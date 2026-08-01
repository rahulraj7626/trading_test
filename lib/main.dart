import 'package:flutter/material.dart';
import 'core/app/app.dart';
import 'core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initInjection();
  runApp(const TradingApp());
}
