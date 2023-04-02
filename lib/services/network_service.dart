import 'package:dio/dio.dart';

class NetworkService {
  Future dioPostRequest(
      {required Map data,
        required String endpointUrl}) async {
    // print(data);
    Dio dio = new Dio();
    dio.options.headers['content-Type'] = 'application/json';

    dio.options.connectTimeout = 30000; //30s
    dio.options.receiveTimeout = 30000; //30s
    String final_url = endpointUrl;
    try {
      var response = await dio.post(final_url, data: data);
      var custom_response = response.data;
      if (!custom_response['success']) {
        return {'error': custom_response['response']['status_message']};
      } else {
        return {'error':false,'message':custom_response['message']['answer']};
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        return {'error': 'Connection timed out'};
      }
      if (e.type == DioErrorType.receiveTimeout) {
        return {'error': 'Receiver timed out'};
      }
      return {'error': 'Something went wrong'};
    }
  }

  Future dioPostRequestImage(
      {required Map data,
        required String endpointUrl}) async {
    print(data);
    Dio dio = new Dio();
    dio.options.headers['content-Type'] = 'application/json';

    dio.options.connectTimeout = 30000; //30s
    dio.options.receiveTimeout = 30000; //30s
    String final_url = endpointUrl;
    try {
      var response = await dio.post(final_url, data: data);
      var custom_response = response.data;
      if (!custom_response['success']) {
        return {'error': custom_response['response']['status_message']};
      } else {
        return {'error':false,'url':custom_response['url']};
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        return {'error': 'Connection timed out'};
      }
      if (e.type == DioErrorType.receiveTimeout) {
        return {'error': 'Receiver timed out'};
      }
      return {'error': 'Something went wrong'};
    }
  }
}