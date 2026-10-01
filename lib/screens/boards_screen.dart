import 'package:flutter/material.dart';
import 'package:engineers_workshop/theme.dart' as th;

/// PCB Reference — boards, soldering, design rules, and designators.
class BoardsScreen extends StatelessWidget {
  const BoardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080c11),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111820),
        title: const Text(
          'PCB Reference',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white70),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionCard(
            context: context,
            title: 'PCB Basics',
            icon: Icons.layers,
            children: [
              _buildSubCard(
                'Single-Layer',
                'Copper on one side of the substrate. Simple and cheap. '
                    'Used for basic circuits, LEDs, and simple power supplies.',
              ),
              _buildSubCard(
                'Double-Layer',
                'Copper on both top and bottom. Allows more complex routing. '
                    'Most common for hobbyist and prototype boards.',
              ),
              _buildSubCard(
                'Multi-Layer (4+)',
                'Alternating copper and substrate layers. Includes dedicated '
                    'power and ground planes. Essential for high-speed digital, RF, '
                    'and dense BGA designs.',
              ),
            ],
          ),
          _buildSectionCard(
            context: context,
            title: 'Through-Hole vs SMD',
            icon: Icons.compare_arrows,
            children: [
              _buildSubCard(
                'Through-Hole (THT)',
                'Components have leads that pass through holes in the board. '
                    'Pros: Strong mechanical bond, easy to hand-solder, good for '
                    'high-power/high-voltage parts.\n'
                    'Cons: Larger, slower to assemble, requires drilled holes.',
              ),
              _buildSubCard(
                'Surface-Mount (SMD)',
                'Components sit directly on pads on the board surface. '
                    'Pros: Much smaller, cheaper, faster to assemble (pick-and-place), '
                    'better high-frequency performance.\n'
                    'Cons: Harder to hand-solder, weaker mechanical bond, '
                    'difficult to prototype without reflow.',
              ),
            ],
          ),
          _buildSectionCard(
            context: context,
            title: 'Soldering Tips',
            icon: Icons.whatshot,
            children: [
              _buildSubCard(
                'Temperature',
                'Use 300–350 °C for leaded solder, 350–380 °C for lead-free. '
                    'Too cold = cold joints; too hot = damaged pads and components.',
              ),
              _buildSubCard(
                'Technique',
                'Heat the pad and the lead simultaneously for 1–2 seconds, '
                    'then feed solder into the joint (not the iron). '
                    'The solder should flow smoothly and form a concave fillet.',
              ),
              _buildSubCard(
                'SMD Soldering',
                'For fine-pitch: use flux, drag soldering with a chisel tip, '
                    'and a solder wick for bridges. For QFN/BGA: hot air rework '
                    'with stencil-applied paste is the way to go.',
              ),
            ],
          ),
          _buildSectionCard(
            context: context,
            title: 'PCB Design Rules',
            icon: Icons.rule,
            children: [
              _buildSubCard(
                'Trace Width',
                'Wider = lower resistance and inductance. Use a trace width '
                    'calculator: 0.25 mm (10 mil) for signal, 0.5–1 mm for power. '
                    'Rule of thumb: 1 mm per 1 A for external layers.',
              ),
              _buildSubCard(
                'Clearance',
                'Minimum distance between copper features. Standard: 0.2 mm (8 mil). '
                    'High-voltage designs need much more — 1 mm per 100 V or more.',
              ),
              _buildSubCard(
                'Ground Plane',
                'A solid copper pour on one layer connected to ground. '
                    'Provides low-impedance return paths, reduces EMI, and helps '
                    'with heat dissipation. Avoid splitting the ground plane.',
              ),
              _buildSubCard(
                'Decoupling',
                'Place 100 nF ceramic capacitors as close as possible to every '
                    'IC power pin. Add a 10–100 µF bulk capacitor per power rail. '
                    'This filters high-frequency noise and provides local charge storage.',
              ),
            ],
          ),
          _buildSectionCard(
            context: context,
            title: 'Common PCB Defects & Fixes',
            icon: Icons.build,
            children: [
              _buildSubCard(
                'Cold Joint',
                'Dull, grainy solder joint caused by insufficient heat or movement '
                    'during cooling. Fix: reflow with fresh solder and flux.',
              ),
              _buildSubCard(
                'Solder Bridge',
                'Unintended solder connection between two pads/pins. '
                    'Fix: use solder wick or a solder sucker to remove excess.',
              ),
              _buildSubCard(
                'Lifted Pad',
                'Pad peeled off the board from excessive heat or mechanical stress. '
                    'Fix: scrape solder mask off the trace and solder a wire to it.',
              ),
              _buildSubCard(
                'Whiskering',
                'Tiny copper whiskers growing between traces over time. '
                    'Fix: conformal coating prevents this; proper spacing reduces risk.',
              ),
            ],
          ),
          _buildSectionCard(
            context: context,
            title: 'Reference Designators',
            icon: Icons.label,
            children: [
              _buildDesignatorTable(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<Widget> children,
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
          children: children,
        ),
      ),
    );
  }

  Widget _buildSubCard(String title, String body) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF111820),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: th.WorkshopColors.ironDark.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: th.WorkshopColors.brassLight,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesignatorTable() {
    const designators = [
      ('R', 'Resistor'),
      ('C', 'Capacitor'),
      ('D', 'Diode'),
      ('Q', 'Transistor'),
      ('U', 'Integrated Circuit'),
      ('T', 'Transformer'),
      ('L', 'Inductor'),
      ('F', 'Fuse'),
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF111820),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: th.WorkshopColors.ironDark.withOpacity(0.5)),
      ),
      child: Column(
        children: designators.map((d) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: th.WorkshopColors.brass.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: th.WorkshopColors.brassDark),
                  ),
                  child: Text(
                    d.$1,
                    style: const TextStyle(
                      color: th.WorkshopColors.brassLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  d.$2,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
