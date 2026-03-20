import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const PumpApp());

class PumpApp extends StatelessWidget {
  const PumpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pump',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF111111),
        colorScheme: const ColorScheme.dark(primary: Color(0xFF8FD9A8)),
      ),
      home: const HomeScreen(),
    );
  }
}

const int kGlucose = 120;
const double kIOB = 0;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();

  void _onDeliver() {
    final units = double.tryParse(_controller.text);
    if (units == null) return;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ConfirmScreen(
        units: units,
        onConfirm: () {
          HapticFeedback.heavyImpact();
          Navigator.of(context).popUntil((r) => r.isFirst);
          _controller.clear();
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(children: [Text('$kGlucose',style: const TextStyle(fontSize: 96, fontWeight: FontWeight.w900, height: 1.0)),const Text('mg/dL',style: TextStyle(fontSize: 16, color: Colors.white54)),]),
                const SizedBox(width: 32),
                Column(children: [Text('$kIOB',style: const TextStyle(fontSize: 96, fontWeight: FontWeight.w900, height: 1.0)),const Text('IOB',style: TextStyle(fontSize: 16, color: Colors.white54)),]),],),
            const SizedBox(height: 48),
            const Divider(color: Colors.white12),
            const SizedBox(height: 48),

           
            const Text('Bolus',textAlign: TextAlign.center,style: TextStyle(fontSize: 18, color: Colors.white54)),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: '0.0',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF8FD9A8), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _onDeliver,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF8FD9A8),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 18),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                overlayColor: Colors.transparent,
              ),
              child: const Text('Deliver'),
            ),
          ],
        ),
      ),
    );
  }
}

class ConfirmScreen extends StatelessWidget {
  final double units;
  final VoidCallback onConfirm;

  const ConfirmScreen({super.key, required this.units, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Deliver ${units}U?',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            FilledButton(
              onPressed: onConfirm,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF8FD9A8),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 18),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                overlayColor: Colors.transparent,
              ),
              child: const Text('Deliver'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                textStyle: const TextStyle(fontSize: 18),
                overlayColor: Colors.transparent,
              ),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}