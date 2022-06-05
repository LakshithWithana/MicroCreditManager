import 'package:flutter/material.dart';
import 'package:mcm/reusable_components/custom_elevated_buttons.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../shared/colors.dart';

class WebViewPage extends StatelessWidget {
  final String title;
  final String url;
  const WebViewPage({Key? key, required this.title, required this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: mainColor),
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          children: [
            Flexible(
              child: WebView(
                initialUrl: url,
                javascriptMode: JavascriptMode.unrestricted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
