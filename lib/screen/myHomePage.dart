import 'package:api_curd/model/dataModel.dart';
import 'package:api_curd/provider/homepageprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/dbhelper.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late HomePageProvider homePageProvider;
late  Future<List<DataModel>> noteList ;

    @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    homePageProvider =  Provider.of<HomePageProvider>(context ,listen: false);
    homePageProvider.allData();
    loadData();
    super.didChangeDependencies();
  }


  @override
  void dispose() {
    super.dispose();
  }

  loadData() async{
      noteList = DatabaseHelper.instance.getAll();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("List Data"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<DataModel>>(
              future: noteList,
              builder: (context,snapshot) {
                print('Start builder');
                print(snapshot.data?.length.toString());
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No users found.'));
                  } else {
                    return  ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(snapshot.data![index].title.toString()),
                            leading: Text(snapshot.data![index].userId.toString()),
                            subtitle: Text(snapshot.data![index].body.toString()),
                          );
                        });
                  }



              }
            ),
          ),
        ],
      ),
    );
  }
}
