import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../provider/users.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_button.dart';
import '../widgets/edit_screen_textfields.dart';
import '../widgets/home_widget.dart';

class UserEdittingScreen extends StatefulWidget {
  @override
  State<UserEdittingScreen> createState() => _UserEdittingScreenState();
}

class _UserEdittingScreenState extends State<UserEdittingScreen> {
  var _edittedUsers = User(
    id: 0,
    userName: "",
    password: "",
    role: "",
    emailId: "",
    mobile: "",
    // createdBy: "0",
    // createdOn: DateTime.now(),
    // lastEditedBy: "",
    // lastEditedOn: DateTime.now(),
  );
  final form = GlobalKey<FormState>();
  final _PasswordFocusNode = FocusNode();
  final _roleFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  final _mobileFocusNode = FocusNode();
  final _passwordConroller = TextEditingController();

  // ignore: prefer_final_fields
  var _initValues = {
    'UserName': '',
    'Password': '',
    'Role': '',
    'EmailId': '',
    'Mobile': '',
  };
  var isInIt = true;

  @override
  void didChangeDependencies() {
    if (isInIt) {
      var userId = ModalRoute.of(context)?.settings.arguments as int?;
      print(
          "here is the user ............................................... id $userId");
      print('didchange id......$userId');
      if (userId != null) {
        _edittedUsers =
            Provider.of<Users>(context, listen: false).findById(userId);
        Provider.of<Users>(context, listen: false).findNameById(userId);
        _initValues = {
          'Username': _edittedUsers.userName!,
          'Password': _edittedUsers.password!,
          'Role': _edittedUsers.role!,
          'Email': _edittedUsers.emailId!,
          'Mobile': _edittedUsers.mobile!,
        };
      }
    }
    isInIt = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final users = Provider.of<Users>(context, listen: false);
    return Scaffold(
      appBar: CustomAppBar('EDIT'),
      body: HomeWidget(
        child: Form(
            key: form,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "UserName             ",
                                style: Theme.of(context).textTheme.headline2,
                              ),
                              Expanded(
                                child: Consumer<Users>(
                                  builder: ((context, value, child) => Text(
                                        "${value.userName}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2,
                                      )),
                                ),
                              ),
                            ],
                          ),

                          // EditScreentextFields(
                          //     initialValue: _initValues['Username'],
                          //     title: "User Name",
                          //     onSaved: (value) {
                          //       _edittedUsers = User(
                          //         userName: value,
                          //         password: _edittedUsers.password,
                          //         role: _edittedUsers.role,
                          //         emailId: _edittedUsers.emailId,
                          //         mobile: _edittedUsers.mobile,
                          //         id: _edittedUsers.id,
                          //         // createdBy: _edittedUsers.createdBy,
                          //         // createdOn: _edittedUsers.createdOn,
                          //         // lastEditedBy: _edittedUserss.lastEditedBy,
                          //         // lastEditedOn: _edittedUsers.lastEditedOn,
                          //       );
                          //     },
                          //     validator: (value) {
                          //       if (value!.isEmpty) {
                          //         return 'Please add a UserName.';
                          //       }
                          //       return null;
                          //     }),
                          const SizedBox(height: 20),
                          EditScreentextFields(
                              hintext: 'Add a new password',
                              title: "Password",
                              textInputAction: TextInputAction.next,
                              focusNode: _PasswordFocusNode,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_roleFocusNode);
                              },
                              onSaved: (value) {
                                _edittedUsers = User(
                                  userName: _edittedUsers.userName,
                                  password: value,
                                  role: _edittedUsers.role,
                                  emailId: _edittedUsers.emailId,
                                  mobile: _edittedUsers.mobile,
                                  id: _edittedUsers.id,
                                  // createdBy: _edittedUsers.createdBy,
                                  // createdOn: _edittedUsers.createdOn,
                                  // lastEditedBy: _edittedUserss.lastEditedBy,
                                  // lastEditedOn: _edittedUsers.lastEditedOn,
                                );
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please add a password.';
                                }
                                return null;
                              }),
                          const SizedBox(height: 20),
                          EditScreentextFields(
                              initialValue: _initValues['Role'],
                              focusNode: _roleFocusNode,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_emailFocusNode);
                              },
                              title: "Role",
                              onSaved: (value) {
                                _edittedUsers = User(
                                  userName: _edittedUsers.userName,
                                  password: _edittedUsers.password,
                                  role: value,
                                  emailId: _edittedUsers.emailId,
                                  mobile: _edittedUsers.mobile,
                                  id: _edittedUsers.id,
                                  // createdBy: _edittedUsers.createdBy,
                                  // createdOn: _edittedUsers.createdOn,
                                  // lastEditedBy: _edittedUserss.lastEditedBy,
                                  // lastEditedOn: _edittedUsers.lastEditedOn,
                                );
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please add an role.';
                                }
                                return null;
                              }),
                          const SizedBox(height: 20),
                          EditScreentextFields(
                              initialValue: _initValues['Email'],
                              focusNode: _emailFocusNode,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_mobileFocusNode);
                              },
                              title: "Email",
                              onSaved: (value) {
                                _edittedUsers = User(
                                  userName: _edittedUsers.userName,
                                  password: _edittedUsers.password,
                                  role: _edittedUsers.role,
                                  emailId: value,
                                  mobile: _edittedUsers.mobile,
                                  id: _edittedUsers.id,
                                  // createdBy: _edittedUsers.createdBy,
                                  // createdOn: _edittedUsers.createdOn,
                                  // lastEditedBy: _edittedUserss.lastEditedBy,
                                  // lastEditedOn: _edittedUsers.lastEditedOn,
                                );
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please add an email id.';
                                }
                                return null;
                              }),
                          const SizedBox(height: 20),
                          EditScreentextFields(
                              initialValue: _initValues['Mobile'],
                              focusNode: _mobileFocusNode,
                              title: "Mobile",
                              onSaved: (value) {
                                _edittedUsers = User(
                                  userName: _edittedUsers.userName,
                                  password: _edittedUsers.password,
                                  role: _edittedUsers.role,
                                  emailId: _edittedUsers.emailId,
                                  mobile: value,
                                  id: _edittedUsers.id,
                                  // createdBy: _edittedUsers.createdBy,
                                  // createdOn: _edittedUsers.createdOn,
                                  // lastEditedBy: _edittedUserss.lastEditedBy,
                                  // lastEditedOn: _edittedUsers.lastEditedOn,
                                );
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please add a mobile number.';
                                }
                                return null;
                              }),
                        ],
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomeButton(
                      butionText: "SAVE",
                      buttonTopPadding: 25,
                      buttionColor: const Color(0xff2182BA),
                      onPressed: () {
                        saveFormEditting();
                      },
                    ),
                    CustomeButton(
                      butionText: "CANCEL",
                      buttonTopPadding: 25,
                      buttionColor: const Color(0xff2182BA),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }

  Future<void> saveFormEditting() async {
    print("sdfsdfgsdghsghsg${_edittedUsers.id}");
    final isValid = form.currentState?.validate();
    if (!isValid!) {
      return;
    }
    form.currentState?.save();
    //  setState(() {
    //   _isLoading = true;
    // });
    Provider.of<Users>(context, listen: false)
        .updateUser(context, _edittedUsers.id!, _edittedUsers);

    Navigator.of(context).pop();
  }
}
