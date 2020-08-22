import 'dart:async';

import 'package:qr_readerapp/src/bloc/validator.dart';
import 'package:qr_readerapp/src/providers/db_provider.dart';

class ScansBloc with Validators {
  static final ScansBloc _Singleton = new ScansBloc._internal();

  factory ScansBloc() {
    return _Singleton;
  }

  ScansBloc._internal() {
    getScans();
  }

  final _scansController =  StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream => _scansController.stream.transform(validGeo); 
  Stream<List<ScanModel>> get scansStreamHttp => _scansController.stream.transform(validHttp); 

  dispose() {
    _scansController?.close();
  }

  addScan(ScanModel scan) async {
    await DBProvider.db.newScan(scan);
    getScans();
  }

  getScans() async {
    _scansController.sink.add(await DBProvider.db.getAllScans());
  }

  deleteScan(int id) async {
    await DBProvider.db.deleteScan(id);
    getScans();

  }

  deleteAll() async {
    await DBProvider.db.deleteAll();
    getScans();
  }

}
