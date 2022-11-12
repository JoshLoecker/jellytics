import 'package:flutter/material.dart';

class StatisticsView extends StatefulWidget {
  const StatisticsView({super.key});

  @override
  State<StatisticsView> createState() => _StatisticsState();
}

class _StatisticsState extends State<StatisticsView> {
  @override
  Widget build(BuildContext context) {
    return const Text("Statistics");
  }
}

const Widget statisticsContent = StatisticsView();
