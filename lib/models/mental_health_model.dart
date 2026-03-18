import 'package:flutter/foundation.dart';

enum MentalHealthCrisisType {
  anxiety('Anxiety/Panic Attack'),
  depression('Severe Depression'),
  selfHarm('Self-Harm'),
  suicidalIdeation('Suicidal Ideation'),
  psychosis('Psychosis/Hallucinations'),
  substanceAbuse('Substance Abuse Crisis'),
  other('Other');

  final String value;
  const MentalHealthCrisisType(this.value);
}

enum RiskLevel {
  low('Low'),
  medium('Medium'),
  high('High'),
  extreme('Extreme');

  final String value;
  const RiskLevel(this.value);
}

@immutable
class MentalHealthReportModel {
  final String? id;
  final String emergencyId;
  final MentalHealthCrisisType crisisType;
  final RiskLevel riskLevel;
  final bool isViolent;
  final bool hasWeapon;
  final String? medications;
  final String? history;
  final DateTime createdAt;

  const MentalHealthReportModel({
    this.id,
    required this.emergencyId,
    required this.crisisType,
    required this.riskLevel,
    this.isViolent = false,
    this.hasWeapon = false,
    this.medications,
    this.history,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'emergency_id': emergencyId,
      'crisis_type': crisisType.value,
      'risk_level': riskLevel.value,
      'is_violent': isViolent,
      'has_weapon': hasWeapon,
      'medications': medications,
      'history': history,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory MentalHealthReportModel.fromMap(Map<String, dynamic> map) {
    return MentalHealthReportModel(
      id: map['id'],
      emergencyId: map['emergency_id'],
      crisisType: MentalHealthCrisisType.values.firstWhere(
        (e) => e.value == map['crisis_type'],
        orElse: () => MentalHealthCrisisType.other,
      ),
      riskLevel: RiskLevel.values.firstWhere(
        (e) => e.value == map['risk_level'],
        orElse: () => RiskLevel.medium,
      ),
      isViolent: map['is_violent'] ?? false,
      hasWeapon: map['has_weapon'] ?? false,
      medications: map['medications'],
      history: map['history'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  MentalHealthReportModel copyWith({
    String? id,
    String? emergencyId,
    MentalHealthCrisisType? crisisType,
    RiskLevel? riskLevel,
    bool? isViolent,
    bool? hasWeapon,
    String? medications,
    String? history,
    DateTime? createdAt,
  }) {
    return MentalHealthReportModel(
      id: id ?? this.id,
      emergencyId: emergencyId ?? this.emergencyId,
      crisisType: crisisType ?? this.crisisType,
      riskLevel: riskLevel ?? this.riskLevel,
      isViolent: isViolent ?? this.isViolent,
      hasWeapon: hasWeapon ?? this.hasWeapon,
      medications: medications ?? this.medications,
      history: history ?? this.history,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
