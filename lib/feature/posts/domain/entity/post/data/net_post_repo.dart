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
}
