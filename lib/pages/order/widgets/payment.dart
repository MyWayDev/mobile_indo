import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:mor_release/scoped/connected.dart';

class PaymentInfo extends StatelessWidget {
  final MainModel model;
  PaymentInfo(this.model);
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Flushbar(
            isDismissible: false,
            flushbarPosition: FlushbarPosition.BOTTOM,
            flushbarStyle: FlushbarStyle.FLOATING,
            reverseAnimationCurve: Curves.decelerate,
            forwardAnimationCurve: Curves.elasticOut,
            mainButton: FlatButton(
              onPressed: () => Navigator.of(context).pop(),
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
          ).show(context);
        },
        child: Icon(
          GroovinMaterialIcons.help_circle,
          color: Colors.black,
          size: 25,
        ));
  }
}
