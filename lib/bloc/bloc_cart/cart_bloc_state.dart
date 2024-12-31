import '../../model/cart.dart';
import '../../model/cart_items.dart';

abstract class CartState {}

class CartAddSuccess extends CartState {
  List<Map<String,dynamic>> cartItems;
  double sum;
  CartAddSuccess(this.cartItems,this.sum);
}

class Initial extends CartState {}

class CartAddFailure extends CartState {
  List<Map<String,dynamic>> cartItems;
  double sum;
  String error;
  CartAddFailure(this.cartItems, this.error, this.sum);
}

class CartApplyVoucherSuccess extends CartState {
  List<Map<String,dynamic>> cartItems;
  double sum;
  double oldSum;
  CartApplyVoucherSuccess(this.cartItems, this.sum, this.oldSum);
}

class CartApplyVoucherFailure extends CartState {
  List<Map<String,dynamic>> cartItems;
  double sum;
  String error;
  CartApplyVoucherFailure(this.cartItems, this.error, this.sum);
}

class CartRemoveSuccess extends CartState {
  List<Map<String,dynamic>> cartItems;
  double sum;
  CartRemoveSuccess(this.cartItems, this.sum);
}

class CartRemoveFailure extends CartState {
  List<Map<String,dynamic>> cartItems;
  double sum;
  String error;
  CartRemoveFailure(this.cartItems, this.error, this.sum);
}

class CartClearAll extends CartState {
  List<Map<String,dynamic>> cartItems;
  double sum;
  CartClearAll(this.cartItems, this.sum);
}

class CartClearAllFailure extends CartState {
  List<Map<String,dynamic>> cartItems;
  String error;
  double sum;
  CartClearAllFailure(this.cartItems,this.error,this.sum);
}

class LoadingSuccess extends CartState {
  List<Map<String, dynamic>> cartItems;
  double sum;
  LoadingSuccess(this.cartItems, this.sum);
}

