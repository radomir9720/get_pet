import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_pet/global/app_themes.dart';
import 'package:get_pet/global/bloc/app_bloc.dart';
import 'package:get_pet/screens/authorization/authorization.dart';
import 'package:get_pet/screens/registration/registration.dart';
import 'package:get_pet/screens/search/search.dart';
import 'package:get_pet/screens/shelters/shelters.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ignore: close_sinks
  final _appBloc = await AppBloc().init();
  runApp(GetPet(appBloc: _appBloc));
}

class GetPet extends StatelessWidget {
  final AppBloc appBloc;
  GetPet({Key key, @required this.appBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (context) => appBloc,
      child: MaterialApp(
        title: 'GetPet',
        theme: appThemeData[AppTheme.light],
        routes: {
          // TabControllerWidget.id: (context) => const TabControllerWidget(),
          SearchScreen.id: (context) => const SearchScreen(),
          AuthorizationScreen.id: (context) => const AuthorizationScreen(),
          RegistrationScreen.id: (context) => const RegistrationScreen(),
          SheltersScreen.id: (context) => const SheltersScreen(),
        },
      ),
    );
  }
}
