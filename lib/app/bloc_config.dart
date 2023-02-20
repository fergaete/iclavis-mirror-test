import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/authentication/authentication_bloc.dart';
import '../blocs/contacts/contacts_bloc.dart';
import '../blocs/first_start/first_start_bloc.dart';
import '../blocs/history_user_support/history_user_support_bloc.dart';
import '../blocs/history_user_support_gci/history_user_support_gci_bloc.dart';
import '../blocs/history_user_support_request/history_user_support_request_bloc.dart';
import '../blocs/new_request_user_support/new_request_user_support_bloc.dart';
import '../blocs/notification/notification_bloc.dart';
import '../blocs/payment/payment_bloc.dart';
import '../blocs/project/project_bloc.dart';
import '../blocs/project_user_support/project_user_support_bloc.dart';
import '../blocs/property/property_bloc.dart';
import '../blocs/user/user_bloc.dart';


class BlocConfig extends StatelessWidget {
  final Widget child;
  const BlocConfig({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => FirstStartBloc()),
        BlocProvider(create: (_) => UserBloc()),
        BlocProvider(create: (_) => ProjectBloc()),
        BlocProvider(create: (_) => PropertyBloc()),
        BlocProvider(create: (_) => PaymentBloc()),
        BlocProvider(create: (_) => ContactsBloc()),
        BlocProvider(create: (_) => HistoryUserSupportBloc()),
        BlocProvider(create: (_) => HistoryUserSupportGciBloc()),
        BlocProvider(create: (_) => HistoryUserSupportRequestBloc()),
        BlocProvider(create: (_) => NewRequestUserSupportBloc()),
        BlocProvider(create: (_) => ProjectUserSupportBloc()),
        BlocProvider(create: (_) => NotificationBloc()),
        BlocProvider(create: (context) => AuthenticationBloc(context)),
      ],
      child: child,
    );
  }
}
