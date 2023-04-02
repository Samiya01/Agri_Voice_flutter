import 'package:agri_voice/services/network_service.dart';
import 'package:agri_voice/values.dart';

class ImageController {
  Future getCommands({required String statement})async {
    var data = {
    "query": imagePrefixExample+statement+imageSurfix,
    };
   var response = await NetworkService().dioPostRequest(data: data, endpointUrl: endpointUrl);
   if(!response['error']){
     String result = response['message'];
     print(result);
     if(result.contains(imageNoCommand)){
       return {'hasCommands':false};
     }else{
       return {
         'hasCommands':true,
         'commands': result.split('*')
       };
     }
   }
  }

  Future getImageUrl({required String command})async {
    var data = {
      "caption": command,
    };
    var response = await NetworkService().dioPostRequestImage(data: data, endpointUrl: endpointUrlImage);
    if(!response['error']){
      return response['url'];
    }
  }

}