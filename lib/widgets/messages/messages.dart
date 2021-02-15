import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(),);
        }
        return StreamBuilder(
          stream: Firestore.instance.collection('chat').orderBy('createdAt', descending: true).snapshots(),
          builder: (ctx, chatSnapshot) {
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(),);
            }
            final messages = chatSnapshot.data.documents;
            return ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (ctx, index) => MessageBubble(
                messages[index]['text'],
                messages[index]['username'],
                messages[index]['userId'] == futureSnapshot.data.uid,
                key: ValueKey(messages[index].documentID),
              ),
            );
          },
        );
      },
    );
  }
}