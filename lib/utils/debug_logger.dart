import 'package:logger/logger.dart';

class Dbg {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 3,
      stackTraceBeginIndex: 1,
      errorMethodCount: 6,
      lineLength: 120,
      colors: true,
      printEmojis: true,
    ),
    level: Level.debug,
  );

  // Standard logging methods
  static void t([dynamic message, dynamic error, StackTrace? stackTrace]) =>
      _logger.t(message ?? '', error: error, stackTrace: stackTrace);
  static void d([dynamic message, dynamic error, StackTrace? stackTrace]) =>
      _logger.d(message ?? '', error: error, stackTrace: stackTrace);
  static void i([dynamic message, dynamic error, StackTrace? stackTrace]) =>
      _logger.i(message ?? '', error: error, stackTrace: stackTrace);
  static void w([dynamic message, dynamic error, StackTrace? stackTrace]) =>
      _logger.w(message ?? '', error: error, stackTrace: stackTrace);
  static void e([dynamic message, dynamic error, StackTrace? stackTrace]) =>
      _logger.e(message ?? '', error: error, stackTrace: stackTrace);

  // CRASH METHODS
  /// Crashes the app with an assertion error
  static void crash(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(' [ CRASH ] : $message', error: error, stackTrace: stackTrace);
    assert(false, 'CRASH: $message');
  }

  /// Marks unimplemented code - crashes with a clear message
  static Never unimplemented([String? feature]) {
    final msg =
        feature != null
            ? 'Feature not implemented: $feature'
            : 'Not implemented';
    _logger.f(' [ UNIMPLEMENTED ] : $msg');
    assert(false, 'UNIMPLEMENTED: $msg');
    throw UnimplementedError(msg);
  }

  /// Marks todo items - logs warning but doesn't crash
  static void todo([String? message]) {
    final msg = message ?? 'TODO item';
    _logger.w(' [ TODO ] : $msg');
  }

  /// Marks unreachable code - crashes if executed
  static Never unreachable([String? message]) {
    final msg = message ?? 'This code should never be reached';
    _logger.f(' [ UNREACHABLE ] : $msg');
    assert(false, 'UNREACHABLE: $msg');
    throw StateError('UNREACHABLE: $msg');
  }

  /// Enhanced warning with context
  static void warn(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(' [ WARNING ] : $message', error: error, stackTrace: stackTrace);
  }
}
