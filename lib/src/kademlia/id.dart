import 'dart:math';

import 'package:dtorrent_common/dtorrent_common.dart';

import 'distance.dart';

// ignore: constant_identifier_names
const BASE_NUM = 128;

/// A ID with any length bytes array
class ID {
  late List<int> _buffer;
  List<int> get buffer => _buffer;

  @Deprecated('Use buffer instead')
  List<int> get ids => _buffer;

  String? _str;

  String? _hexStr;

  /// [byteLength] is the bytes size , default is 20 byte (160 bit)
  ID([int byteLength = 20]) {
    _buffer = List.filled(byteLength, 0);
  }

  // length of the ID
  int get length => _buffer.length;

  @Deprecated('use length instead')
  int get byteLength => _buffer.length;

  // set multiple bytes in the backing buffer
  void setValue(List<int> values, [int offset = 0]) {
    if (_buffer.length > (values.length - offset)) {
      throw 'values length does not match the ID length';
    }
    for (var i = 0; i < _buffer.length; i++) {
      _buffer[i] = values[i + offset];
    }
    _str = null;
    _hexStr = null;
  }

  // get a specific byte
  @Deprecated('use [] operator instead')
  int getValueAt(int index) {
    if (index < 0 || index > _buffer.length - 1) throw 'Index out of range';
    return _buffer[index];
  }

  // set single byte
  @Deprecated('use [] operator instead')
  void setValueAt(int index, int value) {
    if (index < 0 || index > _buffer.length - 1) throw 'Index out of range';
    if (_buffer[index] != value) {
      _buffer[index] = value;
      _str = null;
      _hexStr = null;
    }
  }

  /// XOR another ID to get a `Distance` instance.
  @Deprecated('use distanceTo instead')
  Distance distanceBetween(ID id) => distanceTo(id);

  /// XOR another ID to get a `Distance` instance.
  Distance distanceTo(ID id) {
    if (id.length != length) {
      throw 'provided ID length doesn\'t equal this ID length';
    }

    var ids = List.filled(_buffer.length, 0);
    for (var i = 0; i < _buffer.length; i++) {
      ids[i] = id[i] ^ _buffer[i];
    }
    return Distance(ids);
  }

  // the amount of different bits between the two IDs
  int differenceLength(ID targetID) {
    if (targetID.length != length) {
      throw 'provided ID length doesn\'t equal this ID length';
    }
    var lrp = _buffer.length * 8;
    var base = BASE_NUM;
    for (var i = 0; i < _buffer.length; i++) {
      var xor = _buffer[i] ^ targetID[i];
      if (xor != 0) {
        // bytes are different
        var offset = 0;
        var r = xor & base;
        while (r == 0) {
          // calculate the bit
          offset++;
          base = base >> 1;
          r = xor & base;
        }
        lrp -= offset;
        break;
      } else {
        lrp -= 8;
      }
    }
    return lrp;
  }

  factory ID.fromBuffer(List<int> buffer, [int offset = 0, int? length]) {
    var id = ID(length ?? buffer.length);
    id.setValue(buffer, offset);
    return id;
  }

  factory ID.random([int byteLength = 20]) {
    var id = ID(byteLength);
    var r = Random();
    for (var i = 0; i < byteLength; i++) {
      id[i] = r.nextInt(256);
    }
    return id;
  }

  // returns id as hex string
  String toHexString() {
    _hexStr ??= buffer.toHexString();
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
    if (other is ID) {
      if (other.length == length) {
        var l = differenceLength(other);
        return l == 0;
      }
    }
    return false;
  }

  int operator [](int index) => _buffer[index];

  operator []=(int index, int value) {
    _buffer[index] = value;
    _str = null;
    _hexStr = null;
  }
}
