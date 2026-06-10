import 'package:injectable/injectable.dart';

@lazySingleton
class UnauthorizedNotifier {
  void Function()? onUnauthorized;

  void notify() => onUnauthorized?.call();
}
