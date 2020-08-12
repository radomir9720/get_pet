import 'package:get_pet/global/models/address_search_item.dart';

class Shelter {
  final int addTimestamp;
  final String city;
  final String shelterName;
  final String phoneNumber;
  final String site;
  final AddressSearchItem addressSearchItem;
  final String imageUrl;

  Shelter({
    this.shelterName,
    this.phoneNumber,
    this.site,
    this.addressSearchItem,
    this.addTimestamp,
    this.city,
    this.imageUrl,
  });

  static Shelter fromMap(Map map) => Shelter(
        addTimestamp: int.parse(map['add_timestamp']),
        addressSearchItem: AddressSearchItem(
          displayName: map['address'],
          latitude: double.parse(map['latitude']),
          longitude: double.parse(map['longitude']),
        ),
        city: map['city'],
        phoneNumber: map['phone'],
        shelterName: map['shelter_name'],
        site: map['site'],
        imageUrl: map['shelter_avatar'],
      );
}
