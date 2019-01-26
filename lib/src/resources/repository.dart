import '../models/item_model.dart';
import 'news_api_provider.dart';
import 'news_db_provider.dart';

class Repository {
  List<Source> sources = <Source>[
    newsDbProvider,
    NewsApiProvider(),
  ];

  List<Cache> caches = <Cache>[
    newsDbProvider,
  ];

  Future<List<int>> fetchTopId() {
    return sources[1].fetchTopId();
  }

  Future<ItemModel> fetchItem(int id) async {
    ItemModel item;
    var source;

    for (source in sources) {
      item = await source.fetchItems(id);
      if (item != null) {
        break;
      }
    }

    for (var cache in caches) {
      if (cache != source) {
        cache.addItem(item);
      }
    }

    return item;
  }

  clearCache() async{
    for(var cache in caches){
      await cache.clear();
    }
  }
}

abstract class Source {
  Future<List<int>> fetchTopId();
  Future<ItemModel> fetchItems(int id);
}

abstract class Cache {
  Future<int> addItem(ItemModel item);
  Future<int> clear();
}
