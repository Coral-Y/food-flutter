import 'package:food/utils/request.dart';
import 'package:food/config.dart';

class BaseApi {
  static final Request request = Request('$SERVER_URI/food');
}
