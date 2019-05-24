import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(HomePage());

class ToDoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "ToDo List",
      home: HomePage(),
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String start = "What will you get done today??";
  ThemeData current = ThemeData.light();

  List<Item> items = [Item("What will you get done today??")];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _textEditingController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "ToDo List",
      theme: current,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: Text("ToDo List!"),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.settings), onPressed: _pushSaved)
          ],
        ),
        body: new Container(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(items[index].toString()),
                trailing: new IconButton(
                  icon: new Icon(Icons.delete),
                  onPressed: () {
                    _onDeleteItem(index);
                  },
                ),
              );
            },
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

  _onAddItemPressed() {
    _scaffoldKey.currentState.showBottomSheet<Null>((BuildContext context) {
      return new Container(
        decoration: new BoxDecoration(color: Colors.grey),
        child: new Padding(
            padding: const EdgeInsets.fromLTRB(32.0, 50.0, 32.0, 32.0),
            child: TextField(
              controller: _textEditingController,
              decoration: new InputDecoration.collapsed(
                  hintText: "Enter a Task to Complete"),
              onSubmitted: _onEntered,
            )),
      );
    });
  }

  _onDeleteItem(item) {
    items.removeAt(item);
    setState(() {});
  }

  _onEntered(String s) {
    if (s.isNotEmpty) {
      setState(() {
        if (items[0].toString().compareTo(start) == 0) {
          items.removeAt(0);
        }
        items.add(new Item(s));
        _textEditingController.clear();
      });
    }
  }

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

  void _pushSaved() {
    _scaffoldKey.currentState.showBottomSheet<Null>((BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.red,
          title: Text('Settings'),
        ),
        body: new ListTile(
          title: Text('Switch theme??'),
          trailing: new IconButton(
            icon: new Icon(Icons.ac_unit),
            onPressed: () {
              setTheme();
            },
          ),
        ),
      );
    });
  }
}

class Item {
  String title;
  Item(String title) {
    this.title = title;
  }

  @override
  String toString() => "$title";
}
