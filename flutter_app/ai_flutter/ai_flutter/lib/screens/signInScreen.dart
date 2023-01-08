
import 'package:ai_flutter/screens/signUpScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/AuthButton.dart';
import '../widgets/CustomFormField.dart';
import '../widgets/CustomHeader.dart';
import '../widgets/CustomRichText.dart';

class signInScreen extends StatefulWidget {
  static const routeName = '/signInScreen';


  @override
  State<signInScreen> createState() => _signInScreenState();
}

class _signInScreenState extends State<signInScreen> {
  bool obscured = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {


    return Scaffold(

      body: SafeArea(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Color(0xff040669),
              ),
              CustomHeader(
                text: 'Log In',
                onTap: () {
                  // Navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: (context) => const SignUp()));
                },
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.08,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.9,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width * 0.8,
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.09),
                        child: Image.asset("assets/images/appLogo.png"),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      CustomFormField(
                        headingText: "Email",
                        hintText: "Email",
                        obsecureText: false,
                        suffixIcon: const SizedBox(),
                        controller: _emailController,
                        maxLines: 1,
                        textInputAction: TextInputAction.done,
                        textInputType: TextInputType.emailAddress,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomFormField(
                        headingText: "Password",
                        maxLines: 1,
                        textInputAction: TextInputAction.done,
                        textInputType: TextInputType.text,
                        hintText: "At least 8 Character",
                        obsecureText: true,
                        suffixIcon: IconButton(
                          icon: Icon(obscured?Icons.visibility_off_outlined:Icons.visibility, color: Colors.grey.shade700,),
                          onPressed: (){
                            setState(() {
                              obscured = !obscured;
                            });
                          },
                        ),
                        controller: _passwordController,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 24),
                            child: InkWell(
                              onTap: () {},
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                    color: Color(0xff040669).withOpacity(0.7),
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      AuthButton(
                        onTap: () {},
                        text: 'Sign In',
                      ),
                      CustomRichText(
                        discription: "Don't already Have an account? ",
                        text: "Sign Up",
                        onTap: () {
                          Navigator.pushNamed(context, signUpScreen.routeName);

                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
