import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mor_release/scoped/connected.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Album extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Container(
        child: AlbumPics(idPhotoUrl: null, taxPhotoUrl: null),
      );
    });
  }
}

class AlbumPics extends StatefulWidget {
  final String idPhotoUrl;
  final String taxPhotoUrl;

  AlbumPics({@required this.idPhotoUrl, @required this.taxPhotoUrl});

  @override
  _AlbumPicsState createState() => _AlbumPicsState();
}

class _AlbumPicsState extends State<AlbumPics> {
  SharedPreferences sharedPref;
  File idImageFile;
  File taxImageFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
