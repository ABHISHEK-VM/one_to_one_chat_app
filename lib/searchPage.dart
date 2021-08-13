import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:one_to_one_chat_app/Methods.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchTextEditingController = TextEditingController();
  bool isLoading = false;
  late Map<String, dynamic> userMap;

  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
    });
    await _firestore
        .collection('users')
        .where("email", isEqualTo: searchTextEditingController.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SearchScreen'),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: () {
            logOut();
          }), 
        ],
      ),
      body: isLoading
          ? Center(
              child: Container(
                  height: 40, width: 40, child: CircularProgressIndicator()))
          : Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  color: Colors.grey,
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                        controller: searchTextEditingController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Search username...",
                          hintStyle: TextStyle(
                            color: Colors.white54,
                          ),
                          border: InputBorder.none,
                        ),
                      )),
                      GestureDetector(
                        onTap: () {
                          onSearch();
                        },
                        child: Container(child: Icon(Icons.search)),
                      ),
                    ],
                  ),
                ),
                userMap!= null ? ListTile(

                  onTap:(){},
                  title: Text(userMap['name']),
                  subtitle: Text(userMap['email']),
                  trailing: Icon(Icons.chat, color: Colors.black),
                  leading: Icon(Icons.account_box, color: Colors.black),
                ) : Container(),
              ],
            ),
    );
  }
}
