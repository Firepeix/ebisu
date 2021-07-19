import 'package:flutter/material.dart';

class BottomNavBarItem {
  IconData iconData;
  String text;
  double iconSize = 30;

  BottomNavBarItem({required this.iconData, required this.text});
}

class BottomNavBar extends StatefulWidget {
  final List<BottomNavBarItem> items = _createItems();
  final ValueChanged<int> onTabSelected;
  final Color selectedColor = Colors.redAccent;
  final Color color = Colors.black;
  final double height = 60;
  final String centerItemText;

  BottomNavBar({
    required this.onTabSelected,
    required this.centerItemText,
  });

  @override
  State<StatefulWidget> createState() => _NavBarState();

  static List<BottomNavBarItem> _createItems () {
    return [
      BottomNavBarItem(iconData: Icons.home, text: "Home"),
      BottomNavBarItem(iconData: Icons.list, text: "Despesas"),
    ];
  }
}

class _NavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  _updateIndex(int index) {
    widget.onTabSelected(index == 1 ? index + 1 : index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      elevation: 60,
      shape: CircularNotchedRectangle(),
      child: this._getBar(),
    );
  }

  Row _getBar() {
    return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: this._getTabs()
    );
  }

  List<Widget> _getTabs() {
    List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
        item: widget.items[index],
        index: index,
        onPressed: _updateIndex,
      );
    });
    items.insert(items.length >> 1, _buildMiddleTabItem());
    return items;
  }

  Widget _buildMiddleTabItem() {
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 30),
            Text(
              widget.centerItemText,
              style: TextStyle(color: widget.color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required BottomNavBarItem item,
    int index = 0,
    required ValueChanged<int> onPressed,
  }) {
    Color color = _selectedIndex == index ? widget.selectedColor : widget.color;
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => onPressed(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(item.iconData, color: color, size: item.iconSize),
                Text(
                  item.text,
                  style: TextStyle(color: color),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
