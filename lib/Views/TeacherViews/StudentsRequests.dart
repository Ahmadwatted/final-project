import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../Models/student.dart';
import '../../Models/user.dart';
import '/../../Models/clientConfig.dart';


class CategoryDetailsScreen extends StatefulWidget {
  final String? catID;

  CategoryDetailsScreen({Key? key, this.catID,}) : super(key: key);

  @override
  state createState() => state();
}

class state extends State<CategoryDetailsScreen> {
  BuildContext? _context;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;


    return Scaffold(
      // appBar: generalAppBar(context, parts[0], true),
      //   appBar: generalAppBar(sContext:context, title:parts[0], isWithCartIcon:true, isWithSearchIcon:true),
        backgroundColor: Color(0XFFF7F8FA),
        body: FutureBuilder(
          future: getUsers(),
          builder: (context, projectSnap) {
            if (projectSnap.hasData) {
              if (projectSnap.data.length == 0)
              {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 2,
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('אין תוצאות מתאימות', style: TextStyle(fontSize: 25,))
                  ),
                );
              }
              else {
                return ListView.builder(
                  itemCount: projectSnap.data.length,
                  itemBuilder: (context, index) {
                    Student project = projectSnap.data[index];
                    var numm = projectSnap.data.length - 1;
                    int numInt = numm;
                    numm = numm.toString();

                    // project = projectSnap.data[index-1];

                    return Card(
                        child: ListTile(
                          onTap: () {
                            /*
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryProductsDetailsScreen(),
                                settings: RouteSettings(
                                  arguments: '${project.catName}' + globalSeperator + '${project.catID}' + globalSeperator + '',
                                ),
                              ),
                            );
                             */
                          },
                          /*
                          leading: CachedNetworkImage(
                            width: 80,
                            height: 70,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 2,
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: CircularProgressIndicator(
                                        color: kNavigationBarColor,)
                                  ),
                                ),
                            imageUrl: project.thumbImageURL!,
                          ),
  */
                          title: Text(project.firstName!, style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),),

                          isThreeLine: false,
                        ));

                  },
                );
              }
            }
            else if (projectSnap.hasError)
            {
              return  Center(child: Text('שגיאה, נסה שנית', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)));
            }
            return Center(child: new CircularProgressIndicator(color: Colors.red,));
          },
        ));
  }



  //----------------------------------------------------------------------------------------



  Future getUsers() async
  {
    // final String? getInfoDeviceSTR = localStorage.getItem('getInfoDeviceSTR');
    var url = "users/getUsers.php";
    final response = await http.get(Uri.parse("https://darkgray-hummingbird-925566.hostingersite.com/watad/users/getUsers.php"));
    // print(serverPath + url);
    List<User> arr = [];

    for(Map<String, dynamic> i in json.decode(response.body)){
      arr.add(User.fromJson(i));
    }

    return arr;
  }





}
