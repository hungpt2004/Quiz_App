import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_cart/cart_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_favorite/favorite_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_favorite/favorite_bloc_event.dart';
import 'package:flutter_quiz_app/bloc/bloc_favorite/favorite_bloc_state.dart';
import 'package:flutter_quiz_app/bloc/bloc_quiz/quiz_bloc.dart';
import 'package:flutter_quiz_app/components/box/box_height.dart';
import 'package:flutter_quiz_app/components/box/box_width.dart';
import 'package:flutter_quiz_app/components/snackbar/scaffold_snackbar_msg.dart';
import 'package:flutter_quiz_app/constant/label_str.dart';
import 'package:flutter_quiz_app/model/cart.dart';
import 'package:flutter_quiz_app/model/cart_items.dart';
import 'package:flutter_quiz_app/model/favorite.dart';
import 'package:flutter_quiz_app/service/payment/payment_service.dart';
import 'package:flutter_quiz_app/service/shared_preferences/singleton_user_manage.dart';
import 'package:flutter_quiz_app/sql/sql_helper.dart';
import 'package:flutter_quiz_app/theme/color.dart';
import 'package:flutter_quiz_app/theme/network_image.dart';
import 'package:flutter_quiz_app/theme/responsive_size.dart';
import 'package:flutter_quiz_app/theme/text_style.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../components/button/button_icon.dart';
import '../../../../components/exception/cart_exception.dart';
import '../../../../model/user.dart';

class CardQuizWidget extends StatefulWidget {
  CardQuizWidget({super.key, this.subjectId});

  int? subjectId;

  @override
  State<CardQuizWidget> createState() => _CardQuizWidgetState();
}

class _CardQuizWidgetState extends State<CardQuizWidget> {
  final networkImage = NetworkImageWidget();
  final textStyle = TextStyleCustom();
  User? userCurrent = UserManager().currentUser;
  bool? isFavorite;
  String statusText1 = 'Let\'s play';
  String statusText2 = 'Need Pay';

