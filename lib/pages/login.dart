import 'package:catat_duit/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final String initialUsername = 'user'; // Username awal
  String initialPassword =
      'user'; // Password awal, dapat diubah melalui pengaturan

  Future<void> _checkInitialPassword() async {
    final Database database = await openDatabase(
      'catat_duit.db',
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY, username TEXT, password TEXT)',
        );
        await db.insert(
          'users',
          {'username': initialUsername, 'password': initialPassword},
        );
      },
    );

    final List<Map<String, dynamic>> result = await database.query(
      'users',
      where: 'username = ?',
      whereArgs: [_usernameController.text],
    );

    if (result.isNotEmpty) {
      final Map<String, dynamic> user = result.first;
      if (user['password'] == _passwordController.text) {
        // Jika username dan password cocok, buka halaman 'Home'
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      } else {
        // Jika password salah, tampilkan pesan kesalahan
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Login Gagal'),
              content: const Text('Password salah.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      // Jika username tidak ditemukan, tampilkan pesan kesalahan
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Login Gagal'),
            content: const Text('Username tidak ditemukan.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[50],
      body: ListView(
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 32.0),
                const Text(
                  'Selamat Datang',
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
                const Text(
                  'Silahkan isi username dan password!',
                  style: TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 32.0),
                Column(
                  children: [
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                      ),
                    ),
                    const SizedBox(height: 32.0),
                    ElevatedButton(
                      onPressed: _checkInitialPassword,
                      child: const Text('Login'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
