// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env.dart';

// **************************************************************************
// FlutterSecureDotEnvAnnotationGenerator
// **************************************************************************

class _$Env extends Env {
  const _$Env(this._encryptionKey, this._iv) : super._();

  final String _encryptionKey;
  final String _iv;
  static final Uint8List _encryptedValues = Uint8List.fromList([
    16,
    214,
    9,
    164,
    6,
    90,
    18,
    204,
    244,
    13,
    0,
    144,
    16,
    91,
    104,
    7,
    40,
    55,
    170,
    154,
    34,
    100,
    221,
    81,
    248,
    122,
    38,
    2,
    254,
    66,
    194,
    212,
    122,
    129,
    219,
    252,
    12,
    97,
    110,
    52,
    40,
    128,
    24,
    116,
    133,
    132,
    95,
    160,
    225,
    184,
    202,
    71,
    209,
    175,
    109,
    152,
    144,
    155,
    74,
    62,
    72,
    175,
    250,
    134,
    42,
    55,
    226,
    203,
    229,
    126,
    53,
    50,
    101,
    175,
    88,
    222,
    93,
    9,
    124,
    68,
    12,
    151,
    153,
    213,
    27,
    127,
    73,
    144,
    160,
    158,
    153,
    119,
    243,
    231,
    209,
    139
  ]);
  @override
  String get envKeyOne => _get('ENV_KEY_ONE');

  @override
  String get envKeyTwo => _get('ENV_KEY_TWO');

  T _get<T>(
    String key, {
    T Function(String)? fromString,
  }) {
    T parseValue(String strValue) {
      if (T == String) {
        return (strValue) as T;
      } else if (T == int) {
        return int.parse(strValue) as T;
      } else if (T == double) {
        return double.parse(strValue) as T;
      } else if (T == bool) {
        return (strValue.toLowerCase() == 'true') as T;
      } else if (T == Enum || fromString != null) {
        if (fromString == null) {
          throw Exception('fromString is required for Enum');
        }

        return fromString(strValue.split('.').last);
      }

      throw Exception('Type ${T.toString()} not supported');
    }

    final encryptionKey = base64.decode(_encryptionKey.trim());
    final iv = base64.decode(_iv.trim());
    final decrypted =
        AESCBCEncrypter.aesCbcDecrypt(encryptionKey, iv, _encryptedValues);
    final jsonMap = json.decode(decrypted) as Map<String, dynamic>;
    if (!jsonMap.containsKey(key)) {
      throw Exception('Key $key not found in .env file');
    }

    final encryptedValue = jsonMap[key] as String;
    final decryptedValue = AESCBCEncrypter.aesCbcDecrypt(
      encryptionKey,
      iv,
      base64.decode(encryptedValue),
    );
    return parseValue(decryptedValue);
  }
}
