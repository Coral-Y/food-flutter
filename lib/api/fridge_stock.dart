import 'package:food/api/base.dart';
import 'package:food/model/fridge_stock.dart';

class FridgeStockApi {
  FridgeStockApi._();

  static final FridgeStockApi _instance = FridgeStockApi._();

  factory FridgeStockApi() {
    return _instance;
  }

  // 获取冰箱库存列表
  Future<List<FridgeStock>> list() async {
    try {
      var response = await BaseApi.request.get("/inventories");
      return (response['list'] as List)
          .map((item) => FridgeStock.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error fetching fridge stocks: $e");
      rethrow;
    }
  }

  // 添加冰箱库存
  Future<bool> add(FridgeStock stock) async {
    try {
      await BaseApi.request.post("/inventories", data: {
        "name": stock.name,
        "count": stock.count,
        "unit": stock.unit,
        "purchaseDate":
            "${stock.purchaseDate.year}-${stock.purchaseDate.month.toString().padLeft(2, '0')}-${stock.purchaseDate.day.toString().padLeft(2, '0')}",
        "shelfLife": stock.shelfLife,
        "location": stock.location,
      });
      return true;
    } catch (e) {
      print("Error adding fridge stock: $e");
      return false;
    }
  }

  // 修改冰箱库存
  Future<bool> update(FridgeStock stock) async {
    try {
      await BaseApi.request.put("/inventories/${stock.id}", data: {
        "name": stock.name,
        "count": stock.count,
        "unit": stock.unit,
        "purchaseDate":
            "${stock.purchaseDate.year}-${stock.purchaseDate.month.toString().padLeft(2, '0')}-${stock.purchaseDate.day.toString().padLeft(2, '0')}",
        "shelfLife": stock.shelfLife,
        "location": stock.location,
      });
      return true;
    } catch (e) {
      print("Error updating fridge stock: $e");
      return false;
    }
  }

  // 删除冰箱库存
  Future<bool> delete(int id) async {
    try {
      await BaseApi.request.delete("/inventories/$id");
      return true;
    } catch (e) {
      print("Error deleting fridge stock: $e");
      return false;
    }
  }
}

