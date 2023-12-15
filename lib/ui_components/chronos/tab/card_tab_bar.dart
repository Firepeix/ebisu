import 'package:ebisu/ui_components/chronos/cards/general_card.dart';
import 'package:ebisu/ui_components/chronos/labels/label.dart';
import 'package:flutter/material.dart';

class CardTab {
  final String title;
  final VoidCallback onPressed;

  CardTab({required this.title, required this.onPressed});
}

class CardTabBar extends StatefulWidget {
  final List<CardTab> tabs;

  const CardTabBar({required this.tabs, super.key});

  @override
  State<CardTabBar> createState() => _CardTabBarState();
}

class _CardTabBarState extends State<CardTabBar> {
  int activeIndex = 0;


  bool _isActive(int index) => activeIndex == index;

  void _setTab(int index) {
    Future.delayed(Duration(milliseconds: 50), () {
      setState(() {
        activeIndex = index;
        widget.tabs[index].onPressed();
      });
    });
  }

  List<GeneralCard> _createTabs() {
    final List<GeneralCard> tabs = [];

    widget.tabs.asMap().forEach((key, value) {
      final card = GeneralCard(
        child: Label(text: value.title, mode: _isActive(key) ? LabelMode.ACTIVE : LabelMode.NORMAL,),
        mode: _isActive(key) ? CardMode.ACTIVE : CardMode.NORMAL,
        onPressed: () => _setTab(key),
      );

      tabs.add(card);
    });


    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: widget.tabs.length,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: _createTabs(),
        )
    );
  }
}
