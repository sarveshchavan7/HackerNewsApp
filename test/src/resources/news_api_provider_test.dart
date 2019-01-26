import 'package:news/src/resources/news_api_provider.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'dart:convert';
import 'package:test_api/test_api.dart';
import 'package:news/src/models/item_model.dart';

void main() {
  test('fetchTopIds returns the list of top ids', () async {
    final newApi = NewsApiProvider();

    newApi.client = MockClient((request) async {
      return Response(json.encode([1, 2, 3, 4, 5]), 200);
    });

    final ids = await newApi.fetchTopId();
    expect(ids, [1, 2, 3, 4, 5]);
  });

  test('FetchItem return a item model', () async {
    final newAPi = NewsApiProvider();

    newAPi.client = MockClient((request) async {
      final jsonMap = {'id': 123};
      return Response(json.encode(jsonMap), 200);
    });

    ItemModel item = await newAPi.fetchItems(999);

    expect(item.id, 123);
  });
}
