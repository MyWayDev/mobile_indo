import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mor_release/models/user.dart';
import 'package:mor_release/pages/const.dart';
import 'package:mor_release/scoped/connected.dart';
import 'package:mor_release/widgets/color_loader_2.dart';

class NodeEdit extends StatefulWidget {
  final MainModel model;
  NodeEdit(this.model, {Key key}) : super(key: key);

  @override
  _NodeEditState createState() => _NodeEditState();
}

class _NodeEditState extends State<NodeEdit> {
  TextEditingController cName; //done
  TextEditingController cAddress; //done
  TextEditingController cDistrId; //done
  TextEditingController cPersonalId;
  TextEditingController cTelePhone; //done
  TextEditingController cEmail;
  TextEditingController cBanKAccountNumber; //done
  TextEditingController cBankAccountName;
  TextEditingController cTaxNumber; //done
  TextEditingController cAreaName;
  TextEditingController cAreaId;
  TextEditingController cServiceCenter;
  TextEditingController cheld;

  final FocusNode focusName = new FocusNode();
  final FocusNode focusDistrId = new FocusNode();
  final FocusNode focusPersonalId = new FocusNode();
  final FocusNode focusTelephone = new FocusNode();
  final FocusNode fcousEmail = new FocusNode();
  final FocusNode focusAreaName = new FocusNode();
  final FocusNode focusAreaId = new FocusNode();
  final FocusNode focusAccountName = new FocusNode();
  final FocusNode focusAddress = new FocusNode();
  final FocusNode focusBankAccount = new FocusNode();
  final FocusNode focusTaxNumber = new FocusNode();
  final FocusNode focusHeld = new FocusNode();
  final FocusNode focusServiceCenter = new FocusNode();

  TextEditingController distrController = new TextEditingController();
  final FocusNode focusDistrController = new FocusNode();

  bool _isloading = false;

  void isloading(bool i) {
    setState(() {
      _isloading = i;
    });
  }

  bool isChanged = false;
  bool veri = false;
  //int _courier;
  NewMember _nodeData;

  void resetVeri() {
    distrController.clear();
    cDistrId.clear();
    cName.clear();
    cAddress.clear();
    cBanKAccountNumber.clear();
    cTaxNumber.clear();
    cTelePhone.clear();
    cPersonalId.clear();
    cBankAccountName.clear();
    isSwitched = false;
    veri = false;
  }

