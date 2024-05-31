
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RowStars extends StatefulWidget {
  const RowStars({super.key});

  @override
  State<RowStars> createState() => _RowStarsState();
}

class _RowStarsState extends State<RowStars> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class RowStars extends  {
  int reviewScore = 0;
  RowStars({super.key,required this.reviewScore});
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Row(
      children: List.generate(
        5, (index) => IconButton(
        onPressed: () {setState(() => reviewScore = index);
        },
        icon: Icon(
          Icons.star,
          color:
          index <= reviewScore
              ? Colors.orange
              : Colors.grey,
        ),
      ),
      ),
    );
  }
}
