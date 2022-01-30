// To parse this JSON data, do
//
//     final googlecontacts = googlecontactsFromJson(jsonString?);
import 'dart:convert';

Googlecontacts googlecontactsFromJson(String? str) => Googlecontacts.fromJson(json.decode(str!));

String? googlecontactsToJson(Googlecontacts data) => json.encode(data.toJson());

class Googlecontacts {
  Googlecontacts({
    required this.connections,
  });

  List<Connection>? connections;

  factory Googlecontacts.fromJson(Map<String?, dynamic> json) => Googlecontacts(
    connections: json["connections"] == null ? null : List<Connection>.from(json["connections"].map((x) => Connection.fromJson(x))),
  );

  Map<String?, dynamic> toJson() => {
    "connections": connections == null ? null : List<dynamic>.from(connections!.map((x) => x.toJson())),
  };
}

class Connection {
  Connection({
    required this.resourceName,
    required this.etag,
    required this.names,
    required this.phoneNumbers,
  });

  String? resourceName;
  String? etag;
  List<Name>? names;
  List<PhoneNumber>? phoneNumbers;

  factory Connection.fromJson(Map<String?, dynamic> json) => Connection(
    resourceName: json["resourceName"] == null ? null : json["resourceName"],
    etag: json["etag"] == null ? null : json["etag"],
    names: json["names"] == null ? null : List<Name>.from(json["names"].map((x) => Name.fromJson(x))),
    phoneNumbers: json["phoneNumbers"] == null ? null : List<PhoneNumber>.from(json["phoneNumbers"].map((x) => PhoneNumber.fromJson(x))),
  );

  Map<String?, dynamic> toJson() => {
    "resourceName": resourceName == null ? null : resourceName,
    "etag": etag == null ? null : etag,
    "names": names == null ? null : List<dynamic>.from(names!.map((x) => x.toJson())),
    "phoneNumbers": phoneNumbers == null ? null : List<dynamic>.from(phoneNumbers!.map((x) => x.toJson())),
  };
}

class Name {
  Name({
    required this.metadata,
    required this.displayName,
    required this.familyName,
    required this.givenName,
    required this.displayNameLastFirst,
    required this.unstructuredName,
  });

  Metadata? metadata;
  String? displayName;
  String? familyName;
  String? givenName;
  String? displayNameLastFirst;
  String? unstructuredName;

  factory Name.fromJson(Map<String?, dynamic> json) => Name(
    metadata: json["metadata"] == null ? null : Metadata.fromJson(json["metadata"]),
    displayName: json["displayName"] == null ? null : json["displayName"],
    familyName: json["familyName"] == null ? null : json["familyName"],
    givenName: json["givenName"] == null ? null : json["givenName"],
    displayNameLastFirst: json["displayNameLastFirst"] == null ? null : json["displayNameLastFirst"],
    unstructuredName: json["unstructuredName"] == null ? null : json["unstructuredName"],
  );

  Map<String?, dynamic> toJson() => {
    "metadata": metadata == null ? null : metadata!.toJson(),
    "displayName": displayName == null ? null : displayName,
    "familyName": familyName == null ? null : familyName,
    "givenName": givenName == null ? null : givenName,
    "displayNameLastFirst": displayNameLastFirst == null ? null : displayNameLastFirst,
    "unstructuredName": unstructuredName == null ? null : unstructuredName,
  };
}

class Metadata {
  Metadata({
    required this.primary,
    required this.source,
  });

  bool? primary;
  Source? source;

  factory Metadata.fromJson(Map<String?, dynamic> json) => Metadata(
    primary: json["primary"] == null ? null : json["primary"],
    source: json["source"] == null ? null : Source.fromJson(json["source"]),
  );

  Map<String?, dynamic> toJson() => {
    "primary": primary == null ? null : primary,
    "source": source == null ? null : source!.toJson(),
  };
}

class Source {
  Source({
    required this.type,
    required this.id,
  });

  String? type;
  String? id;

  factory Source.fromJson(Map<String?, dynamic> json) => Source(
    type: json["type"] == null ? null : json["type"],
    id: json["id"] == null ? null : json["id"],
  );

  Map<String?, dynamic> toJson() => {
    "type": type == null ? null : type,
    "id": id == null ? null : id,
  };
}

class PhoneNumber {
  PhoneNumber({
    required this.metadata,
    required this.value,
    required this.canonicalForm,
    required this.type,
    required this.formattedType,
  });

  Metadata? metadata;
  String? value;
  String? canonicalForm;
  String? type;
  String? formattedType;

  factory PhoneNumber.fromJson(Map<String?, dynamic> json) => PhoneNumber(
    metadata: json["metadata"] == null ? null : Metadata.fromJson(json["metadata"]),
    value: json["value"] == null ? null : json["value"],
    canonicalForm: json["canonicalForm"] == null ? null : json["canonicalForm"],
    type: json["type"] == null ? null : json["type"],
    formattedType: json["formattedType"] == null ? null : json["formattedType"],
  );

  Map<String?, dynamic> toJson() => {
    "metadata": metadata == null ? null : metadata!.toJson(),
    "value": value == null ? null : value,
    "canonicalForm": canonicalForm == null ? null : canonicalForm,
    "type": type == null ? null : type,
    "formattedType": formattedType == null ? null : formattedType,
  };
}
