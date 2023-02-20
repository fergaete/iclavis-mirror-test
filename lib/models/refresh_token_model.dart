import 'dart:convert';

RefreshToken refreshTokenFromMap(String str) => RefreshToken.fromMap(json.decode(str));

String refreshTokenToMap(RefreshToken data) => json.encode(data.toMap());

class RefreshToken {
  RefreshToken({
    required this.challengeParameters,
    required this.authenticationResult,
  });

  ChallengeParameters challengeParameters;
  AuthenticationResult authenticationResult;

  factory RefreshToken.fromMap(Map<String, dynamic> json) => RefreshToken(
    challengeParameters: ChallengeParameters.fromMap(json["ChallengeParameters"]),
    authenticationResult: AuthenticationResult.fromMap(json["AuthenticationResult"]),
  );

  Map<String, dynamic> toMap() => {
    "ChallengeParameters": challengeParameters.toMap(),
    "AuthenticationResult": authenticationResult.toMap(),
  };
}

class AuthenticationResult {
  AuthenticationResult({
    required this.accessToken,
    required this.expiresIn,
    required this.tokenType,
    required this.idToken,
  });

  String accessToken;
  int expiresIn;
  String tokenType;
  String idToken;

  factory AuthenticationResult.fromMap(Map<String, dynamic> json) => AuthenticationResult(
    accessToken: json["AccessToken"],
    expiresIn: json["ExpiresIn"],
    tokenType: json["TokenType"],
    idToken: json["IdToken"],
  );

  Map<String, dynamic> toMap() => {
    "AccessToken": accessToken,
    "ExpiresIn": expiresIn,
    "TokenType": tokenType,
    "IdToken": idToken,
  };
}

class ChallengeParameters {
  ChallengeParameters();

  factory ChallengeParameters.fromMap(Map<String, dynamic> json) => ChallengeParameters(
  );

  Map<String, dynamic> toMap() => {
  };
}
