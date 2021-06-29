import 'package:flutter/material.dart';
import 'package:stock/app/home/stock_items/edit_stock_item/edit_stock_item.dart';
import 'package:stock/app/home/stock_items/stock_items_overview_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StockItemsOverviewPage.create(context),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => EditStockItem.show(context),
      ),
    );
  }
}
