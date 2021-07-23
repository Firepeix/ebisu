import 'package:ebisu/card/Domain/Card.dart';
import 'package:ebisu/card/Domain/Repositories/CardRepositoryInterface.dart';

class CardRepository implements CardRepositoryInterface {
  
  @override
  Map<int, String> getCardTypes() {
    return Map.fromIterable(CardType.values, key: (e) => e.index, value: (e) => e.toString().split('.').elementAt(1));
  }

  @override
  getCardClass() {
    return CardClass;
  }
}