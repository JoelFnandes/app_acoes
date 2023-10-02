import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:string_similarity/string_similarity.dart';

class StockData {
  final String name;
  final String location;
  final double points;

  StockData({required this.name, required this.location, required this.points});
}

class ViewStocks extends StatefulWidget {
  @override
  _ViewStocksState createState() => _ViewStocksState();
}

class _ViewStocksState extends State<ViewStocks> {
  TextEditingController _searchController = TextEditingController();
  List<StockData> _stockList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesquisa de Ações'),
        backgroundColor: Colors.amber,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _searchStocks,
              decoration: InputDecoration(
                labelText: 'Digite o nome da ação',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                      color:
                          Colors.grey), // Cor da borda quando não está em foco
                ), // Cor da borda
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber)),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _stockList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_stockList[index].name),
                  subtitle: Text(_stockList[index].location),
                  trailing: Text(
                      'Pontos: ${_stockList[index].points.toStringAsFixed(2)}'),
                  textColor: Colors.white,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _searchStocks(String query) async {
    if (query.length < 2) {
      setState(() {
        _stockList.clear();
      });
      return;
    }

    final financeAPI =
        "https://api.hgbrasil.com/finance?format=json-cors&key=2a34b926";

    final response = await http.get(Uri.parse(financeAPI));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data != null &&
          data['results'] != null &&
          data['results']['stocks'] != null) {
        setState(() {
          _stockList.clear();
          final stocksData = data['results']['stocks'];
          stocksData.forEach((key, value) {
            final stock = StockData(
              name: value['name'],
              location: value['location'],
              points: value['points'].toDouble(),
            );
            _stockList.add(stock);
          });

          // Ordena a lista com base na similaridade do nome com a consulta
          _stockList.sort((a, b) {
            double similarityA = a.name.similarityTo(query);
            double similarityB = b.name.similarityTo(query);
            return similarityB.compareTo(similarityA);
          });
        });
      }
    } else {
      setState(() {
        _stockList.clear();
      });
    }
  }
}
