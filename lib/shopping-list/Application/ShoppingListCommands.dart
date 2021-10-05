import 'package:ebisu/shared/Domain/Bus/Command.dart';
import 'package:ebisu/shopping-list/ShoppingList/Domain/ShoppingList.dart';
import 'package:ebisu/shopping-list/ShoppingList/Domain/ShoppingListService.dart';
import 'package:injectable/injectable.dart';

class CreateShoppingListCommand implements Command {
  final ShoppingListBuilder _builder;
  CreateShoppingListCommand(this._builder);

  ShoppingListBuilder get builder => _builder;
}

@injectable
class CreateShoppingListCommandHandler implements CommandHandler<CreateShoppingListCommand> {
  final ShoppingListServiceInterface _service;
  CreateShoppingListCommandHandler(this._service);

  @override
  Future<void> handle(CreateShoppingListCommand command) async {
    if (command.builder.type == SHOPPING_LIST_TYPE.SHEET) {

    }
    final list = _service.createShoppingList(command.builder);
    print('asd');
  }
}