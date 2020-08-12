import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_pet/components/app_bar_back_arrow.dart';
import 'package:get_pet/components/custom_material_button.dart';
import 'package:get_pet/components/dialog_window.dart';
import 'package:get_pet/components/text_input_field.dart';
import 'package:get_pet/global/bloc/app_bloc.dart';
import 'package:get_pet/global/constants.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:get_pet/screens/registration/bloc/registration_bloc.dart';
import 'package:get_pet/components/progress_indicator.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key key}) : super(key: key);

  static const String id = '/registration';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  RegistrationBloc _registrationBloc;
  final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  // final TextEditingController _repeatPassController = TextEditingController();
  // bool _obscurePass = true;

  @override
  void didChangeDependencies() {
    _registrationBloc ??= RegistrationBloc(BlocProvider.of<AppBloc>(context));
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _registrationBloc.close();
    // _repeatPassController.dispose();
    // _loginController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
            child: BlocBuilder<RegistrationBloc, RegistrationState>(
          bloc: _registrationBloc,
          condition: (previous, current) =>
              current is RegChangePassFieldObscureValueState ||
              current is RegistrationInitial ||
              current is RegCreateUserLoadingState ||
              current is RegCreateUserSuccessState ||
              current is RegCreateUserErrorState,
          builder: (context, state) {
            if (state is RegCreateUserErrorState) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                showDialog(
                  context: context,
                  child: DialogWindow(
                    showDialogText: 'Произошла ошибка авторизации. Детали:',
                    detailText: state.errorMessage,
                  ),
                );
              });
            } else if (state is RegCreateUserSuccessState) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              });
            }

            return ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      top: kStandardPaddingDouble, left: 12),
                  child: Row(
                    children: <Widget>[
                      const AppBarBackArrow(),
                    ],
                  ),
                ),
                Padding(
                  padding: kStandardMargin,
                  child: const Text(
                    'Регистрация',
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
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
                  hintText: 'Введите e-mail',
                  prefixIcon: Icon(
                    LineAwesomeIcons.envelope,
                    color: Theme.of(context).accentColor,
                  ),
                  checkIfIsValid: (TextEditingController controller) =>
                      kEmailRegExp.hasMatch(controller.text),
                  errorText: 'Введите ваш адрес электронной почты.',
                  obligatory: true,
                  controller: _emailController,
                ),
                // TextInputField(
                //   prefixIcon: Icon(
                //     LineAwesomeIcons.user,
                //     color: Theme.of(context).accentColor,
                //   ),
                //   hintText: 'Введите логин',
                //   checkIfIsValid: (TextEditingController controller) =>
                //       kLoginRegExp.hasMatch(controller.text),
                //   controller: _loginController,
                //   errorText:
                //       'Латинские буквы и цифры, первый символ обязательно буква. От 6 до 20 символов.',
                // ),
                TextInputField(
                  hintText: 'Введите пароль',
                  obligatory: true,
                  prefixIcon: Icon(
                    LineAwesomeIcons.lock,
                    color: Theme.of(context).accentColor,
                  ),
                  suffixIcon: CustomMaterialButton(
                    borderRadius: BorderRadius.circular(100),
                    padding: EdgeInsets.zero,
                    child: Icon(
                      state.obscure
                          ? LineAwesomeIcons.eye_slash
                          : LineAwesomeIcons.eye,
                      color: state.obscure
                          ? Theme.of(context).disabledColor
                          : Colors.black,
                    ),
                    onPressed: () => _registrationBloc.add(
                      RegChangePassFieldObscureValueEvent(
                          obscure: !state.obscure),
                    ),
                  ),
                  errorText: 'Буквы, цифры, спецсимволы. Минимум 6 символов.',
                  checkIfIsValid: (TextEditingController controller) =>
                      kPassRegExp.hasMatch(controller.text),
                  controller: _passController,
                  obscure: state.obscure,
                ),

                // TextInputField(
                //   prefixIcon: Icon(
                //     LineAwesomeIcons.lock,
                //     color: Theme.of(context).accentColor,
                //   ),
                //   checkIfIsValid: (TextEditingController controller) =>
                //       controller.text == _passController.text,
                //   controller: _repeatPassController,
                //   errorText: 'Пароли не совпадают',
                //   obscure: true,
                //   hintText: 'Повторите пароль',
                // ),
                Padding(
                  padding: kStandardMargin,
                  child: CustomMaterialButton(
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                      if (!(state is RegCreateUserLoadingState)) {
                        if (kEmailRegExp.hasMatch(_emailController.text) &&
                            kPassRegExp.hasMatch(_passController.text)) {
                          _registrationBloc.add(
                            RegCreateUserEvent(
                              email: _emailController.text,
                              password: _passController.text,
                            ),
                          );
                        } else {
                          showDialog(
                            context: context,
                            child: DialogWindow(
                                showDialogText:
                                    'Одно или несколько полей заполнены неправильно.'),
                          );
                        }
                      }
                    },
                    child: state is RegCreateUserLoadingState
                        ? CustomProgressIndicator(
                            backgroundColor: Theme.of(context).primaryColor,
                          )
                        : Text(
                            'Зарегистрироваться',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).primaryColor),
                          ),
                  ),
                )
              ],
            );
          },
        )),
      ),
    );
  }
}
