import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mor_release/scoped/connected.dart';
import 'package:scoped_model/scoped_model.dart';

class OrderSummary extends StatelessWidget {
  final String courierId;
  final double courierFee;
  final String distrId;
  final String note;
  final formatter = new NumberFormat("#,###");

  OrderSummary(this.courierId, this.courierFee, this.distrId, this.note);
  double orderTotal(MainModel model) {
    return courierFee + model.orderSum() + model.settings.adminFee;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          model.orderBp() > 0
              ? Container(
                  height: 130,
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    // scrollDirection: Axis.vertical,
                    children: <Widget>[
                      /*   Container(
                    height: 30,
                    child: ListTile(
                      leading: Text(model.itemCount().toString() + ' Pcs'),
                      trailing: Icon(
                        Icons.add_shopping_cart,
                        color: Colors.green,
                      ),
                      title: Text(
                        'عدد الاصناف',
                        textDirection: TextDirection.rtl,
                      ),
                    )),*/
                      Container(
                          height: 27,
                          child: ListTile(
                            title: Center(
                              child:
                                  Text(model.orderWeight().toString() + ' Kg'),
                            ),
                            trailing: Icon(
                              Icons.save_alt,
                              color: Colors.black,
                            ),
                            leading: Text(
                              'Total Weight',
                              // textDirection: TextDirection.rtl,
                            ),
                          )),
                      Container(
                          height: 27,
                          child: ListTile(
                            title: Center(
                              child: Text(model.orderBp().toString() + ' Bp'),
                            ),
                            trailing: Icon(
                              Icons.trending_up,
                              color: Colors.green,
                            ),
                            leading: Text(
                              'Total Poin',
                              // textDirection: TextDirection.rtl,
                            ),
                          )),
                      Container(
                          height: 27,
                          child: ListTile(
                            title: Center(
                              child: Text(formatter.format(courierFee) + ' Rp'),
                            ),
                            trailing: Icon(
                              Icons.local_shipping,
                              color: Colors.pink[900],
                            ),
                            leading: Text(
                              'Biaya Kurir',
                              // textDirection: TextDirection.rtl,
                            ),
                          )),
                      Container(
                          height: 27,
                          child: ListTile(
                            title: Center(
                              child: Text(
                                  formatter.format(model.orderSum()) + ' Rp'),
                            ),
                            trailing: Icon(
                              Icons.monetization_on,
                              color: Colors.pink[900],
                            ),
                            leading: Text(
                              'Total Tagihan',
                              // textDirection: TextDirection.rtl,
                            ),
                          )),
                      /* Container(
                          height: 27,
                          child: ListTile(
                            title: Text(
                                formatter.format(model.settings.adminFee) +
                                    ' Rp'),
                            trailing: Icon(
                              Icons.more_horiz,
                              color: Colors.pink[900],
                            ),
                            leading: Text(
                              'Biaya Admin',
                              //  textDirection: TextDirection.rtl,
                            ),
                          )),*/
                    ],
                  ),
                )
              : Container()
        ],
      );
    });
  }
}
/* @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Flex(
        direction: Axis.vertical,
        children: <Widget>[
          ListTile(
            leading: Text(
              orderTotal(model).toString() + ' Rp',
              style: TextStyle(
                  color: Colors.pink[900], fontWeight: FontWeight.bold),
            ),
            trailing: RaisedButton(
              child: Text(
                'Menyimpan',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              color: Colors.green,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) => SaveDialog(
                        courierId, courierFee, model.userInfo.distrId, note));

                print(
                    'courierId:$courierId fee:$courierFee distr:${model.userInfo.distrId}note:$note');
                
                                                          model.orderBalanceCheck(
                                                            stateValue
                                                                .courierId,
                                                            courierFee);
              },
            ),
            title: Text(
              'Total pesanan',
              style: TextStyle(fontWeight: FontWeight.bold),
              textDirection: TextDirection.rtl,
            ),
          ),
        ],
      );
    });
  }*/
