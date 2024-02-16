import 'dart:convert';

import 'package:flutter_news_app/models/new_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkService {
  Future<List<NewModel>> getbookmarks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? bookmarksStringList = prefs.getStringList("bookmarks");
    if (bookmarksStringList != null) {
      return bookmarksStringList
          .map((e) => NewModel.fromJson(jsonDecode(e)))
          .toList();
    } else {
      return [];
    }
  }

  Future<bool> inBookmarks(NewModel newModel) async {
    List<NewModel> bookmarks = await getbookmarks();
    return bookmarks
        .where((element) => element.url == newModel.url)
        .toList()
        .isNotEmpty;
  }

  Future<void> toggleBookmark(NewModel newModel) async {
    List<NewModel> bookmarks = await getbookmarks();
    bool isInBookmarks = await inBookmarks(newModel);

    if (isInBookmarks) {
      bookmarks.removeWhere((element) => element.url == newModel.url);
    } else {
      bookmarks.add(newModel);
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        "bookmarks", bookmarks.map((e) => jsonEncode(e.toJson())).toList());
  }
}
