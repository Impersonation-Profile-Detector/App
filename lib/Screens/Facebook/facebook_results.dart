import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class FacebookScraper extends StatefulWidget {
  const FacebookScraper({super.key});

  @override
  FacebookScraperState createState() => FacebookScraperState();
}

class FacebookScraperState extends State<FacebookScraper> {
  Map<String, String> collectedProfiles = {};

  // Future<Uint8List> getBitmapFromURL(String src) async {
  //   try {
  //     final response = await http.get(Uri.parse(src));

  //     if (response.statusCode == 200) {
  //       return response.bodyBytes;
  //     } else {
  //       print('Failed to load image: ${response.statusCode}');
  //       return ;
  //     }
  //   } catch (e) {
  //     print('Image download error');
  //     print(e.toString());
  //     return null;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Facebook Scraper'),
      ),
      body: WebView(
        initialUrl: 'https://m.facebook.com/notifications.php', // Updated URL
        javascriptMode: JavascriptMode.unrestricted,
        onPageFinished: (String url) {
          if (url.startsWith('https://m.facebook.com/notifications.php')) {
            scrapFacebook();
          }
        },
      ),
    );
  }

  void scrapFacebook() async {
    String html = await _getWebViewHtml();
    var doc = parse(html);
    var images = doc.getElementsByTagName('img');

    for (var element in images) {
      String src = element.attributes['src'] ?? '';
      String innerText =
          element.parent?.parent?.parent?.text.replaceAll('Add Friend', '') ??
              '';
      collectedProfiles[src.replaceAll('"', '').replaceAll('\\', '')] =
          innerText;
    }

    imageProcessing();
  }

  void imageProcessing() {
    // Your image processing logic here
    print('Image processing logic');
  }

  Future<String> _getWebViewHtml() async {
    // You can use a web scraping package for Dart/Flutter if needed
    // For example, you could use the http package to make a request and get the HTML
    // However, be cautious about the terms of service of the website you are scraping.
    return ''; // Replace with actual HTML content
  }
}
