import 'package:equatable/equatable.dart';

class RecordEntity extends Equatable {
  // final String title, key;
  // late final String? type;
  //
  // RecordEntity({
  //   required this.title,
  //   required this.key,
  //   this.type,
  // });
  final int? id;
  final String? soCccd;
  final String? soCmnd;
  final String? diaChi;
  final String? ngayCap;
  final String? hoTen;
  final String? namSinh;
  final String? gioiTinh;

  RecordEntity(
      {
        this.id,
        required this.soCccd,
        required this.soCmnd,
        required this.diaChi,
        required this.ngayCap,
        required this.hoTen,
        required this.namSinh,
        required this.gioiTinh});

  // RecordEntity.fromJson(Map<String, dynamic> json) {
  //   soCccd = json['so_cccd'];
  //   soCmnd = json['so_cmnd'];
  //   diaChi = json['dia_chi'];
  //   ngayCap = json['ngay_cap'];
  //   hoTen = json['ho_ten'];
  //   namSinh = json['nam_sinh'];
  //   gioiTinh = json['gioi_tinh'];
  // }
  //
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['so_cccd'] = this.soCccd;
  //   data['so_cmnd'] = this.soCmnd;
  //   data['dia_chi'] = this.diaChi;
  //   data['ngay_cap'] = this.ngayCap;
  //   data['ho_ten'] = this.hoTen;
  //   data['nam_sinh'] = this.namSinh;
  //   data['gioi_tinh'] = this.gioiTinh;
  //   return data;
  // }

  @override
  List<Object> get props => [soCccd!, hoTen!];

  @override
  bool get stringify => true;
}
