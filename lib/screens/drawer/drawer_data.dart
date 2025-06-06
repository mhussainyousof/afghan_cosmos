import 'package:afghan_cosmos/models/menu_item.dart';
import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart'; 

final List<MenuItem> menuItems = [
  MenuItem(icon: Iconsax.home, title: 'Home'),

  MenuItem(
    icon: Iconsax.setting,
    title: 'Services',
    children: [
      MenuItem(icon: Iconsax.activity, title: 'Capicity Building'),
      MenuItem(icon: Iconsax.monitor, title: 'IT & Solutions'),
      MenuItem(icon: Iconsax.people, title: 'Education Consulting'),
      MenuItem(icon: Iconsax.document, title: 'Audit & Advisory'),
      MenuItem(icon: Iconsax.video_play, title: 'Afghan Cosmos Online Academy'),
    ],
  ),

  MenuItem(icon: Iconsax.teacher, title: 'Scholarships'),
  MenuItem(icon: Iconsax.book, title: 'Projects'),
  MenuItem(icon: Iconsax.note_2, title: 'Blogs'),
  MenuItem(icon: Iconsax.calendar, title: 'Events'),
  MenuItem(icon: Iconsax.medal_star, title: 'Success Story'),
  MenuItem(icon: Iconsax.verify, title: 'Verifications'),
  MenuItem(icon: Iconsax.call, title: 'Contact'),
  MenuItem(icon: Iconsax.information, title: 'About'),
];




List<Widget> buildMenuItems(List<MenuItem> items) {
  return items.map((item) {
    if (item.children != null && item.children!.isNotEmpty) {
      return ExpansionTile(
        leading: Icon(item.icon),
        title: Text(item.title),
        children: buildMenuItems(item.children!),
      );
    } else {
      return ListTile(
        leading: Icon(item.icon),
        title: Text(item.title),
        onTap: () {
        },
      );
    }
  }).toList();
}
