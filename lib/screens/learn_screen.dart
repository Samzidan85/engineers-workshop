import 'package:flutter/material.dart';
import 'package:engineers_workshop/theme.dart' as th;

/// Knowledge Base — expandable cards covering core EE topics.
class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080c11),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111820),
        title: const Text(
          'Learn',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white70),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTopicCard(
            context: context,
            title: "Ohm's Law",
            icon: Icons.bolt,
            formula: 'V = I × R',
            explanation:
                'Voltage (V) equals current (I) multiplied by resistance (R). '
                'This is the most fundamental relationship in electrical engineering. '
                'It tells us that the voltage across a resistor is proportional to '
                'the current flowing through it.',
            example:
                'A 100 Ω resistor with 0.5 A flowing through it has '
                'V = 0.5 × 100 = 50 V across it.',
          ),
          _buildTopicCard(
            context: context,
            title: "Kirchhoff's Laws",
            icon: Icons.account_tree,
            formula: 'ΣI = 0 (KCL)  ·  ΣV = 0 (KVL)',
            explanation:
                'Kirchhoff\'s Current Law (KCL): The sum of currents entering a node '
                'equals the sum leaving it — charge is conserved.\n\n'
                'Kirchhoff\'s Voltage Law (KVL): The sum of voltages around any closed '
                'loop is zero — energy is conserved.',
            example:
                'KCL: If 3 A enters a junction and 1.5 A leaves through one branch, '
                '1.5 A must leave through the other.\n\n'
                'KVL: In a loop with a 12 V battery and two resistors dropping 7 V and 5 V, '
                '12 − 7 − 5 = 0 ✓',
          ),
          _buildTopicCard(
            context: context,
            title: 'Power',
            icon: Icons.power,
            formula: 'P = V × I = I² × R = V² / R',
            explanation:
                'Electrical power is the rate at which energy is transferred. '
                'In DC circuits, power is simply voltage times current. '
                'Using Ohm\'s law, we can derive the other forms.',
            example:
                'A 12 V motor drawing 2 A consumes P = 12 × 2 = 24 W. '
                'If the motor winding is 3 Ω, P = 2² × 3 = 12 W is lost as heat.',
          ),
          _buildTopicCard(
            context: context,
            title: 'Series & Parallel',
            icon: Icons.linear_scale,
            formula:
                'Series: R_total = R₁ + R₂ + …  ·  Parallel: 1/R_total = 1/R₁ + 1/R₂ + …',
            explanation:
                'Series: Components share the same current; resistances add up. '
                'Parallel: Components share the same voltage; conductances add up.\n\n'
                'Series increases total resistance; parallel decreases it.',
            example:
                'Two 10 Ω resistors in series: R = 20 Ω.\n'
                'Two 10 Ω resistors in parallel: R = 5 Ω.',
          ),
          _buildTopicCard(
            context: context,
            title: 'Capacitors & Inductors',
            icon: Icons.battery_charging_full,
            formula: 'C = Q / V  ·  V = L × dI/dt',
            explanation:
                'Capacitors store energy in an electric field. Current leads voltage by 90°.\n\n'
                'Inductors store energy in a magnetic field. Voltage leads current by 90°.\n\n'
                'Both are reactive components — they store and release energy rather than '
                'dissipating it.',
            example:
                'A 100 µF capacitor charged to 12 V stores '
                'E = ½CV² = 0.5 × 100e-6 × 144 = 7.2 mJ.\n\n'
                'A 10 mH inductor carrying 2 A stores '
                'E = ½LI² = 0.5 × 10e-3 × 4 = 20 mJ.',
          ),
          _buildTopicCard(
            context: context,
            title: 'AC vs DC',
            icon: Icons.waves,
            formula: 'DC: constant  ·  AC: V(t) = V_peak × sin(2πft)',
            explanation:
                'DC (Direct Current) flows in one direction — batteries, solar cells.\n\n'
                'AC (Alternating Current) reverses direction periodically — mains power. '
                'AC is used for power transmission because voltage can be easily '
                'transformed up (low current, less loss) and down (safe usage).',
            example:
                'Mains: 230 V RMS at 50 Hz (Europe) or 120 V RMS at 60 Hz (US).\n'
                'V_peak = V_RMS × √2 ≈ 230 × 1.414 ≈ 325 V.',
          ),
        ],
      ),
    );
  }

  Widget _buildTopicCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required String formula,
    required String explanation,
    required String example,
  }) {
    return Card(
      color: const Color(0xFF0d151c),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: th.WorkshopColors.ironDark),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          iconColor: th.WorkshopColors.brassLight,
          collapsedIconColor: Colors.white54,
          title: Row(
            children: [
              Icon(icon, color: th.WorkshopColors.brass, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          children: [
            // Formula
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF111820),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: th.WorkshopColors.brassDark),
              ),
              child: Text(
                formula,
                style: const TextStyle(
                  color: Color(0xFF7dd3fc),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Explanation
            Text(
              explanation,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            // Example
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: th.WorkshopColors.woodDark.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: th.WorkshopColors.woodBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Example',
                    style: TextStyle(
                      color: th.WorkshopColors.brassLight,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    example,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
