import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';

const Map<String, String> UNIT_ID = kReleaseMode
    ? {
        'ios': '[YOUR iOS AD UNIT ID]',
        'android': '[YOUR ANDROID AD UNIT ID]',
      }
    : {
        'ios': 'ca-app-pub-3940256099942544/2934735716',
        'android': 'ca-app-pub-3940256099942544/6300978111',
      };

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  BannerAd banner;
  bool showBanner = true;
  Timer _showTimer;

  void loadBanner() {
    TargetPlatform os = Theme.of(context).platform;

    banner = BannerAd(
      listener: AdListener(
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          setState(() {
            showBanner = false;
          });
          _showTimer = Timer(Duration(seconds: 1), () {
            setState(() {
              showBanner = true;
            });
          });
        },
      ),
      size: AdSize.banner,
      adUnitId: UNIT_ID[os == TargetPlatform.iOS ? 'ios' : 'android'],
      request: AdRequest(),
    )..load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadBanner();
  }

  @override
  void dispose() {
    super.dispose();
    if (_showTimer.isActive) {
      _showTimer.cancel();
    }
    banner.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admob'),
      ),
      body: Center(
        child: Container(
          height: 50,
          child: showBanner
              ? AdWidget(
                  ad: banner,
                )
              : Container(),
        ),
      ),
    );
  }
}
