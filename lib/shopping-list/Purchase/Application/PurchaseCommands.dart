import 'package:ebisu/shared/Domain/Bus/Command.dart';
import 'package:ebisu/shopping-list/Purchase/Domain/Purchase.dart';
import 'package:ebisu/shopping-list/Purchase/Domain/Services/PurchaseService.dart';
import 'package:ebisu/shopping-list/Purchase/UI/Components/Purchase.dart';
import 'package:injectable/injectable.dart';

class CommitPurchaseCommand implements Command {
  final Purchase _purchase;
  final PurchaseBuilder _builder;

  CommitPurchaseCommand(this._purchase, this._builder);

  Purchase get purchase => _purchase;

  PurchaseBuilder get builder => _builder;
}

@injectable
class CommitPurchaseCommandHandler implements CommandHandler<CommitPurchaseCommand> {
  final PurchaseServiceInterface _service;

  CommitPurchaseCommandHandler(this._service);

  @override
  Future<void> handle(CommitPurchaseCommand command) async {
    _service.commitPurchase(command.purchase, command.builder);
  }
}
