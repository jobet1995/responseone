import 'package:flutter/foundation.dart';

@immutable
class MedicalProfileModel {
  final String id;
  final String userId;
  final String bloodType;
  final String allergies;
  final String medications;
  final String medicalConditions;
  final bool organDonor;
  final DateTime updatedAt;

  const MedicalProfileModel({
    required this.id,
    required this.userId,
    this.bloodType = '',
    this.allergies = '',
    this.medications = '',
    this.medicalConditions = '',
    this.organDonor = false,
    required this.updatedAt,
  });

  factory MedicalProfileModel.fromMap(Map<String, dynamic> map) {
    return MedicalProfileModel(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? map['userId'] ?? '',
      bloodType: map['blood_type'] ?? '',
      allergies: map['allergies'] ?? '',
      medications: map['medications'] ?? '',
      medicalConditions: map['medical_conditions'] ?? '',
      organDonor: map['organ_donor'] ?? false,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'blood_type': bloodType,
      'allergies': allergies,
      'medications': medications,
      'medical_conditions': medicalConditions,
      'organ_donor': organDonor,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  MedicalProfileModel copyWith({
    String? bloodType,
    String? allergies,
    String? medications,
    String? medicalConditions,
    bool? organDonor,
    DateTime? updatedAt,
  }) {
    return MedicalProfileModel(
      id: id,
      userId: userId,
      bloodType: bloodType ?? this.bloodType,
      allergies: allergies ?? this.allergies,
      medications: medications ?? this.medications,
      medicalConditions: medicalConditions ?? this.medicalConditions,
      organDonor: organDonor ?? this.organDonor,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
