import 'package:crypto_bazzar/data/constant/constants.dart';
import 'package:crypto_bazzar/data/models/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, this.coindata});
  List<Crypto>? coindata;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Crypto>? coinData;
  bool isOnSerching = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    coinData = widget.coindata;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'کریپتو بازار',
          style: TextStyle(fontFamily: 'mh', fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: blackColor,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: blackColor,
      body: SafeArea(
        child: Column(
          children: [
            _getTextFildSerch(),
            Visibility(
              visible: isOnSerching,
              child: Text(
                '... درحال آپدیت لیست',
                style: TextStyle(
                  color: greenColor,
                  fontFamily: 'mh',
                  fontSize: 16,
                ),
              ),
            ),
            Expanded(
              child: _getRefreshIndicator(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getTextFildSerch() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextField(
          onChanged: (value) async {
            setState(() {
              isOnSerching = true;
            });

            List<Crypto> getData = await _getFreshData();
            setState(() {
              coinData = getData;
              isOnSerching = false;
            });
            _getSerchResult(value);
          },
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  width: 0.0,
                  style: BorderStyle.none,
                  color: Colors.white,
                ),
              ),
              hintText: 'اسم   رمز ارز    را  وارد کنید',
              hintStyle: TextStyle(color: Colors.white, fontSize: 18),
              filled: true,
              fillColor: greenColor),
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'mh'),
        ),
      ),
    );
  }

  void _getSerchResult(String keyWord) {
    List<Crypto> serchResult = [];

    serchResult = coinData!.where((element) {
      return element.name.toLowerCase().contains(keyWord.toLowerCase());
    }).toList();

    setState(() {
      coinData = serchResult;
    });
  }

  Widget _getRefreshIndicator() {
    return RefreshIndicator(
      color: blackColor,
      backgroundColor: greenColor,
      onRefresh: () async {
        List<Crypto> freshData = await _getFreshData();
        setState(() {
          coinData = freshData;
        });
      },
      child: ListView.builder(
        itemCount: coinData!.length,
        itemBuilder: (context, index) {
          return _getListTile(coinData![index]);
        },
      ),
    );
  }

  Future<List<Crypto>> _getFreshData() async {
    var response = await Dio().get('http://api.coincap.io/v2/assets');

    List<Crypto> coinData = response.data['data']
        .map<Crypto>((jsonObject) => Crypto.fromJsonMap(jsonObject))
        .toList();
    return coinData;
  }

  Widget _getListTile(Crypto crypto) {
    return ListTile(
      title: Text(
        crypto.name,
        style: TextStyle(color: greenColor),
      ),
      leading: SizedBox(
        width: 25,
        child: Center(
          child: Text(
            crypto.rank.toString(),
            style: TextStyle(
              color: greyColor,
            ),
          ),
        ),
      ),
      subtitle: Text(
        crypto.symbol,
        style: TextStyle(color: greyColor),
      ),
      trailing: SizedBox(
        width: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  crypto.priceUsd.toStringAsFixed(2),
                  style: TextStyle(color: greyColor, fontSize: 16),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  crypto.changePercent24hr.toStringAsFixed(2) + ' %',
                  style: TextStyle(
                    color: _getTextColos(crypto.changePercent24hr),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _getIconChangePercent(crypto.changePercent24hr),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getIconChangePercent(double percent) {
    return percent <= 0
        ? Icon(
            Icons.trending_down,
            color: redColor,
            size: 24,
          )
        : Icon(
            Icons.trending_up,
            color: greenColor,
            size: 24,
          );
  }
}

Color _getTextColos(double percent) {
  return percent <= 0 ? redColor : greenColor;
}
