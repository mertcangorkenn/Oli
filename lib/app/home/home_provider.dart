import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listing/app/home/home_notifier.dart';
import 'package:listing/app/home/home_state.dart';

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>(
  (ref) => HomeNotifier(),
);
