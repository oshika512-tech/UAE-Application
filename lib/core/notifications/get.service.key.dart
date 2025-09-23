import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:googleapis_auth/auth_io.dart';

class GetServiceKey {
  Future<String> getServiceKey() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson(
        {
          "type": "service_account",
          "project_id": "meditation-center-44aad",
          "private_key_id": dotenv.env['PRIVATE_KEY_ID'],
          "private_key": dotenv.env['PRIVATE_KEY']?.replaceAll(r'\n', '\n'),
          "client_email": dotenv.env['CLIENT_EMAIL'],
          "client_id": dotenv.env['CLIENT_ID'],
          "auth_uri": dotenv.env['AUTH_URI'],
          "token_uri": dotenv.env['TOKEN_URI'],
          "auth_provider_x509_cert_url":
              dotenv.env['AUTH_PROVIDER_X509_CERT_URL'],
          "client_x509_cert_url": dotenv.env['CLIENT_X509_CERT_URL'],
          "universe_domain": "googleapis.com"
        },
      ),
      scopes,
    );
    final accessServiceKey = client.credentials.accessToken.data;
    print("Service key is : $accessServiceKey");
    return accessServiceKey;
  }
}
