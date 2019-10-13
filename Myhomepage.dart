import 'package:flutter/material.dart';
import 'package:registration/Screens/location.dart';
import 'package:registration/Screens/phoneauthscreen.dart';
import 'package:registration/Screens/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:registration/Logic/CreateAccount.dart';
import 'package:firebase_auth/firebase_auth.dart';



final GoogleSignIn googlesignin = GoogleSignIn();

final userref = Firestore.instance.collection('users');

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _email;
  String _password;

showAlertDialog(BuildContext context,String text) {

  // set up the buttons
  
  Widget continueButton = FlatButton(
    child: Text("Ok"),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("AlertDialog"),
    content: Text("$text"),
    actions: [
     
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

  // Google sign in code Start

  bool _isAuth = false;

  @override
  void initState() {
    super.initState();
    googlesignin.onCurrentUserChanged.listen((user) {
      if (user != null) {
        createUsersInFirestore();

        setState(() {
          
          _isAuth = true;
        });
      } else {
        setState(() {
          _isAuth = false;
        });
      }
    }, onError: (err) {
      print("Error Signing in $err");
    });


    googlesignin.signInSilently(suppressErrors: false).then((user) {
      if (user != null) {
        createUsersInFirestore();
        print("User Signed in to $user");

        setState(() {
          _isAuth = true;
        });
      } else {
        setState(() {
          _isAuth = false;
        });
      }
    }).catchError((err) {
      print("Error is $err ");
    });
  }

  createUsersInFirestore() async {
    // check to see if user exist in user collection in database

    final GoogleSignInAccount user = googlesignin.currentUser;

    final DocumentSnapshot doc = await userref.document(user.id).get();
    final DateTime timestamp = DateTime.now();

    if (!doc.exists) {
      final username = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateAccount()));

      userref.document(user.id).setData({
        "id": user.id,
        "username": username,
        "photoUrl": user.photoUrl,
        "email": user.email,
        "displayName": user.displayName,
        "bio": "",
        "timeStamp": timestamp
      });
    }

    // if user is not exist, take them to create username page

    // we will create user
  }

  login() {
    googlesignin.signIn();
    Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Location()));
  }

  logout() {
    googlesignin.signOut();
    FirebaseAuth.instance.signOut();

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyHomePage()));
  }

  // Widget buildAuthScreen() {
  //   return Scaffold(
  //     key: _scaffoldKey,
  //     body: Center(
  //       child: Column(
  //         children: <Widget>[
  //           Container(
  //             child: Center(
  //               child: RaisedButton(
  //                 child: Text("Logout"),
  //                 onPressed: logout,
  //               ),
  //             ),
  //           ),
  //           Container(
  //             child: Center(
  //               child: RaisedButton(
  //                 child: Text("Location"),
  //                 onPressed: () {
  //                   Navigator.push(context,
  //                       MaterialPageRoute(builder: (context) => Location()));
  //                 },
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Color textcolor = Color(0xff686C80);

  @override
  Widget build(BuildContext context) {
    return buildUnAuthScreen();
  }

  Widget buildUnAuthScreen() {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xffEEF0F7),
        resizeToAvoidBottomPadding: false,
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Container(
                  padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                  child: Text(
                    'Welcome',
                    style: TextStyle(
                        fontSize: 40.0, letterSpacing: 1, color: textcolor),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                  padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        onChanged: (val) {
                          setState(() {
                            _email = val;
                          });
                        },
                        decoration: InputDecoration(
                            labelText: 'USERNAME',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: textcolor))),
                      ),
                      SizedBox(height: 20.0),
                      TextField(
                        onChanged: (val) {
                          setState(() {
                            _password = val;
                          });
                        },
                        decoration: InputDecoration(
                            labelText: 'PASSWORD ',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: textcolor))),
                        obscureText: true,
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        child: Text(
                          "Forgot Password?",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ),
                    
                      SizedBox(height: 20.0),
                      Container(
                        height: 40.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: textcolor,
                          color: textcolor,
                          elevation: 7.0,
                          child: RaisedButton(
                            onPressed: () {
                              FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: _email, password: _password)
                                  .then((FirebaseUser user) {

                                    if(user != null){
                                      Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Location()));
                                    }

   
                              }).catchError((e) {
                                print(e);

                                showAlertDialog(context, "$e");
                                
                           
                              
                              });
                            },
                            child: Center(
                              child: Text(
                                'LOGIN',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpPage()),
                          );
                        },
                        child: Container(
                          child: Text(
                            "Have an account? Register here",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        height: 40.0,
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black,
                                  style: BorderStyle.solid,
                                  width: 1.0),
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20.0)),
                          child: InkWell(
                            onTap: login,
                            child: Center(
                              child: Text('Login With Google',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat')),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        height: 40.0,
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black,
                                  style: BorderStyle.solid,
                                  width: 1.0),
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20.0)),
                          child: InkWell(
                            onTap: (){
                            //   fbLogin.logInWithReadPermision();

                              Navigator.push(context, MaterialPageRoute(builder: (context) => Authentication()));
                            },
                            child: Center(
                              child: Text('Login With Facebook',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat')),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        height: 40.0,
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black,
                                  style: BorderStyle.solid,
                                  width: 1.0),
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20.0)),
                          child: InkWell(
                            onTap: (){

                              Navigator.push(context, MaterialPageRoute(builder: (context) => Authentication()));
                            },
                            child: Center(
                              child: Text('Login With Phone Number',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat')),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ]));
  }
}
