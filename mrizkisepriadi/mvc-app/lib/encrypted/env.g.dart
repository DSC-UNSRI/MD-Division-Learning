// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env.dart';

// **************************************************************************
// FlutterSecureDotEnvAnnotationGenerator
// **************************************************************************

class _$Env extends Env {
  const _$Env() : super._();

  static const String _encryptedValues =
      'eyJGSVJFQkFTRV9BTkRST0lEX0FQSV9LRVkiOiJRVWw2WVZONVJHbERVbVV3VFV0RUxUZ3hhWGxsZFdjMU0zRm9SQzFaVjFabVRsVmpXR3BWIiwiRklSRUJBU0VfQU5EUk9JRF9BUFBfSUQiOiJNVG95TVRZMk1EVTFPRFk1TURwaGJtUnliMmxrT2poaFpXVmhNV0k0TkRObE5HWTJOR0kyTVRjNE0yST0iLCJGSVJFQkFTRV9BTkRST0lEX01FU1NBR0lOR19TRU5ERVJfSUQiOiJNakUyTmpBMU5UZzJPVEE9IiwiRklSRUJBU0VfQU5EUk9JRF9QUk9KRUNUX0lEIjoiZEdWemRHbHVaeTFpT0RNd013PT0iLCJGSVJFQkFTRV9BTkRST0lEX1NUT1JBR0VfQlVDS0VUIjoiZEdWemRHbHVaeTFpT0RNd015NW1hWEpsWW1GelpYTjBiM0poWjJVdVlYQncifQ==';
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

    final bytes = base64.decode(_encryptedValues);
    final stringDecoded = String.fromCharCodes(bytes);
    final jsonMap = json.decode(stringDecoded) as Map<String, dynamic>;
    if (!jsonMap.containsKey(key)) {
      throw Exception('Key $key not found in .env file');
    }
    final encryptedValue = jsonMap[key] as String;
    final decryptedValue = base64.decode(encryptedValue);
    final stringValue = String.fromCharCodes(decryptedValue);
    return parseValue(stringValue);
  }
}