  @override
  void initState() {
    distrController.addListener(() {
      setState(() {});
    });
    //_nodeData = null;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isSwitched = false;
  bool _isSwitched() {
    setState(() {
      _nodeData.held == '1' ? isSwitched = false : isSwitched = true;
    });
    return isSwitched;
  }

  Future<String> _saveNodeEdit(NewMember nodeData) async {
    isloading(true);
    String msg;
    print(nodeData.editMemberEncode(nodeData));
    Response response = await nodeData.editPost(nodeData);
    if (response.statusCode == 200) {
      resetVeri();
    }
    response.statusCode == 200 ? msg = 'Updated :)' : msg = 'Failed';
    print(response.statusCode);
    isloading(false);
    setState(() {
      isChanged = false;
    });
    return msg;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: Text('Edit Member'),
      ),
      resizeToAvoidBottomPadding: false,
      body: ModalProgressHUD(
        child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 28),
            child: Container(
              child: buildVeri(context),
            ),
          ),
        ]),
        inAsyncCall: _isloading,
        opacity: 0.6,
        progressIndicator: ColorLoader2(),
      ),
    );
  }

  Widget buildVeri(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.only(left: 15),
            leading: Icon(Icons.vpn_key, size: 25.0, color: Colors.pink[500]),
            title: TextFormField(
              focusNode: focusDistrController,
              textAlign: TextAlign.center,
              controller: distrController,
              enabled: !veri ? true : false,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: 'Masukkan ID member',
                hintStyle: TextStyle(color: Colors.grey[400]),
              ),
              keyboardType: TextInputType.number,
            ),
            trailing: IconButton(
              icon: !veri && distrController.text.length > 0
                  ? Icon(
                      Icons.check,
                      size: 30.0,
                      color: Colors.lightBlue,
                    )
                  : distrController.text.length > 0
                      ? Icon(
                          GroovinMaterialIcons.close,
                          size: 24.0,
                          color: Colors.blueGrey,
                        )
                      : Container(),
              color: Colors.pink[900],
              onPressed: () async {
                isloading(true);
                if (!veri) {
                  veri = true;
                  // await widget.model
                  //  .leaderVerification(distrController.text.padLeft(8, '0'));
                  if (veri) {
                    _nodeData = await widget.model
                        .nodeEdit(distrController.text.padLeft(8, '0'));
                    setState(() {
                      cDistrId = TextEditingController(text: _nodeData.distrId);
                      cName = TextEditingController(text: _nodeData.name);
                      cAddress = TextEditingController(text: _nodeData.address);
                      cBanKAccountNumber = TextEditingController(
                          text: _nodeData.bankAccountNumber);
                      cTaxNumber =
                          TextEditingController(text: _nodeData.taxNumber);
                      cTelePhone =
                          TextEditingController(text: _nodeData.telephone);
                      cPersonalId =
                          TextEditingController(text: _nodeData.personalId);
                      cBankAccountName =
                          TextEditingController(text: _nodeData.bankAccoutName);
                      _isSwitched();
                    });

                    setState(() {});
                    _nodeData.distrId == '00000000'
                        ? resetVeri()
                        : distrController.text =
                            _nodeData.distrId + '  ' + _nodeData.name;
                    isloading(false);
                  } else {
                    resetVeri();
                    isloading(false);
                  }
                } else {
                  resetVeri();
                  isloading(false);
                }
              },
              splashColor: Colors.pink,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              ListTile(
                  leading: Container(
                    child: Text(
                      'Member Id',
                      style: TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                    margin: EdgeInsets.only(left: 20.0, top: 5.0, bottom: 1.0),
                  ),
                  title: Container(
                    child: Theme(
                        data: Theme.of(context)
                            .copyWith(primaryColor: primaryColor),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          enabled: false,
                          style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink[900]),
                          decoration: InputDecoration(
                            hintText: 'Member Id',
                            contentPadding: EdgeInsets.all(5.0),
                            hintStyle: TextStyle(color: greyColor),
                          ),
                          controller: cDistrId,
                          onChanged: (value) {
                            _nodeData.distrId = value;
                          },
                          focusNode: focusDistrId,
                        )),
                    margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  ),
                  trailing: Switch(
                    inactiveTrackColor:
                        veri ? Colors.red[200] : Colors.transparent,
                    activeTrackColor: Colors.green[200],
                    value: isSwitched,
                    onChanged: (bool value) {
                      setState(() {
                        isSwitched = value;
                        isSwitched
                            ? _nodeData.held = '0'
                            : _nodeData.held = '1';
                        isChanged = true;
                      });
                    },
                    activeThumbImage:
                        veri ? AssetImage('assets/images/check.jpg') : null,
                    inactiveThumbImage:
                        veri ? AssetImage('assets/images/xmark.png') : null,
                  )),
              Container(
                child: Theme(
                  data: Theme.of(context).copyWith(primaryColor: primaryColor),
                  child: TextFormField(
                    enabled: veri,
                    decoration: InputDecoration(
                      hintText: 'Name',
                      contentPadding: EdgeInsets.all(5.0),
                      hintStyle: TextStyle(color: greyColor),
                    ),
                    controller: cName,
                    onChanged: (value) {
                      setState(() {
                        _nodeData.name = value;
                        isChanged = true;
                      });
                    },
                    focusNode: focusName,
                  ),
                ),
                margin: EdgeInsets.only(left: 30.0, right: 30.0),
              ),
              Container(
                child: Text(
                  'Personal Id',
                  style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
                margin: EdgeInsets.only(left: 30.0, top: 5.0, bottom: 1.0),
              ),
              Container(
                child: Theme(
                  data: Theme.of(context).copyWith(primaryColor: primaryColor),
                  child: TextFormField(
                    enabled: veri,
                    style: TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Personal Id',
                      contentPadding: EdgeInsets.all(5.0),
                      hintStyle: TextStyle(color: greyColor),
                    ),
                    controller: cPersonalId,
                    onChanged: (value) {
                      setState(() {
                        _nodeData.personalId = value;
                        isChanged = true;
                      });
                    },
                    focusNode: focusPersonalId,
                  ),
                ),
                margin: EdgeInsets.only(left: 30.0, right: 30.0),
              ),
              Container(
                child: Text(
                  'Telephone',
                  style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
                margin: EdgeInsets.only(left: 30.0, top: 5.0, bottom: 1.0),
              ),
              Container(
                child: Theme(
                  data: Theme.of(context).copyWith(primaryColor: primaryColor),
                  child: TextFormField(
                    enabled: veri,
                    style: TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Telephone',
                      contentPadding: EdgeInsets.all(5.0),
                      hintStyle: TextStyle(color: greyColor),
                    ),
                    controller: cTelePhone,
                    onChanged: (value) {
                      setState(() {
                        _nodeData.telephone = value;
                        isChanged = true;
                      });
                    },
                    focusNode: focusTelephone,
                  ),
                ),
                margin: EdgeInsets.only(left: 30.0, right: 30.0),
              ),
              Container(
                child: Text(
                  'Address',
                  style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
                margin: EdgeInsets.only(left: 30.0, top: 5.0, bottom: 1.0),
              ),
              Container(
                child: Theme(
                  data: Theme.of(context).copyWith(primaryColor: primaryColor),
                  child: TextFormField(
                    enabled: veri,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Address',
                      contentPadding: EdgeInsets.all(5.0),
                      hintStyle: TextStyle(color: greyColor),
                    ),
                    controller: cAddress,
                    onChanged: (value) {
                      setState(() {
                        _nodeData.address = value;
                        isChanged = true;
                      });
                    },
                    focusNode: focusAddress,
                  ),
                ),
                margin: EdgeInsets.only(left: 30.0, right: 30.0),
              ),
              ListTile(
                leading: Container(
                  child: Text(
                    'Bank Account & Name',
                    style: TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: primaryColor),
                  ),
                  margin: EdgeInsets.only(left: 15.0, top: 5.0, bottom: 1.0),
                ),
                title: Container(
                  child: Theme(
                    data:
                        Theme.of(context).copyWith(primaryColor: primaryColor),
                    child: TextFormField(
                      enabled: veri,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Bank Account',
                        contentPadding: EdgeInsets.all(8.0),
                        hintStyle: TextStyle(color: greyColor),
                      ),
                      controller: cBanKAccountNumber,
                      onChanged: (value) {
                        setState(() {
                          _nodeData.bankAccountNumber = value;
                          isChanged = true;
                        });
                      },
                      focusNode: focusBankAccount,
                    ),
                  ),
                  margin: EdgeInsets.only(left: 1.0, right: 1.0),
                ),
                subtitle: Container(
                  child: Theme(
                    data:
                        Theme.of(context).copyWith(primaryColor: primaryColor),
                    child: TextFormField(
                      enabled: veri,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Account Name',
                        contentPadding: EdgeInsets.all(5.0),
                        hintStyle: TextStyle(color: greyColor),
                      ),
                      controller: cBankAccountName,
                      onChanged: (value) {
                        setState(() {
                          _nodeData.bankAccoutName = value;
                          isChanged = true;
                        });
                      },
                      focusNode: focusAccountName,
                    ),
                  ),
                  margin: EdgeInsets.only(left: 1.0, right: 1.0),
                ),
              ),
              Container(
                child: Text(
                  'Tax Number',
                  style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
                margin: EdgeInsets.only(left: 30.0, top: 5.0, bottom: 1.0),
              ),
              Container(
                child: Theme(
                  data: Theme.of(context).copyWith(primaryColor: primaryColor),
                  child: TextFormField(
                    enabled: veri,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Tax Number',
                      contentPadding: EdgeInsets.all(5.0),
                      hintStyle: TextStyle(color: greyColor),
                    ),
                    controller: cTaxNumber,
                    onChanged: (value) {
                      setState(() {
                        _nodeData.taxNumber = value;
                        isChanged = true;
                      });
                    },
                    focusNode: focusTaxNumber,
                  ),
                ),
                margin: EdgeInsets.only(left: 30.0, right: 30.0),
              ),
              veri
                  ? ButtonBar(
                      mainAxisSize: MainAxisSize.max,
                      alignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        isChanged
                            ? RaisedButton(
                                elevation: 11,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(21.0)),
                                child: Text(
                                  'Update',
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Colors.indigo[900],
                                onPressed: () async {
                                  String _msg = await _saveNodeEdit(_nodeData);
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                            title: Text(_msg),
                                            actions: <Widget>[
                                              FlatButton(
                                                highlightColor:
                                                    Colors.greenAccent,
                                                shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        color: Colors.red[400],
                                                        width: 2.5,
                                                        style:
                                                            BorderStyle.solid),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50)),
                                                color: Colors.white,
                                                child: Text(
                                                  'Close',
                                                  style: TextStyle(
                                                      color: Colors.red[900],
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                              ),
                                            ],
                                          ));
                                },
                              )
                            : Container(),
                        RaisedButton(
                          elevation: 11,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(21.0)),
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.yellow[100]),
                          ),
                          color: Colors.red[900],
                          onPressed: () => showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    elevation: 15,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(21.0)),
                                    title: Text(
                                      'Confirm Delete ?',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    content: Text(
                                      'Member: ${_nodeData.distrId}',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        highlightColor: Colors.greenAccent,
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Colors.greenAccent[400],
                                                width: 2.5,
                                                style: BorderStyle.solid),
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        color: Colors.white,
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(
                                              color: Colors.green[900],
                                              fontWeight: FontWeight.bold),
                                        ),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      ),
                                      SizedBox(
                                        width: 21,
                                      ),
                                      FlatButton(
                                        colorBrightness: Brightness.light,
                                        highlightColor: Colors.redAccent[400],
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Colors.redAccent[400],
                                                width: 2.5,
                                                style: BorderStyle.solid),
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        color: Colors.white,
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(
                                              color: Colors.pink[900],
                                              fontWeight: FontWeight.bold),
                                        ),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      ),
                                    ],
                                  )),
                        ),
                      ],
                    )
                  : Container(),
            ],
          )
        ],
      ),
    );
  }
}
