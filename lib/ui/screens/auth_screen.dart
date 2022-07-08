import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/auth.dart';
import '../../utils/color_constants.dart';
import '../../utils/routes.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _usrnameFocusNode = FocusNode();
  final _comfirrmpswdFocusNode = FocusNode();
  final _paswdFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _mobileFocusNode = FocusNode();

  final Map<String, dynamic> _authData = {
    'username': '',
    'password': '',
    'organisation': '',
    'email': '',
    'mobile': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final authData = Provider.of<Auth>(context, listen: false);
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (authData.state == 'login') {
        // Log user in
        await Provider.of<Auth>(context, listen: false).login(
          _authData['username'],
          _authData['password'],
        );
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['username'],
          _authData['password'],
          _authData['organisation'],
          _authData['email'],
          _authData['mobile'],
        );
      }
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.homeScreen, (route) => false);
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('USERNAME_EXISTS')) {
        errorMessage = 'This username address is already in use.';
      } else if (error.toString().contains('INVALID_USERNAME')) {
        errorMessage = 'This is not a valid username address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that username.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      print("inside catch");
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  // void _switchAuthMode() {
  //   final authData = Provider.of<Auth>(context);
  //   if (_authMode == AuthMode.Login) {
  //     setState(() {
  //       _authMode = AuthMode.Signup;
  //     });
  //   } else {
  //     setState(() {
  //       _authMode = AuthMode.Login;
  //     });
  //   }
  // }

  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<Auth>(context).state;
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);

    return Scaffold(
      backgroundColor: ColorConstants.backGroundColor,
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            height: deviceSize.height * .5,
            color: ColorConstants.backGroundColor,
            width: deviceSize.width,
            //decoration: const BoxDecoration(
            // gradient: LinearGradient(
            //   colors: [
            //     // ColorConstants.appBarGradientColor1,
            //     // ColorConstants.appBarGradientColor2,
            //     // ColorConstants.appBarGradientColor3,
            //     ColorConstants.appBarGradientColor4
            //   ],
            // ),
            //),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 150,
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: Card(
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 0,
                      child: Container(
                        height: authState == 'signup' ? 450 : 260,
                        constraints: BoxConstraints(
                            minHeight: authState == 'signup' ? 450 : 260),
                        width: deviceSize.width * 0.75,
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  authState == 'login' ? 'SIGN IN' : 'SIGN UP',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                if (authState == 'signup')
                                  TextFormField(
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                    enabled: authState == 'signup',
                                    decoration: const InputDecoration(
                                        icon: Icon(
                                          Icons.business_rounded,
                                          color: ColorConstants.white,
                                        ),
                                        labelText: 'organization',
                                        labelStyle: TextStyle(
                                            color: ColorConstants.white),
                                        focusColor: Colors.white),
                                    keyboardType: TextInputType.name,
                                    validator: authState == 'signup'
                                        ? (value) {
                                            if (value!.isEmpty ||
                                                value.length < 3) {
                                              return 'organisation name is too short!';
                                            }
                                          }
                                        : null,
                                    onSaved: (value) {
                                      _authData['organisation'] = value!;
                                    },
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context)
                                          .requestFocus(_usrnameFocusNode);
                                    },
                                  ),
                                TextFormField(
                                  style: Theme.of(context).textTheme.headline4,
                                  key: const ValueKey('username'),
                                  decoration: const InputDecoration(
                                      icon: Icon(
                                        Icons.person_rounded,
                                        color: ColorConstants.white,
                                      ),
                                      labelText: 'username',
                                      labelStyle: TextStyle(
                                          color: ColorConstants.white)),
                                  focusNode: _usrnameFocusNode,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: authState == 'signup'
                                      ? (value) {
                                          if (value!.isEmpty ||
                                              value.length < 3) {
                                            return 'name is too short!';
                                          }
                                        }
                                      : null,
                                  onSaved: (value) {
                                    _authData['username'] = value!;
                                  },
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_paswdFocusNode);
                                  },
                                ),
                                TextFormField(
                                  style: Theme.of(context).textTheme.headline4,
                                  key: const ValueKey('password'),
                                  decoration: InputDecoration(
                                    icon: const Icon(
                                      Icons.lock,
                                      color: ColorConstants.white,
                                    ),
                                    labelText: 'Password',
                                    labelStyle:
                                        TextStyle(color: ColorConstants.white),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                      child: Icon(
                                        _obscureText
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: ColorConstants.white,
                                      ),
                                    ),
                                  ),
                                  focusNode: _paswdFocusNode,
                                  obscureText: _obscureText,
                                  controller: _passwordController,
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 3) {
                                      return 'Password is too short!';
                                    }
                                  },
                                  onSaved: (value) {
                                    _authData['password'] = value!;
                                  },
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_comfirrmpswdFocusNode);
                                  },
                                ),
                                if (authState == 'signup')
                                  TextFormField(
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                    enabled: authState == 'signup',
                                    decoration: const InputDecoration(
                                        icon: Icon(
                                          Icons.lock,
                                          color: ColorConstants.white,
                                        ),
                                        labelText: 'Confirm Password',
                                        labelStyle: TextStyle(
                                            color: ColorConstants.white)),
                                    focusNode: _comfirrmpswdFocusNode,
                                    obscureText: true,
                                    validator: authState == 'signup'
                                        ? (value) {
                                            if (value !=
                                                _passwordController.text) {
                                              return 'Passwords do not match!';
                                            }
                                          }
                                        : null,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context)
                                          .requestFocus(_emailFocusNode);
                                    },
                                  ),
                                if (authState == 'signup')
                                  TextFormField(
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                    enabled: authState == 'signup',
                                    decoration: const InputDecoration(
                                        icon: Icon(
                                          Icons.email_outlined,
                                          color: ColorConstants.white,
                                        ),
                                        labelText: 'E-Mail',
                                        labelStyle: TextStyle(
                                            color: ColorConstants.white)),
                                    keyboardType: TextInputType.emailAddress,
                                    focusNode: _emailFocusNode,
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          !value.contains('@')) {
                                        return 'Invalid email!';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _authData['email'] = value!;
                                    },
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context)
                                          .requestFocus(_mobileFocusNode);
                                    },
                                  ),
                                if (authState == 'signup')
                                  TextFormField(
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                    enabled: authState == 'signup',
                                    decoration: const InputDecoration(
                                        icon: Icon(
                                          Icons.phone,
                                          color: ColorConstants.white,
                                        ),
                                        labelText: 'mobile',
                                        labelStyle: TextStyle(
                                            color: ColorConstants.white)),
                                    keyboardType: TextInputType.phone,
                                    focusNode: _mobileFocusNode,
                                    validator: (value) {
                                      if (value!.length != 10) {
                                        return 'Mobile Number must be of 10 digit';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (value) {
                                      _authData['mobile'] = value!;
                                    },
                                    onFieldSubmitted: (_) {
                                      _submit();
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else
                    RaisedButton(
                      color: ColorConstants.backGroundColor,
                      child: Text(authState == 'login' ? 'LOGIN' : 'SIGN UP'),
                      onPressed: _submit,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 70.0, vertical: 7.0),
                      textColor:
                          Theme.of(context).primaryTextTheme.button!.color,
                      elevation: 6.6,
                    ),
                  FlatButton(
                    //color: ColorConstants.white,
                    child: Text(
                      '${authState == 'login' ? 'SIGNUP' : 'LOGIN'} INSTEAD',
                      //  style: TextStyle(color: ColorConstants.white),
                    ),
                    onPressed: () {
                      Provider.of<Auth>(context, listen: false)
                          .stateType(authState == 'login' ? 'signup' : 'login');
                    },
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textColor: ColorConstants.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class AuthCard extends StatefulWidget {
//   const AuthCard({
//     Key? key,
//   }) : super(key: key);

//   @override
//   _AuthCardState createState() => _AuthCardState();
// }

// class _AuthCardState extends State<AuthCard> {
//   final GlobalKey<FormState> _formKey = GlobalKey();
//   AuthMode _authMode = AuthMode.Login;
//   Map<String, dynamic> _authData = {
//     'username': '',
//     'organisation': '',
//     'password': '',
//   };
//   var _isLoading = false;
//   final _passwordController = TextEditingController();

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text('An Error Occurred!'),
//         content: Text(message),
//         actions: <Widget>[
//           FlatButton(
//             child: Text('Okay'),
//             onPressed: () {
//               Navigator.of(ctx).pop();
//             },
//           )
//         ],
//       ),
//     );
//   }

//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate()) {
//       // Invalid!
//       return;
//     }
//     _formKey.currentState!.save();
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       if (_authMode == AuthMode.Login) {
//         // Log user in
//         await Provider.of<Auth>(context, listen: false).login(
//           _authData['username'],
//           _authData['password'],
//         );
//       } else {
//         // Sign user up
//         await Provider.of<Auth>(context, listen: false).signup(
//           _authData['username'],
//           _authData['organisation'],
//           _authData['password'],
//         );
//       }
//     } on HttpException catch (error) {
//       var errorMessage = 'Authentication failed';
//       if (error.toString().contains('USERNAME_EXISTS')) {
//         errorMessage = 'This username address is already in use.';
//       } else if (error.toString().contains('INVALID_USERNAME')) {
//         errorMessage = 'This is not a valid username address';
//       } else if (error.toString().contains('WEAK_PASSWORD')) {
//         errorMessage = 'This password is too weak.';
//       } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
//         errorMessage = 'Could not find a user with that username.';
//       } else if (error.toString().contains('INVALID_PASSWORD')) {
//         errorMessage = 'Invalid password.';
//       }
//       _showErrorDialog(errorMessage);
//     } catch (error) {
//       print("inside catch");
//       const errorMessage =
//           'Could not authenticate you. Please try again later.';
//       _showErrorDialog(errorMessage);
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   void _switchAuthMode() {
//     if (_authMode == AuthMode.Login) {
//       setState(() {
//         _authMode = AuthMode.Signup;
//       });
//     } else {
//       setState(() {
//         _authMode = AuthMode.Login;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final deviceSize = MediaQuery.of(context).size;
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       elevation: 8.0,
//       child: Container(
//         height: _authMode == AuthMode.Signup ? 320 : 260,
//         constraints:
//             BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
//         width: deviceSize.width * 0.75,
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               children: <Widget>[
//                 TextFormField(
//                   decoration: InputDecoration(labelText: 'username'),
//                   keyboardType: TextInputType.emailAddress,
//                   // validator: (value) {
//                   //   if (value!.isEmpty || !value.contains('@')) {
//                   //     return 'Invalid email!';
//                   //   }
//                   //   return null;
//                   // },
//                   onSaved: (value) {
//                     _authData['username'] = value!;
//                   },
//                 ),
//                 if (_authMode == AuthMode.Signup)
//                   TextFormField(
//                     enabled: _authMode == AuthMode.Signup,
//                     decoration: InputDecoration(labelText: 'organisation'),
//                     keyboardType: TextInputType.name,
//                     // validator: _authMode == AuthMode.Signup
//                     //     ? (value) {
//                     //         if (value!.isEmpty || value.length < 4) {
//                     //           return 'name is too short!';
//                     //         }
//                     //       }
//                     //     : null,

//                     // validator: (value) {
//                     //   if (value!.isEmpty || value.length < 3) {
//                     //     return 'name is too short!';
//                     //   }
//                     //   return null;
//                     // },
//                     onSaved: (value) {
//                       _authData['organisation'] = value!;
//                     },
//                   ),
//                 TextFormField(
//                   decoration: InputDecoration(labelText: 'Password'),
//                   obscureText: true,
//                   controller: _passwordController,
//                   // validator: (value) {
//                   //   if (value!.isEmpty || value.length < 5) {
//                   //     return 'Password is too short!';
//                   //   }
//                   // },
//                   onSaved: (value) {
//                     _authData['password'] = value!;
//                   },
//                 ),
//                 if (_authMode == AuthMode.Signup)
//                   TextFormField(
//                     enabled: _authMode == AuthMode.Signup,
//                     decoration: InputDecoration(labelText: 'Confirm Password'),
//                     obscureText: true,
//                     validator: _authMode == AuthMode.Signup
//                         ? (value) {
//                             if (value != _passwordController.text) {
//                               return 'Passwords do not match!';
//                             }
//                           }
//                         : null,
//                   ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 if (_isLoading)
//                   CircularProgressIndicator()
//                 else
//                   RaisedButton(
//                     child:
//                         Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
//                     onPressed: _submit,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
//                     color: Theme.of(context).primaryColor,
//                     textColor: Theme.of(context).primaryTextTheme.button!.color,
//                   ),
//                 FlatButton(
//                   child: Text(
//                       '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
//                   onPressed: _switchAuthMode,
//                   padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
//                   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                   textColor: Theme.of(context).primaryColor,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
