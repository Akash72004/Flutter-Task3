import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task_3',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.yellow, // Set your desired primary color
      ),
      home: const MyHomePage(title: 'Input Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var inputtxt = TextEditingController();
  List<Map<String, dynamic>> users = [];

  Future<void> fetchUsers(int count) async {
    final response =
        await http.get(Uri.parse('https://randomuser.me/api/?results=$count'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        users = List.from(data['results']);
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello'),
      ),
      body: Center(
        child: Container(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Enter Number of Users:'),
              SizedBox(height: 11), // Add spacing with SizedBox
              TextField(
                keyboardType: TextInputType.number,
                controller: inputtxt,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(21),
                    borderSide: BorderSide(
                      color: Colors.deepOrange,
                      width: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 11,
              ),
              ElevatedButton(
                onPressed: () {
                  var num = int.tryParse(inputtxt.text);
                  if (num != null) {
                    navigateToUserListPage(num);
                  } else {
                    print("Invalid input: Please enter a valid number.");
                  }
                },
                child: Text('OK'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void navigateToUserListPage(int num) {
    fetchUsers(num); // Fetch users based on the input
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UserListPage(users: users),
      ),
    );
  }
}

class UserListPage extends StatelessWidget {
  final List<Map<String, dynamic>> users;

  UserListPage({required this.users});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) {
          final user = users[index];
          final fullName = '${user['name']['first']} ${user['name']['last']}';
          return ListTile(
            title: Text(fullName),
            // Add more widgets to display other user information as needed
          );
        },
      ),
    );
  }
}
