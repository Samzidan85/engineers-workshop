import 'package:shared_preferences/shared_preferences.dart';

/// Represents a badge/reward that can be earned by the user.
class Badge {
  final String id;
  final String name;
  final String description;
  final String icon;
  final int xpReward;

  const Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.xpReward = 100,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'icon': icon,
        'xpReward': xpReward,
      };

  factory Badge.fromJson(Map<String, dynamic> json) => Badge(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        icon: json['icon'] as String,
        xpReward: json['xpReward'] as int? ?? 100,
      );
}

/// Represents a mission that the user can complete.
class Mission {
  final String id;
  final String title;
  final String description;
  final int xpReward;
  final String category;
  final bool isSecret;

  const Mission({
    required this.id,
    required this.title,
    required this.description,
    required this.xpReward,
    required this.category,
    this.isSecret = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'xpReward': xpReward,
        'category': category,
        'isSecret': isSecret,
      };

  factory Mission.fromJson(Map<String, dynamic> json) => Mission(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        xpReward: json['xpReward'] as int,
        category: json['category'] as String,
        isSecret: json['isSecret'] as bool? ?? false,
      );
}

/// Represents a user profile.
class UserProfile {
  String name;
  String avatar;
  String title;

  UserProfile({
    this.name = 'Engineer',
    this.avatar = '👤',
    this.title = 'Apprentice',
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'avatar': avatar,
        'title': title,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        name: json['name'] as String? ?? 'Engineer',
        avatar: json['avatar'] as String? ?? '👤',
        title: json['title'] as String? ?? 'Apprentice',
      );
}

/// Level definitions with XP thresholds.
class EngineerLevel {
  final String name;
  final int minXP;
  final String icon;

  const EngineerLevel({
    required this.name,
    required this.minXP,
    required this.icon,
  });
}

/// Singleton progress tracker for the gamification system.
class ProgressTracker {
  static final ProgressTracker _instance = ProgressTracker._internal();
  factory ProgressTracker() => _instance;
  ProgressTracker._internal();

  SharedPreferences? _prefs;
  bool _initialized = false;

  // User data
  UserProfile _profile = UserProfile();
  int _xp = 0;
  final Set<String> _completedMissions = {};
  final Set<String> _earnedBadges = {};

  // Level definitions
  static const List<EngineerLevel> levels = [
    EngineerLevel(name: 'Apprentice', minXP: 0, icon: '🔧'),
    EngineerLevel(name: 'Junior Engineer', minXP: 500, icon: '⚙️'),
    EngineerLevel(name: 'Engineer', minXP: 1500, icon: '🔩'),
    EngineerLevel(name: 'Senior Engineer', minXP: 3000, icon: '🛠️'),
    EngineerLevel(name: 'Master Engineer', minXP: 6000, icon: '⚡'),
    EngineerLevel(name: 'Grandmaster', minXP: 10000, icon: '👑'),
  ];

  // Available badges
  static const List<Badge> availableBadges = [
    Badge(
      id: 'first_circuit',
      name: 'First Circuit',
      description: 'Built your first working circuit',
      icon: '💡',
      xpReward: 100,
    ),
    Badge(
      id: 'motor_master',
      name: 'Motor Master',
      description: 'Completed all motor missions',
      icon: '🔌',
      xpReward: 200,
    ),
    Badge(
      id: 'pcb_designer',
      name: 'PCB Designer',
      description: 'Learned PCB design',
      icon: '🖥️',
      xpReward: 200,
    ),
    Badge(
      id: 'troubleshooter',
      name: 'Troubleshooter',
      description: 'Diagnosed 5 faults',
      icon: '🔍',
      xpReward: 150,
    ),
    Badge(
      id: 'knowledge_seeker',
      name: 'Knowledge Seeker',
      description: 'Read all learn articles',
      icon: '📚',
      xpReward: 150,
    ),
    Badge(
      id: 'tip_collector',
      name: 'Tip Collector',
      description: 'Read all tips',
      icon: '💡',
      xpReward: 100,
    ),
    Badge(
      id: 'secret_keeper',
      name: 'Secret Keeper',
      description: 'Unlocked all secrets',
      icon: '🔮',
      xpReward: 300,
    ),
    Badge(
      id: 'engineering_graduate',
      name: 'Engineering Graduate',
      description: 'Reached max level',
      icon: '🎓',
      xpReward: 500,
    ),
  ];

