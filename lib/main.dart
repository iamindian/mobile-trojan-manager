import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'service.dart';
import 'dart:developer';

void main() => runApp(StateContainer(child: new MyApp()));

class StateContainer extends StatefulWidget {
  final Widget child;
  StateContainer({@required this.child});
  // This is the secret sauce. Write your own 'of' method that will behave
  // Exactly like MediaQuery.of and Theme.of
  // It basically says 'get the data from the widget of this type.
  static StateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer)
            as _InheritedStateContainer)
        .data;
  }

  @override
  StateContainerState createState() {
    return StateContainerState();
  }
}

class StateContainerState extends State<StateContainer> {
  Service service;
  StateContainerState() {
    service = new Service();
  }
  @override
  Widget build(BuildContext context) {
    return _InheritedStateContainer(data: this, child: widget.child);
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
        //title: 'Mobile Trojan Manager',
        theme: ThemeData(primarySwatch: Colors.brown),
        home: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                bottom: TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.storage)),
                    Tab(icon: Icon(Icons.people)),
                    Tab(icon: Icon(Icons.person)),
                  ],
                ),
                title: Text('Mobile Trojan Manager'),
              ),
              body: TabBarView(
                children: [Connect(), LsUser(), AddUser()],
              ),
            ))
        //Connect(title: 'Mobile Trojan Manager')),

        /* routes: <String,WidgetBuilder>{
        '/setting':(BuildContext context) => Connect(),
        '/addUser':(BuildContext context) => AddUser(),
        '/delUser':(BuildContext context) => LsUser()
      }, */
        );
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
  TextEditingController usernameCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();
  TextEditingController quotaCtl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Builder(
            builder: (context) => Container(
                    child: FloatingActionButton(
                  heroTag: 'addBtn',
                  backgroundColor: Colors.amber,
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    Service service = StateContainer.of(context).service;
                    List added = await service.addUser(usernameCtl.text,
                        passwordCtl.text, int.parse(quotaCtl.text));
                    setState(() {
                      isLoading = false;
                    });
                    Scaffold.of(context).showSnackBar(SnackBar(
                      duration: new Duration(seconds: 2),
                      content: added[0] == 0
                          ? Text('User added successfully.',
                              textAlign: TextAlign.center)
                          : Text('${added[1]}',
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
                          controller: usernameCtl,
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
                          keyboardType: TextInputType.number,
                          controller: quotaCtl,
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

class LsUser extends StatefulWidget {
  @override
  LsUserState createState() {
    return LsUserState();
  }
}

class LsUserState extends State<LsUser> {
  String username;
  bool isLoading = false;
  List selectedUsers = List.from([]);
  List users = [];
  dynamic last;
  TextEditingController kwCtl = TextEditingController();
  findUser(keyword) async {
    if (keyword == ''){
         setState(() {
            users = [];
        });
    }
    Service service = StateContainer.of(context).service;
    List list = await service.findUser(keyword);
    if (list[0] == 1) {
      setState(() {
        users = [];
      });
      Scaffold.of(context).showSnackBar(SnackBar(
        duration: new Duration(seconds: 2),
        content: Text('${list[1]}', textAlign: TextAlign.center),
      ));
    } else {
      setState(() {
        users = list[1];
      });
    }
  }

  SearchBar searchBar;

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text('Users'),
        actions: [searchBar.getSearchAction(context)]);
  }

  LsUserState() {
    searchBar = SearchBar(
        controller: kwCtl,
        showClearButton: true,
        clearOnSubmit: false,
        inBar: false,
        setState: setState,
        onSubmitted: findUser,
        buildDefaultAppBar: buildAppBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: searchBar.build(context),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
                child: RefreshIndicator(
              onRefresh: () async {
                 await findUser(kwCtl.text);

              },
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final item = users[index].username;
                  return Dismissible(
                    // Each Dismissible must contain a Key. Keys allow Flutter to
                    // uniquely identify Widgets.
                    key: Key(item),
                    // We also need to provide a function that tells our app
                    // what to do after an item has been swiped away.
                    onDismissed: (direction) async {
                      // Remove the item from our data source.
                      setState(() {
                        last = users.removeAt(index);
                      });

                      // Then show a snackbar!
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(
                              content: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(children: [
                                    Expanded(
                                        child: Center(
                                            child: Text("$item deleted",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)))),
                                    Expanded(
                                        child: Center(
                                            child: FlatButton(
                                      child: Text('Undo',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(color: Colors.red)),
                                      padding: EdgeInsets.only(left: 5.0),
                                      onPressed: () {
                                        setState(() {
                                          users.add(last);
                                          Scaffold.of(context)
                                              .removeCurrentSnackBar();
                                        });
                                      },
                                    )))
                                  ]))))
                          .closed
                          .then((reason) async {
                        if (reason == SnackBarClosedReason.timeout) {
                          Service service = StateContainer.of(context).service;
                          List deleted = await service.delUser(last.username);
                          if (deleted[0] == 1) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              duration: new Duration(seconds: 2),
                              content: Text(
                                  'User removed unsuccessfully. ${deleted[1]}',
                                  textAlign: TextAlign.center),
                            ));
                          }
                        }
                      });
                    },
                    // Show a red background as the item is swiped away
                    background: Container(color: Colors.red),
                    child: ListTile(
                        title: Text('$item',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  );
                },
              ),
            ))));
  }
}

class Connect extends StatefulWidget {
  Connect({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  @override
  ConnectState createState() {
    return ConnectState();
  }
}

class ConnectState extends State<Connect>
    with AutomaticKeepAliveClientMixin<Connect> {
  int connected = 0;
  TextEditingController hostCtl = TextEditingController();
  TextEditingController usernameCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();
  TextEditingController databaseCtl = TextEditingController();
  TextEditingController portCtl = TextEditingController();

 
  @override
  Widget build(BuildContext context) {
    Service service = StateContainer.of(context).service;

    return Scaffold(
        floatingActionButton: Builder(
            builder: (context) => Container(
                  child: FloatingActionButton(
                    heroTag: "connectBtn",
                    backgroundColor:
                        connected == 1 ? Colors.amber : Colors.green,
                    onPressed: () async {
                      List result;
                      switch (connected) {
                        case 0:
                          result = await service.connect(
                              hostCtl.text,
                              int.parse(portCtl.text),
                              usernameCtl.text,
                              passwordCtl.text,
                              databaseCtl.text);
                          setState(() {
                            if (result[0] == 0) {
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
                    child: connected == 1
                        ? Icon(Icons.pause)
                        : Icon(Icons.play_arrow),
                  ),
                )),
        appBar: AppBar(
          title: Text('Database'),
        ),
        body: Container(
          child: SingleChildScrollView(child:Column(
          children: <Widget>[
            Padding(
              child: TextFormField(
                //initialValue: '',
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
                //initialValue: setting.user,
                controller: usernameCtl,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'username',
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
                //initialValue: setting.password,
                obscureText: true,
                controller: passwordCtl,
                decoration: const InputDecoration(
                  icon: Icon(Icons.lock),
                  hintText: 'password',
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
                //initialValue: setting.db,
                controller: databaseCtl,
                decoration: const InputDecoration(
                  icon: Icon(Icons.storage),
                  hintText: 'trojan',
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
                  keyboardType: TextInputType.number,
                  //initialValue: '',
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
        ))));
  }

  @override
  bool get wantKeepAlive => true;
}
