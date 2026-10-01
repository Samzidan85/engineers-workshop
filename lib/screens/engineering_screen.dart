import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:engineers_workshop/theme.dart' as th;

/// Level 3: Engineering Calculators
/// A collection of essential electrical engineering calculators.
class EngineeringScreen extends StatefulWidget {
  const EngineeringScreen({super.key});

  @override
  State<EngineeringScreen> createState() => _EngineeringScreenState();
}

class _EngineeringScreenState extends State<EngineeringScreen> {
  int _selectedCalc = 0;

  static const List<String> _calcTitles = [
    "Ohm's Law",
    'Power',
    'Voltage Drop',
    'Cable Sizing',
    'Transformer',
  ];

  static const List<IconData> _calcIcons = [
    Icons.bolt,
    Icons.power,
    Icons.trending_down,
    Icons.cable,
    Icons.electrical_services,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080c11),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111820),
        title: const Text(
          'L3 · Engineering Calculators',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white70),
      ),
      body: Column(
        children: [
          // --- Calculator selector tabs ---
          _buildCalcTabs(),
          // --- Active calculator ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildActiveCalc(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalcTabs() {
    return Container(
      height: 56,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: BoxDecoration(
        color: const Color(0xFF0d151c),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: th.WorkshopColors.ironDark),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _calcTitles.length,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        itemBuilder: (context, index) {
          final isSelected = _selectedCalc == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedCalc = index),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? th.WorkshopColors.brass.withOpacity(0.25)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? th.WorkshopColors.brass
                      : Colors.transparent,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _calcIcons[index],
                    size: 18,
                    color: isSelected
                        ? th.WorkshopColors.brassLight
                        : Colors.white54,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _calcTitles[index],
                    style: TextStyle(
                      color: isSelected
                          ? th.WorkshopColors.brassLight
                          : Colors.white54,
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActiveCalc() {
    switch (_selectedCalc) {
      case 0:
        return _OhmsLawCalc();
      case 1:
        return _PowerCalc();
      case 2:
        return _VoltageDropCalc();
      case 3:
        return _CableSizingCalc();
      case 4:
        return _TransformerCalc();
      default:
        return const SizedBox.shrink();
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared input widget
// ─────────────────────────────────────────────────────────────────────────────

class _CalcInput extends StatefulWidget {
  final String label;
  final String unit;
  final double? initialValue;
  final ValueChanged<double?> onChanged;

  const _CalcInput({
    required this.label,
    required this.unit,
    this.initialValue,
    required this.onChanged,
  });

  @override
  State<_CalcInput> createState() => _CalcInputState();
}

class _CalcInputState extends State<_CalcInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialValue?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: _controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
        ],
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          labelText: '${widget.label} (${widget.unit})',
          labelStyle: const TextStyle(color: Colors.white54),
          suffixText: widget.unit,
          suffixStyle: const TextStyle(color: Colors.white38),
          filled: true,
          fillColor: const Color(0xFF111820),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: th.WorkshopColors.ironDark),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: th.WorkshopColors.ironDark),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: th.WorkshopColors.brass),
          ),
        ),
        onChanged: (text) {
          final val = double.tryParse(text);
          widget.onChanged(val);
        },
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color? valueColor;

  const _ResultRow({
    required this.label,
    required this.value,
    required this.unit,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white60, fontSize: 14)),
          Text(
            '$value $unit',
            style: TextStyle(
              color: valueColor ?? const Color(0xFF7dd3fc),
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

class _CalcCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _CalcCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF0d151c),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: th.WorkshopColors.ironDark),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: th.WorkshopColors.brassLight,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 1. Ohm's Law Calculator
// ─────────────────────────────────────────────────────────────────────────────

class _OhmsLawCalc extends StatefulWidget {
  @override
  State<_OhmsLawCalc> createState() => _OhmsLawCalcState();
}

class _OhmsLawCalcState extends State<_OhmsLawCalc> {
  double? _voltage;
  double? _current;
  double? _resistance;
  double? _power;

