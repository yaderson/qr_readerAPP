import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_readerapp/src/bloc/scans_bloc.dart';
import 'package:qr_readerapp/src/models/scan_model.dart';
import 'package:qr_readerapp/src/utils/utiils.dart' as utils;

class AddresPage extends StatelessWidget {
  final scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {
    scansBloc.getScans();
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      body: StreamBuilder<List<ScanModel>>(
        stream: scansBloc.scansStreamHttp ,
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
                color: Colors.deepPurple,
                child: ListTile(
                  leading: Icon(Icons.delete, color: Colors.white,),
                ),
              ),
              onDismissed: (direction) => scansBloc.deleteScan(scans[i].id),
              child: ListTile(
                onTap: () => utils.openUrl(context ,scans[i]),
                subtitle: Text('ID: ${scans[i].id}'),
                leading: Icon(Icons.cloud_queue, color: Theme.of(context).primaryColor,),
                title: Text(scans[i].value),
                trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey,),
                onLongPress: (){
                  Clipboard.setData(ClipboardData(text: scans[i].value));
                  scaffoldKey.currentState.showSnackBar(
                    SnackBar(content: Text('Copied to Clipboard'), backgroundColor: Colors.deepPurple,)
                  );
                },
              ),
            )
          );
        },
      ),
    );
  }
}