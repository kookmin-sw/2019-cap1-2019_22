import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mdw_demo/create_page.dart';

class SearchPage extends StatefulWidget {
  final FirebaseUser user;

  SearchPage(this.user);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreatePage(widget.user)));
        },
      child: Icon(Icons.create),
      backgroundColor: Colors.amberAccent,
      ),
    );
  }


  Widget _buildAppBar() {
    return AppBar(
    );
  }

  Widget _buildBody(){
    return StreamBuilder(
      stream: Firestore.instance.collection('post').snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
      if(!snapshot.hasData){
        return Center(child: CircularProgressIndicator());
      }

      var items = snapshot.data?.documents ?? [];

      return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.0,
              mainAxisSpacing: 1.0,
              crossAxisSpacing: 1.0
          ),
          itemCount: items.length,
          itemBuilder: (context, index){
            return _buildListItem(context,items[index]);
          });
      },
    );

  }
  
  Widget _buildListItem(context, document){
    return Image.network(
      document['photoUrl'],
      fit: BoxFit.cover,
    );
  }
}
