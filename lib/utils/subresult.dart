import 'dart:core';

class SearchResult {
  static final SearchResult _submergeResult = SearchResult._internal();

  factory SearchResult() => _submergeResult;

  SearchResult._internal();

  static SearchResult get instance => _submergeResult;

  static String searchEngineYhs = searchEngines["Yahoo"];
  static String searchEngineBing = searchEngines["Bing"];
  static String searchEngineGoogle = searchEngines["Google"];
  static String searchEngineSearchlock = searchEngines["Searchlock"];

}

Map<String, dynamic> searchEngines = {
  "Google": "google.com",
  "Bing": "bing.com/search?c=snt&q=",
  //"Yahoo": "yahoo.com",
  "Yahoo": "search.yahoo.com/yhs/search?hspart=sz&hsimp=yhs-001&p=",
  "Searchlock": "searchlock.com",
};