import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/first_aid_tip_model.dart';
import '../services/first_aid_service.dart';

final firstAidTipsProvider = FutureProvider<List<FirstAidTip>>((ref) async {
  return FirstAidService.instance.getAllTips();
});

final firstAidTipDetailProvider = FutureProvider.family<FirstAidTip?, String>((ref, id) async {
  return FirstAidService.instance.getTipById(id);
});
