class LocationData{
  String? addressName;

  LocationData({
    required this.addressName,
  });

  factory LocationData.fromJson(Map<String,dynamic> data){
    return LocationData(
        addressName: data["address_name"]
    );
  }
}