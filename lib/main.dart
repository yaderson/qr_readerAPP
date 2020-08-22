import 'package:flutter/material.dart';
import 'package:qr_readerapp/src/pages/home_page.dart';
import 'package:qr_readerapp/src/pages/show_map_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {  
    return MaterialApp(
      title: 'QRReader',
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      routes: { 
        'home' : (BuildContext context) => HomePage(),
        'map': (BuildContext context) => ShowMapPage(),
      },
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
      ),
    );
  }
}