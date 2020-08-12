import 'package:dio/dio.dart';
import 'package:get_pet/global/secrets.dart';

class HttpService {
  final Dio dio = Dio();

  Future<Response> addNewShelter(Map data) async =>
      await _putRequest({'fun': 'add_new_shelter'}, data);

  Future<Response> searchShelters(String latitude, String longitude) async =>
      await _getRequest({
        'fun': 'search_shelters',
        'latitude': latitude,
        'longitude': longitude
      });

  Future<Response> searchAddress(String address) async {
    return await dio.get(
        'https://nominatim.openstreetmap.org/search?q=$address&format=geojson');
  }

  // Future<Response> uploadImageToBucket(PickedFile image) async =>
  //     await _postRequest({'fun': 'upload_image'},
  //         {'name': 'test2', 'data': await imageToBase64(image)});

  Future<Response> _postRequest(
          Map<String, dynamic> queryParameters, dynamic data) async =>
      await dio.post(
        kAWSLambdaLink,
        // data: data,
        queryParameters: queryParameters,
        data: data,
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status < 503;
          },
          // receiveDataWhenStatusError: true,
          headers: {'x-api-key': kAWSLambdaApiKey},
        ),
      );

  Future<Response> _getRequest(Map<String, dynamic> queryParameters) async =>
      await dio.get(
        kAWSLambdaLink,
        // data: data,
        queryParameters: queryParameters,
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status < 503;
          },
          // receiveDataWhenStatusError: true,
          headers: {'x-api-key': kAWSLambdaApiKey},
        ),
      );

  Future<Response> _putRequest(
          Map<String, dynamic> queryParameters, dynamic data) async =>
      await dio.put(
        kAWSLambdaLink,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status < 503;
          },
          // receiveDataWhenStatusError: true,
          headers: {'x-api-key': kAWSLambdaApiKey},
        ),
      );
}
