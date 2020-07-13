import 'package:flutter/material.dart';

class Actor extends StatefulWidget {
  @override
  _LogState createState() => _LogState();
}

class _LogState extends State<Actor> {
  final GlobalKey<AnimatedListState> _key = GlobalKey();

  List<String> _items = [
    "Actor 1",
    "Actor 2",
    "Actor 3",
    "Actor 4",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addItem(),
        child: Icon(Icons.add),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height - 200,
        child: AnimatedList(
          key: _key,
          initialItemCount: _items.length,
          itemBuilder: (context, index, animation) {
            return _buildItem(_items[index], animation, index);
          },
        ),
      ),
    );
  }

  Widget _buildItem(String item, Animation animation, int index) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        //////
        elevation: 2,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.amber,
          ),
          title: Text(
            item,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text('lorem  ipsum dolor ...'),
          trailing: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.redAccent,
              ),
              onPressed: () {
                _removeItem(index);
              }),
        ),
      ),
    );
  }

  void _removeItem(int index) {
    String removedItem = _items.removeAt(index);
    AnimatedListRemovedItemBuilder builder = (context, animation) {
      return _buildItem(removedItem, animation, index);
    };
    _key.currentState.removeItem(index, builder);
  }

  void _addItem() {
    int index = _items.length > 0 ? _items.length : 0;
    _items.insert(index, 'Log ${_items.length + 1}');
    _key.currentState.insertItem(index);
  }
}
