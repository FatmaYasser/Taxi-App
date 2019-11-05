class Model {
  List<PoiList> poiList;

  Model({this.poiList});

  Model.fromJson(Map<String, dynamic> json) {
    if (json['poiList'] != null) {
      poiList = new List<PoiList>();
      json['poiList'].forEach((v) {
        poiList.add(new PoiList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.poiList != null) {
      data['poiList'] = this.poiList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PoiList {
  int id;
  Coordinate coordinate;
  String fleetType;
  double heading;

  PoiList({this.id, this.coordinate, this.fleetType, this.heading});

  PoiList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    coordinate = json['coordinate'] != null
        ? new Coordinate.fromJson(json['coordinate'])
        : null;
    fleetType = json['fleetType'];
    heading = json['heading'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.coordinate != null) {
      data['coordinate'] = this.coordinate.toJson();
    }
    data['fleetType'] = this.fleetType;
    data['heading'] = this.heading;
    return data;
  }
}

class Coordinate {
  double latitude;
  double longitude;

  Coordinate({this.latitude, this.longitude});

  Coordinate.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
