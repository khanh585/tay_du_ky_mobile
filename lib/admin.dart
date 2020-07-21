import 'package:flutter/material.dart';
import 'package:tay_du_ky_app/home.dart';
import 'package:tay_du_ky_app/login.dart';
import 'package:tay_du_ky_app/screen/actor/actor.dart';
import 'package:tay_du_ky_app/screen/actor/profile.dart';
import 'package:tay_du_ky_app/screen/log.dart';
import 'package:tay_du_ky_app/screen/tribulation/tribulation.dart';
import 'package:tay_du_ky_app/screen/tool/tool.dart';
import 'package:tay_du_ky_app/user.dart';
import 'package:tay_du_ky_app/util/config.dart';
// import 'package:tay_du_ky_app/screen/tribulation_detail.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AddminState createState() => _AddminState();
}

class _AddminState extends State<AdminScreen> {
  int indexScreen = 0;
  List<Widget> list = [
    Home(),
    Tribulation(),
    Actor(),
    Tool(),
    Log(),
    User(),
    ProfileScreen()
  ];
  List<String> list_title = [
    'Home',
    'Tribulation',
    'Actor',
    'Tool',
    'Log',
    'Character',
    'Profile'
  ];
  String title = 'Home';

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
            title = list_title[i];
            indexScreen = i;
            Navigator.pop(ctx);
          });
        },
      ),
    ));
  }
}

class MyDrawer extends StatefulWidget {
  final Function onTap;

  const MyDrawer({Key key, this.onTap}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
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
                  ],
                ),
              ),
            ),
            showDrawer(
                context, Icon(Icons.home), 'Home', 0, ['admin', 'actor']),
            Divider(
              height: 1,
            ),
            showDrawer(context, Icon(Icons.cloud), 'Tribulation', 1, ['admin']),
            showDrawer(context, Icon(Icons.person), 'Actor', 2, ['admin']),
            showDrawer(context, Icon(Icons.brush), 'Tool', 3, ['admin']),
            showDrawer(context, Icon(Icons.list), 'Log', 4, ['admin']),
            showDrawer(context, Icon(Icons.person), 'Character', 5, ['actor']),
            showDrawer(context, Icon(Icons.person), 'Profile', 6, ['actor']),
            Divider(
              height: 1,
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Log out'),
              onTap: () => {
                USER_ID = "",
                ROLE = "",
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false)
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget showDrawer(
      BuildContext context, icon, title, index, List<String> role) {
    if (role.contains(ROLE)) {
      return ListTile(
        leading: icon,
        title: Text(title),
        onTap: () => widget.onTap(context, index),
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }
}
