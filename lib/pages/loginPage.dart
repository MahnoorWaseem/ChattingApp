import 'package:chatting_app/const.dart';
import 'package:chatting_app/pages/homePage.dart';
import 'package:chatting_app/services/authServices.dart';
import 'package:chatting_app/widgets/customFormField.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GetIt _getIt = GetIt.instance;
  late AuthService _authService;

  // inorder to use form widgett fr validation
  final GlobalKey<FormState> _loginFormKey = GlobalKey();
  String? email, password;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authService = _getIt.get<AuthService>();
  }

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
          key: _loginFormKey,
          child: Column(
            // mainAxisSize: MainAxisSize
            //     .max, //diivie all the unused space evenly between children
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              CustomFormField(
                hintText: 'Email',
                height: MediaQuery.sizeOf(context).height * 0.07,
                validationRegExp: EMAIL_VALIDATION_REGEX,
                onSaved: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.03,
              ),
              CustomFormField(
                obscureText: true,
                hintText: 'Password',
                height: MediaQuery.sizeOf(context).height * 0.07,
                validationRegExp: PASSWORD_VALIDATION_REGEX,
                onSaved: (value) {
                  setState(() {
                    password = value;
                  });
                },
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
        onPressed: () async {
          if (_loginFormKey.currentState?.validate() ??
              false) //validate will run validators on children of form and then show message accordingly
          {
            _loginFormKey.currentState?.save();
            // debugPrint("$email , $password");
            bool result = await _authService.login(email!, password!);
            if (result) {
              // debugPrint(result.toString());
Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),));
            } else {}
          }
        },
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
          Text("Don't have an account?"),
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



///Form State: When the save method of the FormState is called, it iterates through all its child form fields and invokes their onSaved callbacks, passing the current value of each field to its respective callback.

// Getting the Value: The value parameter in the onSaved callback of your CustomFormField is automatically provided by the form field itself. The FormField widget manages this internally, ensuring that the current value is passed when onSaved is called.

