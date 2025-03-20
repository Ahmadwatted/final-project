
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
      padding: EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 20,
                color: Colors.blue[600],
              ),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  schedule.course,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              )
              ,if(!isStudent)...{
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
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
                                ? 'schedule deleted successfully!'
                                : 'Failed to delete schedule.',
                          ),
                        ),
                      );
                    });
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 24,
                ),




              },






            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.person, color: Colors.grey,),
              Text(
                schedule.tutor,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),

            ],
          ),
          SizedBox(height: 5),
          Text(
            schedule.day,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          Text(
            schedule.time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.grey,),
              Text(
                schedule.location,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}