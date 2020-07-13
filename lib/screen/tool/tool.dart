import 'package:flutter/material.dart';
import 'package:tay_du_ky_app/dao/ToolDAO.dart';
import 'package:tay_du_ky_app/dto/ToolDTO.dart';
import 'package:tay_du_ky_app/login.dart';
import 'package:tay_du_ky_app/screen/tool/tool_create.dart';
import 'package:tay_du_ky_app/screen/tool/tool_detail.dart';
import 'package:tay_du_ky_app/util/config.dart';

class Tool extends StatefulWidget {
  @override
  _ToolState createState() => _ToolState();
}

class _ToolState extends State<Tool> {
  final GlobalKey<AnimatedListState> _key = GlobalKey();
  List<ToolDTO> futureListToolDTO;
  // Future<List<ToolDTO>> futureListToolDTO;
  @override
  void initState() {
    super.initState();
    _getListToolDTO();
  }

  void _getListToolDTO() {
    setState(() => {futureListToolDTO = null});
    fetchListToolDTO().then((result) => {
          setState(() => {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              title: Text(''),
              icon: Icon(
                Icons.refresh,
                size: 0,
              ),
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              title: Text('Refresh'),
              icon: Icon(
                Icons.refresh,
                size: 30,
                color: Colors.blue,
              ),
              backgroundColor: Colors.blue[600]),
          BottomNavigationBarItem(
              title: Text(''),
              icon: Icon(
                Icons.refresh,
                size: 0,
              ),
              backgroundColor: Colors.white)
        ],
        onTap: (value) {
          _getListToolDTO();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addItem(),
        child: Icon(Icons.add),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height - 120,
        child: futureListToolDTO == null
            ? Center(
                child: Text(
                "Loading...",
                style: TextStyle(fontSize: 25),
              ))
            : AnimatedList(
                key: _key,
                initialItemCount: futureListToolDTO.length,
                itemBuilder: (context, index, animation) {
                  return _buildItem(futureListToolDTO[index], animation, index);
                },
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
