import 'package:catat_duit/db/database.dart';
import 'package:catat_duit/models/transaction_with_category.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpensePage extends StatefulWidget {
  final TransactionWithCategory? transactionWithCategory;
  const ExpensePage({
    Key? key,
    required this.transactionWithCategory,
  }) : super(key: key);

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  final AppDb database = AppDb();
  late int type;
  bool isExpense = true;
  TextEditingController amountController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  Category? selectedCategory;

  Future insert(
      int amount, DateTime date, String nameDetail, int categoryId) async {
    DateTime now = DateTime.now();
    // ignore: unused_local_variable
    final row = await database.into(database.transactions).insertReturning(
        TransactionsCompanion.insert(
            description: nameDetail,
            category_id: categoryId,
            transaction_date: date,
            amount: amount,
            created_at: now,
            updated_at: now));
  }

  Future<List<Category>> getAllCategory(int type) async {
    return await database.getAllCategoryRepo(type);
  }

  Future update(int transactionId, int amount, int categoryId,
      DateTime transactionDate, String nameDetail) async {
    return await database.updateTransactionRepo(
        transactionId, amount, categoryId, transactionDate, nameDetail);
  }

  @override
  void initState() {
    if (widget.transactionWithCategory != null) {
      updateTransactionview(widget.transactionWithCategory!);
    } else {
      type = 2;
    }

    super.initState();
  }

  void updateTransactionview(TransactionWithCategory transactionWithCategory) {
    amountController.text =
        transactionWithCategory.transaction.amount.toString();
    detailController.text = transactionWithCategory.transaction.description;
    dateController.text = DateFormat('yyyy-MM-dd')
        .format(transactionWithCategory.transaction.transaction_date);
    type = transactionWithCategory.category.type;
    (type == 2) ? isExpense = true : isExpense = false;
    selectedCategory = transactionWithCategory.category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Pengeluaran',
        ),
      ),
      backgroundColor: Colors.red[50],
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(
                    color: Colors.grey,
                    width: 0.1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Switch(
                          value: isExpense,
                          onChanged: (bool value) {
                            setState(() {
                              isExpense = value;
                              type = (isExpense) ? 2 : 1;
                              selectedCategory = null;
                            });
                          },
                          inactiveTrackColor: Colors.grey,
                          inactiveThumbColor: Colors.green,
                          activeColor: Colors.red,
                        ),
                        Text(isExpense ? 'Pengeluaran' : 'Pemasukan',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isExpense ? Colors.red : Colors.green)),
                      ],
                    ),
                  ],
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(
                    color: Colors.grey,
                    width: 0.1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            ' Jumlah',
                          ),
                          TextField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        ' Kategori',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FutureBuilder<List<Category>>(
                        future: getAllCategory(type),
                        builder: ((context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            if (snapshot.hasData) {
                              // ignore: prefer_is_empty
                              if (snapshot.data!.length > 0) {
                                selectedCategory = (selectedCategory == null)
                                    ? snapshot.data!.first
                                    : selectedCategory;
                                // ignore: avoid_print
                                print(snapshot.toString());
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: DropdownButton<Category>(
                                      value: (selectedCategory == null)
                                          ? snapshot.data!.first
                                          : selectedCategory,
                                      isExpanded: true,
                                      icon: const Icon(
                                          Icons.arrow_drop_down_outlined),
                                      items:
                                          snapshot.data!.map((Category item) {
                                        return DropdownMenuItem<Category>(
                                          value: item,
                                          child: Text(item.name),
                                        );
                                      }).toList(),
                                      onChanged: (Category? value) {
                                        setState(() {
                                          selectedCategory = value;
                                        });
                                      }),
                                );
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
                        })),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tanggal',
                          ),
                          TextField(
                            readOnly: true,
                            controller: dateController,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2099));

                              if (pickedDate != null) {
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);

                                dateController.text = formattedDate;
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Detail',
                          ),
                          TextField(
                            controller: detailController,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Reset isian
                              amountController.clear();
                              detailController.clear();
                              dateController.text = '2023-01-01';
                              selectedCategory = null;
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.green),
                            ),
                            child: const Text(
                              'Reset',
                            ),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () async {
                              (widget.transactionWithCategory == null)
                                  ? insert(
                                      int.parse(amountController.text),
                                      DateTime.parse(dateController.text),
                                      detailController.text,
                                      selectedCategory!.id)
                                  : await update(
                                      widget.transactionWithCategory!
                                          .transaction.id,
                                      int.parse(amountController.text),
                                      selectedCategory!.id,
                                      DateTime.parse(dateController.text),
                                      detailController.text);
                              setState(() {});
                              Navigator.pop(context, true);
                            },
                            child: const Text(
                              'Simpan',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
