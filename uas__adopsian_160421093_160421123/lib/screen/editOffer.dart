import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uas__adopsian_160421093_160421123/class/animal.dart';

class EditOffer extends StatefulWidget {
  Animal? adopt;

  EditOffer({super.key, required this.adopt});

  @override
  _EditOfferState createState() => _EditOfferState();
}

class _EditOfferState extends State<EditOffer> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleCont = TextEditingController();
  final TextEditingController _type = TextEditingController();
  final TextEditingController _descCont = TextEditingController();
  final TextEditingController _image = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.adopt != null) {
      print('adopt is not null');
      _titleCont.text = widget.adopt!.names;
      _type.text = widget.adopt!.types;
      _descCont.text = widget.adopt!.descriptions;
      _image.text = widget.adopt!.images;

      if (_titleCont.text.isNotEmpty &&
          _type.text.isNotEmpty &&
          _descCont.text.isNotEmpty &&
          _image.text.isNotEmpty) {
        print('Text Updated');
      } else {
        print('Updated Failed');
      }
    } else {
      print('adopt is null');
    }
  }

  Future<void> _submitData() async {
    final response = await http.post(
      Uri.parse("https://ubaya.me/flutter/160421093/updateAnimal.php"),
      body: {
        'id': widget.adopt!.id.toString(),
        'name': widget.adopt!.names,
        'type': widget.adopt!.types,
        'description': widget.adopt!.descriptions,
        'image': widget.adopt!.images,
      },
    );

    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      print(json);
      if (json['result'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Data Succes Edited')));
        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Error')));
      throw Exception('Failed to read API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit Offer"),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _titleCont,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                    onChanged: (value) {
                      widget.adopt!.names = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama harus diisi';
                      }
                      return null;
                    },
                  )),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _type,
                    decoration: const InputDecoration(
                      labelText: 'Type',
                    ),
                    onChanged: (value) {
                      widget.adopt!.images = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tipe harus diisi';
                      }
                      return null;
                    },
                  )),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _descCont,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi',
                    ),
                    onChanged: (value) {
                      widget.adopt!.descriptions = value;
                    },
                    validator: (value) {
                      if (value!.length < 30) {
                        return 'Deskripsi kurang panjang';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: 6,
                  )),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _image,
                    decoration: const InputDecoration(
                      labelText: 'Gambar',
                    ),
                    onChanged: (value) {
                      widget.adopt!.images = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Gambar harus diisi';
                      }
                      return null;
                    },
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState != null &&
                        !_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Harap Isian diperbaiki')));
                    } else {
                      _submitData();
                    }
                  },
                  child: const Text('Save Data'),
                ),
              ),
            ],
          ),
        ));
  }
}
