// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:to_do/Widgets/colors.dart';

class TaskTile extends StatefulWidget {
  final String text;
  void Function()? onTap;

  TaskTile({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  //Checkbox val checker
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.08,
      decoration: BoxDecoration(
        color: isChecked ? Colors.grey : Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Checkbox.adaptive(
                  activeColor: blue,
                  checkColor: Colors.white,
                  side: const BorderSide(color: Colors.black),
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value!;
                      // isChecked = !isChecked;
                    });

                    //Show Snackbar When task completed
                    if (isChecked == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 3),
                          content: Text(
                            'Task Completed',
                            style: TextStyle(
                              color: black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),

                //Task Text
                Flexible(
                  child: Text(
                    widget.text,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: TextStyle(
                      color: isChecked ? Colors.white : black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      decoration: isChecked
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          //Delete Icon
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 15),
            child: GestureDetector(
              onTap: widget.onTap,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: red,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
