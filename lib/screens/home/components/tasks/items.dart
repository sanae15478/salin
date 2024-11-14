import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ms_undraw/ms_undraw.dart';
import 'package:salin/constants/colors.dart';
import 'package:salin/controllers/main-controller.dart';
import 'package:salin/screens/home/animations.dart';
import 'package:salin/screens/home/components/tasks/item.dart';

class HomeTasksItems extends StatefulWidget {
  const HomeTasksItems({super.key});

  @override
  _HomeTasksItemsState createState() => _HomeTasksItemsState();
}

class _HomeTasksItemsState extends State<HomeTasksItems> {
  late bool _isDark;
  @override
  Widget build(BuildContext context) {
    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
    _isDark = brightnessValue == Brightness.dark;
    return GetBuilder<HomeAnimationsController>(builder: (__) {
      return GetBuilder<MainController>(
        builder: (_) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 0),
            child: _.tasks.isNotEmpty
                ? ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _.tasks.length,
                    itemBuilder: (context, index) {
                      return TasksItem(
                        index: index,
                      );
                    },
                  )
                : AnimatedOpacity(
                    opacity: __.notFoundOpacity,
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 100,
                        ),
                        Text(
                          "You have no task for today!",
                          style: GoogleFonts.ubuntu(
                              color: _isDark
                                  ? kBackgroundColor.withOpacity(0.8)
                                  : kSecondaryColor,
                              fontSize: 22.2,
                              fontWeight: FontWeight.w700),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 50, right: 50),
                          child: UnDraw(
                            height: MediaQuery.of(context).size.width - 100,
                            color: _isDark
                                ? kBackgroundColor.withOpacity(0.8)
                                : kSecondaryColor,
                            illustration: UnDrawIllustration.not_found,
                            placeholder: Padding(
                              padding: const EdgeInsets.only(top: 100),
                              child: SpinKitDoubleBounce(
                                color: _isDark
                                    ? kBackgroundColor.withOpacity(0.8)
                                    : kSecondaryColor,
                                size: 75,
                              ),
                            ),
                            errorWidget: const Icon(Icons.error_outline,
                                color: Colors.red, size: 50),
                          ),
                        ),
                      ],
                    )),
                  ),
          );
        },
      );
    });
  }
}
