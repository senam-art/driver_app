import 'package:flutter/material.dart';

class BoardingSheet extends StatefulWidget {
  const BoardingSheet({super.key});

  @override
  State<BoardingSheet> createState() => _BoardingSheetState();
}

class _BoardingSheetState extends State<BoardingSheet> {
  bool _isScanning = true;
  bool _hasSucceeded = false;

  void _simulateNfcTap() async {
    // 1. Show scanning state
    setState(() => _isScanning = true);

    // 2. Mock a delay for the NFC "Handshake"
    await Future.delayed(const Duration(seconds: 2));

    // 3. Update UI to success (In real life, this is where your API call happens)
    setState(() {
      _isScanning = false;
      _hasSucceeded = true;
    });

    // 4. Close automatically after success
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      height: 350,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 30),

          if (_hasSucceeded) ...[
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 16),
            const Text(
              "Boarding Successful!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text("Enjoy your ride to Ashesi", style: TextStyle(color: Colors.grey)),
          ] else ...[
            // The "Ready to Scan" State
            const Icon(Icons.nfc_rounded, color: Color(0xFFC62828), size: 80),
            const SizedBox(height: 20),
            const Text(
              "Ready to Scan",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Hold your phone near the Ashesi Go sticker located at the bus entrance.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const Spacer(),
            // Mock Button for your Demo
            TextButton(
              onPressed: _simulateNfcTap,
              child: const Text(
                "Simulate NFC Tap (Demo Only)",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
