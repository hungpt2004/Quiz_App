import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_cart/cart_bloc_event.dart';
import 'package:flutter_quiz_app/bloc/bloc_cart/cart_bloc_state.dart';
import 'package:flutter_quiz_app/components/exception/cart_exception.dart';
import 'package:flutter_quiz_app/sql/sql_helper.dart';

import '../../model/cart.dart';
import '../../model/cart_items.dart';
import '../../model/quiz.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(Initial()) {
    on<OnPressedAddToCart>(_onAddToCart);
    on<OnPressedRemoveCart>(_onRemoveCart);
    on<LoadingCart>(_onLoadingCart);
    on<OnPressedClearCart>(_onClearCart);
    on<OnPressedApplyVoucher>(_onApplyVoucher);
  }

  void _onAddToCart(OnPressedAddToCart event, Emitter<CartState> emit) async {
    try {
      //Them san pham vao gio hang
      await DBHelper.instance.addQuizToCart(event.cartItem, event.userId);
      //Lay danh sach hang trong gio
      List<Map<String, dynamic>> cartItems = await DBHelper.instance.getCartItemsByCartId(event.cartId);
      //Tinh tong tien
      //=> quiz[price] * quantity = gia cua moi item
      double sumOfBill = 0;
      for(var q in cartItems){
        Quiz? quiz = await DBHelper.instance.getQuizById(q['quiz_id']);
        sumOfBill += (quiz!.price! * q['quantity']);
      }
      print('Tong bill $sumOfBill');
      emit(CartAddSuccess(cartItems,sumOfBill));
      //Neu add khong duoc
    } catch (e) {
      List<Map<String, dynamic>> cartItems = await DBHelper.instance.getCartItemsByCartId(event.cartId);
      double sumOfBill = 0;
      for(var q in cartItems){
        Quiz? quiz = await DBHelper.instance.getQuizById(q['quiz_id']);
        sumOfBill += (quiz!.price! * q['quantity']);
      }
      emit(CartAddFailure(cartItems, e.toString(),sumOfBill));
    }
  }

  void _onRemoveCart(OnPressedRemoveCart event, Emitter<CartState> emit) async {
    try {
      await DBHelper.instance.removeQuizFromCart(event.quizId, event.cartId);
      List<Map<String, dynamic>> cartItems = await DBHelper.instance.getCartItemsByCartId(event.cartId);
      //Tinh tong tien
      //=> quiz[price] * quantity = gia cua moi item
      double sumOfBill = 0;
      for(var q in cartItems){
        Quiz? quiz = await DBHelper.instance.getQuizById(q['quiz_id']);
        sumOfBill += (quiz!.price! * q['quantity']);
      }
      print('Tong bill $sumOfBill');
      emit(CartRemoveSuccess(cartItems,sumOfBill));
    } catch (e) {
      List<Map<String, dynamic>> cartItems = await DBHelper.instance.getCartItemsByCartId(event.cartId);
      double sumOfBill = 0;
      for(var q in cartItems){
        Quiz? quiz = await DBHelper.instance.getQuizById(q['quiz_id']);
        sumOfBill += (quiz!.price! + q['quantity']);
      }
      emit(CartRemoveFailure(cartItems, e.toString(),sumOfBill));
    }
  }


  void _onApplyVoucher(OnPressedApplyVoucher event, Emitter<CartState> emit) async {
    try {
      final cart = await DBHelper.instance.getCartByUserId(event.userId);
      List<Map<String, dynamic>> cartItems = await DBHelper.instance.getCartItemsByCartId(cart!.id!);
      double sumOfBill = 0;
      for(var q in cartItems){
        Quiz? quiz = await DBHelper.instance.getQuizById(q['quiz_id']);
        sumOfBill += (quiz!.price! * q['quantity']);
      }
      final voucher = await DBHelper.instance.getVoucherByRankId(event.rankId);
      final mainSum = sumOfBill - voucher!.value;
      emit(CartApplyVoucherSuccess(cartItems, (mainSum), sumOfBill));
    } catch (e) {
      final cart = await DBHelper.instance.getCartByUserId(event.userId);
      List<Map<String, dynamic>> cartItems = await DBHelper.instance.getCartItemsByCartId(cart!.id!);
      double sumOfBill = 0;
      for(var q in cartItems){
        Quiz? quiz = await DBHelper.instance.getQuizById(q['quiz_id']);
        sumOfBill += (quiz!.price! * q['quantity']);
      }
      emit(CartApplyVoucherFailure(cartItems, e.toString(),sumOfBill));
    }
  }


  void _onLoadingCart(LoadingCart event, Emitter<CartState> emit) async {
    final cart = await DBHelper.instance.getCartByUserId(event.userId);
    final cartList = await DBHelper.instance.getCartItemsByCartId(cart!.id!);
    List<Map<String, dynamic>> cartItems = await DBHelper.instance.getCartItemsByCartId(cart.id!);
    double sumOfBill = 0;
    for(var q in cartItems){
      Quiz? quiz = await DBHelper.instance.getQuizById(q['quiz_id']);
      sumOfBill += (quiz!.price! * q['quantity']);
    }
    emit(LoadingSuccess(cartList,sumOfBill));
  }


  void _onClearCart(OnPressedClearCart event, Emitter<CartState> emit) async {
    try {
      final cart = await DBHelper.instance.getCartByUserId(event.userId);
      List<Map<String, dynamic>> cartItems = await DBHelper.instance.getCartItemsByCartId(cart!.id!);
      for(var c in cartItems){
        await DBHelper.instance.removeQuizFromCart(c['quiz_id'], cart.id!);
      }
      emit(CartClearAll(cartItems, 0));
    } catch (e) {
      final cart = await DBHelper.instance.getCartByUserId(event.userId);
      List<Map<String, dynamic>> cartItems = await DBHelper.instance.getCartItemsByCartId(cart!.id!);
      double sumOfBill = 0;
      for(var q in cartItems){
        Quiz? quiz = await DBHelper.instance.getQuizById(q['quiz_id']);
        sumOfBill += (quiz!.price! + q['quantity']);
      }
      emit(CartClearAllFailure(cartItems, e.toString(), sumOfBill));
    }
  }

  static Future<void> addToCart(BuildContext context,int carId,  CartItem cartItems, int userId) async {
    context.read<CartBloc>().add(OnPressedAddToCart(carId, userId, cartItems));
  }

  static Future<void> removeFromCart(BuildContext context,int cartId, int quizId) async {
    context.read<CartBloc>().add(OnPressedRemoveCart(cartId, quizId));
  }

  static Future<void> loadingCart(BuildContext context,int userId) async {
    context.read<CartBloc>().add(LoadingCart(userId));
  }

  static Future<void> clearCart(BuildContext context,int userId) async {
    context.read<CartBloc>().add(OnPressedClearCart(userId));
  }

  static Future<void> applyVoucher(BuildContext context, int userId, int rankId) async {
    context.read<CartBloc>().add(OnPressedApplyVoucher(rankId, userId));
  }

}
