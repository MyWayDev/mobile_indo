import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:mor_release/widgets/save_dialog.dart';

import 'package:mor_release/scoped/connected.dart';
import 'package:scoped_model/scoped_model.dart';

class OrderSave extends StatelessWidget {
  final String courierId;
  final double courierFee;
  final String distrId;
  final String note;
  final String userId;
  final String areaId;
  final formatter = new NumberFormat("#,###");

  OrderSave(this.courierId, this.courierFee, this.distrId, this.note,
      this.areaId, this.userId);
  double orderTotal(MainModel model) {
    return courierFee + model.orderSum() + model.settings.adminFee;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return saveButton(context, model);
    });
  }

  Widget saveButton(BuildContext context, MainModel model) {
    return Padding(
        padding: EdgeInsets.only(top: 1),
        child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            splashColor: Theme.of(context).primaryColor,
            color: Colors.tealAccent[400],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Transform.translate(
                  offset: Offset(1.0, 0.0),
                  child: Container(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Text(
                      'Total Keseluruhan',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      //  textDirection: TextDirection.rtl,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Text(
                  formatter.format(orderTotal(model)) + ' Rp',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            onPressed: () {
              model.isBalanceChecked = true;

              model.promoOrderList.forEach(
                  (f) => print('bp?:${model.orderBp() / f.bp} qty:${f.qty}'));
              //model.isTypeing = false;
              showDialog(
                  context: context,
                  builder: (_) => SaveDialog(
                      courierId, courierFee, distrId, note, areaId, userId));
            }));
  }
}
