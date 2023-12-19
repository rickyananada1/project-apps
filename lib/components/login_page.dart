import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:login_signup/components/common/page_header.dart';
import 'package:login_signup/components/forget_password_page.dart';
import 'package:login_signup/components/signup_page.dart';
import 'package:http/http.dart' as http;
import 'package:login_signup/components/common/page_heading.dart';
import 'package:login_signup/components/common/custom_form_button.dart';
import 'navbar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

Future<void> login(String username, String password) async {
  final storage = new FlutterSecureStorage();
  const url = 'http://10.232.1.21:7066/v1/auth/login';

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'}, 
      body: json.encode({
        'email': username.toString(),
        'password': password.toString(),
      }),
    );

    if (response.statusCode == 200) {
      print('Login successful: ${response.body}');
      final Map<String, dynamic> responseBody = json.decode(response.body);
      print('dapat token woi : ' + responseBody['data']['token']);
      await storage.write(key: 'token', value: '${responseBody['data']['token']}');
    } else {
      print('Login failed with status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error during login: $error');
  }
}

class _LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffEEF1F3),
        body: Column(
          children: [
            const PageHeader(),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _loginFormKey,
                    child: Column(
                      children: [
                        const PageHeading(
                          title: 'Log-in',
                        ),
                        Container(
                          width: size.width * 0.9,
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  'Username',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  isDense: true,
                                  hintText: 'Masukkan Username Anda',
                                ),
                                validator: (textValue) {
                                  if (textValue == null || textValue.isEmpty) {
                                    return 'Username tidak boleh kosong';
                                  }
                                  return null;
                                },
                                controller: _usernameController,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          width: size.width * 0.9,
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  'Password',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ),
                              TextFormField(
                                obscureText: true,
                                decoration: const InputDecoration(
                                  isDense: true,
                                  hintText: 'Masukkan Password Anda',
                                ),
                                validator: (textValue) {
                                  if (textValue == null || textValue.isEmpty) {
                                    return 'Password tidak boleh kosong';
                                  }
                                  return null;
                                },
                                controller: _passwordController,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          width: size.width * 0.80,
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () => {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgetPasswordPage()))
                            },
                            child: const Text(
                              'Forget password?',
                              style: TextStyle(
                                color: Color(0xff939393),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomFormButton(innerText: 'Login', onPressed: _handleLoginUser),
                        const SizedBox(
                          height: 18,
                        ),
                        SizedBox(
                          width: size.width * 0.8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Don\'t have an account ? ', style: TextStyle(fontSize: 13, color: Color(0xff939393), fontWeight: FontWeight.bold)),
                              GestureDetector(
                                onTap: () => {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupPage()))
                                },
                                child: const Text('Sign-up', style: TextStyle(fontSize: 15, color: Color(0xff748288), fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLoginUser() {
    // login user
    if (_loginFormKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Submitting data..')),
      );
      String username = _usernameController.text.trim();
      String password = _passwordController.text.trim();
      login(username, password);
      // get the return value from login function
      // if the return value is not null, then navigate to MainScreen
      // else, show error message
      String token = login(username, password).toString();
      print("Token " + token);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen(token: token)),
      );
    }
  }
}