  //confirm alert
  _showModalRestart(BuildContext context, int quizId, int userId) {
    showGeneralDialog(
      //Nhan ra ngoai de dong
      barrierDismissible: true,
      barrierLabel: 'DIALOG',
      context: context,
      transitionDuration:
          const Duration(milliseconds: 300), // Thời gian hiệu ứng
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.white),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BoxHeight(h: 10),
                Material(
                  color: fullColor,
                  child: Text(
                    ' You already do this quiz !',
                    textAlign: TextAlign.center,
                    style: textStyle.contentTextStyle(
                        FontWeight.w500, Colors.black),
                  ),
                ),
                const BoxHeight(h: 5),
                Material(
                  color: fullColor,
                  child: Text(
                    '* Your result will be reset when you do this again !',
                    textAlign: TextAlign.start,
                    style: textStyle.superSmallTextStyle(
                        FontWeight.w500, primaryColor),
                  ),
                ),
                const BoxHeight(h: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ButtonIcon(
                        text: 'Cancel',
                        icon: Icons.cancel,
                        function: () {
                          Navigator.pop(context);
                        }),
                    ButtonIcon(
                        text: 'Restart',
                        icon: Icons.refresh_sharp,
                        function: () async {
                          await QuizBloc.enjoyQuiz(context, quizId, userId);
                          Future.delayed(const Duration(milliseconds: 100), () {
                            Navigator.pushNamed(context, '/doQuiz',
                                arguments: quizId);
                          });
                        })
                  ],
                )
              ],
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.fastEaseInToSlowEaseOut,
          ),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoriteBloc, FavoriteState>(
      child: FutureBuilder(
        future: widget.subjectId != null
            ? DBHelper.instance.getQuizBySubjectId(widget.subjectId!)
            : DBHelper.instance.getAllQuiz(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(
              color: primaryColor,
            );
          } else if (!snapshot.hasData || snapshot.hasError) {
            return const Text('Error in card quiz');
          } else {
            final quizList = snapshot.data;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: CROSS_COUNT,
                  mainAxisExtent: HEIGHT,
                  crossAxisSpacing: CROSS_SPACING,
                  mainAxisSpacing: MAIN_SPACING),
              itemCount: quizList!.length,
              itemBuilder: (context, index) {
                final quizIndex = quizList[index];
                return GestureDetector(
                  //Xu ly khi user nhan vao card => detail
                  onTap: () {},
                  //card cua tung quiz
                  child: Card(
                    elevation: 3,
                    color: fullColor,
                    child: Column(
                      children: [
                        Container(
                            width: double.infinity,
                            height: StyleSize(context).heightPercent(100),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                image: DecorationImage(
                                    image: !quizIndex['url']
                                            .toString()
                                            .startsWith('/data/')
                                        ? CachedNetworkImageProvider(
                                            quizIndex['url'])
                                        : FileImage(File(quizIndex['url'])),
                                    fit: BoxFit.cover)),
                            child: Stack(
                              children: [
                                FutureBuilder(
                                  future: precacheImage(
                                      CachedNetworkImageProvider(
                                          quizIndex['url']),
                                      context),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return _loadingOverlay(); // Loading state
                                    } else if (snapshot.hasError) {
                                      return _errorOverlay(); // Error state
                                    } else {
                                      return const SizedBox
                                          .shrink(); // Success state, show nothing
                                    }
                                  },
                                ),
                                _overlay(),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (quizIndex['isFavorite'] == 0) {
                                        context.read<FavoriteBloc>().add(
                                            OnPressedAddFavorite(
                                                Favorite(
                                                    userId: userCurrent!.id!,
                                                    quizId: quizIndex['id'],
                                                    createdAt: DateTime.now()),
                                                quizIndex['id'],
                                                userCurrent!.id!));
                                      } else if (quizIndex['isFavorite'] == 1) {
                                        context.read<FavoriteBloc>().add(
                                            OnPressedRemoveFavorite(
                                                quizIndex['id'],
                                                userCurrent!.id!));
                                      }
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey.withOpacity(0.5)),
                                      child: Center(
                                        child: SvgPicture.asset(
                                            'assets/svg/heart.svg'),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  left: 10,
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (quizIndex['price'] == 0) {
                                        ShowScaffoldMessenger
                                            .showScaffoldMessengerUnsuccessfully(
                                                context,
                                                'This course is free',
                                                textStyle);
                                      } else if (quizIndex['price'] > 0) {
                                        Cart cart =
                                            Cart(userId: userCurrent!.id!);
                                        try {
                                          await DBHelper.instance.createCart(
                                              cart, userCurrent!.id!);
                                        } on CartAlreadyExistException catch (e) {
                                          print(e.toString());
                                        }
                                        final currentCart = await DBHelper
                                            .instance
                                            .getCartByUserId(userCurrent!.id!);
                                        CartItem cartItems = CartItem(
                                            cartId: currentCart!.id!,
                                            quizId: quizIndex['id'],
                                            quantity: 1);
                                        CartBloc.addToCart(
                                            context,
                                            currentCart.id!,
                                            cartItems,
                                            userCurrent!.id!);
                                      }
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey.withOpacity(0.5)),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          'assets/svg/shopping.svg',
                                          width: 20,
                                          height: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        const BoxHeight(h: 10),
                        _title(quizIndex),
                        const BoxHeight(h: 8),
                        _information(quizIndex),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      listener: (context, state) {
        if (state is FavoriteLoading) {
          ShowScaffoldMessenger.showScaffoldMessengerLoading(
              context, textStyle);
        } else if (state is FavoriteAddSuccess) {
          ShowScaffoldMessenger.showScaffoldMessengerSuccessfully(
              context, state.text, textStyle);
        } else if (state is FavoriteAddFailure) {
          ShowScaffoldMessenger.showScaffoldMessengerUnsuccessfully(
              context, state.text, textStyle);
        } else if (state is FavoriteRemoveSuccess) {
          ShowScaffoldMessenger.showScaffoldMessengerSuccessfully(
              context, state.text, textStyle);
        }
      },
    );
  }

  Widget _information(Map<String, dynamic> quizIndex) {
    return FutureBuilder<User?>(
      future: DBHelper.instance.getUserById(quizIndex['user_id']),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(
            color: primaryColor,
          );
        } else if (!snapshot.hasData || snapshot.hasError) {
          return const Text('Error in quiz card');
        } else {
          final user = snapshot.data;
          return _rowInformation(user!, quizIndex);
        }
      },
    );
  }

  Widget _overlay() {
    return Positioned.fill(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            color: Colors.black12.withOpacity(0.15),
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10), topLeft: Radius.circular(10))),
      ),
    );
  }

  Widget _loadingOverlay() {
    return const Center(
      child: CircularProgressIndicator(
        color: primaryColor,
      ),
    );
  }

  Widget _errorOverlay() {
    return const Center(
      child: Text(
        'Error loading image',
        style: TextStyle(color: Colors.red, fontSize: 16),
      ),
    );
  }

  Widget _btn(Map<String, dynamic> quizIndex, User user) {
    return SizedBox(
        height: 50,
        child: Center(
          child: MaterialButton(
            onPressed: () async {
              //Check tat ca complete quiz cua user
              final completeList = await DBHelper.instance.getAllCompleteQuizByUserId(user.id!);
              bool check = completeList.any((item) => item['user_id'] == user.id! && item['quiz_id'] == quizIndex['id']);

              //Kiem tra progress neu progress > 0 thi restart update diem moi
              final completeQuiz = await DBHelper.instance.getCompleteQuiz(user.id!, quizIndex['id']);

              if (check && completeQuiz!.progress > 0) {
                //Quiz da ton tai
                _showModalRestart(context, quizIndex['id'], user.id!);

              } else if ((!check && quizIndex['user_id'] == user.id!) && quizIndex['price'] > 0) {
                //Quiz cua user lam chu
                await QuizBloc.enjoyQuiz(context, quizIndex['id'], user.id!);
                // await DBHelper.instance.updateStatusUnlock(quizIndex['id'],user.id!);
                Future.delayed(const Duration(milliseconds: 100), () {
                  Navigator.pushNamed(context, '/doQuiz',
                      arguments: quizIndex['id']);
                });

              } else if (!check && quizIndex['price'] > 0) {
                //Quiz can duoc thanh toan
                await StripeService.instance.makePayment(price: quizIndex['price'], username: user.name, role: 1, userId: user.id!, quizId: quizIndex['id'], context: context);

              } else {
                //Quiz chua duoc lam
                await QuizBloc.enjoyQuiz(context, quizIndex['id'], user.id!);
                // await DBHelper.instance.updateStatusUnlock(quizIndex['id'],user.id!);
                Future.delayed(const Duration(milliseconds: 100), () {
                  Navigator.pushNamed(context, '/doQuiz',
                      arguments: quizIndex['id']);
                });
              }

            },
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: primaryColor,
            child: Text(
              statusText1,
              style: textStyle.contentTextStyle(FontWeight.w500, Colors.white),
            ),
          ),
        ));
  }

  Widget _rowInformation(User user, Map<String, dynamic> quizIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_avatar(user), _price(quizIndex)],
          ),
          _btn(quizIndex, userCurrent!)
        ],
      ),
    );
  }

  Widget _avatar(User user) {
    return Row(
      children: [
        SizedBox(
            width: StyleSize(context).widthPercent(20),
            height: StyleSize(context).heightPercent(20),
            child: Stack(
              children: [
                Container(
                    width: StyleSize(context).widthPercent(150),
                    height: StyleSize(context).heightPercent(150),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                            image: !user.url!.toString().startsWith('/data/')
                                ? CachedNetworkImageProvider(user.url!)
                                : FileImage(File(user.url!)),
                            fit: BoxFit.cover))),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.green,
                    ),
                    width: 4,
                    height: 4,
                  ),
                )
              ],
            )),
        const BoxWidth(w: 3),
        Text(
          user.name,
          style: textStyle.smallTextStyle(FontWeight.w500, Colors.black),
        )
      ],
    );
  }

  Widget _price(Map<String, dynamic> quizIndex) {
    return Text(
      quizIndex['price'] == 0 ? '0\$' : '${quizIndex['price']}\$',
      style: textStyle.superSmallTextStyle(FontWeight.bold, Colors.black),
    );
  }

  Widget _title(Map<String, dynamic> quizIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: [
          Expanded(
              child: Text(
            quizIndex['title'],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: textStyle.contentTextStyle(FontWeight.w600, Colors.black),
          ))
        ],
      ),
    );
  }
}
