import 'dart:convert';
import 'dart:typed_data';

import '../model/state.dart';

Uint8List encode(Map<String, dynamic> json) =>
    Uint8List.fromList(jsonEncode(json).codeUnits);

Map<String, dynamic> decode(Uint8List data) =>
    jsonDecode(String.fromCharCodes(data));

Uint8List encodeState(State state) => encode(state.toJson());

State decodeState(Uint8List data) => State.fromJson(decode(data));
