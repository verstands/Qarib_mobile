class VilleModel {
  String? id;
  String? nom;
  String? createdAt;
  String? updatedAt;

  VilleModel({this.id, this.nom, this.createdAt, this.updatedAt});

  VilleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nom'] = this.nom;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}