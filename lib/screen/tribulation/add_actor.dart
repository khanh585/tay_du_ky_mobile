import 'package:flutter/material.dart';
import 'package:tay_du_ky_app/dao/ActorDAO.dart';
import 'package:tay_du_ky_app/dto/ActorDTO.dart';
import 'package:tay_du_ky_app/dto/ActorDTO.dart';

class AddActor extends StatefulWidget {
  final String tribulationID;

  const AddActor({Key key, this.tribulationID}) : super(key: key);
  @override
  _ActorState createState() => _ActorState();
}

class _ActorState extends State<AddActor> {
  final txtName = TextEditingController();
  List<ActorDTO> listActor;
  String _actor;
  bool wait = false;
  @override
  void initState() {
    _getListActorDTO();
    super.initState();
  }

  @override
  void dispose() {
    txtName.dispose();
    super.dispose();
  }

  // Future<List<ActorDTO>> listActor;

  Future<void> _getListActorDTO() async {
    setState(() {
      wait = true;
    });
    setState(() => {listActor = null});
    await fetchListActorDTO().then((result) => {
          if (result != null)
            {
              setState(() {
                listActor = result;
                _actor = result[0].actor_id.toString();
                wait = false;
              }),
            },
          print(listActor)
        });
  }

  Future<void> _addActor(context) async {
    try {
      String name = txtName.text;
      await addActorIntoTribulation(widget.tribulationID, _actor, name)
          .then((result) => {
                if (result.trim() == 'true')
                  {_showSnackBar(context, true)}
                else
                  {_showSnackBar(context, false)}
              });
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
          Expanded(child: Text('Add Actor ' + status))
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
        body: listActor == null
            ? Center(
                child: wait
                    ? CircularProgressIndicator(
                        strokeWidth: 3,
                      )
                    : FlatButton(
                        child: Text('Refresh'),
                        onPressed: () => {
                          _getListActorDTO(),
                        },
                      ),
              )
            : Container(
                padding: EdgeInsets.all(10),
                child: ListView(
                  children: <Widget>[
                    DropdownButtonHideUnderline(
                        child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        value: _actor,
                        style: TextStyle(fontSize: 20, color: Colors.black54),
                        hint: Text('Select Actor'),
                        onChanged: (String newValue) {
                          setState(() {
                            _actor = newValue;
                            print(_actor);
                          });
                        },
                        items: listActor?.map((item) {
                              return DropdownMenuItem(
                                child: Text(item.name),
                                value: item.actor_id.toString(),
                              );
                            })?.toList() ??
                            [],
                      ),
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: txtName,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Name',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Builder(
                      builder: (context) => RaisedButton(
                          color: Colors.blue,
                          onPressed: () => _addActor(context),
                          textColor: Colors.white,
                          padding: const EdgeInsets.all(0.0),
                          child: Text('Add')),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ));
  }
}
