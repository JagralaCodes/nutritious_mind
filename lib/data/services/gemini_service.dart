import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 30),
  ));

  String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  Future<String> sendMessage({
    required List<Map<String, String>> messages,
    required String systemPrompt,
    int maxTokens = 800,
    double temperature = 0.7,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl?key=$_apiKey',
        data: {
          'system_instruction': {
            'parts': [{'text': systemPrompt}]
          },
          'contents': messages.map((m) => {
            'role': m['role'] == 'assistant' ? 'model' : 'user',
            'parts': [{'text': m['content']}]
          }).toList(),
          'generationConfig': {
            'temperature': temperature,
            'maxOutputTokens': maxTokens,
          }
        },
      );
      return response.data['candidates'][0]['content']['parts'][0]['text'];
    } on DioException {
      throw Exception('Connection error. Check your internet.');
    } catch (e) {
      throw Exception('Something went wrong. Try again.');
    }
  }

  Future<String> analyzeIngredients(List<String> ingredients, String context) async {
    return sendMessage(
      messages: [
        {'role': 'user', 'content': 'Analyze this meal combination: ${ingredients.join(", ")}'}
      ],
      systemPrompt: context,
      maxTokens: 600,
      temperature: 0.3,
    );
  }

  Future<String> generateDailyTip(String context) async {
    return sendMessage(
      messages: [
        {'role': 'user', 'content': 'Give me one short daily food tip.'}
      ],
      systemPrompt: context,
      maxTokens: 200,
      temperature: 0.7,
    );
  }

  Future<String> generateWeeklySummary(String context) async {
    return sendMessage(
      messages: [
        {'role': 'user', 'content': 'Give me a 2-sentence weekly summary of my progress.'}
      ],
      systemPrompt: context,
      maxTokens: 200,
      temperature: 0.7,
    );
  }
}
