import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tay_du_ky_app/dao/ActorDAO.dart';
import 'package:tay_du_ky_app/dto/ActorDTO.dart';
import 'package:tay_du_ky_app/util/config.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<ProfileScreen> {
  final txtName = TextEditingController();
  final txtDesc = TextEditingController();
  final txtEmail = TextEditingController();
  final txtPhone = TextEditingController();
  final txtRole = TextEditingController();

  SnackBar snackBar;
  File sampleImage;
  String urlImage;
  ActorDTO dto;

  @override
  void initState() {
    _getActorDTO(context);
    super.initState();
  }

  @override
  void dispose() {
    txtName.dispose();
    txtDesc.dispose();
    txtEmail.dispose();
    txtPhone.dispose();
    txtRole.dispose();

    super.dispose();
  }

  void _getActorDTO(BuildContext ctx) async {
    try {
      await fetchActorDTO(USER_ID).then((result) => {
            setState(() => {dto = result}),
            showDTO()
          });
    } catch (Exception) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
        body: Container(
      padding: EdgeInsets.all(10),
      child: dto == null
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
              ),
            )
          : ListView(
              children: <Widget>[
                Container(
                  height: 210,
                  child: Center(
                    child: (dto.image == null || dto.image == '')
                        ? sampleImage != null
                            ? Image.file(
                                sampleImage,
                                height: 200,
                              )
                            : Center(
                                child: Text(
                                  'No Image',
                                  style: TextStyle(fontSize: 20),
                                ),
                              )
                        : Container(
                            height: 150,
                            width: 150,
                            child: CircleAvatar(
                                backgroundImage: NetworkImage(urlImage))),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: txtName,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: txtDesc,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: txtEmail,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: txtPhone,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: txtRole,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Role',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
    ));
  }

  void showDTO() {
    txtName.text = dto.name;
    txtDesc.text = dto.description;
    txtEmail.text = dto.email;
    txtRole.text = dto.role;
    txtPhone.text = dto.phone;
  }
}
