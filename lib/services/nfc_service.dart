// import 'package:nfc_manager/nfc_manager.dart';

// class NfcService {
//   // Check if the device even has NFC
//   Future<bool> isNfcAvailable() async {
//     return await NfcManager.instance.isAvailable();
//   }

//   // Start listening for a tag
//   void startNfcScan({
//     required Function(String busId) onTagRead,
//     required Function(String error) onError,
//   }) async {
//     bool isAvailable = await isNfcAvailable();
//     if (!isAvailable) {
//       onError("NFC is not available on this device.");
//       return;
//     }

//     NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
//       try {
//         // We look specifically for NDEF data (common for stickers)
//         var ndef = Ndef.from(tag);
        
//         if (ndef == null || ndef.cachedMessage == null) {
//           onError("Tag is empty or not formatted correctly.");
//           return;
//         }

//         // Extract the payload from the first record
//         // This assumes you wrote the Bus ID as a plain text record on the sticker
//         final record = ndef.cachedMessage!.records.first;
//         final payload = String.fromCharCodes(record.payload).substring(3); // 'en' prefix skip

//         onTagRead(payload); // Success! Returns "BUS-AG-105"
        
//         NfcManager.instance.stopSession(); // Always stop after a successful read
//       } catch (e) {
//         onError("Failed to parse tag: $e");
//         NfcManager.instance.stopSession();
//       }
//     }, pollingOptions: null);
//   }
// }