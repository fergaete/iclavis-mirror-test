part of 'image_bloc.dart';

abstract class ImageState extends Equatable {
  const ImageState();

  @override
  List<Object> get props => [];
}

class ImageInitial extends ImageState {}

class ImageInProgress extends ImageState {}

class ImageSuccess extends ImageState {
  final Result result;

  const ImageSuccess({required this.result});

  @override
  List<Object> get props => [result];

  @override
  String toString() => 'ImageSuccess { Result: $result }';
}

class ImageFailure extends ImageState {
  final Result result;

  const ImageFailure({required this.result});

  @override
  List<Object> get props => [result];

  @override
  String toString() => 'ImageFailure { Result: $result }';
}
