import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_pet/components/app_bar_back_arrow.dart';
import 'package:get_pet/components/custom_material_button.dart';
import 'package:get_pet/components/dialog_window.dart';
import 'package:get_pet/components/progress_indicator.dart';
import 'package:get_pet/components/text_input_field.dart';
import 'package:get_pet/global/bloc/app_bloc.dart';
import 'package:get_pet/global/constants.dart';
import 'package:get_pet/global/models/address_search_item.dart';
import 'package:get_pet/global/models/shelter.dart';
import 'package:get_pet/screens/authorization/authorization.dart';
import 'package:get_pet/screens/search_address/search_address.dart';
import 'package:get_pet/screens/shelters/bloc/shelters_bloc.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class SheltersScreen extends StatefulWidget {
  const SheltersScreen({Key key}) : super(key: key);
  static const String id = '/shelters';

  @override
  _SheltersScreenState createState() => _SheltersScreenState();
}

class _SheltersScreenState extends State<SheltersScreen> {
  SheltersBloc _sheltersBloc;

  @override
  void didChangeDependencies() {
    if (_sheltersBloc == null) {
      _sheltersBloc = SheltersBloc(BlocProvider.of<AppBloc>(context));
      _sheltersBloc.add(ShelSearchSheltersEvent());
    }
    // _sheltersBloc ??= SheltersBloc(BlocProvider.of<AppBloc>(context));
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _sheltersBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarBackArrow(),
        title: Column(
          children: <Widget>[
            const Text('Приюты'),
            Tooltip(
              message: 'Искать в другом месте',
              child: InkWell(
                borderRadius: kCardBorderRadius,
                onTap: () => showDialog(
                  context: context,
                  child: const SearchAddressDialogWindow(),
                ).then((value) {
                  if (value != null) {
                    _sheltersBloc
                        .add(ShelSelectAddressChangeLocationEvent(value));
                  }
                  // _addressController.text = value.displayName;
                }),
                child: BlocBuilder<SheltersBloc, SheltersState>(
                  bloc: _sheltersBloc,
                  condition: (previous, current) =>
                      current is ShelSelectAddressChangeLocationState,
                  builder: (context, state) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Flexible(
                          fit: FlexFit.loose,
                          flex: 0,
                          child: Text(
                            'в ',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: Text(
                            '${BlocProvider.of<AppBloc>(context).placemark.locality}, ${BlocProvider.of<AppBloc>(context).placemark.country}',
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).accentColor),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        // centerTitle: true,
        actions: <Widget>[
          BlocBuilder<SheltersBloc, SheltersState>(
            bloc: _sheltersBloc,
            condition: (previous, current) =>
                current is ShelCloseModalBottomSheetState ||
                current is ShelOpenModalBottomSheetState,
            builder: (context, state) {
              return Builder(
                builder: (context) => IconButton(
                  icon: Icon(
                    LineAwesomeIcons.plus,
                    color: state is ShelCloseModalBottomSheetState ||
                            state is SheltersInitial
                        ? null
                        : Colors.transparent,
                  ),
                  onPressed: state is ShelOpenModalBottomSheetState
                      ? null
                      : () {
                          if (!BlocProvider.of<AppBloc>(context).isAuthorized) {
                            showDialog(
                              context: context,
                              child: DialogWindow(
                                showDialogText:
                                    'Для добавления питомника необходимо авторизоваться',
                                onPressedNegativeButton: () =>
                                    Navigator.of(context).pop(),
                                negativeButtonText: 'Нет, спасибо',
                                positiveButtonText: 'Авторизоваться',
                                onPressedPositiveButton: () =>
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            AuthorizationScreen.id,
                                            (route) => route.isFirst),
                              ),
                            );
                          } else {
                            _sheltersBloc.add(ShelOpenModalBottomSheetEvent());
                            showBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) => Container(
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(
                                        kMainElementsRadiusDouble),
                                    topRight: Radius.circular(
                                        kMainElementsRadiusDouble),
                                  ),
                                ),
                                child: AddNewShelterBottomSheet(
                                  sheltersBloc: _sheltersBloc,
                                ),
                              ),
                            );
                          }
                        },
                ),
              );
            },
          )
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Ink(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(kMainElementsRadiusDouble),
            topRight: Radius.circular(kMainElementsRadiusDouble),
          ),
        ),
        child: BlocBuilder<SheltersBloc, SheltersState>(
          bloc: _sheltersBloc,
          condition: (previous, current) =>
              current is ShelSearchSheltersErrorState ||
              current is ShelSearchSheltersLoadingState ||
              current is ShelSearchSheltersSuccessState,
          builder: (context, state) {
            if (state is ShelSearchSheltersLoadingState) {
              return const CustomProgressIndicator();
            } else if (state is ShelSearchSheltersErrorState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    LineAwesomeIcons.meh_o,
                    color: Theme.of(context).accentColor,
                    size: 100,
                  ),
                  Text(
                    'Произошла ошибка при загрузке. Детали: \n${state.message}',
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            } else if (state is ShelSearchSheltersSuccessState) {
              if (state.shelters.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      LineAwesomeIcons.frown_o,
                      size: 100,
                      color: Theme.of(context).accentColor,
                    ),
                    const Padding(
                      padding: kStandardPadding,
                      child: Text(
                        'Приютов в этом населенном пункте, пока, нет. Добавьте, нажав на плюс в правом верхнем углу.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
              }
              return ListView.builder(
                itemCount: state.shelters.length,
                itemBuilder: (context, index) => Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        margin: kStandardMargin,
                        padding: kStandardPadding,
                        decoration: BoxDecoration(
                          borderRadius: kCardBorderRadius,
                          color: Theme.of(context).primaryColor,
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              state.shelters[index].imageUrl != null
                                  ? CachedNetworkImage(
                                      height: 100,
                                      imageUrl: state.shelters[index].imageUrl,
                                      placeholder: (context, url) =>
                                          const CustomProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    )
                                  : Icon(LineAwesomeIcons.image),
                              IntrinsicWidth(
                                child: Column(
                                  // mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    ShelterCardListTile(
                                      icon: LineAwesomeIcons.paw,
                                      title: state.shelters[index].shelterName,
                                      isShelterName: true,
                                    ),
                                    const Divider(
                                      thickness: 1,
                                    ),
                                    ShelterCardListTile(
                                      icon: LineAwesomeIcons.phone,
                                      title: state.shelters[index].phoneNumber,
                                    ),
                                    ShelterCardListTile(
                                      icon: Icons.http,
                                      title: state.shelters[index].site,
                                    ),
                                  ],
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
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class ShelterCardListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isShelterName;
  const ShelterCardListTile({
    Key key,
    this.title,
    this.icon,
    this.isShelterName = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return title != null
        ? Flexible(
            fit: FlexFit.loose,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isShelterName ? 22 : 15,
                    fontWeight: isShelterName ? FontWeight.w600 : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  width: 10,
                ),
                Icon(
                  icon,
                  color: Theme.of(context).accentColor,
                  size: isShelterName ? 25 : null,
                ),
              ],
            ),
          )
        : const SizedBox();
  }
}

class AddNewShelterBottomSheet extends StatefulWidget {
  final SheltersBloc sheltersBloc;
  const AddNewShelterBottomSheet({
    Key key,
    @required this.sheltersBloc,
  }) : super(key: key);

  @override
  _AddNewShelterBottomSheetState createState() =>
      _AddNewShelterBottomSheetState();
}

class _AddNewShelterBottomSheetState extends State<AddNewShelterBottomSheet> {
  TextEditingController shelterNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController siteController = TextEditingController();
  // final TextEditingController _cityController = TextEditingController();
  // final TextEditingController _streetController = TextEditingController();
  // final TextEditingController _houseController = TextEditingController();
  // final TextEditingController _buildingController = TextEditingController();
  // final TextEditingController _edificeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  AddressSearchItem _addressSearchItem;

  @override
  void initState() {
    widget.sheltersBloc
        .where((state) => state is ShelSelectAddressState)
        .listen((st) {
      if (st is ShelSelectAddressState) {
        _addressSearchItem = st.addressSearchItem;
        addressController.text = st.addressSearchItem.displayName;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.sheltersBloc.add(ShelCloseModalBottomSheetEvent());
    shelterNameController.dispose();
    phoneController.dispose();
    siteController.dispose();
    addressController.dispose();
    // _cityController.dispose();
    // _streetController.dispose();
    // _houseController.dispose();
    // _buildingController.dispose();
    // _edificeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          height: 3,
          width: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: BorderRadius.circular(kCardBorderRadiusDouble),
          ),
        ),
        Text(
          'Добавить приют',
          style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.w700),
        ),
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: <Widget>[
              TextInputField(
                controller: shelterNameController,
                hintText: 'Название приюта',
                obligatory: true,
                checkIfIsValid: (TextEditingController controller) =>
                    kDefaultTextFieldRegExp.hasMatch(controller.text),
                errorText: 'К-во символов от 1 до 100',
                prefixIcon: Icon(
                  LineAwesomeIcons.home,
                  color: Theme.of(context).accentColor,
                ),
              ),
              // TextInputField(
              //   controller: null,
              //   hintText: 'Адрес',
              //   prefixIcon: Icon(
              //     LineAwesomeIcons.compass,
              //     color: Theme.of(context).accentColor,
              //   ),
              // ),
              TextInputField(
                controller: phoneController,
                hintText: 'Номер телефона',
                obligatory: true,
                maskTextInputFormatter: kPhoneInputFormatter,
                checkIfIsValid: (TextEditingController controller) =>
                    controller.text.length == 18,
                errorText: 'Некорректный формат номера телефона',
                prefixIcon: Icon(
                  LineAwesomeIcons.phone,
                  color: Theme.of(context).accentColor,
                ),
              ),
              GestureDetector(
                onTap: () => showDialog(
                  context: context,
                  child: const SearchAddressDialogWindow(),
                ).then((value) {
                  if (value != null) {
                    widget.sheltersBloc.add(ShelSelectAddressEvent(value));
                  }
                  // _addressController.text = value.displayName;
                }),
                child: AbsorbPointer(
                  child: TextInputField(
                    controller: addressController,
                    hintText: 'Адрес',
                    obligatory: true,
                    prefixIcon: Icon(
                      LineAwesomeIcons.map_marker,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
              ),
              TextInputField(
                controller: siteController,
                checkIfIsValid: (TextEditingController controller) =>
                    kOptionalTextFieldRegExp.hasMatch(controller.text),
                errorText: 'До 100 символов',
                hintText: 'Сайт',
                prefixIcon: Icon(
                  Icons.http,
                  color: Theme.of(context).accentColor,
                ),
              ),
              BlocBuilder<SheltersBloc, SheltersState>(
                bloc: widget.sheltersBloc,
                condition: (previous, current) =>
                    current is ShelPickPhotoForAddingShelterState,
                builder: (context, state) {
                  return Padding(
                    padding: kStandardMargin,
                    child: CustomMaterialButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        widget.sheltersBloc
                            .add(ShelPickPhotoForAddingShelterEvent());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(
                            LineAwesomeIcons.paperclip,
                            // size: 30,
                            color: Theme.of(context).accentColor,
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Text(
                              state is ShelPickPhotoForAddingShelterState
                                  ? state.imageName
                                  : 'Прикрепить фото',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(context).accentColor),
                            ),
                          ),
                          const SizedBox(),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Padding(
                padding: kStandardPadding,
                child: BlocBuilder<SheltersBloc, SheltersState>(
                  bloc: widget.sheltersBloc,
                  condition: (previous, current) =>
                      current is ShelAddNewShelterErrorState ||
                      current is ShelAddNewShelterLoadingState ||
                      current is ShelAddNewShelterSuccessState,
                  builder: (context, state) {
                    if (state is ShelAddNewShelterErrorState ||
                        state is ShelAddNewShelterSuccessState) {
                      SchedulerBinding.instance.addPostFrameCallback(
                        (_) {
                          showDialog(
                            context: context,
                            child: DialogWindow(
                              showDialogText: state
                                      is ShelAddNewShelterErrorState
                                  ? 'Произошла ошибка при добавлении. Детали:'
                                  : 'Приют успешно добавлен',
                              detailText: state is ShelAddNewShelterErrorState
                                  ? state.message
                                  : null,
                              onPressedNeutralButton:
                                  state is ShelAddNewShelterErrorState
                                      ? null
                                      : () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                          widget.sheltersBloc
                                              .add(ShelSearchSheltersEvent());
                                        },
                            ),
                          );
                        },
                      );
                    }

                    return CustomMaterialButton(
                      color: Theme.of(context).accentColor,
                      onPressed: () {
                        if (!kDefaultTextFieldRegExp
                                    .hasMatch(shelterNameController.text) ||
                                // !kDefaultTextFieldRegExp
                                //     .hasMatch(_cityController.text) ||
                                // !kDefaultTextFieldRegExp
                                //     .hasMatch(_streetController.text) ||
                                // !kDefaultTextFieldRegExp
                                //     .hasMatch(_houseController.text) ||
                                phoneController.text.length != 18 ||
                                !kOptionalTextFieldRegExp
                                    .hasMatch(siteController.text) ||
                                _addressSearchItem == null
                            //     ||
                            // !kOptionalTextFieldRegExp
                            //     .hasMatch(_buildingController.text) ||
                            // !kOptionalTextFieldRegExp
                            //     .hasMatch(_edificeController.text)
                            ) {
                          showDialog(
                            context: context,
                            child: DialogWindow(
                                showDialogText:
                                    'Одно или несколько обязательных полей не заполнены, или заполнены неправильно.'),
                          );
                        } else if (!(state is ShelAddNewShelterLoadingState)) {
                          widget.sheltersBloc.add(
                            ShelAddNewShelterEvent(
                              shelter: Shelter(
                                addressSearchItem: _addressSearchItem,
                                phoneNumber: phoneController.text,
                                shelterName: shelterNameController.text,
                                site: siteController.text,
                              ),
                              // shelterName: _shelterNameController.text,
                              // phoneNumber: _phoneController.text,
                              // addressSearchItem: _addressSearchItem,
                              // site: _siteController.text,
                            ),
                          );
                        }
                      },
                      child: state is ShelAddNewShelterLoadingState
                          ? CustomProgressIndicator(
                              backgroundColor: Theme.of(context).primaryColor,
                            )
                          : Text(
                              'Добавить',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).primaryColor),
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
