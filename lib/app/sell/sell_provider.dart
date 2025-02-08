import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listing/app/sell/sell_notifier.dart';
import 'package:listing/app/sell/sell_state.dart';

final sellProvider = StateNotifierProvider<SellNotifier, SellState>(
  (ref) => SellNotifier(),
);
