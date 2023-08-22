
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';

import '../../controller/controller.dart';
import '../../model/BookmarkModel.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  TextEditingController controller = TextEditingController();
  late InAppWebViewController _webViewController;

  late PullToRefreshController? pullToRefreshController;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    pullToRefreshController = PullToRefreshController(
        options: PullToRefreshOptions(
          color: Color(0xff6054c1),
        ),
        onRefresh: () async {
          await _webViewController.reload();
        });
  }
  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e);
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {

    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      _connectionStatus.toString()=="ConnectivityResult.wifi"||_connectionStatus.toString()=="ConnectivityResult.mobile"?
      SafeArea(
          child: Consumer<ScreenChanger>(
            builder: (context, value1, child) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  centerTitle: true,
                  title: Text(
                    'My Browser',
                    style: TextStyle(color: Colors.black),
                  ),
                  actionsIconTheme: IconThemeData(color: Colors.black),
                  actions: [
                    PopupMenuButton(
                      // color: Color(0xfff5ecf6),
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.black,
                        ),
                        elevation: 0,
                        position: PopupMenuPosition.under,
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem<int>(
                              value: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.bookmark),
                                  ),
                                  Text(("All Bookmarks")),
                                ],
                              ),
                            ),
                            PopupMenuItem<int>(
                              value: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.screen_search_desktop_outlined),
                                  Text(("Search Engine")),
                                ],
                              ),
                            ),
                          ];
                        },
                        onSelected: (value) {
                          if (value == 0) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Scaffold(
                                  appBar: PreferredSize(
                                    preferredSize: (Size(double.infinity, 80)),
                                    child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.purple.shade50, elevation: 0),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(Icons.close),
                                        label: GestureDetector(
                                          child: Text("Dismiss"),
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                        )),
                                  ),
                                  body: bookmarkModel.isNotEmpty
                                      ? Container(
                                    child: ListView.separated(
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Text(
                                              "${bookmarkModel[index].bookmarktitle}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            subtitle: Text(
                                                "${bookmarkModel[index].bookmarkdesc}"),
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                            height: 10,
                                          );
                                        },
                                        itemCount: bookmarkModel.length),
                                  )
                                      : Center(
                                    child: Text("No any bookmark yet...."),
                                  ),
                                );
                              },
                            );
                          } else if (value == 1) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return WillPopScope(
                                  child: Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        height: 380,
                                        width: 400,
                                        child: AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(30.0))),
                                            title: Text("Search Engine"),
                                            content: Column(
                                              children: <Widget>[
                                                RadioListTile(
                                                  title:  Text('Google'),
                                                  value: Browser.Google,
                                                  groupValue: value1.chooseBrowser,
                                                  onChanged: (value) {

                                                    value1.changeBrowser= value!;
                                                    _webViewController.loadUrl(
                                                        urlRequest: URLRequest(
                                                            url: Uri.parse(
                                                                "https://www.google.com/" +
                                                                    controller.text)));
                                                    
                                                    Navigator.pop(context);


                                                  },
                                                ),
                                                RadioListTile(
                                                  title: const Text('Yahoo'),
                                                  value: Browser.Yahoo,
                                                  groupValue: value1.chooseBrowser,
                                                  onChanged: (value) {

                                                    value1.changeBrowser  = value!;
                                                    Navigator.pop(context);
                                                    _webViewController.loadUrl(
                                                        urlRequest: URLRequest(
                                                            url: Uri.parse(
                                                                "https://www.yahoo.com/" +
                                                                    controller.text)));

                                                  },
                                                ),
                                                RadioListTile(
                                                  title: const Text('Bing'),
                                                  value: Browser.Bing,
                                                  groupValue: value1.chooseBrowser,
                                                  onChanged: (value) {

                                                    value1.changeBrowser = value!;
                                                    Navigator.pop(context);
                                                    _webViewController?.loadUrl(
                                                        urlRequest: URLRequest(
                                                            url: Uri.parse(
                                                                "https://www.bing.com/" +
                                                                    controller.text)));


                                                  },
                                                ),
                                                RadioListTile(
                                                  title: const Text('DuckDuckGo'),
                                                  value:Browser.DuckDuckgo,
                                                  groupValue: value1.chooseBrowser,
                                                  onChanged: (valuex) {

                                                    value1.changeBrowser = valuex!;
                                                    _webViewController?.loadUrl(
                                                        urlRequest: URLRequest(
                                                            url: Uri.parse(
                                                                "https://www.duckduckgo.com/" +
                                                                    controller.text)));
                                                    Navigator.pop(context);
                                                    //  print(_method);

                                                  },
                                                ),
                                              ],
                                            )),
                                      )),
                                  onWillPop: () async {
                                    return false;
                                  },
                                );
                              },
                            );
                          }
                        })
                  ],
                ),
                body: Container(
                    child: Column(children: <Widget>[
                      Expanded(
                        child: Container(
                          child: InAppWebView(
                            pullToRefreshController: pullToRefreshController,
                            initialUrlRequest: URLRequest(
                              url: Uri.https("www.google.com"),
                            ),
                            onWebViewCreated: (InAppWebViewController controller) {
                              _webViewController = controller;
                            },
                            onLoadStart: (controller, url) {

                              value1.setURL= url as String;
                            },
                            onLoadStop: (controller, url) {
                              value1.setURL = url as String;
                            },
                            onProgressChanged:
                                (InAppWebViewController controller, int progress) {

                              value1.progressBar = progress / 100;

                              if (progress == 100) {
                                pullToRefreshController?.endRefreshing();
                              }
                            },
                          ),
                        ),
                      ),
                    ])),
                bottomNavigationBar: BottomNavigationBar(
                  items: [
                    BottomNavigationBarItem(
                        label: '',
                        icon: IconButton(
                          icon: Icon(
                            Icons.home_filled,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            if (value1.chooseBrowser==Browser.Google) {
                              _webViewController?.loadUrl(
                                  urlRequest: URLRequest(
                                      url:
                                      Uri.parse("https://www.google.com/search?q=")));
                            } else if (value1.chooseBrowser==Browser.DuckDuckgo) {
                              _webViewController?.loadUrl(
                                  urlRequest: URLRequest(
                                      url: Uri.parse(
                                          "https://www.duckduckgo.com/search?q=")));
                            } else if (value1.chooseBrowser==Browser.Bing) {
                              _webViewController?.loadUrl(
                                  urlRequest: URLRequest(
                                      url: Uri.parse("https://www.bing.com/search?q=")));
                            } else {
                              _webViewController?.loadUrl(
                                  urlRequest: URLRequest(
                                      url: Uri.parse("https://www.yahoo.com/search?q=")));
                            }
                          },
                        )),
                    BottomNavigationBarItem(
                        label: '',
                        icon: IconButton(
                          onPressed: () async {
                            if (_webViewController != null) {
                              bookmarkModel.add(BookmarkModel(
                                  bookmarktitle: await _webViewController.getTitle(),
                                  bookmarkdesc: await _webViewController.getUrl()));
                            }
                          },
                          icon: Icon(
                            Icons.bookmark_add_outlined,
                            color: Colors.black,
                          ),
                        )),
                    BottomNavigationBarItem(
                        label: '',
                        icon: IconButton(
                          onPressed: () {
                            if (_webViewController != null) {
                              _webViewController.goBack();
                            }
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.black,
                          ),
                        )),
                    BottomNavigationBarItem(
                        label: '',
                        icon: IconButton(
                          onPressed: () {
                            if (_webViewController != null) {
                              _webViewController.reload();
                            }
                          },
                          icon: Icon(
                            Icons.refresh,
                            color: Colors.black,
                          ),
                        )),
                    BottomNavigationBarItem(
                        label: '',
                        icon: IconButton(
                          onPressed: () {
                            if (_webViewController != null) {
                              _webViewController.goForward();
                            }
                          },
                          icon: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Colors.black,
                          ),
                        )),
                  ],
                ),
                bottomSheet: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        child: TextField(
                          controller: controller,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search or type web address",
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.search,
                                ),
                                onPressed: () {
                                  String searchUri = controller.text;

                                  if (value1.chooseBrowser==Browser.Google) {
                                    _webViewController.loadUrl(
                                        urlRequest: URLRequest(
                                            url: Uri.parse(
                                                "https://www.google.com/search?q=" +
                                                    searchUri)));
                                  } else if (value1.chooseBrowser==Browser.DuckDuckgo) {
                                    _webViewController.loadUrl(
                                        urlRequest: URLRequest(
                                            url: Uri.parse(
                                                "https://www.duckduckgo.com/search?q=" +
                                                    searchUri)));
                                  } else if (value1.chooseBrowser==Browser.Bing) {
                                    _webViewController.loadUrl(
                                        urlRequest: URLRequest(
                                            url: Uri.parse(
                                                "https://www.bing.com/search?q=" +
                                                    searchUri)));
                                  } else {
                                    _webViewController?.loadUrl(
                                        urlRequest: URLRequest(
                                            url: Uri.parse(
                                                "https://www.yahoo.com/search?q=" +
                                                    searchUri)));
                                  }
                                },
                              )),
                        ),
                        // margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(),
                        ),
                      ),
                      Container(
                        // padding: EdgeInsets.all(10.0),
                          child: value1.progress < 1.0
                              ? LinearProgressIndicator(value: value1.progress)
                              : Container()),
                    ],
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  height: 80,
                ),
              );
            },)):
      SafeArea(child: Scaffold(
        body: Center(
          child: Text("❌No Internet\n Check Your Internet Connection",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 30),),
        ),
      ));
  }
}
