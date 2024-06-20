import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UserInvitationRecord extends FirestoreRecord {
  UserInvitationRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "guestName" field.
  String? _guestName;
  String get guestName => _guestName ?? '';
  bool hasGuestName() => _guestName != null;

  // "guestCostume" field.
  String? _guestCostume;
  String get guestCostume => _guestCostume ?? '';
  bool hasGuestCostume() => _guestCostume != null;

  // "guestConfirmed" field.
  bool? _guestConfirmed;
  bool get guestConfirmed => _guestConfirmed ?? false;
  bool hasGuestConfirmed() => _guestConfirmed != null;

  // "user" field.
  DocumentReference? _user;
  DocumentReference? get user => _user;
  bool hasUser() => _user != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  void _initializeFields() {
    _guestName = snapshotData['guestName'] as String?;
    _guestCostume = snapshotData['guestCostume'] as String?;
    _guestConfirmed = snapshotData['guestConfirmed'] as bool?;
    _user = snapshotData['user'] as DocumentReference?;
    _photoUrl = snapshotData['photo_url'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('userInvitation');

  static Stream<UserInvitationRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UserInvitationRecord.fromSnapshot(s));

  static Future<UserInvitationRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UserInvitationRecord.fromSnapshot(s));

  static UserInvitationRecord fromSnapshot(DocumentSnapshot snapshot) =>
      UserInvitationRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UserInvitationRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UserInvitationRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UserInvitationRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UserInvitationRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUserInvitationRecordData({
  String? guestName,
  String? guestCostume,
  bool? guestConfirmed,
  DocumentReference? user,
  String? photoUrl,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'guestName': guestName,
      'guestCostume': guestCostume,
      'guestConfirmed': guestConfirmed,
      'user': user,
      'photo_url': photoUrl,
    }.withoutNulls,
  );

  return firestoreData;
}

class UserInvitationRecordDocumentEquality
    implements Equality<UserInvitationRecord> {
  const UserInvitationRecordDocumentEquality();

  @override
  bool equals(UserInvitationRecord? e1, UserInvitationRecord? e2) {
    return e1?.guestName == e2?.guestName &&
        e1?.guestCostume == e2?.guestCostume &&
        e1?.guestConfirmed == e2?.guestConfirmed &&
        e1?.user == e2?.user &&
        e1?.photoUrl == e2?.photoUrl;
  }

  @override
  int hash(UserInvitationRecord? e) => const ListEquality().hash(
      [e?.guestName, e?.guestCostume, e?.guestConfirmed, e?.user, e?.photoUrl]);

  @override
  bool isValidKey(Object? o) => o is UserInvitationRecord;
}
