import 'dart:convert';

import 'package:api_curd/model/dataModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart'as http;

import '../database/dbhelper.dart';

class HomePageProvider extends ChangeNotifier{
bool loading = false;
DataModel dataModel = DataModel();
List<DataModel> todo =[];

//<List<DataModel>>

Future<void> allData() async{
  loading =true;
  var uri = 'https://jsonplaceholder.typicode.com/posts';
  var url = Uri.parse(uri);
  var response =await http.get(url);

  var data = jsonDecode(response.body.toString());
  print(response.statusCode);
  if(response.statusCode == 200){
    notifyListeners();
    print('Data upload');
    loading = false;
    print('Data  ${data['id']}');
    todo.addAll(data);
    print('Data length ${todo.length}');
    DataModel.fromJson(data);
    for(Map item in data){



      final items = DataModel(
          id:item['id'],
          userId:item['userId'],
          body:item['body'],
          title:item['title']
      );
      print('Data insert ${items.toString()}');
     await DatabaseHelper.instance.insertData(items);

    }
    
    print(todo.length.toString());


 // return todo;
  }else{
// return todo;
     const Center(child: Text('No Internet'));
  }

}



}