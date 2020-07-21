import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tay_du_ky_app/dao/TribulationDAO.dart';
import 'package:tay_du_ky_app/dto/TribulationDTO.dart';

class TribulationCreate extends StatefulWidget {
  final TribulationDTO dto;

  const TribulationCreate({Key key, this.dto}) : super(key: key);

  @override
  _TribulationState createState() => _TribulationState();
}

class _TribulationState extends State<TribulationCreate> {
  final txtName = TextEditingController();
  final txtDesc = TextEditingController();
  final txtTimes = TextEditingController();
  final txtAddress = TextEditingController();
  DateTime _dateStart;
  DateTime _dateEnd;
  final df = new DateFormat('dd-MM-yyyy');
  final txtStart = TextEditingController();
  final txtEnd = TextEditingController();
  SnackBar snackBar;

  @override
  void initState() {
    _dateStart = DateTime.now();
    _dateEnd = DateTime.now();
    txtStart.text = (_dateStart == null)
        ? df.format(DateTime.now())
        : df.format(_dateStart);
    txtEnd.text = df.format(_dateEnd);
    super.initState();
  }

  @override
  void dispose() {
    txtName.dispose();
    txtDesc.dispose();
    txtTimes.dispose();
    txtAddress.dispose();
    txtStart.dispose();
    txtEnd.dispose();
    super.dispose();
  }

  Future<void> _createTribulation(context) async {
    String name = txtName.text;
    String desc = txtDesc.text;
    String address = txtAddress.text;
    String start = _dateStart.toString();
    String end = _dateEnd.toString();
    int times = int.parse(txtTimes.text);

    TribulationDTO dto = TribulationDTO(
        name: name,
        description: desc,
        address: address,
        times: times,
        time_start: start,
        time_end: end);
    try {
      await createTribulation(dto)
          .then((result) => {_showSnackBar(context, result > 0)});
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
          title: Text("Create Tool"),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              TextFormField(
                autovalidate: true,
                validator: (value) {
                  if (value.isEmpty) {
                    return "please enter";
                  }
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
                      onPressed: () => _createTribulation(context),
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
                        child: const Text('Summit',
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
}
