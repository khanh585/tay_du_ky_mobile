// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:tay_du_ky_app/dao/ToolDAO.dart';
// import 'package:tay_du_ky_app/dto/ToolDTO.dart';

// class TribulationDetail extends StatefulWidget {
//   TribulationDetail({Key key}) : super(key: key);

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<TribulationDetail> {
//   Future<Album> futureAlbum;
//   final _formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();
//     futureAlbum = fetchAlbum();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: FutureBuilder<Album>(
//           future: futureAlbum,
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               return _form(context);
//             } else if (snapshot.hasError) {
//               return Text("${snapshot.error}");
//             }
//             return CircularProgressIndicator();
//           },
//         ),
//       ),
//     );
//   }

//   Widget _form(BuildContext context) {
//     // Build a Form widget using the _formKey created above.
//     return Container(
//       child: Form(
//         key: _formKey,
//         child: ListView(
//           padding: const EdgeInsets.all(10),
//           children: <Widget>[
//             _formfield(
//               title: 'Name',
//               value: 'khanh',
//             ),
//             _formfield(
//               title: 'Address',
//               value: 'Phuong Hoang Co Chan',
//             ),
//             _formfield(
//               title: 'Description',
//               value: '',
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 16.0),
//               child: RaisedButton(
//                 onPressed: () {
//                   // Validate returns true if the form is valid, or false
//                   // otherwise.
//                   if (_formKey.currentState.validate()) {
//                     // If the form is valid, display a Snackbar.
//                     Scaffold.of(context).showSnackBar(
//                         SnackBar(content: Text('Processing Data')));
//                   }
//                 },
//                 child: Text('Submit'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _formfield extends StatefulWidget {
//   final String title;
//   final String value;

//   const _formfield({Key key, this.title, this.value}) : super(key: key);

//   @override
//   __formfieldState createState() => __formfieldState();
// }

// class __formfieldState extends State<_formfield> {
//   final TextEditingController _controller = new TextEditingController();
//   @override
//   void dispose() {
//     // Clean up the controller when the widget is removed from the
//     // widget tree.
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     _controller.text = widget.value;
//     return TextFormField(
//       controller: _controller,
//       decoration: InputDecoration(
//           labelText: widget.title,
//           labelStyle: TextStyle(
//             fontSize: 25,
//           )),
//       validator: (value) {
//         if (value.isEmpty) {
//           return 'Please enter some text';
//         }
//         return null;
//       },
//     );
//   }
// }

// class CircleIconButton extends StatelessWidget {
//   final double size;
//   final Function onPressed;
//   final IconData icon;
//   CircleIconButton({this.size = 30.0, this.icon = Icons.clear, this.onPressed});
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//         onTap: this.onPressed,
//         child: SizedBox(
//             width: size,
//             height: size,
//             child: Stack(
//               alignment: Alignment(0.0, 0.0), // all centered
//               children: <Widget>[
//                 Container(
//                   width: size,
//                   height: size,
//                   decoration: BoxDecoration(
//                       shape: BoxShape.circle, color: Colors.grey[300]),
//                 ),
//                 Icon(
//                   icon,
//                   size: size * 0.6, // 60% width for icon
//                 )
//               ],
//             )));
//   }
// }
