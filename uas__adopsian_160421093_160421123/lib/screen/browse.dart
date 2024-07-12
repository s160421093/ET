import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uas__adopsian_160421093_160421123/class/animal.dart';

class Browse extends StatefulWidget {
  const Browse({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BrowseState();
  }
}

class _BrowseState extends State<Browse> {
  String temp = 'waiting API respond…';
  List<Animal> ADopt = [];

  Future<String> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse("https://ubaya.me/flutter/160421093/animalList.php"),
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
    data.then((value) {
      Map json = jsonDecode(value);
      for (var adopt in json['data']) {
        Animal anD = Animal.fromJson(adopt);
        ADopt.add(anD);
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  Widget ListAnimal(listAnimal) {
    if (listAnimal != null) {
      return ListView.builder(
          itemCount: listAnimal.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Card(
                margin: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: Text(listAnimal[index].names +" (" +listAnimal[index].types +")"),
                      subtitle: Text(listAnimal[index].descriptions),
                    ),
                    Image.network(listAnimal[index].images),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[100],
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            String description = '';
                            return AlertDialog(
                              title: const Text('Enter Description'),
                              content: TextField(
                                maxLines:null,
                                onChanged: (value) {
                                  description = value;
                                },
                                decoration: const InputDecoration(
                                    hintText:
                                        'Masukkan kata-kata untuk meyakinkan pemilik'),
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  onPressed: () async {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    final response = await http.post(
                                      Uri.parse(
                                          "https://ubaya.me/flutter/160421093/proposeAnimal.php"),
                                      body: {
                                        'id': listAnimal[index].id.toString(),
                                        'userID':
                                            prefs.getInt("user_id").toString(),
                                        'description': description,
                                      },
                                    );
                                    if (response.statusCode == 200) {
                                      Map json = jsonDecode(response.body);
                                      print(json);
                                      if (json['result'] == 'success') {
                                        if (!mounted) return;
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Sukses Propose Hewan')));
                                        Navigator.pop(context);
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text('Error')));
                                      throw Exception('Failed to read API');
                                    }
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Submit'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text('Propose Hewan Ini'),
                    )
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
        appBar: AppBar(title: const Text('Browse')),
        body: ListView(children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height - 200,
            child: ListAnimal(ADopt),
          )
        ]));
  }
}
