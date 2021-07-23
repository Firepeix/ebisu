import 'package:ebisu/card/Domain/Repositories/CardRepositoryInterface.dart';
import 'package:ebisu/card/Infrastructure/Repositories/CardRepository.dart';

class CardModuleServiceProvider {
  static CardRepositoryInterface cardRepository () => CardRepository();
}