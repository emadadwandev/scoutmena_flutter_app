import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Multi-select position selector with chips
class PositionSelector extends StatelessWidget {
  final List<String> selectedPositions;
  final ValueChanged<List<String>> onChanged;

  const PositionSelector({
    super.key,
    required this.selectedPositions,
    required this.onChanged,
  });

  static const List<Map<String, String>> positions = [
    {'key': 'GK', 'label': 'Goalkeeper'},
    {'key': 'RB', 'label': 'Right Back'},
    {'key': 'CB', 'label': 'Center Back'},
    {'key': 'LB', 'label': 'Left Back'},
    {'key': 'RWB', 'label': 'Right Wing Back'},
    {'key': 'LWB', 'label': 'Left Wing Back'},
    {'key': 'CDM', 'label': 'Defensive Midfielder'},
    {'key': 'CM', 'label': 'Central Midfielder'},
    {'key': 'CAM', 'label': 'Attacking Midfielder'},
    {'key': 'RM', 'label': 'Right Midfielder'},
    {'key': 'LM', 'label': 'Left Midfielder'},
    {'key': 'RW', 'label': 'Right Winger'},
    {'key': 'LW', 'label': 'Left Winger'},
    {'key': 'CF', 'label': 'Center Forward'},
    {'key': 'ST', 'label': 'Striker'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Position(s) *',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select all positions you play',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: positions.map((position) {
            final key = position['key']!;
            final label = position['label']!;
            final isSelected = selectedPositions.contains(key);

            return FilterChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (selected) {
                final newPositions = List<String>.from(selectedPositions);
                if (selected) {
                  newPositions.add(key);
                } else {
                  newPositions.remove(key);
                }
                onChanged(newPositions);
              },
              selectedColor: AppColors.playerPrimary.withOpacity(0.2),
              checkmarkColor: AppColors.playerPrimary,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.playerPrimary : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.playerPrimary : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
            );
          }).toList(),
        ),
        if (selectedPositions.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Please select at least one position',
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