  // Available missions
  static const List<Mission> availableMissions = [
    Mission(
      id: 'build_basic_circuit',
      title: 'Build a Basic Circuit',
      description: 'Connect wires, close switch, and light the lamp',
      xpReward: 100,
      category: 'circuits',
    ),
    Mission(
      id: 'ohms_law_calc',
      title: "Ohm's Law Calculator",
      description: "Calculate Ohm's law for given values",
      xpReward: 50,
      category: 'theory',
    ),
    Mission(
      id: 'dc_motor_run',
      title: 'Run a DC Motor',
      description: 'Run a DC motor at specific parameters',
      xpReward: 150,
      category: 'motors',
    ),
    Mission(
      id: 'motor_fault_diagnosis',
      title: 'Diagnose a Motor Fault',
      description: 'Diagnose and fix a motor fault',
      xpReward: 200,
      category: 'motors',
    ),
    Mission(
      id: 'pcb_layout_design',
      title: 'Design a PCB Layout',
      description: 'Design a PCB layout for a circuit',
      xpReward: 250,
      category: 'pcb',
    ),
    Mission(
      id: 'power_supply_troubleshoot',
      title: 'Troubleshoot a Power Supply',
      description: 'Troubleshoot and repair a power supply',
      xpReward: 200,
      category: 'troubleshooting',
    ),
    Mission(
      id: 'series_circuit',
      title: 'Series Circuit Master',
      description: 'Build and analyze a series circuit',
      xpReward: 100,
      category: 'circuits',
    ),
    Mission(
      id: 'parallel_circuit',
      title: 'Parallel Circuit Master',
      description: 'Build and analyze a parallel circuit',
      xpReward: 100,
      category: 'circuits',
    ),
    Mission(
      id: 'voltage_divider',
      title: 'Voltage Divider Design',
      description: 'Design a voltage divider circuit',
      xpReward: 75,
      category: 'circuits',
    ),
    Mission(
      id: 'led_circuit',
      title: 'LED Circuit Builder',
      description: 'Build an LED circuit with proper resistor',
      xpReward: 75,
      category: 'circuits',
    ),
    Mission(
      id: 'secret_lab',
      title: 'Secret Lab',
      description: 'Discover the hidden lab',
      xpReward: 500,
      category: 'secrets',
      isSecret: true,
    ),
  ];

  /// Initialize the tracker with SharedPreferences.
  Future<void> init() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    _loadFromPrefs();
    _initialized = true;
  }

  void _loadFromPrefs() {
    if (_prefs == null) return;

    final profileJson = _prefs!.getString('profile');
    if (profileJson != null) {
      // Simple parsing - in production use proper JSON
      _profile = UserProfile(
        name: _prefs!.getString('profile_name') ?? 'Engineer',
        avatar: _prefs!.getString('profile_avatar') ?? '👤',
        title: _prefs!.getString('profile_title') ?? 'Apprentice',
      );
    }

    _xp = _prefs!.getInt('xp') ?? 0;

    final missions = _prefs!.getStringList('completed_missions') ?? [];
    _completedMissions.addAll(missions);

    final badges = _prefs!.getStringList('earned_badges') ?? [];
    _earnedBadges.addAll(badges);
  }

  void _saveToPrefs() {
    if (_prefs == null) return;

    _prefs!.setString('profile_name', _profile.name);
    _prefs!.setString('profile_avatar', _profile.avatar);
    _prefs!.setString('profile_title', _profile.title);
    _prefs!.setInt('xp', _xp);
    _prefs!.setStringList('completed_missions', _completedMissions.toList());
    _prefs!.setStringList('earned_badges', _earnedBadges.toList());
  }

  /// Add XP to the user's total.
  void addXP(int amount) {
    _xp += amount;
    _updateTitle();
    _saveToPrefs();
  }

