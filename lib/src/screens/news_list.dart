import 'package:flutter/material.dart';
import '../bloc/stories_provider.dart';
import '../widgets/news_list_tiles.dart';
import '../widgets/refresh.dart';

class NewsList extends StatelessWidget {
  Widget build(context) {
    final bloc = StoriesProvider.of(context);
    bloc.fetchTopIds();
    print('build of fecth top ids');
    return Scaffold(
      appBar: AppBar(
        title: Text('Top News'),
      ),
      body: topIdList(bloc),
    );
  }

  Widget topIdList(StoriesBloc bloc) {
    return StreamBuilder(
      stream: bloc.topId,
      builder: (BuildContext context, AsyncSnapshot<List<int>> snapShot) {
        if (!snapShot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return Refresh(
          child: ListView.builder(
            itemCount: snapShot.data.length,
            itemBuilder: (BuildContext context, int index) {
              bloc.fetchItem(snapShot.data[index]);
              return NewsListTile(itemId: snapShot.data[index]);
            },
          ),
        );
      },
    );
  }
}
