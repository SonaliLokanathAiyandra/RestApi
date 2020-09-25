import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'friendList.dart';
import 'models/constants.dart';
class PhoneVerification extends StatefulWidget {
  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  String smsCode;
  String verificationCode;
  String number;


  void showToast(){
    Fluttertoast.showToast(
        msg:'enter phone number..',
        toastLength:Toast.LENGTH_SHORT,
        gravity:ToastGravity.CENTER,
        //timeInSecForIos:1,
        backgroundColor:Colors.blueGrey,
        textColor:Colors.white
    );
  }

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
      body:
            Stack(
              children:<Widget>[
                Center(
                  child: Container(
                     decoration: BoxDecoration(
                       image: DecorationImage(
                         image: NetworkImage("https://images.pexels.com/photos/2083302/pexels-photo-2083302.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
                          ),
                           fit: BoxFit.cover
                       ),
                     ),
                  height: double.infinity,
                  child: SingleChildScrollView(
                   physics: AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(0, 250, 0, 20),
                    child: Column(
                      children: [
                        Text("Signup...",
                          style: HTextStyle,
                              ),
                                Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  child: TextField(
                                    keyboardType: TextInputType.phone,
                                    obscureText: false,
                              onChanged: (val){
                                  number=val;
                              },
                              cursorColor: Colors.green[900],
                              style: TextStyle(
                                  height: 1,
                              ),
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                    filled: true,
                                    prefixIcon: GestureDetector(
                                      child: Icon(Icons.phone,
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: "Enter Phone Number",
                                    hintStyle: TextStyle1,

                              ),
                              ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(50,5.0,50,0.0),
                                  child: ButtonTheme(
                                  height: 50,
                                  minWidth: width,
                                  child: RaisedButton.icon(
                                    onPressed:(){
                                      _submit();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => HomePage()),
                                      );
                                      showToast();
                                    },

                                    icon: Icon(Icons.send,color: Colors.white,),
                                    label: Text("Send code"),
                                    color: Colors.red,
                                    textColor: Colors.white,
                                    splashColor: Colors.green[800],
                                  ),
                              ),
                                ),
                        ],
                      ),
            ),
            ),
                ),
      ],
    )
    );
  }
  Future<void> _submit() async {
    final PhoneVerificationCompleted verificationSuccess = (AuthCredential credential) {
      setState(() {
        print("Verification");
        print(credential);

      });
    };

    final PhoneVerificationFailed phoneVerificationFailed = (
        AuthException exception) {
      print("${exception.message}");
    };
    final PhoneCodeSent phoneCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationCode = verId;
      smsCodeDialog(context).then((value) => print("Signed In"));
    };

    final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verId) {

      this.verificationCode = verId;
    };


    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: this.number,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationSuccess,
        verificationFailed: phoneVerificationFailed,
        codeSent: phoneCodeSent,
        codeAutoRetrievalTimeout: autoRetrievalTimeout
    );
  }
  Future<bool> smsCodeDialog(BuildContext context){
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Enter Code",
              style: TextStyle(
                color: Colors.green[900],
              ),
            ),
            content: TextField(
              onChanged: (Value){
                smsCode=Value;
              },
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                child: Text("Verify",
                  style: TextStyle(
                    color: Colors.green[900],
                  ),
                ),
                onPressed: (){
                  FirebaseAuth.instance.currentUser().then((user){
                    if(user!=null){
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    }
                    else{
                      Navigator.of(context).pop();
                      signIn();
                    }
                  });
                },
              )
            ],
          );
        }
    );
  }
  signIn() {
    AuthCredential phoneAuthCredential = PhoneAuthProvider.getCredential(
        verificationId: verificationCode, smsCode: smsCode);
    FirebaseAuth.instance.signInWithCredential(phoneAuthCredential)
        .then((user) =>  Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    )).catchError((e) => print(e));
  }
}