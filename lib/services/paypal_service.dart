import 'package:http/http.dart' as http;
import 'package:http_auth/http_auth.dart';
import 'dart:convert' as convert;

class PaypalServices {
  String domain = "https://api.sandbox.paypal.com"; // for sandbox mode
  //  String domain = "https://api.paypal.com"; // for production mode

  String cliendID = "AZ7Vi6VLWBDKoyb--GDWIYrZ7GJmm_zFlZAKK4-XmfFKzTq_p2vGsM2C76g5hcPgppKiG2yr8vc_1ckh";
  String secretKey = "ECLmJxUrNjlrQqcY-CF8uz9Nny_S6cLe3TCLxxYj07aj143lgdkrSFWNYg1Js2XdNbXjvLHsBTs62AU4";

  /////////////////////////////GET ACCESS TOKEN////////////////////////////////
  Future<String> getAccessToken() async {
    try {
      var client = BasicAuthClient(cliendID, secretKey);
      var response = await client.post(Uri.parse('$domain/v1/oauth2/token?grant_type=client_credentials'));
      if (response.statusCode == 200) {
        final body = convert.jsonDecode(response.body);
        return body["access_token"];
      }
      return "0";
    } catch (e) {
      rethrow;
    }
  }

  ////////////////////CREATE PAYMENT///////////////////////////////////
  Future<Map<String, String>> createPayment(transactions, accessToken) async {
    try {
      var response = await http.post(Uri.parse("$domain/v1/payments/payment"),
          body: convert.jsonEncode(transactions), headers: {"content-type": "application/json", 'Authorization': 'Bearer ' + accessToken});

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 201) {
        if (body["links"] != null && body["links"].length > 0) {
          List links = body["links"];

          String executeUrl = "";
          String approvalUrl = "";
          final item = links.firstWhere((o) => o["rel"] == "approval_url", orElse: () => null);
          if (item != null) {
            approvalUrl = item["href"];
          }
          final item1 = links.firstWhere((o) => o["rel"] == "execute", orElse: () => null);
          if (item1 != null) {
            executeUrl = item1["href"];
          }
          return {"executeUrl": executeUrl, "approvalUrl": approvalUrl};
        }
        throw Exception("0");
      } else {
        throw Exception(body["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  ////////////////////EXECUTE PAYMENT////////////////////////////////////
  Future<String> executePayment(url, payerID, accessToken) async {
    try {
      var response = await http.post(Uri.parse(url),
          body: convert.jsonEncode({"payer_id": payerID}), headers: {"content-type": "application/json", 'Authorization': 'Bearer ' + accessToken});

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        return body["id"];
      }
      return "0";
    } catch (e) {
      rethrow;
    }
  }
}
