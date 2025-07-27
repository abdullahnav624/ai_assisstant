import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;

/// This takes a prompt and a callback to update the response in real time
Future<void> streamChatResponse({
  required String prompt,
  required Function(String) onStreamUpdate,
  required Function(String?) onError,
  required VoidCallback onComplete,
}) async {
  final url = Uri.parse('http://10.0.2.2:11434/api/generate');
  final request =
      http.Request('POST', url)
        ..headers['Content-Type'] = 'application/json'
        ..body = jsonEncode({
          'model': 'llama3',
          'prompt': prompt,
          'stream': true,
        });

  try {
    final response = await request.send();

    if (response.statusCode != 200) {
      onError('Error: ${response.statusCode}');
      return;
    }

    final stream = response.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    String buffer = '';

    await for (final line in stream) {
      if (line.trim().isEmpty) continue;

      final jsonLine = json.decode(line);

      if (jsonLine['done'] == true) break;

      buffer += jsonLine['response'] ?? '';
      onStreamUpdate(buffer);
    }

    onComplete();
  } catch (e) {
    onError('Streaming failed: $e');
  }
}
