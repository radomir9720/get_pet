import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_pet/components/custom_material_button.dart';
import 'package:get_pet/components/progress_indicator.dart';
import 'package:get_pet/global/bloc/app_bloc.dart';
import 'package:get_pet/global/constants.dart';
import 'package:get_pet/screens/authorization/authorization.dart';
import 'package:get_pet/screens/shelters/shelters.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:get_pet/components/dialog_window.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final AppBloc _appBloc = BlocProvider.of<AppBloc>(context);

    return Container(
      // Дефолтная ширина Drawer'a
      width: 304.0,
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(
            kMainElementsRadiusDouble,
          ),
          bottomRight: Radius.circular(
            kMainElementsRadiusDouble,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          BlocBuilder(
            bloc: _appBloc,
            condition: (previous, current) =>
                current is SuccessfulSignInState || current is SignOutState,
            builder: (context, state) {
              if (!_appBloc.isAuthorized) {
                return Padding(
                  padding: const EdgeInsets.only(top: kStandardPaddingDouble),
                  child: CustomMaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(AuthorizationScreen.id);
                    },
                    color: Colors.white.withOpacity(0.8),
                    child: Text(
                      'Вход / Регистрация',
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 17),
                    ),
                  ),
                );
              }
              return Container(
                padding: const EdgeInsets.all(30),
                child: Row(
                  children: <Widget>[
                    ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: _appBloc.user.photoUrl == null
                            ? Icon(
                                Icons.account_circle,
                                size: 40,
                                color: Theme.of(context).primaryColor,
                              )
                            : CachedNetworkImage(
                                height: 40,
                                imageUrl: _appBloc.user.photoUrl,
                                placeholder: (context, url) =>
                                    const CustomProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              )

                        // Image.network(
                        //     _appBloc.user.photoUrl,
                        //     height: 40,
                        //   ),
                        ),
                    const SizedBox(
                      width: kStandardPaddingDouble,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _appBloc.user.displayName ?? _appBloc.user.email,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'Частное лицо',
                            style: TextStyle(
                                color: kInactiveColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                // CustomDrawerListTile(
                //   title: 'Приютить',
                //   isActive: true,
                //   icon: LineAwesomeIcons.paw,
                //   onPressed: () {},
                // ),
                CustomDrawerListTile(
                  title: 'Чат',
                  onPressed: () {},
                  icon: LineAwesomeIcons.comments,
                ),
                CustomDrawerListTile(
                  title: 'Добавить питомца',
                  onPressed: () {},
                  icon: LineAwesomeIcons.plus,
                ),
                CustomDrawerListTile(
                  title: 'Приюты',
                  onPressed: () =>
                      Navigator.of(context).popAndPushNamed(SheltersScreen.id),
                  icon: LineAwesomeIcons.paw,
                ),
                CustomDrawerListTile(
                  title: 'Поддержать проект',
                  onPressed: () {},
                  icon: LineAwesomeIcons.dollar,
                ),
                CustomDrawerListTile(
                  title: 'О приложении',
                  onPressed: () {},
                  icon: LineAwesomeIcons.info_circle,
                ),
              ],
            ),
          ),
          Padding(
            padding: kStandardPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CustomMaterialButton(
                  padding: 10,
                  onPressed: () {},
                  child: Row(
                    children: <Widget>[
                      Icon(
                        LineAwesomeIcons.cog,
                        color: kInactiveColor,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Настройки',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ],
                  ),
                ),
                BlocBuilder(
                  bloc: _appBloc,
                  condition: (previous, current) =>
                      current is SuccessfulSignInState ||
                      current is SignOutState,
                  builder: (context, state) => _appBloc.isAuthorized
                      ? CustomMaterialButton(
                          padding: 10,
                          onPressed: () {
                            showDialog(
                              context: context,
                              child: DialogWindow(
                                showDialogText: 'Вы уверены что хотите выйти?',
                                positiveButtonText: 'Да, хочу',
                                onPressedNegativeButton: () =>
                                    Navigator.of(context).pop(),
                                onPressedPositiveButton: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  _appBloc.add(SignOutEvent());
                                  Scaffold.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Вы успешно вышли из аккаунта'),
                                    ),
                                  );
                                },
                              ),
                            );
                            // Auth().signOutGoogle();
                          },
                          child: Text(
                            'Выйти',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                        )
                      : const SizedBox(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomDrawerListTile extends StatelessWidget {
  final String title;
  final Function onPressed;
  final IconData icon;
  const CustomDrawerListTile({
    Key key,
    @required this.title,
    this.onPressed,
    @required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: CustomMaterialButton(
        padding: kStandardPaddingDouble / 2,
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 30,
            ),
            const SizedBox(
              width: kStandardPaddingDouble,
            ),
            Text(
              title,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
        onPressed: onPressed,

        // trailing: Text('1.0.0'),
      ),
    );
  }
}
