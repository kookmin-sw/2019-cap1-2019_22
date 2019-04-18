import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        'Main',
        style: TextStyle(
            color:Colors.black,
            fontWeight: FontWeight.bold
        ),
      ),
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
                  Text('테스트 메세지입니다.',
                    style: TextStyle(fontSize: 24.0),
                  ),
                  Padding(padding: EdgeInsets.all(8.0),),
                  Text('테스트해보아요'),
                  Padding(padding: EdgeInsets.all(12.0),),
                  SizedBox(
                    width:260.0,
                    child: Card(
                      elevation: 4.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.all(1.0),),
                            SizedBox(
                              width: 80.0,
                              height: 80.0,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(user.photoUrl),
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(8.0),),
                            Text(user.email, style: TextStyle(fontWeight: FontWeight.bold),),
                            Text(user.displayName),
                            Padding(padding: EdgeInsets.all(8.0),),
                            Row(
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
                            ),
                            Padding(padding: EdgeInsets.all(4.0),),
                            Text('자기소개'),
                            Padding(padding: EdgeInsets.all(4.0),),
                            RaisedButton(
                              child: Text('follow'),
                              color: Colors.amberAccent,
                              textColor: Colors.black,
                              onPressed: (){},
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
