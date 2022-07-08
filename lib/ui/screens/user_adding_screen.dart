import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../provider/users.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/home_widget.dart';

class UserAddingScreen extends StatefulWidget {
  const UserAddingScreen({Key? key}) : super(key: key);

  @override
  State<UserAddingScreen> createState() => _UserAddingScreenState();
}

class _UserAddingScreenState extends State<UserAddingScreen> {
  var addUser = User(
    id: null,
    userName: '',
    password: '',
    role: '',
    emailId: '',
    mobile: '',
  );
  final _PasswordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _roleFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  final _mobileFocusNode = FocusNode();
  final _passwordConroller = TextEditingController();

  var _isLoading = false;

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Users>(context, listen: false)
          .addUser(context, addUser);

      Navigator.of(context).pop();
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('An error occurred!'),
          content: const Text('Something went wrong.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        'ADD USER',
        actionButton: const [
          Padding(
            padding: const EdgeInsets.only(right: 8),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : HomeWidget(
              child: Form(
                key: _form,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          CustomTextField(
                            horizontalPadding: 27,
                            hintext: 'Username',
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_PasswordFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please provide a username.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              addUser = User(
                                userName: value,
                                password: addUser.password,
                                role: addUser.role,
                                emailId: addUser.emailId,
                                id: addUser.id,
                              );
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          CustomTextField(
                            horizontalPadding: 27,
                            hintext: 'New Password',
                            focusNode: _PasswordFocusNode,
                            textInputAction: TextInputAction.next,
                            controller: _passwordConroller,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_confirmPasswordFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty || value.length < 5) {
                                return "Password is too short";
                              }
                            },
                            onSaved: (value) {
                              addUser = User(
                                userName: addUser.userName,
                                password: value,
                                role: addUser.role,
                                emailId: addUser.emailId,
                                mobile: addUser.mobile,
                                id: addUser.id,
                              );
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          CustomTextField(
                            horizontalPadding: 27,
                            hintext: 'Confirm Password',
                            focusNode: _confirmPasswordFocusNode,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_roleFocusNode);
                            },
                            validator: (value) {
                              if (value != _passwordConroller.text) {
                                return "Passwords do not match!";
                              }
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          CustomTextField(
                            horizontalPadding: 27,
                            hintext: 'Role',
                            textInputAction: TextInputAction.next,
                            focusNode: _roleFocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_emailFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please provide a value.';
                              }
                              // return null;
                            },
                            onSaved: (value) {
                              addUser = User(
                                userName: addUser.userName,
                                password: addUser.password,
                                role: value,
                                emailId: addUser.emailId,
                                id: addUser.id,
                              );
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          CustomTextField(
                            horizontalPadding: 27,
                            focusNode: _emailFocusNode,
                            hintext: 'Email',
                            keyboardType: TextInputType.emailAddress,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_mobileFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty || !value.contains("@")) {
                                return 'Invalid email!';
                              }
                              // return null;
                            },
                            onSaved: (value) {
                              addUser = User(
                                userName: addUser.userName,
                                password: addUser.password,
                                role: addUser.role,
                                emailId: value,
                                mobile: addUser.mobile,
                                id: addUser.id,
                              );
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          CustomTextField(
                            horizontalPadding: 27,
                            hintext: 'Mobile',
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            focusNode: _mobileFocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_mobileFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a Mobile Number.';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Please enter a valid number.';
                              }
                            },
                            onSaved: (value) {
                              addUser = User(
                                userName: addUser.userName,
                                password: addUser.password,
                                role: addUser.role,
                                emailId: addUser.emailId,
                                mobile: value,
                                id: addUser.id,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomeButton(
                          butionText: "ADD",
                          buttonTopPadding: 25,
                          buttionColor: const Color(0xff2182BA),
                          onPressed: _saveForm,
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
                ),
              ),
            ),
    );
  }
}







































//-------------------------------------------------------------------------------------------------------------------------------------------------
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:qksales_frontend/models/user_model.dart';
// import 'package:qksales_frontend/ui/widgets/custom_appbar.dart';
// import 'package:qksales_frontend/ui/widgets/custom_button.dart';
// import 'package:qksales_frontend/ui/widgets/custom_text_field.dart';
// import 'package:qksales_frontend/ui/widgets/home_widget.dart';
// import 'package:qksales_frontend/provider/users.dart';

// class UserAddingScreen extends StatefulWidget {
//   UserAddingScreen({Key? key}) : super(key: key);

//   @override
//   State<UserAddingScreen> createState() => _UserAddingScreenState();
// }

// class _UserAddingScreenState extends State<UserAddingScreen> {
//   final form = GlobalKey<FormState>();
//    final _PasswordFocusNode = FocusNode();
//   final _confirmPasswordFocusNode = FocusNode();
//   final _roleFocusNode = FocusNode();
//   final _emailFocusNode = FocusNode();
//   final _form = GlobalKey<FormState>();
//   final _mobileFocusNode = FocusNode();
//   final _passwordConroller = TextEditingController();
//   var _editedUser = User(
//     id: 0,
//     userName: '',
//     password: '',
//     role: '',
//     emailId: '',
//     mobile: '',
//   );
//   var _intValues = {
//     'userName': '',
//     'password': '',
//     'role': '',
//     'email': '',
//     'mobile': '',
//   };
//   var _isInit = true;
//   var _isLoading = false;

//   @override
//   void didChangeDependencies() {
//     if (_isInit) {
//       final userId = ModalRoute.of(context)!.settings.arguments as dynamic;
//       if (userId != null) {
//         _editedUser =
//             Provider.of<Users>(context, listen: false).findById(userId);
//         _intValues = {
//           'userName': _editedUser.userName!,
//           'password': _editedUser.password!,
//           'role': _editedUser.role!,
//           'email': _editedUser.emailId!,
//           'mobile': _editedUser.mobile.toString(),
//         };
//       }
//     }
//     _isInit = false;
//     super.didChangeDependencies();
//   }

//   Future<void> _saveForm() async {
//     final isValid = _form.currentState!.validate();
//     if (!isValid) {
//       return;
//     }
//     _form.currentState!.save();
//     setState(() {
//       _isLoading = true;
//     });
//     if (_editedUser.id != null) {
//       await Provider.of<Users>(context, listen: false)
//           .updateUser(_editedUser.id, _editedUser);
//     } else {
//       try {
//         await Provider.of<Users>(context, listen: false).addUser(_editedUser);
//       } catch (error) {
//         await showDialog<void>(
//           context: context,
//           builder: (ctx) => AlertDialog(
//             title: Text('An error occurred!'),
//             content: Text('Something went wrong.'),
//             actions: <Widget>[
//               FlatButton(
//                 child: Text('Okay'),
//                 onPressed: () {
//                   Navigator.of(ctx).pop();
//                 },
//               )
//             ],
//           ),
//         );
//       }
//     }
//     setState(() {
//       _isLoading = false;
//     });
//     Navigator.of(context).pop();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: CustomAppBar(
//           'ADD USER',
//           actionButton: const [
//             Padding(
//               padding: const EdgeInsets.only(right: 8),
//             ),
//           ],
//         ),
//         body: HomeWidget(
//           child: _isLoading
//               ? Center(
//                   child: CircularProgressIndicator(),
//                 )
//               : Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Form(
//                     key: _form,
//                     child: ListView(
//                       children: [
//                         Column(
//                           children: [
//                             const SizedBox(
//                               height: 12,
//                             ),
//                             CustomTextField(
//                               initialValue: _intValues['Username'],
//                               horizontalPadding: 27,
//                               hintext: 'Username',
//                               textInputAction: TextInputAction.next,
//                               onFieldSubmitted: (_) {
//                                 FocusScope.of(context)
//                                     .requestFocus(_PasswordFocusNode);
//                               },
//                               validator: (value) {
//                                 if (value!.isEmpty) {
//                                   return 'Please provide a username.';
//                                 }
//                                 return null;
//                               },
//                               onSaved: (value) {
//                                 _editedUser = User(
//                                   userName: value,
//                                   password: _editedUser.password,
//                                   role: _editedUser.role,
//                                   emailId: _editedUser.emailId,
//                                   id: _editedUser.id,
//                                 );
//                               },
//                             ),
//                             const SizedBox(
//                               height: 12,
//                             ),
//                             CustomTextField(
//                               initialValue: _intValues['New Password'],
//                               horizontalPadding: 27,
//                               hintext: 'New Password',
//                               focusNode: _PasswordFocusNode,
//                               textInputAction: TextInputAction.next,
//                               controller: _passwordConroller,
//                               onFieldSubmitted: (_) {
//                                 FocusScope.of(context)
//                                     .requestFocus(_confirmPasswordFocusNode);
//                               },
//                               validator: (value) {
//                                 if (value!.isEmpty || value.length < 5) {
//                                   return "Password is too short";
//                                 }
//                               },
//                               onSaved: (value) {
//                                 _editedUser = User(
//                                   userName: _editedUser.userName,
//                                   password: value,
//                                   role: _editedUser.role,
//                                   emailId: _editedUser.emailId,
//                                   mobile: _editedUser.mobile,
//                                   id: _editedUser.id,
//                                 );
//                               },
//                             ),
//                             const SizedBox(
//                               height: 12,
//                             ),
//                             CustomTextField(
//                               initialValue: _intValues['Confirm Password'],
//                               horizontalPadding: 27,
//                               hintext: 'Confirm Password',
//                               focusNode: _confirmPasswordFocusNode,
//                               textInputAction: TextInputAction.next,
//                               onFieldSubmitted: (_) {
//                                 FocusScope.of(context)
//                                     .requestFocus(_roleFocusNode);
//                               },
//                               validator: (value) {
//                                 if (value != _passwordConroller.text) {
//                                   return "Passwords do not match!";
//                                 }
//                               },
//                             ),
//                             const SizedBox(
//                               height: 12,
//                             ),
//                             CustomTextField(
//                               initialValue: _intValues['Role'],
//                               horizontalPadding: 27,
//                               hintext: 'Role',
                              
//                               textInputAction: TextInputAction.next,
//                               focusNode: _roleFocusNode,
//                               onFieldSubmitted: (_) {
//                                 FocusScope.of(context)
//                                     .requestFocus(_emailFocusNode);
//                               },
//                               validator: (value) {
//                                 if (value!.isEmpty) {
//                                   return 'Please provide a value.';
//                                 }
//                                 // return null;
//                               },
//                               onSaved: (value) {
//                                 _editedUser = User(
//                                   userName: _editedUser.userName,
//                                   password: _editedUser.password,
//                                   role: value,
//                                   emailId: _editedUser.emailId,
//                                   id: _editedUser.id,
//                                 );
//                               },
//                             ),
//                             const SizedBox(
//                               height: 12,
//                             ),
//                             CustomTextField(
//                               initialValue: _intValues['email'],
//                               horizontalPadding: 27,
//                               focusNode: _emailFocusNode,
//                               hintext: 'Email',
//                               keyboardType: TextInputType.emailAddress,
//                               onFieldSubmitted: (_) {
//                                 FocusScope.of(context)
//                                     .requestFocus(_mobileFocusNode);
//                               },
//                               validator: (value) {
//                                 if (value!.isEmpty || !value.contains("@")) {
//                                   return 'Invalid email!';
//                                 }
//                                 // return null;
//                               },
//                               onSaved: (value) {
//                                 _editedUser = User(
//                                   userName: _editedUser.userName,
//                                   password: _editedUser.password,
//                                   role: _editedUser.role,
//                                   emailId: value,
//                                   mobile: _editedUser.mobile,
//                                   id: _editedUser.id,
//                                 );
//                               },
//                             ),
//                             const SizedBox(
//                               height: 12,
//                             ),
//                             CustomTextField(
//                               initialValue: _intValues['Mobile'],
//                               horizontalPadding: 27,
//                               hintext: 'Mobile',
                              
//                               textInputAction: TextInputAction.next,
//                               keyboardType: TextInputType.number,
//                               focusNode: _mobileFocusNode,
//                               onFieldSubmitted: (_) {
//                                 FocusScope.of(context)
//                                     .requestFocus(_mobileFocusNode);
//                               },
//                               validator: (value) {
//                                 if (value!.isEmpty) {
//                                   return 'Please enter a Mobile Number.';
//                                 }
//                                 if (int.tryParse(value) == null) {
//                                   return 'Please enter a valid number.';
//                                 }
//                               },
//                               onSaved: (value) {
//                                 _editedUser = User(
//                                   userName: _editedUser.userName,
//                                   password: _editedUser.password,
//                                   role: _editedUser.role,
//                                   emailId: _editedUser.emailId,
//                                   mobile: value,
//                                   id: _editedUser.id,
//                                 );
//                               },
//                             ),
//                             // CustomTextField(
//                             //   hintext: 'Status',
//                             //   horizontalPadding: 27,

//                             // )
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             CustomeButton(
//                               butionText: "ADD",
//                               buttonTopPadding: 25,
//                               buttionColor: const Color(0xff2182BA),
//                               onPressed: _saveForm,
//                             ),
//                             CustomeButton(
//                               butionText: "CANCEL",
//                               buttonTopPadding: 25,
//                               buttionColor: const Color(0xff2182BA),
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                               },
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//         ));
//   }

//   // void saveForm() {
//   //   final isValid = form.currentState!.validate();
//   //   if (!isValid) {
//   //     return;
//   //   }
//   // }
// }