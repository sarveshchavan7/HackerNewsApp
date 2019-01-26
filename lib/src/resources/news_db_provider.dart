import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import '../models/item_model.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'repository.dart';

class NewsDbProvider implements Source, Cache {
  Database db;

  NewsDbProvider() {
    init();
  }

  // TODO: implement fetchTopId
  Future<List<int>> fetchTopId() {
    return null;
  }

  void init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'items.db');
    db = await openDatabase(path, version: 1,
        onCreate: (Database newDb, int version) {
      newDb.execute("""
            CREATE TABLE Items  
            (
              id INTEGER PRIMARY KEY,
              type TEXT,
              by TEXT,
              time INTEGER,
              text TEXT,
              parent INTEGER,
              kids BLOB,
              dead INTEGER,
              deleted INTEGER,
              url TEXT,
              score INTEGER,
              title TEXT,
              descendants INTEGER
            )
          """);
    });
  }

  Future<ItemModel> fetchItems(int id) async {
    final map = await db.query(
      'Items',
      columns: null,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (map.length > 0) {
      return ItemModel.fromDb(map.first);
    }
    return null;
  }

  Future<int> addItem(ItemModel items) {
    return db.insert('Items', items.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<int> clear(){
    return db.delete('Items');
  }
}

final newsDbProvider = NewsDbProvider();
