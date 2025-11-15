import 'package:flutter/material.dart';
import '../../models/profile_setup_form_data.dart';
import '../position_selector.dart';

/// Step 2: Football Information
class FootballInfoStep extends StatefulWidget {
  final ProfileSetupFormData formData;
  final ValueChanged<ProfileSetupFormData> onDataChanged;

  const FootballInfoStep({
    super.key,
    required this.formData,
    required this.onDataChanged,
  });

  @override
  State<FootballInfoStep> createState() => _FootballInfoStepState();
}

class _FootballInfoStepState extends State<FootballInfoStep> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _clubController;
  late TextEditingController _jerseyController;

  @override
  void initState() {
    super.initState();
    _clubController = TextEditingController(text: widget.formData.currentClub ?? '');
    _jerseyController = TextEditingController(
      text: widget.formData.jerseyNumber?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _clubController.dispose();
    _jerseyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Football Information',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Share your football experience',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 32),

          // Current Club
          TextFormField(
            controller: _clubController,
            decoration: const InputDecoration(
              labelText: 'Current Club',
              hintText: 'Enter your current club (optional)',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              widget.onDataChanged(
                widget.formData.copyWith(
                  currentClub: value.isEmpty ? null : value,
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Positions
          PositionSelector(
            selectedPositions: widget.formData.positions,
            onChanged: (positions) {
              widget.onDataChanged(
                widget.formData.copyWith(positions: positions),
              );
            },
          ),
          const SizedBox(height: 24),

          // Jersey Number and Years Playing Row
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _jerseyController,
                  decoration: const InputDecoration(
                    labelText: 'Jersey Number',
                    hintText: '10',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final number = int.tryParse(value);
                      if (number == null || number < 1 || number > 99) {
                        return 'Invalid (1-99)';
                      }
                    }
                    return null;
                  },
                  onChanged: (value) {
                    final number = int.tryParse(value);
                    widget.onDataChanged(
                      widget.formData.copyWith(jerseyNumber: number),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: widget.formData.yearsPlaying,
                  decoration: const InputDecoration(
                    labelText: 'Years Playing *',
                    border: OutlineInputBorder(),
                  ),
                  items: List.generate(30, (index) => index + 1)
                      .map((year) => DropdownMenuItem(
                            value: year,
                            child: Text('$year ${year == 1 ? "year" : "years"}'),
                          ))
                      .toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Required';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    widget.onDataChanged(
                      widget.formData.copyWith(yearsPlaying: value),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Summary Card
          if (widget.formData.positions.isNotEmpty) ...[
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.sports_soccer, color: Colors.blue[700]),
                        const SizedBox(width: 8),
                        Text(
                          'Your Football Profile',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildSummaryRow(
                      'Positions',
                      widget.formData.positions.join(', '),
                    ),
                    if (widget.formData.currentClub != null &&
                        widget.formData.currentClub!.isNotEmpty)
                      _buildSummaryRow('Club', widget.formData.currentClub!),
                    if (widget.formData.yearsPlaying != null)
                      _buildSummaryRow(
                        'Experience',
                        '${widget.formData.yearsPlaying} ${widget.formData.yearsPlaying == 1 ? "year" : "years"}',
                      ),
                    if (widget.formData.jerseyNumber != null)
                      _buildSummaryRow(
                        'Jersey #',
                        widget.formData.jerseyNumber.toString(),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}
