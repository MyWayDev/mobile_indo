import 'package:flutter/material.dart';
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
  TextEditingController distrController = new TextEditingController();
  bool _isloading = false;

  void isloading(bool i) {
    setState(() {
      _isloading = i;
    });
  }

  bool veri = false;
  //int _courier;
  NewMember _nodeData = NewMember(name: '');

  void resetVeri() {
    distrController.clear();
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
      resizeToAvoidBottomPadding: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      body: ModalProgressHUD(
        child: Padding(
          padding: EdgeInsets.only(top: 28),
          child: Container(
            child: buildVeri(context),
          ),
        ),
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
            leading: Icon(Icons.vpn_key, size: 25.0, color: Colors.pink[500]),
            title: TextFormField(
              textAlign: TextAlign.center,
              controller: distrController,
              enabled: !veri ? true : false,
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
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
                      color: Colors.blue,
                    )
                  : distrController.text.length > 0
                      ? Icon(
                          Icons.close,
                          size: 28.0,
                          color: Colors.grey,
                        )
                      : Container(),
              color: Colors.pink[900],
              onPressed: () async {
                if (distrController.text == 'sari') {
                } else {
                  if (!veri) {
                    veri = await widget.model.leaderVerification(
                        distrController.text.padLeft(8, '0'));
                    if (veri) {
                      _nodeData = await widget.model
                          .nodeEdit(distrController.text.padLeft(8, '0'));
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
                }
              },
              splashColor: Colors.pink,
            ),
          ),
          Container(
            child: Text(
              'Name',
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  color: primaryColor),
            ),
            margin: EdgeInsets.only(left: 10.0, top: 30.0, bottom: 5.0),
          ),
          Container(
            child: Theme(
              data: Theme.of(context).copyWith(primaryColor: primaryColor),
              child: TextFormField(
                initialValue: _nodeData.name,
                decoration: InputDecoration(
                  hintText: '',
                  contentPadding: EdgeInsets.all(5.0),
                  hintStyle: TextStyle(color: greyColor),
                ),
                onChanged: (value) {
                  _nodeData.name = value;
                },
              ),
            ),
            margin: EdgeInsets.only(left: 30.0, right: 30.0),
          ),
        ],
      ),
    );
  }
}
