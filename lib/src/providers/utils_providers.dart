import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/student_model.dart';

part 'utils_providers.g.dart';

@Riverpod(keepAlive: true)
class MyUser extends _$MyUser {
  @override
  Student? build() {
    return null;
  }

  void update(Student? a) {
    state = a;
  }
}

@riverpod
class MyPhoto extends _$MyPhoto {
  @override
  Image? build() {
    return null;
  }

  void update(String? url) {
    if (url != null) state = Image.network(url);
  }
}

@riverpod
class NavigationIndex extends _$NavigationIndex {
  @override
  int build() {
    return 0;
  }

  void update(int a) => state = a;
}

@riverpod
class TimeRemaining extends _$TimeRemaining {
  @override
  double build() {
    return 0;
  }

  void decrease(Duration step) {
    state -= step.inMilliseconds.toDouble() / 1000;
    if (state <= 0) state = 0;
  }

  void set(double time) {
    state = time;
  }
}

// @riverpod
// class EmailVerified extends _$EmailVerified {
//   @override
//   bool build() {
//     return false;
//   }

//   void update(bool a) => state = a;
// }
