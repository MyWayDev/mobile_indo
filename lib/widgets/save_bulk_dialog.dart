import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mor_release/bottom_nav.dart';
import 'package:mor_release/models/item.order.dart';
import 'package:mor_release/pages/order/widgets/outStockDialog.dart';
import 'package:mor_release/pages/order/widgets/payment.dart';
import 'package:mor_release/scoped/connected.dart';
import 'package:mor_release/track/track.order.dart';
import 'package:mor_release/widgets/color_loader_2.dart';
import 'package:scoped_model/scoped_model.dart';

class SaveBulkDialog extends StatefulWidget {
  final String courierId;
  final double courierFee;
  final String distrId;
  final String note;
  final String areaId;
  final String userId;
  const SaveBulkDialog(this.courierId, this.courierFee, this.distrId, this.note,
      this.areaId, this.userId,
      {Key key})
      : super(key: key);

  @override
  _SaveBulkDialogState createState() => _SaveBulkDialogState();
}

class _SaveBulkDialogState extends State<SaveBulkDialog> {
  List<ItemOrder> balanceCheckOutPut = [];
  OrderBulkMsg bulkIds = new OrderBulkMsg(ids: [], error: '');

  List<ItemOrder> msg = List();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void isLoading(bool o, MainModel model) {
    setState(() {
      model.loading = o;
    });
  }

  double orderTotal(MainModel model) {
    return widget.courierFee + model.orderSum() + model.settings.adminFee;
  }

  double bulkOrderTotal(MainModel model) {
    return widget.courierFee + model.bulkOrderSum() + model.settings.adminFee;
  }

  @override
  Widget build(BuildContext context) {
    return _saveDialog(context);
  }

  Widget _saveDialog(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      /* Flushbar fu = Flushbar(
        isDismissible: true,
        flushbarPosition: FlushbarPosition.BOTTOM,
        flushbarStyle: FlushbarStyle.GROUNDED,
        reverseAnimationCurve: Curves.decelerate,
        forwardAnimationCurve: Curves.elasticOut,
        mainButton: FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.done_all,
            color: Colors.lightGreenAccent[400],
          ),
        ),
        margin: EdgeInsets.all(8),
        borderRadius: 8,
        title: model.settings.bankInfo,
        message: 'Silahkan Lakukan Pembayaran Melalui',
        icon: Icon(
          GroovinMaterialIcons.bank,
          color: Colors.greenAccent,
        ),
        boxShadows: [
          BoxShadow(
            color: Colors.red[800],
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          )
        ],
      );*/
      return ModalProgressHUD(
        child: model.giftPacks.length == 0 &&
                model.isBalanceChecked &&
                balanceCheckOutPut.length == 0
            ? dialogOrderCard(context, model)
            : dialogOutCard(context, model),
        inAsyncCall: model.loading,
        opacity: 0.6,
        progressIndicator: ColorLoader2(),
      );
    });
  }

  final formatter = new NumberFormat("#,###");
  Widget orderCard(BuildContext context, MainModel model, int i) {
    return Container(
      height: 50,
      child: Card(
        color: Color(0xFFFFFFF1),
        elevation: 5,
        child: ListTile(
          leading: Text(
            int.parse(model.bulkOrder[i].distrId).toString(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Rp ${formatter.format(model.bulkOrder[i].total)}',
                style: TextStyle(color: Colors.green[700], fontSize: 12),
              ),
              Text(
                'Bp ${model.bulkOrder[i].totalBp.toStringAsFixed(2)}',
                style: TextStyle(color: Colors.red[900], fontSize: 12),
              ),
            ],
          ),
          trailing: Text(
            'Kg ${model.bulkOrder[i].weight.toStringAsFixed(2)}',
            style: TextStyle(color: Colors.black, fontSize: 12),
          ),
        ),
      ),
    );
  }

