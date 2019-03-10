import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trojan_mobile_manager/service.dart';
import 'package:trojan_mobile_manager/user.dart';

void main() => runApp(StateContainer(child:new MyApp()));

class StateContainer extends StatefulWidget{
  final Widget child;
  StateContainer({
    @required this.child
  });
  // This is the secret sauce. Write your own 'of' method that will behave
  // Exactly like MediaQuery.of and Theme.of
  // It basically says 'get the data from the widget of this type.
  static StateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer)
            as _InheritedStateContainer).data;
  }
  @override
  StateContainerState createState() {
    return StateContainerState();
  }
  
}

class StateContainerState extends State<StateContainer>{
  Service service;
  StateContainerState(){
      service = new Service();
  }
  @override
  Widget build(BuildContext context) {
    return  _InheritedStateContainer(
      data:this,
      child:widget.child
    );
  }
}

class _InheritedStateContainer extends InheritedWidget {
   // Data is your entire state. In our case just 'service' 
  final StateContainerState data;
   
  // You must pass through a child and your state.
  _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  // This is a built in method which you can use to check if
  // any state has changed. If not, no reason to rebuild all the widgets
  // that rely on your state.
  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trojan Manager',
      theme: ThemeData(primarySwatch: Colors.brown),
      home: MyHomePage(title: 'Trojan Manager'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Drawer(
              child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(10.0, 75.0, 10.0, 10.0),
            children: [
              RaisedButton(
                child: Text('Create User'),
                onPressed: () {
                  // Navigate to add user when tapped.
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddUser()),
                  );
                },
              ),
              RaisedButton(
                  child: Text('Delete User'),
                  onPressed: () {
                    // Navigate to add user when tapped.
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DelUser()),
                    );
                  }),
              RaisedButton(
                  child: Text('DB Setting'),
                  onPressed: () {
                    // Navigate to add user when tapped.
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Connect()),
                    );
                  })
            ],
          )),
        ),
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container());
  }
}

class AddUser extends StatefulWidget {
  @override
  AddUserState createState() {
    return AddUserState();
  }
}

class AddUserState extends State<AddUser> {
  bool isLoading = false;
  TextEditingController usernameCtl =  TextEditingController();
  TextEditingController passwordCtl =  TextEditingController(); 
  TextEditingController quotaCtl =  TextEditingController(); 
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        floatingActionButton: Builder(
            builder: (context) => Container(
                    child: FloatingActionButton(
                  backgroundColor: Colors.amber,
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    Service service = StateContainer.of(context).service;
                    int added = await service.addUser(usernameCtl.text,passwordCtl.text, int.parse(quotaCtl.text));
                    setState(() {
                      isLoading = false;
                    });
                    Scaffold.of(context).showSnackBar(SnackBar(
                          duration: new Duration(seconds: 2),
                          content: added==0? Text('User added successfully.',
                              textAlign: TextAlign.center):Text('User added unsuccessfully.',
                              textAlign: TextAlign.center),
                    ));
                    
                  },
                  child: Icon(Icons.add),
                ))),
        appBar: AppBar(
          title: Text('Add User'),
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : new Column(
                    children: [
                      Padding(
                        child: TextFormField(
                          controller:usernameCtl,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.account_box),
                            hintText: 'Jack chen',
                            labelText: 'Username',
                          ),
                          onSaved: (String value) {
                            // This optional block of code can be used to run
                            // code when the user saves the form.
                          },
                          validator: (String value) {
                            return null;
                          },
                        ),
                        padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      ),
                      Padding(
                        child: TextFormField(
                          controller:passwordCtl,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.lock),
                            hintText: 'abcde',
                            labelText: 'Password',
                          ),
                          onSaved: (String value) {
                            // This optional block of code can be used to run
                            // code when the user saves the form.
                          },
                          validator: (String value) {
                            return null;
                          },
                        ),
                        padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      ),
                      Padding(
                        child: TextFormField(
                          controller:quotaCtl,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.data_usage),
                            hintText: 'abcde',
                            labelText: 'Quota',
                          ),
                          onSaved: (String value) {
                            // This optional block of code can be used to run
                            // code when the user saves the form.
                          },
                          validator: (String value) {
                            return null;
                          },
                        ),
                        padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      )
                    ],
                  )));
  }
}

class DelUser extends StatefulWidget {
  @override
  DelUserState createState() {
    return DelUserState();
  }
}

