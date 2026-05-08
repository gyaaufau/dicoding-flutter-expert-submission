import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

typedef HttpClientFactory = HttpClient Function(SecurityContext context);

class SslPinningHttpClient {
  static const certificateAssetPath = 'assets/certificates.pem';

  static Future<http.Client> create({
    AssetBundle? bundle,
    HttpClientFactory? httpClientFactory,
  }) async {
    final certData = await (bundle ?? rootBundle).load(certificateAssetPath);
    final securityContext = SecurityContext(withTrustedRoots: false)
      ..setTrustedCertificatesBytes(certData.buffer.asUint8List());

    final httpClient =
        (httpClientFactory ?? ((context) => HttpClient(context: context)))(
          securityContext,
        );

    httpClient.badCertificateCallback = rejectBadCertificate;

    return IOClient(httpClient);
  }

  static bool rejectBadCertificate(
    X509Certificate cert,
    String host,
    int port,
  ) => false;
}
