import 'package:chat/chats/chat_view_model.dart';
import 'package:chat/home/user_item.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  final String title = 'Chat';

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var userList = ChatViemModel.instance.userList;
  int selectedTile = 1;

  void _chatPressed() {
    userList.add('Shabbir new');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    double headerheight = 40;
    double appBarheight = 56;
    double scrollheight =
        height - padding.top - padding.bottom - headerheight - appBarheight;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          TextButton(
              onPressed: () {}, child: const Icon(Icons.camera_alt_outlined)),
          TextButton(onPressed: () {}, child: const Icon(Icons.search)),
          TextButton(onPressed: () {}, child: const Icon(Icons.more_vert)),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _getHeaderRow(headerheight),
          SizedBox(
            height: scrollheight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _getSelectedPage(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _chatPressed,
        child: const Icon(Icons.chat),
      ),
    );
  }

  Widget _getSelectedPage() {
    switch (selectedTile) {
      case 0:
        break;
      case 1:
        return chatView();
      case 2:
        break;
      case 3:
        break;
      default:
    }
    // default widget view
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Coming soon..."),
      ],
    );
  }

  Widget chatView() {
    return ListView.builder(
      itemCount: userList.length,
      itemBuilder: (context, index) {
        return UserItem(userList[index]);
      },
    );
  }

  Widget _getHeaderRow(double headerheight) {
    return SizedBox(
      height: headerheight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: selectedTile == 0
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent),
              ),
            ),
            child: IconButton(
                onPressed: () {
                  setState(() {
                    selectedTile = 0;
                  });
                },
                icon: Icon(
                  Icons.groups_2,
                  color: Theme.of(context).colorScheme.primary,
                )),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: selectedTile == 1
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent),
              ),
            ),
            child: TextButton(
                onPressed: () {
                  setState(() {
                    selectedTile = 1;
                  });
                },
                child: Text("Chats")),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: selectedTile == 2
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent),
              ),
            ),
            child: TextButton(
                onPressed: () {
                  setState(() {
                    selectedTile = 2;
                  });
                },
                child: Text("Updates")),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: selectedTile == 3
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent),
              ),
            ),
            child: TextButton(
                onPressed: () {
                  setState(() {
                    selectedTile = 3;
                  });
                },
                child: Text("Calls")),
          ),
        ],
      ),
    );
  }
}
