class AccountEntity {
  int? id;
  String? name;
  String? username;
  String? address;
  String? phoneNumber;
  String? email;
  String? accessToken;
  int? createdAt;
  int? updatedAt;
  String? apiKey;
  int? permissionMap;
  int? permissionConvertMap;
  String? token;
  bool? isAdmin;
  bool? disableMap;

  AccountEntity({
    this.id,
    this.name,
    this.username,
    this.address,
    this.phoneNumber,
    this.email,
    this.accessToken,
    this.createdAt,
    this.updatedAt,
    this.apiKey,
    this.permissionMap,
    this.permissionConvertMap,
    this.token,
    this.isAdmin,
    this.disableMap,
  });
  factory AccountEntity.fromMap(Map<String, dynamic> json) {
    return AccountEntity(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      address: json['address'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      accessToken: json['access_token'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      apiKey: json['api_key'],
      permissionMap: json['permission_map'],
      permissionConvertMap: json['permission_convert_map'],
    );
  }

  AccountEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    address = json['address'];
    phoneNumber = json['phone_number'];
    email = json['email'];
    accessToken = json['access_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    apiKey = json['api_key'];
    permissionMap = json['permission_map'];
    permissionConvertMap = json['permission_convert_map'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.username;
    data['address'] = this.address;
    data['phone_number'] = this.phoneNumber;
    data['email'] = this.email;
    data['access_token'] = this.accessToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['api_key'] = this.apiKey;
    data['permission_map'] = this.permissionMap;
    data['permission_convert_map'] = this.permissionConvertMap;
    return data;
  }
}
