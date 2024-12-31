import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_auth/auth_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_auth/auth_bloc_state.dart';
import 'package:flutter_quiz_app/bloc/bloc_category/category_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_category/category_bloc_state.dart';
import 'package:flutter_quiz_app/components/box/box_height.dart';
import 'package:flutter_quiz_app/theme/color.dart';
import 'package:flutter_quiz_app/theme/network_image.dart';
import 'package:flutter_quiz_app/theme/text_style.dart';
import 'package:flutter_quiz_app/views/home/widget/advertisement/banner_ads_widget.dart';
import 'package:flutter_quiz_app/views/home/widget/categories/categories_quiz_widget.dart';
import 'package:flutter_quiz_app/views/home/widget/chatbox/form_chat_box_widget.dart';
import 'package:flutter_quiz_app/views/home/widget/quiz/card_quiz_widget.dart';
import 'package:flutter_svg/svg.dart';
import '../../model/user.dart';
import '../../theme/responsive_size.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? currentUser;
  final ScrollController _scrollController = ScrollController();
  double _buttonBottomPosition = 20.0;


  @override
  void initState() {
    _scrollController.addListener((){
      setState(() {
        _buttonBottomPosition = _scrollController.offset > 50 ? 40 : 20;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void showChatBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: FormChatBoxWidget()
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyleCustom();
    final networkImage = NetworkImageWidget();

    return Scaffold(
      backgroundColor: fullColor,
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is LoginSuccess || state is UpdateAvatarSuccess) {
            currentUser = state is LoginSuccess
                ? state.user
                : (state as UpdateAvatarSuccess).user;
            return _body(currentUser!, networkImage, textStyle);
          } else if (state is UpdateNameSuccess) {
            currentUser = state.user;
            return _body(currentUser!, networkImage, textStyle);
          } else if (state is UpdateDOBSuccess) {
            currentUser = state.user;
            return _body(currentUser!, networkImage, textStyle);
          } else if (state is ResetPasswordSuccess) {
            currentUser = state.user;
            return _body(currentUser!, networkImage, textStyle);
          }
          return const Center(child: Text('Need to Login/Register'));
        },
      ),
    );
  }

  //Card quiz
  Widget _body(User user, NetworkImageWidget networkImage, TextStyleCustom textStyle) {
    return Stack(
      children: [
        CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              floating: false,
              pinned: true, // Make the app bar stick at the top when scrolling
              title: _header(user, networkImage, textStyle),
              centerTitle: true,
              expandedHeight: 150,
              elevation: 10,
              backgroundColor: fullColor,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1.5,
                collapseMode: CollapseMode.parallax,
                stretchModes: const [
                  StretchMode.zoomBackground,
                  StretchMode.fadeTitle
                ],
                background: Image.asset(
                  'assets/svg/background.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    const BoxHeight(h: 20),

                    //C O N T E S T - A D V E R T I S E M E N T
                    const BannerAdsWidget(),
                    const BoxHeight(h: 15),

                    // C A T E G O R I E S - S U B J E C T
                    textStyle.titleRow(textStyle, 'Categories'),
                    const BoxHeight(h: 5),
                    const CategoriesQuizWidget(),
                    const BoxHeight(h: 20),

                    // Q U I Z
                    textStyle.titleRow(textStyle, 'Quizz'),
                    BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, state) {
                        if (state is CategoryStateSuccess) {
                          return CardQuizWidget(subjectId: state.subjectId);
                        }
                        return CardQuizWidget();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          bottom: _buttonBottomPosition,
          right: 10,
          child: FloatingActionButton(
            splashColor: Colors.white.withOpacity(0.5),
            elevation: 10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            backgroundColor: primaryColor,
            onPressed: () {
              //open chat box
              showChatBox(context);
            },
            child: SvgPicture.asset('assets/svg/chat.svg'),
          ),
        )
      ],
    );
  }

  //Header UI with User and Point
  Widget _header(User user, NetworkImageWidget networkImage, TextStyleCustom textStyle) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Container(
            width: StyleSize(context).widthPercent(50),
            height: StyleSize(context).heightPercent(50),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              image: DecorationImage(
                image: !user.url!.toString().startsWith('/data/')
                    ? CachedNetworkImageProvider(user.url!)
                    : FileImage(File(user.url!)),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, ${user.name}',
                style:
                    textStyle.contentTextStyle(FontWeight.w500, Colors.black),
              ),
            ],
          ),
          const Spacer(),
          Container(
            height: 30,
            width: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: secondaryColor,
            ),
            child: Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SvgPicture.asset(
                    'assets/svg/diamond.svg',
                    width: 20,
                    height: 20,
                  ),
                  Text(
                    '${user.totalScore}',
                    style: textStyle.contentTextStyle(
                        FontWeight.w500, Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
