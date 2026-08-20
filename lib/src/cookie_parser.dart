import 'string_scanner.dart';

/// Parser that can parse the cookies from the http package's `set-cookie`
/// header response.  Unfortunately, the http package does a "dumb" join of all
/// cookies with the same value utilizing a single comma.  For lots of headers,
/// that can be separated with a simple split.  However, for `set-cookie`, the
/// values themselves may have commas so a more nuanced parsing is required.
class CookieParser {
  /// Create the parser with the value from the http response's `set-cookie`
  /// header value.
  CookieParser(this.setCookie);

  final String setCookie;

  /// Returns a list of strings where each string was a singular `set-cookie`
  /// value before the http package performed the join.
  List<String> get cookies {
    final result = <String>[];

    final scanner = StringScanner(setCookie.trim());
    while (scanner.hasNext) {
      result.add(_nextCookie(scanner));
    }

    return result;
  }

  String _nextCookie(StringScanner scanner) {
    final buf = StringBuffer();

    var first = true;
    while (scanner.hasNext) {
      final name = _parseKey(scanner);
      final value = switch (name.toLowerCase()) {
        'expires' => _parseCommaAllowedValue(scanner),
        'httponly' || 'partitioned' || 'secure' => null,
        _ =>
          first
              ? _parseCommaAllowedValue(scanner)
              : _parseRegularValue(scanner),
      };
      first = false;
      buf.write(name);
      if (value != null) {
        buf.write('=$value');
      }

      if (!scanner.hasNext || scanner.peek == ',') {
        break;
      }
      buf.write('; ');
      _drainWhitespace(scanner);
    }

    // We ended on a split, so drain the comma.
    if (scanner.hasNext && scanner.peek == ',') {
      scanner.next;
    }

    return buf.toString();
  }

  void _drainWhitespace(StringScanner scanner) {
    while (scanner.peek == ' ') {
      scanner.next;
    }
  }

  String _parseCommaAllowedValue(StringScanner scanner) {
    final buf = StringBuffer();
    var ch = scanner.next;
    while (ch != ';' && ch != '') {
      buf.write(ch);
      ch = scanner.hasNext ? scanner.next : '';
    }

    return buf.toString().trim();
  }

  String _parseKey(StringScanner scanner) {
    final buf = StringBuffer();
    var ch = scanner.next;
    while (ch != '=' && ch != ';') {
      buf.write(ch);
      if (!scanner.hasNext || scanner.peek == ',') {
        break;
      }

      ch = scanner.next;
    }
    return buf.toString().trim();
  }

  String _parseRegularValue(StringScanner scanner) {
    final buf = StringBuffer();
    var ch = scanner.next;
    while (ch != ';' && ch != '') {
      buf.write(ch);

      if (!scanner.hasNext || scanner.peek == ',') {
        break;
      }
      ch = scanner.hasNext ? scanner.next : '';
    }
    return buf.toString().trim();
  }
}
