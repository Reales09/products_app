import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: _redBackground(),
      child: Stack(
        children: [
          Positioned(
            child: _Bubble(),
            top: 90,
            left: 30,
            // child: _IconHeader(),
          ),
          Positioned(
            child: _Bubble(),
            top: -40,
            left: -30,
            // child: _IconHeader(),
          ),
          Positioned(
            child: _Bubble(),
            top: -50,
            right: -20,
            // child: _IconHeader(),
          ),
          Positioned(
            child: _Bubble(),
            bottom: -50,
            left: 10,
            // child: _IconHeader(),
          ),
          Positioned(
            child: _Bubble(),
            bottom: 120,
            right: 20,
            // child: _IconHeader(),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _redBackground() => BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.2, 0.8],
        colors: [
          Color.fromRGBO(252, 35, 49, 1),
          Color.fromRGBO(249, 59, 116, 1),
        ],
      ),
    );

class _Bubble extends StatelessWidget {
  const _Bubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Colors.white.withOpacity(0.20),
      ),
    );
  }
}
