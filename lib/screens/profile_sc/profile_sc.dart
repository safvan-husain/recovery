import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recovery_app/resources/assets_manager.dart';
import 'package:recovery_app/resources/snack_bar.dart';
import 'package:recovery_app/screens/HomePage/cubit/home_cubit.dart';
import 'package:recovery_app/screens/authentication/login.dart';
import 'package:recovery_app/screens/authentication/otp_login.dart';
import 'package:recovery_app/screens/common_widgets/count_down_ui.dart';
import 'package:recovery_app/services/auth_services.dart';

import '../../resources/color_manager.dart';

class ProfileScView extends StatefulWidget {
  const ProfileScView({super.key});

  @override
  State<ProfileScView> createState() => _ProfileScViewState();
}

class _ProfileScViewState extends State<ProfileScView>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  int levelClock = 10; // Set your countdown time here

  final TextEditingController _mobNoController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  FocusNode focusNode = FocusNode();
  String? imageUrl;
  bool isEditting = false;
  bool isPhoneChanged = false;
  bool showOtpScreen = false;
  bool isCountComplete = false;

  void _startCountDown() {
    _controller = AnimationController(
        vsync: this, duration: Duration(seconds: levelClock));
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        log("completed");
        setState(() {
          isCountComplete = true;
        });
      }
    });
  }

  void _restartCountdown() {
    setState(() {
      isCountComplete = false;
    });
    _controller.reset();
    _controller.forward();
  }

  @override
  void initState() {
    _mobNoController.text = context.read<HomeCubit>().state.user!.number;
    _nameController.text = context.read<HomeCubit>().state.user!.agent_name;
    _emailController.text = context.read<HomeCubit>().state.user!.email;
    _addressController.text = context.read<HomeCubit>().state.user!.address;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // leading: const BackButton(),
        centerTitle: true,
        backgroundColor: ColorManager.primary,
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: ColorManager.primary,
          statusBarColor: ColorManager.primary,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
        title: const Text(
          "Profile",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 25),
        ),
        actions: [_popUpOptions()],
        bottom: _profilePictureSection(context),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height / 1.8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: isPhoneChanged ? _enterPinScreen : formAndButtons,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> get _enterPinScreen {
    return [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "OTP verification",
          style: GoogleFonts.poppins(
            color: Colors.blue,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Text(
          "You have changed the mobile number\n to +91 ${_mobNoController.text}",
          style: GoogleFonts.outfit(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xff23202a),
            ),
          ),
          textAlign: TextAlign.center,
        ),
      ),
      const SizedBox(height: 20),
      OtpTextField(
        numberOfFields: 4,
        borderColor: const Color(0xFF512DA8),
        enabledBorderColor: const Color.fromARGB(255, 182, 152, 251),
        //set to true to show as box or false to show as dash
        showFieldAsBox: true,
        //runs when a code is typed in
        onCodeChanged: (String code) {
          //handle validation or checks here
        },
        //runs when every textfield is filled
        onSubmit: (v) {}, // end onSubmit
      ),
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: InkWell(
              onTap: () {
                _restartCountdown();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Resend OTP?',
                    style: TextStyle(
                      color: isCountComplete
                          ? const Color(0xff2c65d8)
                          : Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Countdown(
                    animation: StepTween(
                      begin: levelClock,
                      end: 0,
                    ).animate(_controller),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: InkWell(
              onTap: () {
                setState(() {
                  isPhoneChanged = false;
                  _mobNoController.text =
                      context.read<HomeCubit>().state.user!.number;
                });
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Was a mistake? ',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'Revert the change',
                    style: TextStyle(
                      color: Color(0xff2c65d8),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
    ];
  }

  List<Widget> get formAndButtons => [
        Column(
          children: [
            _buildPhoneInputFieald(
                controller: _mobNoController,
                value: context.read<HomeCubit>().state.user!.number),
            _inputFieald(
              controller: _nameController,
              icon: Icons.mail_outline,
              label: 'Full Name',
              value: context.read<HomeCubit>().state.user!.agent_name,
            ),
            _inputFieald(
              controller: _emailController,
              icon: Icons.mail_outline,
              label: 'Email ID',
              value: context.read<HomeCubit>().state.user!.email,
            ),
            _inputFieald(
              controller: _addressController,
              icon: FontAwesomeIcons.addressCard,
              label: 'Address',
              value: context.read<HomeCubit>().state.user!.address,
            ),
          ],
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: [
        //     // A button with a logout icon and a 3D effect
        //     ElevatedButton.icon(
        //       onPressed: () {
        //         if (isEditting) {
        //           _mobNoController.text =
        //               context.read<HomeCubit>().state.user!.number;
        //           _emailController.text =
        //               context.read<HomeCubit>().state.user!.email;
        //           _addressController.text =
        //               context.read<HomeCubit>().state.user!.address;
        //           setState(() {
        //             isEditting = false;
        //             isPhoneChanged = false;
        //           });
        //         }
        //         print(context.read<HomeCubit>().state.user!.email);
        //         print(context.read<HomeCubit>().state.user!.number);
        //       },
        //       icon: Icon(
        //         isEditting ? Icons.cancel : Icons.logout,
        //         color: Colors.white,
        //         size: 30,
        //       ),
        //       label: Text(
        //         isEditting ? "Cancel" : 'Log Out',
        //         style: GoogleFonts.poppins(
        //           fontWeight: FontWeight.bold,
        //           fontSize: 16,
        //           color: Colors.white,
        //         ),
        //       ),
        //       style: ButtonStyle(
        //         shape: MaterialStateProperty.all(
        //           RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(10),
        //           ),
        //         ),
        //         elevation: MaterialStateProperty.all(10),
        //         backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
        //       ),
        //     ),
        //     const SizedBox(width: 10),
        //     // A button with an edit profile icon and a 3D effect
        //     ElevatedButton.icon(
        //       onPressed: () async {
        //         if (isEditting) {
        //           // phone number changed so need to verify.
        //           if (_mobNoController.text !=
        //               context.read<HomeCubit>().state.user!.number) {
        //             var result = await AuthServices.verifyPhone(
        //               phone: _mobNoController.text,
        //               context: context,
        //               isLogin: false,
        //             );
        //             if (result.$2 != null) {
        //               if (context.mounted) {
        //                 setState(() {
        //                   isPhoneChanged = false;
        //                   _mobNoController.text =
        //                       context.read<HomeCubit>().state.user!.number;
        //                 });
        //                 showSnackbar(
        //                     "Mobile number already exist with other account",
        //                     context,
        //                     Icons.warning);
        //               }
        //             } else {
        //               setState(() {
        //                 isPhoneChanged = true;
        //               });
        //               _startCountDown();
        //               //TODO: update user.
        //             }
        //           } else {
        //             //TODO: update user.
        //           }
        //         } else {
        //           FocusScope.of(context).requestFocus(focusNode);
        //         }
        //         setState(() {
        //           isEditting = !isEditting;
        //         });
        //       },
        //       icon: Icon(
        //         isEditting ? Icons.save : Icons.edit,
        //         color: Colors.white,
        //         size: 30,
        //       ),
        //       label: Text(
        //         isEditting ? "Save Profile" : 'Edit Profile',
        //         style: GoogleFonts.poppins(
        //           fontWeight: FontWeight.bold,
        //           fontSize: 16,
        //           color: Colors.white,
        //         ),
        //       ),
        //       style: ButtonStyle(
        //         shape: MaterialStateProperty.all(
        //           RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(10),
        //           ),
        //         ),
        //         elevation: MaterialStateProperty.all(10),
        //         backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
        //       ),
        //     ),
        //   ],
        // ),
      ];

  PreferredSize _profilePictureSection(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(150),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  CircleAvatar(
                      minRadius: 50,
                      backgroundImage: NetworkImage(
                        imageUrl ??
                            "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cGVyc29ufGVufDB8fDB8fHww&auto=format&fit=crop&w=600&q=60",
                      )),
                  if (isEditting)
                    Positioned(
                      bottom: 10,
                      right: 125,
                      child: IconButton(
                        onPressed: () {
                          // PictureUploadService.getImageFile(
                          //   context,
                          //   (url) {
                          //     setState(() {
                          //       imageUrl = url;
                          //     });
                          //   },
                          // );
                        },
                        icon: const Icon(
                          CupertinoIcons.pencil_circle_fill,
                          color: Colors.greenAccent,
                        ),
                      ),
                    )
                ],
              ),
            ),
            const Text(
              "Cameron Williamson",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _emailController.text,
                style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.normal,
                    fontSize: 15),
              ),
            ),
          ],
        ));
  }

  PopupMenuButton<int> _popUpOptions() {
    return PopupMenuButton<int>(
      onSelected: (value) {
        print(value);
      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuItem<int>>[
          PopupMenuItem(
              value: 0,
              child: Row(
                children: [
                  SvgPicture.asset(IconAssets.idCard_ic),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text("Download id Card"),
                ],
              )),
          PopupMenuItem(
              value: 1,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.white,
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(
                              IconAssets.logout_ic,
                              height: 100,
                            ),
                          ),
                          Text(
                            "Oh no! You are leaving... \n are you sure?",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.all(5),
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text("Nah, Just Kidding",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (c) => const OtpLogin()),
                                (route) => false,
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.all(5),
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.blue, width: 1.0)),
                              child: Text("Yes, Log me out",
                                  style: GoogleFonts.poppins(
                                    color: Colors.blue,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    SvgPicture.asset(IconAssets.logout_ic),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text("LogOut"),
                  ],
                ),
              )),
        ];
      },
      icon: const Icon(
        Icons.more_vert,
        color: Colors.white,
      ),
    );
  }

  Widget _inputFieald({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String value,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 200),
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.blue, width: 1.0)),
          child: TextFormField(
            autofocus: true,
            maxLines: null,
            enabled: isEditting,
            controller: controller,
            style: GoogleFonts.poppins(color: Colors.black),
            decoration: InputDecoration(
              labelText: label,
              suffixIcon: isEditting ? const Icon(Icons.edit) : null,
              prefixIcon: Icon(icon),
              labelStyle: const TextStyle(
                color: Color(0xff23202a),
                fontSize: 16,
              ),
              border: InputBorder.none,
            ),
          )),
    );
  }

  Widget _buildPhoneInputFieald({
    required TextEditingController controller,
    required String value,
  }) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.blue, width: 1.0)),
        child: TextField(
          focusNode: focusNode,
          enabled: isEditting,
          keyboardType: TextInputType.phone,
          inputFormatters: [LengthLimitingTextInputFormatter(10)],
          style: GoogleFonts.poppins(color: Colors.black),
          decoration: InputDecoration(
            suffixIcon: isEditting ? const Icon(Icons.edit) : null,
            border: InputBorder.none,
            hintText: "phone",
            hintStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
            prefixIcon: const Padding(
              padding: EdgeInsets.only(
                top: 15,
                bottom: 8.0,
                right: 10,
              ),
              child: Text("🇮🇳  IN  +91"),
            ),
          ),
          controller: controller,
        ));
  }
}
