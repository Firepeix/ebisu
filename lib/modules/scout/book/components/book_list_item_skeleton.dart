import 'package:ebisu/modules/scout/book/models/book.dart';
import 'package:ebisu/shared/UI/Components/Shimmer.dart';
import 'package:ebisu/shared/state/async_component.dart';
import 'package:ebisu/ui_components/chronos/list/tile.dart';
import 'package:flutter/material.dart';
import 'package:ebisu/ui_components/chronos/labels/label.dart';

class BookListItemSkeleton extends StatelessWidget {
  const BookListItemSkeleton({super.key});

    @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ShimmerLoading(isLoading: true, child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Container(
              height: 60,
              decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  shape: BoxShape.rectangle,
              ),
            ),
          )
        ],
      )),
    );
  }
}