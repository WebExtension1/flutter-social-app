import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  final String label;
  final int type;
  final int currentDisplayType;
  final void Function(int) onSelected;

  const ProfileTab({
    super.key,
    required this.label,
    required this.type,
    required this.currentDisplayType,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentDisplayType == type;

    return GestureDetector(
      onTap: () => onSelected(type),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected ? [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ] : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
