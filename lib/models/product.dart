//import 'dart:convert';
//
//Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));
//String welcomeToJson(Welcome data) => json.encode(data.toJson());

class ProdukModel {
  List<Product> data;
  Meta meta;

  ProdukModel({
    required this.data,
    required this.meta,
  });
  factory ProdukModel.fromJson(Map<String, dynamic> json) => ProdukModel(
        data: List<Product>.from(json["data"].map((x) => Product.fromJson(x))),
        meta: Meta.fromJson(json["meta"]),
      );
  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}

class Product {
  final int id;
  final String documentId;
  final String nama;
  final List<Deskripsi> deskripsi;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime publishedAt;
  final String slug;

  var attributes;

  Product({
    required this.id,
    required this.documentId,
    required this.nama,
    required this.deskripsi,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.slug,
  });
  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        documentId: json["documentId"],
        nama: json["nama"],
        deskripsi: List<Deskripsi>.from(
            json["deskripsi"].map((x) => Deskripsi.fromJson(x))),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
        slug: json["slug"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "documentId": documentId,
        "nama": nama,
        "deskripsi": List<dynamic>.from(deskripsi.map((x) => x.toJson())),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "publishedAt": publishedAt.toIso8601String(),
        "slug": slug,
      };
}

class Deskripsi {
  DeskripsiType type;
  List<Child> children;

  Deskripsi({
    required this.type,
    required this.children,
  });

  factory Deskripsi.fromJson(Map<String, dynamic> json) => Deskripsi(
        type: deskripsiTypeValues.map[json["type"]]!,
        children:
            List<Child>.from(json["children"].map((x) => Child.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": deskripsiTypeValues.reverse[type],
        "children": List<dynamic>.from(children.map((x) => x.toJson())),
      };
}

class Child {
  ChildType type;
  String text;

  Child({
    required this.type,
    required this.text,
  });

  factory Child.fromJson(Map<String, dynamic> json) => Child(
        type: childTypeValues.map[json["type"]]!,
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "type": childTypeValues.reverse[type],
        "text": text,
      };
}

enum ChildType { TEXT }

final childTypeValues = EnumValues({"text": ChildType.TEXT});

enum DeskripsiType { PARAGRAPH }

final deskripsiTypeValues = EnumValues({"paragraph": DeskripsiType.PARAGRAPH});

class Meta {
  Pagination pagination;

  Meta({
    required this.pagination,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        pagination: Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "pagination": pagination.toJson(),
      };
}

class Pagination {
  int page;
  int pageSize;
  int pageCount;
  int total;

  Pagination({
    required this.page,
    required this.pageSize,
    required this.pageCount,
    required this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        page: json["page"],
        pageSize: json["pageSize"],
        pageCount: json["pageCount"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "pageSize": pageSize,
        "pageCount": pageCount,
        "total": total,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
