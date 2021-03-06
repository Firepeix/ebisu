import 'package:ebisu/shared/Domain/Bus/Command.dart';
import 'package:ebisu/shopping-list/Purchase/Domain/Purchase.dart';
import 'package:ebisu/shopping-list/ShoppingList/Domain/Repositories/ShoppingListRepositoriesInterfaces.dart';
import 'package:ebisu/shopping-list/ShoppingList/Domain/ShoppingList.dart';
import 'package:injectable/injectable.dart';

class CreateShoppingListCommand implements Command {
  final ShoppingListBuilder _builder;
  CreateShoppingListCommand(this._builder);

  ShoppingListBuilder get builder => _builder;
}

@injectable
class CreateShoppingListCommandHandler implements CommandHandler<CreateShoppingListCommand> {
  final ShoppingListColdStorageRepositoryInterface _coldShoppingList;
  final ShoppingListRepositoryInterface _repository;
  CreateShoppingListCommandHandler(this._coldShoppingList, this._repository);

  @override
  Future<void> handle(CreateShoppingListCommand command) async {
    ShoppingList? list;
    if (command.builder.type == SHOPPING_LIST_TYPE.SHEET.index) {
        list = await _coldShoppingList.getShoppingList(command.builder.name);
        await _repository.store(list);
        return;
    }
    Future.error("Metodo não implementado");
  }
}

class GetShoppingListCommand implements Command {
}

@injectable
class GetShoppingListCommandHandler implements CommandHandler<GetShoppingListCommand> {
  final ShoppingListRepositoryInterface _repository;
  GetShoppingListCommandHandler(this._repository);

  @override
  Future<void> handle(GetShoppingListCommand command) async {
    final lists = await _repository.getShoppingLists();
    return Future.value(lists);
  }
}

class SyncShoppingListCommand implements Command {
  final dynamic listId;
  final String name;
  final ShoppingListSyncType type;
  SyncShoppingListCommand(this.listId, this.name, this.type);
}

@injectable
class SyncShoppingListCommandHandler implements CommandHandler<SyncShoppingListCommand> {
  final ShoppingListColdStorageRepositoryInterface _coldShoppingList;
  final ShoppingListRepositoryInterface _repository;
  SyncShoppingListCommandHandler(this._coldShoppingList, this._repository);

  @override
  Future<ShoppingList> handle(SyncShoppingListCommand command) async {
    if (command.type == ShoppingListSyncType.pull) {
      return await handlePull(command);
    }
    return Future.error("Metodo não implementado");
  }

  Future<ShoppingList> handlePull(SyncShoppingListCommand command) async {
    final localList = await _repository.find(command.listId);
    final list = await _coldShoppingList.getShoppingList(command.name, mergeWith: localList);
    list.id = command.listId;
    list.purchases.applyListId(list.id);
    await _repository.update(list);
    return list;
  }
}

class UpdatePurchaseOnListCommand implements Command {
  final Purchase _purchase;

  Purchase get purchase => _purchase;

  UpdatePurchaseOnListCommand(this._purchase);
}

@injectable
class UpdatePurchaseOnListCommandHandler implements CommandHandler<UpdatePurchaseOnListCommand> {
  final ShoppingListRepositoryInterface _repository;
  UpdatePurchaseOnListCommandHandler(this._repository);

  @override
  Future<ShoppingList> handle(UpdatePurchaseOnListCommand command) async {
    final list = await _repository.find(command._purchase.shoppingListId);
    _repository.updatePurchase(command.purchase, list);
    return Future.value(list);
  }
}