import 'package:firebase_database/firebase_database.dart';

class Area {
  String areaId;
  String name;

  Area({this.areaId, this.name});

  Area.fromSnapshot(DataSnapshot snapshot)
      : areaId = snapshot.value['areaId'],
        name = snapshot.value['name'];
  factory Area.json(Map<dynamic, dynamic> json) {
    return Area(areaId: json['areaId'], name: json['name']);
  }
  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(areaId: json['AREA_ID'], name: json['ANAME']);
  }
  toJson() {
    return {
      "areaId": areaId,
      "name": name,
      "id": areaId,
    };
  }
}

class Region {
  String regionId;
  String name;
  bool distrPoint;
  int id;
  Region({this.regionId, this.name, this.id, this.distrPoint});
  Region.fromSnapshot(DataSnapshot snapshot)
      : regionId = snapshot.value['regionId'],
        name = snapshot.value['name'],
        id = snapshot.value['id'];

  factory Region.json(Map<dynamic, dynamic> json) {
    return Region(
        id: json['id'],
        regionId: json['regionId'],
        name: json['name'],
        distrPoint: json['distrPoint'] ?? false);
  }
}
