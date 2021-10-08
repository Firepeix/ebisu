import 'package:ebisu/shopping-list/Purchase/Domain/Repositories/PurchaseRepositoriesInterfaces.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import 'Models/PurchaseModel.dart';

@Singleton(as: PurchaseRepositoryInterface)
class PurchaseHiveRepository implements PurchaseRepositoryInterface
{
  static const BOX = 'purchases';

  Future<Box> _getBox() async {
    return await Hive.openBox<PurchaseHiveModel>(BOX);
  }
}
