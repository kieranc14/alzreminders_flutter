import 'package:flutter/material.dart';



import 'package:parse_server_sdk/parse_server_sdk.dart';

//Keys from back4app
const String PARSE_APP_ID = 'tiX8YRThrJ8u8VH6tb8YH1tH5qUYpqPu1BeGWA0I';
const String PARSE_APP_URL = 'https://parseapi.back4app.com';
const String MASTER_KEY = 'aquEmSjq86lqbVK2MEBQSMHjo3Oo25cUXujrz41T';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Parse().initialize(
    PARSE_APP_ID,
    PARSE_APP_URL,
    masterKey: MASTER_KEY,
    autoSendSessionId: true,
    debug: true,

    //coreStore: await CoreStoreSharedPrefsImp.getInstance(),
  );
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alzreminders Web App',
      home: Home(),
      theme: ThemeData(
        primarySwatch: Colors.blue
      )
    );
  }
}

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> {
  @override
  void initState() {
    _Userload();
    super.initState();
  }

//UserCredential
  ParseUser _parseUser;
//Check User credential -- initState();
  void _Userload() async {
    ParseUser currentUser = await ParseUser.currentUser(); //The current user was saved in the phone with SharedPreferences
    if (currentUser == null) {
      return null;
    } else {
      _parseUser = currentUser;
      print("AUTO LOGIN SUCCESS");
      var result = currentUser.login();
      result.catchError((e) {
        print(e);
      });
    }
  }

//Login
  Future<ParseUser> Login(username, pass, email) async {
    var user = ParseUser(username, pass, email);
    var response = await user.login();
    if (response.success) {
      setState(() {
        _parseUser = user; //Keep the user
      });
      print(user.objectId);
      navigateToAccountPage(context);
    } else {
      print(response.error.message);
      navigateToAccountPage(context);
    }
  }

//Sign UP
  Future<ParseUser> SignUP(username, pass, email) async {
    var user = ParseUser(username, pass,
        email); //kieran later - You can add Columns to user object adding "..set(key,value)"
    var result = await user.create();
    if (result.success) {
      setState(() {
        _parseUser = user; //Keep the user
      });
      print(user.objectId);
    } else {
      print(result.error.message);
    }
  }
//Controllers
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Demo App')
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: usernameController,
            decoration: InputDecoration(
                hintText: 'Username'
            ),
          ),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
                hintText: 'E-mail'
            ),
          ),
          TextField(
            controller: passController,
            decoration: InputDecoration(
                hintText: 'Pass'
            ),
          ),
          FlatButton(
            child: Text('Login'),
            onPressed: () {
              Login(usernameController.text, passController.text,
                  emailController.text);
            },
          ),
          FlatButton(
            onPressed: () {
              SignUP(usernameController.text, passController.text,
                  emailController.text);
            },
            child: Text('Sign Up'),
          ),
          FlatButton(
            child: Text('Logout'),
            onPressed: ()async{
              var user = _parseUser;
              var response = await user.logout();
              if(response.success){
                _parseUser = null;
                print("LOGOFF SUCCESS");
                usernameController.clear();
                emailController.clear();
                passController.clear();
              } else{
                print(response.error.message);
              }
            },
          )
        ],
      ),
    );
  }
}
Future navigateToAccountPage(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => AccountPage()));
}
class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sub Page'),
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Click button to back to Main Page'),
            RaisedButton(
              textColor: Colors.white,
              color: Colors.redAccent,
              child: Text('Back to Main Page'),
              onPressed: () {
                // TODO
              },
            )
          ],
        ),
      ),
    );
  }
}