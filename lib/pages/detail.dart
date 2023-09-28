import 'package:catat_duit/db/database.dart';
import 'package:catat_duit/models/transaction_with_category.dart';
import 'package:catat_duit/pages/income.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatefulWidget {
  final DateTime selectedDate;
  const DetailPage({Key? key, required this.selectedDate}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final AppDb database = AppDb();
  late int type;
  bool isExpense = true;
  late DateTime selectedDate;
  // ignore: unused_field
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
      backgroundColor: Colors.red[50],
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Teks Transaksi
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Transaksi',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
            StreamBuilder<List<TransactionWithCategory>>(
                stream: database.getTransactionByDateRepo(widget.selectedDate),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isNotEmpty) {
                        // ignore: avoid_print
                        print(snapshot.toString());
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Card(
                                  elevation: 10,
                                  child: ListTile(
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            await database
                                                .deleteTransactionRepo(snapshot
                                                    .data![index]
                                                    .transaction
                                                    .id);
                                            setState(() {});
                                          },
                                          icon: Icon(Icons.delete,
                                              size: 20,
                                              color: (snapshot.data![index]
                                                          .category.type ==
                                                      2)
                                                  ? Colors.red
                                                  : Colors.green),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        IncomePage(
                                                          transactionWithCategory:
                                                              snapshot
                                                                  .data![index],
                                                        )));
                                          },
                                          icon: Icon(Icons.edit,
                                              size: 20,
                                              color: (snapshot.data![index]
                                                          .category.type ==
                                                      2)
                                                  ? Colors.red
                                                  : Colors.green),
                                        ),
                                      ],
                                    ),
                                    title: Text(
                                      'Rp. ' +
                                          snapshot
                                              .data![index].transaction.amount
                                              .toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                        snapshot.data![index].category.name +
                                            '(' +
                                            snapshot.data![index].transaction
                                                .description +
                                            ')'),
                                    leading: Container(
                                      padding: const EdgeInsets.all(5),
                                      child: (snapshot
                                                  .data![index].category.type ==
                                              2)
                                          ? const Icon(
                                              Icons.file_upload_outlined,
                                              color: Colors.red,
                                            )
                                          : const Icon(
                                              Icons.file_download_outlined,
                                              color: Colors.green,
                                            ),
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                    ),
                                  ),
                                ),
                              );
                            });
                      } else {
                        return const Center(
                          child: Text('Tidak Ada Data'),
                        );
                      }
                    } else {
                      return const Center(
                        child: Text('Tidak Ada Data'),
                      );
                    }
                  }
                }),
          ],
        )),
      ),
    );
  }
}
