/**
 * @author Alex Hurley
 */

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(HomePage());

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String start = "What will you get done today??";
  ThemeData current = ThemeData.light();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _textEditingController =
      new TextEditingController();
  bool isSwitched = false;

  List<String> _storedItems = ["What will you get done today??"];

  // this builds the app, it is made up of the scaffold
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "ToDo List",
      theme: current,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: Text("ToDo List!"),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.settings), onPressed: _toSettings)
          ],
        ),
        body: new Container(
          // adds pull to refresh functionality to the app, underneath is a
          // verticle scroll bar
          child: new RefreshIndicator(
            child: new Scrollbar(
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(
                      color: Colors.black,
                    ),
                itemCount: _storedItems.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListTile(
                      title: Text(
                        _storedItems[index],
                        style: new TextStyle(fontSize: 18.0),
                      ),
                      // this adds the inkwell effect to the delete icon
                      trailing: InkWell(
                        child: new IconButton(
                          icon: new Icon(
                            Icons.delete,
                            size: 18.0,
                          ),
                          onPressed: () {
                            _onDeleteItem(_storedItems[index]);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            onRefresh: _refresh,
          ),
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: () {
            _onAddItemPressed();
          },
          tooltip: 'Increment',
          child: new Icon(Icons.add),
          elevation: 8.0,
        ),
      ),
    );
  }

  // when the floating action button is pressed this is the method that is triggered
  // and handles all of the functionality, it displays a pop up text box for user input
  _onAddItemPressed() {
    _scaffoldKey.currentState.showBottomSheet<Null>((BuildContext context) {
      return new Container(
        decoration: new BoxDecoration(color: Colors.grey),
        child: new Padding(
            padding: const EdgeInsets.fromLTRB(32.0, 50.0, 32.0, 32.0),
            child: TextField(
              controller: _textEditingController,
              decoration:
                  new InputDecoration.collapsed(hintText: "I want to...."),
              onSubmitted: _onEntered,
            )),
      );
    });
  }

  // this is called when the trailing icon is pressed, it is the functionality that
  // removes the to-do item from the storage and display
  _onDeleteItem(String item) {
    _delete(item);
    setState(() {
      _storedItems = _storedItems;
    });
  }

  // this method is used when the user submits a new to-do item, it clears
  // the text box and removes the default to-do item
  _onEntered(String s) {
    if (s.isNotEmpty) {
      setState(() {
        if (_storedItems[0].compareTo(start) == 0) {
          _storedItems.removeAt(0);
        }
        _write(s);
        _textEditingController.clear();
      });
    }
  }

  // this is called when the user changes the theme is the settings
  // simply changes from light -> dark mode and vice versa
  ThemeData setTheme() {
    if (current == ThemeData.light()) {
      setState(() {
        current = ThemeData.dark();
        main();
        return ThemeData.dark();
      });
    } else
      setState(() {
        current = ThemeData.light();
        main();
        return ThemeData.light();
      });
    return ThemeData.light();
  }

  // this is the method that displays the bottom drawer popup, it builds the content and
  // displays it to the user, so far it has a switch to change the current theme
  void _toSettings() {
    _scaffoldKey.currentState.showBottomSheet<Null>((BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.red,
          title: Text('Settings'),
        ),
        body: new ListTile(
          title: Text('Dark Theme'),
          trailing: Switch(
            value: isSwitched,
            onChanged: (value) {
              setState(() {
                isSwitched = value;
                setTheme();
              });
            },
            activeTrackColor: Colors.lightGreenAccent,
            activeColor: Colors.green,
          ),
        ),
      );
    });
  }

  // this method saves the user input data into the local devices storage
  _write(String item) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'my_int_key';
    if (item.compareTo(" ") == 0) {
      _storedItems = prefs.getStringList(key);
      prefs.setStringList(key, _storedItems);
    } else {
      if (prefs.getStringList(key) == null) {
        prefs.setStringList(key, _storedItems);
      } else {
        _storedItems = prefs.getStringList(key);
        _storedItems.add(item);
      }
    }
  }

  // this method deletes the given string from the local devices storage
  _delete(String s) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'my_int_key';
    setState(() {
      _storedItems.remove(s);
      prefs.setStringList(key, _storedItems);
    });
  }

  // this method refreshes the page and is called when the pull to refresh is activated
  Future<void> _refresh() async {
    _write(" ");
    setState(() {
      _storedItems = _storedItems;
    });
  }
}
