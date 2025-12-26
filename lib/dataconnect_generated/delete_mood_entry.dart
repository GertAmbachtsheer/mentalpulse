part of 'generated.dart';

class DeleteMoodEntryVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeleteMoodEntryVariablesBuilder(this._dataConnect, {required this.id});
  Deserializer<DeleteMoodEntryData> dataDeserializer = (dynamic json) =>
      DeleteMoodEntryData.fromJson(jsonDecode(json));
  Serializer<DeleteMoodEntryVariables> varsSerializer =
      (DeleteMoodEntryVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteMoodEntryData, DeleteMoodEntryVariables>>
  execute() {
    return ref().execute();
  }

  MutationRef<DeleteMoodEntryData, DeleteMoodEntryVariables> ref() {
    DeleteMoodEntryVariables vars = DeleteMoodEntryVariables(id: id);
    return _dataConnect.mutation(
      "DeleteMoodEntry",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class DeleteMoodEntryMoodEntryDelete {
  final String id;
  DeleteMoodEntryMoodEntryDelete.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteMoodEntryMoodEntryDelete otherTyped =
        other as DeleteMoodEntryMoodEntryDelete;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const DeleteMoodEntryMoodEntryDelete({required this.id});
}

@immutable
class DeleteMoodEntryData {
  final DeleteMoodEntryMoodEntryDelete? moodEntryDelete;
  DeleteMoodEntryData.fromJson(dynamic json)
    : moodEntryDelete = json['moodEntry_delete'] == null
          ? null
          : DeleteMoodEntryMoodEntryDelete.fromJson(json['moodEntry_delete']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteMoodEntryData otherTyped = other as DeleteMoodEntryData;
    return moodEntryDelete == otherTyped.moodEntryDelete;
  }

  @override
  int get hashCode => moodEntryDelete.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (moodEntryDelete != null) {
      json['moodEntry_delete'] = moodEntryDelete!.toJson();
    }
    return json;
  }

  const DeleteMoodEntryData({this.moodEntryDelete});
}

@immutable
class DeleteMoodEntryVariables {
  final String id;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  DeleteMoodEntryVariables.fromJson(Map<String, dynamic> json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteMoodEntryVariables otherTyped =
        other as DeleteMoodEntryVariables;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const DeleteMoodEntryVariables({required this.id});
}
