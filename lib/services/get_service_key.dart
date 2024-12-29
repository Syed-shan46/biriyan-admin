
import 'package:googleapis_auth/auth_io.dart';

class GetServerKey {
  Future<String> getServerKeyToken() async {
   // await dotenv.load();

    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "biriyani-59ef6",
          "private_key_id": "d4cfa564d76ea291fa51f93d33e23a14be646ae2",
          "private_key":
              "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDV/BCY08yCI5sR\nAlP/Si51zlV5OhMRJxMMhJu/7syzzKwR2xUM+Z2VnOeV2Hn214OZAX9w932TomDF\n9pTj1Uhh+VhaImlJiens/XUukFWVhko1FPYnZn2G7H2bWu1I5cuKThDnz7JTbr69\npAKKByN9SiSIH+1W6jIQQKGB7M6k7iDlKfzYKSsLs3qqOFZ5ZFGLcoL9HI24INwI\nv83DMvF6GTjJuRwi+cmCProZmGLRw+5OtrERs+4DZ/5lrdfNlTcmI+8Me3Zc4kzx\nMR7NKgu7ttZHtSdleR23enAIioXqG0t1ajEJMz98qJGx6wzQupp1fWlKkO6k/D8A\nWUoNE+Q7AgMBAAECggEAFwQCoP1+7Kx5vE2czUOkVaV4yg42CM1EHj+RJQbBW8Fy\n7IS88eVTTslOm25qR+OMUwO3OmZUSnHXqNNJ1muVWnxgRWmYG4HK+GOWnAiIPAny\np1z20OwUKlP7ep9AEGwvBVQ6O0S6sICj4W/nmgMEjTBRV5bfh06vTdI1zOy0mUaV\nQKOoR7+fNv+yvnvP97758+hxQ0+hHAjf57Ig7JFdqYgiKp2jZqQOL+XiHD77HRB6\nZHPMAq/K5uE9g+2DrgkmgrQGfR+tdjrszTTcXn0yy7oQ7B1C6YMa1PLj4cUiydV6\nQ2ey70vBl3TU8gEIMa5vMzOxDyfSrmW+V7EYr4Rj4QKBgQDyCzXCKOEKMn3lkzu9\nnA/vA6KMJAaztXSRNr790dRZvfc3Usr6KiuCYWHiPtj4exPN9iusWrbnh+B6joDT\neoHEUkt3fIR5VRi15bju5qKV3gmCpHSRRikxmqihqasWjuiJ6KrN72dQAuxNIL6y\nVmgDei775PVwpHz4lrQKn/+csQKBgQDiUqz6UNxNyWDPJ4bzBRlYE0rbAGu5/als\n5saAKjtSAnNLal8dbA9dUeNqkkFYZXKWoi/9nYmD5dMc8qFtg/cQoZAnCqyyzShN\n3GDZvk4thlbU9OxLEBg8TIzrJWsXNyl0j8Nn7l9Z4JIELsEjSTw5AYVBv8mMYCQq\nJF9lZEBaqwKBgHvVlGmD9K786kCctYHq6JQGrhE5FVy4R61L7yd5RUWs1WCusT6Q\neLY6EJRqRyPKBHXprqp9tvp6IDVT10FbeizxVb8KK9TP3tahc552zVQTx5XZgfIZ\njVXdpM0hO3FNKFf2e/zksVzUQgWr7STc5FZzGrqxh4lb/rxIjlCpT2PhAoGAWsPD\nYYQKRhvr+kgk49N4rYzXKWtKyMWFLAqFMyM8tRAMgwM+8ALFSqyrorLTCAtvYB/d\nVT3Xx5DlEKfxu4UAEahpsm6igfarIkauhMTAf5tvuWocVaI3xf8BSNCx2RajRn7d\nZBICJX5dsNW7WVZmk4obkhnDT8vC1S/PHk+NS48CgYEA8LaCXQaMH/HvVHmT1xMm\nBTWHLatyD7FJO3+UOsfgwj0JcLIaYKpxnv8nwEJQ1pZnxvuxX0F/36IBvSxz/yFr\n29vKAfVKXAxoeEsWFADxkcxCwSNEHCQjdaUzsYWkC3NiOq6u2dz7uAZZJCChbeLy\nWDBzsVB8zsMJ2nYPWhDbR8E=\n-----END PRIVATE KEY-----\n",
          "client_email":
              "firebase-adminsdk-mbvf2@biriyani-59ef6.iam.gserviceaccount.com",
          "client_id": "108025955690871245320",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url":
              "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url":
              "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-mbvf2%40biriyani-59ef6.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }),
        scopes);
    final accessServerKey = client.credentials.accessToken.data;
    return accessServerKey;
  }
}
