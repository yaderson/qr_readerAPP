import 'package:qr_readerapp/src/models/scan_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

openUrl(BuildContext context, ScanModel scan) async {
  
  if(scan.type == 'http') {
    if(await canLaunch(scan.value)) {
      await launch(scan.value);
    }else {
      print('geo...');
    }
  }else {
    if(scan.type == 'search'){
    String url = Uri.encodeFull('https://www.google.com/search?q=${scan.value}&sourceid=chrome&ie=UTF-8');
      if(await canLaunch(url)) {
        await launch(url);
      }else {
        print('geo...');
      }
    }else{
      Navigator.pushNamed(context, 'map', arguments: scan);
    }
  }

}