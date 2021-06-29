import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class RemoteService {
  RemoteService._();
  static final instance = RemoteService._();

  Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'places.db'),
        onCreate: (db, version) {
      return db.execute("""
        CREATE TABLE stock_items
        (
          id TEXT PRIMARY KEY, 
          itemName TEXT,
          itemImage TEXT,
          itemCode INTEGER,
          retailPrice INTEGER,
          wholeSalePrice INTEGER,
          purchaseCost INTEGER,
          unitMeasure TEXT,
          openingStock INTEGER,
          minStock INTEGER,
          notes TEXT
        )
        """);
    }, version: 1);
  }

  Future<void> setData({required Map<String, dynamic> data, String? id}) async {
    final database = await RemoteService._().database();
    if (id == null) {
      database.insert(
        'stock_items',
        data,
      );
    } else {
      database.update(
        'stock_items',
        data,
        where: 'id=?',
        whereArgs: [id],
      );
    }
  }

  Future<List<T>> collectionFuture<T>({
    required T Function(Map<String, dynamic> data) builder,
  }) async {
    final database = await RemoteService._().database();
    final items = await database.query('stock_items');
    return items.map((item) => builder(item)).toList();
  }

  // Future<void> setData({
  //   required String path,
  //   required Map<String, dynamic> data,
  // }) async {
  //   final documentReference = FirebaseFirestore.instance.doc(path);
  //   print('path===$path, data===$data');
  //   await documentReference.set(data);
  // }
}
