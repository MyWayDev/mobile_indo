import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:intl/intl.dart';
import 'package:mor_release/models/lock.dart';
import 'package:mor_release/pages/items/itemDetails/footer.dart';
import 'package:mor_release/pages/order/widgets/distrPointButton.dart';
import 'package:mor_release/pages/order/widgets/storeFloat.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../models/item.dart';
import '../items/item.card.dart';
import 'package:mor_release/scoped/connected.dart';

class ItemsPage extends StatefulWidget {
  final MainModel model;
  ItemsPage(this.model);
  @override
  State<StatefulWidget> createState() {
    return _ItemsPage();
  }
}

@override
class _ItemsPage extends State<ItemsPage> with SingleTickerProviderStateMixin {
  final formatWeight = new NumberFormat("#,###.##");
  //String db = 'production';
  String path =
      "flamelink/environments/indoProduction/content/items/en-US"; //! VERY IMPORTANT change back to production before release
  List<Item> itemData = List();
  List<Item> searchResult = [];
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  var subAdd;
  var subChanged;
  TextEditingController controller = new TextEditingController();
  AnimationController _animationController;
  Lock lock;

  //bool defaultDB = true;

  @override
  void initState() {
    databaseReference = database.reference().child(path);
    Query query = databaseReference.orderByChild('catalogue').equalTo(true);
    widget.model.getStores();
    //!TODO ADD QUERY TO FILTER PRODUCTS NOT IN CATALOGE..
    subAdd = query.onChildAdded.listen(_onItemEntryAdded);
    subChanged = query.onChildChanged.listen(_onItemEntryChanged);
    _animationController =
        new AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat();
    super.initState();
  }

