import 'package:flutter/material.dart';
import 'package:tay_du_ky_app/dao/ToolDAO.dart';
import 'package:tay_du_ky_app/dto/ToolDTO.dart';

class ToolCreate extends StatefulWidget {
  final ToolDTO dto;

  const ToolCreate({Key key, this.dto}) : super(key: key);
  @override
  _ToolState createState() => _ToolState();
}

class _ToolState extends State<ToolCreate> {
  final txtName = TextEditingController();
  final txtDesc = TextEditingController();
  final txtQuantity = TextEditingController();
  final txtStatus = TextEditingController();
  SnackBar snackBar;
  @override
  void dispose() {
    txtName.dispose();
    txtDesc.dispose();
    txtQuantity.dispose();
    txtStatus.dispose();
    super.dispose();
  }

  void _createTool(context) {
    String name = txtName.text;
    String desc = txtDesc.text;
    String status = txtStatus.text;
    int quantity = int.parse(txtQuantity.text);
    ToolDTO dto = ToolDTO(
        name: name, description: desc, status: status, quantity: quantity);
    try {
      createTool(dto).then((result) => {_showSnackBar(context, result > 0)});
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
              TextField(
                controller: txtQuantity,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Quantity',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: txtStatus,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Status',
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
                      onPressed: () => _createTool(context),
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
