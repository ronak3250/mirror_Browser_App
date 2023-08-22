import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

enum Browser { Google, Yahoo, Bing, DuckDuckgo }

class ScreenChanger with ChangeNotifier {
  Browser _chooseBrowser = Browser.Google;
  String _url = "";
  double _progress = 0;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  ConnectivityResult get connectionStatus=>_connectionStatus;
  String get url=>_url;
  double get progress=>_progress;

  Browser get chooseBrowser => _chooseBrowser;
  set checkConnectionStatus(updateConnection)
  {
    _connectionStatus=updateConnection;
    notifyListeners();
  }
  set setURL(newUrl)
  {
    _url=newUrl;
    notifyListeners();
  }
set progressBar(updateProgress)
{
  _progress=updateProgress;
  notifyListeners();
}
  set changeBrowser(newValue) {
    _chooseBrowser = newValue;
    notifyListeners();
  }
}
