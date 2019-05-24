import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final FirebaseUser user;

  HomePage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildAppBar(){
    return AppBar(
      title: Text(
        'MDW',
        style: TextStyle(
            color:Colors.black,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _buildBody(){
    return StreamBuilder(
      stream: Firestore.instance.collection('alarm').snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator());
        }

        var items = snapshot.data?.documents ?? [];

        return PageView.builder(
            itemCount: items.length,
            itemBuilder: (context, index){
              if(items[index]['state'] == 'warning') {
                return _buildListItem(context, items[index]);
              }
            });
      },
    );
  }

  Widget _buildListItem(context, document) {
    return Container(
      decoration: BoxDecoration(color: Colors.black54),
      child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 200.0,
                height: 200.0,
                child: Image.network(
                  document['photoUrl'],
                  fit: BoxFit.cover,
                ),
              ),
              Padding(padding: EdgeInsets.all(4.0),),
              Text('구역 내 접근 감지!', style: TextStyle(color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0),)
            ],
          )
      ),
    );
  }
}
