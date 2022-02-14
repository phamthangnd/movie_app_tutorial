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

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['STT'] = this.id;
    data['Số Cccd'] = this.soCccd;
    data['Số Cmnd'] = this.soCmnd;
    data['Địa chỉ'] = this.diaChi;
    data['Ngày cấp'] = this.ngayCap;
    data['Họ tên'] = this.hoTen;
    data['Năm sinh'] = this.namSinh;
    data['Giới tính'] = this.gioiTinh;
    return data;
  }

  @override
  List<Object> get props => [soCccd!, hoTen!];

  @override
  bool get stringify => true;
}
