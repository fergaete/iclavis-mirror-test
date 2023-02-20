part of 'video_bloc.dart';

abstract class VideoState extends Equatable {
  const VideoState();

  @override
  List<Object> get props => [];
}

class VideoInitial extends VideoState {}

class VideoInProgress extends VideoState {}

class VideoSuccess extends VideoState {
  final Result result;

  const VideoSuccess({required this.result});

  @override
  List<Object> get props => [result];

  @override
  String toString() => 'VideoSuccess { Result: $result }';
}

class VideoFailure extends VideoState {
  final Result result;

  const VideoFailure({required this.result});

  @override
  List<Object> get props => [result];

  @override
  String toString() => 'VideoFailure { Result: $result }';
}
