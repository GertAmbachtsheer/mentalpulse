part of 'generated.dart';

class UpdateMoodEntryVariablesBuilder {
  String id;
  final Optional<String> _entryText = Optional.optional(
    nativeFromJson,
    nativeToJson,
  );
  final Optional<double> _latitude = Optional.optional(
    nativeFromJson,
    nativeToJson,
  );
  final Optional<double> _longitude = Optional.optional(
    nativeFromJson,
    nativeToJson,
  );

  final FirebaseDataConnect _dataConnect;
  UpdateMoodEntryVariablesBuilder entryText(String? t) {
    _entryText.value = t;
    return this;
  }

  UpdateMoodEntryVariablesBuilder latitude(double? t) {
    _latitude.value = t;
    return this;
  }

  UpdateMoodEntryVariablesBuilder longitude(double? t) {
    _longitude.value = t;
    return this;
  }

  UpdateMoodEntryVariablesBuilder(this._dataConnect, {required this.id});
  Deserializer<UpdateMoodEntryData> dataDeserializer = (dynamic json) =>
      UpdateMoodEntryData.fromJson(jsonDecode(json));
  Serializer<UpdateMoodEntryVariables> varsSerializer =
      (UpdateMoodEntryVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateMoodEntryData, UpdateMoodEntryVariables>>
  execute() {
    return ref().execute();
  }

  MutationRef<UpdateMoodEntryData, UpdateMoodEntryVariables> ref() {
    UpdateMoodEntryVariables vars = UpdateMoodEntryVariables(
      id: id,
      entryText: _entryText,
      latitude: _latitude,
      longitude: _longitude,
    );
    return _dataConnect.mutation(
      "UpdateMoodEntry",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class UpdateMoodEntryMoodEntryUpdate {
  final String id;
  UpdateMoodEntryMoodEntryUpdate.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateMoodEntryMoodEntryUpdate otherTyped =
        other as UpdateMoodEntryMoodEntryUpdate;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const UpdateMoodEntryMoodEntryUpdate({required this.id});
}

@immutable
class UpdateMoodEntryData {
  final UpdateMoodEntryMoodEntryUpdate? moodEntryUpdate;
  UpdateMoodEntryData.fromJson(dynamic json)
    : moodEntryUpdate = json['moodEntry_update'] == null
          ? null
          : UpdateMoodEntryMoodEntryUpdate.fromJson(json['moodEntry_update']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateMoodEntryData otherTyped = other as UpdateMoodEntryData;
    return moodEntryUpdate == otherTyped.moodEntryUpdate;
  }

  @override
  int get hashCode => moodEntryUpdate.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (moodEntryUpdate != null) {
      json['moodEntry_update'] = moodEntryUpdate!.toJson();
    }
    return json;
  }

  const UpdateMoodEntryData({this.moodEntryUpdate});
}

class UpdateMoodEntryVariables {
  final String id;
  late final Optional<String> entryText;
  late final Optional<double> latitude;
  late final Optional<double> longitude;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  UpdateMoodEntryVariables.fromJson(Map<String, dynamic> json)
    : id = nativeFromJson<String>(json['id']) {
    entryText = Optional.optional(nativeFromJson, nativeToJson);
    entryText.value = json['entryText'] == null
        ? null
        : nativeFromJson<String>(json['entryText']);

    latitude = Optional.optional(nativeFromJson, nativeToJson);
    latitude.value = json['latitude'] == null
        ? null
        : nativeFromJson<double>(json['latitude']);

    longitude = Optional.optional(nativeFromJson, nativeToJson);
    longitude.value = json['longitude'] == null
        ? null
        : nativeFromJson<double>(json['longitude']);
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateMoodEntryVariables otherTyped =
        other as UpdateMoodEntryVariables;
    return id == otherTyped.id &&
        entryText == otherTyped.entryText &&
        latitude == otherTyped.latitude &&
        longitude == otherTyped.longitude;
  }

  @override
  int get hashCode => Object.hashAll([
    id.hashCode,
    entryText.hashCode,
    latitude.hashCode,
    longitude.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if (entryText.state == OptionalState.set) {
      json['entryText'] = entryText.toJson();
    }
    if (latitude.state == OptionalState.set) {
      json['latitude'] = latitude.toJson();
    }
    if (longitude.state == OptionalState.set) {
      json['longitude'] = longitude.toJson();
    }
    return json;
  }

  UpdateMoodEntryVariables({
    required this.id,
    required this.entryText,
    required this.latitude,
    required this.longitude,
  });
}
