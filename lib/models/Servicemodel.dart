class ServiceModel {
  String? id;
  String? titre;
  String? description;
  String? icon;
  String? createdAt;
  String? updatedAt;

  ServiceModel(
      {this.id,
      this.titre,
      this.description,
      this.icon,
      this.createdAt,
      this.updatedAt});

  ServiceModel.fromJson(Map<String, dynamic> json) {
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
