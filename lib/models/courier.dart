import 'package:firebase_database/firebase_database.dart';

class Courier {
  var key;
  var id;
  String courierId;
  String name;
  List service;

  Courier({this.courierId, this.name, this.service, this.id});

  Courier.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        id = snapshot.value['id'],
        courierId = snapshot.value['courierId'],
        name = snapshot.value['name'],
        service = snapshot.value['service'];

  factory Courier.fromJson(Map<String, dynamic> json) {
    return Courier(courierId: json['DS_SHIPMENT_COMP'], name: json['ANAME']);
  }
  factory Courier.fromList(Map<dynamic, dynamic> list) {
    return Courier(
        courierId: list['courierId'], name: list['name'], id: list['id']);
  }
  toJson() {
    return {
      "courierId": courierId,
      "name": name + '1',
      "id": courierId,
    };
  }
}

class Service {
  String id;
  var fees;
  var freeBp;
  var minWeight;
  var rate;
  List areas;
  Service(
      {this.id, this.fees, this.freeBp, this.areas, this.minWeight, this.rate});

  factory Service.fromJson(Map<dynamic, dynamic> json) {
    return Service(
        id: json['uniqueKey'],
        fees: json['fees'],
        freeBp: json['freeBp'],
        areas: json['areas'],
        minWeight: json['minWeight'],
        rate: json['rate']);
  }
  toJson() {
    return {
      "fees": fees,
      "freeBP": freeBp,
      "areas": areas,
    };
  }

  Service.fromSnapshot(DataSnapshot snapshot)
      : id = snapshot.value['uniqueKey'],
        fees = snapshot.value['fees'],
        freeBp = snapshot.value['freeBp'],
        areas = snapshot.value['areas'];
}

class ShipmentArea {
  String shipmentArea;
  String shipmentName;
  String shipmentAddress;
  ShipmentArea({this.shipmentArea, this.shipmentName, this.shipmentAddress});
  factory ShipmentArea.fromJson(Map<String, dynamic> json) {
    return ShipmentArea(
        shipmentArea: json['DS_SHIPMENT_PLACE'],
        shipmentName: json['SPNAME'],
        shipmentAddress: json['ADDRESS_NOTES']);
  }
}
