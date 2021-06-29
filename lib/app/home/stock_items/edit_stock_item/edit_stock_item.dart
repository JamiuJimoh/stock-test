import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock/app/home/models/stock_item.dart';
// import 'package:stock/services/stockItemBloc.dart';

import 'stock_item_bloc.dart';
import 'edit_stock_item_text_form_field.dart';
import 'image_input.dart';
import 'stock_validator.dart';

class EditStockItem extends StatefulWidget with StockItemValidators {
  EditStockItem({required this.stockItemBloc, this.stockItem});

  final StockItemBloc stockItemBloc;
  final StockItem? stockItem;

  static Future<void> show(BuildContext context, {StockItem? stockItem}) async {
    final stockItemBloc = Provider.of<StockItemBloc>(context, listen: false);
    if (stockItem == null) {
      stockItemBloc.setItemId = null;
    } else {
      stockItemBloc.setItemId = stockItem.id;
    }
    stockItemBloc.getItemId();

    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) =>
            EditStockItem(stockItemBloc: stockItemBloc, stockItem: stockItem),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditStockItemState createState() => _EditStockItemState();
}

class _EditStockItemState extends State<EditStockItem> {
  File? _pickedImage;

  final _formKey = GlobalKey<FormState>();

  var _isLoading = false;

  var _initialValue = <String, dynamic>{
    'itemName': '',
    'itemCode': '',
    'retailPrice': '',
    'wholeSalePrice': '',
    'purchaseCost': '',
    'unitMeasure': '',
    'openingStock': '',
    'minStock': '',
    'notes': '',
  };

  @override
  void initState() {
    super.initState();
    if (widget.stockItem != null) {
      _initialValue = {
        'itemName': widget.stockItem?.itemName,
        'itemImage': widget.stockItem?.itemImage,
        'itemCode': widget.stockItem?.itemCode,
        'retailPrice': widget.stockItem?.retailPrice,
        'wholeSalePrice': widget.stockItem?.wholeSalePrice,
        'purchaseCost': widget.stockItem?.purchaseCost,
        'unitMeasure': widget.stockItem?.unitMeasure,
        'openingStock': widget.stockItem?.openingStock,
        'minStock': widget.stockItem?.minStock,
        'notes': widget.stockItem?.notes,
      };
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState!;
    if (_pickedImage == null && widget.stockItem?.itemImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Row(
            children: [
              Icon(Icons.warning, color: Colors.yellow),
              const SizedBox(width: 6.0),
              Text('Stock item must have an image'),
            ],
          ),
        ),
      );
      return false;
    }
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  ////// HELPER METHODS ////////

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        setState(() {
          _isLoading = true;
        });

        final itemId = widget.stockItem?.id ?? documentIdFromCurrentDate();
        final itemImage = _pickedImage ?? widget.stockItem?.itemImage;
        final stockItem = StockItem(
          id: itemId,
          itemName: _initialValue['itemName'],
          itemImage: itemImage!,
          itemCode: _initialValue['itemCode'],
          retailPrice: _initialValue['retailPrice'],
          wholeSalePrice: _initialValue['wholeSalePrice'],
          purchaseCost: _initialValue['purchaseCost'],
          unitMeasure: _initialValue['unitMeasure'],
          openingStock: _initialValue['openingStock'],
          minStock: _initialValue['minStock'],
          notes: _initialValue['notes'],
        );