class DelUserState extends State<DelUser> {
  String username;
  bool isLoading = false;
  List selectedUsers = List.from([]);
  List<User> users = User.getUsers();
  onSelectedRow(selected, user) {
    setState(() {
      if (!selectedUsers.contains(user) && selected) {
        selectedUsers.add(user);
      } else if (!selected && selectedUsers.contains(user)) {
        selectedUsers.remove(user);
      }
    });
  }

  List<DataRow> getRows() {
    return users
        .map((user) => DataRow(
                selected: selectedUsers.contains(user),
                onSelectChanged: (b) {
                  onSelectedRow(b, user);
                },
                cells: [
                  DataCell(Text(user.username)),
                  DataCell(Text(user.quota.toString())),
                ]))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Builder(
          builder: (context) => Container(
                  child: FloatingActionButton(
                backgroundColor: Colors.amber,
                onPressed: () {
                  setState(() {
                    isLoading = true;
                  });
                  new Timer(new Duration(seconds: 2), () {
                    setState(() {
                      isLoading = false;
                      Scaffold.of(context).showSnackBar(SnackBar(
                        duration: new Duration(seconds: 2),
                        content: Text('Users deleted successfully.',
                            textAlign: TextAlign.center),
                      ));
                    });
                  });
                },
                child: Icon(Icons.delete),
              ))),
      appBar: AppBar(
        title: Text('Del User'),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: DataTable(
              rows: getRows(),
              columns: List.from([
                DataColumn(label: Text('Username')),
                DataColumn(label: Text('Quota'))
              ]))),
    );
  }
}

class Connect extends StatefulWidget {
  @override
  ConnectState createState() {
    return ConnectState();
  }
}

class ConnectState extends State<Connect> {
  int connected = 0;
  TextEditingController hostCtl =TextEditingController();
  TextEditingController usernameCtl =TextEditingController();
  TextEditingController passwordCtl =TextEditingController();
  TextEditingController databaseCtl =TextEditingController();
  TextEditingController portCtl =TextEditingController();
  
  Form form;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: connected==1 ? Colors.amber:Colors.green,
          onPressed: () async {
            Service service = StateContainer.of(context).service;
            int result;
            switch(connected){
              case 0:
                result = await service.connect(
                hostCtl.text, 
                int.parse(portCtl.text), 
                usernameCtl.text, 
                passwordCtl.text,
                databaseCtl.text);
                setState(() {
                    if(result==0){
                      connected = 1;
                    }
                });
                break;
              case 1:
                await service.close();
                setState(() {
                      connected = 0;
                });
                break;
            }
            
          },
          child: connected==1 ? Icon(Icons.pause) : Icon(Icons.play_arrow),
        ),
        appBar: AppBar(
          title: Text('Connect'),
        ),
        body:form=Form(child: Column(
          children: <Widget>[
            Padding(
              child: TextFormField(
                controller: hostCtl,
                decoration: const InputDecoration(
                  icon: Icon(Icons.home),
                  hintText: '127.0.0.1 or db.example.com',
                  labelText: 'Host',
                ),
                onSaved: (String value) {
                  // This optional block of code can be used to run
                  // code when the user saves the form.
                },
                validator: (String value) {
                  return null;
                },
              ),
              padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
            ),
            Padding(
              child: TextFormField(
                controller: usernameCtl,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'abcde',
                  labelText: 'Username',
                ),
                onSaved: (String value) {
                  // This optional block of code can be used to run
                  // code when the user saves the form.
                },
                validator: (String value) {
                  return null;
                },
              ),
              padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
            ),
            Padding(
              child: TextFormField(
                controller: passwordCtl,
                decoration: const InputDecoration(
                  icon: Icon(Icons.lock),
                  hintText: 'abcde',
                  labelText: 'Password',
                ),
                onSaved: (String value) {
                  // This optional block of code can be used to run
                  // code when the user saves the form.
                },
                validator: (String value) {
                  return null;
                },
              ),
              padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
            ),
            Padding(
              child: TextFormField(
                controller: databaseCtl,
                decoration: const InputDecoration(
                  icon: Icon(Icons.storage),
                  hintText: 'test',
                  labelText: 'Database',
                ),
                onSaved: (String value) {
                  // This optional block of code can be used to run
                  // code when the user saves the form.
                },
                validator: (String value) {
                  return null;
                },
              ),
              padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
            ),
            Padding(
                child: TextFormField(
                  controller: portCtl,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.settings_input_composite),
                    hintText: '3306',
                    labelText: 'Port',
                  ),
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  onSaved: (String value) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                  validator: (String value) {
                    return null;
                  },
                ),
                padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0))
          ],
        )
        )
    );
  }
}

class Status extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Status'),
      ),
      body: Container(),
    );
  }
}
