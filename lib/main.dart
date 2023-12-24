import 'package:flutter/material.dart';
import 'pages/loginScreen.dart';
import 'pages/mainHome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: mainScreen());
  }
}

// ignore: camel_case_types
class mainScreen extends StatelessWidget {
  const mainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 550),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 40),
              child: const Center(
                child: Text(
                  'Aplikasi Laporan Keuangan',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0017ED)),
                ),
              ),
            ),
            Center(
              child: Image.asset('assets/images/logoPerusahaan.png',
                  width: 200, height: 200),
            ),
            Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        // return loginScreen();
                        return const MainHomeScreen(token: null);
                      }));
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            const MaterialStatePropertyAll(Color(0xFF0017ED)),
                        minimumSize:
                            const MaterialStatePropertyAll(Size(60, 60)),
                        elevation: const MaterialStatePropertyAll(0),
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ))),
                    child: const Text(
                      'Masuk',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: const Text(
                'Dibuat oleh PT. Mestakung Abadi',
                style: TextStyle(color: Color(0xFF0017ED)),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
