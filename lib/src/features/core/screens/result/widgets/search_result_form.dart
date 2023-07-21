import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jgec_notice/src/features/core/controllers/profile_controller.dart';

import '../../../../../common_widgets/input_box.dart';
import '../../../../../common_widgets/large_button.dart';
import '../../../../../constants/text_strings.dart';
import '../../../../validators/validators.dart';
import '../../../controllers/result_controller.dart';

class SearchResultForm extends StatelessWidget {
  const SearchResultForm({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    ResultController resultController = Get.put(ResultController());
    return Form(
      key: formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          const Align(alignment: Alignment.centerLeft, child: Text('Roll number :')),
          const SizedBox(
            height: 10,
          ),
          InputBox(
            validator: rollValidate,
            inputControl: resultController.rollCont,
            hint: rollHint,
            icon: Icons.numbers_outlined,
            inputType: TextInputType.number,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Semester :'),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Obx(
                  () => DropdownButton(
                      isExpanded: true,
                      items: ResultController.semDropdownList,
                      value: resultController.dropdownValue.value,
                      onChanged: resultController.dropdownCallback),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          MainButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  int sem = int.parse(resultController.dropdownValue.value);
                  String roll = resultController.rollCont.text;
                  if (sem != 0) {
                    await ProfileController.instance
                        .getResultFromRollAndSem(roll, sem);
                  } else {
                    await ProfileController.instance
                        .getAllResultsFromRoll(roll);
                  }
                }
              },
              text: 'Search')
        ],
      ),
    );
  }
}
