import 'package:bitcoin_ticker/network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

const apiKey = 'B49135DF-CED0-4E2E-AEA7-09A189DEAC2D';
const coinapiURL = 'https://rest.coinapi.io/v1/exchangerate/BTC/USD';


class ExchangeModel {
  Future<dynamic> getExchangeRate() async {
    NetworkHelper networkHelper = NetworkHelper('$coinapiURL?apiKey=$apiKey');

    var exchangeData = await networkHelper.getData();
    return exchangeData['rate'];
  }
}


class PriceScreen extends StatefulWidget {
  PriceScreen({this.currentRate});

  final currentRate;

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  ExchangeModel exchange = ExchangeModel();

  String selectedCurrency = 'USD';

  //Method to get android drop down menu
  DropdownButton<String> androidDropDown() {

    List<DropdownMenuItem<String>> dropDownItems = [];

    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );

      dropDownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropDownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
        });
      },
    );
  }

  //Method to get iOS picker items
  CupertinoPicker iOSPicker() {

    List<Text> pickerItems = [];

    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {},
      children: pickerItems,
    );
  }

  var rate;

  @override
  void initState() {
    super.initState();

    updateUI(widget.currentRate);
  }

  void updateUI(dynamic exchangeData) {
    setState(() {
      if (exchangeData == null) {
        rate = 'Error';
        return;
      }
      rate = exchangeData['rate'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = $rate USD',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropDown(),
          ),
        ],
      ),
    );
  }
}
