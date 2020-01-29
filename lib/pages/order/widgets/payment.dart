import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:mor_release/scoped/connected.dart';

class PaymentInfo extends StatelessWidget {
  final MainModel model;
  PaymentInfo(this.model);
  Flushbar flushAction(BuildContext context) {
    Flushbar flush = Flushbar(
      isDismissible: true,
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.bounceInOut,
      forwardAnimationCurve: Curves.elasticOut,
      mainButton: FlatButton(
        onPressed: () => Navigator.pop(context),
        child: Icon(Icons.done_all),
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
    );
    return flush;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          flushAction(context).dismiss(context);
          flushAction(context).show(context);
        },
        child: Icon(
          GroovinMaterialIcons.help_circle,
          color: Colors.black,
          size: 25,
        ));
  }
}
