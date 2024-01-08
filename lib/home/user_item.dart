import 'package:chat/chats/chats.dart';
import 'package:chat/utility/chat_constants.dart';
import 'package:flutter/material.dart';

class UserItem extends StatelessWidget {
  const UserItem(this.name, {super.key});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, right: 8.0, bottom: 8.0),
      child: TextButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Chats(name)));
        },
        child: Row(
          children: [
            const Icon(Icons.person),
            const SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(name,
                          style: const TextStyle(fontSize: AppConstant.text)),
                      Text('04:23'),
                    ],
                  ),
                  Text('Hi, this is the last message'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
