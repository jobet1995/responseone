import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:audioplayers/audioplayers.dart';

class FakeCallScreen extends StatefulWidget {
  final String callerName;
  final String callerNumber;

  const FakeCallScreen({
    super.key,
    this.callerName = 'Emergency Dispatch',
    this.callerNumber = '+1 (555) 0199',
  });

  @override
  State<FakeCallScreen> createState() => _FakeCallScreenState();
}

class _FakeCallScreenState extends State<FakeCallScreen> {
  final AudioPlayer _ringtonePlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _startRingtone();
  }

  @override
  void dispose() {
    _ringtonePlayer.dispose();
    super.dispose();
  }

  Future<void> _startRingtone() async {
    try {
      await _ringtonePlayer.setReleaseMode(ReleaseMode.loop);
      // Using a standard subtle ringtone from Mixkit
      await _ringtonePlayer.play(UrlSource('https://assets.mixkit.co/sfx/preview/mixkit-classic-phone-ring-tone-2944.mp3'));
    } catch (e) {
      debugPrint('Ringtone Error: $e');
    }
  }

  void _handleDecline() {
    _ringtonePlayer.stop();
    context.pop();
  }

  void _handleAccept() {
    _ringtonePlayer.stop();
    context.pushReplacement('/in-call', extra: {
      'name': widget.callerName,
      'number': widget.callerNumber,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E), // Dark iOS-style background
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 80),
            Text(
              widget.callerName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ResQNow Mobile',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 16,
                letterSpacing: 0.5,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 64),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCallAction(
                    icon: Icons.call_end,
                    label: 'Decline',
                    color: Colors.red,
                    onTap: _handleDecline,
                  ),
                  _buildCallAction(
                    icon: Icons.call,
                    label: 'Accept',
                    color: Colors.green,
                    onTap: _handleAccept,
                    isAnimated: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool isAnimated = false,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 72,
            width: 72,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 36),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
      ],
    );
  }
}
