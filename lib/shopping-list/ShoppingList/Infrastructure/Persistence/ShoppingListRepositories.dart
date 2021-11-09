import 'package:ebisu/shared/Domain/ValueObjects.dart';
import 'package:ebisu/shared/Infrastructure/Repositories/Persistence/GoogleSheetsRepository.dart';
import 'package:ebisu/shopping-list/Purchase/Domain/Purchase.dart';
import 'package:ebisu/shopping-list/ShoppingList/Domain/Repositories/ShoppingListRepositoriesInterfaces.dart';
import 'package:ebisu/shopping-list/ShoppingList/Domain/ShoppingList.dart';
import 'package:ebisu/shopping-list/ShoppingList/Infrastructure/Persistence/Models/ShoppingListModels.dart';
import 'package:gsheets/gsheets.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: ShoppingListColdStorageRepositoryInterface)
class GoogleSheetShoppingListRepository extends GoogleSheetsRepository implements ShoppingListColdStorageRepositoryInterface {
  Future<ShoppingList> getShoppingList(String sheetName) async {
    final _sheet = await sheet(sheetName);
    final amount = await _findShoppingListTotalAmount(_sheet);
    final list = ShoppingList(sheetName, amount);
    final rows = await _sheet.values.allRows(fromRow: 8);
    _populateWithPurchases(list, rows);
    list.purchases.commit();
    return Future.value(list);
  }

  Future<ShoppingListInputAmount> _findShoppingListTotalAmount(Worksheet sheet) async {
    final value = await sheet.values.value(column: 2, row: 1);
    return Future.value(ShoppingListInputAmount(IntValueObject.integer(value)));
  }

  void _populateWithPurchases(ShoppingList list, List<List<String>> lines) {
    lines.forEach((line) {
      if (line[ListColumns.NAME.index] != "") {
        final purchase = _buildPurchase(line);
        if (line.length >= 6 && line[ListColumns.AMOUNT_VALUE.index + 4] != "0" && line[ListColumns.AMOUNT_VALUE.index + 4] != "") {
            purchase.commit(_buildPurchase(line, offset: 4));
        }
        list.purchases.add(purchase);
      }
    });
  }

  Purchase _buildPurchase(List<String> line, { int offset: 0 }) {
    final value = IntValueObject.integer(line[ListColumns.AMOUNT_VALUE.index + offset]);
    final originalQuantity = line[ListColumns.AMOUNT.index + offset];
    final quantity = IntValueObject.normal(originalQuantity.replaceAll("g", ""));
    final type = originalQuantity.endsWith("g") ? AmountType.WEIGHT : AmountType.UNIT;
    final amount = Amount(value, quantity, type);
    final name = line[ListColumns.NAME.index + offset] != "" ? line[ListColumns.NAME.index + offset] : line[0];
    return Purchase(name, amount);
  }
}

enum ListColumns {
  NAME,
  AMOUNT,
  AMOUNT_VALUE,
  TOTAL_VALUE,
}

@Singleton(as: ShoppingListRepositoryInterface)
class ShoppingListHiveRepository implements ShoppingListRepositoryInterface
{
  static const SHOPPING_LIST_BOX = 'shopping-lists';

  Future<Box> _getBox() async {
    return await Hive.openBox<ShoppingListHiveModel>(SHOPPING_LIST_BOX);
  }

  Future<List<ShoppingList>> getShoppingLists() async {
    final box = await _getBox();
    final List<ShoppingList> lists = [];
    box.values.forEach((model) {
      model = model as ShoppingListHiveModel;
      final list = ShoppingList(model.name, ShoppingListInputAmount(model.amount), id: model.key);
      list.purchases.populateFromJson(model.serializedPurchases, list.id);
      lists.add(list);
    });
    return lists.reversed.toList();
  }

  Future<void> store(ShoppingList list) async {
    final box = await _getBox();
    final model = ShoppingListHiveModel(list.name, list.input.value, list.purchases.toJson());
    await box.add(model);
  }

  Future<void> update(ShoppingList list) async {
    final box = await _getBox();
    final model = ShoppingListHiveModel(list.name, list.input.value, list.purchases.toJson());
    await box.put(list.id, model);
  }

  @override
  Future<void> updatePurchase(Purchase purchase, ShoppingList list) async {
    list.purchases.updatePurchase(purchase);
    update(list);
  }

  @override
  Future<ShoppingList> find(dynamic id) async {
    final box = await _getBox();
    final model = box.get(id) as ShoppingListHiveModel;
    final list = ShoppingList(model.name, ShoppingListInputAmount(model.amount), id: model.key);
    list.purchases.populateFromJson(model.serializedPurchases, list.id);
    return list;
  }
}