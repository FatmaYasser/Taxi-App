import 'package:dio/dio.dart';
import 'package:taxi_app/model.dart';

class Network {
  var dio = Dio();
  Future<Model> getData() async {
    Response response = await dio.get(
        'https://fake-poi-api.mytaxi.com/?p1Lat=30.129610&p1Lon=30.864947&p2Lat=29.824722&p2Lon=31.519720');
    Model model = Model.fromJson(response.data);
    return model;
  }
}
