// ignore_for_file: prefer_collection_literals, unnecessary_this

class GetYandexMapImageRequest {
  String? latlon;
  String? size;
  int? zoom;
  String? i;
  String? marker;

  GetYandexMapImageRequest(
      {this.latlon, this.size, this.zoom, this.i, this.marker});

  GetYandexMapImageRequest.fromJson(Map<String, dynamic> json) {
    latlon = json['ll'];
    size = json['size'];
    zoom = json['z'];
    i = json['i'];
    marker = json['pt'];
  }

  Map<String, dynamic> toJson() {
    // ignore: unnecessary_new
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ll'] = this.latlon;
    data['size'] = this.size;
    data['z'] = this.zoom;
    data['i'] = this.i;
    data['pt'] = this.marker;
    return data;
  }
}