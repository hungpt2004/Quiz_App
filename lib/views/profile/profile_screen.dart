import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_auth/auth_bloc.dart';
import 'package:flutter_quiz_app/bloc/bloc_auth/auth_bloc_state.dart';
import 'package:flutter_quiz_app/components/appbar/appbar_field.dart';
import 'package:flutter_quiz_app/components/box/box_height.dart';
import 'package:flutter_quiz_app/components/box/box_width.dart';
import 'package:flutter_quiz_app/components/button/button_field.dart';
import 'package:flutter_quiz_app/components/button/button_icon.dart';
import 'package:flutter_quiz_app/components/input_field/input_select.dart';
import 'package:flutter_quiz_app/components/input_field/input_text_field.dart';
import 'package:flutter_quiz_app/components/input_field/label_text.dart';
import 'package:flutter_quiz_app/components/snackbar/scaffold_snackbar_msg.dart';
import 'package:flutter_quiz_app/constant/label_str.dart';
import 'package:flutter_quiz_app/service/shared_preferences/local_data_save.dart';
import 'package:flutter_quiz_app/service/shared_preferences/singleton_user_manage.dart';
import 'package:flutter_quiz_app/theme/color.dart';
import 'package:flutter_quiz_app/theme/responsive_size.dart';
import 'package:flutter_quiz_app/theme/text_style.dart';
import 'package:flutter_quiz_app/views/profile/change_password/change_password_profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';

