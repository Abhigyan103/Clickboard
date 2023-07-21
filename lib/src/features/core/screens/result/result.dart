import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jgec_notice/src/common_widgets/my_app_bar.dart';
import 'package:jgec_notice/src/constants/image_strings.dart';
import 'package:jgec_notice/src/features/core/controllers/profile_controller.dart';
import 'widgets/search_result_form.dart';

class ResultByRoll extends StatelessWidget {
  const ResultByRoll({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context: context, title: 'Search Result'),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              children: [
                SizedBox.square(
                  dimension: 200,
                  child: SvgPicture.asset(searchResult),
                ),
                const SearchResultForm(),
                const SizedBox(
                  height: 20,
                ),
                Obx(() {
                  List data =
                      ProfileController.instance.searchedResults.toList();
                  if (data.whereType<Reference>().isNotEmpty) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          if (data[index] != null) {
                            return Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 3.5,
                                  child: FilledButton(
                                    onPressed: () => ProfileController.instance
                                        .openResultFromRoll(index),
                                    child: Text('Sem ${index + 1}'),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                )
                              ],
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                        itemCount: data.length,
                      ),
                    );
                  }
                  return const SizedBox();
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
