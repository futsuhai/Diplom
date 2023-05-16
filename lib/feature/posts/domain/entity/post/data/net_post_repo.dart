import 'package:client_id/feature/posts/domain/entity/post/post_entity.dart';
import 'package:client_id/feature/posts/domain/post_repo.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../app/domain/app_api.dart';

@Injectable(as: PostRepo)
class NetPostRepo implements PostRepo {
  final AppApi api;

  NetPostRepo(this.api);

  @override
  Future<Iterable> fetchPosts() async{
    try {
      final response = await api.fetchPosts();
      return response.data;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<Iterable> createPost({String? content, String? image}) async{
    try {
      final response = await api.createPost(content: content, image: image);
      return response.data["message"];
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future deletePost(String id) async{
    try {
       await api.deletePost(id);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<Iterable> fetchPostsWithId(String id) async{
    try {
      final response = await api.fetchPostsWithId(id);
      return response.data;
    } catch (_) {
      rethrow;
    }
  }
}
