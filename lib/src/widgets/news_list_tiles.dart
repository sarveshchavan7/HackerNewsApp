import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../bloc/stories_provider.dart';
import '../widgets/loading_container.dart';

class NewsListTile extends StatelessWidget {
  final int itemId;

  NewsListTile({this.itemId});

  Widget build(context) {
    final bloc = StoriesProvider.of(context);
    return StreamBuilder(
      stream: bloc.items,
      builder: (BuildContext context,
          AsyncSnapshot<Map<int, Future<ItemModel>>> snapShot) {
        if (!snapShot.hasData) {
          return LoadingContainer();
        }

        return FutureBuilder(
          future: snapShot.data[itemId],
          builder: (context, AsyncSnapshot<ItemModel> itemShapShot) {
            if (!itemShapShot.hasData) {
              return LoadingContainer();
            }
            return buildList(context,itemShapShot.data);
          },
        );
      },
    );
  }

  Widget buildList(BuildContext context,ItemModel item) {
    return Column(
      children: <Widget>[
        ListTile(
          onTap: (){
            Navigator.pushNamed(context, '${item.id}');
            //print('${item.id}');
          },
          title: Text(item.title),
          subtitle: Text('${item.score} points'),
          trailing: Column(
            children: <Widget>[
              Icon(Icons.comment),
              Text('${item.descendants}')
            ],
          ),
        ),
        Divider(
          height: 10.0,
        )
      ],
    );
  }
}
