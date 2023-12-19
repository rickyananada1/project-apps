import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MainScreen extends StatefulWidget {
  final String token;
  const MainScreen({Key? key, required this.token}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  String tokenValue = '';
  List<String> _urls = [];

  @override
  void initState() {
    super.initState();
    _getTokenFromStorage();
    _initializeUrls();
  }

  void _getTokenFromStorage() async {
    final storage = FlutterSecureStorage();
    tokenValue = await storage.read(key: 'token') ?? '';
    print('token cek woi : ' + tokenValue);
    print('http://10.232.1.21:7767/redirect/page?menu=Overview&token=' + tokenValue);
  }

  void _initializeUrls() {
    String encodedToken = Uri.encodeComponent(tokenValue);
    _urls = [
      'http://10.232.1.21:7767/dashboard',
      'https://bbo.pln.co.id/monit-dashboard/',
      'https://example.com/page3',
      'https://example.com/page4',
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitleForIndex(_selectedIndex)),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _urls.map((url) => _buildWebView(url)).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'MAPP',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'BBO',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Page 3',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Page 4',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        onTap: _onNavItemTapped,
      ),
    );
  }

  Widget _buildWebView(String url) {
    return WebView(
      initialUrl: url,
      debuggingEnabled: true,
      javascriptMode: JavascriptMode.unrestricted,
      onWebResourceError: (WebResourceError error) {
        print("Error: ${error.description}");
      },
      onPageFinished: (String url) {
        _reloadWebView();
      },
    );
  }

  String _getTitleForIndex(int index) {
    if (index == 0) {
      return 'Monitoring MAPP';
    } else if (index == 1) {
      return 'Monitoring BBO';
    } else {
      return 'Monitoring';
    }
  }

  void _reloadWebView() {
    if (_selectedIndex == 0) {
      setState(() {});
    }
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
