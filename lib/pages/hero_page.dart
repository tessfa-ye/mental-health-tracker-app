import 'package:flutter/material.dart';
import 'package:mentalassessment/components/lottie_widget.dart';

class HeroPage extends StatefulWidget {
  const HeroPage({super.key});

  @override
  State<HeroPage> createState() => _HeroPageState();
}

class _HeroPageState extends State<HeroPage> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        LottieWidget(
          path: 'assets/animations/43792-yoga-se-hi-hoga.json',
        ),
        //MotivationWidget(),
      ],
    );
  }
}
