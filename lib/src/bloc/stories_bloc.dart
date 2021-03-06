import '../models/item_model.dart';
import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

class StoriesBloc {
  final _repository = Repository();
  final _topId = PublishSubject<List<int>>();
  final _itemsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();
  final _itemsFetcher = PublishSubject<int>();

  //Getter for stream
  Observable<List<int>> get topId => _topId.stream;
  Observable<Map<int, Future<ItemModel>>> get items => _itemsOutput.stream;

  //Getter for sink
  Function(int) get fetchItem => _itemsFetcher.sink.add;

  StoriesBloc() {
   _itemsFetcher.stream.transform(_itemTransformer()).pipe(_itemsOutput);
  }

  fetchTopIds() async {
    List<int> ids = await _repository.fetchTopId();
    _topId.sink.add(ids);
  }

  clearCache(){
    return _repository.clearCache();
  }

  _itemTransformer() {
    return ScanStreamTransformer(
      (Map<int, Future<ItemModel>> cache,int id, index) {
        //print(index);
        cache[id] = _repository.fetchItem(id);
        return cache;
      },
      <int, Future<ItemModel>>{},
    );
  }

  dispose() {
    _topId.close();
    _itemsFetcher.close();
    _itemsOutput.close();
  }
}
