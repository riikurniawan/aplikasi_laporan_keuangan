import 'package:flutter/material.dart';

import 'pages/loginScreen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: mainScreen());
  }
}

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
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return loginScreen();
                      }));
                    },
                    child: const Text(
                      'Masuk',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            const MaterialStatePropertyAll(Color(0xFF0017ED)),
                        minimumSize: const MaterialStatePropertyAll(Size(60, 60)),
                        elevation: const MaterialStatePropertyAll(0),
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ))),
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



// class signUpScreen extends StatelessWidget {
//   const signUpScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//           body: SingleChildScrollView(
//         child: Center(
//             child: Container(
//           constraints: BoxConstraints(maxWidth: 550),
//           child: Column(
//             children: [
//               Container(
//                 margin: EdgeInsets.symmetric(vertical: 40),
//                 child: Center(
//                   child: Text(
//                     'Registrasi',
//                     style: TextStyle(
//                         fontSize: 30,
//                         fontWeight: FontWeight.w800,
//                         color: Color(0xFF0017ED)),
//                   ),
//                 ),
//               ),
//               Container(
//                 width: MediaQuery.of(context).size.width * 0.8,
//                 padding: EdgeInsets.symmetric(horizontal: 13),
//                 decoration: BoxDecoration(
//                     color: Color(0xFFDBE2EF),
//                     borderRadius: BorderRadius.circular(10)),
//                 child: TextField(
//                   decoration: InputDecoration(
//                     hintText: 'Email',
//                     border: InputBorder.none,
//                   ),
//                 ),
//               ),
//               Container(
//                 width: MediaQuery.of(context).size.width * 0.8,
//                 margin: EdgeInsets.only(top: 25),
//                 padding: EdgeInsets.symmetric(horizontal: 13),
//                 decoration: BoxDecoration(
//                     color: Color(0xFFDBE2EF),
//                     borderRadius: BorderRadius.circular(10)),
//                 child: TextField(
//                   decoration: InputDecoration(
//                     hintText: 'Nama Pengguna',
//                     border: InputBorder.none,
//                   ),
//                 ),
//               ),
//               Container(
//                 width: MediaQuery.of(context).size.width * 0.8,
//                 margin: EdgeInsets.only(top: 25),
//                 padding: EdgeInsets.symmetric(horizontal: 13),
//                 decoration: BoxDecoration(
//                     color: Color(0xFFDBE2EF),
//                     borderRadius: BorderRadius.circular(10)),
//                 child: TextField(
//                   decoration: InputDecoration(
//                     hintText: 'Kata Sandi',
//                     border: InputBorder.none,
//                   ),
//                 ),
//               ),
//               Container(
//                 width: MediaQuery.of(context).size.width * 0.8,
//                 margin: EdgeInsets.only(top: 25),
//                 padding: EdgeInsets.symmetric(horizontal: 13),
//                 decoration: BoxDecoration(
//                     color: Color(0xFFDBE2EF),
//                     borderRadius: BorderRadius.circular(10)),
//                 child: TextField(
//                   decoration: InputDecoration(
//                     hintText: 'Konfirmasi Kata Sandi',
//                     border: InputBorder.none,
//                   ),
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.symmetric(vertical: 40),
//                 child: TextButton(
//                   onPressed: () {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) {
//                       return const loginScreen();
//                     }));
//                   },
//                   child: Text(
//                     'Sudah Punya Akun ? Masuk Sekarang',
//                     style: TextStyle(color: Color(0xFF0017ED)),
//                   ),
//                 ),
//               ),
//               // Container(
//               //   width: MediaQuery.of(context).size.width * 0.8,
//               //   child: ElevatedButton(
//               //     onPressed: () {},
//               //     child: Text(
//               //       'Daftar',
//               //       style: TextStyle(fontSize: 16, color: Colors.white),
//               //     ),
//               //     style: ButtonStyle(
//               //         backgroundColor:
//               //             MaterialStatePropertyAll(Color(0xFF0017ED)),
//               //         minimumSize: MaterialStatePropertyAll(Size(60, 60)),
//               //         elevation: MaterialStatePropertyAll(0),
//               //         shape: MaterialStatePropertyAll(RoundedRectangleBorder(
//               //           borderRadius: BorderRadius.circular(10),
//               //         ))),
//               //   ),
//               // ),
//             ],
//           ),
//         )),
//       )),
//     );
//   }
// }