  @override
  void dispose() {
    subAdd?.cancel();
    subChanged?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  dialogDistrPoints(BuildContext context, MainModel model) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Color(0xFF303030),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(top: 8),
                      height: 250,
                      width: 220,
                      child: storesDialog()),
                  /*  RawMaterialButton(
                    child: Icon(
                      Icons.close,
                      size: 18.0,
                      color: Colors.white,
                    ),
                    shape: CircleBorder(),
                    highlightColor: Colors.pink[900],
                    elevation: 3,
                    fillColor: Colors.red,
                    onPressed: () {
                      _isMap = true;
                      Navigator.of(context).pop();
                    },
                    splashColor: Colors.pink[900],
                  ),*/
                ],
              ),
            ),
          );
        });
  }

  String type;
  bool isSelected = false;
  void _valueChanged(bool v) {
    setState(() {
      isSelected = v;
    });
  }

  Widget storesDialog() {
    return ListView.builder(
      itemCount: widget.model.stores.length,
      itemBuilder: (context, index) {
        return RaisedButton(
          color: Colors.amberAccent,
          elevation: 5,
          child: widget.model.stores.length > 0
              ? Column(
                  children: <Widget>[
                    Text(widget.model.stores[index].name,
                        style: TextStyle(color: Colors.black)),
                    /*     FormField(
                        // initialValue: [],
                        //key: _formKey,
                        enabled: true,
                        builder: (FormFieldState<dynamic> field) {
                          return ScopedModelDescendant<MainModel>(
                            builder: (BuildContext context, Widget child,
                                MainModel model) {
                              return DropdownButton(
                                isExpanded: true,
                                items: widget.model.stores.map((option) {
                                  return DropdownMenuItem(
                                      child: Text("${option.name}"),
                                      value: option.docType);
                                }).toList(),
                                value: field.value,
                                onChanged: (value) async {
                                  field.didChange(value);
                                  type = value;
                                  _valueChanged(true);
                                  print('dropDown value:$value');
                                  // int x = types.indexOf(value);
                                },
                              );
                            },
                          );
                        }),*/
                  ],
                )
              : Text('Data Loading error'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.black),
          ),
          onPressed: () async {
            setState(() {
              widget.model.setStoreId = widget.model.stores[index].storeId;
              widget.model.distrPoint = widget.model.stores[index].region;
              widget.model.distrPointName = widget.model.stores[index].name;
              widget.model.docType = widget.model.stores[index].docType;
            });
            print('region:${widget.model.distrPoint}');
            //  await widget.model.getPoints(widget.model.stores[index].region);
            print('setStore:${widget.model.setStoreId}');
            print('name:${widget.model.distrPointName}');
            print('DocType:${widget.model.docType}');
            await widget.model.getPoints(widget.model.stores[index].region);

            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  Widget _showNeedHelpButton() {
    return Padding(
      padding: widget.model.bulkOrder.length > 0 ||
              widget.model.itemorderlist.length > 0
          ? EdgeInsets.only(bottom: 26)
          : EdgeInsets.only(top: 16),
      child: Material(
        //Wrap with Material
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),

        elevation: 20.0,
        color: Colors.amber,
        clipBehavior: Clip.antiAliasWithSaveLayer, // Add This
        child: Opacity(
            opacity: widget.model.bulkOrder.length > 0 ||
                    widget.model.itemorderlist.length > 0
                ? .50
                : 1,
            child: MaterialButton(
                minWidth: 180.0,
                height: 30,
                color: Color(0xFF303030),
                child: Row(
                  children: <Widget>[
                    FadeTransition(
                      opacity: _animationController,
                      child: Icon(GroovinMaterialIcons.map_marker_radius,
                          color: Colors.amber, size: 20),
                    ),
                    Padding(padding: EdgeInsets.only(right: 8)),
                    Text(widget.model.distrPointNames,
                        style: TextStyle(
                            fontSize: 13,
                            // fontWeight: FontWeight.bold,
                            color: Colors.amber[50])),
                  ],
                ),
                onPressed: widget.model.bulkOrder.length > 0 ||
                        widget.model.itemorderlist.length > 0
                    ? () {}
                    : () {
                        dialogDistrPoints(context, widget.model);
                      })),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      model.itemData = itemData;
      model.searchResult = searchResult;

      return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          label: Padding(
            child: Column(
              children: <Widget>[
                model.orderSum() > 0
                    ? Wrap(
                        spacing: 24,
                        runSpacing: 10,
                        direction: Axis.horizontal,
                        children: <Widget>[
                          Chip(
                            elevation: 5,
                            shadowColor: Colors.black,
                            backgroundColor: Colors.grey[350],
                            avatar: CircleAvatar(
                              backgroundColor: Colors.green[700],
                              child: Text('Rp',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold)),
                            ),
                            label: Text(
                              formatter.format(model.orderSum()),
                              style: TextStyle(
                                  color: Colors.green[700],
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Chip(
                            elevation: 5,
                            shadowColor: Colors.black,
                            backgroundColor: Colors.grey[350],
                            avatar: CircleAvatar(
                              backgroundColor: Colors.pink[900],
                              child: Text('Bp',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold)),
                            ),
                            label: Text(
                              model.orderBp().toString(),
                              style: TextStyle(
                                  color: Colors.pink[900],
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Chip(
                            elevation: 5,
                            shadowColor: Colors.black,
                            backgroundColor: Colors.grey[350],
                            avatar: CircleAvatar(
                              backgroundColor: Colors.black,
                              child: Text('kg',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold)),
                            ),
                            label: Text(
                              formatWeight.format(model.orderWeight()),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )
                    : Container(),
                // MyBlinkingButton()
                StoreFloat(model)
              ],
            ),
            padding: EdgeInsets.only(right: 35),
          ),

          isExtended: true,
          elevation: 30,
          //onPressed:,
          icon: Icon(
            Icons.arrow_right,
            color: Colors.transparent,
          ),
          backgroundColor: Colors.transparent, onPressed: () {},
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        resizeToAvoidBottomPadding: false,
        body: Column(
          children: <Widget>[
            Container(
              height: 58,
              color: Theme.of(context).primaryColorLight,
              child: Card(
                child: ListTile(
                  leading: Icon(
                    Icons.search,
                    size: 22.0,
                  ),
                  title: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "",
                      border: InputBorder.none,
                    ),
                    // style: TextStyle(fontSize: 18.0),
                    onChanged: onSearchTextChanged,
                  ),
                  trailing: IconButton(
                    alignment: AlignmentDirectional.centerEnd,
                    icon: Icon(Icons.cancel, size: 20.0),
                    onPressed: () {
                      controller.clear();
                      onSearchTextChanged('');
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: searchResult.length != 0 || controller.text.isNotEmpty
                  ? ListView.builder(
                      itemCount: searchResult.length,
                      itemBuilder: (context, i) {
                        return ItemCard(searchResult, i);
                      },
                    )
                  : ListView.builder(
                      itemCount: itemData.length,
                      itemBuilder: (context, index) {
                        return ItemCard(itemData, index);
                      },
                    ),
            ),
          ],
        ),
      );
    });
  }

  onSearchTextChanged(String text) {
    searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    itemData.where((i) => !i.disabled).forEach((item) {
      if (item.name.toLowerCase().contains(text.toLowerCase()) ||
          item.itemId.contains(text)) searchResult.add(item);
    });
    setState(() {});
  }

  void _onItemEntryAdded(Event event) {
    //List<Item> items = List();
    itemData.add(Item.fromSnapshot(event.snapshot));
    // items.where((i) => !i.disabled).forEach((f) => itemData.add(f));
    //print("itemData length:${itemData.length}");
    setState(() {});
  }

  void _onItemEntryChanged(Event event) {
    var oldEntry = itemData.lastWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      itemData[itemData.indexOf(oldEntry)] = Item.fromSnapshot(event.snapshot);
    });
  }
}

/*

  Flushbar flushAction(BuildContext context) {
    Flushbar f = Flushbar(
      isDismissible: false,
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.bounceIn,
      forwardAnimationCurve: Curves.fastOutSlowIn,

      mainButton: FlatButton(
        onPressed: () {
          _isMap = true;
          Navigator.of(context).pop();
        },
        child: Icon(
          GroovinMaterialIcons.close_circle_outline,
          color: Colors.red,
        ),
      ),
      margin: EdgeInsets.all(1),
      borderRadius: 8,
      title: 'Order From',
      messageText: Container(
        padding: EdgeInsets.all(8.0),
        child: Flexible(
          fit: FlexFit.tight,
          flex: 1,
          child: ModalProgressHUD(
              color: Colors.transparent,
              inAsyncCall: widget.model.isloading,
              opacity: 0.1,
              progressIndicator: LinearProgressIndicator(
                backgroundColor: Colors.grey[200],
              ),
              child: getRegions()),
        ),
      ),
      //  message: 'Silahkan Lakukan Pembayaran Melalui',
      icon: Icon(
        GroovinMaterialIcons.map_marker_radius,
        color: Colors.amberAccent,
        size: 28,
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.red[800],
          offset: Offset(0.0, 2.0),
          blurRadius: 3.0,
        )
      ],
    );
    return f;
  }
*/
