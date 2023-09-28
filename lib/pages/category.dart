import 'package:catat_duit/db/database.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool? isExpense;
  int? type;
  final AppDb database = AppDb();
  List<Category> listCategory = [];
  TextEditingController categoryNameController = TextEditingController();

  Future<List<Category>> getAllCategory(int type) async {
    return await database.getAllCategoryRepo(type);
  }

  Future insert(String name, int type) async {
    DateTime now = DateTime.now();
    await database.into(database.categories).insertReturning(
        CategoriesCompanion.insert(
            name: name, type: type, createdAt: now, updatedAt: now));
  }

  Future update(int categoryId, String newName) async {
    await database.updateCategoryRepo(categoryId, newName);
  }

  @override
  void initState() {
    isExpense = true;
    type = (isExpense!) ? 2 : 1;
    super.initState();
  }

  void openDialog(Category? category) {
    categoryNameController.clear();
    if (category != null) {
      categoryNameController.text = category.name;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
                child: Center(
                    child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  ((category != null) ? 'Edit ' : 'Tambah ') +
                      ((isExpense!)
                          ? 'Kategori Pengeluaran'
                          : 'Kategori Pemasukan'),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: categoryNameController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Nama'),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      (category == null)
                          ? insert(
                              categoryNameController.text, isExpense! ? 2 : 1)
                          : update(category.id, categoryNameController.text);
                      setState(() {});

                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    },
                    child: const Text('Simpan'))
              ],
            ))),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategori'),
      ),
      backgroundColor: Colors.red[50],
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(
                  color: Colors.grey,
                  width: 0.1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Switch(
                        // This bool value toggles the switch.
                        value: isExpense!,
                        inactiveTrackColor: Colors.green[200],
                        inactiveThumbColor: Colors.green,
                        activeColor: Colors.red,
                        onChanged: (bool value) {
                          // This is called when the user toggles the switch.
                          setState(() {
                            isExpense = value;
                            type = (value) ? 2 : 1;
                          });
                        },
                      ),
                      const SizedBox(
                        width: 60,
                      ),
                      Text(isExpense! ? 'Pengeluaran' : 'Pemasukan',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isExpense! ? Colors.red : Colors.green))
                    ],
                  ),
                  IconButton(
                      onPressed: () {
                        openDialog(null);
                      },
                      icon: const Icon(
                        Icons.add_circle,
                        color: Colors.red,
                      ))
                ],
              ),
            ),
          ),
          FutureBuilder<List<Category>>(
            future: getAllCategory(type!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Card(
                            elevation: 10,
                            child: ListTile(
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.delete,
                                          size: 20,
                                          color: (isExpense!)
                                              ? Colors.red
                                              : Colors.green),
                                      onPressed: () {
                                        database.deleteCategoryRepo(
                                            snapshot.data![index].id);
                                        setState(() {});
                                      },
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit,
                                          size: 20,
                                          color: (isExpense!)
                                              ? Colors.red
                                              : Colors.green),
                                      onPressed: () {
                                        openDialog(snapshot.data![index]);
                                      },
                                    )
                                  ],
                                ),
                                leading: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: (isExpense!)
                                        ? Icon(Icons.file_upload_outlined,
                                            color: Colors.redAccent[400])
                                        : Icon(
                                            Icons.file_download_outlined,
                                            color: Colors.greenAccent[400],
                                          )),
                                title: Text(snapshot.data![index].name)),
                          ),
                        );
                      },
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
            },
          ),
        ])),
      ),
    );
  }
}
