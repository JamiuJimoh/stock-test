import 'package:stock/app/home/models/stock_item.dart';
import 'package:stock/services/remote_service.dart';

abstract class Database {
  Future<void> setItem({required StockItem stockData, String? dataId});
  Future<List<StockItem>> getItems();
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class RemoteDatabase implements Database {
  final _service = RemoteService.instance;

  @override
  Future<void> setItem({required StockItem stockData, String? dataId}) async => _service.setData(
      data: stockData.toMapForDb(),
      id: dataId,
    );

  @override
  Future<List<StockItem>> getItems() async => _service.collectionFuture(
        builder: (data) => StockItem.fromDb(data),
      );
}