        widget.stockItemBloc.inAddStockItem.add(stockItem);
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
        // } on FirebaseException catch (e) {
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print(e);
        // showExceptionAlertDialog(
        //   context,
        //   title: 'Operation failed',
        //   exception: e,
        // );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(
          widget.stockItem == null ? 'Add Stock Item' : 'Edit Stock Item',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : IconButton(
                    icon: Icon(
                      Icons.save,
                      size: 30.0,
                    ),
                    onPressed: _isLoading ? null : _submit,
                  ),
          ),
        ],
      ),
      body: _buildContent(),
    );
  }

  ////// WIDGETS METHODS ////////

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
        child: Card(
          elevation: 0.8,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      EditStockItemTextFormField(
        initialValue: _initialValue['itemName'],
        labelText: 'Item name',
        textInputAction: TextInputAction.next,
        onSaved: (value) => _initialValue['itemName'] = value,
        validator: (value) => widget.itemNameValidator.isValid(value!)
            ? null
            : widget.invalidItemNameErrorText,
      ),
      const SizedBox(height: 20.0),
      ImageInput(
        onSelectImage: _selectImage,
        initialImage: _initialValue['itemImage'],
      ),
      const SizedBox(height: 20.0),
      EditStockItemTextFormField(
        initialValue: _initialValue['itemCode'].toString(),
        labelText: 'Item Code / Barcode',
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        onSaved: (value) =>
            _initialValue['itemCode'] = int.tryParse(value ?? '0')!,
        validator: (value) => widget.numValidator.isValidInteger(value!)
            ? null
            : widget.invalidIntErrorText,
      ),
      const SizedBox(height: 20.0),

      Row(
        children: [
          Expanded(
            child: EditStockItemTextFormField(
              initialValue: _initialValue['retailPrice'].toString(),
              labelText: 'Retail Price',
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onSaved: (value) => _initialValue['retailPrice'] =
                  double.tryParse(value ?? '0.0')!,
              validator: (value) => widget.numValidator.isValidDouble(value!)
                  ? null
                  : widget.invalidDoubleErrorText,
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: EditStockItemTextFormField(
              initialValue: _initialValue['wholeSalePrice'].toString(),
              labelText: 'Wholesale Price',
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onSaved: (value) => _initialValue['wholeSalePrice'] =
                  double.tryParse(value ?? '0.0')!,
              validator: (value) => widget.numValidator.isValidDouble(value!)
                  ? null
                  : widget.invalidDoubleErrorText,
            ),
          ),
        ],
      ),
      const SizedBox(height: 20.0),

      Row(
        children: [
          Expanded(
            child: EditStockItemTextFormField(
              initialValue: _initialValue['purchaseCost'].toString(),
              labelText: 'Purchase Cost',
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onSaved: (value) => _initialValue['purchaseCost'] =
                  double.tryParse(value ?? '0.0')!,
              validator: (value) => widget.numValidator.isValidDouble(value!)
                  ? null
                  : widget.invalidDoubleErrorText,
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: _buildDropDown(_initialValue['unitMeasure']),
          ),
        ],
      ),
      const SizedBox(height: 20.0),
// _initialValue['notes']

      Row(
        children: [
          Expanded(
            child: EditStockItemTextFormField(
              initialValue: _initialValue['openingStock'].toString(),
              labelText: 'Opening Stock',
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onSaved: (value) =>
                  _initialValue['openingStock'] = int.tryParse(value ?? '0')!,
              validator: (value) => widget.numValidator.isValidInteger(value!)
                  ? null
                  : widget.invalidIntErrorText,
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: EditStockItemTextFormField(
              initialValue: _initialValue['minStock'].toString(),
              labelText: 'Min Stock',
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onSaved: (value) =>
                  _initialValue['minStock'] = int.tryParse(value ?? '0')!,
              validator: (value) => widget.numValidator.isValidInteger(value!)
                  ? null
                  : widget.invalidIntErrorText,
            ),
          ),
        ],
      ),
      const SizedBox(height: 20.0),
      EditStockItemTextFormField(
        initialValue: _initialValue['notes'],
        labelText: 'Write your private notes here',
        maxLines: 4,
        textInputAction: TextInputAction.next,
        onSaved: (value) => _initialValue['notes'] = value,
      ),
    ];
  }

  DropdownButtonFormField _buildDropDown(String initialUnit) {
    final items = <String>['PCs', 'AMs', 'TRx', 'UVs', 'JTs'];
    return DropdownButtonFormField(
      decoration: InputDecoration(
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 15.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
      ),
      value: widget.stockItem == null ? null : initialUnit,
      hint: Text('Unit Measure'),
      items: [
        for (var item in items)
          DropdownMenuItem(
            child: Text(item),
            value: item,
          ),
      ],
      onChanged: (val) {
        _initialValue['unitMeasure'] = val;
      },
      validator: (value) => value != null ? null : 'Please select a unit',
    );
  }
}
