class User {
  final String sessionId;
  final bool isOnboarded;
  final bool isSubscribed;
  final bool isEmailVerified;
  final String redirectUrl;  // If you want to capture and use redirectUrl
  final String firstName;

  User({
    required this.sessionId,
    required this.isOnboarded,
    required this.isSubscribed,
    required this.isEmailVerified,
    this.redirectUrl = '',  // optional, you may decide to use it
    this.firstName = ''
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      sessionId: json['sessionId'],
      isOnboarded: json['isOnboarded'],
      isSubscribed: json['isSubscribed'],
      isEmailVerified: json['isEmailVerified'],
      redirectUrl: json['redirectUrl'] ?? '',
      firstName : json['firstName'] ?? ''
    );
  }
}