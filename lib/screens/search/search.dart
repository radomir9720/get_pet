import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_pet/components/dialog_window.dart';
import 'package:get_pet/global/bloc/app_bloc.dart';
import 'package:get_pet/global/constants.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import 'components/custom_drawer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key key}) : super(key: key);

  static const String id = '/';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    BlocProvider.of<AppBloc>(context)
        .where((state) => state is SuccessfulSignInState)
        .listen((state) {
      _scaffoldKey.currentState.showSnackBar(
          const SnackBar(content: Text('Вы упешно авторизовались')));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (BlocProvider.of<AppBloc>(context).isFirstAppLaunch) {
      SchedulerBinding.instance.addPostFrameCallback(
        (_) {
          showDialog(
            context: context,
            child: DialogWindow(
              showDialogText:
                  'Для корректной работы приложения потребуются следующие разрешения:',
              detailText: 'Данные о местоположении',
            ),
          ).then((value) => BlocProvider.of<AppBloc>(context)
              .add(ClosedPermissionWindowEvent()));
        },
      );
    }
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).primaryColor,
        drawer: const CustomDrawer(),
        body: Column(
          children: <Widget>[
            // BlocBuilder<AppBloc, AppState>(
            //   bloc: BlocProvider.of<AppBloc>(context),
            //   condition: (previous, current) =>
            //       current is SuccessfulSignInState,
            //   builder: (context, state) {
            //     // if (state is SuccessfulSignInState) {
            //     SchedulerBinding.instance.addPostFrameCallback(
            //       (_) {
            //         Navigator.of(context).pop();
            //         Scaffold.of(context).showSnackBar(const SnackBar(
            //             content: Text('Вы упешно авторизовались')));
            //       },
            //     );
            //     // }
            //     return const SizedBox();
            //   },
            // ),
            Ink(
              height: 70,
              color: Theme.of(context).primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(LineAwesomeIcons.bars),
                    onPressed: () {
                      _scaffoldKey.currentState.openDrawer();
                    },
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Город',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Icon(
                                    Icons.location_on,
                                    size: 20,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Text(
                                      BlocProvider.of<AppBloc>(context)
                                          .placemark
                                          .locality,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Text(
                                    ', ',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              child: Text(
                                BlocProvider.of<AppBloc>(context)
                                    .placemark
                                    .country,
                                style: const TextStyle(fontSize: 17),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(LineAwesomeIcons.filter),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(kMainElementsRadiusDouble),
                  topRight: Radius.circular(kMainElementsRadiusDouble),
                ),
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: kCardBorderRadius,
                          color: Theme.of(context).primaryColor,
                        ),
                        // padding: kStandardPadding,
                        margin: kStandardMargin,
                        child: TextField(
                          // textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: 'Кого хотите приютить?',
                            // labelStyle: TextStyle(),
                            // prefixIcon: Icon(LineAwesomeIcons.search),
                            prefixIcon: Icon(
                              LineAwesomeIcons.search,
                              color: Colors.grey,
                            ),
                            enabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: <Widget>[
                            Padding(
                              padding: kStandardMargin,
                              child: Container(
                                // margin: kStandardMargin,
                                padding: kStandardPadding,
                                decoration: BoxDecoration(
                                  borderRadius: kCardBorderRadius,
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(1, 40),
                                      blurRadius: 30,
                                      spreadRadius: 10,
                                      color: Colors.grey[300],
                                    ),
                                    BoxShadow(
                                      blurRadius: 0,
                                      spreadRadius: 0,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                child: IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 8,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          // mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Row(
                                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  'Рэкс',
                                                  style: TextStyle(
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Icon(LineAwesomeIcons.mars),
                                                const SizedBox(
                                                  width: kStandardPaddingDouble,
                                                ),
                                              ],
                                            ),
                                            const Text('Немецкая овчарка'),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: ClipRRect(
                                          borderRadius: kCardBorderRadius,
                                          child: Image.network(
                                            // 'https://avatars.mds.yandex.net/get-pdb/38069/a222f1f7-7672-47e5-82fd-7a2fc83194ed/s1200',
                                            // 'https://avatars.mds.yandex.net/get-pdb/25978/9a3475a7-31ef-40f8-9c87-41c1f72007d6/s1200',
                                            'https://avatars.mds.yandex.net/get-pdb/2115127/03356bb0-1082-43d9-a7bc-88a672eeaea8/s600?webp=false',
                                            // 'https://getpetbucket.s3.eu-west-2.amazonaws.com/shelter_avatar/test21596095121433.png',
                                            // height: 150,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
