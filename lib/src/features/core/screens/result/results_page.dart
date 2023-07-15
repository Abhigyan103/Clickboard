import 'package:flutter/material.dart';
import 'widgets/all_results.dart';
import 'widgets/latest_result.dart';
import 'widgets/result_by_roll.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [LatestResult(), SizedBox(height: 20), AllResults()],
              ),
            ),
          ),
          ResultByRollNumber()
        ],
      ),
    );
  }
}
