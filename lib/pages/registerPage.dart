import 'dart:io';

import 'package:chatting_app/const.dart';
import 'package:chatting_app/pages/loginPage.dart';
import 'package:chatting_app/services/mediaService.dart';
import 'package:chatting_app/widgets/customFormField.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GetIt _getIt = GetIt.instance;
  late Mediaservice _mediaservice;
  File? selectedImage;
  //A File holds a [path] on which operations can be performed.
  String? email, password, name;

  @override
  void initState() {
    super.initState();
    _mediaservice = _getIt.get<Mediaservice>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
        child: Padding(
      padding: EdgeInsets.only(
        left: 15,
        right: 15,
        top: 20,
      ),
      child: Column(
        children: [
          _headerText(),
          _registerForm(),
          _createAnAccountLink(),
        ],
      ),
    ));
  }

//1.header text
  Widget _headerText() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Let's get going!",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            "Register an account using the form below",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
              // fontFamily: GoogleFonts.montserratTextTheme().toString(),
            ),
          ),
        ],
      ),
    );
  }

  //2. Login Form
  Widget _registerForm() {
    return Container(
      // height: MediaQuery.sizeOf(context).height * 0.60,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height * 0.05,
      ),
      child: Form(
          child: Column(
        children: [
          _pfpSelectionField(),
          SizedBox(
            height: 20,
          ),
          CustomFormField(
            hintText: 'Name',
            height: MediaQuery.sizeOf(context).height * 0.10,
            validationRegExp: NAME_VALIDATION_REGEX,
            onSaved: (value) {
              name = value;
            },
          ),
          CustomFormField(
            hintText: 'Email',
            height: MediaQuery.sizeOf(context).height * 0.10,
            validationRegExp: EMAIL_VALIDATION_REGEX,
            onSaved: (value) {
              email = value;
            },
          ),
          CustomFormField(
            hintText: 'Password',
            height: MediaQuery.sizeOf(context).height * 0.10,
            validationRegExp: PASSWORD_VALIDATION_REGEX,
            onSaved: (value) {
              password = value;
            },
            obscureText: true,
          ),
          _registerButton(),
        ],
      )),
    );
  }

  //2.1 pfp
  Widget _pfpSelectionField() {
    return GestureDetector(
      onTap: () async {
        File? file = await _mediaservice.getImageFromGallery();
        if (file != null) {
          setState(() {
            selectedImage = file;
          });
        }
      },
      child: CircleAvatar(
        radius: MediaQuery.sizeOf(context).width * 0.15,
        backgroundImage: selectedImage != null
            ? FileImage(selectedImage!)
            : NetworkImage(PLACEHOLDER_PFP) as ImageProvider,
      ),
    );
  }

  //2.2 Reg button
  Widget _registerButton() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: MaterialButton(
        color: Theme.of(context).colorScheme.primary,
        onPressed: () {

        },
        child: const Text(
          "Register",
          style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
        ),
      ),
    );
  }

  //3. bottom Link
  Widget _createAnAccountLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account?"),
        const SizedBox(
          width: 5,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ));
          },
          child: const Text(
            "Login",
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}
