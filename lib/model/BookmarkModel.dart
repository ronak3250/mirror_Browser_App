// To parse this JSON data, do
//
//     final bookmarkModel = bookmarkModelFromJson(jsonString);

import 'dart:convert';

BookmarkModel bookmarkModelFromJson(String str) => BookmarkModel.fromJson(json.decode(str));

String bookmarkModelToJson(BookmarkModel data) => json.encode(data.toJson());

class BookmarkModel {
  var bookmarktitle;
  var bookmarkdesc;

  BookmarkModel({
    required this.bookmarktitle,
    required this.bookmarkdesc,
  });

  factory BookmarkModel.fromJson(Map<String, dynamic> json) => BookmarkModel(
    bookmarktitle: json["bookmarktitle"],
    bookmarkdesc: json["bookmarkdesc"],
  );

  Map<String, dynamic> toJson() => {
    "bookmarktitle": bookmarktitle,
    "bookmarkdesc": bookmarkdesc,
  };
}
List<BookmarkModel> bookmarkModel=[];