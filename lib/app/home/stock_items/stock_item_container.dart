import 'package:flutter/material.dart';
import 'package:stock/common_widgets/custom_container.dart';

class StockItemContainer extends CustomContainer {
  StockItemContainer({
    required BuildContext context,
    required ImageProvider<Object> imageProvider,
    required String itemName,
    required double purchaseCost,
    required double salePrice,
  }) : super(
          borderRadius: 5.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 7,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      topRight: Radius.circular(5.0),
                    ),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5.0),
                      bottomRight: Radius.circular(5.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: Transform.translate(
                          offset: Offset(-15, 0),
                          child: SizedBox(
                            width: 5.0,
                            child: Text(
                              itemName,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        subtitle: Transform.translate(
                          offset: Offset(-15, 0),
                          child: Text(
                            'Category',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(fontSize: 9.0),
                          ),
                        ),
                        trailing: Transform.translate(
                          offset: Offset(15, 0),
                          child: Icon(Icons.tune_outlined),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rs. $purchaseCost',
                                style: TextStyle(
                                  color: Colors.deepOrangeAccent,
                                ),
                              ),
                              Text(
                                'Purchase Cost',
                                style: TextStyle(
                                    color: Colors.grey[400], fontSize: 9.0),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Rs. $salePrice',
                                style: TextStyle(
                                  color: Colors.teal,
                                ),
                              ),
                              Text(
                                'Sale Cost',
                                style: TextStyle(
                                    color: Colors.grey[400], fontSize: 9.0),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
}
