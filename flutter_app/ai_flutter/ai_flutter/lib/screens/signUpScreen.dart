import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/AuthButton.dart';
import '../widgets/CustomFormField.dart';
import '../widgets/CustomHeader.dart';
import '../widgets/CustomRichText.dart';



class signUpScreen extends StatefulWidget {
  static const routeName = '/signUpScreen';
  const signUpScreen({Key? key}) : super(key: key);


  @override
  State<signUpScreen> createState() => _signUpScreenState();
}

class _signUpScreenState extends State<signUpScreen> {
  bool obscured = true;
  final _userName = TextEditingController();
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
                  text: 'Sign Up.',
                  onTap: () {
                    // Navigator.pushReplacement(context,
                    //     MaterialPageRoute(builder: (context) => const Signin()));
                  }),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.08,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.9,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32))),
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
                        height: 16,
                      ),
                      CustomFormField(
                        key: widget.key,
                        headingText: "UserName",
                        hintText: "username",
                        obsecureText: false,
                        suffixIcon: const SizedBox(),
                        maxLines: 1,
                        textInputAction: TextInputAction.done,
                        textInputType: TextInputType.text,
                        controller: _userName,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomFormField(
                        headingText: "Email",
                        hintText: "Email",
                        obsecureText: false,
                        suffixIcon: const SizedBox(),
                        maxLines: 1,
                        textInputAction: TextInputAction.done,
                        textInputType: TextInputType.emailAddress,
                        controller: _emailController,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomFormField(
                        key: widget.key,
                        maxLines: 1,
                        textInputAction: TextInputAction.done,
                        textInputType: TextInputType.text,
                        controller: _passwordController,
                        headingText: "Password",
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
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      AuthButton(
                        onTap: () {},
                        text: 'Sign Up',
                      ),
                      CustomRichText(
                        discription: 'Already Have an account? ',
                        text: 'Log In here',
                        onTap: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
