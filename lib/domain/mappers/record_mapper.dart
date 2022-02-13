import 'package:movieapp/common/mapper.dart';
import 'package:movieapp/data/models/record_model.dart';
import 'package:movieapp/domain/entities/record_entity.dart';

class RecordMapper extends Mapper<RecordModel, RecordEntity> {
// static const uniqueCharacter = ";//;";

@override
RecordModel from(RecordEntity input) {
  return RecordModel(
    id: input.id,
    soCmnd: input.soCmnd,
    soCccd: input.soCccd,
    hoTen: input.hoTen,
    gioiTinh: input.gioiTinh,
    ngayCap: input.ngayCap,
    namSinh: input.namSinh,
    // discount: input.discountValue != null
    //     ? Discount(
    //     value: input.discountValue,
    //     type: voucherTypeFromString(input.discountType))
    //     : null,
  );
}

@override
RecordEntity to(RecordModel input) {
  return RecordEntity(
      id: input.id!,
      soCccd: input.soCccd,
      soCmnd: input.soCmnd,
      hoTen: input.hoTen,
      namSinh: input.namSinh,
      ngayCap: input.ngayCap,
      gioiTinh: input.gioiTinh,
      // images: input.images.map((e) => e.url).join(uniqueCharacter),
      diaChi: input.diaChi??'',
  );
}
}