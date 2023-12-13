import 'package:aplikasi_keuangan_pbl/main.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          width: MediaQuery.of(context).size.width * 0.9,
          constraints: BoxConstraints(maxWidth: 550),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      
                      title: SizedBox(
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const mainScreen();
                            }));
                          },
                          icon: Icon(
                            Icons.logout,
                            color: Colors.black,
                          ),
                          label: Text(
                            'Keluar dari akun saat ini',
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text('Versi 1.0 Developed By TIM PBL IF21',
                  style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
