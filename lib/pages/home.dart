import 'package:catat_duit/db/database.dart';
import 'package:catat_duit/pages/category.dart';
import 'package:catat_duit/pages/income.dart';
import 'package:catat_duit/pages/main_page.dart';
import 'package:catat_duit/pages/expense.dart';
import 'package:catat_duit/pages/setting.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppDb database = AppDb();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 300,
              decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: const Icon(
                      Icons.account_balance_wallet,
                      color: Colors.red,
                      size: 100,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50)),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'catat duit',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // Dashboard
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dashboard',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 140,
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.red.shade100),
                        borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              child: const Icon(
                                Icons.file_download_outlined,
                                color: Colors.white,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Pemasukan : ',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                                FutureBuilder(
                                    future: database
                                        .getTotalIncomeByCategoryRepo(1),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Text(
                                          'Rp. -',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green),
                                        );
                                      } else {
                                        if (snapshot.hasData) {
                                          return Text(
                                            'Rp. ${snapshot.data.toString()}',
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green),
                                          );
                                        } else {
                                          return const Text(
                                            'Rp. -',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green),
                                          );
                                        }
                                      }
                                    }),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              child: const Icon(
                                Icons.file_upload_outlined,
                                color: Colors.white,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Pengeluaran : ',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                                FutureBuilder(
                                    future: database
                                        .getTotalExpenseByCategoryRepo(2),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Text(
                                          'Rp. -',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red),
                                        );
                                      } else {
                                        if (snapshot.hasData) {
                                          return Text(
                                            'Rp. ${snapshot.data.toString()}',
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red),
                                          );
                                        } else {
                                          return const Text(
                                            'Rp. -',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red),
                                          );
                                        }
                                      }
                                    }),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    'List Menu',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
      backgroundColor: Colors.red[50],
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                builder: (context) => const CategoryPage(),
              ))
                  .then((value) {
                setState(() {});
              });
            },
            backgroundColor: Colors.red[700],
            child: const Icon(Icons.category, size: 30, color: Colors.white),
          ),
          const SizedBox(height: 10), // Spasi antara icon dan teks
          const Text(
            'Kategori',
            style: TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 80),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.red.shade100),
              borderRadius: BorderRadius.circular(20)),
          child: SizedBox(
              height: 180,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.red[700],
                                borderRadius: BorderRadius.circular(50)),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                    builder: (context) => const IncomePage(
                                      transactionWithCategory: null,
                                    ),
                                  ))
                                      .then((value) {
                                    setState(() {});
                                  });
                                },
                                icon: const Icon(
                                  Icons.drive_file_move_rounded,
                                  size: 30,
                                  color: Colors.white,
                                )),
                          ),
                          const Text(
                            'Pemasukan',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.red[700],
                                borderRadius: BorderRadius.circular(50)),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                    builder: (context) => const ExpensePage(
                                      transactionWithCategory: null,
                                    ),
                                  ))
                                      .then((value) {
                                    setState(() {});
                                  });
                                },
                                icon: const Icon(
                                  Icons.drive_file_move_rtl,
                                  size: 30,
                                  color: Colors.white,
                                )),
                          ),
                          const Text(
                            'Pengeluaran',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.red[700],
                                borderRadius: BorderRadius.circular(50)),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                    builder: (context) => const MainPage(),
                                  ))
                                      .then((value) {
                                    setState(() {});
                                  });
                                },
                                icon: const Icon(
                                  Icons.featured_play_list,
                                  size: 30,
                                  color: Colors.white,
                                )),
                          ),
                          const Text(
                            'Detail',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.red[700],
                                borderRadius: BorderRadius.circular(50)),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                    builder: (context) => const SettingPage(),
                                  ))
                                      .then((value) {
                                    setState(() {});
                                  });
                                },
                                icon: const Icon(
                                  Icons.settings_applications_sharp,
                                  size: 30,
                                  color: Colors.white,
                                )),
                          ),
                          const Text(
                            'Pengaturan',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
