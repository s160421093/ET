import 'package:flutter/material.dart';
import 'package:uas__adopsian_160421093_160421123/screen/adopt.dart';
import 'package:uas__adopsian_160421093_160421123/screen/browse.dart';
import 'package:uas__adopsian_160421093_160421123/screen/editoffer.dart';
import 'package:uas__adopsian_160421093_160421123/screen/login.dart';
import 'package:uas__adopsian_160421093_160421123/screen/newoffer.dart';
import 'package:uas__adopsian_160421093_160421123/screen/offer.dart';
import 'package:shared_preferences/shared_preferences.dart';

int active_user = -1;
String _user_name = "Paulus Kurnianto";

Future<int> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  int userId = prefs.getInt("user_id") ?? -1;
  _user_name = prefs.getString("user_name") ?? '';
  return userId;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((int result) {
    if (result == -1) {
      runApp(const Login());
    } else {
      active_user = result;
      runApp(const MyApp());
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 183, 58, 58)),
        useMaterial3: true,
      ),
      routes: {
        'adopt': (context) => Adopt(),
        'browse': (context) => Browse(),
        'offer': (context) => const Offer(),
        'new_offer': (context) => const NewOffer(),
        'edit_offer': (context) => EditOffer(adopt: null),
      },
      home: const MyHomePage(title: 'Adopsian'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _user_id = -1;

  @override
  void initState() {
    super.initState();
    checkUser().then((value) => setState(
          () {
            _user_id = value;
          },
        ));
  }

  void goBrowse() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("user_id", _user_id);
    main();
  }

  void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("user_id");
    main();
  }

  Widget funDrawer() {
    return Drawer(
      elevation: 16.0,
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
              accountName: Text(_user_name),
              accountEmail: const Text(""),
              currentAccountPicture: const CircleAvatar(
                  backgroundImage: NetworkImage("https://i.pravatar.cc/800"))),
          ListTile(
              title: const Text("Logout"),
              leading: const Icon(Icons.logout),
              onTap: () {
                doLogout();
              })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: funDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              color: Colors.blue,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "adopt");
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Adopt",
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(
                      width: 12,
                      height: 72,
                    ),
                    Icon(Icons.pets)
                  ],
                ),
              ),
            ),
            Card(
              color: Colors.blue,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "offer");
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Offer",
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(
                      width: 12,
                      height: 72,
                    ),
                    Icon(Icons.handshake)
                  ],
                ),
              ),
            ),
            Card(
              color: Colors.blue,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "browse");
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Browse",
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(
                      width: 12,
                      height: 72,
                    ),
                    Icon(Icons.search)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
