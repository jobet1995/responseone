import 'package:dio/dio.dart';
import '../config/constants.dart';
import '../models/emergency_model.dart';

/// Service to handle emergency reports and interactions.
class EmergencyService {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));

  EmergencyService._();
  
  static final EmergencyService instance = EmergencyService._();

  /// Reports a new emergency.
  Future<EmergencyModel?> createEmergency(Map<String, dynamic> emergencyData) async {
    try {
      final response = await _dio.post(ApiEndpoints.emergencies, data: emergencyData);

      if (response.statusCode == 201) {
        return EmergencyModel.fromMap(response.data);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  /// Fetches a specific emergency by ID.
  Future<EmergencyModel?> getEmergencyById(String id) async {
    try {
      final response = await _dio.get('${ApiEndpoints.emergencies}/$id');

      if (response.statusCode == 200) {
        return EmergencyModel.fromMap(response.data);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  /// Updates the status of an emergency (e.g., Assigned, Arrived).
  Future<bool> updateEmergencyStatus(String id, String status) async {
    try {
      final response = await _dio.patch('${ApiEndpoints.emergencies}/$id', data: {
        'status': status,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Fetches all emergencies reported by a specific user.
  Future<List<EmergencyModel>> getEmergencyHistory(String citizenId) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.emergencies,
        queryParameters: {'citizenId': citizenId},
      );

      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((json) => EmergencyModel.fromMap(json)).toList();
      }
    } catch (e) {
      return [];
    }
    return [];
  }
}
