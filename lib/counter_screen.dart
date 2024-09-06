import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'login_screen.dart'; // Import the LoginScreen

class CounterScreen extends StatefulWidget {
  final String username;
  CounterScreen({required this.username});

  @override
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _counter = 0;
  final DBHelper _dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    _loadUserCount();
  }

  void _loadUserCount() async {
    int? count = await _dbHelper.getUserCount(widget.username);
    setState(() {
      _counter = count ?? 0;
    });
  }

  void _incrementCounter() async {
    setState(() {
      _counter++;
    });
    await _dbHelper.updateUserCount(widget.username, _counter);
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 300,
              child: Image.asset("assets/increment.png"),
            ),
            Text('Hello, ${widget.username}!', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            Text(
              'You have clicked the button $_counter times.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}

