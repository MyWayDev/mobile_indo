import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mor_release/pages/messages/chat.dart';
import 'package:mor_release/scoped/connected.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../const.dart';

class ProfileAlbum extends StatefulWidget {
  final MainModel model;
  final String id;
  final String name;
  final String areaId;
  final String idPhotoUrl;
  final String taxPhotoUrl;

  ProfileAlbum(
      {@required this.model,
      @required this.id,
      @required this.name,
      @required this.areaId,
      @required this.idPhotoUrl,
      @required this.taxPhotoUrl});
  @override
  _ProfileAlbumState createState() => _ProfileAlbumState();
}

class _ProfileAlbumState extends State<ProfileAlbum> {
  TextEditingController controllerNickname;
  TextEditingController controllerAboutMe;

  SharedPreferences prefs;

  String id = '';
  String name = '';
  String areaId = '';
  String idPhotoUrl = '';
  String taxPhotoUrl = '';

  bool isLoading = false;
  File idImageFile;
  File taxImageFile;

  final FocusNode focusNodeNickname = new FocusNode();
  final FocusNode focusNodeAboutMe = new FocusNode();

  @override
  void initState() {
    readLocal();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    String idImageString() {
      String idImage;
      widget.idPhotoUrl == null || widget.idPhotoUrl.isEmpty
          ? idImage = ''
          : idImage = widget.idPhotoUrl;
      return idImage;
    }

    String taxImageString() {
      String taxImage;
      widget.taxPhotoUrl == null || widget.taxPhotoUrl.isEmpty
          ? taxImage = ''
          : taxImage = widget.taxPhotoUrl;
      return taxImage;
    }

    id = widget.id;
    name = widget.name;
    areaId = widget.areaId;
    idPhotoUrl = idImageString();
    taxPhotoUrl = taxImageString();

    controllerNickname = new TextEditingController(text: widget.name);
    controllerAboutMe = new TextEditingController(text: widget.areaId);

    // Force refresh input
    setState(() {});
  }

  Future getIdImage() async {
    File _image =
        await ImagePicker.pickImage(source: ImageSource.gallery) ?? null;

    if (_image != null) {
      setState(() {
        idImageFile = _image;
        isLoading = true;
      });
    }
    uploadFileId();
  }

  Future getTaxImage() async {
    File _image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (_image != null) {
      setState(() {
        taxImageFile = _image;
        isLoading = true;
      });
    }
    uploadFileTax();
  }

