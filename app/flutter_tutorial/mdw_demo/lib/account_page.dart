import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AccountPage extends StatefulWidget {
  final FirebaseUser user;

  AccountPage(this.user);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      actions: <Widget>[
        IconButton(
          icon:  Icon(Icons.exit_to_app),
          onPressed: (){
            FirebaseAuth.instance.signOut();
            _googleSignIn.signOut();
          },
        )
      ],
    );
  }

  Widget _buildBody(){
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  SizedBox(
                    width: 80.0,
                    height: 80.0,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(widget.user.photoUrl),
                    ),
                  ),
                  Container(
                    width: 80.0,
                    height: 80.0,
                    alignment: Alignment.bottomRight,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 28.0,
                          height: 28.0,
                          child: FloatingActionButton(onPressed: null,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.add),
                          ),
                        ),
                        SizedBox(
                          width: 25.0,
                          height: 25.0,
                          child: FloatingActionButton(onPressed: null,
                            backgroundColor: Colors.amberAccent,
                            child: Icon(Icons.add),
                          ),
                        ),
                      ],
                    )
                  )
                ],
              ),
              Text(
                  widget.user.displayName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              )
            ],
          ),
          Text(
              '0\n게시물',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.0),
          ),
          Text(
              '0\n게시',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.0),
          ),
          Text(
              '0\n게',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      ),
    );
  }
}
