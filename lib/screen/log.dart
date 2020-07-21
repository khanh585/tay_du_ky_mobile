import 'package:flutter/material.dart';
import 'package:tay_du_ky_app/dao/LogDAO.dart';
import 'package:tay_du_ky_app/dto/LogDTO.dart';

class Log extends StatefulWidget {
  @override
  _LogState createState() => _LogState();
}

class _LogState extends State<Log> {
  final GlobalKey<AnimatedListState> _key = GlobalKey();
  final GlobalKey<AnimatedListState> _refkey = GlobalKey();
  List<LogDTO> futureListLogDTO;
  bool wait = true;
  // Future<List<LogDTO>> futureListLogDTO;
  @override
  void initState() {
    wait = true;
    super.initState();
    _getListLogDTO();
  }

  Future<void> _getListLogDTO() async {
    setState(() => {futureListLogDTO = null});
    await fetchListLogDTO().then((result) => {
          if (result != null)
            {
              setState(() => {
                    wait = false,
                    futureListLogDTO = result,
                  })
            },
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        key: _refkey,
        onRefresh: () => fetchListLogDTO(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 120,
          child: wait
              ? Center(
                  child: CircularProgressIndicator(
                  strokeWidth: 3,
                ))
              : AnimatedList(
                  key: _key,
                  initialItemCount: futureListLogDTO.length,
                  itemBuilder: (context, index, animation) {
                    return _buildItem(
                        futureListLogDTO[index], animation, index);
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildItem(LogDTO item, Animation animation, int index) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        elevation: 2,
        child: ListTile(
          title: Text(
            item.user_name,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Text('email: ' + item.email.toString()),
              Text('action: ' + item.action),
              Text('time: ' + item.date_create),
            ],
          ),
        ),
      ),
    );
  }
}
