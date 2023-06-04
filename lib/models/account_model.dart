class AccountModel {
  String? username;
  String? password;

  AccountModel({this.password, this.username});

  AccountModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password};
  }
}

// accountList is account signed up
List<AccountModel> accountList = [];

// accountList1 is used to check login
List<AccountModel> accountList1 = [];

