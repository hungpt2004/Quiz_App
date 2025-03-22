import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_cart/cart_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_cart/cart_bloc_state.dart';
import 'package:flutter_quiz_app/theme/color.dart';
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
        bottomNavigationBar: _bottomAppBar());
  }

  //Button
  Widget _button(String urlToggle, String urlDefault, int index) {
    return Column(
      children: [
        MaterialButton(
          animationDuration: Duration(milliseconds: 300),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onPressed: () {
            _toggleIndex(index);
          },
          child: SvgPicture.asset(
            _currentIndex == index
                ? "assets/svg/$urlToggle"
                : "assets/svg/$urlDefault",
            width: 18, // Adjust for larger screens
            height: 18,
          ),
        ),
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
      height: 90,
      color: fullColor,
      shape: const CircularNotchedRectangle(),
      notchMargin: BorderSide.strokeAlignCenter, // Adjusted notch margin for better alignment
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribute buttons evenly
          children: [
            Expanded(flex: 1, child: _button('home_click.svg', 'home.svg', 0),),
            Expanded(flex: 1, child:  _button('quiz_click.svg', 'quiz.svg', 1),),
            Expanded(flex: 1, child:  _button('hear_click.svg', 'hear.svg', 3),),
            Expanded(flex: 1, child:  _button('account_click.svg', 'account.svg', 4),)
          ],
        ),
      ),
    );
  }


  Widget _bodyRenderCenterButton(int length){
    return SizedBox(
        child: Stack(
          children: [
            FloatingActionButton(
                onPressed: () {
                  _toggleIndex(2);
                },
                backgroundColor: primaryColor,
                elevation: 5,
                hoverElevation: 25,
                mini: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), side: BorderSide.none),
                child: SvgPicture.asset(
                  'assets/svg/shopping.svg',
                  width: MediaQuery.of(context).size.width * 0.07,
                  height: MediaQuery.of(context).size.width * 0.07,
                )
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.05,
                height: MediaQuery.of(context).size.width * 0.05,
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
