import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_pet/components/app_bar_back_arrow.dart';
import 'package:get_pet/components/custom_material_button.dart';
import 'package:get_pet/components/dialog_window.dart';
import 'package:get_pet/components/text_input_field.dart';
import 'package:get_pet/global/bloc/app_bloc.dart';
import 'package:get_pet/global/constants.dart';
import 'package:get_pet/screens/registration/registration.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:get_pet/screens/authorization/bloc/authorization_bloc.dart';
import 'package:get_pet/components/progress_indicator.dart';

class AuthorizationScreen extends StatefulWidget {
  const AuthorizationScreen({Key key}) : super(key: key);

  static const String id = '/authorization';

  @override
  _AuthorizationScreenState createState() => _AuthorizationScreenState();
}

class _AuthorizationScreenState extends State<AuthorizationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  AuthorizationBloc _authorizationBloc;

  @override
  void didChangeDependencies() {
    _authorizationBloc = AuthorizationBloc(BlocProvider.of<AppBloc>(context));
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _authorizationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.white,
        // appBar: AppBar(
        //   centerTitle: true,
        //   title: Text('Вход'),
        // ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(
                            top: kStandardPaddingDouble, left: 12),
                        child: AppBarBackArrow(),
                      ),
                    ],
                  ),
                  Padding(
                    padding: kStandardMargin,
                    child: const Text(
                      'Вход',
                      style:
                          TextStyle(fontSize: 45, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const Padding(
                    padding: kStandardPadding,
                    child: Text(
                      'Пожалуйста, заполните поля.',
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.w700),
                    ),
                  ),
                  TextInputField(
                    prefixIcon: Icon(
                      LineAwesomeIcons.envelope,
                      color: Theme.of(context).accentColor,
                    ),
                    controller: _emailController,
                    hintText: 'Введите email',
                    obligatory: true,
                    checkIfIsValid: (TextEditingController controller) =>
                        kEmailRegExp.hasMatch(controller.text),
                    errorText: 'Введите ваш адрес электронной почты.',
                  ),
                  TextInputField(
                    prefixIcon: Icon(
                      LineAwesomeIcons.lock,
                      color: Theme.of(context).accentColor,
                    ),
                    controller: _passController,
                    hintText: 'Введите пароль',
                    obligatory: true,
                    errorText: 'Буквы, цифры, спецсимволы. Минимум 6 символов.',
                    checkIfIsValid: (TextEditingController controller) =>
                        kPassRegExp.hasMatch(controller.text),
                    obscure: true,
                  ),
                  BlocBuilder<AuthorizationBloc, AuthorizationState>(
                    bloc: _authorizationBloc,
                    condition: (previous, current) =>
                        current is AuthSignInWithLogPassLoadingState ||
                        current is AuthSignInWithLogPassSuccessState ||
                        current is AuthSignInWithLogPassErrorState,
                    builder: (context, state) {
                      if (state is AuthSignInWithLogPassErrorState) {
                        SchedulerBinding.instance.addPostFrameCallback(
                          (_) {
                            showDialog(
                              context: context,
                              child: DialogWindow(
                                showDialogText:
                                    'Произошла ошибка авторизации. Детали:',
                                detailText: state.errorMessage,
                              ),
                            );
                          },
                        );
                      } else if (state is AuthSignInWithLogPassSuccessState) {
                        SchedulerBinding.instance.addPostFrameCallback(
                          (_) => Navigator.of(context).pop(),
                        );
                      }
                      return Padding(
                        padding: kStandardMargin,
                        child: CustomMaterialButton(
                          color: Theme.of(context).accentColor,
                          onPressed: () {
                            if (kEmailRegExp.hasMatch(_emailController.text) &&
                                kPassRegExp.hasMatch(_passController.text)) {
                              _authorizationBloc.add(
                                AuthSignInWithLogPassEvent(
                                  email: _emailController.text,
                                  password: _passController.text,
                                ),
                              );
                            } else {
                              showDialog(
                                context: context,
                                child: DialogWindow(
                                  showDialogText:
                                      'Одно или несколько полей заполнены неправильно.',
                                ),
                              );
                            }
                            // BlocProvider.of<AppBloc>(context)
                            //     .auth
                            //     .firebaseAuth
                            //     .signInWithEmailAndPassword(
                            //         email: _loginController.text,
                            //         password: _passController.text)
                            //     .then((value) {
                            //   if (value.user != null) {
                            //     Navigator.of(context).popUntil(
                            //         (route) => !Navigator.of(context).canPop());
                            //     BlocProvider.of<AppBloc>(context).add(
                            //         SuccessfulSignInEvent(user: value.user));
                            //     // Navigator.of(context).pop();
                            //   }
                            // });
                          },
                          child: state is AuthSignInWithLogPassLoadingState
                              ? CustomProgressIndicator(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                )
                              : Text(
                                  'Вход',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600),
                                ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: kStandardMargin,
                    child: Row(
                      children: <Widget>[
                        const Expanded(
                          child: Divider(
                            thickness: 2,
                            endIndent: 10,
                          ),
                        ),
                        const Text(
                          'Или',
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w700),
                        ),
                        const Expanded(
                          child: Divider(
                            thickness: 2,
                            indent: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<AuthorizationBloc, AuthorizationState>(
                    bloc: _authorizationBloc,
                    condition: (previous, current) =>
                        current is AuthSignInWithGoogleLoadingState ||
                        current is AuthSignInWithGoogleSuccessState ||
                        current is AuthSignInWithGoogleErrorState,
                    builder: (context, state) {
                      if (state is AuthSignInWithGoogleErrorState) {
                        SchedulerBinding.instance.addPostFrameCallback(
                          (_) {
                            showDialog(
                              context: context,
                              child: DialogWindow(
                                showDialogText:
                                    'Произошла ошибка авторизации. Детали:',
                                detailText: state.errorMessage,
                              ),
                            );
                          },
                        );
                      } else if (state is AuthSignInWithGoogleSuccessState) {
                        SchedulerBinding.instance.addPostFrameCallback(
                          (_) {
                            if (BlocProvider.of<AppBloc>(context)
                                .isAuthorized) {
                              Navigator.of(context).pop();
                            } else {
                              Scaffold.of(context).showSnackBar(const SnackBar(
                                  content: Text('Авторизация отменена')));
                            }
                          },
                        );
                      }
                      return Padding(
                        padding: kStandardPadding,
                        child: CustomMaterialButton(
                          padding: 10,
                          color: Theme.of(context).primaryColor,
                          child: state is AuthSignInWithGoogleLoadingState
                              ? const CustomProgressIndicator()
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(
                                      'Войдите с помощью Google',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context).accentColor),
                                    ),
                                    Image.asset(
                                      'assets/images/google_logo.png',
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                          onPressed: () {
                            _authorizationBloc.add(AuthSignInWithGoogleEvent());
                            // BlocProvider.of<AppBloc>(context)
                            //     .auth
                            //     .signInWithGoogle()
                            //     .then(
                            //   (value) {
                            //     if (value != null) {
                            //       BlocProvider.of<AppBloc>(context)
                            //           .add(SuccessfulSignInEvent(user: value));
                            //       Navigator.of(context).pop();
                            //     } else {
                            //       Scaffold.of(context).showSnackBar(
                            //         const SnackBar(
                            //           content: Text('Ошибка авторизации'),
                            //         ),
                            //       );
                            //     }
                            //   },
                            // );

                            // signInWithGoogle();
                          },
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Нет аккаунта?',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Theme.of(context).disabledColor),
                    ),
                    CustomMaterialButton(
                      onPressed: () => Navigator.of(context)
                          .pushNamed(RegistrationScreen.id),
                      padding: 10,
                      child: Text(
                        'Зарегистрироваться',
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