  /// Complete a mission by its ID.
  bool completeMission(String missionId) {
    if (_completedMissions.contains(missionId)) return false;

    final mission = availableMissions.firstWhere(
      (m) => m.id == missionId,
      orElse: () => const Mission(
        id: '',
        title: '',
        description: '',
        xpReward: 0,
        category: '',
      ),
    );

    if (mission.id.isEmpty) return false;

    _completedMissions.add(missionId);
    addXP(mission.xpReward);
    _saveToPrefs();
    return true;
  }

  /// Earn a badge by its ID.
  bool earnBadge(String badgeId) {
    if (_earnedBadges.contains(badgeId)) return false;

    final badge = availableBadges.firstWhere(
      (b) => b.id == badgeId,
      orElse: () => const Badge(
        id: '',
        name: '',
        description: '',
        icon: '',
      ),
    );

    if (badge.id.isEmpty) return false;

    _earnedBadges.add(badgeId);
    addXP(badge.xpReward);
    _saveToPrefs();
    return true;
  }

  /// Get all progress data as a map.
  Map<String, dynamic> getProgress() {
    return {
      'profile': _profile.toJson(),
      'xp': _xp,
      'level': currentLevel,
      'completedMissions': _completedMissions.toList(),
      'earnedBadges': _earnedBadges.toList(),
      'totalMissions': availableMissions.length,
      'totalBadges': availableBadges.length,
    };
  }

  /// Reset all progress data.
  Future<void> resetProgress() async {
    _xp = 0;
    _completedMissions.clear();
    _earnedBadges.clear();
    _profile = UserProfile();
    _updateTitle();
    _saveToPrefs();
  }

  /// Get the current level based on XP.
  EngineerLevel get currentLevel {
    EngineerLevel current = levels.first;
    for (final level in levels) {
      if (_xp >= level.minXP) {
        current = level;
      }
    }
    return current;
  }

  /// Get the next level, or null if max level reached.
  EngineerLevel? get nextLevel {
    final current = this.currentLevel;
    final currentIndex = levels.indexOf(current);
    if (currentIndex < levels.length - 1) {
      return levels[currentIndex + 1];
    }
    return null;
  }

  /// Get progress towards the next level (0.0 to 1.0).
  double get levelProgress {
    final current = this.currentLevel;
    final next = this.nextLevel;
    if (next == null) return 1.0;

    final currentMin = current.minXP;
    final nextMin = next.minXP;
    final progress = (_xp - currentMin) / (nextMin - currentMin);
    return progress.clamp(0.0, 1.0);
  }

  /// Update the user's title based on current level.
  void _updateTitle() {
    _profile.title = currentLevel.name;
  }

  /// Getters
  UserProfile get profile => _profile;
  int get xp => _xp;
  Set<String> get completedMissions => Set.unmodifiable(_completedMissions);
  Set<String> get earnedBadges => Set.unmodifiable(_earnedBadges);

  /// Update user profile.
  void updateProfile({String? name, String? avatar, String? title}) {
    if (name != null) _profile.name = name;
    if (avatar != null) _profile.avatar = avatar;
    if (title != null) _profile.title = title;
    _saveToPrefs();
  }

  /// Check if a mission is completed.
  bool isMissionCompleted(String missionId) => _completedMissions.contains(missionId);

  /// Check if a badge is earned.
  bool isBadgeEarned(String badgeId) => _earnedBadges.contains(badgeId);

  /// Get completed missions as Mission objects.
  List<Mission> get completedMissionObjects {
    return availableMissions
        .where((m) => _completedMissions.contains(m.id))
        .toList();
  }

  /// Get earned badges as Badge objects.
  List<Badge> get earnedBadgeObjects {
    return availableBadges
        .where((b) => _earnedBadges.contains(b.id))
        .toList();
  }

  /// Get available (not yet completed) missions.
  List<Mission> get availableMissionsList {
    return availableMissions
        .where((m) => !_completedMissions.contains(m.id))
        .toList();
  }

  /// Get unearned badges.
  List<Badge> get unearnedBadges {
    return availableBadges
        .where((b) => !_earnedBadges.contains(b.id))
        .toList();
  }
}
