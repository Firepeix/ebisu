import 'package:flutter/material.dart';

class EbisuTitle extends StatelessWidget {
  final String content;

  EbisuTitle(this.content);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                content,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                textAlign: TextAlign.end,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  height: 3,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFCDD2),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                    shape: BoxShape.rectangle,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  height: 3,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                    shape: BoxShape.rectangle,
                  ),
                ),
              )
            ],
          )
        ],
      );
}

class EbisuSubTitle extends StatelessWidget {
  final String _content;
  final double size;

  EbisuSubTitle(this._content, {this.size =  22});

  @override
  Widget build(BuildContext context) => Text(
    _content,
    style: TextStyle(
      fontSize: size,
      fontWeight: FontWeight.bold,
    ),
  );
}
