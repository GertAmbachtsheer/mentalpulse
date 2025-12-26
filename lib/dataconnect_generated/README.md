# dataconnect_generated SDK

## Installation
```sh
flutter pub get firebase_data_connect
flutterfire configure
```
For more information, see [Flutter for Firebase installation documentation](https://firebase.google.com/docs/data-connect/flutter-sdk#use-core).

## Data Connect instance
Each connector creates a static class, with an instance of the `DataConnect` class that can be used to connect to your Data Connect backend and call operations.

### Connecting to the emulator

```dart
String host = 'localhost'; // or your host name
int port = 9399; // or your port number
ExampleConnector.instance.dataConnect.useDataConnectEmulator(host, port);
```

You can also call queries and mutations by using the connector class.
## Queries

### GetMoodEntriesForUser
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.getMoodEntriesForUser().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetMoodEntriesForUserData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getMoodEntriesForUser();
GetMoodEntriesForUserData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.getMoodEntriesForUser().ref();
ref.execute();

ref.subscribe(...);
```

## Mutations

### CreateMoodEntry
#### Required Arguments
```dart
String moodOptionId = ...;
ExampleConnector.instance.createMoodEntry(
  moodOptionId: moodOptionId,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CreateMoodEntry, we created `CreateMoodEntryBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreateMoodEntryVariablesBuilder {
  ...
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

  ...
}
ExampleConnector.instance.createMoodEntry(
  moodOptionId: moodOptionId,
)
.entryText(entryText)
.latitude(latitude)
.longitude(longitude)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CreateMoodEntryData, CreateMoodEntryVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createMoodEntry(
  moodOptionId: moodOptionId,
);
CreateMoodEntryData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String moodOptionId = ...;

final ref = ExampleConnector.instance.createMoodEntry(
  moodOptionId: moodOptionId,
).ref();
ref.execute();
```


### UpdateMoodEntry
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.updateMoodEntry(
  id: id,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpdateMoodEntry, we created `UpdateMoodEntryBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpdateMoodEntryVariablesBuilder {
  ...
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

  ...
}
ExampleConnector.instance.updateMoodEntry(
  id: id,
)
.entryText(entryText)
.latitude(latitude)
.longitude(longitude)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpdateMoodEntryData, UpdateMoodEntryVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.updateMoodEntry(
  id: id,
);
UpdateMoodEntryData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.updateMoodEntry(
  id: id,
).ref();
ref.execute();
```


### DeleteMoodEntry
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.deleteMoodEntry(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteMoodEntryData, DeleteMoodEntryVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.deleteMoodEntry(
  id: id,
);
DeleteMoodEntryData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.deleteMoodEntry(
  id: id,
).ref();
ref.execute();
```

