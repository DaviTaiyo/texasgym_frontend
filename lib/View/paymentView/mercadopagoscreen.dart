import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as custom_tabs;
import 'package:url_launcher/url_launcher.dart';

class MercadoPagoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagamento Mercado Pago'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _launchURL(context);
          },
          child: Text('Abrir Mercado Pago'),
        ),
      ),
    );
  }

  Future<void> _launchURL(BuildContext context) async {
    const url = 'https://www.mercadopago.com.br'; // Substitua pela URL correta

    if (await canLaunch(url)) {
      try {
        // Tenta abrir no Google Chrome (Android) ou Safari (iOS)
        await custom_tabs.launch(
          url,
          customTabsOption: custom_tabs.CustomTabsOption(
            toolbarColor: Theme.of(context).primaryColor,
            enableDefaultShare: true,
            enableUrlBarHiding: true,
            showPageTitle: true,
          ),
        );
      } catch (e) {
        // Caso falhe, abra no navegador padrão
        await launch(url);
      }
    } else {
      throw 'Could not launch $url';
    }
  }
}
