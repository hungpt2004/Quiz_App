import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_auth/auth_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_auth/auth_bloc_state.dart';
import 'package:flutter_quiz_app/bloc/bloc_cart/cart_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_cart/cart_bloc_state.dart';
import 'package:flutter_quiz_app/components/box/box_width.dart';
import 'package:flutter_quiz_app/theme/color.dart';
import 'package:flutter_quiz_app/theme/responsive_size.dart';
import 'package:flutter_quiz_app/theme/text_style.dart';
import 'package:flutter_quiz_app/views/cart/cart_screen.dart';
import 'package:flutter_quiz_app/views/exam_quiz/exam_quiz_screen.dart';
import 'package:flutter_quiz_app/views/favorite/favorite_screen.dart';
import 'package:flutter_quiz_app/views/home/home_screen.dart';
import 'package:flutter_quiz_app/views/profile/profile_screen.dart';
import 'package:flutter_svg/svg.dart';

import '../../model/cart.dart';
import '../../model/user.dart';
import '../../service/shared_preferences/singleton_user_manage.dart';
import '../../sql/sql_helper.dart';

class BottomNavbarScreen extends StatefulWidget {
  const BottomNavbarScreen({super.key});

  @override
  State<BottomNavbarScreen> createState() => _BottomNavbarScreenState();
}

class _BottomNavbarScreenState extends State<BottomNavbarScreen> {
  int _currentIndex = 0;
  final textStyle = TextStyleCustom();
  Cart? cart;
  List<Map<String,dynamic>>? cartList;
  User? user=  UserManager().currentUser;

  @override
  void initState() {
    CartBloc.loadingCart(context, user!.id!);
    super.initState();
  }


  _toggleIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  List<Widget> pages = [
    const HomeScreen(),
    const ExamQuizScreen(),
    const CartScreen(),
    const FavoriteScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pages[_currentIndex],
        floatingActionButton: _centerButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        bottomNavigationBar: _bottomAppBar());
  }

  //Button
  Widget _button(String urlToggle, String urlDefault, int index) {
    return Column(
      children: [
        MaterialButton(
            animationDuration: Duration(milliseconds: 300),
            highlightColor: Colors.transparent, // Loại bỏ màu khi giữ nút
            splashColor: Colors.transparent, // Loại bỏ hiệu ứng splash
            onPressed: () {
              _toggleIndex(index);
            },
            child: SvgPicture.asset(
                _currentIndex == index
                    ? "assets/svg/$urlToggle"
                    : "assets/svg/$urlDefault",
                width: 25,
                height: 25)
        ),
        AnimatedContainer(duration: Duration(milliseconds: 300) ,width: 10,height: 2,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: _currentIndex == index ? primaryColor : Colors.grey),)
      ],
    );
  }

  Widget _centerButton() {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if(state is CartAddSuccess){
          final cartList = state.cartItems;
          return _bodyRenderCenterButton(cartList.length);
        } else if (state is CartAddFailure) {
          final cartList = state.cartItems;
          return _bodyRenderCenterButton(cartList.length);
        } else if (state is CartRemoveSuccess) {
          final cartList = state.cartItems;
          return _bodyRenderCenterButton(cartList.length);
        } else if (state is CartRemoveFailure) {
          final cartList = state.cartItems;
          return _bodyRenderCenterButton(cartList.length);
        } else if (state is CartApplyVoucherSuccess) {
          final cartList = state.cartItems;
          return _bodyRenderCenterButton(cartList.length);
        } else if (state is CartApplyVoucherFailure) {
          final cartList = state.cartItems;
          return _bodyRenderCenterButton(cartList.length);
        } else if (state is LoadingSuccess) {
          final cartList = state.cartItems;
          return _bodyRenderCenterButton(cartList.length);
        }
        return _bodyRenderCenterButton(0);
      },
    );
  }

  //Body
  Widget _bottomAppBar() {
    return BottomAppBar(
      height: StyleSize(context).heightPercent(80),
      color: fullColor,
      shape: const CircularNotchedRectangle(),
      notchMargin: BorderSide.strokeAlignOutside,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _button('home_click.svg', 'home.svg', 0),
          _button('quiz_click.svg', 'quiz.svg', 1),
          _button('hear_click.svg', 'hear.svg', 3),
          _button('account_click.svg', 'account.svg', 4),
        ],
      ),
    );
  }

  Widget _bodyRenderCenterButton(int length){
    return SizedBox(
        width: StyleSize(context).widthPercent(60),
        child: Stack(
          children: [
            FloatingActionButton(
                onPressed: () {
                  _toggleIndex(2);
                },
                backgroundColor: primaryColor,
                elevation: 5,
                hoverElevation: 25,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), side: BorderSide.none),
                child: SvgPicture.asset(
                  'assets/svg/shopping.svg',
                  width: 30,
                  height: 30,
                )
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.deepOrangeAccent
                ),
                child: Center(
                  child: Text('$length',style: textStyle.contentTextStyle(FontWeight.w500, Colors.black.withOpacity(0.8)),),
                ),
              ),
            ),
          ],
        )
    );
  }

}
