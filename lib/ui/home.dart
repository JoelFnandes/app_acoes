import 'package:flutter/material.dart';
import 'conversor.dart'; // Importe o arquivo conversor.dart
import 'viewStocks.dart'; // Importe o arquivo ViewStocks.dart

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AppAcões'),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Navegue para a página conversor.dart
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Conversor()),
                );
              },
              child: Text('Conversor de moedas'),
              style: ElevatedButton.styleFrom(fixedSize: Size(170, 50)),
            ),
            ElevatedButton(
              onPressed: () {
                // Navegue para a página ViewStocks.dart
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewStocks()),
                );
              },
              child: Text('Visualizar ações'),
              style: ElevatedButton.styleFrom(fixedSize: Size(170, 50)),
            ),
          ],
        ),
      ),
    );
  }
}
