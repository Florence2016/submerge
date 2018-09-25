import 'dart:core';

class SearchResult {
  static final SearchResult _submergeResult = SearchResult._internal();

  factory SearchResult() => _submergeResult;

  SearchResult._internal();

  static SearchResult get instance => _submergeResult;

  static String searchEngine = SearchEngines["Google"];
}

Map<String, dynamic> SearchEngines = {
  "Google": "google.com",
  "Bing": "bing.com",
  "Yahoo!": "yahoo.com",
  "Searchlock": "searchlock.com",
};