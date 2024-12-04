class UserModel {
  String? noms;
  String? email;
  String? password;
  String? telephone;
  String? statut;
  String? idRole;
  String? idVille;
  int? latitude;
  int? longitude;

  UserModel(
      {this.noms,
      this.email,
      this.password,
      this.telephone,
      this.statut,
      this.idRole,
      this.idVille,
      this.latitude,
      this.longitude});

  UserModel.fromJson(Map<String, dynamic> json) {
    noms = json['noms'];
    email = json['email'];
    password = json['password'];
    telephone = json['telephone'];
    statut = json['statut'];
    idRole = json['id_role'];
    idVille = json['id_ville'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['noms'] = this.noms;
    data['email'] = this.email;
    data['password'] = this.password;
    data['telephone'] = this.telephone;
    data['statut'] = this.statut;
    data['id_role'] = this.idRole;
    data['id_ville'] = this.idVille;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}