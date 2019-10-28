import 'package:firebase_database/firebase_database.dart';
import 'package:scoped_model/scoped_model.dart';

class ToolModel extends Model {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  String path = 'flamelink/environments/indoProduction/content/items/en-US/';
}
