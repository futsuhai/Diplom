abstract class PostRepo{
  Future fetchPosts();
  Future deletePost(String id);
  Future createPost({String? content, String? image});
}