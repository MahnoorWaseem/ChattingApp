import 'package:chatting_app/widgets/customFormField.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, //to avoid bottom overflow
      body: _buildUI(),
    );
  }

//BuildUI widget fr scaffold
  Widget _buildUI() {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 20.0,
      ),
      child: Column(
        children: [
          _headerText(),
          _loginForm(),
          _createAnAccountLink(),
        ],
      ),
    ));
  }

  //children of column in main build ui
  //1. header widget
  Widget _headerText() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hi, Welcome Back!",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            "Hello again, you've been missed",
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

  //2. loginForm
  Widget _loginForm() {
    return Container(
      // height: MediaQuery.sizeOf(context).height * 0.40, //40% of the screen
      margin: EdgeInsets.only(
        top: MediaQuery.sizeOf(context).height * 0.05,
      ),
      child: Form(
          child: Column(
        // mainAxisSize: MainAxisSize
        //     .max, //diivie all the unused space evenly between children
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          CustomFormField(
            hintText: 'Email',
            height: MediaQuery.sizeOf(context).height * 0.07,
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.03,
          ),
          CustomFormField(
            hintText: 'Password',
            height: MediaQuery.sizeOf(context).height * 0.07,
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.03,
          ),
          _loginButton(),
        ],
      )),
    );
  }

  //2.1 Login button
  Widget _loginButton() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: MaterialButton(
        onPressed: () {},
        color: Theme.of(context).colorScheme.primary,
        child: const Text(
          "Login",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  //3. bottom Link
  Widget _createAnAccountLink() {
    return const Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Don't hav an account?"),
          SizedBox(
            width: 5,
          ),
          Text(
            "Sign Up",
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
