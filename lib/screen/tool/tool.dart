import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tay_du_ky_app/dao/ToolDAO.dart';
import 'package:tay_du_ky_app/dto/ToolDTO.dart';
import 'package:tay_du_ky_app/login.dart';
import 'package:tay_du_ky_app/screen/tool/tool_create.dart';
import 'package:tay_du_ky_app/screen/tool/tool_detail.dart';

class Tool extends StatefulWidget {
  @override
  _ToolState createState() => _ToolState();
}

class _ToolState extends State<Tool> {
  final GlobalKey<AnimatedListState> _key = GlobalKey();
  final GlobalKey<AnimatedListState> _refkey = GlobalKey();
  List<ToolDTO> futureListToolDTO;
  bool wait = true;
  DateTime _dateStart;
  DateTime _dateEnd;
  final df = new DateFormat('dd-MM-yyyy');
  final txtStart = TextEditingController();
  final txtEnd = TextEditingController();
  final txtStatus = TextEditingController();
  @override
  void initState() {
    wait = true;
    _dateStart = DateTime.now();
    _dateEnd = DateTime.now();
    txtStart.text = (_dateStart == null)
        ? df.format(DateTime.now())
        : df.format(_dateStart);
    txtEnd.text = df.format(_dateEnd);
    super.initState();
    _getListToolDTO();
  }

  @override
  void dispose() {
    txtStart.dispose();
    txtEnd.dispose();
    txtStatus.dispose();
    super.dispose();
  }

  Future<void> _getListToolDTO() async {
    setState(() => {futureListToolDTO = null});
    await fetchListToolDTO().then((result) => {
          setState(() => {
                wait = false,
                if (result == null)
                  {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false)
                  },
                futureListToolDTO = result,
              })
        });
  }

  Future<void> _searchToolDTO() async {
    String start = _dateStart.toString();
    String end = _dateEnd.toString();
    String status = txtStatus.text;
    setState(() => {futureListToolDTO = null, wait = true});
    await searchListToolDTO(start, end, status).then((result) => {
          if (result != null)
            {
              setState(() => {
                    wait = false,
                    futureListToolDTO = result,
                  })
            },
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addItem(),
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
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
                        firstDate: DateTime(2000),
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
              height: 5,
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
                        initialDate: DateTime.now(),
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
              height: 5,
            ),
            TextField(
              controller: txtStatus,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Status',
              ),
            ),
            SizedBox(
              height: 5,
            ),
            RaisedButton(
              onPressed: () => _searchToolDTO(),
              color: Colors.blue,
              textColor: Colors.white,
              child: Text('Search'),
            ),
            SizedBox(
              height: 5,
            ),
            RefreshIndicator(
              key: _refkey,
              onRefresh: () => _getListToolDTO(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 340,
                child: wait
                    ? Center(
                        child: CircularProgressIndicator(
                        strokeWidth: 3,
                      ))
                    : futureListToolDTO == null
                        ? Container(
                            height: 0,
                          )
                        : AnimatedList(
                            key: _key,
                            initialItemCount: futureListToolDTO.length,
                            itemBuilder: (context, index, animation) {
                              return _buildItem(
                                  futureListToolDTO[index], animation, index);
                            },
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(ToolDTO item, Animation animation, int index) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        //////
        elevation: 2,
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DetailScreen(dto: futureListToolDTO[index]),
              ),
            );
          },
          leading: CircleAvatar(
            backgroundImage: (item.image == '' || item.image == null)
                ? AssetImage('assets/images/tool.png')
                : NetworkImage(item.image),
            backgroundColor: Colors.amber,
          ),
          title: Text(
            item.name,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('quantity: ' + item.quantity.toString()),
              Text('status: ' + item.status),
            ],
          ),
          trailing: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.redAccent,
              ),
              onPressed: () {
                _removeItem(index, item.tool_id);
              }),
        ),
      ),
    );
  }

  void _removeItem(int index, int tool_id) {
    deleteTool(tool_id.toString())
        .then((result) => {_show(index, int.parse(result) > 0)});
  }

  void _show(int index, bool flag) {
    ToolDTO removedItem = futureListToolDTO.removeAt(index);
    AnimatedListRemovedItemBuilder builder = (context, animation) {
      return _buildItem(removedItem, animation, index);
    };
    _key.currentState.removeItem(index, builder);
    showNotification(flag);
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showNotification(
      bool flag) {
    Color color;
    Icon icon;
    if (flag) {
      color = Colors.green;
      icon = Icon(Icons.thumb_up);
    } else {
      color = Colors.red[300];
      icon = Icon(Icons.thumb_down);
    }
    return Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: color,
      content: Row(
        children: <Widget>[
          icon,
          SizedBox(
            width: 20,
          ),
          Expanded(child: flag ? Text('Delete Success') : Text('Delete Fail'))
        ],
      ),
    ));
  }

  void _addItem() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ToolCreate()),
    );
  }
}