  Future uploadFileTax() async {
    Random random = new Random();
    String fileName = widget.id + '-' + random.nextInt(100000).toString();
    StorageReference reference =
        FirebaseStorage.instance.ref().child("avatars/$fileName");
    StorageUploadTask uploadTask = reference.putFile(taxImageFile);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          taxPhotoUrl = downloadUrl;
          FirebaseDatabase.instance
              .reference()
              .child('indoDb/users/en-US/$id')
              .update({
            //'name': name,
            //'areaId': areaId,
            // 'idPhotoUrl': idPhotoUrl,
            'taxPhotoUrl': taxPhotoUrl
          }).then((data) async {
            await prefs.setString('taxPhotoUrl', taxPhotoUrl);
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: "Upload success");
          }).catchError((err) {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: err.toString());
          });
        }, onError: (err) {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: 'This file is not an image');
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: 'This file is not an image');
      }
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: err.toString());
    });
  }

  Future uploadFileId() async {
    Random random = new Random();
    String fileName = widget.id + '-' + random.nextInt(100000).toString();
    StorageReference reference =
        FirebaseStorage.instance.ref().child("avatars/$fileName");
    StorageUploadTask uploadTask = reference.putFile(idImageFile);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          idPhotoUrl = downloadUrl;
          FirebaseDatabase.instance
              .reference()
              .child('indoDb/users/en-US/$id')
              .update({
            //'name': name,
            // 'areaId': areaId,
            'idPhotoUrl': idPhotoUrl,
            //'taxPhotoUrl': taxPhotoUrl
          }).then((data) async {
            await prefs.setString('idPhotoUrl', idPhotoUrl);
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: "Upload success");
          }).catchError((err) {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: err.toString());
          });
        }, onError: (err) {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: 'This file is not an image');
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: 'This file is not an image');
      }
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: err.toString());
    });
  }

  void handleUpdateData() {
    focusNodeNickname.unfocus();
    focusNodeAboutMe.unfocus();

    setState(() {
      isLoading = true;
    });
    FirebaseDatabase.instance
        .reference()
        .child('indoDb/users/en-US/$id')
        .update({
      'name': name,
      'areaId': areaId,
      'idPhotoUrl': idPhotoUrl ?? '',
      'taxPhotoUrl': taxPhotoUrl ?? ''
    }).then((data) async {
      //await prefs.setString('name', name);
      // await prefs.setString('areaId', areaId);
      // await prefs.setString('idPhotoUrl', idPhotoUrl);
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: "Update success");
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: err.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Avatar,

              // Input
              Column(
                children: <Widget>[
                  // Username
                  Container(
                    child: Text(
                      'Name',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                    margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
                  ),
                  Container(
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: primaryColor),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'name',
                          contentPadding: new EdgeInsets.all(5.0),
                          hintStyle: TextStyle(color: greyColor),
                        ),
                        controller: controllerNickname,
                        onChanged: (value) {
                          name = value;
                        },
                        focusNode: focusNodeNickname,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 30.0, right: 30.0),
                  ),

                  // About me
                  Container(
                    child: Text(
                      'Area',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                    margin: EdgeInsets.only(left: 10.0, top: 30.0, bottom: 5.0),
                  ),
                  Container(
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: primaryColor),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: '',
                          contentPadding: EdgeInsets.all(5.0),
                          hintStyle: TextStyle(color: greyColor),
                        ),
                        controller: controllerAboutMe,
                        onChanged: (value) {
                          areaId = value;
                        },
                        focusNode: focusNodeAboutMe,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 30.0, right: 30.0),
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),

              // Button

              Row(
                children: [
                  Expanded(
                    child: Container(
                      child: Center(
                        child: Stack(
                          children: <Widget>[
                            (idImageFile == null)
                                ? (idPhotoUrl != ''
                                    ? Material(
                                        child: CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              Container(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.0,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      themeColor),
                                            ),
                                            width: MediaQuery.of(context)
                                                        .devicePixelRatio <=
                                                    1.5
                                                ? 180
                                                : 220,
                                            height: MediaQuery.of(context)
                                                        .devicePixelRatio <=
                                                    1.5
                                                ? 90
                                                : 100,
                                            padding: EdgeInsets.all(10.0),
                                          ),
                                          imageUrl: idPhotoUrl,
                                          width: MediaQuery.of(context)
                                                      .devicePixelRatio <=
                                                  1.5
                                              ? 180
                                              : 220,
                                          height: MediaQuery.of(context)
                                                      .devicePixelRatio <=
                                                  1.5
                                              ? 90
                                              : 100,
                                          fit: BoxFit.fitWidth,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(0.0)),
                                        clipBehavior: Clip.hardEdge,
                                      )
                                    : Icon(
                                        Icons.account_circle,
                                        size: 100.0,
                                        color: greyColor,
                                      ))
                                : Material(
                                    child: Image.file(
                                      idImageFile,
                                      width: MediaQuery.of(context)
                                                  .devicePixelRatio <=
                                              1.5
                                          ? 230
                                          : 250,
                                      height: MediaQuery.of(context)
                                                  .devicePixelRatio <=
                                              1.5
                                          ? 90
                                          : 100,
                                      fit: BoxFit.fitWidth,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(0.0)),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(
                                      Icons.add_a_photo,
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                    onPressed: getIdImage,
                                    padding: EdgeInsets.all(10.0),
                                    splashColor: Colors.transparent,
                                    highlightColor: greyColor,
                                    iconSize: 25.0,
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.zoom_in,
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (_) {
                                        return ImageDetails(
                                          image: widget.idPhotoUrl,
                                        );
                                      }));
                                    },
                                    padding: EdgeInsets.all(10.0),
                                    splashColor: Colors.transparent,
                                    highlightColor: greyColor,
                                    iconSize: 25.0,
                                  ),
                                ])
                          ],
                        ),
                      ),
                      width: double.infinity,
                      margin: EdgeInsets.all(20.0),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Center(
                        child: Stack(
                          children: <Widget>[
                            (taxImageFile == null)
                                ? (taxPhotoUrl != ''
                                    ? Material(
                                        child: CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              Container(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.0,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      themeColor),
                                            ),
                                            width: 150.0,
                                            height: 150.0,
                                            padding: EdgeInsets.all(10.0),
                                          ),
                                          imageUrl: taxPhotoUrl,
                                          width: 150.0,
                                          height: 150.0,
                                          fit: BoxFit.fitWidth,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(0.0)),
                                        clipBehavior: Clip.antiAlias,
                                      )
                                    : Icon(
                                        Icons.account_circle,
                                        size: 90.0,
                                        color: greyColor,
                                      ))
                                : Material(
                                    child: Image.file(
                                      taxImageFile,
                                      width: 150.0,
                                      height: 150.0,
                                      fit: BoxFit.fitWidth,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(0.0)),
                                    clipBehavior: Clip.antiAlias,
                                  ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(
                                      Icons.add_a_photo,
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                    onPressed: getTaxImage,
                                    padding: EdgeInsets.all(10.0),
                                    splashColor: Colors.transparent,
                                    highlightColor: greyColor,
                                    iconSize: 25.0,
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.zoom_in,
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (_) {
                                        return ImageDetails(
                                          image: widget.taxPhotoUrl,
                                        );
                                      }));
                                    },
                                    padding: EdgeInsets.all(10.0),
                                    splashColor: Colors.transparent,
                                    highlightColor: greyColor,
                                    iconSize: 25.0,
                                  ),
                                ])
                          ],
                        ),
                      ),
                      width: double.infinity,
                      margin: EdgeInsets.all(20.0),
                    ),
                  )
                ],
              ),
              Container(
                child: FlatButton(
                  onPressed: handleUpdateData,
                  child: Text(
                    'UPDATE',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  color: primaryColor,
                  highlightColor: new Color(0xff8d93a0),
                  splashColor: Colors.transparent,
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                ),
                margin: EdgeInsets.only(top: 50.0, bottom: 50.0),
              ),
            ],
          ),
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
        ),

        // Loading
        Positioned(
          child: isLoading
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(themeColor)),
                  ),
                  color: Colors.white.withOpacity(0.8),
                )
              : Container(),
        ),
      ],
    );
  }
}
