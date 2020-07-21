import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tay_du_ky_app/dao/ActorDAO.dart';
import 'package:tay_du_ky_app/dto/ActorDTO.dart';

class DetailScreen extends StatefulWidget {
  // Declare a field that holds the Todo.
  final ActorDTO dto;

  // In the constructor, require a Todo.
  DetailScreen({Key key, @required this.dto}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
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
    super.initState();
    dto = widget.dto;
    urlImage = widget.dto.image;
    showDTO();
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
      await fetchActorDTO(widget.dto.actor_id.toString()).then((result) => {
            setState(() => {dto = result}),
            showDTO()
          });
      _showSnackBar(ctx, true, 'loading..');
    } catch (Exception) {
      _showSnackBar(ctx, false, 'loading..');
      Navigator.pop(context);
    }
  }

  Future getImage(BuildContext context) async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = tempImage;
    });

    //upload to firebase
    _uploadFirebase(context);
  }

  Future _uploadFirebase(BuildContext context) async {
    String filename = 'actor_' + widget.dto.actor_id.toString() + '.jpg';
    final StorageReference firebaseRef =
        FirebaseStorage.instance.ref().child(filename);
    final StorageUploadTask task = firebaseRef.putFile(sampleImage);
    var dowurl = await (await task.onComplete).ref.getDownloadURL();
    String url = dowurl.toString();
    if (url != null || url != '') {
      _showSnackBar(context, true, 'Update image');
      setState(() {
        urlImage = url;
      });
    } else {
      _showSnackBar(context, false, 'Update image');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
        appBar: AppBar(
          title: Text('actor Detail'),
          actions: <Widget>[
            Builder(
              builder: (context) => FlatButton(
                  onPressed: () => {_getActorDTO(context)},
                  child: Icon(Icons.refresh)),
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Container(
                height: 310,
                child: Center(
                  child: (widget.dto.image == null || widget.dto.image == '')
                      ? sampleImage != null
                          ? Image.file(
                              sampleImage,
                              height: 300,
                            )
                          : Center(
                              child: Text(
                                'No Image',
                                style: TextStyle(fontSize: 20),
                              ),
                            )
                      : Image(image: NetworkImage(urlImage)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) return "please enter";
                },
                autovalidate: true,
                controller: txtName,
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
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                autovalidate: true,
                validator: (value) {
                  if (!value.contains('@') || value.isEmpty)
                    return 'please enter email';
                },
                controller: txtEmail,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(7),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(50, 60, 100, .5),
                            blurRadius: 10,
                            offset: Offset(0, 7),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child:
                          const Text('Cancel', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  Builder(
                    builder: (context) => RaisedButton(
                      onPressed: () {
                        getImage(context);
                      },
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(7),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(50, 60, 100, .5),
                              blurRadius: 10,
                              offset: Offset(0, 7),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(10.0),
                        child:
                            const Text('Image', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  ),
                  Builder(
                    builder: (context) => RaisedButton(
                      onPressed: () =>
                          _updateactor(context, widget.dto.actor_id),
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(7),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(50, 60, 100, .5),
                              blurRadius: 10,
                              offset: Offset(0, 7),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(10.0),
                        child: const Text('Update',
                            style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ));
  }

  _updateactor(BuildContext context, int actorID) {
    String name = txtName.text;
    String desc = txtDesc.text;
    String phone = txtPhone.text;
    String email = txtEmail.text;
    String role = txtRole.text;
    ActorDTO dto = ActorDTO(
      name: name,
      description: desc,
      email: email,
      image: urlImage,
      role: role,
      phone: phone,
    );
    try {
      updateActor(actorID.toString(), dto)
          .then((result) => {_showSnackBar(context, result, 'Update actor')});
    } catch (Exception) {
      print('eeeeeeeeeeeeeeeeeeeeeee');
      _showSnackBar(context, false, 'Update actor');
    }
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _showSnackBar(
      context, bool flag, String msg) {
    Color color;
    Icon icon;
    String status = '';
    if (flag) {
      color = Colors.green;
      icon = Icon(Icons.thumb_up);
      status = 'Success';
    } else {
      color = Colors.red[300];
      icon = Icon(Icons.thumb_down);
      status = 'Fail';
    }
    return Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: color,
      content: Row(
        children: <Widget>[
          icon,
          SizedBox(
            width: 20,
          ),
          Expanded(child: Text(msg + ' ' + status))
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
