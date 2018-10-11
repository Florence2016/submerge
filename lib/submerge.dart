import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:submerge/components/drawer.dart';
import 'package:submerge/components/linkbuttons.dart';
import 'package:submerge/utils/subresult.dart';
import 'package:submerge/utils/suburi.dart';
import 'package:flutter/services.dart';

const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

class Submerge extends SubmergeUri {
  final bool primary;

  Submerge({Key key, Uri uri, this.primary: true}) : super (key: key, uri: uri,);

  @override
  _WebViewSubmergeState createState() => _WebViewSubmergeState();
}

class _WebViewSubmergeState extends State<Submerge> {
  FlutterWebviewPlugin _webviewPlugin = new FlutterWebviewPlugin();
  TextEditingController _textController;
  AnimationController controllerBackdrop;
  PreferredSizeWidget appBar;
  Rect _rect;
  Timer _resizeTimer;

  @override
  void initState() {
    super.initState();
    _webviewPlugin.close();

  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _webviewPlugin.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    appBar = buildAppBar();

    _webviewPlugin.onUrlChanged.listen((String url) {
      widget.uri = Uri.parse(url);
      _textController.text = widget.uri.toString();
    });

    //in charge for opening webview search result after enter word on search bar
    if(widget.uri != null) {
      if(_rect == null) {
        _rect = _buildRect(context, appBar);
        _webviewPlugin.launch(widget.uri.toString(),
          rect: _rect,
        );
      }

      //in charge of too much hard work on the main thread, preventing from hang
      else {
        Rect rect = _buildRect(context, appBar);
        if (_rect != rect) {
          _rect = rect;
          _resizeTimer?.cancel();
          _resizeTimer = new Timer(new Duration(milliseconds: 300), () {
            // avoid resizing to fast when build is called multiple time
            _webviewPlugin.resize(_rect);
          });
        }
      }

      //this is in charge to overlay appbar webview
      return Scaffold(
        appBar: buildAppBar2(),

      );
    }
    //this is in charge to return appbar and body of submerge
    else return buildHomePage();
  }


  Widget buildHomePage() {

    return Scaffold(
      endDrawer: SubmergeDrawer(),
      appBar: buildAppBar(),
      body:  listViewHome(),

    );
  }

  Widget listViewHome(){
    return ListView(
      children: <Widget>[
        Padding(padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 100.0),
          child: Container(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () => print('search click'),
                          ),
                          Container(
                            width: 250.0,
                            child: TextField(
                              // controller: _textController,
                              cursorColor: Colors.blueGrey[100],
                              decoration:  InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(16.0),
                                hintText: 'Enter here',
                              ),
                              onSubmitted: handleSubmitted,
                            )
                            ,
                          ),

                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding:const EdgeInsets.symmetric(vertical: 100.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            SubmergeNewTab.launchGmail(context);
                            print('gmail click');
                          },
                          child: Container(
                              height: 50.0,
                              decoration: new BoxDecoration(
                                color: Colors.blueGrey[900],
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                child: Image.asset("assets/gmail.png", fit: BoxFit.contain,width: 10.0,
                                  height: 10.0,),
                              )
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            SubmergeNewTab.launchFacebook(context);
                            print('facebook click');
                          },
                          child: Container(
                              height: 50.0,
                              decoration: new BoxDecoration(
                                color: Colors.blueGrey[700],
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                height: 10.0,
                                child: Image.asset("assets/facebook.png", fit: BoxFit.contain, width: 1.0,
                                  height: 1.0,),
                              )
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            SubmergeNewTab.launchYoutube(context);
                            print('youtube click');
                          },
                          child: Container(
                              height: 50.0,
                              decoration: new BoxDecoration(
                                color: Colors.blueGrey[500],
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                child: Image.asset("assets/youtube.png", fit: BoxFit.contain,width: 10.0,
                                  height: 10.0,)
                                ,)
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget buildAppBar2() {
    _textController = new TextEditingController(text: (widget.uri == null) ? "" : widget.uri.toString());
    return AppBar(
      brightness: Brightness.dark,
      backgroundColor: Colors.blueGrey[900],
      titleSpacing: 0.0,
      leading: IconButton(
          icon: Icon(Icons.home, color: Colors.white,),
          onPressed: home
      ),
      title: TextField(
        maxLines: 1,
        keyboardType: TextInputType.url,
        controller: _textController,
        style: TextStyle(fontSize: 16.0,
            color: Colors.white
        ),

        decoration: InputDecoration.collapsed(
            border: InputBorder.none,
            hintText: "Search or enter URL",
            hintStyle: TextStyle(fontSize: 16.0, color: Colors.grey[300])
        ),
        onSubmitted: handleSubmitted,
      ),

      actions: <Widget>[

        IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white,),
            onPressed: () {
              widget.uri = null;
              _webviewPlugin.close();
              Navigator.pushNamed(context, 'settings');
            }
        ),
      ],
    );
  }
  Widget buildAppBar() {
    _textController = new TextEditingController(text: (widget.uri == null) ? "" : widget.uri.toString());
    return AppBar(
      brightness: Brightness.dark,
      backgroundColor: Colors.blueGrey[900],
      titleSpacing: 0.0,
      leading: IconButton(
          icon: Icon(Icons.home, color: Colors.white,),
          onPressed: home
      ),
      title: TextField(
        maxLines: 1,
        keyboardType: TextInputType.url,
        controller: _textController,
        style: TextStyle(fontSize: 16.0,
            color: Colors.white
        ),

        decoration: InputDecoration.collapsed(
            border: InputBorder.none,
            hintText: "Search or enter URL",
            hintStyle: TextStyle(fontSize: 16.0, color: Colors.grey[300])
        ),
        onSubmitted: handleSubmitted,
      ),
    );
  }
  Rect _buildRect(BuildContext context, PreferredSizeWidget appBar) {
    bool fullscreen = appBar == null;
    final mediaQuery = MediaQuery.of(context);
    final topPadding = widget.primary ? mediaQuery.padding.top : 0.0;
    num top = fullscreen ? 0.0 : appBar.preferredSize.height + topPadding;
    num height = mediaQuery.size.height - top;

    return new Rect.fromLTWH(0.0, top, mediaQuery.size.width, height);
  }

  Future handleSubmitted(String text) async {
    print(text);
    //if text field null but go, keyboard auto close no search result

    search(text);
    _textController.text = widget.uri.toString();

  }
  void home() {
    setState(() => widget.uri = null);
    _webviewPlugin.close();
  }
  void relaunch() {
    _webviewPlugin.close();
    _webviewPlugin.launch(widget.uri.toString(),
      rect: _rect,
    );
  }
  search(String query) {
    setState(() => widget.uri = Uri.parse("https://"+SearchResult.searchEngine+"/search?q="+query));
    if(_rect != null)
      relaunch();
  }
}