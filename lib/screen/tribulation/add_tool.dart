import 'package:flutter/material.dart';
import 'package:tay_du_ky_app/dao/ToolDAO.dart';
import 'package:tay_du_ky_app/dto/ToolDTO.dart';

class AddTool extends StatefulWidget {
  final String tribulationID;

  const AddTool({Key key, this.tribulationID}) : super(key: key);
  @override
  _ToolState createState() => _ToolState();
}

class _ToolState extends State<AddTool> {
  final txtQuantity = TextEditingController();
  List<ToolDTO> listTool;
  String _tool;
  bool wait = false;
  @override
  void initState() {
    _getListToolDTO();
    super.initState();
  }

  @override
  void dispose() {
    txtQuantity.dispose();
    super.dispose();
  }

  // Future<List<ToolDTO>> listTool;

  Future<void> _getListToolDTO() async {
    setState(() {
      wait = true;
    });
    setState(() => {listTool = null});
    await fetchListToolDTO().then((result) => {
          if (result != null)
            {
              setState(() {
                listTool = result;
                _tool = result[0].tool_id.toString();
                wait = false;
              }),
            },
          print(listTool)
        });
  }

  Future<void> _addTool(context) async {
    try {
      int quantity = int.parse(txtQuantity.text);
      await addToolIntoTribulation(widget.tribulationID, _tool, quantity)
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
          Expanded(child: Text('Add tool ' + status))
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
        body: listTool == null
            ? Center(
                child: wait
                    ? CircularProgressIndicator(
                        strokeWidth: 3,
                      )
                    : FlatButton(
                        child: Text('Refresh'),
                        onPressed: () => {
                          _getListToolDTO(),
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
                        value: _tool,
                        style: TextStyle(fontSize: 20, color: Colors.black54),
                        hint: Text('Select Tool'),
                        onChanged: (String newValue) {
                          setState(() {
                            _tool = newValue;
                            print(_tool);
                          });
                        },
                        items: listTool?.map((item) {
                              return DropdownMenuItem(
                                child: Text(item.name),
                                value: item.tool_id.toString(),
                              );
                            })?.toList() ??
                            [],
                      ),
                    )),
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
                    Builder(
                      builder: (context) => RaisedButton(
                          color: Colors.blue,
                          onPressed: () => _addTool(context),
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
