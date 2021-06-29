import 'dart:async';

import 'package:stock/app/home/models/stock_item.dart';
import 'package:stock/services/database.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class StockItemBloc {
  final Database database;
  StockItemBloc({required this.database}) {
    getItem();

    _addItemController.stream.listen((item) => _handleItem(item));
  }

  String? _itemId;

  void getItemId() {
    print(_itemId);
  }

  final _stockItemController = StreamController<List<StockItem>>.broadcast();

  StreamSink<List<StockItem>> get itemSink => _stockItemController.sink;

  Stream<List<StockItem>> get itemStream => _stockItemController.stream;

  final _addItemController = StreamController<StockItem>.broadcast();

  StreamSink<StockItem> get inAddStockItem => _addItemController.sink;

  Future<void> getItem() async {
    List<StockItem> stockItem = await database.getItems();
    itemSink.add(stockItem);
  }

  Future<void> _handleItem(StockItem item) async {
    // Create the stockItem in the database
    await database.setItem(stockData: item, dataId: _itemId);

    // Retrieve all the stockItems again after one is added.
    // This allows our pages to update properly and display the
    // newly added stockItem.
    getItem();
  }

  set setItemId(String? id) {
    _itemId = id;
  }

  void dispose() {
    _stockItemController.close();
    _addItemController.close();
  }
}
