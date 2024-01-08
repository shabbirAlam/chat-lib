import 'package:chat/chats/chat_view_model.dart';
import 'package:chat/utility/chat_constants.dart';
import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class Chats extends StatefulWidget {
  const Chats(this.name, {super.key});
  final String name;

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final ScrollController _controller = ScrollController();
  List<Map<String, Object>> chatList = ChatViemModel.instance.chatList;
  bool newSender = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToEnd();
    });
  }

  void _scrollToEnd() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: const Duration(milliseconds: 1),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    double textFieldHeight = 75;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: getAppBar(context),
        body: Stack(
          children: [
            background(),
            getListView(textFieldHeight),
            messagebar(),
          ],
        ),
      ),
    );
  }

  ListView getListView(double textFieldHeight) {
    return ListView.builder(
        controller: _controller,
        itemCount: chatList.length,
        itemBuilder: (context, index) {
          var chatItem = chatList[index];
          String? text = chatItem['text'] as String;
          if (text.isEmpty) {
            //date
            String? date = chatItem['date'] as String;
            DateTime tempDate = DateTime.parse(date);
            return Center(
              child: DateChip(
                date: tempDate,
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
            );
          } else {
            //msg
            return msgBubble(chatItem, index, text, textFieldHeight);
          }
        });
  }

  GestureDetector msgBubble(Map<String, Object> chatItem, int index,
      String text, double textFieldHeight) {
    bool? isSender = chatItem['isSender'] as bool;
    bool? sent = chatItem['sent'] as bool;
    bool? delivered = chatItem['delivered'] as bool;
    bool? seen = chatItem['seen'] as bool;

    bool tail = false;
    if (chatList.length - 1 == index) {
      tail = true;
    } else {
      var nextChat = chatList[index + 1];
      String? text = nextChat['text'] as String;
      if (!(nextChat['isSender'] == isSender && text.isNotEmpty)) {
        tail = true;
      }
    }
    return GestureDetector(
      onLongPress: () async {
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure to delete?'),
            content:
                const Text('This action will permanently delete this data'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  chatList.removeAt(index);
                  setState(() {});
                  Navigator.pop(context, true);
                },
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      },
      child: Column(
        children: [
          BubbleSpecialThree(
            text: text,
            color: isSender ? Colors.blue : const Color(0xFFE8E8EE),
            textStyle: TextStyle(
                fontSize: AppConstant.text,
                color: isSender ? Colors.white : Colors.black),
            tail: tail,
            isSender: isSender,
            sent: sent,
            delivered: delivered,
            seen: seen,
          ),
          Visibility(
            visible: index == chatList.length - 1,
            child: SizedBox(height: textFieldHeight),
          ),
        ],
      ),
    );
  }

  Container background() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/background.jpg'),
        ),
      ),
    );
  }

  AppBar getAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          var delay = 0;
          var currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            currentFocus.focusedChild?.unfocus();
            delay = 500;
          }
          FocusManager.instance.primaryFocus?.unfocus();
          Future.delayed(Duration(milliseconds: delay), () {
            Navigator.pop(context);
          });
        },
      ),
      centerTitle: false,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(widget.name,
          style: const TextStyle(fontSize: AppConstant.titleFontSize)),
      actions: [
        TextButton(onPressed: () {}, child: const Icon(Icons.videocam_sharp)),
        TextButton(onPressed: () {}, child: const Icon(Icons.call)),
        TextButton(onPressed: () {}, child: const Icon(Icons.more_vert)),
      ],
    );
  }

  MessageBar messagebar() {
    return MessageBar(
      onSend: (txt) {
        FocusManager.instance.primaryFocus?.unfocus();
        Map<String, Object> cht = {
          'text': txt,
          'isSender': newSender,
          'sent': newSender,
          'delivered': newSender,
          'seen': newSender,
          'date': '2024-01-07',
        };
        chatList.add(cht);
        setState(() {});
        Future.delayed(const Duration(milliseconds: 50), () {
          setState(() {
            _scrollToEnd();
          });
        });
      },
      actions: [
        InkWell(
          child: const Icon(
            Icons.add,
            color: Colors.black,
            size: 24,
          ),
          onTap: () {
            newSender = !newSender;
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: InkWell(
            child: const Icon(
              Icons.camera_alt,
              color: Colors.green,
              size: 24,
            ),
            onTap: () {},
          ),
        ),
      ],
    );
  }
}