  /// Solve for the missing value.
  /// We need at least 2 of {V, I, R, P} to solve.
  void _calculate() {
    // Count how many are set
    final values = [_voltage, _current, _resistance, _power];
    final setCount = values.where((v) => v != null).length;

    if (setCount < 2) return;

    double? v = _voltage;
    double? i = _current;
    double? r = _resistance;
    double? p = _power;

    // Solve iteratively (max 4 passes)
    for (int pass = 0; pass < 4; pass++) {
      // V = I * R
      if (v == null && i != null && r != null) v = i * r;
      // I = V / R
      if (i == null && v != null && r != null && r != 0) i = v / r;
      // R = V / I
      if (r == null && v != null && i != null && i != 0) r = v / i;
      // P = V * I
      if (p == null && v != null && i != null) p = v * i;
      // P = I² * R
      if (p == null && i != null && r != null) p = i * i * r;
      // P = V² / R
      if (p == null && v != null && r != null && r != 0) p = v * v / r;
      // V = P / I
      if (v == null && p != null && i != null && i != 0) v = p / i;
      // I = P / V
      if (i == null && p != null && v != null && v != 0) i = p / v;
      // R = P / I²
      if (r == null && p != null && i != null && i != 0) r = p / (i * i);
      // R = V² / P
      if (r == null && v != null && p != null && p != 0) r = (v * v) / p;
    }

    setState(() {
      _voltage = v;
      _current = i;
      _resistance = r;
      _power = p;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _CalcCard(
      title: "Ohm's Law — solve for any variable",
      child: Column(
        children: [
          _CalcInput(
            label: 'Voltage',
            unit: 'V',
            initialValue: _voltage,
            onChanged: (v) {
              _voltage = v;
              _calculate();
            },
          ),
          _CalcInput(
            label: 'Current',
            unit: 'A',
            initialValue: _current,
            onChanged: (v) {
              _current = v;
              _calculate();
            },
          ),
          _CalcInput(
            label: 'Resistance',
            unit: 'Ω',
            initialValue: _resistance,
            onChanged: (v) {
              _resistance = v;
              _calculate();
            },
          ),
          _CalcInput(
            label: 'Power',
            unit: 'W',
            initialValue: _power,
            onChanged: (v) {
              _power = v;
              _calculate();
            },
          ),
          const Divider(color: th.WorkshopColors.ironDark, height: 24),
          _ResultRow(
            label: 'Voltage',
            value: _voltage?.toStringAsFixed(3) ?? '—',
            unit: 'V',
          ),
          _ResultRow(
            label: 'Current',
            value: _current?.toStringAsFixed(3) ?? '—',
            unit: 'A',
          ),
          _ResultRow(
            label: 'Resistance',
            value: _resistance?.toStringAsFixed(3) ?? '—',
            unit: 'Ω',
          ),
          _ResultRow(
            label: 'Power',
            value: _power?.toStringAsFixed(3) ?? '—',
            unit: 'W',
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. Power Calculator (single-phase & three-phase)
// ─────────────────────────────────────────────────────────────────────────────

class _PowerCalc extends StatefulWidget {
  @override
  State<_PowerCalc> createState() => _PowerCalcState();
}

class _PowerCalcState extends State<_PowerCalc> {
  int _phaseMode = 0; // 0 = single-phase, 1 = three-phase
  double? _voltage;
  double? _current;
  double _powerFactor = 0.85;

  double? get _power {
    if (_voltage == null || _current == null) return null;
    if (_phaseMode == 0) {
      return _voltage! * _current! * _powerFactor;
    } else {
      return math.sqrt(3) * _voltage! * _current! * _powerFactor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _CalcCard(
      title: 'Power Calculator',
      child: Column(
        children: [
          // Phase selector
          Row(
            children: [
              Expanded(
                child: _phaseButton('Single-Phase', 0),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _phaseButton('Three-Phase', 1),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _CalcInput(
            label: 'Voltage',
            unit: 'V',
            initialValue: _voltage,
            onChanged: (v) => setState(() => _voltage = v),
          ),
          _CalcInput(
            label: 'Current',
            unit: 'A',
            initialValue: _current,
            onChanged: (v) => setState(() => _current = v),
          ),
          // Power factor slider
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Power Factor',
                        style: TextStyle(color: Colors.white54, fontSize: 14)),
                    Text(_powerFactor.toStringAsFixed(2),
                        style: const TextStyle(
                            color: Color(0xFF7dd3fc),
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                Slider(
                  value: _powerFactor,
                  min: 0.1,
                  max: 1.0,
                  divisions: 18,
                  activeColor: th.WorkshopColors.brass,
                  inactiveColor: th.WorkshopColors.ironDark,
                  onChanged: (v) => setState(() => _powerFactor = v),
                ),
              ],
            ),
          ),
          const Divider(color: th.WorkshopColors.ironDark, height: 24),
          _ResultRow(
            label: 'Apparent Power (S)',
            value: (_voltage != null && _current != null)
                ? (_voltage! * _current!).toStringAsFixed(1)
                : '—',
            unit: 'VA',
          ),
          _ResultRow(
            label: 'Real Power (P)',
            value: _power?.toStringAsFixed(1) ?? '—',
            unit: 'W',
            valueColor: const Color(0xFF48BB78),
          ),
          _ResultRow(
            label: 'Reactive Power (Q)',
            value: (_voltage != null && _current != null)
                ? (_voltage! *
                        _current! *
                        math.sqrt(1 - _powerFactor * _powerFactor))
                    .toStringAsFixed(1)
                : '—',
            unit: 'VAR',
          ),
        ],
      ),
    );
  }

  Widget _phaseButton(String label, int mode) {
    final isSelected = _phaseMode == mode;
    return GestureDetector(
      onTap: () => setState(() => _phaseMode = mode),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? th.WorkshopColors.brass.withOpacity(0.25)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? th.WorkshopColors.brass : th.WorkshopColors.ironDark,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? th.WorkshopColors.brassLight : Colors.white54,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. Voltage Drop Calculator
// ─────────────────────────────────────────────────────────────────────────────

class _VoltageDropCalc extends StatefulWidget {
  @override
  State<_VoltageDropCalc> createState() => _VoltageDropCalcState();
}

class _VoltageDropCalcState extends State<_VoltageDropCalc> {
  double? _current;
  double? _length; // one-way length in meters
  double? _cableRPerMeter; // resistance per meter (Ω/m)
  double? _supplyVoltage;

  double? get _voltageDrop {
    if (_current == null || _length == null || _cableRPerMeter == null) return null;
    // Vd = 2 * L * I * R/m  (factor 2 for go + return)
    return 2 * _length! * _current! * _cableRPerMeter!;
  }

  double? get _voltageDropPercent {
    if (_voltageDrop == null || _supplyVoltage == null || _supplyVoltage == 0) return null;
    return (_voltageDrop! / _supplyVoltage!) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return _CalcCard(
      title: 'Voltage Drop Calculator',
      child: Column(
        children: [
          _CalcInput(
            label: 'Load Current',
            unit: 'A',
            initialValue: _current,
            onChanged: (v) => setState(() => _current = v),
          ),
          _CalcInput(
            label: 'Cable Length (one-way)',
            unit: 'm',
            initialValue: _length,
            onChanged: (v) => setState(() => _length = v),
          ),
          _CalcInput(
            label: 'Cable Resistance per meter',
            unit: 'Ω/m',
            initialValue: _cableRPerMeter,
            onChanged: (v) => setState(() => _cableRPerMeter = v),
          ),
          _CalcInput(
            label: 'Supply Voltage',
            unit: 'V',
            initialValue: _supplyVoltage,
            onChanged: (v) => setState(() => _supplyVoltage = v),
          ),
          const Divider(color: th.WorkshopColors.ironDark, height: 24),
          _ResultRow(
            label: 'Voltage Drop',
            value: _voltageDrop?.toStringAsFixed(3) ?? '—',
            unit: 'V',
          ),
          _ResultRow(
            label: 'Drop Percentage',
            value: _voltageDropPercent?.toStringAsFixed(2) ?? '—',
            unit: '%',
            valueColor: (_voltageDropPercent != null && _voltageDropPercent! > 3)
                ? const Color(0xFFE53E3E)
                : const Color(0xFF48BB78),
          ),
          if (_voltageDropPercent != null && _voltageDropPercent! > 3)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                '⚠ Drop exceeds 3% — consider a larger cable.',
                style: TextStyle(color: Color(0xFFE53E3E), fontSize: 13),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. Cable Sizing Calculator
// ─────────────────────────────────────────────────────────────────────────────

class _CableSizingCalc extends StatefulWidget {
  @override
  State<_CableSizingCalc> createState() => _CableSizingCalcState();
}

class _CableSizingCalcState extends State<_CableSizingCalc> {
  double? _current;
  double _currentDensity = 4.0; // A/mm² (typical for chassis wiring)

  // Standard cable sizes in mm²
  static const List<double> _standardSizes = [
    0.5, 0.75, 1.0, 1.5, 2.5, 4.0, 6.0, 10.0, 16.0, 25.0, 35.0, 50.0, 70.0, 95.0, 120.0,
  ];

  double? get _minArea {
    if (_current == null) return null;
    return _current! / _currentDensity;
  }

  double? get _recommendedSize {
    if (_minArea == null) return null;
    for (final size in _standardSizes) {
      if (size >= _minArea!) return size;
    }
    return _standardSizes.last;
  }

  @override
  Widget build(BuildContext context) {
    return _CalcCard(
      title: 'Cable Sizing Calculator',
      child: Column(
        children: [
          _CalcInput(
            label: 'Load Current',
            unit: 'A',
            initialValue: _current,
            onChanged: (v) => setState(() => _current = v),
          ),
          // Current density slider
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Current Density',
                        style: TextStyle(color: Colors.white54, fontSize: 14)),
                    Text('${_currentDensity.toStringAsFixed(1)} A/mm²',
                        style: const TextStyle(
                            color: Color(0xFF7dd3fc),
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                Slider(
                  value: _currentDensity,
                  min: 2.0,
                  max: 8.0,
                  divisions: 12,
                  activeColor: th.WorkshopColors.brass,
                  inactiveColor: th.WorkshopColors.ironDark,
                  onChanged: (v) => setState(() => _currentDensity = v),
                ),
                const Text(
                  'Typical: 2–4 A/mm² (power), 6–8 A/mm² (chassis)',
                  style: TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ),
          const Divider(color: th.WorkshopColors.ironDark, height: 24),
          _ResultRow(
            label: 'Minimum Area',
            value: _minArea?.toStringAsFixed(2) ?? '—',
            unit: 'mm²',
          ),
          _ResultRow(
            label: 'Recommended Cable',
            value: _recommendedSize?.toStringAsFixed(1) ?? '—',
            unit: 'mm²',
            valueColor: const Color(0xFF48BB78),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 5. Transformer Turns Ratio Calculator
// ─────────────────────────────────────────────────────────────────────────────

class _TransformerCalc extends StatefulWidget {
  @override
  State<_TransformerCalc> createState() => _TransformerCalcState();
}

class _TransformerCalcState extends State<_TransformerCalc> {
  double? _primaryVoltage;
  double? _secondaryVoltage;
  double? _primaryTurns;

  double? get _secondaryTurns {
    if (_primaryVoltage == null || _secondaryVoltage == null || _primaryTurns == null) return null;
    if (_primaryVoltage == 0) return null;
    return _primaryTurns! * _secondaryVoltage! / _primaryVoltage!;
  }

  double? get _turnsRatio {
    if (_primaryVoltage == null || _secondaryVoltage == null || _secondaryVoltage == 0) return null;
    return _primaryVoltage! / _secondaryVoltage!;
  }

  @override
  Widget build(BuildContext context) {
    return _CalcCard(
      title: 'Transformer Turns Ratio',
      child: Column(
        children: [
          _CalcInput(
            label: 'Primary Voltage',
            unit: 'V',
            initialValue: _primaryVoltage,
            onChanged: (v) => setState(() => _primaryVoltage = v),
          ),
          _CalcInput(
            label: 'Secondary Voltage',
            unit: 'V',
            initialValue: _secondaryVoltage,
            onChanged: (v) => setState(() => _secondaryVoltage = v),
          ),
          _CalcInput(
            label: 'Primary Turns',
            unit: 'turns',
            initialValue: _primaryTurns,
            onChanged: (v) => setState(() => _primaryTurns = v),
          ),
          const Divider(color: th.WorkshopColors.ironDark, height: 24),
          _ResultRow(
            label: 'Turns Ratio (Np:Ns)',
            value: _turnsRatio?.toStringAsFixed(2) ?? '—',
            unit: ': 1',
          ),
          _ResultRow(
            label: 'Secondary Turns',
            value: _secondaryTurns?.toStringAsFixed(0) ?? '—',
            unit: 'turns',
            valueColor: const Color(0xFF48BB78),
          ),
        ],
      ),
    );
  }
}
