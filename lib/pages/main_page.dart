import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:catat_duit/db/database.dart';
import 'package:catat_duit/pages/detail.dart';
import 'package:catat_duit/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final AppDb database = AppDb();
  late int type;
  bool isExpense = true;
  late DateTime selectedDate;
  late List<Widget> _children;
  late int currentIndex;

  @override
  void initState() {
    updateView(0, DateTime.now());
    super.initState();
  }

  void updateView(int index, DateTime? date) {
    setState(() {
      if (date != null) {
        selectedDate = DateTime.parse(DateFormat('yyyy-MM-dd').format(date));
      }

      currentIndex = index;
      _children = [
        DetailPage(
          selectedDate: selectedDate,
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CalendarAppBar(
        accent: Colors.red[800],
        backButton: false,
        locale: 'id',
        // ignore: avoid_print
        onDateChanged: (value) {
          setState(() {
            selectedDate = value;
            updateView(0, value);
          });
        },
        firstDate: DateTime.now().subtract(const Duration(days: 140)),
        lastDate: DateTime.now(),
      ),
      floatingActionButton: Visibility(
        visible: (currentIndex == 0) ? true : false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ))
                    .then((value) {
                  setState(() {});
                });
              },
              backgroundColor: Colors.red[700],
              child:
                  const Icon(Icons.home_filled, size: 30, color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text(
              'Home',
              style: TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      backgroundColor: Colors.red[50],
      body: _children[currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}
