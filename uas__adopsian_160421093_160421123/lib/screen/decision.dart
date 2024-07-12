import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uas__adopsian_160421093_160421123/class/animal.dart';

class Decision extends StatefulWidget {
  Animal? animAdopt;
  Decision({super.key, required this.animAdopt});

  @override
  State<Decision> createState() => _DecisionState();
}

class _DecisionState extends State<Decision> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Decision'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(widget.animAdopt!.names,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.green[100],
                ),
                child: Text(
                  widget.animAdopt!.types,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              Text(widget.animAdopt!.descriptions),
              const Divider(),
              Image.network(widget.animAdopt!.images),
              const Divider(),
              const Text('Akan diadopsi oleh'),
              Builder(builder: (context) {
                List<Widget> listWidget = [];
                for (var i = 0; i < widget.animAdopt!.userlist.length; i++) {
                  UserList user = widget.animAdopt!.userlist[i];
                  listWidget.add(ListTile(
                    leading:Text("#${i + 1}", style: const TextStyle(fontSize: 20)),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(user.name),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            final response = await http.post(
                              Uri.parse(
                                  "https://ubaya.me/flutter/160421093/decision.php"),
                              body: {
                                'id': widget.animAdopt!.id.toString(),
                                'status': 'adopted',
                                'selectAdoptID': user.userId.toString(),
                              },
                            );
                            if (response.statusCode == 200) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Sukses Adopsikan Hewan')));
                              Navigator.pop(context);
                            } else {
                              throw Exception('Failed to read API');
                            }
                          },
                          child: const Text("Adopsikan"),
                        ),
                      ],
                    ),
                    subtitle: Text(user.description),
                  ));
                }
                return Column(
                  children: listWidget,
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
