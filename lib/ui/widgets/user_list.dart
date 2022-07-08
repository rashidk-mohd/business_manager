import 'package:business_manager/ui/widgets/user_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/users.dart';

class UserList extends StatelessWidget {
  Future<void> _refreshUser(BuildContext context) async {
    await Provider.of<Users>(context, listen: false).fetchAndSetUsers(context);
  }

  @override
  Widget build(BuildContext context) {
    final usersData = Provider.of<Users>(context, listen: false);
    final users = usersData.users;
    return RefreshIndicator(
      onRefresh: () => _refreshUser(context),
      child: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: users.length,
        itemBuilder: (_, i) => ChangeNotifierProvider.value(
          value: users[i],
          child: UserItem(
            users[i].id,
            users[i].userName,
            users[i].password,
            users[i].role,
            users[i].emailId,
            users[i].status,
            users[i].mobile,
          ),
        ),
      ),
    );
  }
}
