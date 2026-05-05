import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
// ignore: clean_layer_files_and_self_imports

final logger = Logger(
  level: Level.debug,
  printer: SimpleEmojiPrinter(),
);

class SimpleEmojiPrinter extends LogPrinter {
  static const Map<Level, String> _levelEmojis = {
    Level.trace: '🔍',
    Level.debug: '🐛',
    Level.info: 'ℹ️',
    Level.warning: '⚠️',
    Level.error: '❌',
    Level.fatal: '💥',
  };

  final DateFormat _timeFormat = DateFormat('HH:mm:ss.SSS');
  // Maximum characters per printed chunk. Keep large to avoid many lines,
  // but small enough to be safe for consoles that may truncate long prints.
  static const int _chunkSize = 1000;

  @override
  List<String> log(final LogEvent event) {
    final emoji = _levelEmojis[event.level] ?? '';
    final formattedTime = _timeFormat.format(DateTime.now());

    final fileInfo = _extractCallerFileInfo();

    final includeLocation = event.level == Level.warning || event.level == Level.error || event.level == Level.fatal;

    final message = event.message;

    final messageStr = _stringifyMessage(message);
    final prefix = '$emoji $formattedTime ';

    final full = '$prefix$messageStr';

    // Split into chunks so the console/printer doesn't truncate the output
    final out = <String>[];
    if (full.length <= _chunkSize) {
      out.add(full);
    } else {
      for (var i = 0; i < full.length; i += _chunkSize) {
        final end = min(i + _chunkSize, full.length);
        out.add(full.substring(i, end));
      }
    }

    if (includeLocation && fileInfo.isNotEmpty) {
      out.add('... see: [$fileInfo]');
    }

    return out;
  }

  // Convert common types (Map/List) to pretty JSON; otherwise fallback to toString().
  String _stringifyMessage(final Object? msg) {
    if (msg == null) {
      return 'null';
    }
    try {
      if (msg is String) {
        return msg;
      }
      // Pretty print Maps and Lists as JSON for full readability
      if (msg is Map || msg is List) {
        return const JsonEncoder.withIndent('  ').convert(msg);
      }
      // Logger package sometimes passes Exception or other objects
      return msg.toString();
    } catch (_) {
      try {
        return msg.toString();
      } catch (__) {
        return '<unprintable message>';
      }
    }
  }

  // Inspect the current stack trace and try to find the first frame outside
  // this file and the logger package. Returns a compact 'file:line' or empty.
  String _extractCallerFileInfo() {
    try {
      final trace = StackTrace.current.toString().split('\n');
      for (final line in trace) {
        if (line.contains('logger.dart') || line.contains('package:logger')) {
          continue;
        }
        final match = RegExp(r'([^\s]+\.dart):(\d+)').firstMatch(line);
        if (match != null) {
          return '${match.group(1)}:${match.group(2)}';
        }
      }
    } catch (_) {}
    return '';
  }
}

// AppLogger wrapper mirroring Android Logger API
class AppLogger {
  static const int _maxTagLength = 22;
  final String tag;
  AppLogger._(this.tag);

  factory AppLogger.forType(final Type t) => AppLogger._(_normalizeTag(t.toString()));
  factory AppLogger.forName(final String name) => AppLogger._(_normalizeTag(name));

  static String _normalizeTag(final String t) {
    if (t.length <= _maxTagLength) {
      return t;
    }
    return t.substring(0, _maxTagLength - 1);
  }
}
