import 'package:flutter/material.dart';

class AreaSelector extends StatelessWidget {
  final List<String> areas;
  final String selectedArea;
  final Function(String) onSelectArea;

  const AreaSelector({
    super.key,
    required this.areas,
    required this.selectedArea,
    required this.onSelectArea,
  });

  @override
  Widget build(BuildContext context) {
    // Add "Hamısı" (All) at the start of the list
    final displayAreas = ['Hamısı', ...areas];

    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: displayAreas.length,
        itemBuilder: (context, index) {
          final area = displayAreas[index];
          final isSelected = selectedArea == area;

          return GestureDetector(
            onTap: () => onSelectArea(area),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFF7E21).withOpacity(0.15) : Colors.transparent,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: isSelected ? const Color(0xFFFF7E21) : const Color(0xFF2C241E),
                  width: 1,
                ),
              ),
              child: Text(
                area,
                style: TextStyle(
                  color: isSelected ? const Color(0xFFFF7E21) : const Color(0xFFA09890),
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
