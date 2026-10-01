import 'package:flutter/material.dart';
import 'package:engineers_workshop/theme.dart';

class WorkshopHeader extends StatelessWidget {
  const WorkshopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: WorkshopColors.woodDark,
        border: Border(
          bottom: BorderSide(color: WorkshopColors.woodBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.hardware, color: WorkshopColors.brass, size: 28),
          const SizedBox(width: 10),
          const Text(
            "The Engineer's Workshop",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: WorkshopColors.benchMetal,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'v1.0',
              style: TextStyle(
                color: WorkshopColors.ironText,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
