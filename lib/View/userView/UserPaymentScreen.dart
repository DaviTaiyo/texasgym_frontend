import 'package:flutter/material.dart';

class UserPaymentScreen extends StatefulWidget {
  @override
  _UserPaymentScreenState createState() => _UserPaymentScreenState();
}

class _UserPaymentScreenState extends State<UserPaymentScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Pagamentos'),
        backgroundColor: Color(0xFF007BFF),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: Icon(Icons.warning, color: Colors.black),
              child: Text(
                'Pendentes',
                style: TextStyle(color: Colors.black),
              ),
            ),
            Tab(
              icon: Icon(Icons.history, color: Colors.black),
              child: Text(
                'Histórico',
                style: TextStyle(color: Colors.black),
              ),
            ),
            Tab(
              icon: Icon(Icons.notifications, color: Colors.black),
              child: Text(
                'Notificações',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPendingPaymentsTab(),
          _buildPaymentHistoryTab(),
          _buildNotificationsTab(),
        ],
      ),
    );
  }

  Widget _buildPendingPaymentsTab() {
    List<Map<String, dynamic>> pendingPayments = [
      {'name': 'Plano Mensal', 'dueDate': '15/08/2024', 'amount': 150.0},
      {'name': 'Plano Anual', 'dueDate': '20/08/2024', 'amount': 1200.0},
    ];

    return ListView.builder(
      itemCount: pendingPayments.length,
      itemBuilder: (context, index) {
        final payment = pendingPayments[index];
        return Card(
          margin: EdgeInsets.all(8),
          child: ListTile(
            title: Text(payment['name']),
            subtitle: Text('Data de vencimento: ${payment['dueDate']}\nValor: R\$ ${payment['amount']}'),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                textStyle: TextStyle(fontSize: 14),
              ),
              onPressed: () {
                _makePayment(payment['name']);
              },
              child: Text('Pagar'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaymentHistoryTab() {
    List<Map<String, dynamic>> paymentHistory = [
      {'name': 'Plano Mensal', 'date': '01/08/2024', 'amount': 150.0, 'method': 'Cartão'},
      {'name': 'Plano Anual', 'date': '05/08/2024', 'amount': 1200.0, 'method': 'Pix'},
    ];

    return ListView.builder(
      itemCount: paymentHistory.length,
      itemBuilder: (context, index) {
        final payment = paymentHistory[index];
        IconData iconData;
        Color iconColor = Colors.blue;

        switch (payment['method']) {
          case 'Cartão':
            iconData = Icons.credit_card;
            break;
          case 'Pix':
            iconData = Icons.qr_code;
            break;
          default:
            iconData = Icons.payment;
            break;
        }

        return Card(
          margin: EdgeInsets.all(8),
          child: ListTile(
            title: Text(payment['name']),
            subtitle: Text('Data: ${payment['date']}\nValor: R\$ ${payment['amount']}\nMétodo: ${payment['method']}'),
            leading: Icon(iconData, color: iconColor),
          ),
        );
      },
    );
  }

  Widget _buildNotificationsTab() {
    List<String> notifications = [
      'Seu pagamento de R\$ 150,00 foi recebido com sucesso.',
      'Lembrete: Sua próxima parcela vence em 15/08/2024.',
    ];

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.notifications, color: Colors.blue),
          title: Text(notifications[index]),
        );
      },
    );
  }

  void _makePayment(String paymentName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pagamento Realizado'),
          content: Text('O pagamento para $paymentName foi realizado com sucesso.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
