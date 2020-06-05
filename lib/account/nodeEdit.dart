import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
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
  TextEditingController cName;
  TextEditingController cAddress;
  TextEditingController cDistrId;
  TextEditingController cPersonalId;
  TextEditingController cTelePhone;
  TextEditingController cBanKAccountNumber;
  TextEditingController cBankAccountName;
  TextEditingController cTaxNumber;
  TextEditingController cAreaName;
  TextEditingController cAreaId;
  TextEditingController cServiceCenter;

  final FocusNode focusName = new FocusNode();
  final FocusNode focusAddress = new FocusNode();
  final FocusNode focusBankAccount = new FocusNode();
  final FocusNode focusTaxNumber = new FocusNode();
  final FocusNode focusDistrController = new FocusNode();

  TextEditingController distrController = new TextEditingController();

  bool _isloading = false;

  void isloading(bool i) {
    setState(() {
      _isloading = i;
    });
  }

  bool veri = false;
  //int _courier;
  NewMember _nodeData;

  void resetVeri() {
    distrController.clear();
    cName.clear();
    cAddress.clear();
    cBanKAccountNumber.clear();
    cTaxNumber.clear();
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
            contentPadding: EdgeInsets.only(left: 8),
            leading: Icon(Icons.vpn_key, size: 25.0, color: Colors.indigo[900]),
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
                          GroovinMaterialIcons.close_circle_outline,
                          size: 30.0,
                          color: Colors.red[900],
                        )
                      : Container(),
              color: Colors.pink[900],
              onPressed: () async {
                if (!veri) {
                  veri = await widget.model
                      .leaderVerification(distrController.text.padLeft(8, '0'));
                  if (veri) {
                    _nodeData = await widget.model
                        .nodeEdit(distrController.text.padLeft(8, '0'));
                    setState(() {
                      cName = TextEditingController(text: _nodeData.name);
                      cAddress = TextEditingController(text: _nodeData.address);
                      cBanKAccountNumber = TextEditingController(
                          text: _nodeData.bankAccountNumber);
                      cTaxNumber =
                          TextEditingController(text: _nodeData.taxNumber);
                    });

                    setState(() {});
                    _nodeData.distrId == '00000000'
                        ? resetVeri()
                        : distrController.text =
                            _nodeData.distrId + '  ' + _nodeData.name;
                    // memberReportSummary(_nodeData.distrId);
                  } else {
                    resetVeri();
                    //   memberReportSummary(widget.userId);
                  }
                } else {
                  resetVeri();
                  //  memberReportSummary(widget.userId);
                }
              },
              splashColor: Colors.pink,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                child: Text(
                  'Name',
                  style: TextStyle(
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
                    readOnly: true,
                    enabled: veri,
                    decoration: InputDecoration(
                      hintText: '',
                      contentPadding: EdgeInsets.all(5.0),
                      hintStyle: TextStyle(color: greyColor),
                    ),
                    controller: cName,
                    onChanged: (value) {
                      _nodeData.name = value;
                    },
                    focusNode: focusName,
                  ),
                ),
                margin: EdgeInsets.only(left: 30.0, right: 30.0),
              ),
              Container(
                child: Text(
                  'Address',
                  style: TextStyle(
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
                      hintText: '',
                      contentPadding: EdgeInsets.all(5.0),
                      hintStyle: TextStyle(color: greyColor),
                    ),
                    controller: cAddress,
                    onChanged: (value) {
                      _nodeData.address = value;
                    },
                    focusNode: focusAddress,
                  ),
                ),
                margin: EdgeInsets.only(left: 30.0, right: 30.0),
              ),
              Container(
                child: Text(
                  'Bank Account',
                  style: TextStyle(
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
                    style: TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: '',
                      contentPadding: EdgeInsets.all(5.0),
                      hintStyle: TextStyle(color: greyColor),
                    ),
                    controller: cBanKAccountNumber,
                    onChanged: (value) {
                      _nodeData.bankAccountNumber = value;
                    },
                    focusNode: focusBankAccount,
                  ),
                ),
                margin: EdgeInsets.only(left: 30.0, right: 30.0),
              ),
              Container(
                child: Text(
                  'Tax Number',
                  style: TextStyle(
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
                    style: TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: '',
                      contentPadding: EdgeInsets.all(5.0),
                      hintStyle: TextStyle(color: greyColor),
                    ),
                    controller: cTaxNumber,
                    onChanged: (value) {
                      _nodeData.taxNumber = value;
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
                        RaisedButton(
                          elevation: 11,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(21.0)),
                          child: Text(
                            'Update',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.indigo[900],
                          onPressed: () {/** */},
                        ),
                        RaisedButton(
                          elevation: 11,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(21.0)),
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.yellow[100]),
                          ),
                          color: Colors.red[900],
                          onPressed: () {/** */},
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
