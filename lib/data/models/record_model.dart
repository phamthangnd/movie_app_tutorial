import 'package:movieapp/domain/entities/record_entity.dart';

class RecordModel extends RecordEntity {
  String? soCccd;
  String? soCmnd;
  String? diaChi;
  String? ngayCap;
  String? hoTen;
  String? namSinh;
  String? gioiTinh;

  RecordModel({
    this.soCccd,
    this.soCmnd,
    this.diaChi,
    this.ngayCap,
    this.hoTen,
    this.namSinh,
    this.gioiTinh,
  }) : super(
          soCccd: soCccd,
          soCmnd: soCmnd,
          diaChi: diaChi,
          ngayCap: ngayCap,
          hoTen: hoTen,
          namSinh: namSinh,
          gioiTinh: gioiTinh,
        );

  factory RecordModel.fromJson(Map<String, dynamic> json) {
    return RecordModel(
      soCccd: json['so_cccd'],
      soCmnd: json['so_cmnd'],
      diaChi: json['dia_chi'],
      ngayCap: json['ngay_cap'],
      hoTen: json['ho_ten'],
      namSinh: json['nam_sinh'],
      gioiTinh: json['gioi_tinh'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['so_cccd'] = this.soCccd;
    data['so_cmnd'] = this.soCmnd;
    data['dia_chi'] = this.diaChi;
    data['ngay_cap'] = this.ngayCap;
    data['ho_ten'] = this.hoTen;
    data['nam_sinh'] = this.namSinh;
    data['gioi_tinh'] = this.gioiTinh;
    return data;
  }
}
