part of 'generated.dart';

class CreateMoodEntryVariablesBuilder {
  String moodOptionId;
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
  CreateMoodEntryVariablesBuilder entryText(String? t) {
    _entryText.value = t;
    return this;
  }

  CreateMoodEntryVariablesBuilder latitude(double? t) {
    _latitude.value = t;
    return this;
  }

  CreateMoodEntryVariablesBuilder longitude(double? t) {
    _longitude.value = t;
    return this;
  }

  CreateMoodEntryVariablesBuilder(
    this._dataConnect, {
    required this.moodOptionId,
  });
  Deserializer<CreateMoodEntryData> dataDeserializer = (dynamic json) =>
      CreateMoodEntryData.fromJson(jsonDecode(json));
  Serializer<CreateMoodEntryVariables> varsSerializer =
      (CreateMoodEntryVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateMoodEntryData, CreateMoodEntryVariables>>
  execute() {
    return ref().execute();
  }

  MutationRef<CreateMoodEntryData, CreateMoodEntryVariables> ref() {
    CreateMoodEntryVariables vars = CreateMoodEntryVariables(
      moodOptionId: moodOptionId,
      entryText: _entryText,
      latitude: _latitude,
      longitude: _longitude,
    );
    return _dataConnect.mutation(
      "CreateMoodEntry",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class CreateMoodEntryMoodEntryInsert {
  final String id;
  CreateMoodEntryMoodEntryInsert.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateMoodEntryMoodEntryInsert otherTyped =
        other as CreateMoodEntryMoodEntryInsert;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const CreateMoodEntryMoodEntryInsert({required this.id});
}

@immutable
class CreateMoodEntryData {
  final CreateMoodEntryMoodEntryInsert moodEntryInsert;
  CreateMoodEntryData.fromJson(dynamic json)
    : moodEntryInsert = CreateMoodEntryMoodEntryInsert.fromJson(
        json['moodEntry_insert'],
      );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateMoodEntryData otherTyped = other as CreateMoodEntryData;
    return moodEntryInsert == otherTyped.moodEntryInsert;
  }

  @override
  int get hashCode => moodEntryInsert.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['moodEntry_insert'] = moodEntryInsert.toJson();
    return json;
  }

  const CreateMoodEntryData({required this.moodEntryInsert});
}

class CreateMoodEntryVariables {
  final String moodOptionId;
  late final Optional<String> entryText;
  late final Optional<double> latitude;
  late final Optional<double> longitude;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  CreateMoodEntryVariables.fromJson(Map<String, dynamic> json)
    : moodOptionId = nativeFromJson<String>(json['moodOptionId']) {
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

    final CreateMoodEntryVariables otherTyped =
        other as CreateMoodEntryVariables;
    return moodOptionId == otherTyped.moodOptionId &&
        entryText == otherTyped.entryText &&
        latitude == otherTyped.latitude &&
        longitude == otherTyped.longitude;
  }

  @override
  int get hashCode => Object.hashAll([
    moodOptionId.hashCode,
    entryText.hashCode,
    latitude.hashCode,
    longitude.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['moodOptionId'] = nativeToJson<String>(moodOptionId);
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

  CreateMoodEntryVariables({
    required this.moodOptionId,
    required this.entryText,
    required this.latitude,
    required this.longitude,
  });
}
