import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part 'create_mood_entry.dart';

part 'get_mood_entries_for_user.dart';

part 'update_mood_entry.dart';

part 'delete_mood_entry.dart';

class ExampleConnector {
  CreateMoodEntryVariablesBuilder createMoodEntry({
    required String moodOptionId,
  }) {
    return CreateMoodEntryVariablesBuilder(
      dataConnect,
      moodOptionId: moodOptionId,
    );
  }

  GetMoodEntriesForUserVariablesBuilder getMoodEntriesForUser() {
    return GetMoodEntriesForUserVariablesBuilder(dataConnect);
  }

  UpdateMoodEntryVariablesBuilder updateMoodEntry({required String id}) {
    return UpdateMoodEntryVariablesBuilder(dataConnect, id: id);
  }

  DeleteMoodEntryVariablesBuilder deleteMoodEntry({required String id}) {
    return DeleteMoodEntryVariablesBuilder(dataConnect, id: id);
  }

  static ConnectorConfig connectorConfig = ConnectorConfig(
    'us-east4',
    'example',
    'metalpulse',
  );

  ExampleConnector({required this.dataConnect});
  static ExampleConnector get instance {
    return ExampleConnector(
      dataConnect: FirebaseDataConnect.instanceFor(
        connectorConfig: connectorConfig,
        sdkType: CallerSDKType.generated,
      ),
    );
  }

  FirebaseDataConnect dataConnect;
}
