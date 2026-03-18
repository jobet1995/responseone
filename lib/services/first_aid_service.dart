import 'package:hive_flutter/hive_flutter.dart';
import '../models/first_aid_tip_model.dart';

class FirstAidService {
  static const String boxName = 'first_aid_tips';
  
  FirstAidService._();
  static final FirstAidService instance = FirstAidService._();

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(FirstAidTipAdapter());
    }
    await Hive.openBox<FirstAidTip>(boxName);
    
    // Populate with default data if empty
    final box = Hive.box<FirstAidTip>(boxName);
    if (box.isEmpty) {
      await _populateDefaultData(box);
    }
  }

  Future<List<FirstAidTip>> getAllTips() async {
    final box = Hive.box<FirstAidTip>(boxName);
    return box.values.toList();
  }

  Future<FirstAidTip?> getTipById(String id) async {
    final box = Hive.box<FirstAidTip>(boxName);
    return box.get(id);
  }

  Future<void> _populateDefaultData(Box<FirstAidTip> box) async {
    final List<FirstAidTip> defaultTips = [
      FirstAidTip(
        id: 'cpr',
        title: 'CPR',
        description: 'Push hard and fast in the center of the chest.',
        category: 'Basic Life Support',
        iconName: 'favorite',
        colorValue: 0xFFF44336,
        steps: [
          'Check the scene for safety and the person for responsiveness.',
          'Call Emergency Services or ask someone else to do it.',
          'Place the heel of one hand on the center of the chest.',
          'Place the other hand on top and interlock fingers.',
          'Push hard and fast: at least 2 inches deep and 100-120 beats per minute.',
          'Allow the chest to recoil completely between compressions.',
          'Continue until professional help arrives or an AED is available.',
        ],
      ),
      FirstAidTip(
        id: 'choking',
        title: 'Choking',
        description: 'Perform abdominal thrusts (Heimlich maneuver).',
        category: 'Basic Life Support',
        iconName: 'person_search',
        colorValue: 0xFFF44336,
        steps: [
          'Stand behind the person and wrap your arms around their waist.',
          'Make a fist and place the thumb side against their abdomen, just above the navel.',
          'Grasp your fist with your other hand.',
          'Perform quick, upward thrusts into the abdomen.',
          'Continue until the object is forced out or the person becomes unconscious.',
        ],
      ),
      FirstAidTip(
        id: 'bleeding',
        title: 'Heavy Bleeding',
        description: 'Apply direct pressure to the wound.',
        category: 'Injury & Trauma',
        iconName: 'healing',
        colorValue: 0xFFFF9800,
        steps: [
          'Put on gloves if available.',
          'Apply direct pressure to the wound with a clean cloth or bandage.',
          'Maintain pressure until the bleeding stops.',
          'If the blood soaks through, add more bandages on top without removing the old ones.',
          'Elevate the injured area if possible.',
        ],
      ),
      // Add more as needed...
    ];

    for (var tip in defaultTips) {
      await box.put(tip.id, tip);
    }
  }
}
