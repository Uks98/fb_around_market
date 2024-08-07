class Favorite {
  String? imagePath;
  String? categories;
  String? marketName;
  String? kindOfCash;

  Favorite(
      {required this.imagePath, required this.categories,
        required this.marketName, required this.kindOfCash,});
  Map<String, dynamic> toJson() {
    return {
      'imagePath': imagePath?? "데이터가 없습니다",
      'categories': categories?? "데이터가 없습니다",
      'marketName': marketName?? "데이터가 없습니다",
      'kindOfCash': kindOfCash?? "데이터가 없습니다",
    };
  }
  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      imagePath: json['imagePath'] ?? 'a',
      categories: json['categories'] ?? 'a',
      marketName: json['marketName'] ?? 'a',
      kindOfCash: json['kindOfCash'] ?? 'a',
    );
  }
  }
