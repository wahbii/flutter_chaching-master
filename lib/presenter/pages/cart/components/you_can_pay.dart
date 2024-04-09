import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

import '../../../widgets/modal.dart';
// import 'package:webview_flutter/webview_flutter.dart';

class YouCanPay {


  final Function() onSuccess ;
  final Function(String error) onFailure ;

  YouCanPay({required this.onSuccess ,required this.onFailure});
  final Uri _tokenUrlSB = Uri(
      scheme: 'https', host: 'youcanpay.com', path: '/sandbox/api/tokenize');
  final Uri _paymentUrlSB =
      Uri(scheme: 'https', host: 'youcanpay.com', path: '/sandbox/api/pay');
  final Uri _tokenUrl =
      Uri(scheme: 'https', host: 'youcanpay.com', path: '/api/tokenize');
  final Uri _paymentUrl =
      Uri(scheme: 'https', host: 'youcanpay.com', path: '/api/pay');
  bool _isDone = false;

//IN PRODUCTION MODE
  static const String _publicKey = "pub_f440c85f-2067-45c1-b27a-838c8bf5";
  static const String _secretKey = "pri_f58fb394-7317-4842-be03-b58980e9";

//IN DEV MODE
  static const String _publicKeySB =
      "pub_sandbox_8ef33b22-d540-40d5-8f2f-90e3a";
  static const String _secretKeySB = "pri_f58fb394-7317-4842-be03-b58980e9";

  static const Map<String, String> _header = {
    'Content-Type': 'Application/json'
  };

  //isSandBox TOKEN in SANDBOX
  //First Get Token
  Future<String> _getToken(int amount, String subScID, UserModel? customer,
      CompanyModel? comp, BuildContext context,
      {bool isSandBox = true}) async {
    Map<String, dynamic> body = {
      'pri_key': isSandBox ? _secretKeySB : _secretKey,
      'order_id': subScID,
      'amount': "$amount",
      'currency': "MAD",
      "customer": {
        "id": customer?.uid,
        "city": comp?.ville,
        "name": customer?.name,
        "email": customer?.email,
        "phone": (customer?.phone ?? ''),
        "state": 'ice: ${comp?.ice ?? ''}',
        "address": '${comp?.address} CompId-Tk:${comp?.id ?? ''}',
      },
    };
    http.Response response = await http.post(
        isSandBox ? _tokenUrlSB : _tokenUrl,
        headers: _header,
        body: jsonEncode(body));
    switch (response.statusCode) {
      case 200:
        var data = jsonDecode(response.body);
        return data["token"]["id"];
      default:
        if (kDebugMode) {
          print("response.statusCode");
          print(response.statusCode);
          print(response.body);
        }

        Navigator.of(context).pop();
        showWebViewDialog(
            'https://spiffy-dragon-c84c64.netlify.app/', context,(){

        }); //Error MSG
        throw Exception('Initiation invalid');
    }
  }

  //isSandBox PAY in SANDBOX
  //Make Paiment
  Future<dynamic> makePayment(
      CardModel card,
     int amount,
      UserModel? customer,
     // CompanyModel? comp,
      BuildContext context,
      {bool isSandBox = true}) async {

    var comp = CompanyModel(
      id: "sqdsdsd",
      ice: "provence rabat",
      address: "rabat",
      ville: "rabat"

    );


    showWatingDialog(context);
    if (kDebugMode) {
      print('amount');
      print(amount);
    }

    String token = await _getToken(amount , "0", customer, comp, context,
        isSandBox: isSandBox);
    if (kDebugMode) {
      print("===============token================");
      print(token);
    }

    if (comp != null) {
      Map<String, dynamic> body = {
        'pub_key': isSandBox ? _publicKeySB : _publicKey,
        'token_id': token,
        'credit_card': card.creditCardNumber,
        'card_holder_name': card.cardHolderName,
        'cvv': card.cvv,
        'expire_date': card.expireDate,
        'payment_method': {
          "type": "credit_card",
        },
        "customer": {
          "id": customer?.uid,
          "city": comp.ville,
          "name": customer?.name,
          "email": customer?.email,
          "phone": (customer?.phone ?? ''),
          "state": 'ice: ${comp.ice}',
          "address": '${comp.address} CompId:${comp.id ?? ''}',
        },
      };
      http.Response response = await http.post(
          isSandBox ? _paymentUrlSB : _paymentUrl,
          headers: _header,
          body: jsonEncode(body));
      Navigator.of(context).pop(); // pop showWatingDialog
      switch (response.statusCode) {
        case 200:
          var data = jsonDecode(response.body);
          print("response : ${data}");
          //Add Success Message
          showWebViewDialog(data?["redirect_url"], context,onSuccess);

          return data;
        default:
          if (kDebugMode) {
            print(response.statusCode);
            print(response.body);
          }

          //ADD Error MSG
          onFailure.call(response.body);
          throw Exception('Initiation invalid');
      }
    } else {
      onFailure.call('Company Data is null');

      throw Exception('Company Data is null');
    }
  }

  Future<dynamic> showWatingDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => const AlertDialog(
              title: Text('progress ...'),
              content: Row(
                children: const [
                  Spacer(),
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(),
                  ),
                  Spacer(),
                ],
              ),
            ));
  }

  void showWebViewDialog(String url, BuildContext context,Function action) {
    late WebViewController _controller;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(20)
              .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: WebView(
                  initialUrl: url,
                  javascriptMode: JavascriptMode.unrestricted,
                  onPageFinished: (String url) {
                    print(url);
                    if (url.contains("https://www.chaching.com/success")) {
                      print(url);
                      Navigator.of(context).pop();
                      onSuccess.call();
                      // Perform the action here after successful page load
                    }
                  },
                ),
              ),
              // Add any additional widgets below the WebView if needed
            ],
          ),
        );
      },
    );



  }
}

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String state;
  final String address;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.state,
    required this.address,
  });
}

class CompanyModel {
  final String? id;
  final String? ville;
  final String? ice;
  final String? address;

  CompanyModel({
    this.id,
    this.ville,
    this.ice,
    this.address,
  });
}

class CardModel {
  final String creditCardNumber;
  final String cardHolderName;
  final String cvv;
  final String expireDate;

  CardModel({
    required this.creditCardNumber,
    required this.cardHolderName,
    required this.cvv,
    required this.expireDate,
  });
}
