// To parse this JSON data, do
//
//     final scanModel = scanModelFromJson(jsonString);

import 'dart:convert';
import 'package:latlong/latlong.dart';

ScanModel scanModelFromJson(String str) => ScanModel.fromJson(json.decode(str));

String scanModelToJson(ScanModel data) => json.encode(data.toJson());

class ScanModel {
  ScanModel({
    this.id,
    this.type,
    this.value,
  }){
    if(this.value.contains('http')){
      this.type = 'http';
    }else {
      Pattern geoPattern = r'^([-+]?)([\d]{1,2})(((\.)(\d+)(,)))(\s*)(([-+]?)([\d]{1,3})((\.)(\d+))?)$';
      RegExp isGeo = new RegExp(geoPattern);

      if(isGeo.hasMatch(this.value) || this.value.contains('geo:')){
        this.type = 'geo';
      }else {
        this.type = 'search';
      }
      
    }
  }

  int id;
  String type;
  String value;

  factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
    id: json["id"],
    type: json["type"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "value": value,
  };

  getLatLang() {
    final lalo = value.substring(4).split(',');
    final lat = double.parse(lalo[0]);
    final lng = double.parse(lalo[1]);
    
    return LatLng(lat, lng);
  }
}