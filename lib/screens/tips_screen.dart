import 'package:flutter/material.dart';
import 'package:engineers_workshop/theme.dart' as th;

/// Practical Tips — expandable cards with hands-on advice.
class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080c11),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111820),
        title: const Text(
          'Practical Tips',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white70),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTipCard(
            context: context,
            title: 'Discharging Capacitors',
            icon: Icons.battery_alert,
            color: const Color(0xFFE53E3E),
            explanation:
                'Large capacitors in power supplies, motor drives, and audio amplifiers '
                'can hold dangerous voltages long after power is removed. A 470 µF cap '
                'charged to 400 V stores 37.6 joules — enough to weld metal.\n\n'
                'Always discharge before working on a circuit.',
            advice:
                '• Use a insulated screwdriver with a resistor (10–100 Ω, 5 W) '
                'soldered to the tip for a controlled discharge.\n'
                '• Never short large caps directly — the spark can damage the cap '
                'and throw molten metal.\n'
                '• Verify with a multimeter before touching anything.\n'
                '• Bleeder resistors across cap terminals are good design practice.',
          ),
          _buildTipCard(
            context: context,
            title: 'Wire Gauge Selection',
            icon: Icons.cable,
            color: const Color(0xFF7dd3fc),
            explanation:
                'Wire gauge determines how much current a wire can safely carry. '
                'Too thin = overheating, voltage drop, and fire risk. '
                'Too thick = wasted copper, cost, and stiffness.\n\n'
                'The key metric is current density (A/mm²).',
            advice:
                '• Chassis wiring: 6–8 A/mm² (short runs, free air).\n'
                '• Power distribution: 3–4 A/mm² (bundled, enclosed).\n'
                '• For 10 A: use 2.5 mm² (14 AWG) minimum.\n'
                '• For 25 A: use 6 mm² (10 AWG) minimum.\n'
                '• Always check voltage drop over long runs, not just ampacity.',
          ),
          _buildTipCard(
            context: context,
            title: 'Heat Management',
            icon: Icons.thermostat,
            color: const Color(0xFFECC94B),
            explanation:
                'Heat is the #1 killer of electronic components. Every 10 °C rise '
                'roughly halves the lifespan of electrolytic capacitors. '
                'Semiconductors fail when junction temperatures exceed ratings.\n\n'
                'Thermal resistance (°C/W) tells you how hot a component gets per watt dissipated.',
            advice:
                '• Heatsinks: match thermal resistance to power dissipation.\n'
                '• Thermal paste: thin, even layer — too much is as bad as too little.\n'
                '• Airflow: hot air rises; intake low, exhaust high.\n'
                '• Derate components: run at 50–70% of max rating for reliability.\n'
                '• Use thermal vias under hot components to conduct heat to the other side.',
          ),
          _buildTipCard(
            context: context,
            title: 'Systematic Troubleshooting',
            icon: Icons.search,
            color: const Color(0xFF48BB78),
            explanation:
                'Random poking around wastes time and can make things worse. '
                'A systematic approach finds faults faster and builds real skill.\n\n'
                'The key: divide and conquer. Split the circuit in half, determine '
                'which half has the fault, repeat.',
            advice:
                '• Start with the obvious: power, fuses, connectors, visual damage.\n'
                '• Measure voltages at key points — compare to expected values.\n'
                '• Signal injection: inject a known signal at the input, '
                'trace it through with an oscilloscope.\n'
                '• For digital: check clocks, resets, and communication lines first.\n'
                '• Document what you find — it helps you see patterns.',
          ),
          _buildTipCard(
            context: context,
            title: 'Planning Before Soldering',
            icon: Icons.list_alt,
            color: th.WorkshopColors.brassLight,
            explanation:
                'Jumping straight into soldering without planning leads to '
                'messy boards, cold joints, and difficult rework. '
                'A few minutes of planning saves hours of frustration.',
            advice:
                '• Place components in order of height: shortest first '
                '(resistors, diodes), then ICs, then tallest (caps, connectors).\n'
                '• Orient all polarized components the same way for easy visual inspection.\n'
                '• Do a dry fit: place all parts without soldering to check fit.\n'
                '• Tack one corner pin of each IC, then reflow the rest.\n'
                '• Use flux — it makes every joint better.',
          ),
          _buildTipCard(
            context: context,
            title: 'Grounding',
            icon: Icons.power,
            color: const Color(0xFFB794F4),
            explanation:
                'Grounding is the most misunderstood topic in electronics. '
                'A poor ground scheme causes noise, oscillation, and mysterious '
                'intermittent faults.\n\n'
                'Ground is not a magic sink for electrons — it is a return path. '
                'Current flows in loops.',
            advice:
                '• Star grounding: all ground returns meet at one point '
                '(best for mixed-signal).\n'
                '• Ground planes: low impedance, excellent for digital and RF.\n'
                '• Separate analog and digital grounds, connect at one point '
                'near the ADC.\n'
                '• Keep high-current return paths away from sensitive signal grounds.\n'
                '• Ground loops: break them with isolation or differential signaling.',
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required String explanation,
    required String advice,
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
                    'Practical Advice',
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
        ),
      ),
    );
  }
}
