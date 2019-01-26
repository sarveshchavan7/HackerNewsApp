import 'dart:async';
import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../widgets/loading_container.dart';

class Comment extends StatelessWidget {
  final int itemId;
  final Map<int, Future<ItemModel>> itemMap;
  final int dept;

  Comment({this.itemId, this.itemMap, this.dept});

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: itemMap[itemId],
      builder: (context, AsyncSnapshot<ItemModel> snapShot) {
        if (!snapShot.hasData) {
          return LoadingContainer();
        }
        return buildComment(snapShot.data);
      },
    );
  }

  Widget buildComment(ItemModel item) {
    final children = <Widget>[];
    children.add(
      ListTile(
        title: buildText(item),
        subtitle: item.by == '' ? Text('Deleted') : Text(item.by),
        contentPadding: EdgeInsets.only(
          right: 16.0,
          left: (dept + 1) * 16.0,
        ),
      ),
    );
    children.add(Divider());
    item.kids.forEach((kidId) {
      children.add(Comment(
        itemId: kidId,
        itemMap: itemMap,
        dept: dept + 1,
      ));
    });
    return Column(
      children: children,
    );
  }

  Widget buildText(ItemModel item) {
    final text = item.text
        .replaceAll('&#x27;', "'")
        .replaceAll('<p>', '\n\n')
        .replaceAll('</p>', '');
    return Text(text);
  }
}
