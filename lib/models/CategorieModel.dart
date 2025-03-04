class CategorieModel {
  String? id;
  String? titre;
  String? createdAt;
  String? updatedAt;

  CategorieModel({this.id, this.titre, this.createdAt, this.updatedAt});

  CategorieModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titre = json['titre'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['titre'] = this.titre;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}