import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:mor_release/pages/profile/album.dart';
import 'package:mor_release/pages/profile/profileForm.dart';
import 'package:mor_release/scoped/connected.dart';
import 'package:scoped_model/scoped_model.dart';
import '../const.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return SettingsScreen(
        model: model,
      );
    });
  }
}

class SettingsScreen extends StatefulWidget {
  final MainModel model;

  /*final String id;
  final String name;
  final String areaId;
  final String idPhotoUrl;
  final String taxPhotoUrl;
*/
  SettingsScreen({
    @required this.model,
  });

  @override
  State createState() => new SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  ScrollController scrollController;
  SlidingUpPanelController panelController = SlidingUpPanelController();

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        panelController.expand();
      } else if (scrollController.offset <=
              scrollController.position.minScrollExtent &&
          !scrollController.position.outOfRange) {
        panelController.anchor();
      } else {}
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _profileAlbumBottomSheet(context) {
    showModalBottomSheet(
        elevation: 26,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return ProfileAlbum(
              model: widget.model,
              idPhotoUrl: widget.model.userInfo.idPhotoUrl,
              taxPhotoUrl: widget.model.userInfo.taxPhotoUrl);
        });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.model.user.key,
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 20,
        clipBehavior: Clip.none,
        child: Stack(fit: StackFit.expand, children: [
          Positioned(
            top: 1,
            right: 8,
            child: Icon(
              Icons.add,
              size: 18,
            ),
          ),
          Positioned(
              bottom: 8,
              left: 2,
              right: 2,
              child: Icon(
                Icons.photo_album,
                size: 32,
              ))
        ]),
        backgroundColor: Colors.pink[500],
        onPressed: () => _profileAlbumBottomSheet(context),
      ),
      resizeToAvoidBottomPadding: true,
      body: Column(children: <Widget>[
        ProfileForm(
          widget.model,
        ),
      ]),
    );
  }
}