/*  bulkIds.ids.length != 0
                          ? Container(
                              height: 300,
                              width: 275,
                              child: ListView.builder(
                                itemCount: bulkIds.ids.length,
                                itemBuilder: (context, i) {
                                  return saveMsg(context, i);
                                },
                              ),
                            )
                          : errorMsg(context), */
  Widget orderOutCard(BuildContext context, MainModel model, int i) {
    return Container(
      height: 50,
      child: Card(
        color: Color(0xFFFFFFF1),
        elevation: 5,
        child: ListTile(
          leading: Text(
            balanceCheckOutPut[i].itemId,
            style: TextStyle(color: Colors.green[700], fontSize: 12),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                balanceCheckOutPut[i].qty.toString(),
                style: TextStyle(color: Colors.red[900], fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dialogOutCard(BuildContext context, MainModel model) {
    return Dialog(
      backgroundColor: Colors.yellow[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        height: 475.0,
        width: 310.0,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Card(
              elevation: 3,
              color: Colors.grey[100],
              child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text(
                        'ITEM',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text(
                        'AVALABLE STOCK',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Text(
                        '',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ]),
            ),
            Container(
              height: 300,
              width: 275,
              child: ListView.builder(
                itemCount: balanceCheckOutPut.length,
                itemBuilder: (context, i) {
                  return orderOutCard(context, model, i);
                },
              ),
            ),
            Container(
                height: 125.0,
                width: MediaQuery.of(context).size.width,
                color: Colors.yellow[100],
                child: Padding(
                  padding: const EdgeInsets.only(left: 1.0, right: 1.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'order telah diubah sesuai' +
                                ' dengan ketersediaan saat ini',
                            overflow: TextOverflow.clip,
                            softWrap: true,
                            style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        RawMaterialButton(
                          child: Icon(
                            Icons.undo,
                            size: 24.0,
                            color: Colors.white,
                          ),
                          shape: CircleBorder(),
                          highlightColor: Colors.pink[900],
                          elevation: 3,
                          fillColor: Colors.yellow[900],
                          onPressed: () {
                            Navigator.of(context).pop();
                            model.deleteEmptyOrders();
                            /*  Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) => BulkOrder(
                                                          model,
                                                          model.shipmentArea,
                                                          model.distrPoint)));*/
                          },
                          splashColor: Colors.pink[900],
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'kebali ke modifikasi',
                                //textDirection: TextDirection.ltr,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                            ]),
                      ]),
                )),
          ],
        ),
      ),
    );
  }

  Widget dialogOrderCard(BuildContext context, MainModel model) {
    return Dialog(
      backgroundColor:
          bulkIds.ids.length == 0 ? Colors.white : Colors.green[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        height: 530,
        width: 310.0,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          children: <Widget>[
            bulkIds.ids.length == 0
                ? Card(
                    elevation: 3,
                    color: Colors.grey[100],
                    child: Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              'Jumlah',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              'Kode',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Text(
                              '#',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ]),
                  )
                : Card(
                    elevation: 3,
                    color: Colors.grey[100],
                    child: Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Center(
                            // TOD  padding: EdgeInsets.only(right: 10),
                            child: Text(
                              'Invoice Number',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ]),
                  ),
            bulkIds.ids.length == 0
                ? Container(
                    height: 300,
                    width: 275,
                    child: ListView.builder(
                      itemCount: model.bulkOrder.length,
                      itemBuilder: (context, i) {
                        return orderCard(context, model, i);
                      },
                    ),
                  )
                : Container(
                    height: 300,
                    width: 275,
                    child: ListView.builder(
                      itemCount: bulkIds.ids.length,
                      itemBuilder: (context, i) {
                        return saveMsg(context, i);
                      },
                    ),
                  ),
            // : errorMsg(context),
            SizedBox(height: 20.0),
            //  Text('Silahkan Lakukan Pembayaran Melalui'),
            bulkIds.ids.length == 0
                ? Container(
                    height: 50.0,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RawMaterialButton(
                              child: Icon(
                                Icons.undo,
                                size: 24.0,
                                color: Colors.white,
                              ),
                              shape: CircleBorder(),
                              highlightColor: Colors.pink[900],
                              elevation: 3,
                              fillColor: Colors.yellowAccent[700],
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              splashColor: Colors.pink[900],
                            ),
                            !model.loading && bulkIds.ids.length == 0
                                ? RawMaterialButton(
                                    child: Icon(
                                      Icons.done,
                                      size: 24.0,
                                      color: Colors.white,
                                    ),
                                    shape: CircleBorder(),
                                    highlightColor: Colors.pink[900],
                                    elevation: 3,
                                    fillColor: Colors.green,
                                    onPressed: () async {
                                      // Navigator.of(context).pop();
                                      // fu.dismiss(context);
                                      //fu.show(context);
                                      isLoading(true, model);
                                      balanceCheckOutPut =
                                          await model.bulkOrderBalanceCheck(
                                              model.bulkOrder);
                                      isLoading(false, model);
                                      if (balanceCheckOutPut.length == 0) {
                                        isLoading(true, model);
                                        bulkIds =
                                            await model.mockSaveBulkOrders(
                                                model.bulkOrder,
                                                widget.courierFee,
                                                widget.note +
                                                    model.shipmentAddress,
                                                widget.courierId);
                                        isLoading(false, model);
                                        PaymentInfo(model)
                                            .flushAction(context)
                                            .show(context);
                                        /*OutStock(balanceCheckOutPut)
                                                  .flushAction(context)
                                                  .show(context);*/
                                      }

                                      /* Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PaymentInfo(model)
                                                    // ItemDetails(widget.itemData[widget.index])
                                                    ));*/
                                      model.bulkItemsList(model.bulkOrder);

                                      /* isLoading(true, model);
                                            msg = await model.saveBulkOrders(
                                              model.bulkOrder,
                                              widget.courierFee,
                                              widget.note +
                                                  model.shipmentAddress,
                                              widget.courierId,
                                            );

                                            print(
                                                'bulkOrderBp:${model.bulkOrderBp()}');
                                            if (model.bulkOrderBp() == 0 &&
                                                model.bulkOrder.length ==
                                                    0) if (model.loading) {
                                              model.isTypeing = false;
                                              Navigator.pop(context);
                                              isLoading(false, model);*/
                                      /* showReview(
                                                  context, msg, msg.first);*/
                                      /* model.isTypeing = false;
                                            } else {
                                              isLoading(false, model);
                                            }*/
                                    },
                                    splashColor: Colors.pink[900],
                                  )
                                : Container(),
                          ]),
                    ))
                : Container(),
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    formatter.format((bulkOrderTotal(model) * 1.1)) + ' Rp',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  bulkIds.ids.length != 0
                      ? RawMaterialButton(
                          child: Icon(
                            Icons.close,
                            size: 24.0,
                            color: Colors.white,
                          ),
                          shape: CircleBorder(),
                          highlightColor: Colors.pink[900],
                          elevation: 3,
                          fillColor: Colors.pink[900],
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BottomNav(widget.userId),
                                  // ItemDetails(widget.itemData[widget.index])
                                ),
                                (_) => false);
                          },
                          splashColor: Colors.pink[900],
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget saveMsg(BuildContext context, int i) {
    return Container(
      height: 50,
      child: Card(
        color: Color(0xFFFFFFF1),
        elevation: 5,
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                bulkIds.ids[i],
                style: TextStyle(color: Colors.green[700], fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget errorMsg(BuildContext context) {
    return Container(
      height: 50,
      child: Card(
        color: Color(0xFFFFFFF1),
        elevation: 5,
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                bulkIds.error,
                style: TextStyle(color: Colors.red[900], fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> showReview(
      BuildContext context, List<String> ids, String error) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Container(
                  height: 300,
                  width: 275,
                  child: SingleChildScrollView(
                    child: ListView.builder(
                      itemCount: ids.length,
                      itemBuilder: (context, i) {
                        return ids != null || ids != []
                            ? Text(
                                '$ids: nomor order',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              )
                            : Text(
                                '$error',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.red),
                              );
                      },
                    ),
                  )),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();

                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomNav(widget.userId),
                        // ItemDetails(widget.itemData[widget.index])
                      ),
                      (_) => false);
                },
                child: Container(
                  height: 35.0,
                  width: 35.0,
                  color: Colors.white,
                  child: Icon(
                    Icons.close,
                    color: Colors.grey,
                    size: 24,
                  ),
                ),
              ),
            ]),
          );
        });
  }
}
