import 'package:bootstrap_library/constants.dart';
import 'package:bootstrap_library/firebase/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  bool signup = false;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  void resetInfo() {
    usernameController.text = "";
    emailController.text = "";
    passwordController.text = "";
    confirmController.text = "";
  }

  void performLogin() async {
    if (_formKey.currentState!.validate()) {
      if (!signup) {
        bool successful = await FirebaseAuthService.loginWithEmailAndPassword(
            context, emailController.text, passwordController.text);
        if (context.mounted && successful) {
          Navigator.of(context).pushReplacementNamed(
            "/HomePage",
          );
        }
      } else {
        bool successful = await FirebaseAuthService.signupWithEmailAndPassword(
          context,
          usernameController.text,
          emailController.text,
          passwordController.text,
        );
        if (context.mounted && successful) {
          Navigator.of(context).pushReplacementNamed(
            "/HomePage",
          );
        }
      }
    }
  }

  void switchLoginSignup() {
    setState(() {
      signup = !signup;

      resetInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        // backgroundColor: thirtyUIColor,
        // resizeToAvoidBottomInset: false,
        appBar: null,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0, -1),
              end: Alignment(0, 1),
              colors: [
                thirtyUIColor,
                Colors.white,
              ],
            ),
          ),
          child: Stack(
            children: [
              Lottie.asset('assets/book_animation.json', repeat: true),
              Align(
                alignment: Alignment.bottomCenter,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Container(
                    width: width,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(44),
                        topRight: Radius.circular(44),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: globalEdgePadding,
                        ),
                        Text(
                          (!signup) ? "Login" : "Sign up",
                          style: GoogleFonts.roboto(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(globalEdgePadding),
                          child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  if (signup)
                                    SizedBox(
                                      child: TextFormField(
                                        controller: usernameController,
                                        decoration: const InputDecoration(
                                            prefixIcon: Icon(Icons.person),
                                            labelText: 'Create a username',
                                            border: OutlineInputBorder()),
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return 'Username Cannot be empty';
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                    ),
                                  if (signup)
                                    const SizedBox(height: globalMarginPadding),
                                  TextFormField(
                                    controller: emailController,
                                    decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.email),
                                        labelText: 'Enter your email',
                                        border: OutlineInputBorder()),
                                    validator: (val) {
                                      if (val!.isEmpty ||
                                          !emailRegex
                                              .hasMatch(emailController.text)) {
                                        return 'Enter a valid email';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  const SizedBox(height: globalMarginPadding),
                                  SizedBox(
                                    child: TextFormField(
                                      controller: passwordController,
                                      obscuringCharacter: '*',
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                          prefixIcon: Icon(Icons.key),
                                          labelText: 'Enter your password',
                                          border: OutlineInputBorder()),
                                      validator: (val) {
                                        if (val!.isEmpty ||
                                            passwordController.text.length <
                                                6) {
                                          return 'Password must be 6 characters or longer';
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                  if (signup)
                                    const SizedBox(height: globalMarginPadding),
                                  if (signup)
                                    SizedBox(
                                      child: TextFormField(
                                        controller: confirmController,
                                        obscuringCharacter: '*',
                                        obscureText: true,
                                        decoration: const InputDecoration(
                                            prefixIcon: Icon(Icons.repeat),
                                            labelText: 'Confirm your password',
                                            border: OutlineInputBorder()),
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return 'Enter your password again';
                                          } else if (val !=
                                              passwordController.text) {
                                            return 'Must match previous password';
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                    ),
                                ],
                              )),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                performLogin();
                              },
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        globalEdgePadding,
                                        globalMarginPadding,
                                        globalEdgePadding,
                                        globalMarginPadding),
                                    decoration: const BoxDecoration(
                                      color: tenUIColor,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          (!signup) ? "Login" : "Sign up",
                                          style: GoogleFonts.roboto(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: globalEdgePadding,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: globalEdgePadding,
                        ),
                        (signup)
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Already have an account? "),
                                  GestureDetector(
                                      onTap: () {
                                        switchLoginSignup();
                                      },
                                      child: const Text(
                                        "Login Here!",
                                        style: TextStyle(color: tenUIColor),
                                      ))
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Don't have an account? "),
                                  GestureDetector(
                                      onTap: () {
                                        switchLoginSignup();
                                      },
                                      child: const Text(
                                        "Signup Here!",
                                        style: TextStyle(color: tenUIColor),
                                      ))
                                ],
                              ),
                        const SizedBox(
                          height: globalEdgePadding * 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
