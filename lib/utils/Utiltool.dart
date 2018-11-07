import 'dart:convert';

String decodeBase64(String data){
  String str = utf8.decode(base64.decode(data));
  var strJson = json.decode(str);
  if(strJson is String){
    return strJson.toString();
  }
  return str;
}