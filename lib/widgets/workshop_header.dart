import 'package:flutter/material.dart';
import 'package:engineers_workshop/theme.dart';
import 'package:engineers_workshop/progress.dart';
import 'package:engineers_workshop/screens/profile_screen.dart';
import 'package:engineers_workshop/screens/learn_screen.dart';
import 'package:engineers_workshop/screens/boards_screen.dart';
import 'package:engineers_workshop/screens/tips_screen.dart';
import 'package:engineers_workshop/screens/secrets_screen.dart';

/// Top bar: title, XP/level readout, and the content-library menu.
class WorkshopHeader extends StatefulWidget {
  const WorkshopHeader({super.key});

  @override
  State<WorkshopHeader> createState() => _WorkshopHeaderState();
}

class _WorkshopHeaderState extends State<WorkshopHeader> {
  final ProgressTracker _progress = ProgressTracker();

  @override
  void initState() {
    super.initState();
    _progress.init().then((_) {
      if (mounted) setState(() {});
    });
  }

  void _open(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final level = _progress.currentLevel;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: WorkshopColors.woodDark,
        border: Border(
          bottom: BorderSide(color: WorkshopColors.woodBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.hardware, color: WorkshopColors.brass, size: 26),
          const SizedBox(width: 10),
          const Text(
            "The Engineer's Workshop",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 16),

          // --- XP / level readout ---
          GestureDetector(
            onTap: () => _open(const ProfileScreen()),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: WorkshopColors.benchMetal,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: WorkshopColors.brassDark),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(level.icon, style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(
                    '${level.name} · ${_progress.xp} XP',
                    style: const TextStyle(
                      color: WorkshopColors.brassLight,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

          // --- Content library ---
          _navButton('Learn', Icons.menu_book, const LearnScreen()),
          _navButton('Boards', Icons.developer_board, const BoardsScreen()),
          _navButton('Tips', Icons.lightbulb_outline, const TipsScreen()),
          _navButton('Secrets', Icons.auto_awesome, const SecretsScreen()),
          const SizedBox(width: 6),
          _navButton('Profile', Icons.person, const ProfileScreen()),
        ],
      ),
    );
  }

  Widget _navButton(String label, IconData icon, Widget screen) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: TextButton.icon(
        onPressed: () => _open(screen),
        icon: Icon(icon, size: 16, color: WorkshopColors.ironText),
        label: Text(
          label,
          style: const TextStyle(
            color: WorkshopColors.ironText,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          backgroundColor: WorkshopColors.ironDark.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
