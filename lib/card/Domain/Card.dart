import 'package:ebisu/shared/Domain/ValueObjects.dart';

class Card {

}

class CardType extends StringValueObject {
  CardType(String value) : super(value);
}

enum CardClass {
  DEBIT,
  CREDIT
}