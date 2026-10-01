import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:engineers_workshop/widgets/component_block.dart';
import 'package:flutter/material.dart' show Color, TextStyle, TextAlign;

class LevelSelector extends StatelessWidget {
  final int currentLevel;
  final ValueChanged<int> onLevelSelected;

  const LevelSelector({super.key, required this.currentLevel, required this.onLevelSelected});

  @override
  Widget build(BuildContext context) {
    const woodDark = Color(0xFF3A2A1C);
    const woodBorder = Color(0xFF3A2A1C);
    const benchMetal = Color(0xFF6B7280);
    const brass = Color(0xFFB8860B);
    const brassLight = Color(0xFFD4A017);
    const ironDark = Color(0xFF374151);
    const ironText = Color(0xFFA0AEC0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: benchMetal.withOpacity(0.6),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: woodBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'LEVEL',
            style: TextStyle(
              color: ironText,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(width: 8),
          _buildChip(1, 'Circuit Bench', currentLevel == 1, brass, brassLight, ironDark, ironText, Colors.white, false),
          const SizedBox(width: 6),
          _buildChip(2, 'Motors', currentLevel == 2, brass, brassLight, ironDark, ironText, Colors.white, true),
          const SizedBox(width: 6),
          _buildChip(3, 'Engineering', currentLevel == 3, brass, brassLight, ironDark, ironText, Colors.white, true),
        ],
      ),
    );
  }

  Widget _buildChip(int level, String label, bool active, Color brassColor, Color brassLightColor, Color ironDarkColor, Color ironTextColor, Color whiteColor, bool locked) {
    final isSelected = active;
    return GestureDetector(
      onTap: () {
        if (!locked) {
          HapticFeedback.lightImpact();
          onLevelSelected(level);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? brassColor : (locked ? benchMetal.withOpacity(0.4) : ironDarkColor),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? brassLightColor : ironDarkColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? whiteColor : ironDarkColor,
                border: Border.all(
                  color: isSelected ? whiteColor : ironTextColor,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  '$level',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? whiteColor : ironTextColor,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (locked) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.lock,
                size: 12,
                color: ironTextColor,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
