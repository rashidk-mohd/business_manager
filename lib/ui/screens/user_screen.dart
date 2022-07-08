import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/users.dart';
import '../../utils/color_constants.dart';
import '../../utils/routes.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/user_list.dart';

class UserScreen extends StatefulWidget {
  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  var _isLoading = false;
  var _isInit = true;

  // @override
  // void initState() {
  //   Future.delayed(Duration.zero).then((_) {
  //     Provider.of<Users>(context, listen: false).fetchAndSetUsers();
  //   });
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Users>(context).fetchAndSetUsers(context).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.backGroundColor,
        appBar: CustomAppBar(
          'USER',
          actionButton: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                icon: const Icon(Icons.add),
                iconSize: 35,
                onPressed: () {
                  Navigator.pushNamed(context, Routes.routeUserAddingScreen);
                },
              ),
            ),
          ],
        ),
        body: _isLoading
            ? Center(
                child: Container(
                    height: 250,
                    width: 250,
                    child: Image.asset("assets/loading.gif")),
              )
            : UserList());
  }
}
