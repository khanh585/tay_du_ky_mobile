import 'package:flutter/material.dart';
import 'package:tay_du_ky_app/dao/TribulationDAO.dart';
import 'package:tay_du_ky_app/dto/TribulationDTO.dart';
import 'package:tay_du_ky_app/login.dart';
import 'package:tay_du_ky_app/screen/tribulation/tribulation_create.dart';
import 'package:tay_du_ky_app/screen/tribulation/tribulation_detail.dart';

class Tribulation extends StatefulWidget {
  @override
  _TribulationState createState() => _TribulationState();
}

class _TribulationState extends State<Tribulation> {
  final GlobalKey<AnimatedListState> _key = GlobalKey();
  final GlobalKey<AnimatedListState> _refkey = GlobalKey();
  List<TribulationDTO> futureListTribulationDTO;
  bool wait = true;
  // Future<List<TribulationDTO>> futureListTribulationDTO;
  @override
  void initState() {
    wait = true;
    super.initState();
    _getListTribulationDTO();
  }

  Future<void> _getListTribulationDTO() async {
    setState(() => {futureListTribulationDTO = null});
    await fetchListTribulationDTO().then((result) => {
          setState(() => {
                wait = false,
                if (result == null)
                  {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false)
                  },
                futureListTribulationDTO = result,
              })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TribulationCreate()),
          )
        },
        child: Icon(Icons.add),
      ),
      body: RefreshIndicator(
        key: _refkey,
        onRefresh: () => _getListTribulationDTO(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 120,
          child: wait
              ? Center(
                  child: CircularProgressIndicator(
                  strokeWidth: 3,
                ))
              : futureListTribulationDTO == null ||
                      futureListTribulationDTO.length == 0
                  ? Center(
                      child: Text('No Tribulation'),
                    )
                  : AnimatedList(
                      key: _key,
                      initialItemCount: futureListTribulationDTO.length,
                      itemBuilder: (context, index, animation) {
                        return _buildItem(
                            futureListTribulationDTO[index], animation, index);
                      },
                    ),
        ),
      ),
    );
  }

  Widget _buildItem(TribulationDTO item, Animation animation, int index) {
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
                    DetailScreen(dto: futureListTribulationDTO[index]),
              ),
            );
          },
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/images/mountain.png'),
            backgroundColor: Colors.amber,
          ),
          title: Text(
            item.name,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text('start:  ' + item.time_start.toString()),
                  Text('end:  ' + item.time_end.toString()),
                ],
              ),
            ],
          ),
          trailing: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.redAccent,
              ),
              onPressed: () {
                _removeItem(index, item.tribulation_id);
              }),
        ),
      ),
    );
  }

  void _removeItem(int index, int tool_id) {
    deleteTribulation(tool_id.toString())
        .then((result) => {_show(index, int.parse(result) > 0)});
  }

  void _show(int index, bool flag) {
    TribulationDTO removedItem = futureListTribulationDTO.removeAt(index);
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
      MaterialPageRoute(builder: (context) => TribulationCreate()),
    );
  }
}
