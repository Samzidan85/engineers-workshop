import 'package:flutter/material.dart';
import 'package:engineers_workshop/theme.dart' as th;

/// Insider Secrets — hard-won knowledge from experienced engineers.
class SecretsScreen extends StatelessWidget {
  const SecretsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080c11),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111820),
        title: const Text(
          'Insider Secrets',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white70),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSecretCard(
            context: context,
            title: 'The 80/20 of Troubleshooting',
            icon: Icons.trending_up,
            color: const Color(0xFF48BB78),
            explanation:
                '80% of faults are caused by 20% of possible causes. '
                'The most common failures in order:\n\n'
                '1. Loose or corroded connections\n'
                '2. Blown fuses / tripped breakers\n'
                '3. Cold solder joints\n'
                '4. Failed electrolytic capacitors\n'
                '5. Broken wires / cracked traces\n\n'
                'Always check the boring stuff first. The exotic fault is almost '
                'never the actual fault.',
          ),
          _buildSecretCard(
            context: context,
            title: 'Component Derating',
            icon: Icons.shield,
            color: const Color(0xFF7dd3fc),
            explanation:
                'Never run a component at its maximum rating. Manufacturers specify '
                'absolute maximums — exceeding them, even briefly, can cause latent '
                'damage that shows up as a mysterious failure weeks later.\n\n'
                'The military and aerospace industries have used derating for decades. '
                'It is why their equipment lasts 30+ years.',
            advice:
                '• Resistors: run at ≤ 50% of rated power.\n'
                '• Capacitors: run at ≤ 80% of rated voltage.\n'
                '• Semiconductors: keep junction temperature ≤ 75% of max.\n'
                '• Connectors: run at ≤ 50% of rated current.\n'
                '• Motors: run at ≤ 70% of stall torque.',
          ),
          _buildSecretCard(
            context: context,
            title: 'Reading Datasheets',
            icon: Icons.description,
            color: th.WorkshopColors.brassLight,
            explanation:
                'Datasheets are written by engineers for engineers, but they are '
                'not tutorials. Knowing what to look for is a skill.\n\n'
                'The most important sections are often skipped by beginners.',
            advice:
                '• Page 1: Key specs — is this part even suitable?\n'
                '• Absolute Maximum Ratings: never exceed, even for a microsecond.\n'
                '• Electrical Characteristics: typical vs min/max — design for worst case.\n'
                '• Application Information: the reference designs are gold.\n'
                '• Package Dimensions: check your footprint before ordering.\n'
                '• Typical Performance Curves: these tell you how the part really behaves.',
          ),
          _buildSecretCard(
            context: context,
            title: 'Oscillation Causes',
            icon: Icons.waves,
            color: const Color(0xFFE53E3E),
            explanation:
                'Oscillation is when a circuit amplifies its own noise, creating '
                'an unwanted AC signal. It is the most common "ghost in the machine" '
                'problem in analog and power electronics.\n\n'
                'Oscillation requires two things: gain and feedback. '
                'Break either one and the oscillation stops.',
            advice:
                '• Op-amps: check phase margin, add compensation if needed.\n'
                '• Power supplies: output capacitors with wrong ESR can cause oscillation.\n'
                '• Layout: long feedback traces act as antennas — keep them short.\n'
                '• Ground loops: a ground loop can provide unintended feedback.\n'
                '• Fix: add a small capacitor (10–100 pF) across the feedback resistor.',
          ),
          _buildSecretCard(
            context: context,
            title: 'Multimeter Battery Trick',
            icon: Icons.battery_std,
            color: const Color(0xFFECC94B),
            explanation:
                'A weak multimeter battery can give false readings, especially '
                'on high-impedance circuits. The meter loads the circuit less '
                'when the battery is fresh.\n\n'
                'This is a classic "the circuit works until I measure it" problem.',
            advice:
                '• Replace multimeter batteries proactively — every 6–12 months.\n'
                '• If readings seem erratic, check the battery first.\n'
                '• A fresh battery also ensures the continuity beeper works reliably.\n'
                '• Keep a spare 9 V battery in your toolkit.\n'
                '• Some meters show a low-battery icon — don\'t ignore it.',
          ),
          _buildSecretCard(
            context: context,
            title: 'Soldering Iron Care',
            icon: Icons.whatshot,
            color: const Color(0xFFB794F4),
            explanation:
                'A soldering iron is a precision tool, not a hammer. '
                'Proper care extends tip life from weeks to years and makes '
                'every solder joint better.\n\n'
                'The enemy of soldering iron tips is oxidation and thermal shock.',
            advice:
                '• Keep the tip tinned: always have a thin layer of molten solder on it.\n'
                '• Clean with a damp sponge or brass wool — not a file or sandpaper.\n'
                '• Turn off or reduce temperature when idle for > 5 minutes.\n'
                '• Never use the iron as a pry bar or screwdriver.\n'
                '• Retire tips when they won\'t hold solder — a new tip is cheaper than '
                'a damaged board.\n'
                '• Use the right tip size: too small = slow heat transfer; too big = '
                'damages small pads.',
          ),
        ],
      ),
    );
  }

  Widget _buildSecretCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required String explanation,
    String? advice,
  }) {
    return Card(
      color: const Color(0xFF0d151c),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withOpacity(0.3)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          iconColor: color,
          collapsedIconColor: Colors.white54,
          title: Row(
            children: [
              Icon(icon, color: color, size: 22),
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
            Text(
              explanation,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            if (advice != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF111820),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Key Points',
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      advice,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
