/// Simple scanner that scans a string a single character at a time.
class StringScanner {
  StringScanner(this.str);

  final String str;
  var _offset = 0;

  /// Returns true if a call to [next] or [peek] will return a new character.
  /// If false then calling either will throw an exception.
  bool get hasNext => str.length > _offset;

  /// Returns the current character from the string and then advances the
  /// pointer to the next character.
  String get next {
    final char = str.substring(_offset, _offset + 1);
    _offset++;
    return char;
  }

  /// Returns the current character from the string.  This will not advance the
  /// pointer so repeated calls to [peek] without a call to [next] will always
  /// return the same character.
  String get peek => str.substring(_offset, _offset + 1);

  /// Returns the sub-string that is remaining from the current pointer until
  /// the end of the string.
  String get remaining => str.substring(_offset);

  @override
  String toString() => remaining;
}
