import 'package:dio/dio.dart';
import '../../core/errors/failures.dart';

/// Message role for Ollama API.
enum OllamaRole { system, user, assistant }

class OllamaMessage {
  final OllamaRole role;
  final String content;

  const OllamaMessage({required this.role, required this.content});

  Map<String, dynamic> toJson() => {
        'role': role.name,
        'content': content,
      };
}

/// Response from Ollama chat endpoint.
class OllamaResponse {
  final String content;
  final bool isDone;

  const OllamaResponse({required this.content, required this.isDone});
}

/// Service to communicate with a local Ollama instance.
class OllamaService {
  late Dio _dio;
  String _baseUrl;
  String _model;

  OllamaService({
    String baseUrl = 'http://localhost:11434',
    String model = 'llama3',
  })  : _baseUrl = baseUrl,
        _model = model {
    _initDio();
  }

  void _initDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 120),
        sendTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );
  }

  void configure({required String baseUrl, required String model}) {
    _baseUrl = baseUrl;
    _model = model;
    _initDio();
  }

  /// Check if Ollama is reachable.
  Future<bool> isAvailable() async {
    try {
      final response = await _dio.get('/api/tags');
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// List available models.
  Future<List<String>> listModels() async {
    try {
      final response = await _dio.get('/api/tags');
      final models = response.data['models'] as List<dynamic>? ?? [];
      return models
          .map((m) => m['name']?.toString() ?? '')
          .where((n) => n.isNotEmpty)
          .toList();
    } catch (e) {
      throw OllamaFailure('No se pudo obtener la lista de modelos: $e');
    }
  }

  /// Send a chat completion (non-streaming).
  Future<String> chat({
    required List<OllamaMessage> messages,
    double temperature = 0.7,
  }) async {
    try {
      final response = await _dio.post(
        '/api/chat',
        data: {
          'model': _model,
          'messages': messages.map((m) => m.toJson()).toList(),
          'stream': false,
          'options': {'temperature': temperature},
        },
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return data['message']?['content']?.toString() ??
            data['response']?.toString() ??
            'Sin respuesta';
      }
      return 'Sin respuesta';
    } on DioException catch (e) {
      throw _mapDioError(e);
    } catch (e) {
      throw OllamaFailure('Error inesperado: $e');
    }
  }

  /// Stream a chat response chunk by chunk.
  Stream<String> chatStream({
    required List<OllamaMessage> messages,
    double temperature = 0.7,
  }) async* {
    try {
      final response = await _dio.post<ResponseBody>(
        '/api/chat',
        data: {
          'model': _model,
          'messages': messages.map((m) => m.toJson()).toList(),
          'stream': true,
          'options': {'temperature': temperature},
        },
        options: Options(responseType: ResponseType.stream),
      );

      final stream = response.data!.stream;
      final buffer = StringBuffer();

      await for (final chunk in stream) {
        final raw = String.fromCharCodes(chunk);
        buffer.write(raw);

        final lines = buffer.toString().split('\n');
        for (int i = 0; i < lines.length - 1; i++) {
          final line = lines[i].trim();
          if (line.isEmpty) continue;
          try {
            final jsonStr = line.startsWith('{') ? line : null;
            if (jsonStr == null) continue;
            // Very basic JSON parsing for streaming chunks
            final contentMatch =
                RegExp(r'"content"\s*:\s*"((?:[^"\\]|\\.)*)"')
                    .firstMatch(jsonStr);
            if (contentMatch != null) {
              final content = contentMatch
                  .group(1)!
                  .replaceAll(r'\n', '\n')
                  .replaceAll(r'\"', '"')
                  .replaceAll(r'\\', '\\');
              if (content.isNotEmpty) yield content;
            }
          } catch (_) {}
        }
        buffer.clear();
        if (lines.isNotEmpty) buffer.write(lines.last);
      }
    } on DioException catch (e) {
      throw _mapDioError(e);
    } catch (e) {
      throw OllamaFailure('Error de streaming: $e');
    }
  }

  OllamaFailure _mapDioError(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        const OllamaFailure(
          'Ollama tardó demasiado en responder. ¿Está ejecutándose?\n'
          'Ejecuta: ollama serve',
        ),
      DioExceptionType.connectionError => const OllamaFailure(
          'No se puede conectar a Ollama.\n'
          '1. Abre una terminal\n'
          '2. Ejecuta: ollama serve\n'
          '3. Asegúrate de tener el modelo: ollama pull llama3',
        ),
      DioExceptionType.badResponse => OllamaFailure(
          'Ollama respondió con error ${e.response?.statusCode}: '
          '${e.response?.statusMessage}',
        ),
      _ => OllamaFailure('Error de red: ${e.message}'),
    };
  }
}
