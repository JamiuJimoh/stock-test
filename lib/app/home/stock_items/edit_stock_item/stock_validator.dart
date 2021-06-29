abstract class Validator {
  bool isValid(String value);
  bool isValidInteger(String value);
  bool isValidDouble(String value);
  bool isValidTimeToPrep(String value);
}

class ValidInputValidator implements Validator {
  @override
  bool isValid(String? value) {
    if (value == null) {
      return false;
    }
    return value.isNotEmpty;
  }

  @override
  bool isValidInteger(String value) {
    final itemCode = int.tryParse(value);
    if (itemCode == null) {
      return false;
    }
    return value.isNotEmpty && !itemCode.isNegative;
  }

  @override
  bool isValidDouble(String value) {
    final itemCode = double.tryParse(value);
    if (itemCode == null) {
      return false;
    }
    return value.isNotEmpty && !itemCode.isNegative;
  }

  @override
  bool isValidTimeToPrep(String value) {
    final time = int.tryParse(value);
    if (time == null) {
      return false;
    }
    return value.isNotEmpty && !time.isNegative && time >= 1;
  }
}

mixin StockItemValidators {
  final Validator itemNameValidator = ValidInputValidator();
  final Validator numValidator = ValidInputValidator();
  // final StringValidator mealDescriptionValidator = NonEmptyStringValidator();
  // final StringValidator priceValidator = NonEmptyStringValidator();
  // final StringValidator timeToPrepValidator = NonEmptyStringValidator();

  final String invalidItemNameErrorText = 'Item name can\'t be empty';
  final String invalidIntErrorText = 'Must be a valid number';
  final String invalidDoubleErrorText = 'Must be a valid number';
  // final String invalidItemCodeErrorText = 'Item code must be valid';
  // final String invalidMealDescriptionErrorText =
  //     'Meal description can\'t be empty';
  // final String invalidPriceErrorText = 'Price must be valid';
  // final String invalidTimeToPrepErrorText = 'Time must be valid';
}
