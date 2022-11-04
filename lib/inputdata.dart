import 'dart:async';
import 'dart:io';

void main(){


File file = new File('./assets/DataFile.txt'); // (1)
  Future<String> futureContent = file.readAsString(); 
  futureContent.then((c) => print(c));
}