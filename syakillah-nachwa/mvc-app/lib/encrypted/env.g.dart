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
    19,
    242,
    42,
    109,
    43,
    25,
    193,
    202,
    155,
    170,
    216,
    161,
    141,
    203,
    122,
    98,
    83,
    129,
    112,
    48,
    17,
    130,
    98,
    184,
    224,
    229,
    89,
    237,
    213,
    51,
    240,
    21,
    119,
    206,
    164,
    86,
    115,
    130,
    135,
    170,
    223,
    129,
    254,
    27,
    197,
    252,
    91,
    202,
    200,
    115,
    233,
    239,
    66,
    2,
    231,
    199,
    139,
    149,
    200,
    102,
    55,
    198,
    197,
    74,
    135,
    112,
    163,
    160,
    118,
    156,
    196,
    57,
    158,
    7,
    139,
    239,
    17,
    161,
    46,
    91,
    18,
    211,
    24,
    220,
    117,
    249,
    117,
    135,
    211,
    254,
    83,
    38,
    187,
    181,
    173,
    202,
    59,
    176,
    6,
    100,
    42,
    211,
    122,
    234,
    73,
    255,
    215,
    173,
    82,
    163,
    5,
    5,
    185,
    59,
    5,
    191,
    18,
    133,
    57,
    11,
    2,
    220,
    19,
    77,
    112,
    90,
    211,
    177,
    92,
    8,
    69,
    224,
    143,
    235,
    100,
    230,
    128,
    157,
    117,
    190,
    14,
    175,
    24,
    99,
    19,
    170,
    60,
    75,
    54,
    14,
    29,
    9,
    58,
    100,
    179,
    118,
    218,
    181,
    164,
    166,
    61,
    2,
    44,
    134,
    21,
    160,
    203,
    214,
    233,
    87,
    53,
    57,
    59,
    28,
    163,
    71,
    138,
    27,
    183,
    154,
    58,
    112,
    232,
    161,
    45,
    202,
    202,
    96,
    236,
    180,
    245,
    189,
    121,
    193,
    144,
    146,
    30,
    156,
    112,
    169,
    131,
    255,
    40,
    1,
    89,
    155,
    235,
    182,
    161,
    105,
    71,
    55,
    108,
    168,
    101,
    68,
    199,
    112,
    123,
    133,
    6,
    28,
    108,
    115,
    229,
    249,
    87,
    150,
    72,
    50,
    246,
    189,
    182,
    24,
    25,
    39,
    205,
    5,
    238,
    115,
    216,
    179,
    166,
    44,
    22,
    145,
    65,
    62,
    205,
    145,
    55,
    83,
    242,
    166,
    123,
    74,
    219,
    234,
    17,
    149,
    232,
    228,
    113,
    76,
    129,
    17,
    16,
    153,
    11,
    34,
    236,
    43,
    0,
    243,
    45,
    126,
    183,
    234,
    96,
    207,
    234,
    96,
    192,
    34,
    217,
    70,
    166,
    199,
    225,
    84,
    36,
    208,
    71,
    88,
    255,
    188,
    247,
    46,
    188,
    61,
    183,
    252,
    223,
    239,
    49,
    108,
    121,
    145,
    77,
    132,
    56,
    186,
    91,
    160,
    4,
    215,
    12,
    209,
    165,
    204,
    189,
    33,
    104,
    36,
    135,
    47,
    138,
    71,
    140,
    105,
    36,
    28,
    88,
    145,
    89,
    148,
    243,
    204,
    153,
    244,
    94,
    12,
    246,
    48,
    136,
    250,
    24,
    176,
    84,
    45,
    237,
    75,
    95,
    186,
    102,
    223,
    108,
    204,
    123,
    106,
    235,
    184,
    121,
    48,
    62,
    225,
    238,
    108,
    36,
    121,
    1,
    163,
    114,
    194,
    224,
    137,
    52,
    5,
    78,
    37,
    47,
    248,
    3,
    212,
    8,
    57,
    168,
    234,
    46,
    166,
    94,
    105,
    96,
    246,
    53,
    106,
    218,
    90,
    47,
    228,
    10,
    167,
    42,
    153,
    120,
    213,
    92,
    22,
    214,
    51,
    64,
    5,
    145,
    243,
    60,
    5
  ]);
  @override
  String get firebaseAndroidApiKey => _get('FIREBASE_ANDROID_API_KEY');

  @override
  String get firebaseAndroidAppId => _get('FIREBASE_ANDROID_APP_ID');

  @override
  String get firebaseAndroidMessagingSenderId =>
      _get('FIREBASE_ANDROID_MESSAGING_SENDER_ID');

  @override
  String get firebaseAndroidProjectId => _get('FIREBASE_ANDROID_PROJECT_ID');

  @override
  String get firebaseAndroidStorageBucket =>
      _get('FIREBASE_ANDROID_STORAGE_BUCKET');

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
