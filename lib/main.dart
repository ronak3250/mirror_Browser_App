
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mirror_browser/controller/controller.dart';
import 'package:mirror_browser/model/BookmarkModel.dart';
import 'package:mirror_browser/view/screen/HomeScreen.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider<ScreenChanger>(create: (context) => ScreenChanger(),

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
        theme: ThemeData(
            useMaterial3: true
        ),
      ),),

  );
}
