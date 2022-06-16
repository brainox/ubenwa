import 'package:flutter/gestures.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubenwa/screens/home_screen.dart';
import 'package:ubenwa/utils/app_colors.dart';
import 'package:workmanager/workmanager.dart';

import '../providers/dio_client.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  static const routeName = '/signup-screen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: deviceHeight,
          width: deviceWidth,
          color: AppColors.kBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              SizedBox(
                height: 116,
              ),
              Text(
                "Test App",
                style: TextStyle(
                  color: AppColors.kHeaderColor,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 86,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 26),
                child: SignupCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignupCard extends StatefulWidget {
  const SignupCard({
    Key? key,
  }) : super(key: key);

  @override
  State<SignupCard> createState() => _SignupCardState();
}

class _SignupCardState extends State<SignupCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _passwordVisible = false;
  var _isLoading = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late TapGestureRecognizer _tapGestureRecognizer;
  final Map<String, String> _authData = {
    'name': '',
    'email': '',
    'password': '',
  };

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Success'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pushNamed(LoginScreen.routeName);
            },
          )
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    _passwordVisible = false;
    _tapGestureRecognizer = TapGestureRecognizer()..onTap = _handleLoginPress;
    // _longPressRecognizer = LongPressGestureRecognizer()
    //   ..onLongPress = _handleLoginPress;
  }

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  void _handleLoginPress() {
    Navigator.of(context).pushNamed(LoginScreen.routeName);
    // Navigator.push(context, MaterialPageRoute(builder: (context =)))
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      var result = await Provider.of<DioClient>(context, listen: false).signup(
          email: '${_authData['email']}',
          firstName: '${_authData['name']}',
          lastName: '${_authData['name']}',
          password: '${_authData['password']}',
          passwordConfirmation: '${_authData['password']}');
      print('the response is ${result.statusCode}');
      if (result.statusCode == "200" || result.statusCode == "201") {
        const successMessage = 'Successfully signed up. Login now.';
        // Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        _showSuccessDialog(successMessage);
      } else {
        const errorMessage =
            'Could not authenticate you. Please try again later.';
        _showErrorDialog(errorMessage);
      }
    } catch (error) {
      print(error);
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Color(0xffFBF5FF),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(30.0),
      ),
      elevation: 0.0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 27),
        constraints: const BoxConstraints(minHeight: 417),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 22,
                    color: AppColors.kPrimaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 17,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Name",
                      style: TextStyle(
                          color: AppColors.kPrimaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 10),
                    ),
                  ),
                ),
                Container(
                  height: 38,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _nameController,
                    style: const TextStyle(
                        color: AppColors.kHintColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      fillColor: Color(0xffE6E6E6),
                      focusColor: Color(0xffE6E6E6),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Invalid name!';
                      }
                    },
                    onSaved: (value) {
                      _authData['name'] = value!;
                    },
                  ),
                ),
                const SizedBox(
                  height: 9,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Email",
                      style: TextStyle(
                          color: AppColors.kPrimaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 10),
                    ),
                  ),
                ),
                Container(
                  height: 38,
                  child: TextFormField(
                    controller: _emailController,
                    style: const TextStyle(
                        color: AppColors.kHintColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      fillColor: Color(0xffE6E6E6),
                      focusColor: Color(0xffE6E6E6),
                    ),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Invalid email!';
                      }
                    },
                    onSaved: (value) {
                      _authData['email'] = value!;
                    },
                  ),
                ),
                const SizedBox(
                  height: 9,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Password",
                      style: TextStyle(
                          color: AppColors.kPrimaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 10),
                    ),
                  ),
                ),
                Container(
                  height: 38,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _passwordController,
                    obscureText:
                        !_passwordVisible, //This will obscure text dynamically
                    style: const TextStyle(
                        color: AppColors.kHintColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      fillColor: Color(0xffE6E6E6),
                      focusColor: Color(0xffE6E6E6),
                      suffixIcon: IconButton(
                        iconSize: 18,
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Color(0xffCCD2E3),
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 5) {
                        return 'Password is too short!';
                      }
                    },
                    onSaved: (value) {
                      _authData['password'] = value!;
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 34),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      // Note: Styles for TextSpans must be explicitly defined.
                      // Child text spans will inherit styles from parent
                      style: TextStyle(
                          fontSize: 10.0,
                          color: AppColors.kHintColor,
                          fontWeight: FontWeight.w500),
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                'By entering your details, your are agreeing to our '),
                        TextSpan(
                            text: 'Terms of Service ',
                            style: TextStyle(
                                color: AppColors.kButtonColor,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w500)),
                        TextSpan(text: 'and '),
                        TextSpan(
                            text: 'Privacy Policy. ',
                            style: TextStyle(
                                color: AppColors.kButtonColor,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w500)),
                        TextSpan(text: 'Thanks!'),
                        // Privacy Policy.
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 28,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  SizedBox(
                    width: 110,
                    child: ElevatedButton(
                      onPressed: _submit,
                      child: Text("Sign up"),
                      style: ElevatedButton.styleFrom(
                          primary: AppColors.kButtonColor,
                          onPrimary: Colors.white,
                          elevation: 0, // Elev
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)) // ation
                          ),
                    ),
                  ),
                const SizedBox(
                  height: 34,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style: TextStyle(
                        fontSize: 10.0,
                        color: AppColors.kHintColor,
                        fontWeight: FontWeight.w500),
                    children: <TextSpan>[
                      TextSpan(text: 'Dont have an account? '),
                      TextSpan(
                          text: 'Login. ',
                          recognizer: _tapGestureRecognizer,
                          style: TextStyle(
                              color: AppColors.kButtonColor,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w500)),
                      // Privacy Policy.
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: 110,
                  child: ElevatedButton(
                    onPressed: () {
                      print("Hello world");
                      Workmanager().registerOneOffTask(
                        "taskone",
                        "testTask",
                        initialDelay: Duration(seconds: 5),
                      );
                    },
                    child: Text("Sign up"),
                    style: ElevatedButton.styleFrom(
                        primary: AppColors.kButtonColor,
                        onPrimary: Colors.white,
                        elevation: 0, // Elev
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)) // ation
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
