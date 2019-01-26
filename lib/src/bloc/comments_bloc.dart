import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';

class CommentsBloc {
  final _respository = Repository();
  final _commentsFetcher = PublishSubject<int>();
  final _commentsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();

  //Streams
  Observable<Map<int, Future<ItemModel>>> get itemWithComments =>
      _commentsOutput.stream;

  //Sinks
  Function(int) get fetchItemWithComments => _commentsFetcher.sink.add;

  CommentsBloc() {
    _commentsFetcher.stream
        .transform(_commentsTransformer())
        .pipe(_commentsOutput);
  }

  _commentsTransformer() {
    return ScanStreamTransformer(
      (Map<int, Future<ItemModel>> cache, int id, index) {
        print('kids {$index}');
        cache[id] = _respository.fetchItem(id);
        cache[id].then(
          (ItemModel item) {
            item.kids.forEach((kids) => fetchItemWithComments(kids));
          },
        );
        return cache;
      },
      <int, Future<ItemModel>>{},
    );
  }

  disponse() {
    _commentsFetcher.close();
    _commentsOutput.close();
  }
}
