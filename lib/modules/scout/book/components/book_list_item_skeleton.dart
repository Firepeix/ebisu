import 'package:ebisu/shared/UI/Components/Shimmer.dart';
import 'package:flutter/material.dart';

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