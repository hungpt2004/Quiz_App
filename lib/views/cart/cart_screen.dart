import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_cart/cart_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_cart/cart_bloc_state.dart';
import 'package:flutter_quiz_app/components/appbar/appbar_field.dart';
import 'package:flutter_quiz_app/components/box/box_width.dart';
import 'package:flutter_quiz_app/components/button/button_field.dart';
import 'package:flutter_quiz_app/components/button/button_icon.dart';
import 'package:flutter_quiz_app/components/snackbar/not_yet_noti.dart';
import 'package:flutter_quiz_app/components/snackbar/scaffold_snackbar_msg.dart';
import 'package:flutter_quiz_app/service/payment/payment_service.dart';
import 'package:flutter_quiz_app/service/shared_preferences/singleton_user_manage.dart';
import 'package:flutter_quiz_app/sql/sql_helper.dart';
import 'package:flutter_quiz_app/theme/color.dart';
import 'package:flutter_quiz_app/theme/network_image.dart';
import 'package:flutter_quiz_app/theme/responsive_size.dart';
import 'package:flutter_quiz_app/theme/text_style.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../components/box/box_height.dart';
import '../../model/cart.dart';
import '../../model/discount.dart';
import '../../model/quiz.dart';
import '../../model/user.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final textStyle = TextStyleCustom();
  final networkImage = NetworkImageWidget();
  User? user = UserManager().currentUser;

  @override
  void initState() {
    CartBloc.loadingCart(context, user!.id!);
    super.initState();
  }

  showVoucherSheet(Discount discount){
    showModalBottomSheet(context: context, builder: (context) {
      return Container(
        width: StyleSize(context).screenWidth,
        height: StyleSize(context).screenHeight * 0.4,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 100,
                  height: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey.shade700
                  ),
                ),
              ),
              const BoxHeight(h: 20),
              Card(
                elevation: 10,

                color: fullColor,
                child: ListTile(
                  leading: Icon(Icons.discount,color: Colors.orange.shade700,),
                  title: Text(discount.name,style: textStyle.contentTextStyle(FontWeight.w500, Colors.black)),
                  trailing: ButtonField(text: 'Apply', function: (){
                    CartBloc.applyVoucher(context, user!.id!, user!.rankId!);
                  }),
                ),
              ),
            ],
          ),
        )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom.appbarNoBackBtn(context, 'SHOPPING CART', textStyle),
      backgroundColor: fullColor,
      body: BlocConsumer<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartAddSuccess) {
            return _body(cartItems: state.cartItems, sum: state.sum);
          } else if (state is CartAddFailure) {
            return _body(cartItems: state.cartItems, sum: state.sum);
          } else if (state is CartRemoveSuccess) {
            return _body(cartItems: state.cartItems, sum: state.sum);
          } else if (state is CartRemoveFailure) {
            return _body(cartItems: state.cartItems, sum: state.sum);
          } else if (state is LoadingSuccess) {
            return _body(cartItems: state.cartItems, sum: state.sum);
          } else if (state is CartClearAll) {
            return const Center(child: NotYetNoti(label: 'Cart', image: 'assets/svg/cart.svg'));
          } else if (state is CartClearAllFailure) {
            return _body(cartItems: state.cartItems, sum: state.sum);
          } else if (state is CartApplyVoucherSuccess) {
            final oldSum = state.oldSum;
            return _body(cartItems: state.cartItems, sum: state.sum,oldSum: oldSum);
          } else if (state is CartApplyVoucherFailure) {
            return _body(cartItems: state.cartItems, sum: state.sum);
          } else if (state is Initial) {
            return const Center(child: NotYetNoti(label: 'Cart', image: 'assets/svg/cart.svg'));
          }
          print(state);
          return const Center(child: NotYetNoti(label: 'Cart', image: 'assets/svg/cart.svg'));
        },
        listener: (context, state) {
          if (state is CartAddSuccess) {
            ShowScaffoldMessenger.showScaffoldMessengerSuccessfully(
                context, 'Add successfully', textStyle);
          } else if (state is CartAddFailure) {
            ShowScaffoldMessenger.showScaffoldMessengerUnsuccessfully(
                context, 'Add failure', textStyle);
          }
        },
      ),
    );
  }

  // List<Map<String, dynamic>> cartItems, double sum
  Widget _body({required List<Map<String, dynamic>> cartItems, required double sum, double? oldSum}) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _header(user!),
              Card(
                elevation: 4,
                color: fullColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      _host(),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final cartIndex = cartItems[index];
                          return FutureBuilder(
                            future: DBHelper.instance
                                .getQuizById(cartIndex['quiz_id']),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return const Text('Error');
                              } else if (!snapshot.hasData) {
                                return const Text('Error');
                              }
                              final quizIndex = snapshot.data!;
                              return _cart(quizIndex, cartIndex['cart_id'], sum);
                            },
                          );
                        },
                      ),
                      const BoxHeight(h: 10),
                      Container(
                        width: double.infinity,
                        height: 1,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        color: Colors.grey,
                      ),
                      const BoxHeight(h: 10),
                      _voucher(),
                      _totalProduct(cartItems.length, sum),
                    ],
                  ),
                ),
              ),
              _payMethod(),
              _payDetails(sum: sum, oldSum: oldSum),
              _total(sum),
            ],
          ),
        ));
  }

  Widget _payMethod() {
    return Card(
      elevation: 4,
      color: fullColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    'Payment Method',
                    style: textStyle.contentTextStyle(
                        FontWeight.w600, Colors.black),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      const Icon(Icons.paypal),
                      Text(
                        'Online Payment',
                        style: textStyle.superSmallTextStyle(
                            FontWeight.w500, Colors.black),
                      )
                    ],
                  ),
                ),
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 20,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _payDetails({required double sum, double? oldSum}) {
    return Card(
      elevation: 4,
      color: fullColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    'Payment Details',
                    style: textStyle.contentTextStyle(
                        FontWeight.w600, Colors.black),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Bill',
                    style: textStyle.superSmallTextStyle(
                        FontWeight.w500, Colors.black),
                  ),
                  Text(
                    '$sum\$',
                    style: textStyle.superSmallTextStyle(
                        FontWeight.w500, Colors.black),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Discount Value',
                    style: textStyle.superSmallTextStyle(
                        FontWeight.w500, Colors.black),
                  ),
                  Text(
                    oldSum != null ? '-${oldSum-sum}\$' : '0',
                    style: textStyle.superSmallTextStyle(
                        FontWeight.w500, Colors.red),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Final Total',
                    style: textStyle.superSmallTextStyle(
                        FontWeight.w500, Colors.black),
                  ),
                  Text(
                    '$sum\$',
                    style: textStyle.superSmallTextStyle(
                        FontWeight.w500, Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _host() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(3)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  'Mall',
                  style: textStyle.superSmallTextStyle(
                      FontWeight.w500, Colors.white),
                ),
              ),
            ),
          ),
          const BoxWidth(w: 5),
          Text(
            'Quizzliz',
            style: textStyle.contentTextStyle(FontWeight.w500, Colors.black),
          )
        ],
      ),
    );
  }

  Widget _voucher() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: DBHelper.instance.getVoucherByRankId(user!.rankId!),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          } else if (!snapshot.hasData) {
            return const Text('No have data');
          } else if (snapshot.hasError) {
            return const Text('Have an error');
          }
          final discount = snapshot.data!;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rank\'s Voucher',
                style: textStyle.contentTextStyle(FontWeight.w500, Colors.black),
              ),
              ButtonField(text: 'Choose voucher', function: () {
                showVoucherSheet(discount);
              })
            ],
          );
        },
      )
    );
  }

  Widget _totalProduct(int length, double sum) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total ($length products)',
            style: textStyle.superSmallTextStyle(FontWeight.w500, Colors.black),
          ),
          Text(
            '$sum\$',
            style: textStyle.superSmallTextStyle(FontWeight.w700, Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _header(User user) {
    return Card(
      elevation: 5,
      color: fullColor,
      child: ListTile(
        leading: const Icon(
          Icons.location_on_sharp,
          size: 20,
          color: Colors.deepOrangeAccent,
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  user.name,
                  style:
                      textStyle.contentTextStyle(FontWeight.w500, Colors.black),
                ),
                const BoxWidth(w: 5),
                Text(
                  '(+84) ${user.phone}',
                  style: textStyle.superSmallTextStyle(
                      FontWeight.w500, Colors.grey),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  user.email,
                  textAlign: TextAlign.start,
                  style: textStyle.superSmallTextStyle(
                      FontWeight.w500, Colors.grey),
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
          size: 15,
        ),
      ),
    );
  }

  Widget _cart(Quiz quiz, int cartId, double sum) {
    return Slidable(
      key: ValueKey(quiz.id), // Khóa duy nhất để nhận dạng Slidable
      endActionPane: ActionPane(
        dragDismissible: true,
        motion: const ScrollMotion(), // Hiệu ứng cuộn
        children: [
          SlidableAction(
            onPressed: (context) async {
              CartBloc.removeFromCart(context, cartId, quiz.id!);
            },
            padding: const EdgeInsets.all(0),
            foregroundColor: primaryColor,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Card(
        color: fullColor,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListTile(
            leading: SizedBox(
              width: 80,
              height: 80,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: !quiz.url.toString().startsWith('/data/')
                    ? networkImage.networkImage(quiz.url)
                    : Image.file(
                        File(quiz.url),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quiz.title,
                  style:
                      textStyle.contentTextStyle(FontWeight.w500, Colors.black),
                ),
                const BoxHeight(h: 4),
                Text(
                  'Price: ${quiz.price}\$/quiz',
                  style: textStyle.superSmallTextStyle(
                      FontWeight.w500, Colors.black),
                ),
                const BoxHeight(h: 5),
                Row(
                  children: [
                    Material(
                      elevation: 4,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      child: const Icon(
                        Icons.remove,
                        size: 20,
                      ),
                    ),
                    const BoxWidth(w: 10),
                    Container(
                      width: 50,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.grey.shade200),
                      child: Center(
                        child: Text('1',
                            style: textStyle.contentTextStyle(
                                FontWeight.w500, Colors.black)),
                      ),
                    ),
                    const BoxWidth(w: 10),
                    Material(
                      elevation: 4,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      child: const Icon(
                        Icons.add,
                        size: 20,
                      ),
                    ),
                  ],
                )
              ],
            ),
            trailing: const Icon(
              Icons.arrow_back_ios_new,
              color: primaryColor,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _total(double sum) {
    return Card(
      color: fullColor,
      elevation: 4,
      child: ListTile(
        title: Text(
          'Total Bill: $sum\$',
          style: textStyle.superSmallTextStyle(FontWeight.w500, Colors.black),
        ),
        trailing: MaterialButton(
          onPressed: () async {
            await StripeService.instance.makePayment(price: sum.toInt(), username: user!.name, role: 2, userId: user!.id!, context: context);
            },
          elevation: 4,
          color: Colors.deepOrange,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Text(
            'Pay',
            style: textStyle.superSmallTextStyle(FontWeight.w500, Colors.white),
          ),
        ),
      ),
    );
  }

}
