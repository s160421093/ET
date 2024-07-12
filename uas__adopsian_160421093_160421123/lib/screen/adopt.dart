import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uas__adopsian_160421093_160421123/class/animal.dart';
import 'package:http/http.dart' as http;

class Adopt extends StatefulWidget {
  const Adopt({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AdoptState();
  }
}

class _AdoptState extends State<Adopt> {
  String temp = 'waiting API respond…';
  List<Animal> anD = [];

  Future<String> fetchData() async {
    final response = await http.get(
        Uri.parse("https://ubaya.me/flutter/160421093/listAdopt.php"));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    Future<String> data = fetchData();
    data.then((value) {
      Map json = jsonDecode(value);
      for (var adopt in json['data']) {
        Animal ad = Animal.fromJson(adopt);
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

  Widget DaftarAdopsi(adopts) {
    if (adopts != null) {
      return ListView.builder(
          itemCount: adopts.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Card(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                    leading: Image.network(adopts[index].image,
                        width: 30, height: 30),
                    title: Text(
                        adopts[index].name + " (" + adopts[index].type + ")"),
                    subtitle:
                        Text("Description: " + adopts[index].description)),
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
      appBar: AppBar(title: const Text('List of Adopt')),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                            Text(
                              anD[i].names,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        subtitle: Text('Pemilik: ${anD[i].ownerName}'),
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
                                const Icon(Icons.people),
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