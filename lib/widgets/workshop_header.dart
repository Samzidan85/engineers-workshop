import 'package:flutter/material.dart';
import 'package:engineers_workshop/theme.dart';
import 'package:engineers_workshop/progress.dart';
import 'package:engineers_workshop/screens/profile_screen.dart';
import 'package:engineers_workshop/screens/learn_screen.dart';
import 'package:engineers_workshop/screens/boards_screen.dart';
import 'package:engineers_workshop/screens/tips_screen.dart';
import 'package:engineers_workshop/screens/secrets_screen.dart';

/// Top bar: title, XP/level readout, and the content-library menu.
/// Lays out on one row when there is width for it, and stacks into two
/// compact rows on narrow (portrait) screens so nothing overflows.
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
    final wide = MediaQuery.sizeOf(context).width >= 620;

    final titleBlock = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.hardware, color: WorkshopColors.brass, size: 24),
        const SizedBox(width: 8),
        const Text(
          "Engineer's Workshop",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(width: 10),
        _xpChip(level),
      ],
    );

    final navBlock = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _navButton('Learn', Icons.menu_book, const LearnScreen()),
        _navButton('Boards', Icons.developer_board, const BoardsScreen()),
        _navButton('Tips', Icons.lightbulb_outline, const TipsScreen()),
        _navButton('Secrets', Icons.auto_awesome, const SecretsScreen()),
        _navButton('Profile', Icons.person, const ProfileScreen()),
      ],
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: WorkshopColors.woodDark,
        border: Border(
          bottom: BorderSide(color: WorkshopColors.woodBorder, width: 1),
        ),
      ),
      child: wide
          ? Row(
              children: [
                titleBlock,
                const Spacer(),
                navBlock,
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleBlock,
                const SizedBox(height: 8),
                // Horizontally scrollable so buttons never clip on narrow screens.
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: navBlock,
                ),
              ],
            ),
    );
  }

  Widget _xpChip(EngineerLevel level) {
    return GestureDetector(
      onTap: () => _open(const ProfileScreen()),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: WorkshopColors.benchMetal,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: WorkshopColors.brassDark),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(level.icon, style: const TextStyle(fontSize: 13)),
            const SizedBox(width: 5),
            Text(
              '${level.name} · ${_progress.xp} XP',
              style: const TextStyle(
                color: WorkshopColors.brassLight,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navButton(String label, IconData icon, Widget screen) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: TextButton.icon(
        onPressed: () => _open(screen),
        icon: Icon(icon, size: 15, color: WorkshopColors.ironText),
        label: Text(
          label,
          style: const TextStyle(
            color: WorkshopColors.ironText,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: WorkshopColors.ironDark.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
