import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/activity_provider.dart';
import 'activity_item.dart';

class ActivityList2 extends StatelessWidget {
  Future<void> _refreshactivity(BuildContext context) async {
    await Provider.of<ActivityProvider>(context, listen: false)
        .fetchAndSetActivity(context);
  }

  @override
  Widget build(BuildContext context) {
    final activityData = Provider.of<ActivityProvider>(context);
    final activities = activityData.activity;
    return RefreshIndicator(
      onRefresh: () => _refreshactivity(context),
      child: Padding(
        padding:
            EdgeInsets.only(left: MediaQuery.of(context).size.height * 0.001),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.57,
          child: ListView.builder(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
            itemCount: activities.length,
            itemBuilder: (_, i) => ChangeNotifierProvider.value(
              value: activities[i],
              child: ActivityItem2(
                activities[i].id,
                activities[i].type,
                activities[i].details,
                activities[i].date,
                activities[i].lead,
              ),
            ),
          ),
        ),
      ),
      //   ],
      // ),
    );
  }
}
