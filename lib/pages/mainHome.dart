import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting('id', null).then((_) {
    runApp(const MainHomeScreen(username: ''));
  });
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
    final response =
        await http.get(Uri.parse('http://10.0.2.2/list_ukm/getdata.php'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final totalThisMonth =
              _calculateTotalForMonth(snapshot.data ?? [], selectedMonth);
          final formattedTotalThisMonth =
              NumberFormat.currency(locale: 'id', symbol: 'Rp')
                  .format(totalThisMonth);

          return Column(
            children: [
              _buildMonthDropdown(),
              PaginatedDataTable(
                header: Text('Penghasilan Bulan Ini: $formattedTotalThisMonth'),
                columns: [
                  DataColumn(label: Text('No')),
                  DataColumn(label: Text('Tanggal')),
                  DataColumn(label: Text('Total Penghasilan')),
                ],
                source: _DataSource(context, snapshot.data ?? []),
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
          Text('Pilih Bulan: '),
          DropdownButton<int>(
            value: selectedMonth,
            items: availableMonths.map((month) {
              return DropdownMenuItem<int>(
                value: month,
                child: Text(month.toString()),
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

  double _calculateTotalForMonth(
      List<Map<String, dynamic>> dataList, int month) {
    double total = 0;
    for (final data in dataList) {
      final date = DateTime.parse(data['tanggal']);
      if (date.month == month) {
        total += double.parse(data['total_penghasilan'].toString());
      }
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

    final totalPenghasilan = double.parse(data['total_penghasilan'].toString());

    // Format the total_penghasilan as Rupiah
    final formattedTotalPenghasilan =
        NumberFormat.currency(locale: 'id', symbol: 'Rp')
            .format(totalPenghasilan);

    return DataRow(cells: [
      DataCell(Text('${data['id_penghasilan']}')),
      DataCell(Text('${data['tanggal']}')),
      DataCell(Text(formattedTotalPenghasilan)),
    ]);
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
