import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:salin/constants/types.dart';

class HomeController extends GetxController {
  final advancedDrawerController = AdvancedDrawerController();

  DrawerStatus drawerStatus = DrawerStatus.CLOSE;
  changeDrawerStatus() {
    drawerStatus = drawerStatus == DrawerStatus.CLOSE
        ? DrawerStatus.OPEN
        : DrawerStatus.CLOSE;
    update();
  }
}
