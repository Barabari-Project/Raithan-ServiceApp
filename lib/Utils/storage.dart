
import 'package:get_storage/get_storage.dart';

class Storage{
  static final storage = GetStorage();

  static void writeData(String key,String value){
    storage.write(key, value);
  }
  static String readData(String key){
    return storage.read(key);
  }
  static bool isExist(String key){
    return storage.hasData(key);
  }
  static void removeData(String key){
    storage.remove(key);
  }
  static void removeAllData(){
    storage.erase();
  }
}