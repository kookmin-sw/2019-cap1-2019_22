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
      title: Text(
        '사용자 정보',
        style: TextStyle(
            color:Colors.black,
            fontWeight: FontWeight.bold
        ),
      ),
      /*actions: <Widget>[
        IconButton(
          icon:  Icon(Icons.exit_to_app),
          onPressed: (){
            FirebaseAuth.instance.signOut();
            _googleSignIn.signOut();
          },
        )
      ],*/
    );
  }

  Widget _buildBody(){
    return SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(8.0),
          child: SafeArea(
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.all(40.0)),
                  SizedBox(
                    width:260.0,
                    child: Card(
                      elevation: 4.0,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.all(1.0),),
                            SizedBox(
                              width: 80.0,
                              height: 80.0,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(widget.user.photoUrl),
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(6.0),),
                            Text(widget.user.displayName, style: TextStyle(fontWeight: FontWeight.bold),),
                            Text(widget.user.email),
                            Padding(padding: EdgeInsets.all(8.0),),
                           /* Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width: 70.0,
                                  height: 70.0,
                                  child: Image.network('https://github.com/kookmin-sw/2019-cap1-2019_22/blob/master/Images/MDW.PNG?raw=true'
                                  ),
                                ),
                                Padding(padding: EdgeInsets.all(1.0),),
                                SizedBox(
                                  width: 70.0,
                                  height: 70.0,
                                  child: Image.network('https://github.com/kookmin-sw/2019-cap1-2019_22/blob/master/Images/MDW.PNG?raw=true'
                                  ),
                                ),
                                Padding(padding: EdgeInsets.all(1.0),),
                                SizedBox(
                                  width: 70.0,
                                  height: 70.0,
                                  child: Image.network('https://github.com/kookmin-sw/2019-cap1-2019_22/blob/master/Images/MDW.PNG?raw=true'
                                  ),
                                ),
                              ],
                            ),*/
                            Padding(padding: EdgeInsets.all(4.0),),
                            Text('MDW 등록 위치 : 국민대학교'),
                            Padding(padding: EdgeInsets.all(4.0),),
                            RaisedButton(
                              child: Text('Log out'),
                              color: Colors.amberAccent,
                              textColor: Colors.black,
                              onPressed: (){
                                FirebaseAuth.instance.signOut();
                                _googleSignIn.signOut();
                              },
                            ),
                            Padding(padding: EdgeInsets.all(4.0),),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}
