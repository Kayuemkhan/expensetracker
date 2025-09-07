class UserLoginRes {
  Message? message;
  Data? data;

  UserLoginRes({this.message, this.data});

  UserLoginRes.fromJson(Map<String, dynamic> json) {
    message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (message != null) {
      data['message'] = message!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Message {
  List<String>? success;

  Message({this.success});

  Message.fromJson(Map<String, dynamic> json) {
    success = json['success'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    return data;
  }
}

class Data {
  User? user;
  String? accessToken;

  Data({this.user, this.accessToken});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    accessToken = json['access_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['access_token'] = accessToken;
    return data;
  }
}

class User {
  int? id;
  String? firstname;
  String? lastname;
  String? username;
  String? email;
  dynamic mobile;
  dynamic refBy;
  String? balance;
  dynamic image;
  Address? address;
  int? status;
  int? ev;
  int? sv;
  String? verCode;
  String? verCodeSendAt;
  int? ts;
  int? tv;
  String? tsc;
  String? provider;
  String? providerId;
  String? createdAt;
  String? updatedAt;

  User(
      {this.id,
      this.firstname,
      this.lastname,
      this.username,
      this.email,
      this.mobile,
      this.refBy,
      this.balance,
      this.image,
      this.address,
      this.status,
      this.ev,
      this.sv,
      this.verCode,
      this.verCodeSendAt,
      this.ts,
      this.tv,
      this.tsc,
      this.provider,
      this.providerId,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    username = json['username'];
    email = json['email'];
    mobile = json['mobile'];
    refBy = json['ref_by'];
    balance = json['balance'];
    image = json['image'];
    address = json['address'] != null ? Address.fromJson(json['address']) : null;
    status = json['status'];
    ev = json['ev'];
    sv = json['sv'];
    verCode = json['ver_code'];
    verCodeSendAt = json['ver_code_send_at'];
    ts = json['ts'];
    tv = json['tv'];
    tsc = json['tsc'];
    provider = json['provider'];
    providerId = json['provider_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['username'] = username;
    data['email'] = email;
    data['mobile'] = mobile;
    data['ref_by'] = refBy;
    data['balance'] = balance;
    data['image'] = image;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['status'] = status;
    data['ev'] = ev;
    data['sv'] = sv;
    data['ver_code'] = verCode;
    data['ver_code_send_at'] = verCodeSendAt;
    data['ts'] = ts;
    data['tv'] = tv;
    data['tsc'] = tsc;
    data['provider'] = provider;
    data['provider_id'] = providerId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Address {
  String? address;
  String? state;
  String? zip;
  String? country;
  String? city;

  Address({this.address, this.state, this.zip, this.country, this.city});

  Address.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    state = json['state'];
    zip = json['zip'];
    country = json['country'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['state'] = state;
    data['zip'] = zip;
    data['country'] = country;
    data['city'] = city;
    return data;
  }
}