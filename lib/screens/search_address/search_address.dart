import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_pet/components/progress_indicator.dart';
import 'package:get_pet/components/text_input_field.dart';
import 'package:get_pet/global/bloc/app_bloc.dart';
import 'package:get_pet/global/constants.dart';
import 'package:get_pet/global/debouncer.dart';

import '../../components/custom_material_button.dart';
import 'bloc/search_address_bloc.dart';

class SearchAddressDialogWindow extends StatefulWidget {
  const SearchAddressDialogWindow({
    Key key,
    // @required this.sheltersBloc,
  }) : super(key: key);

  @override
  _SearchAddressDialogWindowState createState() =>
      _SearchAddressDialogWindowState();
}

class _SearchAddressDialogWindowState extends State<SearchAddressDialogWindow> {
  SearchAddressBloc _searchAddressBloc;
  final _debouncer = Debouncer(milliseconds: 1000);

  @override
  void didChangeDependencies() {
    _searchAddressBloc ??= SearchAddressBloc(BlocProvider.of<AppBloc>(context));
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _searchAddressBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final SearchAddressBloc _searchAddressBloc =
    // SearchAddressBloc(BlocProvider.of<AppBloc>(context));

    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.3),
        body: Column(
          children: <Widget>[
            Container(
              // margin: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                // color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: kCardBorderRadius,
              ),
              child: TextInputField(
                autoFocus: true,
                onChanged: (String text) => _debouncer.run(
                    () => _searchAddressBloc.add(SearSearchAddressEvent(text))),
                controller: null,
                hintText: 'Адрес',
              ),
            ),
            BlocBuilder<SearchAddressBloc, SearchAddressState>(
              bloc: _searchAddressBloc,
              condition: (previous, current) =>
                  current is SearSearchAddressLoadingState ||
                  current is SearSearchAddressErrorState ||
                  current is SearSearchAddressResultState,
              builder: (context, state) {
                Widget body = const SizedBox();

                if (state is SearSearchAddressResultState) {
                  body = Column(
                    children: <Widget>[
                      Text(
                        state.items.isEmpty
                            ? 'Совпадений не найдено'
                            : 'Выберите адрес из списка',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(
                        height: kStandardPaddingDouble,
                      ),
                      Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          separatorBuilder: (context, index) => Divider(
                            color: Theme.of(context).dividerColor,
                            thickness: 3,
                          ),
                          itemCount: state.items.length,
                          itemBuilder: (context, index) => CustomMaterialButton(
                            padding: 4,
                            onPressed: () =>
                                Navigator.of(context).pop(state.items[index]),
                            child: Text(state.items[index].displayName),
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (state is SearSearchAddressLoadingState) {
                  body = const CustomProgressIndicator();
                } else
                // if (state is ShelSearchAddressErrorState ||
                //     state is ShelOpenModalBottomSheetState)
                {
                  body = Text(
                    state is SearSearchAddressErrorState
                        ? state.message
                        : 'Введите адрес...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 17,
                    ),
                  );
                }

                return Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: kStandardPadding,
                    padding: kStandardPadding,
                    decoration: BoxDecoration(
                      borderRadius: kCardBorderRadius,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: body,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
