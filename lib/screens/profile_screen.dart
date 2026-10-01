import 'package:flutter/material.dart';
import 'package:engineers_workshop/theme.dart';
import 'package:engineers_workshop/progress.dart';

/// Player profile: level, XP bar, badges, and mission log.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProgressTracker _progress = ProgressTracker();

  @override
  void initState() {
    super.initState();
    _progress.init().then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final level = _progress.currentLevel;
    final next = _progress.nextLevel;
    final earned = _progress.earnedBadgeObjects;

    return Scaffold(
      backgroundColor: const Color(0xFF080c11),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111820),
        title: const Text(
          'Profile · Progress',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white70),
        actions: [
          IconButton(
            tooltip: 'Reset progress',
            icon: const Icon(Icons.restart_alt),
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: const Color(0xFF111820),
                  title: const Text('Reset progress?',
                      style: TextStyle(color: Colors.white)),
                  content: const Text(
                    'This clears XP, missions, and badges.',
                    style: TextStyle(color: Colors.white70),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Reset',
                          style: TextStyle(color: Color(0xFFE53E3E))),
                    ),
                  ],
                ),
              );
              if (ok == true) {
                await _progress.resetProgress();
                if (mounted) setState(() {});
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- Level card ---
          Card(
            color: const Color(0xFF0d151c),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: WorkshopColors.brassDark),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(level.icon, style: const TextStyle(fontSize: 34)),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _progress.profile.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            level.name,
                            style: const TextStyle(
                              color: WorkshopColors.brassLight,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        '${_progress.xp} XP',
                        style: const TextStyle(
                          color: WorkshopColors.meterTextGreen,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: _progress.levelProgress,
                      minHeight: 10,
                      backgroundColor: WorkshopColors.ironDark,
                      valueColor: const AlwaysStoppedAnimation(
                        WorkshopColors.brassLight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    next == null
                        ? 'Max level reached — Grandmaster'
                        : '${next.minXP - _progress.xp} XP to ${next.name}',
                    style: const TextStyle(
                      color: WorkshopColors.ironText,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // --- Level ladder ---
          _sectionTitle('Levels'),
          ...ProgressTracker.levels.map((l) {
            final reached = _progress.xp >= l.minXP;
            return ListTile(
              dense: true,
              leading: Text(l.icon, style: const TextStyle(fontSize: 20)),
              title: Text(
                l.name,
                style: TextStyle(
                  color: reached ? Colors.white : Colors.white38,
                  fontWeight: reached ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              trailing: Text(
                '${l.minXP} XP',
                style: TextStyle(
                  color: reached
                      ? WorkshopColors.meterTextGreen
                      : Colors.white38,
                  fontSize: 12,
                ),
              ),
            );
          }),

          const SizedBox(height: 8),

          // --- Badges ---
          _sectionTitle('Badges (${earned.length}/${ProgressTracker.availableBadges.length})'),
          ...ProgressTracker.availableBadges.map((b) {
            final has = _progress.isBadgeEarned(b.id);
            return ListTile(
              dense: true,
              leading: Opacity(
                opacity: has ? 1.0 : 0.3,
                child: Text(b.icon, style: const TextStyle(fontSize: 22)),
              ),
              title: Text(
                b.name,
                style: TextStyle(
                  color: has ? Colors.white : Colors.white38,
                  fontWeight: has ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              subtitle: Text(
                b.description,
                style: const TextStyle(color: Colors.white38, fontSize: 11),
              ),
              trailing: has
                  ? const Icon(Icons.check_circle,
                      color: WorkshopColors.meterTextGreen, size: 18)
                  : const Icon(Icons.lock, color: Colors.white24, size: 16),
            );
          }),

          const SizedBox(height: 8),

          // --- Missions ---
          _sectionTitle(
              'Missions (${_progress.completedMissions.length}/${ProgressTracker.availableMissions.length})'),
          ...ProgressTracker.availableMissions.map((m) {
            final done = _progress.isMissionCompleted(m.id);
            return ListTile(
              dense: true,
              leading: Icon(
                done ? Icons.check_circle : Icons.radio_button_unchecked,
                color: done ? WorkshopColors.meterTextGreen : Colors.white24,
                size: 20,
              ),
              title: Text(
                m.title,
                style: TextStyle(
                  color: done ? Colors.white : Colors.white54,
                  fontWeight: done ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              subtitle: Text(
                m.description,
                style: const TextStyle(color: Colors.white38, fontSize: 11),
              ),
              trailing: Text(
                '+${m.xpReward} XP',
                style: const TextStyle(
                  color: WorkshopColors.brassLight,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4, left: 4),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: WorkshopColors.brass,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
