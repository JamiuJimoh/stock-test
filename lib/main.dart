import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock/app/home/stock_items/edit_stock_item/stock_item_bloc.dart';

import 'app/home/home_page.dart';
import 'services/database.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<Database>(
      create: (_) => RemoteDatabase(),
      child: Consumer<Database>(
        builder: (_, database, __) => Provider<StockItemBloc>(
          create: (_) => StockItemBloc(database: database),
          child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: Colors.grey[100],
              appBarTheme: AppBarTheme(
                  backgroundColor: Colors.grey[100], elevation: 0.0),
            ),
            home: HomePage(),
          ),
        ),
      ),
    );
  }
}
