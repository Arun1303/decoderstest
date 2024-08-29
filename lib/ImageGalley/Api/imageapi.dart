import 'dart:convert';

import '../model/imagemodel.dart';
import 'package:http/http.dart' as http;

class APIService {
  var base_url = 'https://api.slingacademy.com/v1/sample-data/photos';

  Future<List<Photo>> getPhotos() async {
    try {
      var getData = await http.get(Uri.parse(base_url));
      if (getData.statusCode == 200) {
        ImageModel model = ImageModel.fromJson(jsonDecode(getData.body));
        return model.photos;
      } else {
        return [];
      }
    } catch (e) {
      throw e;
      
    }
  }
}
