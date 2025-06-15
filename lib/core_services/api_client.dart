import 'dart:convert';
import 'package:http/http.dart' as http;
import 'data_models/participant.dart';

class ApiClient {
  static const String _baseUrl = 'https://par-impar.glitch.me';

  Future<Participant?> registerOrGetParticipant(String participantName) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/novo'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': participantName}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['usuarios'] != null && (data['usuarios'] as List).isNotEmpty) {
          var userData = (data['usuarios'] as List).firstWhere(
            (u) => u['username'] == participantName,
            orElse: () => data['usuarios'][0],
          );
          return Participant.fromJson(userData);
        } else if (data['username'] != null) {
          return Participant.fromJson(data);
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<List<Participant>> getAllParticipants() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/jogadores'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['jogadores'] != null) {
          return (data['jogadores'] as List)
              .map((pJson) => Participant.fromJson(pJson))
              .toList();
        }
      }
    } catch (e) {
      return [];
    }
    return [];
  }

  Future<bool> placeParticipantBet(
    String name,
    int value,
    int choice,
    int number,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/aposta'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': name,
          'valor': value,
          'parimpar': choice,
          'numero': number,
        }),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> startMatch(String p1Name, String p2Name) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/jogar/$p1Name/$p2Name'),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<Participant?> getParticipantScore(String name) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/pontos/$name'));
      if (response.statusCode == 200) {
        return Participant.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
