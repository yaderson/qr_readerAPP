import 'dart:async';
import 'dart:math';

import 'package:qr_readerapp/src/models/scan_model.dart';

class Validators {
  final validGeo = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: (scans, sink){
      final geoScans = scans.where((element) => element.type == 'geo').toList();
      sink.add(geoScans);
    }     
  );

  final validHttp = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: (scans, sink){
      final scan = scans.where((element) => element.type == 'http' || element.type == 'search').toList();
      sink.add(scan);
    }     
  );
}