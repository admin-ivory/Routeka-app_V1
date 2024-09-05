import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void openCinetPay(BuildContext context, Map<String, dynamic> paymentData, Map<String, dynamic> configData) {
  String paymentUrl = generateCinetPayUrl(configData, paymentData);

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("CinetPay Checkout"),
        ),
        body: WebView(
          initialUrl: paymentUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onPageFinished: (url) {
            if (url.contains('success')) {
              // Traitement de la transaction réussie
              Navigator.pop(context, "Transaction Successful");
            } else if (url.contains('error')) {
              // Traitement de la transaction échouée
              Navigator.pop(context, "Transaction Failed");
            }
          },
          onWebResourceError: (error) {
            // Gestion des erreurs de chargement de la WebView
            Navigator.pop(context, "Error loading page: ${error.description}");
          },
        ),
      ),
    ),
  );
}

String generateCinetPayUrl(Map<String, dynamic> configData, Map<String, dynamic> paymentData) {
  // Générer l'URL de CinetPay avec les paramètres nécessaires
  return "https://payment.cinetpay.com/init?"
      "apikey=${configData['apikey']}&"
      "site_id=${configData['site_id']}&"
      "transaction_id=${paymentData['transaction_id']}&"
      "amount=${paymentData['amount']}&"
      "currency=${paymentData['currency']}&"
      "description=${paymentData['description']}&"
      "channels=${paymentData['channels']}&"
      "notify_url=${configData['notify_url']}";
}
