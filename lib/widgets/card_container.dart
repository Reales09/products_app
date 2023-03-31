import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  const CardContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        width: double.infinity,
        height: 300, //TODO borrar
        decoration: _createCardShape(),
      ),
    );
  }

  BoxDecoration _createCardShape() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      );
}
