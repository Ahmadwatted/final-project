import 'package:flutter/material.dart';
import '../../Models/schedule.dart';
import 'Confirm_Del.dart';
import 'Random_color.dart';

class ScheduleCard extends StatelessWidget {
  final Schedule schedule;
  final bool isStudent;
  final Function onTaskDeleted;
  final Color courseColor = RandomColor.getRandomShade700();

  ScheduleCard({
    Key? key,
    required this.schedule,
    this.isStudent = true,
    required this.onTaskDeleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: Colors.blue[600],
              ),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  schedule.course,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              if(!isStudent)
                SizedBox(
                  width: 24,
                  height: 24,
                  child: IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (dialogContext) => TaskDeleteAlert(
                          taskID: schedule.scheduleID,
                          onTaskDeleted: onTaskDeleted,
                        ),
                      ).then((result) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              result == true
                                  ? 'Schedule deleted successfully!'
                                  : 'Failed to delete schedule.',
                            ),
                          ),
                        );
                      });
                    },
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    splashRadius: 18,
                  ),
                ),
            ],
          ),
          SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.person, color: Colors.grey, size: 14),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  schedule.tutor,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[500],
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.event, color: Colors.grey, size: 14),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  schedule.day,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.access_time, color: Colors.grey, size: 14),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  schedule.time,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.location_on, color: Colors.grey, size: 14),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  schedule.location,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[500],
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}