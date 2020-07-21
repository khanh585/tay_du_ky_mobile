import 'package:flutter/material.dart';
import 'package:tay_du_ky_app/dao/ActorDAO.dart';
import 'package:tay_du_ky_app/dto/ActorDTO.dart';
import 'package:tay_du_ky_app/login.dart';
import 'package:tay_du_ky_app/screen/actor/actor_create.dart';
import 'package:tay_du_ky_app/screen/actor/actor_detail.dart';

class Actor extends StatefulWidget {
  @override
  _ToolState createState() => _ToolState();
}

class _ToolState extends State<Actor> {
  final GlobalKey<AnimatedListState> _key = GlobalKey();
  final GlobalKey<AnimatedListState> _refkey = GlobalKey();
  List<ActorDTO> futureListActorDTO;
  bool wait = true;
  // Future<List<ActorDTO>> futureListActorDTO;
  @override
  void initState() {
    wait = true;
    super.initState();
    _getListActorDTO();
  }

  Future<void> _getListActorDTO() async {
    setState(() => {futureListActorDTO = null});
    await fetchListActorDTO().then((result) => {
          setState(() => {
                wait = false,
                if (result == null)
                  {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false)
                  },
                futureListActorDTO = result,
              })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addItem(),
        child: Icon(Icons.add),
      ),
      body: RefreshIndicator(
        key: _refkey,
        onRefresh: () => _getListActorDTO(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 120,
          child: wait
              ? Center(
                  child: CircularProgressIndicator(
                  strokeWidth: 3,
                ))
              : futureListActorDTO == null
                  ? Container(
                      height: 0,
                    )
                  : AnimatedList(
                      key: _key,
                      initialItemCount: futureListActorDTO.length,
                      itemBuilder: (context, index, animation) {
                        return _buildItem(
                            futureListActorDTO[index], animation, index);
                      },
                    ),
        ),
      ),
    );
  }

  Widget _buildItem(ActorDTO item, Animation animation, int index) {
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
                    DetailScreen(dto: futureListActorDTO[index]),
              ),
            );
          },
          leading: CircleAvatar(
            backgroundImage: (item.image == '' || item.image == null)
                ? AssetImage('assets/images/wk.png')
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
              // Text('email: ' + item.email.toString()),
              Text('phone: ' + item.phone.toString()),
              Text('role: ' + item.role.toString()),
            ],
          ),
          trailing: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.redAccent,
              ),
              onPressed: () {
                _removeItem(index, item.actor_id);
              }),
        ),
      ),
    );
  }

  void _removeItem(int index, int tool_id) {
    deleteActor(tool_id.toString())
        .then((result) => {_show(index, int.parse(result) > 0)});
  }

  void _show(int index, bool flag) {
    ActorDTO removedItem = futureListActorDTO.removeAt(index);
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
      MaterialPageRoute(builder: (context) => ActorCreate()),
    );
  }
}
