import 'package:flutter/material.dart';
import 'package:tay_du_ky_app/screen/actor/actor.dart';
import 'package:tay_du_ky_app/screen/log.dart';
import 'package:tay_du_ky_app/screen/tribulation/tribulation.dart';
import 'package:tay_du_ky_app/screen/tool/tool.dart';
// import 'package:tay_du_ky_app/screen/tribulation_detail.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AddminState createState() => _AddminState();
}

class _AddminState extends State<AdminScreen> {
  int indexScreen = 0;
  List<Widget> list = [Tribulation(), Actor(), Tool(), Log()];
  List<String> list_title = ['Kiep nan', 'Dien vien', 'Dao cu', 'Nhat ky'];
  String title = 'Tay Du Ky';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: list[indexScreen],
      // body: list[indexScreen],
      drawer: MyDrawer(
        onTap: (ctx, i) {
          setState(() {
            title = 'Tay Du Ky - ' + list_title[i];
            indexScreen = i;
            Navigator.pop(ctx);
          });
        },
      ),
    ));
  }
}

class MyDrawer extends StatelessWidget {
  final Function onTap;

  const MyDrawer({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/banner.jpg')),
              ),
              child: Padding(
                padding: EdgeInsets.all(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: 60,
                      height: 60,
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/images/wk.jpg'),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      decoration:
                          BoxDecoration(color: Color.fromRGBO(10, 10, 10, 0.7)),
                      child: Text(
                        'Tề Thiên Đại Thánh',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 3),
                    Container(
                      decoration:
                          BoxDecoration(color: Color.fromRGBO(10, 10, 10, 0.7)),
                      child: Text(
                        'ngokhong@gmail.com',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.cloud),
              title: Text('Tribulation'),
              onTap: () => onTap(context, 0),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Actor'),
              onTap: () => onTap(context, 1),
            ),
            ListTile(
              leading: Icon(Icons.brush),
              title: Text('Tool'),
              onTap: () => onTap(context, 2),
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Log'),
              onTap: () => onTap(context, 3),
            ),
            Divider(
              height: 1,
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Log out'),
              onTap: () => onTap(context, 3),
            ),
          ],
        ),
      ),
    );
  }
}
