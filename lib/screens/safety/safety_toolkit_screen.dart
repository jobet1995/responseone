import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:torch_light/torch_light.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../config/themes.dart';
import '../../models/emergency_model.dart';

class SafetyToolkitScreen extends StatefulWidget {
  const SafetyToolkitScreen({super.key});

  @override
  State<SafetyToolkitScreen> createState() => _SafetyToolkitScreenState();
}

class _SafetyToolkitScreenState extends State<SafetyToolkitScreen> {
  bool _isSirenActive = false;
  bool _isFlashActive = false;
  
  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _sosTimer;
  int _sosIndex = 0;
  
  // SOS Morse Code Pulse Durations (ms)
  // S: . . . (short pulses)
  // O: - - - (long pulses)
  // S: . . .
  final List<int> _sosPattern = [
    200, 200, 200, 200, 200, 600, // S
    600, 200, 600, 200, 600, 600, // O
    200, 200, 200, 200, 200, 1000 // S
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    _setupAudio();
  }

  Future<void> _setupAudio() async {
    try {
      await _audioPlayer.setAudioContext(AudioContext(
        android: const AudioContextAndroid(
          usageType: AndroidUsageType.alarm,
          contentType: AndroidContentType.music,
          audioFocus: AndroidAudioFocus.gainTransient,
        ),
        iOS: AudioContextIOS(
          category: AVAudioSessionCategory.playback,
          options: const {
            AVAudioSessionOptions.defaultToSpeaker,
            AVAudioSessionOptions.mixWithOthers,
          },
        ),
      ));
    } catch (e) {
      debugPrint('Audio Setup Error: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _sosTimer?.cancel();
    _stopFlashlight();
    super.dispose();
  }

  Future<void> _toggleSiren() async {
    try {
      if (_isSirenActive) {
        await _audioPlayer.stop();
      } else {
        // Play local asset
        await _audioPlayer.play(AssetSource('audio/siren.mp3'));
      }
      
      setState(() => _isSirenActive = !_isSirenActive);
      
      if (_isSirenActive) {
        HapticFeedback.vibrate();
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isSirenActive ? 'Siren Activated' : 'Siren Deactivated'),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      debugPrint('Siren Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not play siren. Please check your audio permissions or device settings.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _toggleFlash() async {
    try {
      final isTorchAvailable = await TorchLight.isTorchAvailable();
      if (!isTorchAvailable) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Flashlight not available on this device')),
          );
        }
        return;
      }

      if (_isFlashActive) {
        setState(() => _isFlashActive = false);
        _stopSosFlash();
      } else {
        setState(() => _isFlashActive = true);
        _startSosFlash();
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isFlashActive ? 'SOS Flashlight Activated' : 'Flashlight Deactivated'),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      debugPrint('Flashlight Error: $e');
    }
  }

  void _startSosFlash() {
    _sosIndex = 0;
    _nextSosStep();
  }

  void _stopSosFlash() {
    _sosTimer?.cancel();
    _stopFlashlight();
  }

  Future<void> _stopFlashlight() async {
    try {
      await TorchLight.disableTorch();
    } catch (_) {}
  }

  void _nextSosStep() {
    if (!_isFlashActive) return;

    final bool isOn = _sosIndex % 2 == 0;
    final int duration = _sosPattern[_sosIndex % _sosPattern.length];

    if (isOn) {
      TorchLight.enableTorch();
    } else {
      TorchLight.disableTorch();
    }

    _sosTimer = Timer(Duration(milliseconds: duration), () {
      _sosIndex++;
      _nextSosStep();
    });
  }

  Future<void> _openCrisisCamera() async {
    try {
      final picker = ImagePicker();
      // Show a dialog to choose between Photo and Video
      final choice = await showModalBottomSheet<String>(
        context: context,
        builder: (context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded),
                title: const Text('Take Photo'),
                onTap: () => Navigator.pop(context, 'photo'),
              ),
              ListTile(
                leading: const Icon(Icons.videocam_rounded),
                title: const Text('Record Video'),
                onTap: () => Navigator.pop(context, 'video'),
              ),
            ],
          ),
        ),
      );

      if (choice == null) return;

      XFile? file;
      if (choice == 'photo') {
        file = await picker.pickImage(source: ImageSource.camera);
      } else {
        file = await picker.pickVideo(source: ImageSource.camera);
      }

      if (file != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Crisis ${choice == 'photo' ? 'photo' : 'video'} captured successfully.'),
            backgroundColor: Colors.green,
          ),
        );
        // In a real app, we would upload this or save it to a specific crisis folder
      }
    } catch (e) {
      debugPrint('Camera Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open camera. Please check permissions.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Safety Toolkit'),
        backgroundColor: AppTheme.primaryRed,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'EMERGENCY QUICK ACTIONS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.textSecondary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            _buildToolkitCard(
              title: 'SOS Siren',
              subtitle: 'Plays a loud alarm sound to attract attention.',
              icon: Icons.volume_up_rounded,
              color: Colors.red,
              isActive: _isSirenActive,
              onTap: _toggleSiren,
            ),
            const SizedBox(height: 16),
            _buildToolkitCard(
              title: 'SOS Flashlight',
              subtitle: 'Blinks the camera flash in SOS Morse pattern.',
              icon: Icons.flashlight_on_rounded,
              color: Colors.amber,
              isActive: _isFlashActive,
              onTap: _toggleFlash,
            ),
            const SizedBox(height: 32),
            const Text(
              'PERSONAL SAFETY',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.textSecondary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            _buildActionTile(
              title: 'Fake Call',
              subtitle: 'Receive a simulated call to exit a situation.',
              icon: Icons.phone_callback_rounded,
              color: Colors.blue,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Simulated call incoming in 5 seconds...'),
                    duration: Duration(seconds: 3),
                  ),
                );
                Future.delayed(const Duration(seconds: 5), () {
                  if (mounted) context.push('/fake-call');
                });
              },
            ),
            _buildActionTile(
              title: 'Share Location',
              subtitle: 'Send real-time GPS to trusted contacts.',
              icon: Icons.share_location_rounded,
              color: Colors.green,
              onTap: () => context.push('/share-location'),
            ),
            _buildActionTile(
              title: 'Walk With Me',
              subtitle: 'Keep a responder on the line until you reach home.',
              icon: Icons.directions_walk_rounded,
              color: Colors.purple,
              onTap: () => context.push('/request', extra: EmergencyType.walkWithMe),
            ),
            _buildActionTile(
              title: 'Crisis Camera',
              subtitle: 'Quickly capture evidence of an incident.',
              icon: Icons.camera_alt_rounded,
              color: Colors.orange,
              onTap: _openCrisisCamera,
            ),
            const SizedBox(height: 48),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primaryRed.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.primaryRed.withValues(alpha: 0.1)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.shield_rounded, size: 48, color: AppTheme.primaryRed),
                  const SizedBox(height: 16),
                  const Text(
                    'Stay Safe with ResQNow',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Use these tools proactively. Your safety is our top priority.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolkitCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isActive ? color : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: isActive ? color : Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 48,
              color: isActive ? Colors.white : color,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isActive ? Colors.white : AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isActive ? Colors.white.withValues(alpha: 0.8) : AppTheme.textSecondary,
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

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
      ),
    );
  }
}
