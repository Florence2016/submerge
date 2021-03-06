
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:submerge/components/drawer.dart';
import 'package:submerge/utils/subresult.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:submerge/components/searchHomebuttons.dart';
import 'package:flutter/services.dart';

const kAndroidUserAgent = 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';


// ignore: must_be_immutable
class Submerge extends StatefulWidget {
  bool primary = true;
  Uri uri;

  @override
  _WebViewSubmergeState createState() => _WebViewSubmergeState();
}

class _WebViewSubmergeState extends State<Submerge> {
  FlutterWebviewPlugin _webViewPlugin = new FlutterWebviewPlugin();
  TextEditingController _textController;
  AnimationController controllerBackdrop;
  PreferredSizeWidget appBar;
  Rect _rect;
  Timer _resizeTimer;
  List<DropdownMenuItem<String>> listSearch = [];
  String selected;

  @override
  void initState() {
    super.initState();
    _webViewPlugin.close();
  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _webViewPlugin.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    appBar = buildAppBar();

    _webViewPlugin.onUrlChanged.listen((String url) {
      widget.uri = Uri.parse(url);
      _textController.text = widget.uri.toString();
    });

    //in charge for opening webview search result after enter word on search bar
    if(widget.uri != null) {
      if(_rect == null) {
        _rect = _buildRect(context, appBar);
        _webViewPlugin.launch(widget.uri.toString(),
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
            _webViewPlugin.resize(_rect);
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
    addItemSearch();

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/panda.png"),
            fit: BoxFit.cover,)),
      child: ListView(
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
                            dropListSearch(),

                            Container(
                              width: 240.0,
                              child:  enterSearch(),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  homeRowButtons(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  String selectedSearch;
  Widget enterSearch(){
    String changeSearchResult = selectedSearch;

    switch(changeSearchResult){

      case "Bing" :
        return TextField(
          // controller: _textController,
          cursorColor: Colors.blueGrey[100],
          decoration:  InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(16.0),
            hintText: 'Enter here',
          ),
          onSubmitted: handleSubmittedBing,

        );
        break;
      case "Yahoo":
        return TextField(
          // controller: _textController,
          cursorColor: Colors.blueGrey[100],
          decoration:  InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(16.0),
            hintText: 'Enter here',
          ),
          onSubmitted: handleSubmittedYhs,

        );
        break;
      case "Searchlock":
        return TextField(
          // controller: _textController,
          cursorColor: Colors.blueGrey[100],
          decoration:  InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(16.0),
            hintText: 'Enter here',
          ),
          onSubmitted: handleSubmittedSearchlock,

        );
        break;

      default:
        return TextField(
          // controller: _textController,
          cursorColor: Colors.blueGrey[100],
          decoration:  InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(16.0),
            hintText: 'Enter here',
          ),
          onSubmitted: handleSubmittedGoogle,

        );
        break;
    }

  }
  Widget dropListSearch(){
    return DropdownButtonHideUnderline(
      child: Center(
          child: ButtonTheme(
            alignedDropdown: true,
            child: Container(
              height: 50.0,
              child: DropdownButton(
                value: selected,
                items: listSearch,
                hint: Image.asset("assets/google.png", height: 30.0,width: 30.0,),
                onChanged: (value) {
                  print('Selected $value');
                  selected = value;

                  Fluttertoast.showToast(
                    msg: "$selected",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIos: 1,
                    bgcolor: "#0d0f7c",
                  );
                  setState(() {
                    selectedSearch = selected;
                  });
                },
              ),
            ),
          )
      ),
    );

  }
  Widget homeRowButtons(){
    return Padding(
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
          Expanded(
            child: GestureDetector(
              onTap: () {
                SubmergeNewTab.launchSearchlock(context);
                print('searchlock click');
              },
              child: Container(
                  height: 50.0,
                  decoration: new BoxDecoration(
                    color: Colors.blueGrey[500],
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    child: Image.asset("assets/searchlock.png", fit: BoxFit.contain,width: 10.0,
                      height: 10.0,)
                    ,)
              ),
            ),
          ),

        ],
      ),
    );
  }
  Widget buildAppBar2() {
    _textController = new TextEditingController(text: (widget.uri == null) ? "" : widget.uri.toString());
    return AppBar(
      brightness: Brightness.dark,
      backgroundColor: Colors.white,
      titleSpacing: 0.0,
      leading: IconButton(
          icon: Icon(Icons.home, color: Colors.grey,),
          onPressed: home
      ),
      title: TextField(
        maxLines: 1,
        keyboardType: TextInputType.url,
        controller: _textController,
        style: TextStyle(fontSize: 16.0,
            color: Colors.black
        ),

        decoration: InputDecoration.collapsed(
            border: InputBorder.none,
            hintText: "Search or enter URL",
            hintStyle: TextStyle(fontSize: 16.0, color: Colors.grey[300])
        ),
        onSubmitted: handleSubmittedYhs,
      ),

      actions: <Widget>[

        IconButton(
            icon: Icon(Icons.more_vert, color: Colors.grey,),
            onPressed: () {
              widget.uri = null;
              _webViewPlugin.close();
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
      backgroundColor: Colors.white,
      iconTheme: new IconThemeData(color: Colors.grey),
      titleSpacing: 0.0,
      leading: IconButton(
          icon: Icon(Icons.home, color: Colors.grey,),
          onPressed: home
      ),
      title: TextField(
        maxLines: 1,
        keyboardType: TextInputType.url,
        controller: _textController,
        style: TextStyle(fontSize: 16.0,
            color: Colors.black
        ),

        decoration: InputDecoration.collapsed(
            border: InputBorder.none,
            hintText: "Search or enter URL",
            hintStyle: TextStyle(fontSize: 16.0, color: Colors.grey[300])
        ),
        onSubmitted: handleSubmittedYhs,
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

  Future handleSubmittedYhs(String text) async {
    print(text);
    _textController.clear();
    //if text field null but go, keyboard auto close no search result
    searchYhs(text);
    _textController.text = widget.uri.toString();
  }
  Future handleSubmittedBing(String text) async {
    print(text);
    _textController.clear();
    //if text field null but go, keyboard auto close no search result
    searchBing(text);
    _textController.text = widget.uri.toString();

  }
  Future handleSubmittedGoogle(String text) async {
    print(text);
    _textController.clear();
    //if text field null but go, keyboard auto close no search result
    searchGoogle(text);
    _textController.text = widget.uri.toString();

  }
  Future handleSubmittedSearchlock(String text) async {
    print(text);
    _textController.clear();
    //if text field null but go, keyboard auto close no search result
    searchSearchlock(text);
    _textController.text = widget.uri.toString();

  }

  void home() {
    setState(() => widget.uri = null);
    _webViewPlugin.close();
  }
  void relaunch() {
    _webViewPlugin.close();
    _webViewPlugin.launch(widget.uri.toString(),
      rect: _rect,
    );
  }
  searchYhs(String query) {
    setState(() => widget.uri = Uri.parse("https://"+SearchResult.searchEngineYhs+query));
    if(_rect != null)
      relaunch();
  }
  searchBing(String query) {
    setState(() => widget.uri = Uri.parse("https://"+SearchResult.searchEngineBing+query+"&chnm=store&ref=sa-tab&sr=newtab-sb"));
    if(_rect != null)
      relaunch();
  }
  searchGoogle(String query) {
    setState(() => widget.uri = Uri.parse("https://"+SearchResult.searchEngineGoogle+"/search?q="+query));
    if(_rect != null)
      relaunch();
  }
  searchSearchlock(String query) {
    setState(() => widget.uri = Uri.parse("https://"+SearchResult.searchEngineSearchlock+"/search?q="+query));
    if(_rect != null)
      relaunch();
  }

  void addItemSearch(){
    listSearch = [];
    listSearch.add(DropdownMenuItem(
      child:Center(child: Image.asset("assets/google.png", height: 30.0,width: 30.0,)),
      //child:Center(child: Text('Bing')),
      value:"Google",
    ));
    listSearch.add(DropdownMenuItem(
      child:Center(child: Image.asset("assets/bing.png", height: 30.0,width: 30.0,)),
      //child:Center(child: Text('Bing')),
      value:"Bing",
    ));
    listSearch.add(DropdownMenuItem(
      child:Center(child: Image.asset("assets/yahoo.png", height: 30.0,width: 30.0,)),
      //child:Center(child: Text('Yahoo')),
      value:"Yahoo",
    ));
    listSearch.add(DropdownMenuItem(
      child:Center(child: Image.asset("assets/searchlock.png", height: 30.0,width: 30.0,)),
      //child:Center(child: Text('SL')),
      value:"Searchlock",
    ));
  }

}