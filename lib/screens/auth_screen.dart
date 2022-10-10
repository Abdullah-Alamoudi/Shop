import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/http_exception.dart';

import '../providers/auth.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key key}) : super(key: key);
  static const routename = '/auth';

  @override
  Widget build(BuildContext context) {
    final devicesize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                      Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0, 1])),
          ),
          SingleChildScrollView(
            child: Container(
              height: devicesize.height,
              width: devicesize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                      child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 94),
                    transform: Matrix4.rotationZ(-8 * pi / 180)
                      ..translate(-10.0),
                    decoration: BoxDecoration(
                        color: Colors.deepOrange.shade900,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 8,
                              color: Colors.black26,
                              offset: Offset(0, 2))
                        ]),
                    child: Text(
                      'My shop',
                      style: TextStyle(
                          color:
                              Theme.of(context).accentTextTheme.headline6.color,
                          fontSize: 50,
                          fontFamily: 'Anton'),
                    ),
                  )),
                  Flexible(
                      flex: devicesize.width > 600 ? 2 : 1, child: AuthCard())
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({Key key}) : super(key: key);

  @override
  State<AuthCard> createState() => _AuthCardState();
}

enum AuthMode { SignUp, LogIn }

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _fromkey = GlobalKey();
  AuthMode _authMode = AuthMode.LogIn;

  Map<String, String> _authData = {'email': '', 'password': ''};
  var _isloading = false;
  final _passwordcontroller = TextEditingController();

  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<double> _opicityAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    _slideAnimation = Tween<Offset>(begin: Offset(0, -0.15), end: Offset(0, 0))
        .animate(
            CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));

    _opicityAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  Future<void> _submit()async{
    if(!_fromkey.currentState.validate()){
      return;
    }
    FocusScope.of(context).unfocus();
    _fromkey.currentState.save();
    setState(() {
      _isloading=true;
    });

    try {
      if(_authMode==AuthMode.LogIn){
        await Provider.of<Auth>(context,listen: false).login(_authData['email'], _authData['password']);
      }else{
        await Provider.of<Auth>(context,listen: false).signUp(_authData['email'], _authData['password']);
      }
      
    } 
    // on HttpException catch(error){
    //     var errorMessage='Authentcation Failed';
    //     if(error.toString().contains('EMAIL_EXISTS')){
    //       errorMessage='This email address is already in use.';
    //     }else if(error.toString().contains('INVALID_EMAIL')){
    //       errorMessage='This is not a valid email address.';
    //     }else if(error.toString().contains('WEAK_PASSWORD')){
    //       errorMessage='This password is too weak.';
    //     }else if(error.toString().contains('EMAIL_NOT_FOUND')){
    //       errorMessage='Could not find a user with that email.';
    //     }else if(error.toString().contains('INVALID_PASSWORD')){
    //       errorMessage='INVALID password.';
    //     }
    //     _showErrorDialog(errorMessage);
    // }
    
    catch (e) {
      const errorMessage='Could not authenticate you. Please try again later';
      _showErrorDialog(errorMessage);
      print('Abdullah');
    }

    setState(() {
      _isloading=false;
    });
  }
    void _showErrorDialog(String message) {
      showDialog(
        context: context,
         builder: (ctx)=>AlertDialog(
          title: Text('An Error Occured!'),
          content: Text(message),
          actions: [
            FlatButton(
              onPressed: ()=>Navigator.of(ctx).pop(),
               child: Text('okay!'))
          ],
         ));
    }

  void _switchAuthMode(){
    if(_authMode==AuthMode.LogIn){
      setState(() {
        _authMode=AuthMode.SignUp;
      });
      _controller.forward();
    }else{
      setState(() {
        _authMode=AuthMode.LogIn;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final devicesize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)),
        elevation: 8,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
          height: _authMode==AuthMode.SignUp?320:260,
          constraints: BoxConstraints(minHeight: _authMode==AuthMode.SignUp?320:260),
          width: devicesize.width*0.75,
          padding: EdgeInsets.all(16),
          child: Form(
            key: _fromkey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'E-mail'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (val){
                      if(val.isEmpty|| !val.contains('@')){
                        return 'Invalid email';
                      }
                      return null;
                    },
                    onSaved: (val){
                      _authData['email']=val;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    controller: _passwordcontroller,
                    validator: (val){
                      if(val.isEmpty||val.length<5){
                        return 'Password is too short!';
                      }
                      return null;
                    },
                    onSaved: (val){
                      _authData['password']=val;
                    },
                  ),
                  AnimatedContainer(
                    constraints: BoxConstraints(
                      minHeight: _authMode==AuthMode.SignUp?60:0,
                      maxHeight: _authMode==AuthMode.SignUp?60:0
                      ),
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                      child: FadeTransition(
                        opacity: _opicityAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: TextFormField(
                            enabled:_authMode== AuthMode.SignUp,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _authMode== AuthMode.SignUp?(val){
                      if(val!=_passwordcontroller.text){
                        return 'Password do not match!';
                      }
                      return null;
                    }:null,
                    onSaved: (val){
                      _authData['password']=val;
                    },
                  ),
                        ),
                      ),
                  )
                ,SizedBox(height: 20,),
                if(_isloading)CircularProgressIndicator(),
                RaisedButton(
                  child: Text(_authMode==AuthMode.LogIn?'LOGIN':'SIGNUP'),
                  onPressed: _submit,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30,vertical: 8),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).primaryTextTheme.headline6.color,
                ),
                FlatButton(
                  onPressed: _switchAuthMode,
                   child: Text('${_authMode==AuthMode.LogIn?'SIGNUP':'LOGIN'} INSTED'),
                   padding: EdgeInsets.symmetric(horizontal: 30,vertical: 8),
                  textColor: Theme.of(context).primaryColor
                   ),
                   
                ],
              ),
            ),
          ),
        ),
    );
  }
  

}
