import 'package:flutter/material.dart';
import 'screens/news_list.dart';
import '../src/bloc/stories_provider.dart';
import '../src/bloc/comments_provider.dart';
import 'screens/news_detail.dart';

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    return CommentsProvider(
      child: StoriesProvider(
        child: MaterialApp(title: 'News!', onGenerateRoute: routes),
      ),
    );
  }

  Route routes(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute(
        builder: (context) {
          print('fetch top ids');
          //final storiesBloc = StoriesProvider.of(context);
          //storiesBloc.fetchTopIds();
          return NewsList();
        },
      );
    } else {
      return MaterialPageRoute(
        builder: (context) {
          final commentsBloc = CommentsProvider.of(context);
          final itemId = int.parse(settings.name.replaceFirst('/', ''));
          commentsBloc.fetchItemWithComments(itemId);
          return NewsDetail(
            itemId: itemId,
          );
        },
      );
    }
  }
}
