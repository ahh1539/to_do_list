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

  List<Item> items = [Item("What will you get done today??")];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _textEditingController =
  new TextEditingController();
  bool isSwitched = false;

  List<String> _storedItems = ["What will you get done today??"];

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
            IconButton(icon: Icon(Icons.settings), onPressed: _pushSaved)
          ],
        ),
        body: new Container(
          child: ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.black,
            ),
            itemCount: _storedItems.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListTile(
                  title: Text(_storedItems[index], style: new TextStyle(fontSize: 18.0),),
                  trailing: InkWell(
                    child: new IconButton(
                      icon: new Icon(Icons.delete, size: 18.0,),
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

  _onDeleteItem(String item) {
    _delete(item);
    setState(() {
      _storedItems = _storedItems;
    });
  }

  _onEntered(String s) {
    if (s.isNotEmpty) {
      setState(() {
        if (items[0].toString().compareTo(start) == 0) {
          items.removeAt(0);
          _storedItems.removeAt(0);
        }
        items.add(new Item(s));
        _write(new Item(s));
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

  _write(Item item) async{
    final prefs = await SharedPreferences.getInstance();
    final key = 'my_int_key';

    if(prefs.getStringList(key) == null){
      prefs.setStringList(key, _storedItems);
    }
    else{
      _storedItems = prefs.getStringList(key);
      _storedItems.add(item.toString());
      prefs.setStringList(key, _storedItems);
    }

  }


  _delete(String s) async{
    final prefs = await SharedPreferences.getInstance();
    final key = 'my_int_key';
    setState(() {
      _storedItems.remove(s);
      prefs.setStringList(key, _storedItems);
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