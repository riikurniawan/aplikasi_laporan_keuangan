import 'dart:convert';
import 'dart:math';
// ignore: unused_import
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'settingScreen.dart';

void main() {
  runApp(const MainHomeScreen(username: ''));
}

class MainHomeScreen extends StatelessWidget {
  final String username;

  const MainHomeScreen({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(username: username),
    );
  }
}

class MainScreen extends StatefulWidget {
  final String username;

  const MainScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  List<Widget> get _screens => <Widget>[
        HomeScreen(username: widget.username),
        SettingsScreen(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF333333),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  int currentPage = 1;
  int itemsPerPage = 5;

  @override
  Widget build(BuildContext context) {
    String username = widget.username;

    DateTime currentDate = DateTime.now();
    String formattedDate =
        "${currentDate.day}-${currentDate.month}-${currentDate.year}";

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.only(bottom: 30),
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: const BoxConstraints(maxWidth: 550),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 35),
                  child: Center(
                    child: Image.asset('assets/images/logoPerusahaan.png',
                        width: 200, height: 100),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Selamat datang, $username!',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 19,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Tanggal Hari Ini : $formattedDate',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 19,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                FutureBuilder(
                  future: fetchData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // Hitung total penghasilan dalam satu bulan
                      double totalPenghasilan = 0;

                      // ignore: unused_local_variable
                      int totalPages = (snapshot.data!.length / itemsPerPage).ceil();

                  // Calculate the index range for the current page
                  int startIndex = (currentPage - 1) * itemsPerPage;
                  int endIndex = min(currentPage * itemsPerPage, snapshot.data!.length);

                  List<Map<String, dynamic>> currentPageData = snapshot.data!
                      .sublist(startIndex, endIndex)
                      .toList();

                      for (var data in snapshot.data!) {
                        if (data['total_penghasilan'] != null) {
                          // Konversi nilai 'total_penghasilan' dari String ke double
                          totalPenghasilan +=
                              double.parse(data['total_penghasilan']);
                        }
                      }

                      List<DataRow> rows = List<DataRow>.generate(
                        min(5, snapshot.data!.length),
                        (int index) => DataRow(
                          cells: <DataCell>[
                            DataCell(Text(
                              '${index + 1}',
                              style: const TextStyle(fontSize: 18),
                            )),
                            DataCell(Text(
                              '${snapshot.data?[index]['tanggal']}',
                              style: const TextStyle(fontSize: 18),
                            )),
                            DataCell(
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Text(
                                  'Rp.${snapshot.data?[index]['total_penghasilan']}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );

                      return Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 16.0),
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 128, 130,
                                  132), // Ganti warna latar belakang sesuai keinginan
                              borderRadius: BorderRadius.circular(
                                  10.0), // Ganti bentuk sudut sesuai keinginan
                            ),
                            child: Text(
                              'Total Penghasilan Bulan Ini: Rp.${totalPenghasilan.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 25, 24,
                                    24), // Ganti warna teks sesuai keinginan
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columnSpacing: 16.0,
                              columns: const <DataColumn>[
                                DataColumn(
                                  label: Text('No'),
                                ),
                                DataColumn(
                                  label: Text('Tanggal'),
                                ),
                                DataColumn(
                                  label: Text('Jumlah Pemasukan'),
                                ),
                              ],
                              rows: rows,
                            ),
                          ),
                          Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                currentPage = max(1, currentPage - 1);
                              });
                            },
                            child: const Text('Prev'),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                currentPage = min(totalPages, currentPage + 1);
                              });
                            },
                            child: const Text('Next'),
                          ),
                        ],
                      ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<List<Map<String, dynamic>>> fetchData() async {
  final response = await http.get(Uri.parse(
      "http://10.0.2.2/list_ukm/getdata.php")); // Ganti dengan URL API yang sesuai

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return data.cast<Map<String, dynamic>>();
  } else {
    throw Exception('Failed to load data from API');
  }
}
