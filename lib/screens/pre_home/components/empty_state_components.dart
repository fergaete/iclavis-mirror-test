import 'package:flutter/material.dart';

import 'package:iclavis/widgets/widgets.dart';

class EmptyState extends StatefulWidget {
  const EmptyState({super.key});

  @override
  State<EmptyState> createState() => _EmptyStateState();
}

class _EmptyStateState extends State<EmptyState> {


  @override
  void initState() {

    super.initState();
  }
  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((_) {

      ModalOverlay(
        context: context,
        message: 'Parece que hay problemas con nuestro servidor.'
            ' Aprovecha de despejar la mente e intenta más tarde.',
        title: '¡Ups!',
        buttonTitle: 'Entendido',
        colorAllText: Colors.white,
        backgroundColor: Color(0xff1A2341),
      );

    });


    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {

    return Container(
      child: Text("sqdq"),
    );
  }
}
