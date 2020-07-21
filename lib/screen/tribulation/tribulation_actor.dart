import 'package:flutter/material.dart';
import 'package:tay_du_ky_app/dao/ActorDAO.dart';
import 'package:tay_du_ky_app/dto/ActorDTO.dart';
import 'package:tay_du_ky_app/dto/ActorDTO.dart';
import 'package:tay_du_ky_app/screen/tribulation/add_actor.dart';

class TribulationActor extends StatefulWidget {
  final List<ActorDTO> dtos;
  final String tribulationID;

  const TribulationActor({Key key, this.dtos, this.tribulationID})
      : super(key: key);
  @override
  TribulationActorState createState() => TribulationActorState();
}

class TribulationActorState extends State<TribulationActor> {
  final GlobalKey<AnimatedListState> _key = GlobalKey();
  List<ActorDTO> listcurrentActor;
  final GlobalKey<AnimatedListState> _refkey = GlobalKey();

  @override
  void initState() {
    listcurrentActor = widget.dtos;
    super.initState();
  }

  Future<void> _getListActorDTO() async {
    setState(() => {listcurrentActor = null});
    await fetchListActorDTOByTribulation(widget.tribulationID)
        .then((result) => {
              if (result != null)
                {
                  setState(() => {
                        listcurrentActor = result,
                      })
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
        title: Text('Tribulation Actor'),
        actions: <Widget>[
          FlatButton(
            child: Icon(Icons.refresh),
            onPressed: () => _getListActorDTO(),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddActor(
                      tribulationID: widget.tribulationID,
                    )),
          );
        },
        child: Icon(Icons.add),
      ),
      body: RefreshIndicator(
        key: _refkey,
        onRefresh: () => _getListActorDTO(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 120,
          child: listcurrentActor == null
              ? Center(
                  child: Text(
                  "Loading...",
                  style: TextStyle(fontSize: 25),
                ))
              : listcurrentActor.length == 0
                  ? Center(
                      child: Text(
                      "Don't have actor",
                      style: TextStyle(fontSize: 25),
                    ))
                  : AnimatedList(
                      key: _key,
                      initialItemCount: listcurrentActor.length,
                      itemBuilder: (context, index, animation) {
                        return _buildItem(
                            listcurrentActor[index], animation, index);
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
        elevation: 2,
        child: ListTile(
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
              Text('Name: ' + item.name),
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

  Future<void> _removeItem(int index, int actor_id) async {
    await removeActor(widget.tribulationID, actor_id.toString())
        .then((result) => {_show(index, result)});
  }

  void _show(int index, bool flag) {
    ActorDTO removedItem = listcurrentActor.removeAt(index);
    AnimatedListRemovedItemBuilder builder = (context, animation) {
      return _buildItem(removedItem, animation, index);
    };
    _key.currentState.removeItem(index, builder);
  }
}
