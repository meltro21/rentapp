import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:rentapp/controllers/auth_controller.dart';
import 'package:rentapp/main.dart';
import 'package:rentapp/views/authentication/background.dart';
import 'package:rentapp/views/authentication/login.dart';
import 'package:rentapp/views/home/home_screen.dart';

class RegisterScreen extends StatelessWidget {
  AuthController authController = Get.put(AuthController());
  final _form = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  // TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Obx(
      () => LoadingOverlay(
        isLoading: authController.loading.value,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Background(
              child: Form(
                key: _form,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        "REGISTER",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2661FA),
                            fontSize: 36),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Name';
                          }
                          return null;
                        },
                        controller: nameController,
                        decoration: InputDecoration(labelText: "Name"),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Email';
                          }
                          return null;
                        },
                        controller: emailController,
                        decoration: InputDecoration(labelText: "Email"),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Phone';
                          }
                          return null;
                        },
                        controller: phoneController,
                        decoration: InputDecoration(labelText: "Mobile Number"),
                      ),
                    ),
                    // SizedBox(height: size.height * 0.03),
                    // Container(
                    //   alignment: Alignment.center,
                    //   margin: EdgeInsets.symmetric(horizontal: 40),
                    //   child: TextFormField(
                    //     validator: (value) {
                    //       if (value == null || value.isEmpty) {
                    //         return 'Enter Username';
                    //       }
                    //       return null;
                    //     },
                    //     controller: userNameController,
                    //     decoration: InputDecoration(labelText: "Username"),
                    //   ),
                    // ),
                    SizedBox(height: size.height * 0.03),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Password';
                          }
                          return null;
                        },
                        controller: passwordController,
                        decoration: InputDecoration(labelText: "Password"),
                        obscureText: true,
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),
                    Container(
                      alignment: Alignment.centerRight,
                      margin:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      child: RaisedButton(
                        onPressed: () async {
                          if (_form.currentState!.validate()) {
                            bool logIn = await authController
                                .registerWithEmailAndPassword(
                                    emailController.text,
                                    passwordController.text,
                                    nameController.text,
                                    phoneController.text);
                            if (logIn == true) {
                              Get.to(MyHomePage());
                            }
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0)),
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(0),
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          width: size.width * 0.5,
                          decoration: new BoxDecoration(
                              borderRadius: BorderRadius.circular(80.0),
                              color: Color(0xFF7033FF)
                              // gradient: new LinearGradient(
                              //   colors: [
                              //     Color.fromARGB(255, 255, 136, 34),
                              //     Color.fromARGB(255, 255, 177, 41)
                              //   ]
                              // )
                              ),
                          padding: const EdgeInsets.all(0),
                          child: Text(
                            "SIGN UP",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      margin:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      child: GestureDetector(
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()))
                        },
                        child: Text(
                          "Already Have an Account? Sign in",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2661FA)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
