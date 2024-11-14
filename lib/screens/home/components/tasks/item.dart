import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salin/constants/colors.dart';
import 'package:salin/constants/task-colors.dart';
import 'package:salin/controllers/main-controller.dart';
import 'package:salin/models/tasks.dart';

class TasksItem extends StatefulWidget {
  final int index;
  const TasksItem({super.key, required this.index});

  @override
  _TasksItemState createState() => _TasksItemState();
}

class _TasksItemState extends State<TasksItem> {
  bool _delete = false;
  double _opacity = 0.0;
  bool _isDark = false;

  @override
  void initState() {
    super.initState();
    _isDark =
        WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
    _animationController();
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
    _isDark = brightnessValue == Brightness.dark;

    return GetBuilder<MainController>(builder: (_) {
      return AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 500),
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Slidable(
            key: Key("${_.tasks[widget.index][0]}${widget.index}"),
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) => _removeTask(),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) => _removeTask(),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 70,
              margin: const EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 0.001,
                  ),
                ],
                color: _isDark ? kDarkBackgroundColor : Colors.white,
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Transform.scale(
                      scale: 1.2,
                      child: Checkbox(
                        activeColor: Colors.grey,
                        checkColor: Colors.white,
                        value: _.tasks[widget.index][2] == 'done',
                        onChanged: (value) {
                          updateTask(index: widget.index);
                        },
                      ),
                    ),
                  ),
                  Text(
                    _.tasks[widget.index][0],
                    style: GoogleFonts.ubuntu(
                      color: _.tasks[widget.index][2] == 'done'
                          ? Colors.grey
                          : _isDark
                              ? Colors.white
                              : colors[int.parse(_.tasks[widget.index][1])],
                      fontWeight: FontWeight.w500,
                      fontSize: 17.5,
                      decoration: _.tasks[widget.index][2] == 'done'
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Future<void> _animationController() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    await Future.delayed(Duration(
        milliseconds:
            500 * (Get.find<MainController>().tasks.length - widget.index)));
    setState(() {
      _opacity = 1;
    });
  }

  void _removeTask() async {
    setState(() {
      _delete = true;
    });
    await Future.delayed(const Duration(milliseconds: 3500));
    if (_delete) {
      setState(() {
        _delete = false;
      });
      removeTask(index: widget.index);
    }
  }
}
