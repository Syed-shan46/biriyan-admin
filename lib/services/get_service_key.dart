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
          "private_key_id": "ee03b365c840807a26edd83be6792a39c283bce4",
          "private_key":
              "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCkLILUV9D4Udjh\nvoYGjl/OlP/kzFqHHXBxgZnhHuMdQgqC6k/Al6k3ckMT038N4fWT3eqTYiOXcOp0\n0qmbp3soE6ktomfq0w3OCxDsp0UpDcgugr0DUJRtTwFnxQA3pTrE4iRAmrqvJ0tC\nxAyuGi7W7J0MebHH/GfNWw84PivWWxotLoOubR0S4izNrsjeqoPo13oFunbT2T29\nVkJ7FcuJ5wpNlRaC2LB7G4KWWPtNo1a5ujNorCmECRKCc14GWoZzVbqGzpKkpXLm\nwMmKJm7O5EzMxl3eSDWCDjJbnidv+jh0Nzl5PE1fRaqvi0kQpfxCv+BroP4TaDYR\n9X4eDIfrAgMBAAECggEATKIoWbU6KseNzOYxypqn1xbPEf5f3YUc6SbdbOuNiSk8\nHdsA6j4A84xHCliljJXmm6SxbCWZxoWjM2/oUuuNPepbhJ00E7V70qtwtX7o9h5k\nTG2jjAoPlqyT09vt24upkKCc2nk/XiYh5+L6pkQ7jAB72Ihvt5G25HE2fALtVIuG\n5C7XHX136RnuT7YyhQok66GGpmv++07K4zQoChTHOmR6wbpdrxhXPJ/rnH0pMAyK\nRZi1uGfUXHH6PIM2O6S9j8Ljiwv0v9QB8kjENG1ZBQ3/7ihr0NC/ThOz4EfDqkkh\nM3X7xZv2T9re8NLHzIAKhxrbt7IdWMXGKZh03LOpSQKBgQDffM3zi81QeVdYTYWJ\nYgVeTEi0m7J85YeRylDBELMWFQksWT3pJz8PceYnQZGzJfys/rcbNHbKEzhS+ldw\n1kuFnF9p7+ukS4URLMDGiPQzWd6axkmG8dEZmpD406zoZluRbWEUMbJT3vhIg9p8\nMPrdxtGhQ1CVAW1choRtVxe5uQKBgQC8DrpvvRg7pJGkg/B5qnCAhdrXVvAEv6em\niPcLAo2CoUaUKjcBftjrkaC0LbZ36DReqDIvSXr6eXHMq4hep70Veu13iDEQUSlw\nLAvQvATXxBPovpz9rOyIUlxzVeCrROCtwh5MtucgntlwDEUU/4C//NRAgAlfCq6C\nmlphG5KQwwKBgFegN6AmUHodGYIl4xXauQAgKOGnqnQOCvm+uar5QT6HQPGCjCO+\nn5sOrY72xonXexrZRDIGgAz7PDpMrbwwSaw5g6+lwl7IvYPeaDdvu0/nDMDivjGK\n3tGLKQxm8oSsnXqHyGiCk8kOw4qrKB9JlRMfwVHZct75kEeW9pVocIUBAoGBALbl\n8CcalsXzIX8Kn0gFHxOwm42RzTAhIjGSxgocOnsQ1W7mu8alkt1RLiXuy6dE3CIv\nnVdmNMgEc0xmi+PbacfJXclCWM2Q0id5fyhMpL0gw2g6cr85fnZ6+9VkcXTBMW9s\n+0ELJjEQrVMPa+SnNpYClIACxpp77guxiTMmuN43AoGBAMze2EDAglVAXt/Om+o7\nDsRmFAh/sXt6kG7LVgRXMbIl3QzYCYwgCrOSz883ED8a5otFRqBPCJWnwLPQCvLO\n748hIKUvmCPlHFySyjTVS9lLF6B2HBGhpUuHP7iJ+4S28Y9Wxf8y7Jt9L3C0EoRG\nBCmrYcaNwgLGB+5j3/gHcfoo\n-----END PRIVATE KEY-----\n",
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
