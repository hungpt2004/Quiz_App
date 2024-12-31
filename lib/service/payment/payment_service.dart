
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_quiz_app/components/snackbar/scaffold_snackbar_msg.dart';
import 'package:flutter_quiz_app/model/completed_quiz.dart';
import 'package:flutter_quiz_app/sql/sql_helper.dart';
import 'package:flutter_quiz_app/theme/text_style.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../../bloc/bloc_cart/cart_bloc.dart';
import '../../constant/payment_key.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<void> makePayment({required int price,required String username,required int role,required int userId, int? quizId,required BuildContext context}) async {
    final textStyle = TextStyleCustom();
    try {
      String? paymentIntentClientSecret = await _createPaymentIntent(price, "vnd");
      if (paymentIntentClientSecret == null) return;

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: username,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      if (role == 1) {
        print('ROLE 1');
        await DBHelper.instance.createNewCompleteQuiz(
          CompletedQuiz(
            userId: userId,
            quizId: quizId!,
            completedAt: DateTime.now(),
            paidAt: DateTime.now(),
          ),
          userId,
        );
        await DBHelper.instance.updatePaidAtTime(userId, quizId);
        await DBHelper.instance.updateStatusUnlock(quizId, userId);
        ShowScaffoldMessenger.showScaffoldMessengerSuccessfully(context, 'Buy quiz successfully', textStyle);
      } else if (role == 2) {
        print('ROLE 2');
        final cart = await DBHelper.instance.getCartByUserId(userId);
        final cartItemList = await DBHelper.instance.getCartItemsByCartId(cart!.id!);
        print('SO ITEM TRONG CART: ${cartItemList.length}');
        for (var c in cartItemList) {
          print('QUIZ_ID: ${c['quiz_id']}');
          final quizId = c['quiz_id'];
          if (quizId == null) {
            print('Quiz ID của một item trong cartItemList là null, bỏ qua.');
            continue;
          }
          await DBHelper.instance.createNewCompleteQuiz(
            CompletedQuiz(
              userId: userId,
              quizId: quizId,
              completedAt: DateTime.now(),
              paidAt: DateTime.now(),
            ),
            userId,
          );
          await DBHelper.instance.updatePaidAtTime(userId, quizId);
          await DBHelper.instance.updateStatusUnlock(quizId, quizId);
        }
        Future.delayed(const Duration(milliseconds: 100),() async {await CartBloc.clearCart(context, userId);});
        ShowScaffoldMessenger.showScaffoldMessengerSuccessfully(context, 'Buy quiz successfully', textStyle);
        print('THANH TOÁN THÀNH CÔNG - ROLE 2');
      } else {
        print('THANH TOÁN KHOONG THÀNH CÔNG');
      }
    } catch (e) {
      print('LỖI TRONG QUÁ TRÌNH THANH TOÁN: $e');
    }
  }


  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": _calculateAmount(
          amount,
        ),
        "currency": currency,
      };
      var response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $stripeSecretKey",
            "Content-Type": 'application/x-www-form-urlencoded'
          },
        ),
      );
      if (response.data != null) {
        return response.data["client_secret"];
      }
      return null;
    } catch (e) {
      print(e);
    }
    return null;
  }


  String _calculateAmount(int amount) {
    final calculatedAmount = amount * 100;
    return calculatedAmount.toString();
  }
}
