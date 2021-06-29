import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock/app/home/models/stock_item.dart';
// import 'package:stock/services/stockItemBloc.dart';

import 'edit_stock_item/stock_item_bloc.dart';
import 'edit_stock_item/edit_stock_item.dart';
import 'stock_item_container.dart';

class StockItemsOverviewPage extends StatelessWidget {
  StockItemsOverviewPage({required this.stockItemBloc});
  final StockItemBloc stockItemBloc;

  static Widget create(BuildContext context) {
    final stockItemBloc = Provider.of<StockItemBloc>(context);
    return StockItemsOverviewPage(stockItemBloc: stockItemBloc);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Stock Items',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<List<StockItem>>(
        stream: stockItemBloc.itemStream,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final items = snapshot.data;
          if (items == null) {
            return Center(child: Text('No data'));
          }
          if (snapshot.hasData) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 1 * 0.48,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: items.length,
                itemBuilder: (_, index) => GestureDetector(
                  onTap: () =>
                      EditStockItem.show(context, stockItem: items[index]),
                  child: StockItemContainer(
                    context: context,
                    imageProvider: FileImage(items[index].itemImage),
                    itemName: items[index].itemName,
                    purchaseCost: items[index].purchaseCost,
                    salePrice: items[index].wholeSalePrice,
                  ),
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
