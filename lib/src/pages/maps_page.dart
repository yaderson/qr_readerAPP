import 'package:flutter/material.dart';
import 'package:qr_readerapp/src/bloc/scans_bloc.dart';
import 'package:qr_readerapp/src/models/scan_model.dart';
import 'package:qr_readerapp/src/utils/utiils.dart' as utils;

class MapsPage extends StatelessWidget {
  final scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {
    scansBloc.getScans();
    return Scaffold(
      body: StreamBuilder<List<ScanModel>>(
        stream: scansBloc.scansStream ,
        builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
          if(!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final scans = snapshot.data;

          if(scans.length == 0) {
            return Center(
              child: Text('Empty'),
            );
          }

          return ListView.builder(
            itemCount: scans.length,
            itemBuilder: (context, i) => Dismissible(
              key: UniqueKey(),
              background: Container(
                color: Colors.red,
              ),
              onDismissed: (direction) => scansBloc.deleteScan(scans[i].id),
              child: ListTile(
                onTap: () => (scans[i].type == 'http')?utils.openUrl(context ,scans[i]): Navigator.pushNamed(context,'map', arguments: scans[i]),
                subtitle: Text('ID: ${scans[i].id}'),
                leading: Icon(Icons.cloud_queue, color: Theme.of(context).primaryColor,),
                title: Text(scans[i].value),
                trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey,),
              ),
            )
          );
        },
      ),
    );
  }
}