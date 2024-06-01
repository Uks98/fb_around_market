
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reviewScore = StateProvider<int>((ref) {
  return 0;
});

class RowStars extends ConsumerWidget {
  const RowStars({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Row(
      children: List.generate(5, (index) => IconButton(
          onPressed: () => ref.read(reviewScore.notifier).state = index,
          icon: Icon(
            Icons.star,
            color:
            index <= ref.watch(reviewScore)
                ? Colors.orange
                : Colors.grey,
          ),
        ),
      ),
    );
  }
}
