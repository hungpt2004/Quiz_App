import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_favorite/favorite_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_favorite/favorite_bloc_state.dart';
import 'package:flutter_quiz_app/bloc/bloc_own_quiz/ownquiz_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_own_quiz/ownquiz_bloc_state.dart';
import 'package:flutter_quiz_app/components/box/box_height.dart';
import 'package:flutter_quiz_app/components/box/box_width.dart';
import 'package:flutter_quiz_app/components/button/button_icon.dart';
import 'package:flutter_quiz_app/components/snackbar/not_yet_noti.dart';
import 'package:flutter_quiz_app/components/snackbar/scaffold_snackbar_msg.dart';
import 'package:flutter_quiz_app/service/shared_preferences/singleton_user_manage.dart';
import 'package:flutter_quiz_app/sql/sql_helper.dart';
import 'package:flutter_quiz_app/theme/color.dart';
import 'package:flutter_quiz_app/theme/network_image.dart';
import 'package:flutter_quiz_app/theme/text_style.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import '../../components/button/button_field.dart';
import '../../model/user.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final networkImage = NetworkImageWidget();
  final textStyle = TextStyleCustom();
  final ScrollController _scrollController = ScrollController();
  bool _isShowButtonTop = false;
  User? user = UserManager().currentUser;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  //Lang nghe user scroll
  void _scrollListener() {
    if (_scrollController.offset > 200 && !_isShowButtonTop) {
      setState(() {
        _isShowButtonTop = true;
      });
    } else if (_scrollController.offset <= 200 && _isShowButtonTop) {
      setState(() {
        _isShowButtonTop = false;
      });
    }
  }

  void _scrollTop() {
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 200), curve: Curves.fastOutSlowIn);
  }

  void showLeaderBoard() {
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Text(
                'Leaderboard of Ranks',
                style:
                    textStyle.subTitleTextStyle(FontWeight.w600, Colors.black),
              ),
              const BoxWidth(w: 5),
              Lottie.asset('assets/animation/top.json', width: 40, height: 40)
            ],
          ),
          elevation: 15,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          content: FutureBuilder<List<Map<String, dynamic>>>(
            future: DBHelper.instance
                .getAllUserByDesc(), // Gọi phương thức lấy dữ liệu
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No users found.');
              } else {
                final users = snapshot.data!;
                return Stack(
                  children: [
                    SizedBox(
                      width: double.maxFinite,
                      height: 300,
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return _cardUser(user);
                        },
                      ),
                    ),
                    if (_isShowButtonTop)
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: FloatingActionButton(
                          onPressed: _scrollTop,
                          mini: true,
                          child: const Icon(Icons.arrow_upward),
                        ),
                      ),
                  ],
                );
              }
            },
          ),
        ),
      );
    }
  }

  _showModalSheetDelete(Map<String, dynamic> quiz) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Confirm Delete',
          textAlign: TextAlign.center,
          style: textStyle.subTitleTextStyle(FontWeight.w700, Colors.black),
        ),
        content: Text(
          'Are you sure to delete Quiz ${quiz['id']}',
          textAlign: TextAlign.center,
          style: textStyle.contentTextStyle(FontWeight.w500, Colors.black),
        ),
        alignment: Alignment.center,
        elevation: 15,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ButtonField(
                  text: 'Cancel',
                  function: () {
                    Navigator.pop(context);
                  }),
              ButtonField(
                  text: 'Delete',
                  function: () async {
                    await FavoriteBloc.removeFavorite(context, quiz['id'], user!.id!);
                  })
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Load list favorite lan 1');
    OwnQuizBloc.loadingFavorite(context, user!.id!);
    return Scaffold(backgroundColor: fullColor, body: _body());
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            //L E A D E R - B O A R D
            const BoxHeight(h: 50),
            _buttonHeader(),

            //T I T L E
            textStyle.titleRow(textStyle, 'Favorite Quiz'),

            //F A V O R I T E
            _renderFavorite()
          ],
        ),
      ),
    );
  }

  Widget _buttonHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ButtonIcon(
            text: 'Leaderboard',
            icon: Icons.leaderboard,
            function: () {
              showLeaderBoard();
            })
      ],
    );
  }

  Widget _cardUser(Map<String, dynamic> user) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: const BorderSide(color: primaryColor, width: 1)),
      color: fullColor,
      child: ListTile(
          leading: SizedBox(
            width: 40,
            height: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: user['url'].toString().startsWith('/data/')
                  ? Image.file(
                File(user['url']),
                fit: BoxFit.cover,)
                  : networkImage.networkImage(user['url']),
            ),
          ),
          title: Text(
            user['name'] ?? 'Unknown',
            style: textStyle.superSmallTextStyle(FontWeight.w600, Colors.black),
          ), // Tên user
          subtitle: Text(
            'Points: ${user['total_score'] ?? 0}',
            style: textStyle.superSmallTextStyle(FontWeight.w500, Colors.black),
          ), // Điểm
          trailing: IconButton(onPressed: (){}, icon: Icon(Icons.person,size: 30,)),
          ),
    );
  }

  Widget _renderFavorite() {
    return BlocBuilder<OwnQuizBloc, OwnQuizState>(
      builder: (context, state) {
        if (state is OwnQuizLoadingFavorite) {
          final favorites = state.favorites;
          final quizzes = state.quizzes;
          return BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, state) {
              //load own favorite lan 2
              print('Load list favorite lan 2');
              OwnQuizBloc.loadingFavorite(context, user!.id!);
              return BlocListener<FavoriteBloc, FavoriteState>(
                child: quizzes.isNotEmpty ? _listOwnFavorite(quizzes) : NotYetNoti(label: 'Favorite',image: 'assets/svg/heart_click.svg',),
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
                    Future.delayed(const Duration(milliseconds: 80),(){Navigator.pop(context);});
                  }
                },
              );
            },
          );
        }
        return Container(
          child: const Text('No have any favorites! Please add'),
        );
      },
    );
  }

  Widget _listOwnFavorite(List<dynamic> quizzes) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0),
      itemCount: quizzes.length,
      //favorite = [id, quiz_id, user_id]
      itemBuilder: (context, index) {
        return _cardQuiz(quizzes[index], networkImage, textStyle);
      },
    );
  }




  Widget _cardQuiz(Map<String, dynamic> quiz, NetworkImageWidget networkImage,
      TextStyleCustom textStyle) {
    return Card(
      color: fullColor,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListTile(
          leading: SizedBox(
            width: 75,
            height: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: !quiz['url'].toString().startsWith('/data/')
                  ? networkImage.networkImage(quiz['url'])
                  : Image.file(
                      File(quiz['url']),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                quiz['title'],
                style:
                    textStyle.contentTextStyle(FontWeight.w500, Colors.black),
              ),
              Text(
                textStyle
                    .formatDateFromText(DateTime.parse(quiz['created_at'])),
                style: textStyle.superSmallTextStyle(
                    FontWeight.w400, Colors.black),
              )
            ],
          ),
          trailing: SizedBox(
            width: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                    onTap: () {},
                    child: SvgPicture.asset(
                      'assets/svg/pen.svg',
                      width: 20,
                      height: 20,
                    )),
                GestureDetector(
                    onTap: () async {
                      _showModalSheetDelete(quiz);
                    },
                    child: SvgPicture.asset(
                      'assets/svg/trash.svg',
                      width: 20,
                      height: 20,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
