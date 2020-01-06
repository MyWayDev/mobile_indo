import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mor_release/bottom_nav.dart';
import 'package:mor_release/widgets/save_bulk_dialog.dart';

import 'package:mor_release/widgets/save_dialog.dart';

import 'package:mor_release/scoped/connected.dart';
import 'package:scoped_model/scoped_model.dart';

class OrderSave extends StatelessWidget {
  final String courierId;
  final double courierFee;
  final double courierDiscount;
  final String distrId;
  final String note;
  final String userId;
  final String areaId;
  final formatter = new NumberFormat("#,###");

  OrderSave(this.courierId, this.courierFee, this.courierDiscount, this.distrId,
      this.note, this.areaId, this.userId);
  double orderTotal(MainModel model) {
    return (courierFee - courierDiscount) +
        model.orderSum() +
        model.settings.adminFee;
  }

  double bulkOrderTotal(MainModel model) {
    return (courierFee - courierDiscount) +
        model.bulkOrderSum() +
        model.settings.adminFee;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return saveButton(context, model);
    });
  }

  Widget saveButton(BuildContext context, MainModel model) {
    return !model.isBulk
        ? Column(
            children: <Widget>[
              Padding(
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
                                padding: const EdgeInsets.only(right: 2.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Total Keseluruhan',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                      //  textDirection: TextDirection.rtl,
                                    ),
                                    Text(
                                      "  + 10% PPN",
                                      style: TextStyle(
                                          color: Colors.pink[800],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11),
                                    ),
                                  ],
                                )),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Text(
                            formatter.format((orderTotal(model) * 1.1)) + ' Rp',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      onPressed: () {
                        model.isBalanceChecked = true;

                        // model.promoOrderList.forEach(
                        //   (f) => print('bp?:${model.orderBp() / f.bp} qty:${f.qty}'));
                        //model.isTypeing = false;
                        showDialog(
                            context: context,
                            builder: (_) => SaveDialog(
                                courierId,
                                (courierFee - courierDiscount),
                                distrId,
                                note,
                                areaId,
                                userId));
                      })),
            ],
          )
        : Column(
            children: <Widget>[
              Padding(
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
                                padding: const EdgeInsets.only(right: 2.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Total Keseluruhan',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                      //  textDirection: TextDirection.rtl,
                                    ),
                                    Text(
                                      "  + 10% PPN",
                                      style: TextStyle(
                                          color: Colors.pink[800],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11),
                                    ),
                                  ],
                                )),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Text(
                            formatter.format((bulkOrderTotal(model) * 1.1)) +
                                ' Rp',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      onPressed: () async {
                        model.isBalanceChecked = true;

                        // model.promoOrderList.forEach(
                        //   (f) => print('bp?:${model.orderBp() / f.bp} qty:${f.qty}'));
                        model.isTypeing = false;
                        /*   await model.saveBulkOrders(model.bulkOrder,
                            (courierFee - courierDiscount), note, courierId);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BottomNav(model.userInfo.distrId),
                          ),
                        );*/

                        showDialog(
                            context: context,
                            builder: (_) => SaveBulkDialog(
                                courierId,
                                (courierFee - courierDiscount),
                                distrId,
                                note,
                                areaId,
                                userId));
                      })),
            ],
          );
  }
}

/*

 */
