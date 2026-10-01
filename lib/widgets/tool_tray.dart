import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:engineers_workshop/theme.dart';

class ToolTray extends StatelessWidget {
  final int selectedTool;
  final String? hoveredTool;
  final ValueChanged<int> onToolSelected;
  final ValueChanged<String?> onToolHover;

  const ToolTray({
    super.key,
    required this.selectedTool,
    required this.hoveredTool,
    required this.onToolSelected,
    required this.onToolHover,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ToolButton(
            tool: 'select',
            icon: Icons.touch_app,
            label: 'Select',
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
          _ToolButton(
            tool: 'clear',
            icon: Icons.delete_outline,
            label: 'Clear',
            isSelected: false,
            hovered: hoveredTool == 'clear',
            onTap: () {
              HapticFeedback.mediumImpact();
              onToolSelected(-1); // special: clear
            },
            onHover: (h) => onToolHover(h ? 'clear' : null),
          ),
        ],
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: 64,
          height: 56,
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
                size: 22,
                color: isSelected ? Colors.white : WorkshopColors.ironText,
              ),
              const SizedBox(height: 2),
              Text(
                widget.label,
                style: TextStyle(
                  color: isSelected ? Colors.white : WorkshopColors.ironText,
                  fontSize: 10,
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
    );
  }
}
