
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_readerapp/src/models/scan_model.dart';
export 'package:qr_readerapp/src/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {

  static Database _database;
  static final DBProvider db = DBProvider._();
  



  DBProvider._();

  Future<Database> get database async {

    if ( _database != null ) return _database;

    _database = await initDB();
    return _database;
  }


  initDB() async {

    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join( documentsDirectory.path, 'ScansDB.db' );

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: ( Database db, int version ) async {
        await db.execute(
          'CREATE TABLE Scans ('
          ' id INTEGER PRIMARY KEY,'
          ' type TEXT,'
          ' value TEXT'
          ')'
        );
      }
    
    );

  }


  newScanRaw( ScanModel newScan) async {
    final db = await database;
    final res = await db.rawInsert(
      'INSERT Into Scans (id, type, value)'
      'VALUES (${newScan.id}, ${newScan.type}, ${newScan.value})'
    );
    return res;
  }

  newScan(ScanModel newScan) async {
    final db = await database;
    final res =  db.insert('Scans', newScan.toJson());
    return res;
  }

  
  Future <ScanModel> getScanId(int id) async {
    final db = await database;
    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);
    
    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future <List<ScanModel>> getAllScans() async {
    final db = await database;
    final res = await db.query('Scans');
    
    List<ScanModel> list; 
    if(res.isNotEmpty) {
      list = res.map((c) => ScanModel.fromJson(c)).toList();
    }else {
      list = [];
    }

    return list;
  } 

  Future <List<ScanModel>> getScansByType(String type) async {
    final db = await database;
    final res = await db.query('Scans', where: 'type = ?', whereArgs: [type]);
    
    List<ScanModel> list; 
    if(res.isNotEmpty) {
      list = res.map((c) => ScanModel.fromJson(c)).toList();
    }else {
      list = [];
    }

    return list;
  }

  Future<int> updateScans (ScanModel newScan) async {
    
    final db = await database;
    final res = await db.update('Scans', newScan.toJson(), where: 'id = ?', whereArgs: [newScan.id]);

    return res;

  }

  Future<int> deleteScan (int id) async {
    final db = await database;
    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);

    return res;
  }

  Future<int> deleteAll () async {
    final db = await database;
    final res = db.rawDelete('DELETE FROM Scans');
    return res;
  }
 
}