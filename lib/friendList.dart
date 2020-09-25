import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'models/constants.dart';
import 'models/loader.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Map data;
  List userData;

  Future getData() async {
    http.Response response = await http.get("https://reqres.in/api/users?page=2");
    data = json.decode(response.body);
    setState(() {
      userData = data["data"];
    });
  }

  String uid;

  @override
  void initState() {
    this.uid = "";
    FirebaseAuth.instance.currentUser().then((val) {
      setState(() {
        this.uid = val.uid;
      });
    });
    getData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
        child: ClipPath(
          clipper: CustomAppBar(
          ),
          child: Container(color: Colors.cyan[200],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Connections....',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 30
                  ),
                )
               ],
            ),
          ),
        ),
        preferredSize: Size.fromHeight(kToolbarHeight +50),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        index: 0,
        items:<Widget>[
          Icon(Icons.home, size: 30,),
          Icon(Icons.search, size: 30,),
          Icon(Icons.account_circle, size: 30,),
        ],
        color: Colors.cyan[200],
        buttonBackgroundColor: Colors.white70,
        backgroundColor: Colors.yellowAccent,
        animationDuration: Duration(milliseconds: 800),
        onTap: (index){
          setState(() {
          });
        },
      ),
    body:

      Container(
        color: Colors.grey[100],
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: userData == null ? 0 : userData.length,
          itemBuilder: (BuildContext context, int index) {
             return Card(
              color: Colors.white,
              shadowColor: Colors.lightGreenAccent,
              child: ListTile(
                leading:
                CircleAvatar(
                  backgroundImage: NetworkImage(userData[index]["avatar"]),
                ),
         title:
         Text("${userData[index]["first_name"]} ${userData[index]["last_name"]}",
           style: fLabelStyle,
           ),
         subtitle:
                Text("${userData[index]["email"]}",
                  style: fLabelStyle2,
                  ),
              ),
            );
          },
        ),
      ),
    );
  }
}