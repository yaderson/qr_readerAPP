import 'package:barcode_scan/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:qr_readerapp/src/bloc/scans_bloc.dart';
import 'package:qr_readerapp/src/models/scan_model.dart';
import 'package:qr_readerapp/src/pages/addres_page.dart';
import 'package:qr_readerapp/src/pages/maps_page.dart';
import 'package:qr_readerapp/src/utils/utiils.dart' as utils;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  final scanBloc = new ScansBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () => scanBloc.deleteAll(),
          )
        ],
      ),
      body: callPage(currentIndex),
      bottomNavigationBar: bottomNavBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.filter_center_focus),
        onPressed: () => _scanQR(context)
      ),
    );
  }
  _scanQR(BuildContext context) async{
    dynamic futureStrig = '';
    try {
      futureStrig = await BarcodeScanner.scan();
    }catch (e) {
      futureStrig = e.toString();
    }
    print('Future String ${futureStrig.rawContent}');

    if(futureStrig != null) {
      print('We have information');
      final scan = ScanModel(value: futureStrig.rawContent);
      scanBloc.addScan(scan);

      utils.openUrl(context ,scan);

    }
  }

  Widget callPage (int currentPage) {
    switch( currentPage ){
      case 0: return MapsPage();
      case 1: return AddresPage();
      default: return MapsPage();
    }
  }

  Widget bottomNavBar () {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        currentIndex = index;
        setState((){});
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.map), title: Text('Maps')),
        BottomNavigationBarItem(icon: Icon(Icons.brightness_1), title: Text('Addres')),
      ],
    );
  }
}