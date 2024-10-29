String arrayToString(List<String>? array) =>
    (array == null || array.isEmpty) ? '' : array.join('^');

List<String> stringToArray(String? str) =>
    (str == null || str.isEmpty) ? [] : str.split('^');
