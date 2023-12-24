import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'mainHome.dart';

class loginScreen extends StatefulWidget {
  @override
  _loginScreenState createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  String errorMessage = '';
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> _login(BuildContext context) async {
    if (user.text.isEmpty) {
      setState(() {
        errorMessage = "Mohon isi username.";
      });
      return;
    }

    if (pass.text.isEmpty) {
      setState(() {
        errorMessage = "Mohon isi password.";
      });
      return;
    }

    // request body
    var reqBody = {"username": user.text, "password": pass.text};

    // process
    final response = await http.post(
      Uri.parse('http://192.168.100.10:8080/api/ukm/auth'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );

    // if get an token
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);

      // get token
      var myToken = data['access_token'];

      // store token on shared_preferences
      prefs.setString('token', myToken);

      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainHomeScreen(token: myToken),
        ),
      );
    } else if (response.statusCode == 404 || response.statusCode == 401) {
      Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        errorMessage = "${data['messages']['error']}";
      });
    } else {
      Map<String, dynamic> errorData = json.decode(response.body);
      String errorMessageFromApi =
          errorData['messages']['error'] ?? "Terjadi kesalahan pada server";
      setState(() {
        errorMessage = errorMessageFromApi;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 550),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Image.asset(
                        'assets/images/ikonGembok.png',
                        width: 200,
                        height: 200,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Text(
                        'Mohon Untuk Memasukkan Username dan Password Anda',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDBE2EF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: user,
                      decoration: const InputDecoration(
                        hintText: 'Username',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDBE2EF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: pass,
                      obscureText:
                          true, // Setel obscureText menjadi true untuk menyembunyikan password
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ElevatedButton(
                      onPressed: () {
                        _login(context);
                      },
                      child: const Text(
                        'Masuk',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            const MaterialStatePropertyAll(Color(0xFF0017ED)),
                        minimumSize:
                            const MaterialStatePropertyAll(Size(60, 60)),
                        elevation: const MaterialStatePropertyAll(0),
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                      ),
                    ),
                  ),
                  errorMessage.isNotEmpty
                      ? Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            errorMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
