import 'dart:io';

/// Allows connection to the [BadSSLOverrides.allowedHosts] even when
/// certificate is bad.
bool badSSLCallback(X509Certificate cert, String host, int port) {
  // Go through each allowedHost and check if to-be-connected host
  // matches it
  for (final String hostFromList in BadSSLOverrides.allowedHosts) {
    if (host.contains(hostFromList)) return true;
  }

  // Do not allow connection if to-be-connected host is not pre-defined
  return false;
}

class BadSSLOverrides extends HttpOverrides {
  // List of allowed hosts for bad ssl rule overriding
  static const List<String> allowedHosts = [
    'googleapis.com',
    'google.com',
    'youtu.be',
    'youtube.com',
  ];

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = badSSLCallback;
  }
}