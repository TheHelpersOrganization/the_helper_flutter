import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class StepView {
  final Widget title;
  final Widget content;

  const StepView({
    required this.title,
    required this.content,
  });
}

List<Step> createSteps({
  required List<StepView> steps,
  required int currentStep,
}) {
  return steps
      .mapIndexed(
        (index, step) => createStep(
            currentStep: currentStep,
            index: index,
            title: step.title,
            content: step.content),
      )
      .toList();
}

Step createStep({
  required int currentStep,
  required int index,
  required Widget title,
  required Widget content,
}) =>
    Step(
      title: currentStep == index ? title : const Text(''),
      state: currentStep > index ? StepState.complete : StepState.indexed,
      isActive: currentStep >= index,
      content: content,
    );
