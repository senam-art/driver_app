import 'package:flutter/material.dart';
import 'package:driver_app/widgets/passenger/pulsating_nfc_icon.dart';
import 'package:vibration/vibration.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:audioplayers/audioplayers.dart';

class BoardingFlowContainer extends StatefulWidget {
  const BoardingFlowContainer({super.key});

  @override
  State<BoardingFlowContainer> createState() => _BoardingFlowContainerState();
}

class _BoardingFlowContainerState extends State<BoardingFlowContainer> {
  final PageController _pageController = PageController();
  int _friendCount = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    _audioPlayer.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // Helper method to trigger the scan success feedback
  Future<void> _triggerScanFeedback() async {
    // 1. Play the short success beep
    try {
      await _audioPlayer.play(AssetSource('sounds/success_beep.mp3'));
    } catch (e) {
      debugPrint("Error playing sound: $e");
    }

    // 2. Trigger a heavy haptic feedback / vibration
    bool hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator) {
      // Custom pattern: brief pause, then a firm double vibration
      Vibration.vibrate(pattern: [0, 80, 50, 80]);
    } else {
      // Fallback to standard heavy impact if custom vibration isn't supported completely well
      await Haptics.vibrate(HapticsType.heavy);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold inside the BottomSheet fixes the overflow issues
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [_buildScanStep(), _buildSuccessAndPayStep()],
      ),
    );
  }

  // STEP 1: PULSATING SCAN
  Widget _buildScanStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Ready to Board", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        const Text(
          "Hold your phone near the bus sticker, make sure NFC is enabled ",
          style: TextStyle(color: Colors.grey),
        ),
        const Spacer(),

        const PulsatingNfcIcon(), // Uses the animation logic from previous steps

        const Spacer(),
        // For Demo purposes, click this to "succeed"
        TextButton(
          onPressed: () async {
            // Trigger physical feedback
            await _triggerScanFeedback();

            // Proceed to success page
            if (context.mounted) {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOutCubic,
              );
            }
          },
          child: const Text("Simulate Tap", style: TextStyle(color: Colors.grey)),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  // STEP 2: PAYMENT & FRIENDS (Scrollable to prevent overflow)
  Widget _buildSuccessAndPayStep() {
    return SingleChildScrollView(
      // Prevents overflow on smaller screens
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 80),
          const SizedBox(height: 16),
          const Text("Success", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const Text("NFC Tap Confirmed", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 30),

          // Fare Card
          _buildFareCard(),

          const SizedBox(height: 20),

          // Friend Section
          _buildPayForFriendSection(),

          const SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text("Done", style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
        ],
      ),
    );
  }

  Widget _buildFareCard() {
    /* Your Card UI here */
    return Container();
  }

  Widget _buildPayForFriendSection() {
    /* Your Friend UI here */
    return Container();
  }
}