import '../../model/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? currentUser;
  final textStyle = TextStyleCustom();
  final _newNameController = TextEditingController();
  final _newDobController = TextEditingController();
  String? url;
  XFile? imageFile;
  final picker = ImagePicker();
  DateTime? dob;

  // P I C K -- I M A G E
  Future<void> pickImage(
      bool isCamera, User currentUser, BuildContext context) async {
    try {
      final imageFile = await picker.pickImage(
          source: isCamera ? ImageSource.camera : ImageSource.gallery,
          imageQuality: 100);
      if (imageFile != null) {
        setState(() {
          url = imageFile.path;
        });
        await AuthBloc.updateAvatar(context, url!, currentUser.id!);
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: SelectableText(e.toString()),
              ));
    }
  }

  // P I C K -- D A T E
  Future<DateTime?> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(1990),
      lastDate: DateTime(2101),
    );
    return pickedDate;
  }

  // S H O W -- M O D A L
  _showModalUpload(BuildContext context, User user) {
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
            width: MediaQuery.of(context).size.width * 0.4,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.white),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ButtonIcon(
                    text: 'Camera',
                    icon: Icons.camera_alt_outlined,
                    function: () {
                      pickImage(true, user, context);
                    }),
                ButtonIcon(
                    text: 'Gallery',
                    icon: Icons.image,
                    function: () {
                      pickImage(false, user, context);
                    })
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

  // S H O W -- N A M E
  _showModalUpdateName(User user, BuildContext context) {
    showGeneralDialog(
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
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const BoxHeight(h: 10),
                Material(
                    color: fullColor,
                    child: Text(
                      'Change Name',
                      textAlign: TextAlign.center,
                      style: textStyle.questionTextStyle(
                          FontWeight.w500, Colors.black),
                    )),
                const BoxHeight(h: 5),
                Material(
                    color: fullColor,
                    child: Text(
                      'Enter the box below to change your name',
                      textAlign: TextAlign.center,
                      style: textStyle.contentTextStyle(
                          FontWeight.w500, Colors.grey),
                    )),
                const BoxHeight(h: 5),
                Material(
                  color: fullColor,
                  child: Container(
                    width: StyleSize(context).screenWidth * 0.8,
                    height: 100,
                    child: Center(
                      child: InputTextField(
                          controller: _newNameController,
                          textInputAction: TextInputAction.done,
                          hint: 'Enter New Name',
                          paddingRate: 10),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: ButtonField(
                              text: 'Cancel',
                              function: () => Navigator.pop(context))),
                      const BoxWidth(w: 5),
                      Expanded(
                          child: ButtonField(
                              text: 'Save',
                              function: () {
                                AuthBloc.updateName(
                                    context, _newNameController.text, user.id!);
                              }))
                    ],
                  ),
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
  void dispose() {
    _newNameController.dispose();
    _newDobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom.appbarNoBackBtn(context, 'PROFILE', textStyle),
      backgroundColor: fullColor,
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is LoginSuccess || state is UpdateAvatarSuccess) {
            currentUser = state is LoginSuccess
                ? state.user
                : (state as UpdateAvatarSuccess).user;
            return _body(currentUser!, context);
          } else if (state is UpdateNameSuccess) {
            currentUser = state.user;
            return _body(currentUser!, context);
          } else if (state is UpdateDOBSuccess) {
            currentUser = state.user;
            return _body(currentUser!, context);
          } else if (state is ResetPasswordSuccess) {
            currentUser = state.user;
            return _body(currentUser!, context);
          }
          return Center(
            child: ButtonField(text: 'Need to Login/Register', function: () {}),
          );
        },
      ),
    );
  }

  Widget _body(User currentUser, BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UpdateAvatarSuccess) {
          ShowScaffoldMessenger.showScaffoldMessengerSuccessfully(
              context, state.text, textStyle);
          Future.delayed(const Duration(milliseconds: 100), () {
            Navigator.pop(context);
          });
        } else if (state is UpdateNameSuccess) {
          ShowScaffoldMessenger.showScaffoldMessengerSuccessfully(
              context, state.text, textStyle);
          Future.delayed(const Duration(milliseconds: 100), () {
            Navigator.pop(context);
          });
        } else if (state is UpdateDOBSuccess) {
          ShowScaffoldMessenger.showScaffoldMessengerSuccessfully(
              context, state.text, textStyle);
        } else if (state is UpdateDOBFailure) {
          ShowScaffoldMessenger.showScaffoldMessengerUnsuccessfully(
              context, state.text, textStyle);
        } else if (state is ResetPasswordSuccess) {
          ShowScaffoldMessenger.showScaffoldMessengerSuccessfully(
              context, state.success, textStyle);
          Future.delayed(const Duration(milliseconds: 100), () {
            Navigator.pop(context);
          });
        }
      },
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _avatar(context),
            const BoxHeight(h: 10),
            const BoxHeight(h: 2),
            const LabelText(text: LABEL_FULLNAME),
            InputSelectField(
              textInputAction: TextInputAction.next,
              hint: currentUser.name,
              paddingRate: 25,
              function: () => _showModalUpdateName(currentUser, context),
            ),
            const BoxHeight(h: 10),
            const BoxHeight(h: 2),
            const LabelText(text: LABEL_EMAIL),
            InputSelectField(
                textInputAction: TextInputAction.next,
                hint: currentUser.email,
                paddingRate: 25),
            const BoxHeight(h: 10),
            const LabelText(text: LABEL_DOB),
            const BoxHeight(h: 2),
            InputSelectField(
              textInputAction: TextInputAction.next,
              hint: textStyle.formatDateFromText(currentUser.dob!),
              paddingRate: 25,
              function: () async {
                await _selectDate(context).then((selectedDate) {
                  if (selectedDate != null) {
                    setState(() {
                      dob = selectedDate; // Gán giá trị cho taskDeadline
                      _newDobController.text =
                          textStyle.formatDateFromText(selectedDate);
                    });
                  }
                });
                await AuthBloc.updateDob(
                    context, dob!.toIso8601String(), currentUser.id!);
              },
            ),
            const BoxHeight(h: 10),
            const LabelText(text: LABEL_PASSWORD),
            const BoxHeight(h: 2),
            InputSelectField(
              textInputAction: TextInputAction.next,
              hint: 'Change password',
              paddingRate: 25,
              function: () => Navigator.pushNamed(context, '/passwordProfile'),
            ),
            const BoxHeight(h: 10),
            const LabelText(text: LABEL_PHONE),
            const BoxHeight(h: 2),
            InputSelectField(
                textInputAction: TextInputAction.next,
                hint: currentUser.phone!,
                paddingRate: 25),
            const BoxHeight(h: 20),
            Center(
              child: Container(
                width: 130,
                height: 40,
                child: ButtonIcon(text: 'Logout', icon: Icons.logout, function: () async {
                  await UserManager().logout();
                  Navigator.pushReplacementNamed(context, '/login');
                }),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _avatar(
    BuildContext context,
  ) {
    return Center(
      child: Container(
          width: StyleSize(context).widthPercent(150),
          height: StyleSize(context).heightPercent(150),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              image: DecorationImage(
                  image: !currentUser!.url!.toString().startsWith('/data/')
                      ? CachedNetworkImageProvider(currentUser!.url!)
                      : FileImage(File(currentUser!.url!)),
                  fit: BoxFit.cover)),
          child: _camera(context, currentUser!)),
    );
  }

  Widget _camera(BuildContext context, User currentUser) {
    return Stack(
      children: [
        Positioned(
            bottom: 0,
            right: 0,
            child: IconButton(
                style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(primaryColor),
                    padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
                    elevation: WidgetStatePropertyAll(10)),
                onPressed: () {
                  _showModalUpload(context, currentUser);
                },
                icon: const Icon(
                  Icons.add_a_photo_outlined,
                  color: Colors.white,
                  size: 20,
                )))
      ],
    );
  }
}
