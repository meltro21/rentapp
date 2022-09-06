import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentapp/controllers/chat_controller.dart';
import 'package:rentapp/models/posts_model.dart';
import 'package:rentapp/views/chat/chat_detail.dart';

import '../../models/chat/chat_user_model.dart';

class ChatHome extends StatefulWidget {
  const ChatHome({Key? key}) : super(key: key);

  @override
  State<ChatHome> createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  ChatController chatController = Get.put(ChatController());
  List<ChatUsers> chatUsers = [
    ChatUsers(
      name: 'Usama',
      messageText: 'Bhai construction k lie truck hai?',
      imageURL: 'assets/images/person1.jpeg',
      time: '28 May',
    ),
    ChatUsers(
        name: 'Ahtesham',
        messageText: 'Loader hai?',
        imageURL: 'assets/images/person2.jpeg',
        time: '28 May'),
    ChatUsers(
        name: 'Mahad',
        messageText: 'Aoa',
        imageURL: 'assets/images/person3.jpeg',
        time: '28 May')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Conversations",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            //Search
            Padding(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey.shade100)),
                ),
              ),
            ),
            //List
            StreamBuilder(
                stream: chatController.getLatestMessages(),
                builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 16),
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: (() {
                              Get.to(
                                  ChatDetail(postDetails: PostsModel.empty()));
                            }),
                            child: Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                    snapshot.data!.docs[index]['message'])),
                          );
                        });
                  } else {
                    return SizedBox(
                      child: Text('No Data'),
                    );
                  }
                })),
          ],
        ),
      ),
    );
  }
}

// class ConversationList extends StatefulWidget {
//   String name;
//   String messageText;
//   String imageUrl;
//   String time;
//   bool isMessageRead;
//   ConversationList(
//       {required this.name,
//       required this.messageText,
//       required this.imageUrl,
//       required this.time,
//       required this.isMessageRead});
//   @override
//   _ConversationListState createState() => _ConversationListState();
// }

// class _ConversationListState extends State<ConversationList> {
//   @override
//   Widget build(BuildContext context) {
//     //print(widget.imageUrl + 'hello');
//     return GestureDetector(
//       onTap: () {},
//       child: Container(
//         padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
//         child: Row(
//           children: <Widget>[
//             Expanded(
//               child: Row(
//                 children: <Widget>[
//                   // CircleAvatar(
//                   //   backgroundImage: AssetImage(
//                   //     widget.imageUrl,
//                   //   ),
//                   //   maxRadius: 30,
//                   // ),
//                   Container(
//                     height: 50,
//                     width: 50,
//                     child: ClipOval(
//                         child: Image.asset(
//                       widget.imageUrl,
//                       fit: BoxFit.fill,
//                       width: 60.0,
//                       height: 60.0,
//                     )),
//                   ),
//                   SizedBox(
//                     width: 16,
//                   ),
//                   Expanded(
//                     child: Container(
//                       color: Colors.transparent,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Text(
//                             widget.name,
//                             style: TextStyle(fontSize: 16),
//                           ),
//                           SizedBox(
//                             height: 6,
//                           ),
//                           Text(
//                             widget.messageText,
//                             style: TextStyle(
//                                 fontSize: 13,
//                                 color: Colors.grey.shade600,
//                                 fontWeight: widget.isMessageRead
//                                     ? FontWeight.bold
//                                     : FontWeight.normal),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Text(
//               widget.time,
//               style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: widget.isMessageRead
//                       ? FontWeight.bold
//                       : FontWeight.normal),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
