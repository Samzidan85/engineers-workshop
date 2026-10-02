# The Engineer's Workshop

An offline Flutter app for learning practical electrical and electronic engineering —
build circuits on a simulated bench, run motors, use engineering calculators, and
study a reference library of boards, tips and field secrets.

**Android APK → [Releases](../../releases/latest)** · minSdk 24 · targetSdk 36

---

## Download

The APK is **not** in this repo's file tree — GitHub stores release assets separately.
Get it from the Releases page:

1. Open **[Releases](../../releases/latest)** (right sidebar of the repo home, or add `/releases` to the URL)
2. Under the latest release, expand **Assets**
3. Download `app-release.apk` and tap it to install

Direct link to the current build:

```
https://github.com/Samzidan85/engineers-workshop/releases/latest/download/app-release.apk
```

You will need to allow "install from unknown sources" for whichever app opens the file.

## What's in it

**Level 1 — Circuit Bench.** Place a battery, resistor and lamp on the bench, then wire
them into a loop with the Wire tool. The solver runs on every change and lights the lamp
when the circuit closes. Voltmeter and ammeter can be dropped in to probe the circuit.
Completing a circuit awards 100 XP and the *First Circuit* badge.

**Level 2 — DC Motor Lab.** Interactive DC motor model: armature resistance, back-EMF
constant, stall current and torque. Adjust supply voltage and mechanical load, watch
current, speed and torque respond.

**Level 3 — Engineering Calculators.** Ohm's Law (solve for any variable), Power,
Voltage Drop, Cable Sizing, and Transformer Turns Ratio.

**Reference library** (from the top nav):

| Screen | Contents |
|---|---|
| Learn | Ohm's Law, Kirchhoff's Laws, Power, Series & Parallel, Capacitors & Inductors, AC vs DC — each with formula and worked example |
| Boards | PCB basics, through-hole vs SMD, soldering, design rules, common PCB defects & fixes, reference designators |
| Tips | Capacitor discharge, wire gauge selection, heat management, systematic troubleshooting, planning before soldering, grounding |
| Secrets | The 80/20 of troubleshooting, component derating, reading datasheets, oscillation causes, multimeter battery trick, soldering iron care |

**Progress system.** Six levels (Apprentice → Junior Engineer → Engineer → Senior
Engineer → Master Engineer → Grandmaster), XP, eight badges, and a mission log. All
persisted locally via SharedPreferences. Tap the XP chip in the header or *Profile* to
view, and reset from there.

## Building

The APK is built by GitHub Actions (`.github/workflows/build-apk.yml`) on every push to
`master` — see the **Actions** tab. To build locally you need a Flutter SDK and Android
SDK:

```bash
flutter pub get
flutter build apk --release
# output: build/app/outputs/flutter-apk/app-release.apk
```

## Layout

```
lib/
  main.dart                    app entry, orientation, progress init
  progress.dart                XP / levels / badges / missions (SharedPreferences)
  theme.dart                   workshop colour palette
  circuit_engine/              circuit solver (nodes, components, meters)
  screens/
    workshop_screen.dart       level host + routing
    circuit_bench_screen.dart  L1
    motors_screen.dart         L2
    engineering_screen.dart    L3
    learn_screen.dart          reference library
    boards_screen.dart
    tips_screen.dart
    secrets_screen.dart
    profile_screen.dart        XP, badges, missions
  widgets/
    workshop_header.dart       title, XP chip, nav
    level_selector.dart        level chips
    circuit_canvas.dart        bench canvas + controller
    component_block.dart       battery / resistor / lamp
    tool_tray.dart             component palette + tools
    ...
```

## Notes

- The bench solver is exercised on every component placement and wire connection; the
  lamp lights when the circuit solves successfully.
- `flutter analyze` is clean (0 errors). Remaining output is lint info only
  (deprecated `withOpacity`, unused imports).
