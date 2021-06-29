import 'dart:io';

class StockItem {
  final String id;
  final String itemName;
  final File itemImage;
  final int itemCode;
  final double retailPrice;
  final double wholeSalePrice;
  final double purchaseCost;
  final String unitMeasure;
  final int openingStock;
  final int minStock;
  final String notes;

  StockItem({
    required this.id,
    required this.itemName,
    required this.itemImage,
    required this.itemCode,
    required this.retailPrice,
    required this.wholeSalePrice,
    required this.purchaseCost,
    required this.unitMeasure,
    required this.openingStock,
    required this.minStock,
    required this.notes,
  });

  StockItem.fromDb(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        itemName = parsedJson['itemName'],
        itemImage = File(parsedJson['itemImage']),
        itemCode = parsedJson['itemCode'],
        retailPrice = parsedJson['retailPrice'].toDouble(),
        wholeSalePrice = parsedJson['wholeSalePrice'].toDouble(),
        purchaseCost = parsedJson['purchaseCost'].toDouble(),
        unitMeasure = parsedJson['unitMeasure'],
        openingStock = parsedJson['openingStock'],
        minStock = parsedJson['minStock'],
        notes = parsedJson['notes'];

  Map<String, dynamic> toMapForDb() {
    return <String, dynamic>{
      'id': id,
      'itemName': itemName,
      'itemImage': itemImage.path,
      'itemCode': itemCode,
      'retailPrice': retailPrice,
      'wholeSalePrice': wholeSalePrice,
      'purchaseCost': purchaseCost,
      'unitMeasure': unitMeasure,
      'openingStock': openingStock,
      'minStock': minStock,
      'notes': notes,
    };
  }

  @override
  String toString() {
    return 'id: $id, itemName: $itemName, itemImage: $itemImage';
  }
}
