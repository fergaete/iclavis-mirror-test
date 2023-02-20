import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/blocs/payment/payment_bloc.dart';
import 'package:iclavis/blocs/project/project_bloc.dart';
import 'package:iclavis/blocs/user/user_bloc.dart';
import 'package:iclavis/models/project_model.dart';
import 'package:iclavis/models/user_model.dart';
import 'package:iclavis/widgets/widgets.dart';

import 'agreed_amounts.dart';
import 'future_payments.dart';
import 'payment_card.dart';
import 'payment_info_card.dart';
import 'payment_state_card.dart';
import 'payments_made.dart';
import 'purchase_detail.dart';

final itemWidth = 360.w;

class PaymentViews extends StatefulWidget {
  const PaymentViews({super.key});

  @override
  _PaymentViewsState createState() => _PaymentViewsState();
}

class _PaymentViewsState extends State<PaymentViews>
    with SingleTickerProviderStateMixin {
  final PageController controller = PageController(initialPage: 0);
  late TabController tabController;
  late PaymentBloc bloc;
  late UserModel user;
  late ProjectModel currentProject;

  @override
  void initState() {
    tabController = TabController(length: 3, initialIndex: 0, vsync: this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    bloc = context.read<PaymentBloc>();

    user = (context.read<UserBloc>().state as UserSuccess).user;

    if (bloc.state is! PaymentSuccess) {
      List<ProjectModel> projects =
          (context.read<ProjectBloc>().state as ProjectSuccess).result.data;

      currentProject =
          projects.firstWhere((p) => p.isCurrent, orElse: () => projects.first);

      bloc.add(
        PaymentLoaded(
          dni: user.dni!,
          id: currentProject.proyecto!.gci!.id!,
          apiKey: currentProject.inmobiliaria!.gci!.apikey!,
        ),
      );
    }

    super.didChangeDependencies();
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //super.build(context);

    final projectsState = context.watch<ProjectBloc>().state;

    if (projectsState is ProjectSuccess) {
      List<ProjectModel> projects = projectsState.result.data;

      currentProject = projects.firstWhere((p) => p.isCurrent);
    }

    return RefreshIndicator(
      onRefresh: () async {
        bloc.add(
          PaymentLoaded(
            dni: user.dni!,
            id: currentProject.proyecto!.gci!.id!,
            apiKey: currentProject.inmobiliaria!.gci!.apikey!,
          ),
        );
      },
      child: BlocConsumer<PaymentBloc, PaymentState>(
        listener: (_, state) {
          if (state is PaymentFailure) {
            if (state.result.message!.contains('server')) {
              ModalOverlay(
                context: context,
                message: 'Parece que hay problemas con nuestro servidor.'
                    ' Aprovecha de despejar la mente e intenta más tarde.',
                title: '¡Ups!',
                buttonTitle: 'Entendido',
              );
            }
          }
        },
        builder: (_, state) {
          if (state is PaymentSuccess) {
            return _View(
              tabController: tabController,
            );
          } else if (state is PaymentFailure) {
            return Center(child: Text(state.result.message ?? ''));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _View extends StatelessWidget {
  final TabController tabController;
  const _View({Key? key, required this.tabController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const PaymentCard(),
        SizedBox(height: 15.h),
        PaymentStateCard(
          tabController: tabController,
          itemWidth: itemWidth,
        ),
        Expanded(
          child: TabBarView(
            //scrollDirection: Axis.horizontal,
            controller: tabController,
            physics: const NeverScrollableScrollPhysics(),
            //padding: EdgeInsets.only(bottom: 50.h),
            children: [
              SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: SizedBox(
                    width: itemWidth,
                    child: Column(
                      children: [
                        AlertWidget(
                            text:
                                "Los montos en pesos están calculados en base "
                                "al valor de la UF del día en que se pactó el negocio "),
                        const PaymentInfoCard(),
                        SizedBox(height: 30.h),
                        const FuturePayments(),
                      ],
                    ),
                  )),
              SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: SizedBox(
                    width: itemWidth,
                    child: const PaymentsMade(),
                  )),
              SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: SizedBox(
                    width: itemWidth,
                    child: Column(
                      children: [
                        const PurchaseDetail(),
                        SizedBox(height: 30.h),
                        const AgreedAmounts(),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
