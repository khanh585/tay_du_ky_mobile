import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tay_du_ky_app/dao/TribulationDAO.dart';
import 'package:tay_du_ky_app/dto/TribulationDTO.dart';
import 'package:tay_du_ky_app/login.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tay_du_ky_app/util/config.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class User extends StatefulWidget {
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  final GlobalKey<AnimatedListState> _key = GlobalKey();
  final GlobalKey<AnimatedListState> _refkey = GlobalKey();
  List<TribulationDTO> futureListTribulationDTO;
  bool wait = true;
  bool waitDown = false;
  bool isFlag = false;
  bool downloading = false;
  var progressString = "";

  @override
  Future<void> initState() async {
    wait = true;
    super.initState();
    _getListTribulationDTO();
  }

  Future<void> _getListTribulationDTO() async {
    setState(() => {futureListTribulationDTO = null});
    await fetchListTribulationDTOByActorID(USER_ID).then((result) => {
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
                print(futureListTribulationDTO == []),
              })
        });
  }

  Future<void> download(String url, int tribulationID) async {
    // Dio dio = Dio();
    // try {
    //   Directory tempDir = await getApplicationDocumentsDirectory();
    //   String tempPath = tempDir.path;
    //   print(tempPath);
    //   var rs = await dio.download(
    //       url, tempPath + "/tribulation" + tribulationID.toString() + ".txt");
    //   print(rs);
    //   showNotification(true);
    // } catch (e) {
    //   showNotification(false);
    // }
    if (!isFlag) {
      WidgetsFlutterBinding.ensureInitialized();
      await FlutterDownloader.initialize(
          debug: true // optional: set false to disable printing logs to console
          );
      setState(() {
        isFlag = true;
      });
    }

    Directory tempDir = await getApplicationDocumentsDirectory();
    String tempPath = tempDir.path;

    await FlutterDownloader.enqueue(
      url: url,
      savedDir: tempPath,
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      child: Text('No Character'),
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
          trailing: waitDown
              ? CircularProgressIndicator(
                  strokeWidth: 3,
                )
              : IconButton(
                  icon: Icon(
                    Icons.cloud_download,
                    color: item.url_file == null || item.url_file == ''
                        ? Colors.grey
                        : Colors.cyan,
                  ),
                  onPressed: () {
                    setState(() {
                      waitDown = true;
                    });
                    download(item.url_file, item.tribulation_id);
                    setState(() {
                      waitDown = false;
                    });
                  }),
        ),
      ),
    );
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
          Expanded(
              child: flag ? Text('Download Success') : Text('Download Fail'))
        ],
      ),
    ));
  }
}
