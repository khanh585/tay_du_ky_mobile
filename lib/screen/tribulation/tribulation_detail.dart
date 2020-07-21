import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tay_du_ky_app/dao/TribulationDAO.dart';
import 'package:tay_du_ky_app/dto/TribulationDTO.dart';
import 'package:tay_du_ky_app/screen/tribulation/tribulation.dart';
import 'package:tay_du_ky_app/screen/tribulation/tribulation_actor.dart';
import 'package:tay_du_ky_app/screen/tribulation/tribulation_tool.dart';

class DetailScreen extends StatefulWidget {
  // Declare a field that holds the Todo.
  final TribulationDTO dto;

  // In the constructor, require a Todo.
  DetailScreen({Key key, @required this.dto}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final txtName = TextEditingController();
  final txtDesc = TextEditingController();
  final txtTimes = TextEditingController();
  final txtAddress = TextEditingController();
  final txtFile = TextEditingController();
  DateTime _dateStart;
  DateTime _dateEnd;
  final df = new DateFormat('dd-MM-yyyy');
  final txtStart = TextEditingController();
  final txtEnd = TextEditingController();

  SnackBar snackBar;
  File sampleFile;
  TribulationDTO dto;
  String urlFile;

  @override
  void initState() {
    super.initState();
    dto = widget.dto;
    _dateStart = DateTime.now();
    _dateEnd = DateTime.now();

    showDTO();
  }

  @override
  void dispose() {
    txtName.dispose();
    txtDesc.dispose();
    txtTimes.dispose();
    txtAddress.dispose();
    txtStart.dispose();
    txtEnd.dispose();
    txtFile.dispose();
    super.dispose();
  }

  void _getTribulationDTO(BuildContext ctx) async {
    try {
      await fetchTribulationDTO(widget.dto.tribulation_id.toString())
          .then((result) => {
                setState(() => {dto = result}),
                showDTO()
              });
      _showSnackBar(ctx, true, 'loading..');
    } catch (Exception) {
      _showSnackBar(ctx, false, 'loading..');
      Navigator.pop(context);
    }
  }

  Future getFile(BuildContext context) async {
    await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'txt'],
    ).then((tempFile) => {
          if (tempFile != null)
            {
              print(tempFile.path),
              setState(() {
                sampleFile = tempFile;
              }),
              _uploadFirebase(context),
            }
        });

    // upload to firebase
  }

  Future _uploadFirebase(BuildContext context) async {
    List<String> temp = sampleFile.path.split('.');
    String extention = temp[temp.length - 1];
    String filename =
        'tribulation_' + widget.dto.tribulation_id.toString() + '.' + extention;
    final StorageReference firebaseRef =
        FirebaseStorage.instance.ref().child(filename);
    final StorageUploadTask task = firebaseRef.putFile(sampleFile);
    var dowurl = await (await task.onComplete).ref.getDownloadURL();
    String url = dowurl.toString();
    if (url != null || url != '') {
      _showSnackBar(context, true, 'Update file');
      setState(() {
        urlFile = url;
        txtFile.text = url;
      });
    } else {
      _showSnackBar(context, false, 'Update file');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                title: Text('Tribulation'),
                icon: Icon(
                  Icons.cloud,
                  size: 30,
                  color: Colors.blue,
                ),
                backgroundColor: Colors.blue[600]),
            BottomNavigationBarItem(
                title: Text('Actor'),
                icon: Icon(
                  Icons.person,
                  size: 30,
                  color: Colors.blue,
                ),
                backgroundColor: Colors.blue[600]),
            BottomNavigationBarItem(
                title: Text('Tool'),
                icon: Icon(
                  Icons.brush,
                  size: 30,
                  color: Colors.blue,
                ),
                backgroundColor: Colors.blue[600]),
          ],
          onTap: (value) {
            switch (value) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Tribulation()),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TribulationActor(
                            dtos: widget.dto.actor,
                            tribulationID: widget.dto.tribulation_id.toString(),
                          )),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TribulationTool(
                            dtos: widget.dto.tool,
                            tribulationID: widget.dto.tribulation_id.toString(),
                            from: widget.dto.time_start,
                            to: widget.dto.time_end,
                          )),
                );
                break;
              default:
            }
          },
        ),
        appBar: AppBar(
          title: Text('Tribulation Detail'),
          actions: <Widget>[
            Builder(
              builder: (context) => FlatButton(
                  onPressed: () => {_getTribulationDTO(context)},
                  child: Icon(Icons.refresh)),
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: txtName,
                autovalidate: true,
                validator: (value) {
                  if (value.isEmpty) return 'please enter name';
                },
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
                  try {
                    if (int.parse(value) <= 0) {
                      return "please enter number > 0";
                    }
                  } catch (e) {
                    return "please enter number";
                  }
                },
                controller: txtTimes,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Times',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: txtAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Address',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: txtStart,
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Time Start',
                ),
                onTap: () {
                  showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2050))
                      .then((value) => {
                            if (value != null)
                              {
                                setState(() {
                                  _dateStart = value;
                                  txtStart.text = df.format(_dateStart);
                                }),
                              },
                          });
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: txtEnd,
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Time End',
                ),
                onTap: () {
                  showDatePicker(
                          context: context,
                          initialDate: _dateStart,
                          firstDate: _dateStart,
                          lastDate: DateTime(2050))
                      .then((value) => {
                            if (value != null)
                              {
                                setState(() {
                                  _dateEnd = value;
                                  txtEnd.text = df.format(_dateEnd);
                                }),
                              }
                          });
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                onTap: () {},
                readOnly: true,
                controller: txtFile,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'File url',
                ),
              ),
              SizedBox(
                height: 20,
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
                        getFile(context);
                      },
                      textColor: Colors.white,
                      color: Colors.green,
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
                        padding: const EdgeInsets.fromLTRB(28, 10, 28, 10),
                        child:
                            const Text('File', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  ),
                  Builder(
                    builder: (context) => RaisedButton(
                      onPressed: () => _updateTribulation(
                          context, widget.dto.tribulation_id),
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

  _updateTribulation(BuildContext context, int tribulationID) async {
    String name = txtName.text;
    String desc = txtDesc.text;
    String address = txtAddress.text;
    String url = txtFile.text;
    String start = _dateStart.toString();
    String end = _dateEnd.toString();
    int times = int.parse(txtTimes.text);
    TribulationDTO idto = TribulationDTO(
        name: name,
        description: desc,
        address: address,
        url_file: url,
        time_start: start,
        time_end: end,
        times: times);
    try {
      await updateTribulation(tribulationID.toString(), idto).then((result) => {
            _showSnackBar(
                context, result.trim() == 'true', 'Update tribulation')
          });
    } catch (Exception) {
      _showSnackBar(context, false, 'Update tribulation');
    }
    // dispose();
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
    txtAddress.text = dto.address;
    txtStart.text = dto.time_start;
    txtEnd.text = dto.time_end;
    txtFile.text = dto.url_file != null ? dto.url_file : '';
    txtTimes.text = dto.times.toString();
  }
}
