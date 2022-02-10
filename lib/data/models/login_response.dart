class LoginResponse {
  int? status;
  String? message;
  String? token;
  Account? account;
  bool? isAdmin;
  bool? disableMap;
  bool? convertDgnToGis;

  LoginResponse(
      {this.status,
        this.message,
        this.token,
        this.account,
        this.isAdmin,
        this.disableMap,
        this.convertDgnToGis});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    token = json['token'];
    account =
    json['user'] != null ? new Account.fromJson(json['user']) : null;
    isAdmin = json['isAdmin'];
    disableMap = json['disable_map'];
    convertDgnToGis = json['convert_dgn_to_gis'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['token'] = this.token;
    if (this.account != null) {
      data['user'] = this.account!.toJson();
    }
    data['isAdmin'] = this.isAdmin;
    data['disable_map'] = this.disableMap;
    data['convert_dgn_to_gis'] = this.convertDgnToGis;
    return data;
  }
}

class Account {
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

  Account(
      {this.id,
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
        this.permissionConvertMap});

  Account.fromJson(Map<String, dynamic> json) {
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
