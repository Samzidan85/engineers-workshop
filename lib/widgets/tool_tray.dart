import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:engineers_workshop/theme.dart';

class ToolTray extends StatelessWidget {
  final int selectedTool;
  final String? hoveredTool;
  final ValueChanged<int> onToolSelected;
  final ValueChanged<String?> onToolHover;
  final ValueChanged<String> onPlaceComponent;
  final VoidCallback onClear;

  const ToolTray({
    super.key,
    required this.selectedTool,
    required this.hoveredTool,
    required this.onToolSelected,
    required this.onToolHover,
    required this.onPlaceComponent,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      margin: const EdgeInsets.fromLTRB(12, 4, 12, 10),
      decoration: BoxDecoration(
        color: WorkshopColors.benchMetal.withOpacity(0.85),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: WorkshopColors.ironDark, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // --- Component palette: tap to place on the bench ---
          const _TrayLabel('PLACE'),
          _ComponentButton(
            icon: Icons.battery_full,
            label: 'Battery',
            color: WorkshopColors.brassLight,
            onTap: () => onPlaceComponent('battery'),
          ),
          _ComponentButton(
            icon: Icons.electrical_services,
            label: 'Resistor',
            color: const Color(0xFFE53E3E),
            onTap: () => onPlaceComponent('resistor'),
          ),
          _ComponentButton(
            icon: Icons.lightbulb,
            label: 'Lamp',
            color: const Color(0xFFF6E05E),
            onTap: () => onPlaceComponent('lamp'),
          ),

          const _TrayDivider(),
          const _TrayLabel('TOOLS'),

          // --- Interaction tools ---
          _ToolButton(
            tool: 'select',
            icon: Icons.touch_app,
            label: 'Move',
            isSelected: selectedTool == 0,
            hovered: hoveredTool == 'select',
            onTap: () => onToolSelected(0),
            onHover: (h) => onToolHover(h ? 'select' : null),
          ),
          _ToolButton(
            tool: 'wire',
            icon: Icons.wifi,
            label: 'Wire',
            isSelected: selectedTool == 1,
            hovered: hoveredTool == 'wire',
            onTap: () => onToolSelected(1),
            onHover: (h) => onToolHover(h ? 'wire' : null),
          ),
          _ToolButton(
            tool: 'voltmeter',
            icon: Icons.power,
            label: 'Voltmeter',
            isSelected: selectedTool == 2,
            hovered: hoveredTool == 'voltmeter',
            onTap: () => onToolSelected(2),
            onHover: (h) => onToolHover(h ? 'voltmeter' : null),
          ),
          _ToolButton(
            tool: 'ammeter',
            icon: Icons.flip,
            label: 'Ammeter',
            isSelected: selectedTool == 3,
            hovered: hoveredTool == 'ammeter',
            onTap: () => onToolSelected(3),
            onHover: (h) => onToolHover(h ? 'ammeter' : null),
          ),

          const _TrayDivider(),

          _ToolButton(
            tool: 'clear',
            icon: Icons.delete_outline,
            label: 'Clear',
            isSelected: false,
            hovered: hoveredTool == 'clear',
            onTap: onClear,
            onHover: (h) => onToolHover(h ? 'clear' : null),
          ),
        ],
      ),
    );
  }
}

class _TrayLabel extends StatelessWidget {
  final String text;
  const _TrayLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 4),
      child: RotatedBox(
        quarterTurns: 3,
        child: Text(
          text,
          style: const TextStyle(
            color: WorkshopColors.ironText,
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}

class _TrayDivider extends StatelessWidget {
  const _TrayDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 44,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: WorkshopColors.ironDark,
    );
  }
}

/// A palette button that places a new component on the bench.
class _ComponentButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ComponentButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          onTap();
        },
        child: Container(
          width: 62,
          height: 54,
          decoration: BoxDecoration(
            color: WorkshopColors.ironDark,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: color.withOpacity(0.7), width: 1.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(height: 3),
              Text(
                label,
                style: const TextStyle(
                  color: WorkshopColors.ironText,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToolButton extends StatefulWidget {
  final String tool;
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool hovered;
  final VoidCallback onTap;
  final ValueChanged<bool> onHover;

  const _ToolButton({
    required this.tool,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.hovered,
    required this.onTap,
    required this.onHover,
  });

  @override
  State<_ToolButton> createState() => _ToolButtonState();
}

class _ToolButtonState extends State<_ToolButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.isSelected;
    final hovered = _hovered || widget.hovered;

    return MouseRegion(
      onEnter: (_) {
        setState(() => _hovered = true);
        widget.onHover(true);
      },
      onExit: (_) {
        setState(() => _hovered = false);
        widget.onHover(false);
      },
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onTap();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            width: 60,
            height: 54,
            decoration: BoxDecoration(
              color: isSelected
                  ? WorkshopColors.brass
                  : (hovered ? WorkshopColors.benchLight : WorkshopColors.benchMetal),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: isSelected ? WorkshopColors.brassLight : WorkshopColors.ironDark,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: WorkshopColors.brass.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.icon,
                  size: 20,
                  color: isSelected ? Colors.white : WorkshopColors.ironText,
                ),
                const SizedBox(height: 2),
                Text(
                  widget.label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : WorkshopColors.ironText,
                    fontSize: 9,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
