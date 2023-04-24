import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String apikey = dotenv.get('API_KEY');
  static String appId = dotenv.get('APP_ID');
  static String messagingSenderId = dotenv.get('MESSAGING_SENDER_ID');
  static String projectId = dotenv.get('universal-price-list');
}