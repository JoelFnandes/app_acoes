import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const financeAPI =
    "https://api.hgbrasil.com/finance?format=json-cors&key=2a34b926";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme:
        ThemeData(highlightColor: Colors.purple, primaryColor: Colors.purple),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(Uri.parse(financeAPI));
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final euroController = TextEditingController();
  final dolarController = TextEditingController();
  final realController = TextEditingController();

  double dolar = 0;
  double euro = 0;

  void _clearAll() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  void _realChange(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChange(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChange(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    euroController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black54,
        appBar: AppBar(
          title: const Text("Conversor de Ações"),
          centerTitle: true,
          backgroundColor: Colors.purple,
        ),
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return const Center(
                      child: Text(
                    "Carregando dados...",
                    style: TextStyle(color: Colors.purple, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ));
                default:
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text(
                      "Erro ao carregar dados...",
                      style: TextStyle(color: Colors.redAccent, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ));
                  } else {
                    dolar =
                        snapshot.data!["results"]["currencies"]["USD"]["buy"];
                    euro =
                        snapshot.data!["results"]["currencies"]["EUR"]["buy"];

                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const Icon(Icons.monetization_on,
                              size: 150.0, color: Colors.purple),
                          buildTextFormField(
                              "Reais", "R\$", realController, _realChange),
                          const Divider(),
                          buildTextFormField(
                              "Dólar", "US\$", dolarController, _dolarChange),
                          const Divider(),
                          buildTextFormField(
                              "Euro", "EUR", euroController, _euroChange),
                        ],
                      ),
                    );
                  }
              }
            }));
  }

  Widget buildTextFormField(String label, String prefix,
      TextEditingController controller, Function f) {
    return TextField(
      onChanged: (value) => f(value),
      controller: controller,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.purple),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.grey), // Cor da borda quando não está em foco
          ), // Cor da borda
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors
                      .purple)), // Cor da borda quando o campo está em foco
          prefixText: "$prefix ",
          prefixStyle:
              const TextStyle(color: Colors.cyanAccent, fontSize: 24.0)),
      style: const TextStyle(color: Colors.amber, fontSize: 25.0),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
    );
  }
}
