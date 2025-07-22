// for the request of signup


/*
{
"fullName": "John Doe",
"email": "john@example.com",
"password": "123456"
}



Response (HERE RESPONSE IS HANDLED IN AUTH SERVICE [services/auth/authentication.dart],
we just need the message which is shown using Toast [utils/toast.dart]):

usecase: 

showToast(context, signupResult['message']);

{
"success": true,
"message": "Registration successful. Please check your email to verify your 
account.",
"userId": 101
}
*/ 

class SignupDTO {
  final String fullName;
  final String email;
  final String password;

  SignupDTO({
    required this.fullName,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'email': email,
        'password': password,
      };
}