import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AppleSignIn {
  static const String _authorizationEndpoint =
      'https://appleid.apple.com/auth/authorize';
  static const String _tokenEndpoint = 'https://appleid.apple.com/auth/tokens';

  final String clientId;

  AppleSignIn(this.clientId);

  signIn() async {
    // Start the authorization process.
    final authorizationUrl =
        Uri.parse('$_authorizationEndpoint?client_id=$clientId');
    final authorizationResponse = await http.get(authorizationUrl);
    print('error ${authorizationResponse.request?.url}');
    var url = authorizationResponse.request?.url != null
        ? authorizationResponse.request?.url.toString()
        : authorizationResponse.request?.url.toString();
    // Extract the authorization code from the response.
    final authorizationCode = Uri.parse("$url").queryParameters['code'];

    // Exchange the authorization code for an access token.
    final tokenUrl = Uri.parse(
        '$_tokenEndpoint?client_id=$clientId&code=$authorizationCode');
    final tokenResponse = await http.post(tokenUrl);
    print("toke response ${tokenResponse.body}");

    // Extract the access token from the response.
    final token = jsonDecode(tokenResponse.body)['access_token'];

    return token;
  }
}
