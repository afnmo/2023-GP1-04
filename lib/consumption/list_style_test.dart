import 'package:flutter/material.dart';

class ListStyleTest extends StatelessWidget {
  final List<String> items = List<String>.generate(10, (i) => "Item $i");

  ListStyleTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List View Styles'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildBasicListView(),
            Divider(),
            _buildDividedListView(),
            Divider(),
            _buildCardStyleListView(),
            Divider(),
            _buildHorizontalScrollListView(),
            Divider(),
            _buildGridListView(),
            Divider(),
            _buildSwipeToDismissListView(),
            Divider(),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicListView() {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.map, color: Colors.blue),
          title: Text('Map', style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('Find locations easily'),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
        // Add more ListTiles...
      ],
    );
  }

  Widget _buildDividedListView() {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Item ${items[index]}',
              style: TextStyle(color: Colors.deepPurple)),
        );
      },
      separatorBuilder: (context, index) => Divider(color: Colors.grey),
    );
  }

  Widget _buildCardStyleListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            title: Text('Item ${items[index]}'),
          ),
        );
      },
    );
  }

  Widget _buildHorizontalScrollListView() {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Container(
            width: 180.0,
            child: Card(
              child: Center(
                child: Text('Item ${items[index]}'),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGridListView() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.lightBlueAccent,
          child: Center(
            child: Text('Item ${items[index]}',
                style: TextStyle(color: Colors.white)),
          ),
        );
      },
    );
  }

  Widget _buildSwipeToDismissListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(items[index]),
          onDismissed: (direction) {
            // Handle item removal
          },
          background: Container(color: Colors.red),
          child: ListTile(title: Text('${items[index]}')),
        );
      },
    );
  }
}
