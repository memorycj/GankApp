class ItemData {
  String id;
  String createdAt;
  String desc;
  String publishedAt;
  String source;
  String type;
  String url;
  bool used;
  String who;
  List<String> images;

  ItemData(
      {this.id,
        this.createdAt,
        this.desc,
        this.publishedAt,
        this.type,
        this.source,
        this.url,
        this.used,
        this.who});

  factory ItemData.fromJson(jsonMap) {
    final itemdata = ItemData(
        id: jsonMap["_id"] as String,
        createdAt: jsonMap["createdAt"],
        desc: jsonMap["desc"],
        publishedAt: jsonMap["publishedAt"],
        source: jsonMap["source"],
        type: jsonMap["type"],
        url: jsonMap["url"],
        who: jsonMap["who"],
        used: jsonMap["used"]);
    if (jsonMap["images"] != null) {
      itemdata.images = [];
      for (var imageUrl in jsonMap["images"]) {
        itemdata.images.add(imageUrl);
      }
    }
    return itemdata;
  }

  @override
  String toString() {
    return 'ItemData{id: $id, createdAt: $createdAt, desc: $desc, publishedAt: $publishedAt, source: $source, type: $type, url: $url, used: $used, who: $who}';
  }
}
