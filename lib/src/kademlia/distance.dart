import 'package:dtorrent_common/dtorrent_common.dart';

class Distance {
  final List<int> _buffer;

  List<int> get buffer => _buffer;

  String? _str;

  String? _hexStr;

  int get length => _buffer.length;

  Distance(this._buffer);
  @Deprecated('use [] operator instead')
  int getValue(int index) {
    return _buffer[index];
  }

  // returns id as hex string
  toHexString() {
    _hexStr ??= _buffer.toHexString();
    return _hexStr!;
  }

  @override
  String toString() {
    _str ??= String.fromCharCodes(_buffer);
    return _str!;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  bool operator ==(other) {
    if (other is Distance) {
      if (other.length == length) {
        for (var i = 0; i < length; i++) {
          if (this[i] != other[i]) return false;
        }
        return true;
      }
    }
    return false;
  }

  bool operator >=(a) {
    if (a is Distance) {
      if (a.length == length) {
        for (var i = 0; i < length; i++) {
          if (a[i] > this[i]) return false;
        }
        return true;
      } else {
        throw 'can not compare different lengths';
      }
    } else {
      throw 'can not compare different type';
    }
  }

  bool operator >(a) {
    if (a is Distance) {
      return a != this && this >= a;
    } else {
      throw 'can not compare different type';
    }
  }

  bool operator <=(a) {
    if (a is Distance) {
      return a > this;
    } else {
      throw 'can not compare different type';
    }
  }

  bool operator <(a) {
    if (a is Distance) {
      return a != this && this <= a;
    } else {
      throw 'can not compare different types';
    }
  }

  int operator [](int index) => _buffer[index];
}
