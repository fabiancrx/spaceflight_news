class SpaceFlightErrorResponse {

  final int code;
  final String message;

  SpaceFlightErrorResponse({
    required this.code,
    required this.message,
  });

  factory SpaceFlightErrorResponse.fromJson(Map<String, dynamic> json) =>
      SpaceFlightErrorResponse(
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
      };
}
