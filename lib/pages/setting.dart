import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final String developerName = 'Nurul Huda';
  final String developerNim = '2141764061';
  String storedPassword = 'password';

  bool isPasswordValid = true; // Indikator apakah password saat ini valid

  @override
  void initState() {
    super.initState();
    _currentPasswordController.text = storedPassword;
  }

  Future<void> _updatePassword() async {
    if (_currentPasswordController.text == storedPassword) {
      storedPassword = _newPasswordController.text;
      isPasswordValid = true;

      final Database database = await openDatabase(
        'catat_duit.db',
        version: 1,
      );

      await database.update(
        'users',
        {'password': storedPassword},
        where: 'id = ?',
        whereArgs: [1],
      );

      _newPasswordController.clear();
      setState(() {});
    } else {
      isPasswordValid = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      backgroundColor: Colors.red[50],
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.red.shade100),
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 16.0),
                      const Text(
                        'Ganti Password',
                        style: TextStyle(fontSize: 17),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _currentPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password Saat Ini',
                          errorText:
                              isPasswordValid ? null : 'Password tidak valid',
                        ),
                      ),
                      TextField(
                        controller: _newPasswordController,
                        obscureText: true,
                        decoration:
                            const InputDecoration(labelText: 'Password Baru'),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        onPressed: () {
                          _updatePassword;
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                            builder: (context) => const SettingPage(),
                          ))
                              .then((value) {
                            setState(() {});
                          });
                        },
                        child: const Text('Simpan Password Baru'),
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                ),
                const SizedBox(height: 50.0),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.red.shade100),
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/images/nu.png'),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Informasi Developer:',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text('Nama: $developerName'),
                      Text('NIM: $developerNim'),
                      const Text('Dibuat pada 28 September 2023'),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
