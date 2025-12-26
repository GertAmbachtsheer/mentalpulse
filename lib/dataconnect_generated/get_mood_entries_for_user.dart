part of 'generated.dart';

class GetMoodEntriesForUserVariablesBuilder {
  final FirebaseDataConnect _dataConnect;
  GetMoodEntriesForUserVariablesBuilder(this._dataConnect);
  Deserializer<GetMoodEntriesForUserData> dataDeserializer = (dynamic json) =>
      GetMoodEntriesForUserData.fromJson(jsonDecode(json));

  Future<QueryResult<GetMoodEntriesForUserData, void>> execute() {
    return ref().execute();
  }

  QueryRef<GetMoodEntriesForUserData, void> ref() {
    return _dataConnect.query(
      "GetMoodEntriesForUser",
      dataDeserializer,
      emptySerializer,
      null,
    );
  }
}

@immutable
class GetMoodEntriesForUserMoodEntries {
  final String id;
  final GetMoodEntriesForUserMoodEntriesMoodOption moodOption;
  final Timestamp createdAt;
  final String? entryText;
  final double? latitude;
  final double? longitude;
  GetMoodEntriesForUserMoodEntries.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']),
      moodOption = GetMoodEntriesForUserMoodEntriesMoodOption.fromJson(
        json['moodOption'],
      ),
      createdAt = Timestamp.fromJson(json['createdAt']),
      entryText = json['entryText'] == null
          ? null
          : nativeFromJson<String>(json['entryText']),
      latitude = json['latitude'] == null
          ? null
          : nativeFromJson<double>(json['latitude']),
      longitude = json['longitude'] == null
          ? null
          : nativeFromJson<double>(json['longitude']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetMoodEntriesForUserMoodEntries otherTyped =
        other as GetMoodEntriesForUserMoodEntries;
    return id == otherTyped.id &&
        moodOption == otherTyped.moodOption &&
        createdAt == otherTyped.createdAt &&
        entryText == otherTyped.entryText &&
        latitude == otherTyped.latitude &&
        longitude == otherTyped.longitude;
  }

  @override
  int get hashCode => Object.hashAll([
    id.hashCode,
    moodOption.hashCode,
    createdAt.hashCode,
    entryText.hashCode,
    latitude.hashCode,
    longitude.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['moodOption'] = moodOption.toJson();
    json['createdAt'] = createdAt.toJson();
    if (entryText != null) {
      json['entryText'] = nativeToJson<String?>(entryText);
    }
    if (latitude != null) {
      json['latitude'] = nativeToJson<double?>(latitude);
    }
    if (longitude != null) {
      json['longitude'] = nativeToJson<double?>(longitude);
    }
    return json;
  }

  const GetMoodEntriesForUserMoodEntries({
    required this.id,
    required this.moodOption,
    required this.createdAt,
    this.entryText,
    this.latitude,
    this.longitude,
  });
}

@immutable
class GetMoodEntriesForUserMoodEntriesMoodOption {
  final String id;
  final String name;
  final String value;
  GetMoodEntriesForUserMoodEntriesMoodOption.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']),
      name = nativeFromJson<String>(json['name']),
      value = nativeFromJson<String>(json['value']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetMoodEntriesForUserMoodEntriesMoodOption otherTyped =
        other as GetMoodEntriesForUserMoodEntriesMoodOption;
    return id == otherTyped.id &&
        name == otherTyped.name &&
        value == otherTyped.value;
  }

  @override
  int get hashCode =>
      Object.hashAll([id.hashCode, name.hashCode, value.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    json['value'] = nativeToJson<String>(value);
    return json;
  }

  const GetMoodEntriesForUserMoodEntriesMoodOption({
    required this.id,
    required this.name,
    required this.value,
  });
}

@immutable
class GetMoodEntriesForUserData {
  final List<GetMoodEntriesForUserMoodEntries> moodEntries;
  GetMoodEntriesForUserData.fromJson(dynamic json)
    : moodEntries = (json['moodEntries'] as List<dynamic>)
          .map((e) => GetMoodEntriesForUserMoodEntries.fromJson(e))
          .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetMoodEntriesForUserData otherTyped =
        other as GetMoodEntriesForUserData;
    return moodEntries == otherTyped.moodEntries;
  }

  @override
  int get hashCode => moodEntries.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['moodEntries'] = moodEntries.map((e) => e.toJson()).toList();
    return json;
  }

  const GetMoodEntriesForUserData({required this.moodEntries});
}
