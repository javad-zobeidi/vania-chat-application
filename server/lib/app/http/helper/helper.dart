Future<int> genrateOtpCode({required int length}) async {
  String result = '';
  String numbers = '1234567890';
  List<String> list = numbers.split('');
  list.shuffle();
  list.shuffle();
  numbers = list.join('');
  for (int i = 0; i < length; i++) {
    result += numbers[i];
  }
  return int.parse(result);
}
