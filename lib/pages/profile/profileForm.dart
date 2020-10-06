import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mor_release/models/area.dart';
import 'package:mor_release/scoped/connected.dart';
import 'package:http/http.dart' as http;
import 'package:mor_release/widgets/color_loader_2.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import '../const.dart';

class ProfileForm extends StatefulWidget {
  final MainModel model;
  ProfileForm(this.model, {Key key}) : super(key: key);

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  List<Bank> banks;
  List<DropdownMenuItem> bankList = [];
  String selectedBank;
  var bankSplit;

  TextEditingController cName; //done
  TextEditingController cAddress; //done
  TextEditingController cDistrId; //done
  TextEditingController cPersonalId;
  TextEditingController cTelePhone; //done
  TextEditingController cEmail;
  TextEditingController cBirthDate;
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
  final FocusNode fcousBirth = new FocusNode();
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

  void resetVeri() {
    distrController.clear();
    cDistrId.clear();
    cName.clear();
    cAddress.clear();
    cEmail.clear();
    cBirthDate.clear();
    cBanKAccountNumber.clear();
    cTaxNumber.clear();
    cTelePhone.clear();
    cPersonalId.clear();
    cBankAccountName.clear();
    cAreaName.clear();
    cServiceCenter.clear();
    veri = false;
    isChanged = false;
  }

  void getBanks() async {
    banks = [];
    final response = await http
        .get('http://mywayindoapi.azurewebsites.net/api/get_bank_info/');
    if (response.statusCode == 200) {
      final _banks = json.decode(response.body) as List;
      banks = _banks.map((s) => Bank.json(s)).toList();
      //areaPlace.forEach((a) => print(a.spName));
    } else {
      banks = [];
    }

    if (banks.isNotEmpty) {
      for (var t in banks) {
        String sValue = "${t.bankId}" + " " + "${t.bankName}";
        bankList.add(
          DropdownMenuItem(
              child: Text(
                sValue,
                style: TextStyle(fontSize: 12),
              ),
              value: sValue),
        );
      }
    }
  }

  @override
  void initState() {
    getBanks();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /*void updateFormData() {
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
  }*/

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      child: SingleChildScrollView(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          reverse: true,
          child: Column(children: [
            ListTile(
              leading: Container(
                child: Text(
                  'Bank Account / Name',
                  style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
                margin: EdgeInsets.only(left: 15.0),
              ),
              title: Container(
                child: Theme(
                  data: Theme.of(context).copyWith(primaryColor: primaryColor),
                  child: TextFormField(
                    //enabled: veri,
                    initialValue: widget.model.nodeEditData.bankAccountNumber,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      hintText: 'Bank Account',
                      contentPadding: EdgeInsets.all(5.0),
                      hintStyle: TextStyle(color: greyColor),
                    ),
                    controller: cBanKAccountNumber,
                    onChanged: (value) {
                      setState(() {
                        widget.model.nodeEditData.bankAccountNumber = value;
                        isChanged = true;
                      });
                    },
                    focusNode: focusBankAccount,
                  ),
                ),
                margin: EdgeInsets.only(left: 1.0, right: 30.0),
              ),
              subtitle: Container(
                child: Theme(
                  data: Theme.of(context).copyWith(primaryColor: primaryColor),
                  child: TextFormField(
                    // enabled: veri,
                    initialValue: widget.model.nodeEditData.bankAccoutName,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      hintText: 'Account Name',
                      contentPadding: EdgeInsets.all(3.0),
                      hintStyle: TextStyle(color: greyColor),
                    ),
                    controller: cBankAccountName,
                    onChanged: (value) {
                      setState(() {
                        widget.model.nodeEditData.bankAccoutName = value;
                        isChanged = true;
                      });
                    },
                    focusNode: focusAccountName,
                  ),
                ),
                margin: EdgeInsets.only(left: 1.0, right: 30.0),
              ),
            ),
            Container(
              child: Theme(
                data: Theme.of(context).copyWith(primaryColor: Colors.pink),
                child: Wrap(children: <Widget>[
                  Icon(GroovinMaterialIcons.bank, color: Colors.pink[500]),
                  SearchableDropdown(
                    isExpanded: true,
                    //style: TextStyle(fontSize: 12),
                    hint: Text('Bank'),
                    iconEnabledColor: Colors.pink[200],
                    iconDisabledColor: Colors.grey,
                    items: bankList,
                    value: selectedBank,
                    onChanged: (value) {
                      setState(() {
                        selectedBank = value;
                        bankSplit = selectedBank.split('\ ');
                        print(bankSplit);
                      });
                    },
                  )
                ]),
              ),
              margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5),
            ),
          ])),
      inAsyncCall: _isloading,
      opacity: 0.6,
      progressIndicator: ColorLoader2(),
    );
  }

  Widget buildProfileForm(BuildContext context) {
    return Text('data');
  }
}
