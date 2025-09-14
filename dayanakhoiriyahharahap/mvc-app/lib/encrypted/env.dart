import 'package:flutter_secure_dotenv/flutter_secure_dotenv.dart';

part 'env.g.dart';

@DotEnvGen(
  filename: '.env',
  fieldRename: FieldRename.screamingSnake,
)
abstract class Env {
  static Env create() {
  return const Env();
}


  const factory Env() = _$Env; // You can call const env = Env('encryption-key', 'iv') from another Dart file using this

  const Env._();

  // Declare your environment variables as abstract getters
  @FieldKey(defaultValue: "")
  String get firebaseAndroidApiKey;

  @FieldKey(defaultValue: "")
  String get firebaseAndroidAppId;

  @FieldKey(defaultValue: "")
  String get firebaseAndroidMessagingSenderId;

  @FieldKey(defaultValue: "")
  String get firebaseAndroidProjectId;

  @FieldKey(defaultValue: "")
  String get firebaseAndroidStorageBucket;
}