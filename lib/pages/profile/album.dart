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

  final String idPhotoUrl;
  final String taxPhotoUrl;

  ProfileAlbum(
      {@required this.model,
      @required this.idPhotoUrl,
      @required this.taxPhotoUrl});
  @override
  _ProfileAlbumState createState() => _ProfileAlbumState();
}

class _ProfileAlbumState extends State<ProfileAlbum> {
  SharedPreferences prefs;

  String idPhotoUrl = '';
  String taxPhotoUrl = '';

  bool isLoading = false;
  File idImageFile;
  File taxImageFile;

  @override
  void initState() {
    _readLocal();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _readLocal() async {
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

    idPhotoUrl = idImageString();
    taxPhotoUrl = taxImageString();

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
    String fileName =
        widget.model.userInfo.key + '-' + random.nextInt(100000).toString();
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
              .child('indoDb/users/en-US/${widget.model.userInfo.key}')
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
    String fileName =
        widget.model.userInfo.key + '-' + random.nextInt(100000).toString();
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
              .child('indoDb/users/en-US/${widget.model.userInfo.key}')
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                  ]),
                              idImageFile == null
                                  ? (idPhotoUrl != ''
                                      ? Material(
                                          child: CachedNetworkImage(
                                            placeholder: (context, url) =>
                                                Container(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.0,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(themeColor),
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(0.0)),
                                      clipBehavior: Clip.hardEdge,
                                    ),
                            ],
                          ),
                        ),
                        width: double.infinity,
                        margin: EdgeInsets.all(5.0),
                      ),
                    ),
                    VerticalDivider(
                      endIndent: 5,
                      width: 12,
                      color: Colors.grey,
                      indent: 10,
                    ),
                    Expanded(
                      child: Container(
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                  ]),
                              taxImageFile == null
                                  ? (taxPhotoUrl != ''
                                      ? Material(
                                          child: CachedNetworkImage(
                                            placeholder: (context, url) =>
                                                Container(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.0,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(themeColor),
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
                                            imageUrl: taxPhotoUrl,
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
                                        taxImageFile,
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(0.0)),
                                      clipBehavior: Clip.hardEdge,
                                    ),
                            ],
                          ),
                        ),
                        width: double.infinity,
                        margin: EdgeInsets.all(5.0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
        ),

        // Loading
      ],
    );
  }
}
