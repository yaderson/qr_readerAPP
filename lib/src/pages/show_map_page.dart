import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qr_readerapp/src/models/scan_model.dart';

class ShowMapPage extends StatefulWidget {
  @override
  _ShowMapPageState createState() => _ShowMapPageState();
}

class _ShowMapPageState extends State<ShowMapPage> {
  final map = new MapController();

  String typeMap = 'streets-v11';

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location), 
            onPressed: () {
              map.move(scan.getLatLang(), 10.0);
            }
          )
        ],
      ),
      body: _map(scan),
      floatingActionButton: _changeMap(context),
    );
  }

  Widget _changeMap(BuildContext context) {
    return FloatingActionButton(
      
      backgroundColor: Theme.of(context).primaryColor,
      child: Icon(Icons.repeat),
      onPressed: (){
        if(typeMap == 'streets-v11'){
          typeMap = 'dark-v10';
        }else {
          typeMap = 'streets-v11';
        }
        print(typeMap);
        setState(() {
          
        });
      },
    );
  }

  _map(ScanModel scan) {
    return FlutterMap(
      mapController: map,
      options: MapOptions(
        center: scan.getLatLang(),
        zoom: 10.0
      ),
      layers: [
        _createMap(),
        _markerMap(scan)
      ],
    );   
  }

  _createMap() {
    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/styles/v1/'
      '{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
      additionalOptions: {
      'accessToken':'pk.eyJ1IjoieWFkZXJyIiwiYSI6ImNrZDR3cjZ2dTAyazQyc3F2ODg4OXN0dGIifQ.ORb9f0MD8Z5_s6_TjleDPQ',
      'id': 'mapbox/$typeMap'
      } 
    );
  }

  _markerMap(ScanModel scan) {
    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          width: 100.0,
          height: 100.0,
          point: scan.getLatLang(),
          builder: (context) => Container(
            child: Icon(Icons.location_on, color: Theme.of(context).primaryColor, size: 50,),
          )
        )
      ],
    );
  }
}