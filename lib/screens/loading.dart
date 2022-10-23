import 'package:crypto_bazzar/data/constant/constants.dart';
import 'package:crypto_bazzar/data/models/crypto.dart';
import 'package:crypto_bazzar/screens/homeScreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/images/logo.png'),
            ),
            SpinKitWave(
              color: Colors.white,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getData() async {
    var response = await Dio().get('http://api.coincap.io/v2/assets');

    List<Crypto> coinData = response.data['data']
        .map<Crypto>((jsonObject) => Crypto.fromJsonMap(jsonObject))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: ((context) => HomeScreen(
              coindata: coinData,
            )),
      ),
    );
  }
}
