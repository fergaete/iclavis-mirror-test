import 'dart:async';

import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclavis/blocs/notification/notification_bloc.dart';

import 'package:iclavis/blocs/project/project_bloc.dart';
import 'package:iclavis/blocs/property/property_bloc.dart';
import 'package:iclavis/blocs/history_user_support/history_user_support_bloc.dart';
import 'package:iclavis/blocs/payment/payment_bloc.dart';
import 'package:iclavis/services/user_identity/user_identity_repository.dart';
import 'package:iclavis/models/user_model.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated, error }

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(BuildContext context)
      : super(const AuthenticationState.unknown()) {

    final UserIdentityRepository userIdentityRepository =
        UserIdentityRepository();

    void loggedOut() async {
      await userIdentityRepository.signOut();
      context
        ..read<ProjectBloc>().add(ProjectChanged())
        ..read<PropertyBloc>().add(PropertyChanged())
        ..read<PaymentBloc>().add(PaymentAccountChanged())
        ..read<HistoryUserSupportBloc>().add(HistoryUserSupportChanged())
        ..read<NotificationBloc>().add(NotificationChanged());
      // await HydratedBloc.storage.clear();
    }

    on<AuthenticationSessionValidated>((event, emit) async {
      try {
        bool? hasSession = await userIdentityRepository.checkAuth() ?? false;
        if (hasSession) {
          emit(const AuthenticationState.authenticated());
        } else {
         // loggedOut();
          emit(const AuthenticationState.unauthenticated());
        }
      } catch (e) {
        emit(AuthenticationState.error(error: e));
      }
    });
    on<AuthenticationLoggedOut>((event, emit) async {
      try {
        loggedOut();
        emit(AuthenticationState.unauthenticated());
      } catch (e) {
        emit(AuthenticationState.error());
      }
    });
  }

  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationSessionValidated) {}

    if (event is AuthenticationLoggedOut) {}
  }
}
