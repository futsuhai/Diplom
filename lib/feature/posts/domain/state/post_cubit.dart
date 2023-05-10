import 'dart:async';

import 'package:client_id/feature/auth/domain/auth_state/auth_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:client_id/feature/posts/domain/entity/post/post_entity.dart';

import '../post_repo.dart';

part 'post_state.dart';
part 'post_cubit.freezed.dart';
part 'post_cubit.g.dart';

class PostCubit extends HydratedCubit<PostState> {
  PostCubit(this.repo, this.authCubit) : super(const PostState(asyncSnapshot: AsyncSnapshot.nothing())){
    authSub = authCubit.stream.listen((event) {
      event.mapOrNull(
        authorized: (value) => fetchPosts(),
        notAuthorized: (value) => logOut(),
      );
    });
  }

  final PostRepo repo;
  final AuthCubit authCubit;
  late final StreamSubscription authSub;

  Future<void> fetchPosts() async{
    await repo.fetchPosts().then((value) {
      final Iterable iterable = value;
      emit(state.copyWith(
        postList: iterable.map((e) => PostEntity.fromJson(e)).toList(),
          asyncSnapshot:
          const AsyncSnapshot.withData(ConnectionState.done, true)));
    }).catchError((error) {
      addError(error);
    });
  }

  Future<void> createPost({String? content, String? image}) async{
    await repo.createPost(content: content, image: image).then((value) {
      fetchPosts();
    }).catchError((error) {
      addError(error);
    });
  }

  Future<void> deletePost(String id) async{
    await repo.deletePost(id).then((value) {
      fetchPosts();
    }).catchError((error) {
      addError(error);
    });
  }

  void logOut(){
    emit(state.copyWith(asyncSnapshot: const AsyncSnapshot.nothing(), postList: []));
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {
    emit(state.copyWith(
      asyncSnapshot: AsyncSnapshot.withError(ConnectionState.done, error)
    ));
    super.addError(error, stackTrace);
  }

  @override
  PostState? fromJson(Map<String, dynamic> json) {
    return PostState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(state) {
    return state.toJson();
  }

  @override
  Future<void> close() {
    return super.close();
  }
}