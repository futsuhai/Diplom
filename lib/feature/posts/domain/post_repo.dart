abstract class PostRepo{
  Future fetchPosts();
  Future fetchPostsWithId(String id);
  Future deletePost(String id);
  Future createPost({String? content, String? image});
}