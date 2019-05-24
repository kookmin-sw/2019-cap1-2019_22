import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mdw_app/create_page.dart';

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
          showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopup(context),
          );
        },
      child: Icon(Icons.delete),
      backgroundColor: Colors.amberAccent,
      ),
    );
  }


  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        '접근 기록',
        style: TextStyle(
            color:Colors.black,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _buildBody(){
    return StreamBuilder(
      stream: Firestore.instance.collection('document').snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
      if(!snapshot.hasData){
        return Center(child: CircularProgressIndicator());
      }

      var items = snapshot.data?.documents ?? [];

      return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 3.5,
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
    return SizedBox(
      child: Card(
        elevation: 4.0,
          child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('일시 : ' + document['datetime']),
                  Padding(padding: EdgeInsets.all(2.0),),
                  Text('장소 : ' + document['location']),
                  Padding(padding: EdgeInsets.all(2.0),),
                  Text('행동 : ' + document['motion']),
                ],
              ),
          ),
      ),
    );
  }

  Widget _buildPopup(BuildContext context) {
    return new AlertDialog(
      title: const Text(
        '전체 기록 삭제',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              '모든 기록을 삭제하시겠습니까?',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('네'),
        ),
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('아니요'),
        ),
      ],
    );
  }


}
