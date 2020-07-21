import 'package:flutter/material.dart';
import 'package:tay_du_ky_app/dao/ToolDAO.dart';
import 'package:tay_du_ky_app/dto/ToolDTO.dart';
import 'package:tay_du_ky_app/screen/tribulation/add_tool.dart';

class TribulationTool extends StatefulWidget {
  final List<ToolDTO> dtos;
  final String tribulationID;
  final String from;
  final String to;

  const TribulationTool(
      {Key key, this.dtos, this.tribulationID, this.from, this.to})
      : super(key: key);
  @override
  ToolState createState() => ToolState();
}

class ToolState extends State<TribulationTool> {
  final GlobalKey<AnimatedListState> _key = GlobalKey();
  List<ToolDTO> listcurrentTool;
  final GlobalKey<AnimatedListState> _refkey = GlobalKey();

  @override
  void initState() {
    listcurrentTool = widget.dtos;
    super.initState();
  }

  Future<void> _getListToolDTO() async {
    setState(() => {listcurrentTool = null});
    await fetchListToolDTOByTribulation(widget.tribulationID).then((result) => {
          if (result != null)
            {
              setState(() => {listcurrentTool = result})
            },
        });
  }

  void setStateDrop(value) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tribulation Tool'),
        actions: <Widget>[
          FlatButton(
            child: Icon(Icons.refresh),
            onPressed: () => _getListToolDTO(),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddTool(
                      tribulationID: widget.tribulationID,
                    )),
          );
        },
        child: Icon(Icons.add),
      ),
      body: RefreshIndicator(
        key: _refkey,
        onRefresh: () => _getListToolDTO(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 120,
          child: listcurrentTool == null
              ? Center(
                  child: Text(
                  "Loading...",
                  style: TextStyle(fontSize: 25),
                ))
              : listcurrentTool.length == 0
                  ? Center(
                      child: Text(
                      "Don't have tool",
                      style: TextStyle(fontSize: 25),
                    ))
                  : AnimatedList(
                      key: _key,
                      initialItemCount: listcurrentTool.length,
                      itemBuilder: (context, index, animation) {
                        return _buildItem(
                            listcurrentTool[index], animation, index);
                      },
                    ),
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
              Column(
                children: <Widget>[
                  Text('from: ' + widget.from),
                  Text('to: ' + widget.to),
                ],
              )
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

  Future<void> _removeItem(int index, int tool_id) async {
    await removeTool('7', tool_id.toString())
        .then((result) => {_show(index, result)});
  }

  void _show(int index, bool flag) {
    ToolDTO removedItem = listcurrentTool.removeAt(index);
    AnimatedListRemovedItemBuilder builder = (context, animation) {
      return _buildItem(removedItem, animation, index);
    };
    _key.currentState.removeItem(index, builder);
  }
}
