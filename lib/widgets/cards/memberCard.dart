import 'package:flutter/material.dart';

import '../../models/Member.dart';

class MemberCard extends StatelessWidget {
  Member member;
  MemberCard({super.key, required this.member});
  @override
  Widget build(BuildContext context) {
    String memberName = member.MemberName ?? "Member";
    String name = member.IsAdmin ? "${memberName} 👑" : memberName;
    return Container(
      child: Card(
          margin: EdgeInsets.symmetric(vertical: 3),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
            child: Text(
              name,
              style: TextStyle(fontSize: 20),
            ),
          )),
    );
  }
}
