import 'package:ebisu/shared/Domain/ValueObjects.dart';
import 'package:ebisu/shared/Infrastructure/Repositories/Persistence/GoogleSheetsRepository.dart';
import 'package:ebisu/shopping-list/Purchase/Domain/Purchase.dart';
import 'package:ebisu/shopping-list/Shared/Domain/Purchases.dart';
import 'package:ebisu/shopping-list/ShoppingList/Domain/Repositories/ShoppingListRepositoriesInterfaces.dart';
import 'package:ebisu/shopping-list/ShoppingList/Domain/ShoppingList.dart';
import 'package:ebisu/shopping-list/ShoppingList/Infrastructure/Persistence/Models/ShoppingListModels.dart';
import 'package:gsheets/gsheets.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: ShoppingListColdStorageRepositoryInterface)
class GoogleSheetShoppingListRepository extends GoogleSheetsRepository implements ShoppingListColdStorageRepositoryInterface {
  Future<ShoppingList> getShoppingList(String sheetName, { ShoppingList? mergeWith }) async {
    final _sheet = await sheet(sheetName);
    final amount = await _findShoppingListTotalAmount(_sheet);
    final list = ShoppingList(sheetName, amount);
    final rows = await _sheet.cells.allRows(fromRow: 8);
    _populateWithPurchases(list, rows, _sheet, mergeWith: mergeWith != null ? mergeWith.purchases : null);
    list.purchases.commit();
    return Future.value(list);
  }

  Future<ShoppingListInputAmount> _findShoppingListTotalAmount(Worksheet sheet) async {
    final value = await sheet.values.value(column: 2, row: 1);
    return Future.value(ShoppingListInputAmount(IntValueObject.integer(value)));
  }

  void _populateWithPurchases(ShoppingList list, List<List<Cell>> lines, Worksheet sheet, {Purchases? mergeWith}) {
    final List<Cell> cells = [];
    lines.forEach((line) {
      if (line[ListColumns.NAME.index].value != "") {
        final purchase = _buildPurchase(line);
        if (line.length >= 6 && line[ListColumns.AMOUNT_VALUE.index + 4].value != "0" && line[ListColumns.AMOUNT_VALUE.index + 4].value != "") {
            purchase.commit(_buildPurchase(line, offset: 4));
        }
        final localPurchase = mergeWith != null ? mergeWith.find(purchase.name) : null;
        if (!purchase.wasBought && localPurchase != null && localPurchase.wasBought) {
          purchase.commit(localPurchase.purchased!);
          cells.addAll(_buildCellsFromRow(line, purchase.purchased!));
        }

        list.purchases.add(purchase);
      }
    });

    _update(sheet, cells);
  }

  List<Cell> _buildCellsFromRow(List<Cell> original, Purchase bought) {
    final slice = original.sublist(ListColumns.TOTAL_VALUE.index + 1, ListColumns.TOTAL_VALUE.index + 4);
    slice[ListColumns.NAME.index].value = bought.name;
    slice[ListColumns.AMOUNT.index].value = bought.amount.simple;
    slice[ListColumns.AMOUNT_VALUE.index].value = bought.amount.value.money;
    return slice;
  }

  Future<void> _update(Worksheet sheet, List<Cell> cells) async {
    cells.forEach((element) {
      sheet.values.insertValue(element.value, column: element.column, row: element.row);
    });
  }

  Purchase _buildPurchase(List<Cell> line, { int offset =  0 }) {
    final value = IntValueObject.integer(line[ListColumns.AMOUNT_VALUE.index + offset].value);
    final originalQuantity = line[ListColumns.AMOUNT.index + offset].value;
    final quantity = IntValueObject.normal(originalQuantity.replaceAll("g", ""));
    final type = originalQuantity.endsWith("g") ? AmountType.WEIGHT : AmountType.UNIT;
    final amount = Amount(value, quantity, type);
    final name = line[ListColumns.NAME.index + offset].value != "" ? line[ListColumns.NAME.index + offset].value : line[0].value;
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