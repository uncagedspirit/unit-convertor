import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../data/category_data.dart';
import '../../data/conversion_engine.dart';
import '../../data/keypad_input.dart';
import '../../data/models/category.dart';
import '../../data/models/unit.dart';
import '../../data/number_format.dart';
import '../../state/app_state.dart';
import '../../theme/app_neutral_colors.dart';
import '../../theme/text_styles.dart';
import 'from_card.dart';
import 'numeric_keypad.dart';
import 'results_list.dart';
import 'unit_chip_row.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({
    super.key,
    required this.categoryId,
    this.initialFromUnitId,
  });

  final String categoryId;
  final String? initialFromUnitId;

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  late final Category _category;
  late ConvertibleUnit _fromUnit;
  String _value = '1';

  @override
  void initState() {
    super.initState();
    _category = findCategory(widget.categoryId)!;
    _fromUnit =
        _findUnit(widget.initialFromUnitId) ??
        ConversionEngine.defaultUnit(_category);
  }

  ConvertibleUnit? _findUnit(String? id) {
    if (id == null) return null;
    for (final u in _category.units) {
      if (u.id == id) return u;
    }
    return null;
  }

  double get _parsedValue {
    if (_value.isEmpty || _value == '.') return 0;
    final normalized = _value.endsWith('.')
        ? _value.substring(0, _value.length - 1)
        : _value;
    return double.tryParse(normalized) ?? 0;
  }

  void _maybeHaptic() {
    if (context.read<AppState>().hapticsEnabled) {
      HapticFeedback.lightImpact();
    }
  }

  void _pressDigit(String d) {
    _maybeHaptic();
    setState(() => _value = KeypadInput.pressDigit(_value, d));
  }

  void _pressDot() {
    _maybeHaptic();
    setState(() => _value = KeypadInput.pressDot(_value));
  }

  void _pressBackspace() {
    _maybeHaptic();
    setState(() => _value = KeypadInput.pressBackspace(_value));
  }

  void _clear() => setState(() => _value = '');

  void _selectFromUnit(ConvertibleUnit u) => setState(() => _fromUnit = u);

  void _swap(ConvertibleUnit target) {
    final result = ConversionEngine.convert(
      _category,
      _fromUnit,
      target,
      _parsedValue,
    );
    setState(() {
      _fromUnit = target;
      _value = NumberFormat.clean(result);
    });
  }

  String _favKey(ConvertibleUnit to) =>
      '${_category.id}|${_fromUnit.id}|${to.id}';

  @override
  Widget build(BuildContext context) {
    final neutrals = context.neutrals;
    final appState = context.watch<AppState>();
    final otherUnits = _category.units
        .where((u) => u.id != _fromUnit.id)
        .toList();
    final color = _category.colorFor(appState.paletteStyle);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 4),
              child: Row(
                children: [
                  _RoundIconButton(
                    icon: Icons.arrow_back_rounded,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _category.name,
                          style: fredokaStyle(
                            size: 20,
                            color: neutrals.textPrimary,
                          ),
                        ),
                        Text(
                          '${_category.units.length} units',
                          style: jakartaStyle(
                            size: 12,
                            color: neutrals.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      _category.icon,
                      size: 22,
                      color: const Color(0xFF2C2A2A),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
              child: FromCard(
                color: color,
                unit: _fromUnit,
                valueDisplay: _value.isEmpty ? '0' : _value,
                onClear: _clear,
                cornerRadius: appState.cornerRadius,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: UnitChipRow(
                units: _category.units,
                selectedId: _fromUnit.id,
                onSelect: _selectFromUnit,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 6),
                    child: Text(
                      'CONVERTS TO',
                      style: sectionLabelStyle(neutrals.textTertiary),
                    ),
                  ),
                  Expanded(
                    child: ConversionResultsList(
                      units: otherUnits,
                      formatFor: (u) => NumberFormat.format(
                        ConversionEngine.convert(
                          _category,
                          _fromUnit,
                          u,
                          _parsedValue,
                        ),
                        significantDigits: appState.precision,
                        grouped: appState.grouping,
                      ),
                      isFavorite: (u) => appState.isFavorite(_favKey(u)),
                      onSwap: _swap,
                      onToggleFavorite: (u) =>
                          appState.toggleFavorite(_favKey(u)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
              child: NumericKeypad(
                onDigit: _pressDigit,
                onDot: _pressDot,
                onBackspace: _pressBackspace,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final neutrals = context.neutrals;
    return Material(
      color: neutrals.subtleFill,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, size: 23, color: neutrals.textSecondary),
        ),
      ),
    );
  }
}
