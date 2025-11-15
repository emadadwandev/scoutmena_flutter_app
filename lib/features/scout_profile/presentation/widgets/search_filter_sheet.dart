import 'package:flutter/material.dart';
import '../../domain/entities/search_filters.dart';
import '../../../../core/theme/app_colors.dart';

/// Bottom sheet for search filters
class SearchFilterSheet extends StatefulWidget {
  final SearchFilters currentFilters;

  const SearchFilterSheet({
    super.key,
    required this.currentFilters,
  });

  @override
  State<SearchFilterSheet> createState() => _SearchFilterSheetState();
}

class _SearchFilterSheetState extends State<SearchFilterSheet> {
  late List<String> _selectedPositions;
  late List<String> _selectedCountries;
  late List<String> _selectedNationalities;
  late RangeValues _ageRange;
  late RangeValues _heightRange;
  String? _selectedFoot;
  final _clubController = TextEditingController();

  static const List<String> _positions = [
    'GK', 'RB', 'CB', 'LB', 'CDM', 'CM', 'CAM', 'RM', 'LM', 'RW', 'LW', 'ST'
  ];

  static const List<String> _countries = [
    'Egypt', 'Saudi Arabia', 'UAE', 'Qatar', 'Morocco', 'Tunisia',
    'Algeria', 'Jordan', 'Lebanon', 'Iraq', 'Palestine', 'Syria',
  ];

  @override
  void initState() {
    super.initState();
    _selectedPositions = widget.currentFilters.positions?.toList() ?? [];
    _selectedCountries = widget.currentFilters.countries?.toList() ?? [];
    _selectedNationalities = widget.currentFilters.nationalities?.toList() ?? [];
    _ageRange = RangeValues(
      widget.currentFilters.minAge?.toDouble() ?? 16,
      widget.currentFilters.maxAge?.toDouble() ?? 35,
    );
    _heightRange = RangeValues(
      widget.currentFilters.minHeight?.toDouble() ?? 150,
      widget.currentFilters.maxHeight?.toDouble() ?? 200,
    );
    _selectedFoot = widget.currentFilters.dominantFoot;
    _clubController.text = widget.currentFilters.currentClub ?? '';
  }

  @override
  void dispose() {
    _clubController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final filters = SearchFilters(
      positions: _selectedPositions.isNotEmpty ? _selectedPositions : null,
      countries: _selectedCountries.isNotEmpty ? _selectedCountries : null,
      nationalities: _selectedNationalities.isNotEmpty ? _selectedNationalities : null,
      minAge: _ageRange.start.toInt(),
      maxAge: _ageRange.end.toInt(),
      minHeight: _heightRange.start.toInt(),
      maxHeight: _heightRange.end.toInt(),
      dominantFoot: _selectedFoot,
      currentClub: _clubController.text.isNotEmpty ? _clubController.text : null,
      sortBy: widget.currentFilters.sortBy,
      sortOrder: widget.currentFilters.sortOrder,
    );

    Navigator.pop(context, filters);
  }

  void _clearAll() {
    setState(() {
      _selectedPositions = [];
      _selectedCountries = [];
      _selectedNationalities = [];
      _ageRange = const RangeValues(16, 35);
      _heightRange = const RangeValues(150, 200);
      _selectedFoot = null;
      _clubController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildPositionsSection(),
                    const SizedBox(height: 24),
                    _buildAgeRangeSection(),
                    const SizedBox(height: 24),
                    _buildCountriesSection(),
                    const SizedBox(height: 24),
                    _buildHeightRangeSection(),
                    const SizedBox(height: 24),
                    _buildFootSection(),
                    const SizedBox(height: 24),
                    _buildClubSection(),
                  ],
                ),
              ),
              _buildActionButtons(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          const Text(
            'Filter Players',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: _clearAll,
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  Widget _buildPositionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Positions',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _positions.map((position) {
            final isSelected = _selectedPositions.contains(position);
            return FilterChip(
              label: Text(position),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedPositions.add(position);
                  } else {
                    _selectedPositions.remove(position);
                  }
                });
              },
              selectedColor: AppColors.scoutPrimary.withOpacity(0.2),
              checkmarkColor: AppColors.scoutPrimary,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAgeRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Age Range: ${_ageRange.start.toInt()} - ${_ageRange.end.toInt()} years',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        RangeSlider(
          values: _ageRange,
          min: 16,
          max: 40,
          divisions: 24,
          labels: RangeLabels(
            _ageRange.start.toInt().toString(),
            _ageRange.end.toInt().toString(),
          ),
          onChanged: (values) {
            setState(() {
              _ageRange = values;
            });
          },
        ),
      ],
    );
  }

  Widget _buildCountriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Countries',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _countries.map((country) {
            final isSelected = _selectedCountries.contains(country);
            return FilterChip(
              label: Text(country),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedCountries.add(country);
                  } else {
                    _selectedCountries.remove(country);
                  }
                });
              },
              selectedColor: AppColors.scoutPrimary.withOpacity(0.2),
              checkmarkColor: AppColors.scoutPrimary,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildHeightRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Height Range: ${_heightRange.start.toInt()} - ${_heightRange.end.toInt()} cm',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        RangeSlider(
          values: _heightRange,
          min: 150,
          max: 210,
          divisions: 60,
          labels: RangeLabels(
            '${_heightRange.start.toInt()}cm',
            '${_heightRange.end.toInt()}cm',
          ),
          onChanged: (values) {
            setState(() {
              _heightRange = values;
            });
          },
        ),
      ],
    );
  }

  Widget _buildFootSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dominant Foot',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: ['left', 'right', 'both'].map((foot) {
            final isSelected = _selectedFoot == foot;
            return ChoiceChip(
              label: Text(foot.toUpperCase()),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFoot = selected ? foot : null;
                });
              },
              selectedColor: AppColors.scoutPrimary.withOpacity(0.2),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildClubSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Current Club',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _clubController,
          decoration: const InputDecoration(
            hintText: 'Enter club name',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.shield),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.scoutPrimary,
              ),
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }
}
