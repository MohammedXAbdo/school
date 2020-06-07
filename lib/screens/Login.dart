import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infixedu/screens/AdmissionWebView.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/server/Login.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  String user;
  String email;
  Future<String> futureEmail;
  String password = '123456';
  bool isResponse = false;


  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = Theme.of(context).textTheme.title;

    return Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          key: _formKey,
          child: Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage('images/login_bg.png'),
                      fit: BoxFit.fill,
                    )),
                    child: Center(
                      child: Container(
                        height: 150.0,
                        width: 150.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage('images/inflex_edu_logo.png'),
                        )),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height / 2,
                    child: ListView(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: FlatButton(
                                onPressed: () {
                                  user = 'student';
                                  futureEmail = getEmail(user);
                                  futureEmail.then((value){
                                    setState(() {
                                      email = value;
                                      emailController.text = email;
                                      passwordController.text = password;
                                    });
                                  });
                                },
                                color: Colors.purpleAccent,
                                textColor: Colors.white,
                                child: Text("Student",style: Theme.of(context).textTheme.display1.copyWith(color: Colors.white),),
                              ),
                            ),
                            Expanded(
                              child: FlatButton(
                                onPressed: () {
                                  setState(() {
                                    user = 'teacher';
                                    futureEmail = getEmail(user);
                                    futureEmail.then((value){
                                      setState(() {
                                        email = value;
                                        emailController.text = email;
                                        passwordController.text = password;
                                      });
                                    });
                                  });
                                },
                                color: Colors.purpleAccent,
                                textColor: Colors.white,
                                child: Text("Teacher",style: Theme.of(context).textTheme.display1.copyWith(color: Colors.white)),
                              ),
                            ),
                            Expanded(
                              child: FlatButton(
                                onPressed: () {
                                  user = 'parent';
                                  futureEmail = getEmail(user);
                                  futureEmail.then((value){
                                    setState(() {
                                      email = value;
                                      emailController.text = email;
                                      passwordController.text = password;
                                    });
                                  });
                                },
                                color: Colors.purpleAccent,
                                textColor: Colors.white,
                                child: Text("Parents",style: Theme.of(context).textTheme.display1.copyWith(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            style: textStyle,
                            controller: emailController,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'please enter a valid email';
                              }
                              return value;
                            },
                            decoration: InputDecoration(
                                hintText: "email",
                                labelText: "Email",
                                labelStyle: textStyle,
                                errorStyle: TextStyle(
                                    color: Colors.pinkAccent, fontSize: 15.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: TextFormField(
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            style: textStyle,
                            controller: passwordController,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'please enter a valid password';
                              }
                              return value;
                            },
                            decoration: InputDecoration(
                                hintText: "password",
                                labelText: "Password",
                                labelStyle: textStyle,
                                errorStyle: TextStyle(
                                    color: Colors.pinkAccent, fontSize: 15.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                )),
                          ),
                        ),
                        GestureDetector(
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            height: 50.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Colors.purple,
                            ),
                            child: Text(
                                "Login",
                                style: Theme.of(context).textTheme.headline.copyWith(
                                  color: Colors.white
                                ),
                              ),
                          ),
                          onTap: () {

                            String email = emailController.text;
                            String password = passwordController.text;


                            if(email.length > 5 && password.length > 5){
                              setState(() {
                                isResponse = true;
                              });
                              Login(email, password).getData(context).then((result)=>{
//                                if(result){
//                                  debugPrint('success')
//                                }
                              });
                            }else{
                              setState(() {
                                isResponse = false;
                              });
                              Utils.showToast('invalid email and password');
                            }
//                            setState(() {
//                              if (_formKey.currentState.validate()) {
//
//                                Utils.showToast('${emailController.text}  ${passwordController.text}');
//
//                                String email = emailController.text;
//                                String password = passwordController.text;
//
//                                debugPrint('$email  $password');
//
//                                Login(email, password).getData(context).then((result)=>{
//                                  if(result){
//                                    debugPrint('success')
//                                  }
//                                });
//                              }
//                            });
                          },
                        ),

                        /// Admission
                        Padding(
                          padding: EdgeInsets.only(left:MediaQuery.of(context).size.width / 4, top:MediaQuery.of(context).size.width / 40, right:MediaQuery.of(context).size.width / 4),
                          child: GestureDetector(
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width / 4,
                              height: 40.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: Colors.purple,
                              ),
                              child: Text(
                                'Admission',
                                style: Theme.of(context).textTheme.headline.copyWith(
                                    color: Colors.white
                                ),
                              ),
                            ),
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AdmissionWebView())),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: isResponse == true ? LinearProgressIndicator(
                            backgroundColor: Colors.transparent,
                          ):Text(''),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<String> getEmail(String user) async{

    final response = await http.get(InfixApi.getEmail);

    var jsonData = json.decode(response.body);

    return jsonData['data'][user]['email'];
  }

}
