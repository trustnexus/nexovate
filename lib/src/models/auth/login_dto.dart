// for the request of login

/* 

[POST] /auth/login

{
"email": "john@example.com",
"password": "123456"
}


On Success:
{
"token": "jwt_token_here",
"user": { "UserID": 101, "email": "john@example.com" }
}


If Email Not Verified:
{
"code": "EMAIL_NOT_VERIFIED",
"message": "Please verify your email before logging in.",
"resendToken": "abcdef123456"
}




*/

class LoginDto {
  final String email;
  final String password;

  LoginDto({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };

  factory LoginDto.fromJson(Map<String, dynamic> json) {
    return LoginDto(
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }
}

// for the response: see - providers/user.dart (UserResponse Class)