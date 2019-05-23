import 'package:flutter/material.dart';

void main() => runApp(ToDoList());

class ToDoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "ToDo List",
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {
  List<Item> items = [Item("feed the cat"), Item("yeet on all of the feet")];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("ToDo List!"),
      ),
      body: new Container(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                items[index].toString()
              ),
              trailing: Icon(Icons.assignment_turned_in),
            );
          },
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: null,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
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

