import 'package:flutter/material.dart';
import '../bloc/comments_provider.dart';
import '../models/item_model.dart';
import '../widgets/comment.dart';

class NewsDetail extends StatelessWidget {
  final int itemId;

  NewsDetail({this.itemId});

  Widget build(BuildContext context) {
    final bloc = CommentsProvider.of(context);
    return Scaffold(
      body: buildBody(bloc),
      appBar: AppBar(
        title: Text('Detail'),
      ),
    );
  }

  Widget buildBody(CommentsBloc bloc) {
    return StreamBuilder(
      stream: bloc.itemWithComments,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapShot) {
        if (!snapShot.hasData) {
          return Text('Loading!');
        }

        final itemFuture = snapShot.data[itemId];
        return FutureBuilder(
          future: itemFuture,
          builder: (context, AsyncSnapshot<ItemModel> itemSnapShot) {
            if (!itemSnapShot.hasData) {
              return Text('Loading!');
            }
            return buildList(itemSnapShot.data, snapShot.data);
          },
        );
      },
    );
  }

  Widget buildList(ItemModel item, Map<int, Future<ItemModel>> itemMap) {
    final children = <Widget>[];
    children.add(buildTitle(item));
    final commentList = item.kids.map((kidsId) {
      return Comment(
        itemId: kidsId,
        itemMap: itemMap,
        dept: 0,
      );
    }).toList();
    children.addAll(commentList);

    return ListView(
      children: children,
    );
  }

  Widget buildTitle(ItemModel item) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.all(10.0),
      child: Text(
        item.title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
