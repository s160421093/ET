import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uas__adopsian_160421093_160421123/class/animal.dart';
import 'package:uas__adopsian_160421093_160421123/screen/decision.dart';
import 'package:uas__adopsian_160421093_160421123/screen/editoffer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Offer extends StatefulWidget {
  const Offer({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AdoptState();
  }
}

class _AdoptState extends State<Offer> {
  String temp = 'waiting API respond…';
  List<Animal> anD = [];

  Future<String> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse(
        "https://ubaya.me/flutter/160421093/listOffer.php",
      ),
      body: {
        'id': prefs.getInt("user_id").toString(),
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    Future<String> data = fetchData();
    anD.clear();
    data.then((value) {
      Map json = jsonDecode(value);
      print(json);
      for (var mov in json['data']) {
        Animal ad = Animal.fromJson(mov);
        anD.add(ad);
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  Widget DaftarAdopsi(PopMovs) {
    if (PopMovs != null) {
      return ListView.builder(
          itemCount: PopMovs.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Card(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.pets, size: 30),
                  title: Text(PopMovs[index].name),
                ),
              ],
            ));
          });
    } else {
      return const CircularProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List Offer')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "new_offer");
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.add),
                        SizedBox(width: 8),
                        Text('Create New Offer'),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Builder(builder: (context) {
              List<Widget> listCard = [];
              for (var i = 0; i < anD.length; i++) {
                listCard.add(Card(
                  margin: const EdgeInsets.all(18),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.pets, size: 30),
                        title: Row(
                          children: [
                            Text(anD[i].names,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditOffer(adopt: anD[i]),
                                      ),
                                    )
                                    .then((value) => bacaData());
                              },
                              icon: const Icon(
                                Icons.edit,
                                size: 18,
                              ),
                            )
                          ],
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue[100],
                          ),
                          child: Text(
                            anD[i].status.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const Divider(),
                      Image.network(anD[i].images),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.green[100],
                            ),
                            child: Text(
                              anD[i].types,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.red[100],
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.trending_up_outlined),
                                const SizedBox(width: 8),
                                Text(
                                  anD[i].userCount.toString(),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (anD[i].selectedUserName != "")
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Diadopsi oleh '),
                            Text(anD[i].selectedUserName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      if (anD[i].selectedUserName == "")
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[100],
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Decision(animAdopt: anD[i]),
                                    ),
                                  )
                                  .then((value) => bacaData());
                            },
                            child: const Row(
                              children: [
                                Icon(Icons.question_mark),
                                SizedBox(width: 8),
                                Text('Choose Adopter'),
                              ],
                            ),
                          ),
                        ),
                      ListTile(
                        title: Text(anD[i].descriptions),
                      ),
                    ],
                  ),
                ));
              }
              return Column(
                children: listCard,
              );
            }),
          ],
        ),
      ),
    );
  }
}
