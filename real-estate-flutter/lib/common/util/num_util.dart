extension DoubleEx on double {
  String toStringAsDynamic(int fractionDigits) {
    var numbers = this.toStringAsFixed(fractionDigits).split('.');
    var integer = numbers[0];
    var decimal = numbers[1];
    for (int i = fractionDigits; i > 0; --i) {
      if (decimal.substring(decimal.length - 1, decimal.length) == '0') {
        decimal = decimal.substring(0, decimal.length - 1);
      } else {
        break;
      }
    }
    return decimal.isNotEmpty ? '$integer.$decimal' : integer.toString();
  }
}