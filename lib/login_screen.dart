import 'package:flutter/material.dart';
import 'counter_screen.dart';
import 'db_helper.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DBHelper _dbHelper = DBHelper();
  bool _passwordVisible = false;

  void _login() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isNotEmpty && password.isNotEmpty) {
      bool userExists = await _dbHelper.checkUserExists(username);

      if (userExists) {
        String? storedPassword = await _dbHelper.getUserPassword(username);
        if (storedPassword != null && storedPassword == password) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CounterScreen(username: username),
            ),
          );
        } else {
          _showError('Incorrect password. Please try again.');
        }
      } else {
        await _dbHelper.insertOrUpdateUser(username, password);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CounterScreen(username: username),
          ),
        );
      }
    } else {
      _showError('Please enter both username and password.');
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300,
              child: Image.asset("assets/login.png"),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: 'Enter your username',
                labelText: 'Username or Email',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: 'Enter your password',
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
              ),
              obscureText: !_passwordVisible,
            ),
            SizedBox(height: 20),Align(alignment: Alignment.center,
           child:  ElevatedButton(
              onPressed: _login,
              child: Text('Login',),
            ),
            ),
          ],
        ),
      ),
    );
  }
}
