import 'package:http/http.dart';

makePostRequestContT(mail) async {
  // set up POST request arguments
  String url = 'https://signonservice-difbz2ztya-uc.a.run.app/recoverypassword';
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = '{"email": "$mail"}';
  // make POST request
  Response response = await post(url, headers: headers, body: json);
  // check the status code for the result
  int statusCode = response.statusCode;
  return statusCode;
}