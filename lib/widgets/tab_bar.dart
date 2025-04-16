import 'package:flutter/material.dart';

class TabBarWidget extends StatelessWidget {
  final List<String> labels;
  final int displayType;
  final ValueChanged<int> onTabSelected;

  const TabBarWidget({
    Key? key,
    required this.labels,
    required this.displayType,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(labels.length, (index) {
        final int type = index + 1;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: GestureDetector(
            onTap: () => onTabSelected(type),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  labels[index],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                AnimatedContainer(
                  duration: Duration(milliseconds: 250),
                  height: 2,
                  width: displayType == type ? 24 : 0,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
