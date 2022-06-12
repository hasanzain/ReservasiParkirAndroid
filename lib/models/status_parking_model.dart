class ItemStatusParkingModel {
  ItemStatusParkingModel({
    this.idTempat,
    this.lokasiTempat,
    this.statusTersedia,
  });

  String? idTempat;
  String? lokasiTempat;
  String? statusTersedia;

  factory ItemStatusParkingModel.fromJson(Map<String, dynamic> json) =>
      ItemStatusParkingModel(
        lokasiTempat: json["lokasi"],
        statusTersedia: json["status_tersedia"],
        idTempat: json["id_tempat"],
      );
}
