import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class MainHomeScreen extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final token;

  const MainHomeScreen({required this.token, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(token: token),
    );
  }
}

class MainScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final token;

  const MainScreen({required this.token, Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // prepare variabel to store decoded jwt
  late int ukmId;
  late String ukmUsername;
  late String ukmName;

  @override
  void initState() {
    super.initState();

    // decode jwt
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);

    ukmUsername = jwtDecodedToken['username'];
    ukmId = int.parse(jwtDecodedToken['ukmId']);
    ukmName = jwtDecodedToken['name'];
  }

  List<Widget> get _screens => <Widget>[
        HomeScreen(
          username: ukmUsername,
          ukmId: ukmId,
          name: ukmName,
        ),
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
  final int ukmId;
  final String name;

  const HomeScreen(
      {Key? key,
      required this.username,
      required this.ukmId,
      required this.name})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    String username = widget.username;
    int ukmId = widget.ukmId;
    String name = widget.name;

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
                          'Selamat datang, $name!',
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
                // Add the PaginatedDataList widget here
                PaginatedDataList(username: username),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PaginatedDataList extends StatefulWidget {
  final String username;

  const PaginatedDataList({Key? key, required this.username}) : super(key: key);

  @override
  _PaginatedDataListState createState() => _PaginatedDataListState();
}

class _PaginatedDataListState extends State<PaginatedDataList> {
  late Future<List<Map<String, dynamic>>> futureData;
  late List<int> availableMonths;
  late int selectedMonth;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
    availableMonths = List.generate(12, (index) => index + 1);
    selectedMonth = DateTime.now().month;
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await http
        .get(Uri.parse('http://192.168.100.10:8080/api/ukm/pemasukan/2'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final List<dynamic> data = responseData['data'][0]['pemasukan'];

      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load data');
    }
  }

  List<Map<String, dynamic>> _filteredData(
      List<Map<String, dynamic>> dataList, int month) {
    return dataList.where((data) {
      final date = DateTime.parse(data['tanggal_pemasukan']);
      return date.month == month;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final filteredData =
              _filteredData(snapshot.data ?? [], selectedMonth);
          final totalThisMonth = _calculateTotalForMonth(filteredData);
          final formattedTotalThisMonth =
              NumberFormat.currency(locale: 'id', symbol: 'Rp')
                  .format(totalThisMonth);

          return Column(
            children: [
              _buildMonthDropdown(),
              PaginatedDataTable(
                key: ValueKey(selectedMonth),
                header: Text('Penghasilan Bulan Ini: $formattedTotalThisMonth'),
                columns: const [
                  DataColumn(label: Text('No')),
                  DataColumn(label: Text('Tanggal')),
                  DataColumn(label: Text('Total Penghasilan')),
                ],
                source: _DataSource(context, filteredData),
                rowsPerPage: 5,
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildMonthDropdown() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Pilih Bulan: '),
          DropdownButton<int>(
            value: selectedMonth,
            items: availableMonths.map((month) {
              return DropdownMenuItem<int>(
                value: month,
                child: Text(
                    _getMonthName(month)), // Menggunakan fungsi _getMonthName
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedMonth = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    // Menggunakan objek DateTime untuk mendapatkan nama bulan
    return DateFormat('MMMM').format(DateTime(2022, month, 1));
  }

  double _calculateTotalForMonth(List<Map<String, dynamic>> dataList) {
    double total = 0;
    for (final data in dataList) {
      total += double.parse(data['total_pemasukan'].toString());
    }
    return total;
  }
}

class _DataSource extends DataTableSource {
  final BuildContext context;
  final List<Map<String, dynamic>> dataList;

  _DataSource(this.context, this.dataList);

  @override
  DataRow? getRow(int index) {
    if (index >= dataList.length) return null;
    final data = dataList[index];

    try {
      final totalPenghasilan = double.parse(data['total_pemasukan'].toString());

      // Format the total_penghasilan as Rupiah
      final formattedTotalPenghasilan =
          NumberFormat.currency(locale: 'id', symbol: 'Rp')
              .format(totalPenghasilan);

      return DataRow(cells: [
        DataCell(Text((index + 1).toString())),
        DataCell(Text('${data['tanggal_pemasukan']}')),
        DataCell(Text(formattedTotalPenghasilan)),
      ]);
    } catch (e) {
      print('Error: $e');
      return null; // Atau tindakan lain yang sesuai
    }
  }

  @override
  int get rowCount => dataList.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Text('Settings Screen'),
      ),
    );
  }
}
