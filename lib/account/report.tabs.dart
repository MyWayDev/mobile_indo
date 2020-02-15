import 'package:flutter/material.dart';
import 'package:mor_release/account/report.dart';
import 'package:mor_release/scoped/connected.dart';
import 'package:mor_release/track/track.invoice.dart';
import 'package:mor_release/track/track.order.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';

class ReportTabs extends StatelessWidget {
  final AppBar _appBar = AppBar(
    leading: Container(),
    bottomOpacity: 0.0,
    backgroundColor: Colors.transparent,
    elevation: 20,
    ///////////////////////Top Tabs Navigation Widget//////////////////////////////
    title: TabBar(
      indicatorColor: Colors.grey,
      indicatorWeight: 4,
      indicatorSize: TabBarIndicatorSize.tab,
      tabs: <Widget>[
        Tab(
          icon: Icon(
            GroovinMaterialIcons.account_card_details,
            size: 29.0,
            color: Colors.pink[700],
          ),
        ),
        Tab(
          icon: Icon(
            GroovinMaterialIcons.account_plus,
            color: Colors.green[900],
            size: 29.0,
          ),
          // required
          //badgeColor: Colors.red, // default: Colors.red
          // default: Colors.white
          //hideZeroCount: true, // default: true

          /* icon: new Stack(children: <Widget>[
                        Icon(
                          Icons.shopping_cart,
                          size: 35.0,
                        ),
                        Positioned(
                            right: 0.0,
                            bottom: 0.0,
                            child: )
                      ]),*/
        ),
        Tab(
          icon: Icon(
            GroovinMaterialIcons.account_star,
            size: 29.0,
            color: Colors.amberAccent[400],
          ),
        ),
        Tab(
          icon: Icon(
            GroovinMaterialIcons.account_group,
            size: 29.0,
            color: Colors.black,
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(45.0), child: _appBar),
          body: TabBarView(
            children: <Widget>[
              Report(model.userInfo.distrId),
              TrackInvoice(model.userInfo.distrId),
              Report(model.userInfo.distrId),
              Report(model.userInfo.distrId),
              // ExpansionTileSample() // SwitchPage(ItemsPage()),
              //OrderPage(), //SwitchPage(OrderPage()),
              //ProductList(),
            ],
          ),
          /* bottomNavigationBar: BottomNavigationBar(
            currentIndex: 0,
            items: [
              BottomNavigationBarItem(
                  title: new Text('Account'),
                  icon: new Icon(Icons.account_box)),
              BottomNavigationBarItem(
                  icon: new Icon(Icons.mail), title: new Text('Messages')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), title: Text('Profile'))
            ],
          ),*/
        ),
      );
    });
  }
/*new BottomNavigationBarItem(
        title: new Text('Home'),
        icon: new Stack(
          children: <Widget>[
            new Icon(Icons.home),
            new Positioned(  // draw a red marble
              top: 0.0,
              right: 0.0,
              child: new Icon(Icons.brightness_1, size: 8.0, 
                color: Colors.redAccent),
            )
          ]
        ),
      )*/

}
