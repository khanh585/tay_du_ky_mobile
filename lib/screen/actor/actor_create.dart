import 'package:flutter/material.dart';
import 'package:tay_du_ky_app/dao/ActorDAO.dart';
import 'package:tay_du_ky_app/dto/ActorDTO.dart';
import 'package:tay_du_ky_app/screen/tribulation/tribulation_tool.dart';

class ActorCreate extends StatefulWidget {
  final ActorDTO dto;

  const ActorCreate({Key key, this.dto}) : super(key: key);
  @override
  _ActorState createState() => _ActorState();
}

class _ActorState extends State<ActorCreate> {
  final txtName = TextEditingController();
  final txtDesc = TextEditingController();
  final txtEmail = TextEditingController();
  final txtRole = TextEditingController();
  final txtPhone = TextEditingController();
  final txtPassword = TextEditingController();
  bool waitCreate = false;

  SnackBar snackBar;
  @override
  void dispose() {
    txtName.dispose();
    txtDesc.dispose();
    txtEmail.dispose();
    txtRole.dispose();
    txtPhone.dispose();
    txtPassword.dispose();
    super.dispose();
  }

  void _createActor(context) {
    String name = txtName.text;
    String desc = txtDesc.text;
    String email = txtEmail.text;
    String phone = txtPhone.text;
    String role = txtRole.text;
    ActorDTO dto = ActorDTO(
        name: name, description: desc, email: email, phone: phone, role: role);
    try {
      createActor(dto).then((result) => {_showSnackBar(context, result > 0)});
    } catch (Exception) {
      _showSnackBar(context, false);
    }
    // dispose();
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _showSnackBar(
      context, bool flag) {
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
          Expanded(child: Text('Create ' + status))
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Create Actor"),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              TextFormField(
                autovalidate: true,
                validator: (value) {
                  if (value.isEmpty) return "Please enter";
                },
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
                obscureText: true,
                controller: txtPassword,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {},
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
                        if (!waitCreate) {
                          setState(() {
                            waitCreate = true;
                          });
                          _createActor(context);
                        }
                      },
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
                        child: waitCreate
                            ? CircularProgressIndicator(
                                strokeWidth: 3,
                              )
                            : Text('Summit', style: TextStyle(fontSize: 20)),
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
}
