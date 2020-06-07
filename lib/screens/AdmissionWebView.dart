import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

String selectedUrl = 'https://form.jotform.com/201576884477571?fbclid=IwAR1xPCeYg1Nmuu0TpNze1Nym2vDqHoAWjFNyYY-092iWAq3BbMq9QlQBs1M';

// ignore: prefer_collection_literals
final Set<JavascriptChannel> jsChannels = [
  JavascriptChannel(
      name: 'Print',
      onMessageReceived: (JavascriptMessage message) {
        print(message.message);
      }),
].toSet();

class AdmissionWebView extends StatefulWidget {
  const AdmissionWebView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AdmissionWebViewState createState() => _AdmissionWebViewState();
}

class _AdmissionWebViewState extends State<AdmissionWebView> {
  // Instance of WebView plugin
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  // On destroy stream
  StreamSubscription _onDestroy;

  // On urlChanged stream
  StreamSubscription<String> _onUrlChanged;

  // On urlChanged stream
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  StreamSubscription<WebViewHttpError> _onHttpError;

//  StreamSubscription<double> _onProgressChanged;
//
//  StreamSubscription<double> _onScrollYChanged;
//
//  StreamSubscription<double> _onScrollXChanged;

  final _urlCtrl = TextEditingController(text: selectedUrl);

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    flutterWebViewPlugin.close();

    _urlCtrl.addListener(() {
      selectedUrl = _urlCtrl.text;
    });

    // Add listeners to WebView...
    _onDestroy = flutterWebViewPlugin.onDestroy.listen((_) {
//      if (mounted) {
//        _scaffoldKey.currentState.showSnackBar(SnackBar(content:  Text('Webview Destroyed')));
//      }
    });

    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (mounted)
        setState(() => _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Redirect...'))));
    });

    _onStateChanged =
        flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      if (mounted) {
        setState(() {
          _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('${state.type} Changed!')));
        });
      }
    });

    _onHttpError =
        flutterWebViewPlugin.onHttpError.listen((WebViewHttpError error) {
      if (mounted) {
        setState(() {
          _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Error with loading page ')));
          Navigator.pop(_scaffoldKey.currentContext);
        });
      }
    });
  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();

    flutterWebViewPlugin.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /*WidgetsFlutterBinding.ensureInitialized();*/
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.indigo,));
    
    return Padding(
      padding: EdgeInsets.only(top: statusBarHeight),
      child: WebviewScaffold(
        url: selectedUrl,
        key: _scaffoldKey,
        javascriptChannels: jsChannels,
        mediaPlaybackRequiresUserGesture: false,
        appBar: AppBar(
          primary: false,
          centerTitle: false,
          title:Row(
            children: <Widget>[
              Image.asset(
                'images/inflex_edu_logo.png',
                width: 60.0,
                height: 60.0,
              ),
              Expanded(child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text('Admission',
                  style: TextStyle(
                      color: Colors.white, fontSize: 18.0),),
              ),),
              IconButton(
                icon: const Icon(Icons.autorenew),
                onPressed: () {
                  flutterWebViewPlugin.reload();
                },
              ),
            ],
          ),
          flexibleSpace: Image(
            image: AssetImage('images/tool_bar_bg.png'),
            fit: BoxFit.cover,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        withZoom: true,
        withLocalStorage: true,
        hidden: true,
        initialChild: Container(
          color: Colors.white,
          child: const Center(child: Text('Waiting.....', style: TextStyle(color: Colors.pinkAccent, fontSize: 15.0),),
          ),
        ),
      ),
    );
  }

}
