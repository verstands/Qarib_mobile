class FavoriModel {
  String? id;
  String? idUser;
  String? idService;
  String? createdAt;
  String? updatedAt;
  User? user;
  Service? service;

  FavoriModel(
      {this.id,
      this.idUser,
      this.idService,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.service});

  FavoriModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idUser = json['id_user'];
    idService = json['id_service'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    service =
        json['service'] != null ? new Service.fromJson(json['service']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_user'] = this.idUser;
    data['id_service'] = this.idService;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.service != null) {
      data['service'] = this.service!.toJson();
    }
    return data;
  }
}

class User {
  String? id;
  String? noms;
  String? password;
  String? telephone;
  String? statut;
  String? idRole;
  String? idVille;
  String? email;
  String? createdAt;
  String? updatedAt;

  User(
      {this.id,
      this.noms,
      this.password,
      this.telephone,
      this.statut,
      this.idRole,
      this.idVille,
      this.email,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    noms = json['noms'];
    password = json['password'];
    telephone = json['telephone'];
    statut = json['statut'];
    idRole = json['id_role'];
    idVille = json['id_ville'];
    email = json['email'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['noms'] = this.noms;
    data['password'] = this.password;
    data['telephone'] = this.telephone;
    data['statut'] = this.statut;
    data['id_role'] = this.idRole;
    data['id_ville'] = this.idVille;
    data['email'] = this.email;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Service {
  String? id;
  String? titre;
  String? description;
  String? icon;
  String? createdAt;
  String? updatedAt;

  Service(
      {this.id,
      this.titre,
      this.description,
      this.icon,
      this.createdAt,
      this.updatedAt});

  Service.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titre = json['titre'];
    description = json['description'];
    icon = json['icon'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['titre'] = this.titre;
    data['description'] = this.description;
    data['icon'] = this.icon;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}