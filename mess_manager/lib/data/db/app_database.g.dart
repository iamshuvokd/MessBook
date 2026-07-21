// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $GroupsTable extends Groups with TableInfo<$GroupsTable, Group> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('mess'),
  );
  static const VerificationMeta _currencySymbolMeta = const VerificationMeta(
    'currencySymbol',
  );
  @override
  late final GeneratedColumn<String> currencySymbol = GeneratedColumn<String>(
    'currency_symbol',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('৳'),
  );
  static const VerificationMeta _monthStartDayMeta = const VerificationMeta(
    'monthStartDay',
  );
  @override
  late final GeneratedColumn<int> monthStartDay = GeneratedColumn<int>(
    'month_start_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _mealEnabledMeta = const VerificationMeta(
    'mealEnabled',
  );
  @override
  late final GeneratedColumn<bool> mealEnabled = GeneratedColumn<bool>(
    'meal_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("meal_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _mealLedgerSeparateMeta =
      const VerificationMeta('mealLedgerSeparate');
  @override
  late final GeneratedColumn<bool> mealLedgerSeparate = GeneratedColumn<bool>(
    'meal_ledger_separate',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("meal_ledger_separate" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _defaultNonVoterPolicyMeta =
      const VerificationMeta('defaultNonVoterPolicy');
  @override
  late final GeneratedColumn<String> defaultNonVoterPolicy =
      GeneratedColumn<String>(
        'default_non_voter_policy',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('routine'),
      );
  static const VerificationMeta _pollReminderMinutesMeta =
      const VerificationMeta('pollReminderMinutes');
  @override
  late final GeneratedColumn<int> pollReminderMinutes = GeneratedColumn<int>(
    'poll_reminder_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(30),
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inviteCodeMeta = const VerificationMeta(
    'inviteCode',
  );
  @override
  late final GeneratedColumn<String> inviteCode = GeneratedColumn<String>(
    'invite_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    currencySymbol,
    monthStartDay,
    mealEnabled,
    mealLedgerSeparate,
    defaultNonVoterPolicy,
    pollReminderMinutes,
    archived,
    createdAt,
    updatedAt,
    inviteCode,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<Group> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('currency_symbol')) {
      context.handle(
        _currencySymbolMeta,
        currencySymbol.isAcceptableOrUnknown(
          data['currency_symbol']!,
          _currencySymbolMeta,
        ),
      );
    }
    if (data.containsKey('month_start_day')) {
      context.handle(
        _monthStartDayMeta,
        monthStartDay.isAcceptableOrUnknown(
          data['month_start_day']!,
          _monthStartDayMeta,
        ),
      );
    }
    if (data.containsKey('meal_enabled')) {
      context.handle(
        _mealEnabledMeta,
        mealEnabled.isAcceptableOrUnknown(
          data['meal_enabled']!,
          _mealEnabledMeta,
        ),
      );
    }
    if (data.containsKey('meal_ledger_separate')) {
      context.handle(
        _mealLedgerSeparateMeta,
        mealLedgerSeparate.isAcceptableOrUnknown(
          data['meal_ledger_separate']!,
          _mealLedgerSeparateMeta,
        ),
      );
    }
    if (data.containsKey('default_non_voter_policy')) {
      context.handle(
        _defaultNonVoterPolicyMeta,
        defaultNonVoterPolicy.isAcceptableOrUnknown(
          data['default_non_voter_policy']!,
          _defaultNonVoterPolicyMeta,
        ),
      );
    }
    if (data.containsKey('poll_reminder_minutes')) {
      context.handle(
        _pollReminderMinutesMeta,
        pollReminderMinutes.isAcceptableOrUnknown(
          data['poll_reminder_minutes']!,
          _pollReminderMinutesMeta,
        ),
      );
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('invite_code')) {
      context.handle(
        _inviteCodeMeta,
        inviteCode.isAcceptableOrUnknown(data['invite_code']!, _inviteCodeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Group map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Group(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      currencySymbol: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_symbol'],
      )!,
      monthStartDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}month_start_day'],
      )!,
      mealEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}meal_enabled'],
      )!,
      mealLedgerSeparate: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}meal_ledger_separate'],
      )!,
      defaultNonVoterPolicy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_non_voter_policy'],
      )!,
      pollReminderMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}poll_reminder_minutes'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      inviteCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invite_code'],
      ),
    );
  }

  @override
  $GroupsTable createAlias(String alias) {
    return $GroupsTable(attachedDatabase, alias);
  }
}

class Group extends DataClass implements Insertable<Group> {
  final String id;
  final String name;
  final String type;
  final String currencySymbol;
  final int monthStartDay;
  final bool mealEnabled;
  final bool mealLedgerSeparate;
  final String defaultNonVoterPolicy;
  final int pollReminderMinutes;
  final bool archived;
  final int createdAt;
  final int updatedAt;
  final String? inviteCode;
  const Group({
    required this.id,
    required this.name,
    required this.type,
    required this.currencySymbol,
    required this.monthStartDay,
    required this.mealEnabled,
    required this.mealLedgerSeparate,
    required this.defaultNonVoterPolicy,
    required this.pollReminderMinutes,
    required this.archived,
    required this.createdAt,
    required this.updatedAt,
    this.inviteCode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['currency_symbol'] = Variable<String>(currencySymbol);
    map['month_start_day'] = Variable<int>(monthStartDay);
    map['meal_enabled'] = Variable<bool>(mealEnabled);
    map['meal_ledger_separate'] = Variable<bool>(mealLedgerSeparate);
    map['default_non_voter_policy'] = Variable<String>(defaultNonVoterPolicy);
    map['poll_reminder_minutes'] = Variable<int>(pollReminderMinutes);
    map['archived'] = Variable<bool>(archived);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || inviteCode != null) {
      map['invite_code'] = Variable<String>(inviteCode);
    }
    return map;
  }

  GroupsCompanion toCompanion(bool nullToAbsent) {
    return GroupsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      currencySymbol: Value(currencySymbol),
      monthStartDay: Value(monthStartDay),
      mealEnabled: Value(mealEnabled),
      mealLedgerSeparate: Value(mealLedgerSeparate),
      defaultNonVoterPolicy: Value(defaultNonVoterPolicy),
      pollReminderMinutes: Value(pollReminderMinutes),
      archived: Value(archived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      inviteCode: inviteCode == null && nullToAbsent
          ? const Value.absent()
          : Value(inviteCode),
    );
  }

  factory Group.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Group(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      currencySymbol: serializer.fromJson<String>(json['currencySymbol']),
      monthStartDay: serializer.fromJson<int>(json['monthStartDay']),
      mealEnabled: serializer.fromJson<bool>(json['mealEnabled']),
      mealLedgerSeparate: serializer.fromJson<bool>(json['mealLedgerSeparate']),
      defaultNonVoterPolicy: serializer.fromJson<String>(
        json['defaultNonVoterPolicy'],
      ),
      pollReminderMinutes: serializer.fromJson<int>(
        json['pollReminderMinutes'],
      ),
      archived: serializer.fromJson<bool>(json['archived']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      inviteCode: serializer.fromJson<String?>(json['inviteCode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'currencySymbol': serializer.toJson<String>(currencySymbol),
      'monthStartDay': serializer.toJson<int>(monthStartDay),
      'mealEnabled': serializer.toJson<bool>(mealEnabled),
      'mealLedgerSeparate': serializer.toJson<bool>(mealLedgerSeparate),
      'defaultNonVoterPolicy': serializer.toJson<String>(defaultNonVoterPolicy),
      'pollReminderMinutes': serializer.toJson<int>(pollReminderMinutes),
      'archived': serializer.toJson<bool>(archived),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'inviteCode': serializer.toJson<String?>(inviteCode),
    };
  }

  Group copyWith({
    String? id,
    String? name,
    String? type,
    String? currencySymbol,
    int? monthStartDay,
    bool? mealEnabled,
    bool? mealLedgerSeparate,
    String? defaultNonVoterPolicy,
    int? pollReminderMinutes,
    bool? archived,
    int? createdAt,
    int? updatedAt,
    Value<String?> inviteCode = const Value.absent(),
  }) => Group(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    currencySymbol: currencySymbol ?? this.currencySymbol,
    monthStartDay: monthStartDay ?? this.monthStartDay,
    mealEnabled: mealEnabled ?? this.mealEnabled,
    mealLedgerSeparate: mealLedgerSeparate ?? this.mealLedgerSeparate,
    defaultNonVoterPolicy: defaultNonVoterPolicy ?? this.defaultNonVoterPolicy,
    pollReminderMinutes: pollReminderMinutes ?? this.pollReminderMinutes,
    archived: archived ?? this.archived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    inviteCode: inviteCode.present ? inviteCode.value : this.inviteCode,
  );
  Group copyWithCompanion(GroupsCompanion data) {
    return Group(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      currencySymbol: data.currencySymbol.present
          ? data.currencySymbol.value
          : this.currencySymbol,
      monthStartDay: data.monthStartDay.present
          ? data.monthStartDay.value
          : this.monthStartDay,
      mealEnabled: data.mealEnabled.present
          ? data.mealEnabled.value
          : this.mealEnabled,
      mealLedgerSeparate: data.mealLedgerSeparate.present
          ? data.mealLedgerSeparate.value
          : this.mealLedgerSeparate,
      defaultNonVoterPolicy: data.defaultNonVoterPolicy.present
          ? data.defaultNonVoterPolicy.value
          : this.defaultNonVoterPolicy,
      pollReminderMinutes: data.pollReminderMinutes.present
          ? data.pollReminderMinutes.value
          : this.pollReminderMinutes,
      archived: data.archived.present ? data.archived.value : this.archived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      inviteCode: data.inviteCode.present
          ? data.inviteCode.value
          : this.inviteCode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Group(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('currencySymbol: $currencySymbol, ')
          ..write('monthStartDay: $monthStartDay, ')
          ..write('mealEnabled: $mealEnabled, ')
          ..write('mealLedgerSeparate: $mealLedgerSeparate, ')
          ..write('defaultNonVoterPolicy: $defaultNonVoterPolicy, ')
          ..write('pollReminderMinutes: $pollReminderMinutes, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('inviteCode: $inviteCode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    type,
    currencySymbol,
    monthStartDay,
    mealEnabled,
    mealLedgerSeparate,
    defaultNonVoterPolicy,
    pollReminderMinutes,
    archived,
    createdAt,
    updatedAt,
    inviteCode,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Group &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.currencySymbol == this.currencySymbol &&
          other.monthStartDay == this.monthStartDay &&
          other.mealEnabled == this.mealEnabled &&
          other.mealLedgerSeparate == this.mealLedgerSeparate &&
          other.defaultNonVoterPolicy == this.defaultNonVoterPolicy &&
          other.pollReminderMinutes == this.pollReminderMinutes &&
          other.archived == this.archived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.inviteCode == this.inviteCode);
}

class GroupsCompanion extends UpdateCompanion<Group> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String> currencySymbol;
  final Value<int> monthStartDay;
  final Value<bool> mealEnabled;
  final Value<bool> mealLedgerSeparate;
  final Value<String> defaultNonVoterPolicy;
  final Value<int> pollReminderMinutes;
  final Value<bool> archived;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<String?> inviteCode;
  final Value<int> rowid;
  const GroupsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.currencySymbol = const Value.absent(),
    this.monthStartDay = const Value.absent(),
    this.mealEnabled = const Value.absent(),
    this.mealLedgerSeparate = const Value.absent(),
    this.defaultNonVoterPolicy = const Value.absent(),
    this.pollReminderMinutes = const Value.absent(),
    this.archived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.inviteCode = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GroupsCompanion.insert({
    required String id,
    required String name,
    this.type = const Value.absent(),
    this.currencySymbol = const Value.absent(),
    this.monthStartDay = const Value.absent(),
    this.mealEnabled = const Value.absent(),
    this.mealLedgerSeparate = const Value.absent(),
    this.defaultNonVoterPolicy = const Value.absent(),
    this.pollReminderMinutes = const Value.absent(),
    this.archived = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.inviteCode = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Group> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? currencySymbol,
    Expression<int>? monthStartDay,
    Expression<bool>? mealEnabled,
    Expression<bool>? mealLedgerSeparate,
    Expression<String>? defaultNonVoterPolicy,
    Expression<int>? pollReminderMinutes,
    Expression<bool>? archived,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? inviteCode,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (currencySymbol != null) 'currency_symbol': currencySymbol,
      if (monthStartDay != null) 'month_start_day': monthStartDay,
      if (mealEnabled != null) 'meal_enabled': mealEnabled,
      if (mealLedgerSeparate != null)
        'meal_ledger_separate': mealLedgerSeparate,
      if (defaultNonVoterPolicy != null)
        'default_non_voter_policy': defaultNonVoterPolicy,
      if (pollReminderMinutes != null)
        'poll_reminder_minutes': pollReminderMinutes,
      if (archived != null) 'archived': archived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (inviteCode != null) 'invite_code': inviteCode,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GroupsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? type,
    Value<String>? currencySymbol,
    Value<int>? monthStartDay,
    Value<bool>? mealEnabled,
    Value<bool>? mealLedgerSeparate,
    Value<String>? defaultNonVoterPolicy,
    Value<int>? pollReminderMinutes,
    Value<bool>? archived,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<String?>? inviteCode,
    Value<int>? rowid,
  }) {
    return GroupsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      monthStartDay: monthStartDay ?? this.monthStartDay,
      mealEnabled: mealEnabled ?? this.mealEnabled,
      mealLedgerSeparate: mealLedgerSeparate ?? this.mealLedgerSeparate,
      defaultNonVoterPolicy:
          defaultNonVoterPolicy ?? this.defaultNonVoterPolicy,
      pollReminderMinutes: pollReminderMinutes ?? this.pollReminderMinutes,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      inviteCode: inviteCode ?? this.inviteCode,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (currencySymbol.present) {
      map['currency_symbol'] = Variable<String>(currencySymbol.value);
    }
    if (monthStartDay.present) {
      map['month_start_day'] = Variable<int>(monthStartDay.value);
    }
    if (mealEnabled.present) {
      map['meal_enabled'] = Variable<bool>(mealEnabled.value);
    }
    if (mealLedgerSeparate.present) {
      map['meal_ledger_separate'] = Variable<bool>(mealLedgerSeparate.value);
    }
    if (defaultNonVoterPolicy.present) {
      map['default_non_voter_policy'] = Variable<String>(
        defaultNonVoterPolicy.value,
      );
    }
    if (pollReminderMinutes.present) {
      map['poll_reminder_minutes'] = Variable<int>(pollReminderMinutes.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (inviteCode.present) {
      map['invite_code'] = Variable<String>(inviteCode.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('currencySymbol: $currencySymbol, ')
          ..write('monthStartDay: $monthStartDay, ')
          ..write('mealEnabled: $mealEnabled, ')
          ..write('mealLedgerSeparate: $mealLedgerSeparate, ')
          ..write('defaultNonVoterPolicy: $defaultNonVoterPolicy, ')
          ..write('pollReminderMinutes: $pollReminderMinutes, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('inviteCode: $inviteCode, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MembersTable extends Members with TableInfo<$MembersTable, Member> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "groups" (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _joinDateMeta = const VerificationMeta(
    'joinDate',
  );
  @override
  late final GeneratedColumn<int> joinDate = GeneratedColumn<int>(
    'join_date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _leaveDateMeta = const VerificationMeta(
    'leaveDate',
  );
  @override
  late final GeneratedColumn<int> leaveDate = GeneratedColumn<int>(
    'leave_date',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('member'),
  );
  static const VerificationMeta _permissionsMeta = const VerificationMeta(
    'permissions',
  );
  @override
  late final GeneratedColumn<String> permissions = GeneratedColumn<String>(
    'permissions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    groupId,
    name,
    phone,
    photoPath,
    joinDate,
    leaveDate,
    active,
    role,
    permissions,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'members';
  @override
  VerificationContext validateIntegrity(
    Insertable<Member> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('join_date')) {
      context.handle(
        _joinDateMeta,
        joinDate.isAcceptableOrUnknown(data['join_date']!, _joinDateMeta),
      );
    } else if (isInserting) {
      context.missing(_joinDateMeta);
    }
    if (data.containsKey('leave_date')) {
      context.handle(
        _leaveDateMeta,
        leaveDate.isAcceptableOrUnknown(data['leave_date']!, _leaveDateMeta),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    if (data.containsKey('permissions')) {
      context.handle(
        _permissionsMeta,
        permissions.isAcceptableOrUnknown(
          data['permissions']!,
          _permissionsMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Member map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Member(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      joinDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}join_date'],
      )!,
      leaveDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}leave_date'],
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      permissions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}permissions'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MembersTable createAlias(String alias) {
    return $MembersTable(attachedDatabase, alias);
  }
}

class Member extends DataClass implements Insertable<Member> {
  final String id;
  final String groupId;
  final String name;
  final String? phone;
  final String? photoPath;
  final int joinDate;
  final int? leaveDate;
  final bool active;
  final String role;
  final String permissions;
  final int updatedAt;
  const Member({
    required this.id,
    required this.groupId,
    required this.name,
    this.phone,
    this.photoPath,
    required this.joinDate,
    this.leaveDate,
    required this.active,
    required this.role,
    required this.permissions,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['group_id'] = Variable<String>(groupId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    map['join_date'] = Variable<int>(joinDate);
    if (!nullToAbsent || leaveDate != null) {
      map['leave_date'] = Variable<int>(leaveDate);
    }
    map['active'] = Variable<bool>(active);
    map['role'] = Variable<String>(role);
    map['permissions'] = Variable<String>(permissions);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  MembersCompanion toCompanion(bool nullToAbsent) {
    return MembersCompanion(
      id: Value(id),
      groupId: Value(groupId),
      name: Value(name),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      joinDate: Value(joinDate),
      leaveDate: leaveDate == null && nullToAbsent
          ? const Value.absent()
          : Value(leaveDate),
      active: Value(active),
      role: Value(role),
      permissions: Value(permissions),
      updatedAt: Value(updatedAt),
    );
  }

  factory Member.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Member(
      id: serializer.fromJson<String>(json['id']),
      groupId: serializer.fromJson<String>(json['groupId']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      joinDate: serializer.fromJson<int>(json['joinDate']),
      leaveDate: serializer.fromJson<int?>(json['leaveDate']),
      active: serializer.fromJson<bool>(json['active']),
      role: serializer.fromJson<String>(json['role']),
      permissions: serializer.fromJson<String>(json['permissions']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'groupId': serializer.toJson<String>(groupId),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'photoPath': serializer.toJson<String?>(photoPath),
      'joinDate': serializer.toJson<int>(joinDate),
      'leaveDate': serializer.toJson<int?>(leaveDate),
      'active': serializer.toJson<bool>(active),
      'role': serializer.toJson<String>(role),
      'permissions': serializer.toJson<String>(permissions),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  Member copyWith({
    String? id,
    String? groupId,
    String? name,
    Value<String?> phone = const Value.absent(),
    Value<String?> photoPath = const Value.absent(),
    int? joinDate,
    Value<int?> leaveDate = const Value.absent(),
    bool? active,
    String? role,
    String? permissions,
    int? updatedAt,
  }) => Member(
    id: id ?? this.id,
    groupId: groupId ?? this.groupId,
    name: name ?? this.name,
    phone: phone.present ? phone.value : this.phone,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    joinDate: joinDate ?? this.joinDate,
    leaveDate: leaveDate.present ? leaveDate.value : this.leaveDate,
    active: active ?? this.active,
    role: role ?? this.role,
    permissions: permissions ?? this.permissions,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Member copyWithCompanion(MembersCompanion data) {
    return Member(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      joinDate: data.joinDate.present ? data.joinDate.value : this.joinDate,
      leaveDate: data.leaveDate.present ? data.leaveDate.value : this.leaveDate,
      active: data.active.present ? data.active.value : this.active,
      role: data.role.present ? data.role.value : this.role,
      permissions: data.permissions.present
          ? data.permissions.value
          : this.permissions,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Member(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('photoPath: $photoPath, ')
          ..write('joinDate: $joinDate, ')
          ..write('leaveDate: $leaveDate, ')
          ..write('active: $active, ')
          ..write('role: $role, ')
          ..write('permissions: $permissions, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    groupId,
    name,
    phone,
    photoPath,
    joinDate,
    leaveDate,
    active,
    role,
    permissions,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Member &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.photoPath == this.photoPath &&
          other.joinDate == this.joinDate &&
          other.leaveDate == this.leaveDate &&
          other.active == this.active &&
          other.role == this.role &&
          other.permissions == this.permissions &&
          other.updatedAt == this.updatedAt);
}

class MembersCompanion extends UpdateCompanion<Member> {
  final Value<String> id;
  final Value<String> groupId;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String?> photoPath;
  final Value<int> joinDate;
  final Value<int?> leaveDate;
  final Value<bool> active;
  final Value<String> role;
  final Value<String> permissions;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const MembersCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.joinDate = const Value.absent(),
    this.leaveDate = const Value.absent(),
    this.active = const Value.absent(),
    this.role = const Value.absent(),
    this.permissions = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MembersCompanion.insert({
    required String id,
    required String groupId,
    required String name,
    this.phone = const Value.absent(),
    this.photoPath = const Value.absent(),
    required int joinDate,
    this.leaveDate = const Value.absent(),
    this.active = const Value.absent(),
    this.role = const Value.absent(),
    this.permissions = const Value.absent(),
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       groupId = Value(groupId),
       name = Value(name),
       joinDate = Value(joinDate),
       updatedAt = Value(updatedAt);
  static Insertable<Member> custom({
    Expression<String>? id,
    Expression<String>? groupId,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? photoPath,
    Expression<int>? joinDate,
    Expression<int>? leaveDate,
    Expression<bool>? active,
    Expression<String>? role,
    Expression<String>? permissions,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (photoPath != null) 'photo_path': photoPath,
      if (joinDate != null) 'join_date': joinDate,
      if (leaveDate != null) 'leave_date': leaveDate,
      if (active != null) 'active': active,
      if (role != null) 'role': role,
      if (permissions != null) 'permissions': permissions,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MembersCompanion copyWith({
    Value<String>? id,
    Value<String>? groupId,
    Value<String>? name,
    Value<String?>? phone,
    Value<String?>? photoPath,
    Value<int>? joinDate,
    Value<int?>? leaveDate,
    Value<bool>? active,
    Value<String>? role,
    Value<String>? permissions,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return MembersCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      photoPath: photoPath ?? this.photoPath,
      joinDate: joinDate ?? this.joinDate,
      leaveDate: leaveDate ?? this.leaveDate,
      active: active ?? this.active,
      role: role ?? this.role,
      permissions: permissions ?? this.permissions,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (joinDate.present) {
      map['join_date'] = Variable<int>(joinDate.value);
    }
    if (leaveDate.present) {
      map['leave_date'] = Variable<int>(leaveDate.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (permissions.present) {
      map['permissions'] = Variable<String>(permissions.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MembersCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('photoPath: $photoPath, ')
          ..write('joinDate: $joinDate, ')
          ..write('leaveDate: $leaveDate, ')
          ..write('active: $active, ')
          ..write('role: $role, ')
          ..write('permissions: $permissions, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "groups" (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultKeyMeta = const VerificationMeta(
    'defaultKey',
  );
  @override
  late final GeneratedColumn<String> defaultKey = GeneratedColumn<String>(
    'default_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isMealCategoryMeta = const VerificationMeta(
    'isMealCategory',
  );
  @override
  late final GeneratedColumn<bool> isMealCategory = GeneratedColumn<bool>(
    'is_meal_category',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_meal_category" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    groupId,
    name,
    defaultKey,
    isMealCategory,
    icon,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('default_key')) {
      context.handle(
        _defaultKeyMeta,
        defaultKey.isAcceptableOrUnknown(data['default_key']!, _defaultKeyMeta),
      );
    }
    if (data.containsKey('is_meal_category')) {
      context.handle(
        _isMealCategoryMeta,
        isMealCategory.isAcceptableOrUnknown(
          data['is_meal_category']!,
          _isMealCategoryMeta,
        ),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      defaultKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_key'],
      ),
      isMealCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_meal_category'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final String id;
  final String? groupId;
  final String name;
  final String? defaultKey;
  final bool isMealCategory;
  final String icon;
  final int updatedAt;
  const Category({
    required this.id,
    this.groupId,
    required this.name,
    this.defaultKey,
    required this.isMealCategory,
    required this.icon,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<String>(groupId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || defaultKey != null) {
      map['default_key'] = Variable<String>(defaultKey);
    }
    map['is_meal_category'] = Variable<bool>(isMealCategory);
    map['icon'] = Variable<String>(icon);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
      name: Value(name),
      defaultKey: defaultKey == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultKey),
      isMealCategory: Value(isMealCategory),
      icon: Value(icon),
      updatedAt: Value(updatedAt),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<String>(json['id']),
      groupId: serializer.fromJson<String?>(json['groupId']),
      name: serializer.fromJson<String>(json['name']),
      defaultKey: serializer.fromJson<String?>(json['defaultKey']),
      isMealCategory: serializer.fromJson<bool>(json['isMealCategory']),
      icon: serializer.fromJson<String>(json['icon']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'groupId': serializer.toJson<String?>(groupId),
      'name': serializer.toJson<String>(name),
      'defaultKey': serializer.toJson<String?>(defaultKey),
      'isMealCategory': serializer.toJson<bool>(isMealCategory),
      'icon': serializer.toJson<String>(icon),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  Category copyWith({
    String? id,
    Value<String?> groupId = const Value.absent(),
    String? name,
    Value<String?> defaultKey = const Value.absent(),
    bool? isMealCategory,
    String? icon,
    int? updatedAt,
  }) => Category(
    id: id ?? this.id,
    groupId: groupId.present ? groupId.value : this.groupId,
    name: name ?? this.name,
    defaultKey: defaultKey.present ? defaultKey.value : this.defaultKey,
    isMealCategory: isMealCategory ?? this.isMealCategory,
    icon: icon ?? this.icon,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      name: data.name.present ? data.name.value : this.name,
      defaultKey: data.defaultKey.present
          ? data.defaultKey.value
          : this.defaultKey,
      isMealCategory: data.isMealCategory.present
          ? data.isMealCategory.value
          : this.isMealCategory,
      icon: data.icon.present ? data.icon.value : this.icon,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('name: $name, ')
          ..write('defaultKey: $defaultKey, ')
          ..write('isMealCategory: $isMealCategory, ')
          ..write('icon: $icon, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    groupId,
    name,
    defaultKey,
    isMealCategory,
    icon,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.name == this.name &&
          other.defaultKey == this.defaultKey &&
          other.isMealCategory == this.isMealCategory &&
          other.icon == this.icon &&
          other.updatedAt == this.updatedAt);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<String> id;
  final Value<String?> groupId;
  final Value<String> name;
  final Value<String?> defaultKey;
  final Value<bool> isMealCategory;
  final Value<String> icon;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.name = const Value.absent(),
    this.defaultKey = const Value.absent(),
    this.isMealCategory = const Value.absent(),
    this.icon = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    this.groupId = const Value.absent(),
    required String name,
    this.defaultKey = const Value.absent(),
    this.isMealCategory = const Value.absent(),
    required String icon,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       icon = Value(icon),
       updatedAt = Value(updatedAt);
  static Insertable<Category> custom({
    Expression<String>? id,
    Expression<String>? groupId,
    Expression<String>? name,
    Expression<String>? defaultKey,
    Expression<bool>? isMealCategory,
    Expression<String>? icon,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (name != null) 'name': name,
      if (defaultKey != null) 'default_key': defaultKey,
      if (isMealCategory != null) 'is_meal_category': isMealCategory,
      if (icon != null) 'icon': icon,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? id,
    Value<String?>? groupId,
    Value<String>? name,
    Value<String?>? defaultKey,
    Value<bool>? isMealCategory,
    Value<String>? icon,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      defaultKey: defaultKey ?? this.defaultKey,
      isMealCategory: isMealCategory ?? this.isMealCategory,
      icon: icon ?? this.icon,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (defaultKey.present) {
      map['default_key'] = Variable<String>(defaultKey.value);
    }
    if (isMealCategory.present) {
      map['is_meal_category'] = Variable<bool>(isMealCategory.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('name: $name, ')
          ..write('defaultKey: $defaultKey, ')
          ..write('isMealCategory: $isMealCategory, ')
          ..write('icon: $icon, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "groups" (id)',
    ),
  );
  static const VerificationMeta _amountPaisaMeta = const VerificationMeta(
    'amountPaisa',
  );
  @override
  late final GeneratedColumn<int> amountPaisa = GeneratedColumn<int>(
    'amount_paisa',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<int> date = GeneratedColumn<int>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _receiptPathMeta = const VerificationMeta(
    'receiptPath',
  );
  @override
  late final GeneratedColumn<String> receiptPath = GeneratedColumn<String>(
    'receipt_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isRecurringInstanceMeta =
      const VerificationMeta('isRecurringInstance');
  @override
  late final GeneratedColumn<bool> isRecurringInstance = GeneratedColumn<bool>(
    'is_recurring_instance',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_recurring_instance" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    groupId,
    amountPaisa,
    date,
    categoryId,
    note,
    receiptPath,
    isRecurringInstance,
    deleted,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Expense> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('amount_paisa')) {
      context.handle(
        _amountPaisaMeta,
        amountPaisa.isAcceptableOrUnknown(
          data['amount_paisa']!,
          _amountPaisaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountPaisaMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('receipt_path')) {
      context.handle(
        _receiptPathMeta,
        receiptPath.isAcceptableOrUnknown(
          data['receipt_path']!,
          _receiptPathMeta,
        ),
      );
    }
    if (data.containsKey('is_recurring_instance')) {
      context.handle(
        _isRecurringInstanceMeta,
        isRecurringInstance.isAcceptableOrUnknown(
          data['is_recurring_instance']!,
          _isRecurringInstanceMeta,
        ),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      amountPaisa: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_paisa'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      receiptPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_path'],
      ),
      isRecurringInstance: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_recurring_instance'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class Expense extends DataClass implements Insertable<Expense> {
  final String id;
  final String groupId;
  final int amountPaisa;
  final int date;
  final String categoryId;
  final String? note;
  final String? receiptPath;
  final bool isRecurringInstance;
  final bool deleted;
  final int updatedAt;
  const Expense({
    required this.id,
    required this.groupId,
    required this.amountPaisa,
    required this.date,
    required this.categoryId,
    this.note,
    this.receiptPath,
    required this.isRecurringInstance,
    required this.deleted,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['group_id'] = Variable<String>(groupId);
    map['amount_paisa'] = Variable<int>(amountPaisa);
    map['date'] = Variable<int>(date);
    map['category_id'] = Variable<String>(categoryId);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || receiptPath != null) {
      map['receipt_path'] = Variable<String>(receiptPath);
    }
    map['is_recurring_instance'] = Variable<bool>(isRecurringInstance);
    map['deleted'] = Variable<bool>(deleted);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      groupId: Value(groupId),
      amountPaisa: Value(amountPaisa),
      date: Value(date),
      categoryId: Value(categoryId),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      receiptPath: receiptPath == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptPath),
      isRecurringInstance: Value(isRecurringInstance),
      deleted: Value(deleted),
      updatedAt: Value(updatedAt),
    );
  }

  factory Expense.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<String>(json['id']),
      groupId: serializer.fromJson<String>(json['groupId']),
      amountPaisa: serializer.fromJson<int>(json['amountPaisa']),
      date: serializer.fromJson<int>(json['date']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      note: serializer.fromJson<String?>(json['note']),
      receiptPath: serializer.fromJson<String?>(json['receiptPath']),
      isRecurringInstance: serializer.fromJson<bool>(
        json['isRecurringInstance'],
      ),
      deleted: serializer.fromJson<bool>(json['deleted']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'groupId': serializer.toJson<String>(groupId),
      'amountPaisa': serializer.toJson<int>(amountPaisa),
      'date': serializer.toJson<int>(date),
      'categoryId': serializer.toJson<String>(categoryId),
      'note': serializer.toJson<String?>(note),
      'receiptPath': serializer.toJson<String?>(receiptPath),
      'isRecurringInstance': serializer.toJson<bool>(isRecurringInstance),
      'deleted': serializer.toJson<bool>(deleted),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  Expense copyWith({
    String? id,
    String? groupId,
    int? amountPaisa,
    int? date,
    String? categoryId,
    Value<String?> note = const Value.absent(),
    Value<String?> receiptPath = const Value.absent(),
    bool? isRecurringInstance,
    bool? deleted,
    int? updatedAt,
  }) => Expense(
    id: id ?? this.id,
    groupId: groupId ?? this.groupId,
    amountPaisa: amountPaisa ?? this.amountPaisa,
    date: date ?? this.date,
    categoryId: categoryId ?? this.categoryId,
    note: note.present ? note.value : this.note,
    receiptPath: receiptPath.present ? receiptPath.value : this.receiptPath,
    isRecurringInstance: isRecurringInstance ?? this.isRecurringInstance,
    deleted: deleted ?? this.deleted,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      amountPaisa: data.amountPaisa.present
          ? data.amountPaisa.value
          : this.amountPaisa,
      date: data.date.present ? data.date.value : this.date,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      note: data.note.present ? data.note.value : this.note,
      receiptPath: data.receiptPath.present
          ? data.receiptPath.value
          : this.receiptPath,
      isRecurringInstance: data.isRecurringInstance.present
          ? data.isRecurringInstance.value
          : this.isRecurringInstance,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('amountPaisa: $amountPaisa, ')
          ..write('date: $date, ')
          ..write('categoryId: $categoryId, ')
          ..write('note: $note, ')
          ..write('receiptPath: $receiptPath, ')
          ..write('isRecurringInstance: $isRecurringInstance, ')
          ..write('deleted: $deleted, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    groupId,
    amountPaisa,
    date,
    categoryId,
    note,
    receiptPath,
    isRecurringInstance,
    deleted,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.amountPaisa == this.amountPaisa &&
          other.date == this.date &&
          other.categoryId == this.categoryId &&
          other.note == this.note &&
          other.receiptPath == this.receiptPath &&
          other.isRecurringInstance == this.isRecurringInstance &&
          other.deleted == this.deleted &&
          other.updatedAt == this.updatedAt);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<String> id;
  final Value<String> groupId;
  final Value<int> amountPaisa;
  final Value<int> date;
  final Value<String> categoryId;
  final Value<String?> note;
  final Value<String?> receiptPath;
  final Value<bool> isRecurringInstance;
  final Value<bool> deleted;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.amountPaisa = const Value.absent(),
    this.date = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.note = const Value.absent(),
    this.receiptPath = const Value.absent(),
    this.isRecurringInstance = const Value.absent(),
    this.deleted = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpensesCompanion.insert({
    required String id,
    required String groupId,
    required int amountPaisa,
    required int date,
    required String categoryId,
    this.note = const Value.absent(),
    this.receiptPath = const Value.absent(),
    this.isRecurringInstance = const Value.absent(),
    this.deleted = const Value.absent(),
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       groupId = Value(groupId),
       amountPaisa = Value(amountPaisa),
       date = Value(date),
       categoryId = Value(categoryId),
       updatedAt = Value(updatedAt);
  static Insertable<Expense> custom({
    Expression<String>? id,
    Expression<String>? groupId,
    Expression<int>? amountPaisa,
    Expression<int>? date,
    Expression<String>? categoryId,
    Expression<String>? note,
    Expression<String>? receiptPath,
    Expression<bool>? isRecurringInstance,
    Expression<bool>? deleted,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (amountPaisa != null) 'amount_paisa': amountPaisa,
      if (date != null) 'date': date,
      if (categoryId != null) 'category_id': categoryId,
      if (note != null) 'note': note,
      if (receiptPath != null) 'receipt_path': receiptPath,
      if (isRecurringInstance != null)
        'is_recurring_instance': isRecurringInstance,
      if (deleted != null) 'deleted': deleted,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpensesCompanion copyWith({
    Value<String>? id,
    Value<String>? groupId,
    Value<int>? amountPaisa,
    Value<int>? date,
    Value<String>? categoryId,
    Value<String?>? note,
    Value<String?>? receiptPath,
    Value<bool>? isRecurringInstance,
    Value<bool>? deleted,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return ExpensesCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      amountPaisa: amountPaisa ?? this.amountPaisa,
      date: date ?? this.date,
      categoryId: categoryId ?? this.categoryId,
      note: note ?? this.note,
      receiptPath: receiptPath ?? this.receiptPath,
      isRecurringInstance: isRecurringInstance ?? this.isRecurringInstance,
      deleted: deleted ?? this.deleted,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (amountPaisa.present) {
      map['amount_paisa'] = Variable<int>(amountPaisa.value);
    }
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (receiptPath.present) {
      map['receipt_path'] = Variable<String>(receiptPath.value);
    }
    if (isRecurringInstance.present) {
      map['is_recurring_instance'] = Variable<bool>(isRecurringInstance.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('amountPaisa: $amountPaisa, ')
          ..write('date: $date, ')
          ..write('categoryId: $categoryId, ')
          ..write('note: $note, ')
          ..write('receiptPath: $receiptPath, ')
          ..write('isRecurringInstance: $isRecurringInstance, ')
          ..write('deleted: $deleted, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExpensePayersTable extends ExpensePayers
    with TableInfo<$ExpensePayersTable, ExpensePayer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensePayersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _expenseIdMeta = const VerificationMeta(
    'expenseId',
  );
  @override
  late final GeneratedColumn<String> expenseId = GeneratedColumn<String>(
    'expense_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES expenses (id)',
    ),
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
    'member_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES members (id)',
    ),
  );
  static const VerificationMeta _amountPaidPaisaMeta = const VerificationMeta(
    'amountPaidPaisa',
  );
  @override
  late final GeneratedColumn<int> amountPaidPaisa = GeneratedColumn<int>(
    'amount_paid_paisa',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [expenseId, memberId, amountPaidPaisa];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expense_payers';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExpensePayer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('expense_id')) {
      context.handle(
        _expenseIdMeta,
        expenseId.isAcceptableOrUnknown(data['expense_id']!, _expenseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_expenseIdMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('amount_paid_paisa')) {
      context.handle(
        _amountPaidPaisaMeta,
        amountPaidPaisa.isAcceptableOrUnknown(
          data['amount_paid_paisa']!,
          _amountPaidPaisaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountPaidPaisaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {expenseId, memberId};
  @override
  ExpensePayer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpensePayer(
      expenseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expense_id'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_id'],
      )!,
      amountPaidPaisa: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_paid_paisa'],
      )!,
    );
  }

  @override
  $ExpensePayersTable createAlias(String alias) {
    return $ExpensePayersTable(attachedDatabase, alias);
  }
}

class ExpensePayer extends DataClass implements Insertable<ExpensePayer> {
  final String expenseId;
  final String memberId;
  final int amountPaidPaisa;
  const ExpensePayer({
    required this.expenseId,
    required this.memberId,
    required this.amountPaidPaisa,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['expense_id'] = Variable<String>(expenseId);
    map['member_id'] = Variable<String>(memberId);
    map['amount_paid_paisa'] = Variable<int>(amountPaidPaisa);
    return map;
  }

  ExpensePayersCompanion toCompanion(bool nullToAbsent) {
    return ExpensePayersCompanion(
      expenseId: Value(expenseId),
      memberId: Value(memberId),
      amountPaidPaisa: Value(amountPaidPaisa),
    );
  }

  factory ExpensePayer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpensePayer(
      expenseId: serializer.fromJson<String>(json['expenseId']),
      memberId: serializer.fromJson<String>(json['memberId']),
      amountPaidPaisa: serializer.fromJson<int>(json['amountPaidPaisa']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'expenseId': serializer.toJson<String>(expenseId),
      'memberId': serializer.toJson<String>(memberId),
      'amountPaidPaisa': serializer.toJson<int>(amountPaidPaisa),
    };
  }

  ExpensePayer copyWith({
    String? expenseId,
    String? memberId,
    int? amountPaidPaisa,
  }) => ExpensePayer(
    expenseId: expenseId ?? this.expenseId,
    memberId: memberId ?? this.memberId,
    amountPaidPaisa: amountPaidPaisa ?? this.amountPaidPaisa,
  );
  ExpensePayer copyWithCompanion(ExpensePayersCompanion data) {
    return ExpensePayer(
      expenseId: data.expenseId.present ? data.expenseId.value : this.expenseId,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      amountPaidPaisa: data.amountPaidPaisa.present
          ? data.amountPaidPaisa.value
          : this.amountPaidPaisa,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpensePayer(')
          ..write('expenseId: $expenseId, ')
          ..write('memberId: $memberId, ')
          ..write('amountPaidPaisa: $amountPaidPaisa')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(expenseId, memberId, amountPaidPaisa);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpensePayer &&
          other.expenseId == this.expenseId &&
          other.memberId == this.memberId &&
          other.amountPaidPaisa == this.amountPaidPaisa);
}

class ExpensePayersCompanion extends UpdateCompanion<ExpensePayer> {
  final Value<String> expenseId;
  final Value<String> memberId;
  final Value<int> amountPaidPaisa;
  final Value<int> rowid;
  const ExpensePayersCompanion({
    this.expenseId = const Value.absent(),
    this.memberId = const Value.absent(),
    this.amountPaidPaisa = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpensePayersCompanion.insert({
    required String expenseId,
    required String memberId,
    required int amountPaidPaisa,
    this.rowid = const Value.absent(),
  }) : expenseId = Value(expenseId),
       memberId = Value(memberId),
       amountPaidPaisa = Value(amountPaidPaisa);
  static Insertable<ExpensePayer> custom({
    Expression<String>? expenseId,
    Expression<String>? memberId,
    Expression<int>? amountPaidPaisa,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (expenseId != null) 'expense_id': expenseId,
      if (memberId != null) 'member_id': memberId,
      if (amountPaidPaisa != null) 'amount_paid_paisa': amountPaidPaisa,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpensePayersCompanion copyWith({
    Value<String>? expenseId,
    Value<String>? memberId,
    Value<int>? amountPaidPaisa,
    Value<int>? rowid,
  }) {
    return ExpensePayersCompanion(
      expenseId: expenseId ?? this.expenseId,
      memberId: memberId ?? this.memberId,
      amountPaidPaisa: amountPaidPaisa ?? this.amountPaidPaisa,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (expenseId.present) {
      map['expense_id'] = Variable<String>(expenseId.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (amountPaidPaisa.present) {
      map['amount_paid_paisa'] = Variable<int>(amountPaidPaisa.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensePayersCompanion(')
          ..write('expenseId: $expenseId, ')
          ..write('memberId: $memberId, ')
          ..write('amountPaidPaisa: $amountPaidPaisa, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExpenseSplitsTable extends ExpenseSplits
    with TableInfo<$ExpenseSplitsTable, ExpenseSplit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpenseSplitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _expenseIdMeta = const VerificationMeta(
    'expenseId',
  );
  @override
  late final GeneratedColumn<String> expenseId = GeneratedColumn<String>(
    'expense_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES expenses (id)',
    ),
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
    'member_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES members (id)',
    ),
  );
  static const VerificationMeta _amountPaisaMeta = const VerificationMeta(
    'amountPaisa',
  );
  @override
  late final GeneratedColumn<int> amountPaisa = GeneratedColumn<int>(
    'amount_paisa',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _splitTypeMeta = const VerificationMeta(
    'splitType',
  );
  @override
  late final GeneratedColumn<String> splitType = GeneratedColumn<String>(
    'split_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    expenseId,
    memberId,
    amountPaisa,
    splitType,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expense_splits';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExpenseSplit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('expense_id')) {
      context.handle(
        _expenseIdMeta,
        expenseId.isAcceptableOrUnknown(data['expense_id']!, _expenseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_expenseIdMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('amount_paisa')) {
      context.handle(
        _amountPaisaMeta,
        amountPaisa.isAcceptableOrUnknown(
          data['amount_paisa']!,
          _amountPaisaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountPaisaMeta);
    }
    if (data.containsKey('split_type')) {
      context.handle(
        _splitTypeMeta,
        splitType.isAcceptableOrUnknown(data['split_type']!, _splitTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_splitTypeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {expenseId, memberId};
  @override
  ExpenseSplit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseSplit(
      expenseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expense_id'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_id'],
      )!,
      amountPaisa: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_paisa'],
      )!,
      splitType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}split_type'],
      )!,
    );
  }

  @override
  $ExpenseSplitsTable createAlias(String alias) {
    return $ExpenseSplitsTable(attachedDatabase, alias);
  }
}

class ExpenseSplit extends DataClass implements Insertable<ExpenseSplit> {
  final String expenseId;
  final String memberId;
  final int amountPaisa;
  final String splitType;
  const ExpenseSplit({
    required this.expenseId,
    required this.memberId,
    required this.amountPaisa,
    required this.splitType,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['expense_id'] = Variable<String>(expenseId);
    map['member_id'] = Variable<String>(memberId);
    map['amount_paisa'] = Variable<int>(amountPaisa);
    map['split_type'] = Variable<String>(splitType);
    return map;
  }

  ExpenseSplitsCompanion toCompanion(bool nullToAbsent) {
    return ExpenseSplitsCompanion(
      expenseId: Value(expenseId),
      memberId: Value(memberId),
      amountPaisa: Value(amountPaisa),
      splitType: Value(splitType),
    );
  }

  factory ExpenseSplit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseSplit(
      expenseId: serializer.fromJson<String>(json['expenseId']),
      memberId: serializer.fromJson<String>(json['memberId']),
      amountPaisa: serializer.fromJson<int>(json['amountPaisa']),
      splitType: serializer.fromJson<String>(json['splitType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'expenseId': serializer.toJson<String>(expenseId),
      'memberId': serializer.toJson<String>(memberId),
      'amountPaisa': serializer.toJson<int>(amountPaisa),
      'splitType': serializer.toJson<String>(splitType),
    };
  }

  ExpenseSplit copyWith({
    String? expenseId,
    String? memberId,
    int? amountPaisa,
    String? splitType,
  }) => ExpenseSplit(
    expenseId: expenseId ?? this.expenseId,
    memberId: memberId ?? this.memberId,
    amountPaisa: amountPaisa ?? this.amountPaisa,
    splitType: splitType ?? this.splitType,
  );
  ExpenseSplit copyWithCompanion(ExpenseSplitsCompanion data) {
    return ExpenseSplit(
      expenseId: data.expenseId.present ? data.expenseId.value : this.expenseId,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      amountPaisa: data.amountPaisa.present
          ? data.amountPaisa.value
          : this.amountPaisa,
      splitType: data.splitType.present ? data.splitType.value : this.splitType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseSplit(')
          ..write('expenseId: $expenseId, ')
          ..write('memberId: $memberId, ')
          ..write('amountPaisa: $amountPaisa, ')
          ..write('splitType: $splitType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(expenseId, memberId, amountPaisa, splitType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseSplit &&
          other.expenseId == this.expenseId &&
          other.memberId == this.memberId &&
          other.amountPaisa == this.amountPaisa &&
          other.splitType == this.splitType);
}

class ExpenseSplitsCompanion extends UpdateCompanion<ExpenseSplit> {
  final Value<String> expenseId;
  final Value<String> memberId;
  final Value<int> amountPaisa;
  final Value<String> splitType;
  final Value<int> rowid;
  const ExpenseSplitsCompanion({
    this.expenseId = const Value.absent(),
    this.memberId = const Value.absent(),
    this.amountPaisa = const Value.absent(),
    this.splitType = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpenseSplitsCompanion.insert({
    required String expenseId,
    required String memberId,
    required int amountPaisa,
    required String splitType,
    this.rowid = const Value.absent(),
  }) : expenseId = Value(expenseId),
       memberId = Value(memberId),
       amountPaisa = Value(amountPaisa),
       splitType = Value(splitType);
  static Insertable<ExpenseSplit> custom({
    Expression<String>? expenseId,
    Expression<String>? memberId,
    Expression<int>? amountPaisa,
    Expression<String>? splitType,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (expenseId != null) 'expense_id': expenseId,
      if (memberId != null) 'member_id': memberId,
      if (amountPaisa != null) 'amount_paisa': amountPaisa,
      if (splitType != null) 'split_type': splitType,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpenseSplitsCompanion copyWith({
    Value<String>? expenseId,
    Value<String>? memberId,
    Value<int>? amountPaisa,
    Value<String>? splitType,
    Value<int>? rowid,
  }) {
    return ExpenseSplitsCompanion(
      expenseId: expenseId ?? this.expenseId,
      memberId: memberId ?? this.memberId,
      amountPaisa: amountPaisa ?? this.amountPaisa,
      splitType: splitType ?? this.splitType,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (expenseId.present) {
      map['expense_id'] = Variable<String>(expenseId.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (amountPaisa.present) {
      map['amount_paisa'] = Variable<int>(amountPaisa.value);
    }
    if (splitType.present) {
      map['split_type'] = Variable<String>(splitType.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseSplitsCompanion(')
          ..write('expenseId: $expenseId, ')
          ..write('memberId: $memberId, ')
          ..write('amountPaisa: $amountPaisa, ')
          ..write('splitType: $splitType, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MealsTable extends Meals with TableInfo<$MealsTable, Meal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "groups" (id)',
    ),
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
    'member_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES members (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<int> date = GeneratedColumn<int>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<double> count = GeneratedColumn<double>(
    'count',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _guestCountMeta = const VerificationMeta(
    'guestCount',
  );
  @override
  late final GeneratedColumn<double> guestCount = GeneratedColumn<double>(
    'guest_count',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _slotsJsonMeta = const VerificationMeta(
    'slotsJson',
  );
  @override
  late final GeneratedColumn<String> slotsJson = GeneratedColumn<String>(
    'slots_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    groupId,
    memberId,
    date,
    count,
    guestCount,
    slotsJson,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meals';
  @override
  VerificationContext validateIntegrity(
    Insertable<Meal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
        _countMeta,
        count.isAcceptableOrUnknown(data['count']!, _countMeta),
      );
    }
    if (data.containsKey('guest_count')) {
      context.handle(
        _guestCountMeta,
        guestCount.isAcceptableOrUnknown(data['guest_count']!, _guestCountMeta),
      );
    }
    if (data.containsKey('slots_json')) {
      context.handle(
        _slotsJsonMeta,
        slotsJson.isAcceptableOrUnknown(data['slots_json']!, _slotsJsonMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Meal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Meal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date'],
      )!,
      count: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}count'],
      )!,
      guestCount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}guest_count'],
      )!,
      slotsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slots_json'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MealsTable createAlias(String alias) {
    return $MealsTable(attachedDatabase, alias);
  }
}

class Meal extends DataClass implements Insertable<Meal> {
  final String id;
  final String groupId;
  final String memberId;
  final int date;
  final double count;
  final double guestCount;
  final String? slotsJson;
  final int updatedAt;
  const Meal({
    required this.id,
    required this.groupId,
    required this.memberId,
    required this.date,
    required this.count,
    required this.guestCount,
    this.slotsJson,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['group_id'] = Variable<String>(groupId);
    map['member_id'] = Variable<String>(memberId);
    map['date'] = Variable<int>(date);
    map['count'] = Variable<double>(count);
    map['guest_count'] = Variable<double>(guestCount);
    if (!nullToAbsent || slotsJson != null) {
      map['slots_json'] = Variable<String>(slotsJson);
    }
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  MealsCompanion toCompanion(bool nullToAbsent) {
    return MealsCompanion(
      id: Value(id),
      groupId: Value(groupId),
      memberId: Value(memberId),
      date: Value(date),
      count: Value(count),
      guestCount: Value(guestCount),
      slotsJson: slotsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(slotsJson),
      updatedAt: Value(updatedAt),
    );
  }

  factory Meal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Meal(
      id: serializer.fromJson<String>(json['id']),
      groupId: serializer.fromJson<String>(json['groupId']),
      memberId: serializer.fromJson<String>(json['memberId']),
      date: serializer.fromJson<int>(json['date']),
      count: serializer.fromJson<double>(json['count']),
      guestCount: serializer.fromJson<double>(json['guestCount']),
      slotsJson: serializer.fromJson<String?>(json['slotsJson']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'groupId': serializer.toJson<String>(groupId),
      'memberId': serializer.toJson<String>(memberId),
      'date': serializer.toJson<int>(date),
      'count': serializer.toJson<double>(count),
      'guestCount': serializer.toJson<double>(guestCount),
      'slotsJson': serializer.toJson<String?>(slotsJson),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  Meal copyWith({
    String? id,
    String? groupId,
    String? memberId,
    int? date,
    double? count,
    double? guestCount,
    Value<String?> slotsJson = const Value.absent(),
    int? updatedAt,
  }) => Meal(
    id: id ?? this.id,
    groupId: groupId ?? this.groupId,
    memberId: memberId ?? this.memberId,
    date: date ?? this.date,
    count: count ?? this.count,
    guestCount: guestCount ?? this.guestCount,
    slotsJson: slotsJson.present ? slotsJson.value : this.slotsJson,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Meal copyWithCompanion(MealsCompanion data) {
    return Meal(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      date: data.date.present ? data.date.value : this.date,
      count: data.count.present ? data.count.value : this.count,
      guestCount: data.guestCount.present
          ? data.guestCount.value
          : this.guestCount,
      slotsJson: data.slotsJson.present ? data.slotsJson.value : this.slotsJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Meal(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('memberId: $memberId, ')
          ..write('date: $date, ')
          ..write('count: $count, ')
          ..write('guestCount: $guestCount, ')
          ..write('slotsJson: $slotsJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    groupId,
    memberId,
    date,
    count,
    guestCount,
    slotsJson,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Meal &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.memberId == this.memberId &&
          other.date == this.date &&
          other.count == this.count &&
          other.guestCount == this.guestCount &&
          other.slotsJson == this.slotsJson &&
          other.updatedAt == this.updatedAt);
}

class MealsCompanion extends UpdateCompanion<Meal> {
  final Value<String> id;
  final Value<String> groupId;
  final Value<String> memberId;
  final Value<int> date;
  final Value<double> count;
  final Value<double> guestCount;
  final Value<String?> slotsJson;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const MealsCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.memberId = const Value.absent(),
    this.date = const Value.absent(),
    this.count = const Value.absent(),
    this.guestCount = const Value.absent(),
    this.slotsJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MealsCompanion.insert({
    required String id,
    required String groupId,
    required String memberId,
    required int date,
    this.count = const Value.absent(),
    this.guestCount = const Value.absent(),
    this.slotsJson = const Value.absent(),
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       groupId = Value(groupId),
       memberId = Value(memberId),
       date = Value(date),
       updatedAt = Value(updatedAt);
  static Insertable<Meal> custom({
    Expression<String>? id,
    Expression<String>? groupId,
    Expression<String>? memberId,
    Expression<int>? date,
    Expression<double>? count,
    Expression<double>? guestCount,
    Expression<String>? slotsJson,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (memberId != null) 'member_id': memberId,
      if (date != null) 'date': date,
      if (count != null) 'count': count,
      if (guestCount != null) 'guest_count': guestCount,
      if (slotsJson != null) 'slots_json': slotsJson,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MealsCompanion copyWith({
    Value<String>? id,
    Value<String>? groupId,
    Value<String>? memberId,
    Value<int>? date,
    Value<double>? count,
    Value<double>? guestCount,
    Value<String?>? slotsJson,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return MealsCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      memberId: memberId ?? this.memberId,
      date: date ?? this.date,
      count: count ?? this.count,
      guestCount: guestCount ?? this.guestCount,
      slotsJson: slotsJson ?? this.slotsJson,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (count.present) {
      map['count'] = Variable<double>(count.value);
    }
    if (guestCount.present) {
      map['guest_count'] = Variable<double>(guestCount.value);
    }
    if (slotsJson.present) {
      map['slots_json'] = Variable<String>(slotsJson.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealsCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('memberId: $memberId, ')
          ..write('date: $date, ')
          ..write('count: $count, ')
          ..write('guestCount: $guestCount, ')
          ..write('slotsJson: $slotsJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DepositsTable extends Deposits with TableInfo<$DepositsTable, Deposit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DepositsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "groups" (id)',
    ),
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
    'member_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES members (id)',
    ),
  );
  static const VerificationMeta _amountPaisaMeta = const VerificationMeta(
    'amountPaisa',
  );
  @override
  late final GeneratedColumn<int> amountPaisa = GeneratedColumn<int>(
    'amount_paisa',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<int> date = GeneratedColumn<int>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purposeMeta = const VerificationMeta(
    'purpose',
  );
  @override
  late final GeneratedColumn<String> purpose = GeneratedColumn<String>(
    'purpose',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('general'),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    groupId,
    memberId,
    amountPaisa,
    date,
    note,
    purpose,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deposits';
  @override
  VerificationContext validateIntegrity(
    Insertable<Deposit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('amount_paisa')) {
      context.handle(
        _amountPaisaMeta,
        amountPaisa.isAcceptableOrUnknown(
          data['amount_paisa']!,
          _amountPaisaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountPaisaMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('purpose')) {
      context.handle(
        _purposeMeta,
        purpose.isAcceptableOrUnknown(data['purpose']!, _purposeMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Deposit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Deposit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_id'],
      )!,
      amountPaisa: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_paisa'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      purpose: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purpose'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DepositsTable createAlias(String alias) {
    return $DepositsTable(attachedDatabase, alias);
  }
}

class Deposit extends DataClass implements Insertable<Deposit> {
  final String id;
  final String groupId;
  final String memberId;
  final int amountPaisa;
  final int date;
  final String? note;
  final String purpose;
  final int updatedAt;
  const Deposit({
    required this.id,
    required this.groupId,
    required this.memberId,
    required this.amountPaisa,
    required this.date,
    this.note,
    required this.purpose,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['group_id'] = Variable<String>(groupId);
    map['member_id'] = Variable<String>(memberId);
    map['amount_paisa'] = Variable<int>(amountPaisa);
    map['date'] = Variable<int>(date);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['purpose'] = Variable<String>(purpose);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  DepositsCompanion toCompanion(bool nullToAbsent) {
    return DepositsCompanion(
      id: Value(id),
      groupId: Value(groupId),
      memberId: Value(memberId),
      amountPaisa: Value(amountPaisa),
      date: Value(date),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      purpose: Value(purpose),
      updatedAt: Value(updatedAt),
    );
  }

  factory Deposit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Deposit(
      id: serializer.fromJson<String>(json['id']),
      groupId: serializer.fromJson<String>(json['groupId']),
      memberId: serializer.fromJson<String>(json['memberId']),
      amountPaisa: serializer.fromJson<int>(json['amountPaisa']),
      date: serializer.fromJson<int>(json['date']),
      note: serializer.fromJson<String?>(json['note']),
      purpose: serializer.fromJson<String>(json['purpose']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'groupId': serializer.toJson<String>(groupId),
      'memberId': serializer.toJson<String>(memberId),
      'amountPaisa': serializer.toJson<int>(amountPaisa),
      'date': serializer.toJson<int>(date),
      'note': serializer.toJson<String?>(note),
      'purpose': serializer.toJson<String>(purpose),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  Deposit copyWith({
    String? id,
    String? groupId,
    String? memberId,
    int? amountPaisa,
    int? date,
    Value<String?> note = const Value.absent(),
    String? purpose,
    int? updatedAt,
  }) => Deposit(
    id: id ?? this.id,
    groupId: groupId ?? this.groupId,
    memberId: memberId ?? this.memberId,
    amountPaisa: amountPaisa ?? this.amountPaisa,
    date: date ?? this.date,
    note: note.present ? note.value : this.note,
    purpose: purpose ?? this.purpose,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Deposit copyWithCompanion(DepositsCompanion data) {
    return Deposit(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      amountPaisa: data.amountPaisa.present
          ? data.amountPaisa.value
          : this.amountPaisa,
      date: data.date.present ? data.date.value : this.date,
      note: data.note.present ? data.note.value : this.note,
      purpose: data.purpose.present ? data.purpose.value : this.purpose,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Deposit(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('memberId: $memberId, ')
          ..write('amountPaisa: $amountPaisa, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('purpose: $purpose, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    groupId,
    memberId,
    amountPaisa,
    date,
    note,
    purpose,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Deposit &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.memberId == this.memberId &&
          other.amountPaisa == this.amountPaisa &&
          other.date == this.date &&
          other.note == this.note &&
          other.purpose == this.purpose &&
          other.updatedAt == this.updatedAt);
}

class DepositsCompanion extends UpdateCompanion<Deposit> {
  final Value<String> id;
  final Value<String> groupId;
  final Value<String> memberId;
  final Value<int> amountPaisa;
  final Value<int> date;
  final Value<String?> note;
  final Value<String> purpose;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const DepositsCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.memberId = const Value.absent(),
    this.amountPaisa = const Value.absent(),
    this.date = const Value.absent(),
    this.note = const Value.absent(),
    this.purpose = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DepositsCompanion.insert({
    required String id,
    required String groupId,
    required String memberId,
    required int amountPaisa,
    required int date,
    this.note = const Value.absent(),
    this.purpose = const Value.absent(),
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       groupId = Value(groupId),
       memberId = Value(memberId),
       amountPaisa = Value(amountPaisa),
       date = Value(date),
       updatedAt = Value(updatedAt);
  static Insertable<Deposit> custom({
    Expression<String>? id,
    Expression<String>? groupId,
    Expression<String>? memberId,
    Expression<int>? amountPaisa,
    Expression<int>? date,
    Expression<String>? note,
    Expression<String>? purpose,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (memberId != null) 'member_id': memberId,
      if (amountPaisa != null) 'amount_paisa': amountPaisa,
      if (date != null) 'date': date,
      if (note != null) 'note': note,
      if (purpose != null) 'purpose': purpose,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DepositsCompanion copyWith({
    Value<String>? id,
    Value<String>? groupId,
    Value<String>? memberId,
    Value<int>? amountPaisa,
    Value<int>? date,
    Value<String?>? note,
    Value<String>? purpose,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return DepositsCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      memberId: memberId ?? this.memberId,
      amountPaisa: amountPaisa ?? this.amountPaisa,
      date: date ?? this.date,
      note: note ?? this.note,
      purpose: purpose ?? this.purpose,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (amountPaisa.present) {
      map['amount_paisa'] = Variable<int>(amountPaisa.value);
    }
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (purpose.present) {
      map['purpose'] = Variable<String>(purpose.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DepositsCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('memberId: $memberId, ')
          ..write('amountPaisa: $amountPaisa, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('purpose: $purpose, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettlementsTable extends Settlements
    with TableInfo<$SettlementsTable, Settlement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettlementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "groups" (id)',
    ),
  );
  static const VerificationMeta _fromMemberIdMeta = const VerificationMeta(
    'fromMemberId',
  );
  @override
  late final GeneratedColumn<String> fromMemberId = GeneratedColumn<String>(
    'from_member_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES members (id)',
    ),
  );
  static const VerificationMeta _toMemberIdMeta = const VerificationMeta(
    'toMemberId',
  );
  @override
  late final GeneratedColumn<String> toMemberId = GeneratedColumn<String>(
    'to_member_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES members (id)',
    ),
  );
  static const VerificationMeta _amountPaisaMeta = const VerificationMeta(
    'amountPaisa',
  );
  @override
  late final GeneratedColumn<int> amountPaisa = GeneratedColumn<int>(
    'amount_paisa',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<int> date = GeneratedColumn<int>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purposeMeta = const VerificationMeta(
    'purpose',
  );
  @override
  late final GeneratedColumn<String> purpose = GeneratedColumn<String>(
    'purpose',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('general'),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    groupId,
    fromMemberId,
    toMemberId,
    amountPaisa,
    date,
    method,
    note,
    purpose,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settlements';
  @override
  VerificationContext validateIntegrity(
    Insertable<Settlement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('from_member_id')) {
      context.handle(
        _fromMemberIdMeta,
        fromMemberId.isAcceptableOrUnknown(
          data['from_member_id']!,
          _fromMemberIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fromMemberIdMeta);
    }
    if (data.containsKey('to_member_id')) {
      context.handle(
        _toMemberIdMeta,
        toMemberId.isAcceptableOrUnknown(
          data['to_member_id']!,
          _toMemberIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_toMemberIdMeta);
    }
    if (data.containsKey('amount_paisa')) {
      context.handle(
        _amountPaisaMeta,
        amountPaisa.isAcceptableOrUnknown(
          data['amount_paisa']!,
          _amountPaisaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountPaisaMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('purpose')) {
      context.handle(
        _purposeMeta,
        purpose.isAcceptableOrUnknown(data['purpose']!, _purposeMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Settlement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Settlement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      fromMemberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_member_id'],
      )!,
      toMemberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_member_id'],
      )!,
      amountPaisa: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_paisa'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      purpose: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purpose'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SettlementsTable createAlias(String alias) {
    return $SettlementsTable(attachedDatabase, alias);
  }
}

class Settlement extends DataClass implements Insertable<Settlement> {
  final String id;
  final String groupId;
  final String fromMemberId;
  final String toMemberId;
  final int amountPaisa;
  final int date;
  final String? method;
  final String? note;
  final String purpose;
  final int updatedAt;
  const Settlement({
    required this.id,
    required this.groupId,
    required this.fromMemberId,
    required this.toMemberId,
    required this.amountPaisa,
    required this.date,
    this.method,
    this.note,
    required this.purpose,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['group_id'] = Variable<String>(groupId);
    map['from_member_id'] = Variable<String>(fromMemberId);
    map['to_member_id'] = Variable<String>(toMemberId);
    map['amount_paisa'] = Variable<int>(amountPaisa);
    map['date'] = Variable<int>(date);
    if (!nullToAbsent || method != null) {
      map['method'] = Variable<String>(method);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['purpose'] = Variable<String>(purpose);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  SettlementsCompanion toCompanion(bool nullToAbsent) {
    return SettlementsCompanion(
      id: Value(id),
      groupId: Value(groupId),
      fromMemberId: Value(fromMemberId),
      toMemberId: Value(toMemberId),
      amountPaisa: Value(amountPaisa),
      date: Value(date),
      method: method == null && nullToAbsent
          ? const Value.absent()
          : Value(method),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      purpose: Value(purpose),
      updatedAt: Value(updatedAt),
    );
  }

  factory Settlement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Settlement(
      id: serializer.fromJson<String>(json['id']),
      groupId: serializer.fromJson<String>(json['groupId']),
      fromMemberId: serializer.fromJson<String>(json['fromMemberId']),
      toMemberId: serializer.fromJson<String>(json['toMemberId']),
      amountPaisa: serializer.fromJson<int>(json['amountPaisa']),
      date: serializer.fromJson<int>(json['date']),
      method: serializer.fromJson<String?>(json['method']),
      note: serializer.fromJson<String?>(json['note']),
      purpose: serializer.fromJson<String>(json['purpose']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'groupId': serializer.toJson<String>(groupId),
      'fromMemberId': serializer.toJson<String>(fromMemberId),
      'toMemberId': serializer.toJson<String>(toMemberId),
      'amountPaisa': serializer.toJson<int>(amountPaisa),
      'date': serializer.toJson<int>(date),
      'method': serializer.toJson<String?>(method),
      'note': serializer.toJson<String?>(note),
      'purpose': serializer.toJson<String>(purpose),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  Settlement copyWith({
    String? id,
    String? groupId,
    String? fromMemberId,
    String? toMemberId,
    int? amountPaisa,
    int? date,
    Value<String?> method = const Value.absent(),
    Value<String?> note = const Value.absent(),
    String? purpose,
    int? updatedAt,
  }) => Settlement(
    id: id ?? this.id,
    groupId: groupId ?? this.groupId,
    fromMemberId: fromMemberId ?? this.fromMemberId,
    toMemberId: toMemberId ?? this.toMemberId,
    amountPaisa: amountPaisa ?? this.amountPaisa,
    date: date ?? this.date,
    method: method.present ? method.value : this.method,
    note: note.present ? note.value : this.note,
    purpose: purpose ?? this.purpose,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Settlement copyWithCompanion(SettlementsCompanion data) {
    return Settlement(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      fromMemberId: data.fromMemberId.present
          ? data.fromMemberId.value
          : this.fromMemberId,
      toMemberId: data.toMemberId.present
          ? data.toMemberId.value
          : this.toMemberId,
      amountPaisa: data.amountPaisa.present
          ? data.amountPaisa.value
          : this.amountPaisa,
      date: data.date.present ? data.date.value : this.date,
      method: data.method.present ? data.method.value : this.method,
      note: data.note.present ? data.note.value : this.note,
      purpose: data.purpose.present ? data.purpose.value : this.purpose,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Settlement(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('fromMemberId: $fromMemberId, ')
          ..write('toMemberId: $toMemberId, ')
          ..write('amountPaisa: $amountPaisa, ')
          ..write('date: $date, ')
          ..write('method: $method, ')
          ..write('note: $note, ')
          ..write('purpose: $purpose, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    groupId,
    fromMemberId,
    toMemberId,
    amountPaisa,
    date,
    method,
    note,
    purpose,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Settlement &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.fromMemberId == this.fromMemberId &&
          other.toMemberId == this.toMemberId &&
          other.amountPaisa == this.amountPaisa &&
          other.date == this.date &&
          other.method == this.method &&
          other.note == this.note &&
          other.purpose == this.purpose &&
          other.updatedAt == this.updatedAt);
}

class SettlementsCompanion extends UpdateCompanion<Settlement> {
  final Value<String> id;
  final Value<String> groupId;
  final Value<String> fromMemberId;
  final Value<String> toMemberId;
  final Value<int> amountPaisa;
  final Value<int> date;
  final Value<String?> method;
  final Value<String?> note;
  final Value<String> purpose;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const SettlementsCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.fromMemberId = const Value.absent(),
    this.toMemberId = const Value.absent(),
    this.amountPaisa = const Value.absent(),
    this.date = const Value.absent(),
    this.method = const Value.absent(),
    this.note = const Value.absent(),
    this.purpose = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettlementsCompanion.insert({
    required String id,
    required String groupId,
    required String fromMemberId,
    required String toMemberId,
    required int amountPaisa,
    required int date,
    this.method = const Value.absent(),
    this.note = const Value.absent(),
    this.purpose = const Value.absent(),
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       groupId = Value(groupId),
       fromMemberId = Value(fromMemberId),
       toMemberId = Value(toMemberId),
       amountPaisa = Value(amountPaisa),
       date = Value(date),
       updatedAt = Value(updatedAt);
  static Insertable<Settlement> custom({
    Expression<String>? id,
    Expression<String>? groupId,
    Expression<String>? fromMemberId,
    Expression<String>? toMemberId,
    Expression<int>? amountPaisa,
    Expression<int>? date,
    Expression<String>? method,
    Expression<String>? note,
    Expression<String>? purpose,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (fromMemberId != null) 'from_member_id': fromMemberId,
      if (toMemberId != null) 'to_member_id': toMemberId,
      if (amountPaisa != null) 'amount_paisa': amountPaisa,
      if (date != null) 'date': date,
      if (method != null) 'method': method,
      if (note != null) 'note': note,
      if (purpose != null) 'purpose': purpose,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettlementsCompanion copyWith({
    Value<String>? id,
    Value<String>? groupId,
    Value<String>? fromMemberId,
    Value<String>? toMemberId,
    Value<int>? amountPaisa,
    Value<int>? date,
    Value<String?>? method,
    Value<String?>? note,
    Value<String>? purpose,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return SettlementsCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      fromMemberId: fromMemberId ?? this.fromMemberId,
      toMemberId: toMemberId ?? this.toMemberId,
      amountPaisa: amountPaisa ?? this.amountPaisa,
      date: date ?? this.date,
      method: method ?? this.method,
      note: note ?? this.note,
      purpose: purpose ?? this.purpose,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (fromMemberId.present) {
      map['from_member_id'] = Variable<String>(fromMemberId.value);
    }
    if (toMemberId.present) {
      map['to_member_id'] = Variable<String>(toMemberId.value);
    }
    if (amountPaisa.present) {
      map['amount_paisa'] = Variable<int>(amountPaisa.value);
    }
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (purpose.present) {
      map['purpose'] = Variable<String>(purpose.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettlementsCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('fromMemberId: $fromMemberId, ')
          ..write('toMemberId: $toMemberId, ')
          ..write('amountPaisa: $amountPaisa, ')
          ..write('date: $date, ')
          ..write('method: $method, ')
          ..write('note: $note, ')
          ..write('purpose: $purpose, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MonthsTable extends Months with TableInfo<$MonthsTable, Month> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MonthsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "groups" (id)',
    ),
  );
  static const VerificationMeta _yearMonthMeta = const VerificationMeta(
    'yearMonth',
  );
  @override
  late final GeneratedColumn<String> yearMonth = GeneratedColumn<String>(
    'year_month',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _closedAtMeta = const VerificationMeta(
    'closedAt',
  );
  @override
  late final GeneratedColumn<int> closedAt = GeneratedColumn<int>(
    'closed_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mealRatePaisaMeta = const VerificationMeta(
    'mealRatePaisa',
  );
  @override
  late final GeneratedColumn<int> mealRatePaisa = GeneratedColumn<int>(
    'meal_rate_paisa',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _snapshotJsonMeta = const VerificationMeta(
    'snapshotJson',
  );
  @override
  late final GeneratedColumn<String> snapshotJson = GeneratedColumn<String>(
    'snapshot_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mealClosedAtMeta = const VerificationMeta(
    'mealClosedAt',
  );
  @override
  late final GeneratedColumn<int> mealClosedAt = GeneratedColumn<int>(
    'meal_closed_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mealSnapshotJsonMeta = const VerificationMeta(
    'mealSnapshotJson',
  );
  @override
  late final GeneratedColumn<String> mealSnapshotJson = GeneratedColumn<String>(
    'meal_snapshot_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    groupId,
    yearMonth,
    closedAt,
    mealRatePaisa,
    snapshotJson,
    mealClosedAt,
    mealSnapshotJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'months';
  @override
  VerificationContext validateIntegrity(
    Insertable<Month> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('year_month')) {
      context.handle(
        _yearMonthMeta,
        yearMonth.isAcceptableOrUnknown(data['year_month']!, _yearMonthMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMonthMeta);
    }
    if (data.containsKey('closed_at')) {
      context.handle(
        _closedAtMeta,
        closedAt.isAcceptableOrUnknown(data['closed_at']!, _closedAtMeta),
      );
    }
    if (data.containsKey('meal_rate_paisa')) {
      context.handle(
        _mealRatePaisaMeta,
        mealRatePaisa.isAcceptableOrUnknown(
          data['meal_rate_paisa']!,
          _mealRatePaisaMeta,
        ),
      );
    }
    if (data.containsKey('snapshot_json')) {
      context.handle(
        _snapshotJsonMeta,
        snapshotJson.isAcceptableOrUnknown(
          data['snapshot_json']!,
          _snapshotJsonMeta,
        ),
      );
    }
    if (data.containsKey('meal_closed_at')) {
      context.handle(
        _mealClosedAtMeta,
        mealClosedAt.isAcceptableOrUnknown(
          data['meal_closed_at']!,
          _mealClosedAtMeta,
        ),
      );
    }
    if (data.containsKey('meal_snapshot_json')) {
      context.handle(
        _mealSnapshotJsonMeta,
        mealSnapshotJson.isAcceptableOrUnknown(
          data['meal_snapshot_json']!,
          _mealSnapshotJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Month map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Month(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      yearMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}year_month'],
      )!,
      closedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}closed_at'],
      ),
      mealRatePaisa: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}meal_rate_paisa'],
      ),
      snapshotJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}snapshot_json'],
      ),
      mealClosedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}meal_closed_at'],
      ),
      mealSnapshotJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_snapshot_json'],
      ),
    );
  }

  @override
  $MonthsTable createAlias(String alias) {
    return $MonthsTable(attachedDatabase, alias);
  }
}

class Month extends DataClass implements Insertable<Month> {
  final String id;
  final String groupId;
  final String yearMonth;
  final int? closedAt;
  final int? mealRatePaisa;
  final String? snapshotJson;
  final int? mealClosedAt;
  final String? mealSnapshotJson;
  const Month({
    required this.id,
    required this.groupId,
    required this.yearMonth,
    this.closedAt,
    this.mealRatePaisa,
    this.snapshotJson,
    this.mealClosedAt,
    this.mealSnapshotJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['group_id'] = Variable<String>(groupId);
    map['year_month'] = Variable<String>(yearMonth);
    if (!nullToAbsent || closedAt != null) {
      map['closed_at'] = Variable<int>(closedAt);
    }
    if (!nullToAbsent || mealRatePaisa != null) {
      map['meal_rate_paisa'] = Variable<int>(mealRatePaisa);
    }
    if (!nullToAbsent || snapshotJson != null) {
      map['snapshot_json'] = Variable<String>(snapshotJson);
    }
    if (!nullToAbsent || mealClosedAt != null) {
      map['meal_closed_at'] = Variable<int>(mealClosedAt);
    }
    if (!nullToAbsent || mealSnapshotJson != null) {
      map['meal_snapshot_json'] = Variable<String>(mealSnapshotJson);
    }
    return map;
  }

  MonthsCompanion toCompanion(bool nullToAbsent) {
    return MonthsCompanion(
      id: Value(id),
      groupId: Value(groupId),
      yearMonth: Value(yearMonth),
      closedAt: closedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(closedAt),
      mealRatePaisa: mealRatePaisa == null && nullToAbsent
          ? const Value.absent()
          : Value(mealRatePaisa),
      snapshotJson: snapshotJson == null && nullToAbsent
          ? const Value.absent()
          : Value(snapshotJson),
      mealClosedAt: mealClosedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(mealClosedAt),
      mealSnapshotJson: mealSnapshotJson == null && nullToAbsent
          ? const Value.absent()
          : Value(mealSnapshotJson),
    );
  }

  factory Month.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Month(
      id: serializer.fromJson<String>(json['id']),
      groupId: serializer.fromJson<String>(json['groupId']),
      yearMonth: serializer.fromJson<String>(json['yearMonth']),
      closedAt: serializer.fromJson<int?>(json['closedAt']),
      mealRatePaisa: serializer.fromJson<int?>(json['mealRatePaisa']),
      snapshotJson: serializer.fromJson<String?>(json['snapshotJson']),
      mealClosedAt: serializer.fromJson<int?>(json['mealClosedAt']),
      mealSnapshotJson: serializer.fromJson<String?>(json['mealSnapshotJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'groupId': serializer.toJson<String>(groupId),
      'yearMonth': serializer.toJson<String>(yearMonth),
      'closedAt': serializer.toJson<int?>(closedAt),
      'mealRatePaisa': serializer.toJson<int?>(mealRatePaisa),
      'snapshotJson': serializer.toJson<String?>(snapshotJson),
      'mealClosedAt': serializer.toJson<int?>(mealClosedAt),
      'mealSnapshotJson': serializer.toJson<String?>(mealSnapshotJson),
    };
  }

  Month copyWith({
    String? id,
    String? groupId,
    String? yearMonth,
    Value<int?> closedAt = const Value.absent(),
    Value<int?> mealRatePaisa = const Value.absent(),
    Value<String?> snapshotJson = const Value.absent(),
    Value<int?> mealClosedAt = const Value.absent(),
    Value<String?> mealSnapshotJson = const Value.absent(),
  }) => Month(
    id: id ?? this.id,
    groupId: groupId ?? this.groupId,
    yearMonth: yearMonth ?? this.yearMonth,
    closedAt: closedAt.present ? closedAt.value : this.closedAt,
    mealRatePaisa: mealRatePaisa.present
        ? mealRatePaisa.value
        : this.mealRatePaisa,
    snapshotJson: snapshotJson.present ? snapshotJson.value : this.snapshotJson,
    mealClosedAt: mealClosedAt.present ? mealClosedAt.value : this.mealClosedAt,
    mealSnapshotJson: mealSnapshotJson.present
        ? mealSnapshotJson.value
        : this.mealSnapshotJson,
  );
  Month copyWithCompanion(MonthsCompanion data) {
    return Month(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      yearMonth: data.yearMonth.present ? data.yearMonth.value : this.yearMonth,
      closedAt: data.closedAt.present ? data.closedAt.value : this.closedAt,
      mealRatePaisa: data.mealRatePaisa.present
          ? data.mealRatePaisa.value
          : this.mealRatePaisa,
      snapshotJson: data.snapshotJson.present
          ? data.snapshotJson.value
          : this.snapshotJson,
      mealClosedAt: data.mealClosedAt.present
          ? data.mealClosedAt.value
          : this.mealClosedAt,
      mealSnapshotJson: data.mealSnapshotJson.present
          ? data.mealSnapshotJson.value
          : this.mealSnapshotJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Month(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('yearMonth: $yearMonth, ')
          ..write('closedAt: $closedAt, ')
          ..write('mealRatePaisa: $mealRatePaisa, ')
          ..write('snapshotJson: $snapshotJson, ')
          ..write('mealClosedAt: $mealClosedAt, ')
          ..write('mealSnapshotJson: $mealSnapshotJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    groupId,
    yearMonth,
    closedAt,
    mealRatePaisa,
    snapshotJson,
    mealClosedAt,
    mealSnapshotJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Month &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.yearMonth == this.yearMonth &&
          other.closedAt == this.closedAt &&
          other.mealRatePaisa == this.mealRatePaisa &&
          other.snapshotJson == this.snapshotJson &&
          other.mealClosedAt == this.mealClosedAt &&
          other.mealSnapshotJson == this.mealSnapshotJson);
}

class MonthsCompanion extends UpdateCompanion<Month> {
  final Value<String> id;
  final Value<String> groupId;
  final Value<String> yearMonth;
  final Value<int?> closedAt;
  final Value<int?> mealRatePaisa;
  final Value<String?> snapshotJson;
  final Value<int?> mealClosedAt;
  final Value<String?> mealSnapshotJson;
  final Value<int> rowid;
  const MonthsCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.yearMonth = const Value.absent(),
    this.closedAt = const Value.absent(),
    this.mealRatePaisa = const Value.absent(),
    this.snapshotJson = const Value.absent(),
    this.mealClosedAt = const Value.absent(),
    this.mealSnapshotJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MonthsCompanion.insert({
    required String id,
    required String groupId,
    required String yearMonth,
    this.closedAt = const Value.absent(),
    this.mealRatePaisa = const Value.absent(),
    this.snapshotJson = const Value.absent(),
    this.mealClosedAt = const Value.absent(),
    this.mealSnapshotJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       groupId = Value(groupId),
       yearMonth = Value(yearMonth);
  static Insertable<Month> custom({
    Expression<String>? id,
    Expression<String>? groupId,
    Expression<String>? yearMonth,
    Expression<int>? closedAt,
    Expression<int>? mealRatePaisa,
    Expression<String>? snapshotJson,
    Expression<int>? mealClosedAt,
    Expression<String>? mealSnapshotJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (yearMonth != null) 'year_month': yearMonth,
      if (closedAt != null) 'closed_at': closedAt,
      if (mealRatePaisa != null) 'meal_rate_paisa': mealRatePaisa,
      if (snapshotJson != null) 'snapshot_json': snapshotJson,
      if (mealClosedAt != null) 'meal_closed_at': mealClosedAt,
      if (mealSnapshotJson != null) 'meal_snapshot_json': mealSnapshotJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MonthsCompanion copyWith({
    Value<String>? id,
    Value<String>? groupId,
    Value<String>? yearMonth,
    Value<int?>? closedAt,
    Value<int?>? mealRatePaisa,
    Value<String?>? snapshotJson,
    Value<int?>? mealClosedAt,
    Value<String?>? mealSnapshotJson,
    Value<int>? rowid,
  }) {
    return MonthsCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      yearMonth: yearMonth ?? this.yearMonth,
      closedAt: closedAt ?? this.closedAt,
      mealRatePaisa: mealRatePaisa ?? this.mealRatePaisa,
      snapshotJson: snapshotJson ?? this.snapshotJson,
      mealClosedAt: mealClosedAt ?? this.mealClosedAt,
      mealSnapshotJson: mealSnapshotJson ?? this.mealSnapshotJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (yearMonth.present) {
      map['year_month'] = Variable<String>(yearMonth.value);
    }
    if (closedAt.present) {
      map['closed_at'] = Variable<int>(closedAt.value);
    }
    if (mealRatePaisa.present) {
      map['meal_rate_paisa'] = Variable<int>(mealRatePaisa.value);
    }
    if (snapshotJson.present) {
      map['snapshot_json'] = Variable<String>(snapshotJson.value);
    }
    if (mealClosedAt.present) {
      map['meal_closed_at'] = Variable<int>(mealClosedAt.value);
    }
    if (mealSnapshotJson.present) {
      map['meal_snapshot_json'] = Variable<String>(mealSnapshotJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MonthsCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('yearMonth: $yearMonth, ')
          ..write('closedAt: $closedAt, ')
          ..write('mealRatePaisa: $mealRatePaisa, ')
          ..write('snapshotJson: $snapshotJson, ')
          ..write('mealClosedAt: $mealClosedAt, ')
          ..write('mealSnapshotJson: $mealSnapshotJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecurringRulesTable extends RecurringRules
    with TableInfo<$RecurringRulesTable, RecurringRule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurringRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "groups" (id)',
    ),
  );
  static const VerificationMeta _templateJsonMeta = const VerificationMeta(
    'templateJson',
  );
  @override
  late final GeneratedColumn<String> templateJson = GeneratedColumn<String>(
    'template_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayOfMonthMeta = const VerificationMeta(
    'dayOfMonth',
  );
  @override
  late final GeneratedColumn<int> dayOfMonth = GeneratedColumn<int>(
    'day_of_month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    groupId,
    templateJson,
    dayOfMonth,
    active,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurring_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecurringRule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('template_json')) {
      context.handle(
        _templateJsonMeta,
        templateJson.isAcceptableOrUnknown(
          data['template_json']!,
          _templateJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_templateJsonMeta);
    }
    if (data.containsKey('day_of_month')) {
      context.handle(
        _dayOfMonthMeta,
        dayOfMonth.isAcceptableOrUnknown(
          data['day_of_month']!,
          _dayOfMonthMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dayOfMonthMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecurringRule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurringRule(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      templateJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_json'],
      )!,
      dayOfMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_of_month'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RecurringRulesTable createAlias(String alias) {
    return $RecurringRulesTable(attachedDatabase, alias);
  }
}

class RecurringRule extends DataClass implements Insertable<RecurringRule> {
  final String id;
  final String groupId;
  final String templateJson;
  final int dayOfMonth;
  final bool active;
  final int updatedAt;
  const RecurringRule({
    required this.id,
    required this.groupId,
    required this.templateJson,
    required this.dayOfMonth,
    required this.active,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['group_id'] = Variable<String>(groupId);
    map['template_json'] = Variable<String>(templateJson);
    map['day_of_month'] = Variable<int>(dayOfMonth);
    map['active'] = Variable<bool>(active);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  RecurringRulesCompanion toCompanion(bool nullToAbsent) {
    return RecurringRulesCompanion(
      id: Value(id),
      groupId: Value(groupId),
      templateJson: Value(templateJson),
      dayOfMonth: Value(dayOfMonth),
      active: Value(active),
      updatedAt: Value(updatedAt),
    );
  }

  factory RecurringRule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurringRule(
      id: serializer.fromJson<String>(json['id']),
      groupId: serializer.fromJson<String>(json['groupId']),
      templateJson: serializer.fromJson<String>(json['templateJson']),
      dayOfMonth: serializer.fromJson<int>(json['dayOfMonth']),
      active: serializer.fromJson<bool>(json['active']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'groupId': serializer.toJson<String>(groupId),
      'templateJson': serializer.toJson<String>(templateJson),
      'dayOfMonth': serializer.toJson<int>(dayOfMonth),
      'active': serializer.toJson<bool>(active),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  RecurringRule copyWith({
    String? id,
    String? groupId,
    String? templateJson,
    int? dayOfMonth,
    bool? active,
    int? updatedAt,
  }) => RecurringRule(
    id: id ?? this.id,
    groupId: groupId ?? this.groupId,
    templateJson: templateJson ?? this.templateJson,
    dayOfMonth: dayOfMonth ?? this.dayOfMonth,
    active: active ?? this.active,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RecurringRule copyWithCompanion(RecurringRulesCompanion data) {
    return RecurringRule(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      templateJson: data.templateJson.present
          ? data.templateJson.value
          : this.templateJson,
      dayOfMonth: data.dayOfMonth.present
          ? data.dayOfMonth.value
          : this.dayOfMonth,
      active: data.active.present ? data.active.value : this.active,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurringRule(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('templateJson: $templateJson, ')
          ..write('dayOfMonth: $dayOfMonth, ')
          ..write('active: $active, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, groupId, templateJson, dayOfMonth, active, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurringRule &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.templateJson == this.templateJson &&
          other.dayOfMonth == this.dayOfMonth &&
          other.active == this.active &&
          other.updatedAt == this.updatedAt);
}

class RecurringRulesCompanion extends UpdateCompanion<RecurringRule> {
  final Value<String> id;
  final Value<String> groupId;
  final Value<String> templateJson;
  final Value<int> dayOfMonth;
  final Value<bool> active;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const RecurringRulesCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.templateJson = const Value.absent(),
    this.dayOfMonth = const Value.absent(),
    this.active = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecurringRulesCompanion.insert({
    required String id,
    required String groupId,
    required String templateJson,
    required int dayOfMonth,
    this.active = const Value.absent(),
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       groupId = Value(groupId),
       templateJson = Value(templateJson),
       dayOfMonth = Value(dayOfMonth),
       updatedAt = Value(updatedAt);
  static Insertable<RecurringRule> custom({
    Expression<String>? id,
    Expression<String>? groupId,
    Expression<String>? templateJson,
    Expression<int>? dayOfMonth,
    Expression<bool>? active,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (templateJson != null) 'template_json': templateJson,
      if (dayOfMonth != null) 'day_of_month': dayOfMonth,
      if (active != null) 'active': active,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecurringRulesCompanion copyWith({
    Value<String>? id,
    Value<String>? groupId,
    Value<String>? templateJson,
    Value<int>? dayOfMonth,
    Value<bool>? active,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return RecurringRulesCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      templateJson: templateJson ?? this.templateJson,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      active: active ?? this.active,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (templateJson.present) {
      map['template_json'] = Variable<String>(templateJson.value);
    }
    if (dayOfMonth.present) {
      map['day_of_month'] = Variable<int>(dayOfMonth.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurringRulesCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('templateJson: $templateJson, ')
          ..write('dayOfMonth: $dayOfMonth, ')
          ..write('active: $active, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MealPollsTable extends MealPolls
    with TableInfo<$MealPollsTable, MealPoll> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealPollsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "groups" (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<int> date = GeneratedColumn<int>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _optionsJsonMeta = const VerificationMeta(
    'optionsJson',
  );
  @override
  late final GeneratedColumn<String> optionsJson = GeneratedColumn<String>(
    'options_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _closeAtMeta = const VerificationMeta(
    'closeAt',
  );
  @override
  late final GeneratedColumn<int> closeAt = GeneratedColumn<int>(
    'close_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByMemberIdMeta = const VerificationMeta(
    'createdByMemberId',
  );
  @override
  late final GeneratedColumn<String> createdByMemberId =
      GeneratedColumn<String>(
        'created_by_member_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES members (id)',
        ),
      );
  static const VerificationMeta _nonVoterPolicyMeta = const VerificationMeta(
    'nonVoterPolicy',
  );
  @override
  late final GeneratedColumn<String> nonVoterPolicy = GeneratedColumn<String>(
    'non_voter_policy',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _closedMeta = const VerificationMeta('closed');
  @override
  late final GeneratedColumn<bool> closed = GeneratedColumn<bool>(
    'closed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("closed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    groupId,
    date,
    type,
    title,
    optionsJson,
    closeAt,
    createdByMemberId,
    nonVoterPolicy,
    closed,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_polls';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealPoll> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('options_json')) {
      context.handle(
        _optionsJsonMeta,
        optionsJson.isAcceptableOrUnknown(
          data['options_json']!,
          _optionsJsonMeta,
        ),
      );
    }
    if (data.containsKey('close_at')) {
      context.handle(
        _closeAtMeta,
        closeAt.isAcceptableOrUnknown(data['close_at']!, _closeAtMeta),
      );
    } else if (isInserting) {
      context.missing(_closeAtMeta);
    }
    if (data.containsKey('created_by_member_id')) {
      context.handle(
        _createdByMemberIdMeta,
        createdByMemberId.isAcceptableOrUnknown(
          data['created_by_member_id']!,
          _createdByMemberIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdByMemberIdMeta);
    }
    if (data.containsKey('non_voter_policy')) {
      context.handle(
        _nonVoterPolicyMeta,
        nonVoterPolicy.isAcceptableOrUnknown(
          data['non_voter_policy']!,
          _nonVoterPolicyMeta,
        ),
      );
    }
    if (data.containsKey('closed')) {
      context.handle(
        _closedMeta,
        closed.isAcceptableOrUnknown(data['closed']!, _closedMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealPoll map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealPoll(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      optionsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}options_json'],
      ),
      closeAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}close_at'],
      )!,
      createdByMemberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by_member_id'],
      )!,
      nonVoterPolicy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}non_voter_policy'],
      ),
      closed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}closed'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MealPollsTable createAlias(String alias) {
    return $MealPollsTable(attachedDatabase, alias);
  }
}

class MealPoll extends DataClass implements Insertable<MealPoll> {
  final String id;
  final String groupId;
  final int date;
  final String type;
  final String? title;
  final String? optionsJson;
  final int closeAt;
  final String createdByMemberId;
  final String? nonVoterPolicy;
  final bool closed;
  final int updatedAt;
  const MealPoll({
    required this.id,
    required this.groupId,
    required this.date,
    required this.type,
    this.title,
    this.optionsJson,
    required this.closeAt,
    required this.createdByMemberId,
    this.nonVoterPolicy,
    required this.closed,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['group_id'] = Variable<String>(groupId);
    map['date'] = Variable<int>(date);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || optionsJson != null) {
      map['options_json'] = Variable<String>(optionsJson);
    }
    map['close_at'] = Variable<int>(closeAt);
    map['created_by_member_id'] = Variable<String>(createdByMemberId);
    if (!nullToAbsent || nonVoterPolicy != null) {
      map['non_voter_policy'] = Variable<String>(nonVoterPolicy);
    }
    map['closed'] = Variable<bool>(closed);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  MealPollsCompanion toCompanion(bool nullToAbsent) {
    return MealPollsCompanion(
      id: Value(id),
      groupId: Value(groupId),
      date: Value(date),
      type: Value(type),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      optionsJson: optionsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(optionsJson),
      closeAt: Value(closeAt),
      createdByMemberId: Value(createdByMemberId),
      nonVoterPolicy: nonVoterPolicy == null && nullToAbsent
          ? const Value.absent()
          : Value(nonVoterPolicy),
      closed: Value(closed),
      updatedAt: Value(updatedAt),
    );
  }

  factory MealPoll.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealPoll(
      id: serializer.fromJson<String>(json['id']),
      groupId: serializer.fromJson<String>(json['groupId']),
      date: serializer.fromJson<int>(json['date']),
      type: serializer.fromJson<String>(json['type']),
      title: serializer.fromJson<String?>(json['title']),
      optionsJson: serializer.fromJson<String?>(json['optionsJson']),
      closeAt: serializer.fromJson<int>(json['closeAt']),
      createdByMemberId: serializer.fromJson<String>(json['createdByMemberId']),
      nonVoterPolicy: serializer.fromJson<String?>(json['nonVoterPolicy']),
      closed: serializer.fromJson<bool>(json['closed']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'groupId': serializer.toJson<String>(groupId),
      'date': serializer.toJson<int>(date),
      'type': serializer.toJson<String>(type),
      'title': serializer.toJson<String?>(title),
      'optionsJson': serializer.toJson<String?>(optionsJson),
      'closeAt': serializer.toJson<int>(closeAt),
      'createdByMemberId': serializer.toJson<String>(createdByMemberId),
      'nonVoterPolicy': serializer.toJson<String?>(nonVoterPolicy),
      'closed': serializer.toJson<bool>(closed),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  MealPoll copyWith({
    String? id,
    String? groupId,
    int? date,
    String? type,
    Value<String?> title = const Value.absent(),
    Value<String?> optionsJson = const Value.absent(),
    int? closeAt,
    String? createdByMemberId,
    Value<String?> nonVoterPolicy = const Value.absent(),
    bool? closed,
    int? updatedAt,
  }) => MealPoll(
    id: id ?? this.id,
    groupId: groupId ?? this.groupId,
    date: date ?? this.date,
    type: type ?? this.type,
    title: title.present ? title.value : this.title,
    optionsJson: optionsJson.present ? optionsJson.value : this.optionsJson,
    closeAt: closeAt ?? this.closeAt,
    createdByMemberId: createdByMemberId ?? this.createdByMemberId,
    nonVoterPolicy: nonVoterPolicy.present
        ? nonVoterPolicy.value
        : this.nonVoterPolicy,
    closed: closed ?? this.closed,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MealPoll copyWithCompanion(MealPollsCompanion data) {
    return MealPoll(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      date: data.date.present ? data.date.value : this.date,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      optionsJson: data.optionsJson.present
          ? data.optionsJson.value
          : this.optionsJson,
      closeAt: data.closeAt.present ? data.closeAt.value : this.closeAt,
      createdByMemberId: data.createdByMemberId.present
          ? data.createdByMemberId.value
          : this.createdByMemberId,
      nonVoterPolicy: data.nonVoterPolicy.present
          ? data.nonVoterPolicy.value
          : this.nonVoterPolicy,
      closed: data.closed.present ? data.closed.value : this.closed,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealPoll(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('optionsJson: $optionsJson, ')
          ..write('closeAt: $closeAt, ')
          ..write('createdByMemberId: $createdByMemberId, ')
          ..write('nonVoterPolicy: $nonVoterPolicy, ')
          ..write('closed: $closed, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    groupId,
    date,
    type,
    title,
    optionsJson,
    closeAt,
    createdByMemberId,
    nonVoterPolicy,
    closed,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealPoll &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.date == this.date &&
          other.type == this.type &&
          other.title == this.title &&
          other.optionsJson == this.optionsJson &&
          other.closeAt == this.closeAt &&
          other.createdByMemberId == this.createdByMemberId &&
          other.nonVoterPolicy == this.nonVoterPolicy &&
          other.closed == this.closed &&
          other.updatedAt == this.updatedAt);
}

class MealPollsCompanion extends UpdateCompanion<MealPoll> {
  final Value<String> id;
  final Value<String> groupId;
  final Value<int> date;
  final Value<String> type;
  final Value<String?> title;
  final Value<String?> optionsJson;
  final Value<int> closeAt;
  final Value<String> createdByMemberId;
  final Value<String?> nonVoterPolicy;
  final Value<bool> closed;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const MealPollsCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.date = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.optionsJson = const Value.absent(),
    this.closeAt = const Value.absent(),
    this.createdByMemberId = const Value.absent(),
    this.nonVoterPolicy = const Value.absent(),
    this.closed = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MealPollsCompanion.insert({
    required String id,
    required String groupId,
    required int date,
    required String type,
    this.title = const Value.absent(),
    this.optionsJson = const Value.absent(),
    required int closeAt,
    required String createdByMemberId,
    this.nonVoterPolicy = const Value.absent(),
    this.closed = const Value.absent(),
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       groupId = Value(groupId),
       date = Value(date),
       type = Value(type),
       closeAt = Value(closeAt),
       createdByMemberId = Value(createdByMemberId),
       updatedAt = Value(updatedAt);
  static Insertable<MealPoll> custom({
    Expression<String>? id,
    Expression<String>? groupId,
    Expression<int>? date,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? optionsJson,
    Expression<int>? closeAt,
    Expression<String>? createdByMemberId,
    Expression<String>? nonVoterPolicy,
    Expression<bool>? closed,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (date != null) 'date': date,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (optionsJson != null) 'options_json': optionsJson,
      if (closeAt != null) 'close_at': closeAt,
      if (createdByMemberId != null) 'created_by_member_id': createdByMemberId,
      if (nonVoterPolicy != null) 'non_voter_policy': nonVoterPolicy,
      if (closed != null) 'closed': closed,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MealPollsCompanion copyWith({
    Value<String>? id,
    Value<String>? groupId,
    Value<int>? date,
    Value<String>? type,
    Value<String?>? title,
    Value<String?>? optionsJson,
    Value<int>? closeAt,
    Value<String>? createdByMemberId,
    Value<String?>? nonVoterPolicy,
    Value<bool>? closed,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return MealPollsCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      date: date ?? this.date,
      type: type ?? this.type,
      title: title ?? this.title,
      optionsJson: optionsJson ?? this.optionsJson,
      closeAt: closeAt ?? this.closeAt,
      createdByMemberId: createdByMemberId ?? this.createdByMemberId,
      nonVoterPolicy: nonVoterPolicy ?? this.nonVoterPolicy,
      closed: closed ?? this.closed,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (optionsJson.present) {
      map['options_json'] = Variable<String>(optionsJson.value);
    }
    if (closeAt.present) {
      map['close_at'] = Variable<int>(closeAt.value);
    }
    if (createdByMemberId.present) {
      map['created_by_member_id'] = Variable<String>(createdByMemberId.value);
    }
    if (nonVoterPolicy.present) {
      map['non_voter_policy'] = Variable<String>(nonVoterPolicy.value);
    }
    if (closed.present) {
      map['closed'] = Variable<bool>(closed.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealPollsCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('optionsJson: $optionsJson, ')
          ..write('closeAt: $closeAt, ')
          ..write('createdByMemberId: $createdByMemberId, ')
          ..write('nonVoterPolicy: $nonVoterPolicy, ')
          ..write('closed: $closed, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MealPollVotesTable extends MealPollVotes
    with TableInfo<$MealPollVotesTable, MealPollVote> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealPollVotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _pollIdMeta = const VerificationMeta('pollId');
  @override
  late final GeneratedColumn<String> pollId = GeneratedColumn<String>(
    'poll_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES meal_polls (id)',
    ),
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
    'member_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES members (id)',
    ),
  );
  static const VerificationMeta _valueJsonMeta = const VerificationMeta(
    'valueJson',
  );
  @override
  late final GeneratedColumn<String> valueJson = GeneratedColumn<String>(
    'value_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _votedAtMeta = const VerificationMeta(
    'votedAt',
  );
  @override
  late final GeneratedColumn<int> votedAt = GeneratedColumn<int>(
    'voted_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [pollId, memberId, valueJson, votedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_poll_votes';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealPollVote> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('poll_id')) {
      context.handle(
        _pollIdMeta,
        pollId.isAcceptableOrUnknown(data['poll_id']!, _pollIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pollIdMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('value_json')) {
      context.handle(
        _valueJsonMeta,
        valueJson.isAcceptableOrUnknown(data['value_json']!, _valueJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_valueJsonMeta);
    }
    if (data.containsKey('voted_at')) {
      context.handle(
        _votedAtMeta,
        votedAt.isAcceptableOrUnknown(data['voted_at']!, _votedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_votedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {pollId, memberId};
  @override
  MealPollVote map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealPollVote(
      pollId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poll_id'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_id'],
      )!,
      valueJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value_json'],
      )!,
      votedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}voted_at'],
      )!,
    );
  }

  @override
  $MealPollVotesTable createAlias(String alias) {
    return $MealPollVotesTable(attachedDatabase, alias);
  }
}

class MealPollVote extends DataClass implements Insertable<MealPollVote> {
  final String pollId;
  final String memberId;
  final String valueJson;
  final int votedAt;
  const MealPollVote({
    required this.pollId,
    required this.memberId,
    required this.valueJson,
    required this.votedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['poll_id'] = Variable<String>(pollId);
    map['member_id'] = Variable<String>(memberId);
    map['value_json'] = Variable<String>(valueJson);
    map['voted_at'] = Variable<int>(votedAt);
    return map;
  }

  MealPollVotesCompanion toCompanion(bool nullToAbsent) {
    return MealPollVotesCompanion(
      pollId: Value(pollId),
      memberId: Value(memberId),
      valueJson: Value(valueJson),
      votedAt: Value(votedAt),
    );
  }

  factory MealPollVote.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealPollVote(
      pollId: serializer.fromJson<String>(json['pollId']),
      memberId: serializer.fromJson<String>(json['memberId']),
      valueJson: serializer.fromJson<String>(json['valueJson']),
      votedAt: serializer.fromJson<int>(json['votedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'pollId': serializer.toJson<String>(pollId),
      'memberId': serializer.toJson<String>(memberId),
      'valueJson': serializer.toJson<String>(valueJson),
      'votedAt': serializer.toJson<int>(votedAt),
    };
  }

  MealPollVote copyWith({
    String? pollId,
    String? memberId,
    String? valueJson,
    int? votedAt,
  }) => MealPollVote(
    pollId: pollId ?? this.pollId,
    memberId: memberId ?? this.memberId,
    valueJson: valueJson ?? this.valueJson,
    votedAt: votedAt ?? this.votedAt,
  );
  MealPollVote copyWithCompanion(MealPollVotesCompanion data) {
    return MealPollVote(
      pollId: data.pollId.present ? data.pollId.value : this.pollId,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      valueJson: data.valueJson.present ? data.valueJson.value : this.valueJson,
      votedAt: data.votedAt.present ? data.votedAt.value : this.votedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealPollVote(')
          ..write('pollId: $pollId, ')
          ..write('memberId: $memberId, ')
          ..write('valueJson: $valueJson, ')
          ..write('votedAt: $votedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(pollId, memberId, valueJson, votedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealPollVote &&
          other.pollId == this.pollId &&
          other.memberId == this.memberId &&
          other.valueJson == this.valueJson &&
          other.votedAt == this.votedAt);
}

class MealPollVotesCompanion extends UpdateCompanion<MealPollVote> {
  final Value<String> pollId;
  final Value<String> memberId;
  final Value<String> valueJson;
  final Value<int> votedAt;
  final Value<int> rowid;
  const MealPollVotesCompanion({
    this.pollId = const Value.absent(),
    this.memberId = const Value.absent(),
    this.valueJson = const Value.absent(),
    this.votedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MealPollVotesCompanion.insert({
    required String pollId,
    required String memberId,
    required String valueJson,
    required int votedAt,
    this.rowid = const Value.absent(),
  }) : pollId = Value(pollId),
       memberId = Value(memberId),
       valueJson = Value(valueJson),
       votedAt = Value(votedAt);
  static Insertable<MealPollVote> custom({
    Expression<String>? pollId,
    Expression<String>? memberId,
    Expression<String>? valueJson,
    Expression<int>? votedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (pollId != null) 'poll_id': pollId,
      if (memberId != null) 'member_id': memberId,
      if (valueJson != null) 'value_json': valueJson,
      if (votedAt != null) 'voted_at': votedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MealPollVotesCompanion copyWith({
    Value<String>? pollId,
    Value<String>? memberId,
    Value<String>? valueJson,
    Value<int>? votedAt,
    Value<int>? rowid,
  }) {
    return MealPollVotesCompanion(
      pollId: pollId ?? this.pollId,
      memberId: memberId ?? this.memberId,
      valueJson: valueJson ?? this.valueJson,
      votedAt: votedAt ?? this.votedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (pollId.present) {
      map['poll_id'] = Variable<String>(pollId.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (valueJson.present) {
      map['value_json'] = Variable<String>(valueJson.value);
    }
    if (votedAt.present) {
      map['voted_at'] = Variable<int>(votedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealPollVotesCompanion(')
          ..write('pollId: $pollId, ')
          ..write('memberId: $memberId, ')
          ..write('valueJson: $valueJson, ')
          ..write('votedAt: $votedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MealSlotsTable extends MealSlots
    with TableInfo<$MealSlotsTable, MealSlot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealSlotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "groups" (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultKeyMeta = const VerificationMeta(
    'defaultKey',
  );
  @override
  late final GeneratedColumn<String> defaultKey = GeneratedColumn<String>(
    'default_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    groupId,
    name,
    defaultKey,
    weight,
    sortOrder,
    active,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_slots';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealSlot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('default_key')) {
      context.handle(
        _defaultKeyMeta,
        defaultKey.isAcceptableOrUnknown(data['default_key']!, _defaultKeyMeta),
      );
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealSlot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealSlot(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      defaultKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_key'],
      ),
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MealSlotsTable createAlias(String alias) {
    return $MealSlotsTable(attachedDatabase, alias);
  }
}

class MealSlot extends DataClass implements Insertable<MealSlot> {
  final String id;
  final String groupId;
  final String name;
  final String? defaultKey;
  final double weight;
  final int sortOrder;
  final bool active;
  final int updatedAt;
  const MealSlot({
    required this.id,
    required this.groupId,
    required this.name,
    this.defaultKey,
    required this.weight,
    required this.sortOrder,
    required this.active,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['group_id'] = Variable<String>(groupId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || defaultKey != null) {
      map['default_key'] = Variable<String>(defaultKey);
    }
    map['weight'] = Variable<double>(weight);
    map['sort_order'] = Variable<int>(sortOrder);
    map['active'] = Variable<bool>(active);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  MealSlotsCompanion toCompanion(bool nullToAbsent) {
    return MealSlotsCompanion(
      id: Value(id),
      groupId: Value(groupId),
      name: Value(name),
      defaultKey: defaultKey == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultKey),
      weight: Value(weight),
      sortOrder: Value(sortOrder),
      active: Value(active),
      updatedAt: Value(updatedAt),
    );
  }

  factory MealSlot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealSlot(
      id: serializer.fromJson<String>(json['id']),
      groupId: serializer.fromJson<String>(json['groupId']),
      name: serializer.fromJson<String>(json['name']),
      defaultKey: serializer.fromJson<String?>(json['defaultKey']),
      weight: serializer.fromJson<double>(json['weight']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      active: serializer.fromJson<bool>(json['active']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'groupId': serializer.toJson<String>(groupId),
      'name': serializer.toJson<String>(name),
      'defaultKey': serializer.toJson<String?>(defaultKey),
      'weight': serializer.toJson<double>(weight),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'active': serializer.toJson<bool>(active),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  MealSlot copyWith({
    String? id,
    String? groupId,
    String? name,
    Value<String?> defaultKey = const Value.absent(),
    double? weight,
    int? sortOrder,
    bool? active,
    int? updatedAt,
  }) => MealSlot(
    id: id ?? this.id,
    groupId: groupId ?? this.groupId,
    name: name ?? this.name,
    defaultKey: defaultKey.present ? defaultKey.value : this.defaultKey,
    weight: weight ?? this.weight,
    sortOrder: sortOrder ?? this.sortOrder,
    active: active ?? this.active,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MealSlot copyWithCompanion(MealSlotsCompanion data) {
    return MealSlot(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      name: data.name.present ? data.name.value : this.name,
      defaultKey: data.defaultKey.present
          ? data.defaultKey.value
          : this.defaultKey,
      weight: data.weight.present ? data.weight.value : this.weight,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      active: data.active.present ? data.active.value : this.active,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealSlot(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('name: $name, ')
          ..write('defaultKey: $defaultKey, ')
          ..write('weight: $weight, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('active: $active, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    groupId,
    name,
    defaultKey,
    weight,
    sortOrder,
    active,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealSlot &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.name == this.name &&
          other.defaultKey == this.defaultKey &&
          other.weight == this.weight &&
          other.sortOrder == this.sortOrder &&
          other.active == this.active &&
          other.updatedAt == this.updatedAt);
}

class MealSlotsCompanion extends UpdateCompanion<MealSlot> {
  final Value<String> id;
  final Value<String> groupId;
  final Value<String> name;
  final Value<String?> defaultKey;
  final Value<double> weight;
  final Value<int> sortOrder;
  final Value<bool> active;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const MealSlotsCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.name = const Value.absent(),
    this.defaultKey = const Value.absent(),
    this.weight = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.active = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MealSlotsCompanion.insert({
    required String id,
    required String groupId,
    required String name,
    this.defaultKey = const Value.absent(),
    this.weight = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.active = const Value.absent(),
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       groupId = Value(groupId),
       name = Value(name),
       updatedAt = Value(updatedAt);
  static Insertable<MealSlot> custom({
    Expression<String>? id,
    Expression<String>? groupId,
    Expression<String>? name,
    Expression<String>? defaultKey,
    Expression<double>? weight,
    Expression<int>? sortOrder,
    Expression<bool>? active,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (name != null) 'name': name,
      if (defaultKey != null) 'default_key': defaultKey,
      if (weight != null) 'weight': weight,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (active != null) 'active': active,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MealSlotsCompanion copyWith({
    Value<String>? id,
    Value<String>? groupId,
    Value<String>? name,
    Value<String?>? defaultKey,
    Value<double>? weight,
    Value<int>? sortOrder,
    Value<bool>? active,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return MealSlotsCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      defaultKey: defaultKey ?? this.defaultKey,
      weight: weight ?? this.weight,
      sortOrder: sortOrder ?? this.sortOrder,
      active: active ?? this.active,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (defaultKey.present) {
      map['default_key'] = Variable<String>(defaultKey.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealSlotsCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('name: $name, ')
          ..write('defaultKey: $defaultKey, ')
          ..write('weight: $weight, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('active: $active, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MemberMealRoutinesTable extends MemberMealRoutines
    with TableInfo<$MemberMealRoutinesTable, MemberMealRoutine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemberMealRoutinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
    'member_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES members (id)',
    ),
  );
  static const VerificationMeta _slotIdMeta = const VerificationMeta('slotId');
  @override
  late final GeneratedColumn<String> slotId = GeneratedColumn<String>(
    'slot_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES meal_slots (id)',
    ),
  );
  static const VerificationMeta _weekdayMeta = const VerificationMeta(
    'weekday',
  );
  @override
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
    'weekday',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    memberId,
    slotId,
    weekday,
    enabled,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'member_meal_routines';
  @override
  VerificationContext validateIntegrity(
    Insertable<MemberMealRoutine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('slot_id')) {
      context.handle(
        _slotIdMeta,
        slotId.isAcceptableOrUnknown(data['slot_id']!, _slotIdMeta),
      );
    } else if (isInserting) {
      context.missing(_slotIdMeta);
    }
    if (data.containsKey('weekday')) {
      context.handle(
        _weekdayMeta,
        weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MemberMealRoutine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemberMealRoutine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_id'],
      )!,
      slotId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slot_id'],
      )!,
      weekday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekday'],
      ),
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MemberMealRoutinesTable createAlias(String alias) {
    return $MemberMealRoutinesTable(attachedDatabase, alias);
  }
}

class MemberMealRoutine extends DataClass
    implements Insertable<MemberMealRoutine> {
  final String id;
  final String memberId;
  final String slotId;
  final int? weekday;
  final bool enabled;
  final int updatedAt;
  const MemberMealRoutine({
    required this.id,
    required this.memberId,
    required this.slotId,
    this.weekday,
    required this.enabled,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['member_id'] = Variable<String>(memberId);
    map['slot_id'] = Variable<String>(slotId);
    if (!nullToAbsent || weekday != null) {
      map['weekday'] = Variable<int>(weekday);
    }
    map['enabled'] = Variable<bool>(enabled);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  MemberMealRoutinesCompanion toCompanion(bool nullToAbsent) {
    return MemberMealRoutinesCompanion(
      id: Value(id),
      memberId: Value(memberId),
      slotId: Value(slotId),
      weekday: weekday == null && nullToAbsent
          ? const Value.absent()
          : Value(weekday),
      enabled: Value(enabled),
      updatedAt: Value(updatedAt),
    );
  }

  factory MemberMealRoutine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemberMealRoutine(
      id: serializer.fromJson<String>(json['id']),
      memberId: serializer.fromJson<String>(json['memberId']),
      slotId: serializer.fromJson<String>(json['slotId']),
      weekday: serializer.fromJson<int?>(json['weekday']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'memberId': serializer.toJson<String>(memberId),
      'slotId': serializer.toJson<String>(slotId),
      'weekday': serializer.toJson<int?>(weekday),
      'enabled': serializer.toJson<bool>(enabled),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  MemberMealRoutine copyWith({
    String? id,
    String? memberId,
    String? slotId,
    Value<int?> weekday = const Value.absent(),
    bool? enabled,
    int? updatedAt,
  }) => MemberMealRoutine(
    id: id ?? this.id,
    memberId: memberId ?? this.memberId,
    slotId: slotId ?? this.slotId,
    weekday: weekday.present ? weekday.value : this.weekday,
    enabled: enabled ?? this.enabled,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MemberMealRoutine copyWithCompanion(MemberMealRoutinesCompanion data) {
    return MemberMealRoutine(
      id: data.id.present ? data.id.value : this.id,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      slotId: data.slotId.present ? data.slotId.value : this.slotId,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemberMealRoutine(')
          ..write('id: $id, ')
          ..write('memberId: $memberId, ')
          ..write('slotId: $slotId, ')
          ..write('weekday: $weekday, ')
          ..write('enabled: $enabled, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, memberId, slotId, weekday, enabled, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemberMealRoutine &&
          other.id == this.id &&
          other.memberId == this.memberId &&
          other.slotId == this.slotId &&
          other.weekday == this.weekday &&
          other.enabled == this.enabled &&
          other.updatedAt == this.updatedAt);
}

class MemberMealRoutinesCompanion extends UpdateCompanion<MemberMealRoutine> {
  final Value<String> id;
  final Value<String> memberId;
  final Value<String> slotId;
  final Value<int?> weekday;
  final Value<bool> enabled;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const MemberMealRoutinesCompanion({
    this.id = const Value.absent(),
    this.memberId = const Value.absent(),
    this.slotId = const Value.absent(),
    this.weekday = const Value.absent(),
    this.enabled = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MemberMealRoutinesCompanion.insert({
    required String id,
    required String memberId,
    required String slotId,
    this.weekday = const Value.absent(),
    this.enabled = const Value.absent(),
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       memberId = Value(memberId),
       slotId = Value(slotId),
       updatedAt = Value(updatedAt);
  static Insertable<MemberMealRoutine> custom({
    Expression<String>? id,
    Expression<String>? memberId,
    Expression<String>? slotId,
    Expression<int>? weekday,
    Expression<bool>? enabled,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (memberId != null) 'member_id': memberId,
      if (slotId != null) 'slot_id': slotId,
      if (weekday != null) 'weekday': weekday,
      if (enabled != null) 'enabled': enabled,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MemberMealRoutinesCompanion copyWith({
    Value<String>? id,
    Value<String>? memberId,
    Value<String>? slotId,
    Value<int?>? weekday,
    Value<bool>? enabled,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return MemberMealRoutinesCompanion(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      slotId: slotId ?? this.slotId,
      weekday: weekday ?? this.weekday,
      enabled: enabled ?? this.enabled,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (slotId.present) {
      map['slot_id'] = Variable<String>(slotId.value);
    }
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemberMealRoutinesCompanion(')
          ..write('id: $id, ')
          ..write('memberId: $memberId, ')
          ..write('slotId: $slotId, ')
          ..write('weekday: $weekday, ')
          ..write('enabled: $enabled, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MealLeavesTable extends MealLeaves
    with TableInfo<$MealLeavesTable, MealLeave> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealLeavesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
    'member_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES members (id)',
    ),
  );
  static const VerificationMeta _fromDateMeta = const VerificationMeta(
    'fromDate',
  );
  @override
  late final GeneratedColumn<int> fromDate = GeneratedColumn<int>(
    'from_date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toDateMeta = const VerificationMeta('toDate');
  @override
  late final GeneratedColumn<int> toDate = GeneratedColumn<int>(
    'to_date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    memberId,
    fromDate,
    toDate,
    note,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_leaves';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealLeave> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('from_date')) {
      context.handle(
        _fromDateMeta,
        fromDate.isAcceptableOrUnknown(data['from_date']!, _fromDateMeta),
      );
    } else if (isInserting) {
      context.missing(_fromDateMeta);
    }
    if (data.containsKey('to_date')) {
      context.handle(
        _toDateMeta,
        toDate.isAcceptableOrUnknown(data['to_date']!, _toDateMeta),
      );
    } else if (isInserting) {
      context.missing(_toDateMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealLeave map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealLeave(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_id'],
      )!,
      fromDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}from_date'],
      )!,
      toDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}to_date'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MealLeavesTable createAlias(String alias) {
    return $MealLeavesTable(attachedDatabase, alias);
  }
}

class MealLeave extends DataClass implements Insertable<MealLeave> {
  final String id;
  final String memberId;
  final int fromDate;
  final int toDate;
  final String? note;
  final int updatedAt;
  const MealLeave({
    required this.id,
    required this.memberId,
    required this.fromDate,
    required this.toDate,
    this.note,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['member_id'] = Variable<String>(memberId);
    map['from_date'] = Variable<int>(fromDate);
    map['to_date'] = Variable<int>(toDate);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  MealLeavesCompanion toCompanion(bool nullToAbsent) {
    return MealLeavesCompanion(
      id: Value(id),
      memberId: Value(memberId),
      fromDate: Value(fromDate),
      toDate: Value(toDate),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      updatedAt: Value(updatedAt),
    );
  }

  factory MealLeave.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealLeave(
      id: serializer.fromJson<String>(json['id']),
      memberId: serializer.fromJson<String>(json['memberId']),
      fromDate: serializer.fromJson<int>(json['fromDate']),
      toDate: serializer.fromJson<int>(json['toDate']),
      note: serializer.fromJson<String?>(json['note']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'memberId': serializer.toJson<String>(memberId),
      'fromDate': serializer.toJson<int>(fromDate),
      'toDate': serializer.toJson<int>(toDate),
      'note': serializer.toJson<String?>(note),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  MealLeave copyWith({
    String? id,
    String? memberId,
    int? fromDate,
    int? toDate,
    Value<String?> note = const Value.absent(),
    int? updatedAt,
  }) => MealLeave(
    id: id ?? this.id,
    memberId: memberId ?? this.memberId,
    fromDate: fromDate ?? this.fromDate,
    toDate: toDate ?? this.toDate,
    note: note.present ? note.value : this.note,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MealLeave copyWithCompanion(MealLeavesCompanion data) {
    return MealLeave(
      id: data.id.present ? data.id.value : this.id,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      fromDate: data.fromDate.present ? data.fromDate.value : this.fromDate,
      toDate: data.toDate.present ? data.toDate.value : this.toDate,
      note: data.note.present ? data.note.value : this.note,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealLeave(')
          ..write('id: $id, ')
          ..write('memberId: $memberId, ')
          ..write('fromDate: $fromDate, ')
          ..write('toDate: $toDate, ')
          ..write('note: $note, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, memberId, fromDate, toDate, note, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealLeave &&
          other.id == this.id &&
          other.memberId == this.memberId &&
          other.fromDate == this.fromDate &&
          other.toDate == this.toDate &&
          other.note == this.note &&
          other.updatedAt == this.updatedAt);
}

class MealLeavesCompanion extends UpdateCompanion<MealLeave> {
  final Value<String> id;
  final Value<String> memberId;
  final Value<int> fromDate;
  final Value<int> toDate;
  final Value<String?> note;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const MealLeavesCompanion({
    this.id = const Value.absent(),
    this.memberId = const Value.absent(),
    this.fromDate = const Value.absent(),
    this.toDate = const Value.absent(),
    this.note = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MealLeavesCompanion.insert({
    required String id,
    required String memberId,
    required int fromDate,
    required int toDate,
    this.note = const Value.absent(),
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       memberId = Value(memberId),
       fromDate = Value(fromDate),
       toDate = Value(toDate),
       updatedAt = Value(updatedAt);
  static Insertable<MealLeave> custom({
    Expression<String>? id,
    Expression<String>? memberId,
    Expression<int>? fromDate,
    Expression<int>? toDate,
    Expression<String>? note,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (memberId != null) 'member_id': memberId,
      if (fromDate != null) 'from_date': fromDate,
      if (toDate != null) 'to_date': toDate,
      if (note != null) 'note': note,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MealLeavesCompanion copyWith({
    Value<String>? id,
    Value<String>? memberId,
    Value<int>? fromDate,
    Value<int>? toDate,
    Value<String?>? note,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return MealLeavesCompanion(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      note: note ?? this.note,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (fromDate.present) {
      map['from_date'] = Variable<int>(fromDate.value);
    }
    if (toDate.present) {
      map['to_date'] = Variable<int>(toDate.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealLeavesCompanion(')
          ..write('id: $id, ')
          ..write('memberId: $memberId, ')
          ..write('fromDate: $fromDate, ')
          ..write('toDate: $toDate, ')
          ..write('note: $note, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BazarDutiesTable extends BazarDuties
    with TableInfo<$BazarDutiesTable, BazarDuty> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BazarDutiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "groups" (id)',
    ),
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
    'member_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES members (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<int> date = GeneratedColumn<int>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _doneMeta = const VerificationMeta('done');
  @override
  late final GeneratedColumn<bool> done = GeneratedColumn<bool>(
    'done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    groupId,
    memberId,
    date,
    note,
    done,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bazar_duties';
  @override
  VerificationContext validateIntegrity(
    Insertable<BazarDuty> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('done')) {
      context.handle(
        _doneMeta,
        done.isAcceptableOrUnknown(data['done']!, _doneMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BazarDuty map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BazarDuty(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      done: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}done'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BazarDutiesTable createAlias(String alias) {
    return $BazarDutiesTable(attachedDatabase, alias);
  }
}

class BazarDuty extends DataClass implements Insertable<BazarDuty> {
  final String id;
  final String groupId;
  final String memberId;
  final int date;
  final String? note;
  final bool done;
  final int updatedAt;
  const BazarDuty({
    required this.id,
    required this.groupId,
    required this.memberId,
    required this.date,
    this.note,
    required this.done,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['group_id'] = Variable<String>(groupId);
    map['member_id'] = Variable<String>(memberId);
    map['date'] = Variable<int>(date);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['done'] = Variable<bool>(done);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  BazarDutiesCompanion toCompanion(bool nullToAbsent) {
    return BazarDutiesCompanion(
      id: Value(id),
      groupId: Value(groupId),
      memberId: Value(memberId),
      date: Value(date),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      done: Value(done),
      updatedAt: Value(updatedAt),
    );
  }

  factory BazarDuty.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BazarDuty(
      id: serializer.fromJson<String>(json['id']),
      groupId: serializer.fromJson<String>(json['groupId']),
      memberId: serializer.fromJson<String>(json['memberId']),
      date: serializer.fromJson<int>(json['date']),
      note: serializer.fromJson<String?>(json['note']),
      done: serializer.fromJson<bool>(json['done']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'groupId': serializer.toJson<String>(groupId),
      'memberId': serializer.toJson<String>(memberId),
      'date': serializer.toJson<int>(date),
      'note': serializer.toJson<String?>(note),
      'done': serializer.toJson<bool>(done),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  BazarDuty copyWith({
    String? id,
    String? groupId,
    String? memberId,
    int? date,
    Value<String?> note = const Value.absent(),
    bool? done,
    int? updatedAt,
  }) => BazarDuty(
    id: id ?? this.id,
    groupId: groupId ?? this.groupId,
    memberId: memberId ?? this.memberId,
    date: date ?? this.date,
    note: note.present ? note.value : this.note,
    done: done ?? this.done,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BazarDuty copyWithCompanion(BazarDutiesCompanion data) {
    return BazarDuty(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      date: data.date.present ? data.date.value : this.date,
      note: data.note.present ? data.note.value : this.note,
      done: data.done.present ? data.done.value : this.done,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BazarDuty(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('memberId: $memberId, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('done: $done, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, groupId, memberId, date, note, done, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BazarDuty &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.memberId == this.memberId &&
          other.date == this.date &&
          other.note == this.note &&
          other.done == this.done &&
          other.updatedAt == this.updatedAt);
}

class BazarDutiesCompanion extends UpdateCompanion<BazarDuty> {
  final Value<String> id;
  final Value<String> groupId;
  final Value<String> memberId;
  final Value<int> date;
  final Value<String?> note;
  final Value<bool> done;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const BazarDutiesCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.memberId = const Value.absent(),
    this.date = const Value.absent(),
    this.note = const Value.absent(),
    this.done = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BazarDutiesCompanion.insert({
    required String id,
    required String groupId,
    required String memberId,
    required int date,
    this.note = const Value.absent(),
    this.done = const Value.absent(),
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       groupId = Value(groupId),
       memberId = Value(memberId),
       date = Value(date),
       updatedAt = Value(updatedAt);
  static Insertable<BazarDuty> custom({
    Expression<String>? id,
    Expression<String>? groupId,
    Expression<String>? memberId,
    Expression<int>? date,
    Expression<String>? note,
    Expression<bool>? done,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (memberId != null) 'member_id': memberId,
      if (date != null) 'date': date,
      if (note != null) 'note': note,
      if (done != null) 'done': done,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BazarDutiesCompanion copyWith({
    Value<String>? id,
    Value<String>? groupId,
    Value<String>? memberId,
    Value<int>? date,
    Value<String?>? note,
    Value<bool>? done,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return BazarDutiesCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      memberId: memberId ?? this.memberId,
      date: date ?? this.date,
      note: note ?? this.note,
      done: done ?? this.done,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (done.present) {
      map['done'] = Variable<bool>(done.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BazarDutiesCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('memberId: $memberId, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('done: $done, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuditLogTable extends AuditLog
    with TableInfo<$AuditLogTable, AuditLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "groups" (id)',
    ),
  );
  static const VerificationMeta _entityMeta = const VerificationMeta('entity');
  @override
  late final GeneratedColumn<String> entity = GeneratedColumn<String>(
    'entity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _diffJsonMeta = const VerificationMeta(
    'diffJson',
  );
  @override
  late final GeneratedColumn<String> diffJson = GeneratedColumn<String>(
    'diff_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    groupId,
    entity,
    entityId,
    action,
    timestamp,
    diffJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuditLogData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('entity')) {
      context.handle(
        _entityMeta,
        entity.isAcceptableOrUnknown(data['entity']!, _entityMeta),
      );
    } else if (isInserting) {
      context.missing(_entityMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('diff_json')) {
      context.handle(
        _diffJsonMeta,
        diffJson.isAcceptableOrUnknown(data['diff_json']!, _diffJsonMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditLogData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      entity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}timestamp'],
      )!,
      diffJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diff_json'],
      ),
    );
  }

  @override
  $AuditLogTable createAlias(String alias) {
    return $AuditLogTable(attachedDatabase, alias);
  }
}

class AuditLogData extends DataClass implements Insertable<AuditLogData> {
  final String id;
  final String groupId;
  final String entity;
  final String entityId;
  final String action;
  final int timestamp;
  final String? diffJson;
  const AuditLogData({
    required this.id,
    required this.groupId,
    required this.entity,
    required this.entityId,
    required this.action,
    required this.timestamp,
    this.diffJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['group_id'] = Variable<String>(groupId);
    map['entity'] = Variable<String>(entity);
    map['entity_id'] = Variable<String>(entityId);
    map['action'] = Variable<String>(action);
    map['timestamp'] = Variable<int>(timestamp);
    if (!nullToAbsent || diffJson != null) {
      map['diff_json'] = Variable<String>(diffJson);
    }
    return map;
  }

  AuditLogCompanion toCompanion(bool nullToAbsent) {
    return AuditLogCompanion(
      id: Value(id),
      groupId: Value(groupId),
      entity: Value(entity),
      entityId: Value(entityId),
      action: Value(action),
      timestamp: Value(timestamp),
      diffJson: diffJson == null && nullToAbsent
          ? const Value.absent()
          : Value(diffJson),
    );
  }

  factory AuditLogData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditLogData(
      id: serializer.fromJson<String>(json['id']),
      groupId: serializer.fromJson<String>(json['groupId']),
      entity: serializer.fromJson<String>(json['entity']),
      entityId: serializer.fromJson<String>(json['entityId']),
      action: serializer.fromJson<String>(json['action']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      diffJson: serializer.fromJson<String?>(json['diffJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'groupId': serializer.toJson<String>(groupId),
      'entity': serializer.toJson<String>(entity),
      'entityId': serializer.toJson<String>(entityId),
      'action': serializer.toJson<String>(action),
      'timestamp': serializer.toJson<int>(timestamp),
      'diffJson': serializer.toJson<String?>(diffJson),
    };
  }

  AuditLogData copyWith({
    String? id,
    String? groupId,
    String? entity,
    String? entityId,
    String? action,
    int? timestamp,
    Value<String?> diffJson = const Value.absent(),
  }) => AuditLogData(
    id: id ?? this.id,
    groupId: groupId ?? this.groupId,
    entity: entity ?? this.entity,
    entityId: entityId ?? this.entityId,
    action: action ?? this.action,
    timestamp: timestamp ?? this.timestamp,
    diffJson: diffJson.present ? diffJson.value : this.diffJson,
  );
  AuditLogData copyWithCompanion(AuditLogCompanion data) {
    return AuditLogData(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      entity: data.entity.present ? data.entity.value : this.entity,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      action: data.action.present ? data.action.value : this.action,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      diffJson: data.diffJson.present ? data.diffJson.value : this.diffJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogData(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('entity: $entity, ')
          ..write('entityId: $entityId, ')
          ..write('action: $action, ')
          ..write('timestamp: $timestamp, ')
          ..write('diffJson: $diffJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, groupId, entity, entityId, action, timestamp, diffJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditLogData &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.entity == this.entity &&
          other.entityId == this.entityId &&
          other.action == this.action &&
          other.timestamp == this.timestamp &&
          other.diffJson == this.diffJson);
}

class AuditLogCompanion extends UpdateCompanion<AuditLogData> {
  final Value<String> id;
  final Value<String> groupId;
  final Value<String> entity;
  final Value<String> entityId;
  final Value<String> action;
  final Value<int> timestamp;
  final Value<String?> diffJson;
  final Value<int> rowid;
  const AuditLogCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.entity = const Value.absent(),
    this.entityId = const Value.absent(),
    this.action = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.diffJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuditLogCompanion.insert({
    required String id,
    required String groupId,
    required String entity,
    required String entityId,
    required String action,
    required int timestamp,
    this.diffJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       groupId = Value(groupId),
       entity = Value(entity),
       entityId = Value(entityId),
       action = Value(action),
       timestamp = Value(timestamp);
  static Insertable<AuditLogData> custom({
    Expression<String>? id,
    Expression<String>? groupId,
    Expression<String>? entity,
    Expression<String>? entityId,
    Expression<String>? action,
    Expression<int>? timestamp,
    Expression<String>? diffJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (entity != null) 'entity': entity,
      if (entityId != null) 'entity_id': entityId,
      if (action != null) 'action': action,
      if (timestamp != null) 'timestamp': timestamp,
      if (diffJson != null) 'diff_json': diffJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuditLogCompanion copyWith({
    Value<String>? id,
    Value<String>? groupId,
    Value<String>? entity,
    Value<String>? entityId,
    Value<String>? action,
    Value<int>? timestamp,
    Value<String?>? diffJson,
    Value<int>? rowid,
  }) {
    return AuditLogCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      entity: entity ?? this.entity,
      entityId: entityId ?? this.entityId,
      action: action ?? this.action,
      timestamp: timestamp ?? this.timestamp,
      diffJson: diffJson ?? this.diffJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (entity.present) {
      map['entity'] = Variable<String>(entity.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (diffJson.present) {
      map['diff_json'] = Variable<String>(diffJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('entity: $entity, ')
          ..write('entityId: $entityId, ')
          ..write('action: $action, ')
          ..write('timestamp: $timestamp, ')
          ..write('diffJson: $diffJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      ),
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String? value;
  const AppSetting({required this.key, this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<String>(value);
    }
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      key: Value(key),
      value: value == null && nullToAbsent
          ? const Value.absent()
          : Value(value),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String?>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String?>(value),
    };
  }

  AppSetting copyWith({
    String? key,
    Value<String?> value = const Value.absent(),
  }) => AppSetting(
    key: key ?? this.key,
    value: value.present ? value.value : this.value,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String?> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String?>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GroupsTable groups = $GroupsTable(this);
  late final $MembersTable members = $MembersTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $ExpensePayersTable expensePayers = $ExpensePayersTable(this);
  late final $ExpenseSplitsTable expenseSplits = $ExpenseSplitsTable(this);
  late final $MealsTable meals = $MealsTable(this);
  late final $DepositsTable deposits = $DepositsTable(this);
  late final $SettlementsTable settlements = $SettlementsTable(this);
  late final $MonthsTable months = $MonthsTable(this);
  late final $RecurringRulesTable recurringRules = $RecurringRulesTable(this);
  late final $MealPollsTable mealPolls = $MealPollsTable(this);
  late final $MealPollVotesTable mealPollVotes = $MealPollVotesTable(this);
  late final $MealSlotsTable mealSlots = $MealSlotsTable(this);
  late final $MemberMealRoutinesTable memberMealRoutines =
      $MemberMealRoutinesTable(this);
  late final $MealLeavesTable mealLeaves = $MealLeavesTable(this);
  late final $BazarDutiesTable bazarDuties = $BazarDutiesTable(this);
  late final $AuditLogTable auditLog = $AuditLogTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    groups,
    members,
    categories,
    expenses,
    expensePayers,
    expenseSplits,
    meals,
    deposits,
    settlements,
    months,
    recurringRules,
    mealPolls,
    mealPollVotes,
    mealSlots,
    memberMealRoutines,
    mealLeaves,
    bazarDuties,
    auditLog,
    appSettings,
  ];
}

typedef $$GroupsTableCreateCompanionBuilder =
    GroupsCompanion Function({
      required String id,
      required String name,
      Value<String> type,
      Value<String> currencySymbol,
      Value<int> monthStartDay,
      Value<bool> mealEnabled,
      Value<bool> mealLedgerSeparate,
      Value<String> defaultNonVoterPolicy,
      Value<int> pollReminderMinutes,
      Value<bool> archived,
      required int createdAt,
      required int updatedAt,
      Value<String?> inviteCode,
      Value<int> rowid,
    });
typedef $$GroupsTableUpdateCompanionBuilder =
    GroupsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> type,
      Value<String> currencySymbol,
      Value<int> monthStartDay,
      Value<bool> mealEnabled,
      Value<bool> mealLedgerSeparate,
      Value<String> defaultNonVoterPolicy,
      Value<int> pollReminderMinutes,
      Value<bool> archived,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<String?> inviteCode,
      Value<int> rowid,
    });

final class $$GroupsTableReferences
    extends BaseReferences<_$AppDatabase, $GroupsTable, Group> {
  $$GroupsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MembersTable, List<Member>> _membersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.members,
    aliasName: 'groups__id__members__group_id',
  );

  $$MembersTableProcessedTableManager get membersRefs {
    final manager = $$MembersTableTableManager(
      $_db,
      $_db.members,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_membersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CategoriesTable, List<Category>>
  _categoriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.categories,
    aliasName: 'groups__id__categories__group_id',
  );

  $$CategoriesTableProcessedTableManager get categoriesRefs {
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_categoriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ExpensesTable, List<Expense>> _expensesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.expenses,
    aliasName: 'groups__id__expenses__group_id',
  );

  $$ExpensesTableProcessedTableManager get expensesRefs {
    final manager = $$ExpensesTableTableManager(
      $_db,
      $_db.expenses,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MealsTable, List<Meal>> _mealsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.meals,
    aliasName: 'groups__id__meals__group_id',
  );

  $$MealsTableProcessedTableManager get mealsRefs {
    final manager = $$MealsTableTableManager(
      $_db,
      $_db.meals,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_mealsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DepositsTable, List<Deposit>> _depositsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.deposits,
    aliasName: 'groups__id__deposits__group_id',
  );

  $$DepositsTableProcessedTableManager get depositsRefs {
    final manager = $$DepositsTableTableManager(
      $_db,
      $_db.deposits,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_depositsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SettlementsTable, List<Settlement>>
  _settlementsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.settlements,
    aliasName: 'groups__id__settlements__group_id',
  );

  $$SettlementsTableProcessedTableManager get settlementsRefs {
    final manager = $$SettlementsTableTableManager(
      $_db,
      $_db.settlements,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_settlementsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MonthsTable, List<Month>> _monthsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.months,
    aliasName: 'groups__id__months__group_id',
  );

  $$MonthsTableProcessedTableManager get monthsRefs {
    final manager = $$MonthsTableTableManager(
      $_db,
      $_db.months,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_monthsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RecurringRulesTable, List<RecurringRule>>
  _recurringRulesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.recurringRules,
    aliasName: 'groups__id__recurring_rules__group_id',
  );

  $$RecurringRulesTableProcessedTableManager get recurringRulesRefs {
    final manager = $$RecurringRulesTableTableManager(
      $_db,
      $_db.recurringRules,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_recurringRulesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MealPollsTable, List<MealPoll>>
  _mealPollsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mealPolls,
    aliasName: 'groups__id__meal_polls__group_id',
  );

  $$MealPollsTableProcessedTableManager get mealPollsRefs {
    final manager = $$MealPollsTableTableManager(
      $_db,
      $_db.mealPolls,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_mealPollsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MealSlotsTable, List<MealSlot>>
  _mealSlotsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mealSlots,
    aliasName: 'groups__id__meal_slots__group_id',
  );

  $$MealSlotsTableProcessedTableManager get mealSlotsRefs {
    final manager = $$MealSlotsTableTableManager(
      $_db,
      $_db.mealSlots,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_mealSlotsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BazarDutiesTable, List<BazarDuty>>
  _bazarDutiesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.bazarDuties,
    aliasName: 'groups__id__bazar_duties__group_id',
  );

  $$BazarDutiesTableProcessedTableManager get bazarDutiesRefs {
    final manager = $$BazarDutiesTableTableManager(
      $_db,
      $_db.bazarDuties,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_bazarDutiesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AuditLogTable, List<AuditLogData>>
  _auditLogRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.auditLog,
    aliasName: 'groups__id__audit_log__group_id',
  );

  $$AuditLogTableProcessedTableManager get auditLogRefs {
    final manager = $$AuditLogTableTableManager(
      $_db,
      $_db.auditLog,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_auditLogRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GroupsTableFilterComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencySymbol => $composableBuilder(
    column: $table.currencySymbol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthStartDay => $composableBuilder(
    column: $table.monthStartDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get mealEnabled => $composableBuilder(
    column: $table.mealEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get mealLedgerSeparate => $composableBuilder(
    column: $table.mealLedgerSeparate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultNonVoterPolicy => $composableBuilder(
    column: $table.defaultNonVoterPolicy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pollReminderMinutes => $composableBuilder(
    column: $table.pollReminderMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get inviteCode => $composableBuilder(
    column: $table.inviteCode,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> membersRefs(
    Expression<bool> Function($$MembersTableFilterComposer f) f,
  ) {
    final $$MembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableFilterComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> categoriesRefs(
    Expression<bool> Function($$CategoriesTableFilterComposer f) f,
  ) {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> expensesRefs(
    Expression<bool> Function($$ExpensesTableFilterComposer f) f,
  ) {
    final $$ExpensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableFilterComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> mealsRefs(
    Expression<bool> Function($$MealsTableFilterComposer f) f,
  ) {
    final $$MealsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableFilterComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> depositsRefs(
    Expression<bool> Function($$DepositsTableFilterComposer f) f,
  ) {
    final $$DepositsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.deposits,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepositsTableFilterComposer(
            $db: $db,
            $table: $db.deposits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> settlementsRefs(
    Expression<bool> Function($$SettlementsTableFilterComposer f) f,
  ) {
    final $$SettlementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.settlements,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SettlementsTableFilterComposer(
            $db: $db,
            $table: $db.settlements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> monthsRefs(
    Expression<bool> Function($$MonthsTableFilterComposer f) f,
  ) {
    final $$MonthsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.months,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MonthsTableFilterComposer(
            $db: $db,
            $table: $db.months,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recurringRulesRefs(
    Expression<bool> Function($$RecurringRulesTableFilterComposer f) f,
  ) {
    final $$RecurringRulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recurringRules,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurringRulesTableFilterComposer(
            $db: $db,
            $table: $db.recurringRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> mealPollsRefs(
    Expression<bool> Function($$MealPollsTableFilterComposer f) f,
  ) {
    final $$MealPollsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealPolls,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealPollsTableFilterComposer(
            $db: $db,
            $table: $db.mealPolls,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> mealSlotsRefs(
    Expression<bool> Function($$MealSlotsTableFilterComposer f) f,
  ) {
    final $$MealSlotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealSlots,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealSlotsTableFilterComposer(
            $db: $db,
            $table: $db.mealSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> bazarDutiesRefs(
    Expression<bool> Function($$BazarDutiesTableFilterComposer f) f,
  ) {
    final $$BazarDutiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bazarDuties,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BazarDutiesTableFilterComposer(
            $db: $db,
            $table: $db.bazarDuties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> auditLogRefs(
    Expression<bool> Function($$AuditLogTableFilterComposer f) f,
  ) {
    final $$AuditLogTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.auditLog,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AuditLogTableFilterComposer(
            $db: $db,
            $table: $db.auditLog,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencySymbol => $composableBuilder(
    column: $table.currencySymbol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthStartDay => $composableBuilder(
    column: $table.monthStartDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get mealEnabled => $composableBuilder(
    column: $table.mealEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get mealLedgerSeparate => $composableBuilder(
    column: $table.mealLedgerSeparate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultNonVoterPolicy => $composableBuilder(
    column: $table.defaultNonVoterPolicy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pollReminderMinutes => $composableBuilder(
    column: $table.pollReminderMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inviteCode => $composableBuilder(
    column: $table.inviteCode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get currencySymbol => $composableBuilder(
    column: $table.currencySymbol,
    builder: (column) => column,
  );

  GeneratedColumn<int> get monthStartDay => $composableBuilder(
    column: $table.monthStartDay,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get mealEnabled => $composableBuilder(
    column: $table.mealEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get mealLedgerSeparate => $composableBuilder(
    column: $table.mealLedgerSeparate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultNonVoterPolicy => $composableBuilder(
    column: $table.defaultNonVoterPolicy,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pollReminderMinutes => $composableBuilder(
    column: $table.pollReminderMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get inviteCode => $composableBuilder(
    column: $table.inviteCode,
    builder: (column) => column,
  );

  Expression<T> membersRefs<T extends Object>(
    Expression<T> Function($$MembersTableAnnotationComposer a) f,
  ) {
    final $$MembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableAnnotationComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> categoriesRefs<T extends Object>(
    Expression<T> Function($$CategoriesTableAnnotationComposer a) f,
  ) {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> expensesRefs<T extends Object>(
    Expression<T> Function($$ExpensesTableAnnotationComposer a) f,
  ) {
    final $$ExpensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableAnnotationComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> mealsRefs<T extends Object>(
    Expression<T> Function($$MealsTableAnnotationComposer a) f,
  ) {
    final $$MealsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableAnnotationComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> depositsRefs<T extends Object>(
    Expression<T> Function($$DepositsTableAnnotationComposer a) f,
  ) {
    final $$DepositsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.deposits,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepositsTableAnnotationComposer(
            $db: $db,
            $table: $db.deposits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> settlementsRefs<T extends Object>(
    Expression<T> Function($$SettlementsTableAnnotationComposer a) f,
  ) {
    final $$SettlementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.settlements,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SettlementsTableAnnotationComposer(
            $db: $db,
            $table: $db.settlements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> monthsRefs<T extends Object>(
    Expression<T> Function($$MonthsTableAnnotationComposer a) f,
  ) {
    final $$MonthsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.months,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MonthsTableAnnotationComposer(
            $db: $db,
            $table: $db.months,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> recurringRulesRefs<T extends Object>(
    Expression<T> Function($$RecurringRulesTableAnnotationComposer a) f,
  ) {
    final $$RecurringRulesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recurringRules,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurringRulesTableAnnotationComposer(
            $db: $db,
            $table: $db.recurringRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> mealPollsRefs<T extends Object>(
    Expression<T> Function($$MealPollsTableAnnotationComposer a) f,
  ) {
    final $$MealPollsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealPolls,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealPollsTableAnnotationComposer(
            $db: $db,
            $table: $db.mealPolls,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> mealSlotsRefs<T extends Object>(
    Expression<T> Function($$MealSlotsTableAnnotationComposer a) f,
  ) {
    final $$MealSlotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealSlots,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealSlotsTableAnnotationComposer(
            $db: $db,
            $table: $db.mealSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> bazarDutiesRefs<T extends Object>(
    Expression<T> Function($$BazarDutiesTableAnnotationComposer a) f,
  ) {
    final $$BazarDutiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bazarDuties,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BazarDutiesTableAnnotationComposer(
            $db: $db,
            $table: $db.bazarDuties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> auditLogRefs<T extends Object>(
    Expression<T> Function($$AuditLogTableAnnotationComposer a) f,
  ) {
    final $$AuditLogTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.auditLog,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AuditLogTableAnnotationComposer(
            $db: $db,
            $table: $db.auditLog,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GroupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GroupsTable,
          Group,
          $$GroupsTableFilterComposer,
          $$GroupsTableOrderingComposer,
          $$GroupsTableAnnotationComposer,
          $$GroupsTableCreateCompanionBuilder,
          $$GroupsTableUpdateCompanionBuilder,
          (Group, $$GroupsTableReferences),
          Group,
          PrefetchHooks Function({
            bool membersRefs,
            bool categoriesRefs,
            bool expensesRefs,
            bool mealsRefs,
            bool depositsRefs,
            bool settlementsRefs,
            bool monthsRefs,
            bool recurringRulesRefs,
            bool mealPollsRefs,
            bool mealSlotsRefs,
            bool bazarDutiesRefs,
            bool auditLogRefs,
          })
        > {
  $$GroupsTableTableManager(_$AppDatabase db, $GroupsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> currencySymbol = const Value.absent(),
                Value<int> monthStartDay = const Value.absent(),
                Value<bool> mealEnabled = const Value.absent(),
                Value<bool> mealLedgerSeparate = const Value.absent(),
                Value<String> defaultNonVoterPolicy = const Value.absent(),
                Value<int> pollReminderMinutes = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String?> inviteCode = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroupsCompanion(
                id: id,
                name: name,
                type: type,
                currencySymbol: currencySymbol,
                monthStartDay: monthStartDay,
                mealEnabled: mealEnabled,
                mealLedgerSeparate: mealLedgerSeparate,
                defaultNonVoterPolicy: defaultNonVoterPolicy,
                pollReminderMinutes: pollReminderMinutes,
                archived: archived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                inviteCode: inviteCode,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> type = const Value.absent(),
                Value<String> currencySymbol = const Value.absent(),
                Value<int> monthStartDay = const Value.absent(),
                Value<bool> mealEnabled = const Value.absent(),
                Value<bool> mealLedgerSeparate = const Value.absent(),
                Value<String> defaultNonVoterPolicy = const Value.absent(),
                Value<int> pollReminderMinutes = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<String?> inviteCode = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroupsCompanion.insert(
                id: id,
                name: name,
                type: type,
                currencySymbol: currencySymbol,
                monthStartDay: monthStartDay,
                mealEnabled: mealEnabled,
                mealLedgerSeparate: mealLedgerSeparate,
                defaultNonVoterPolicy: defaultNonVoterPolicy,
                pollReminderMinutes: pollReminderMinutes,
                archived: archived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                inviteCode: inviteCode,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$GroupsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                membersRefs = false,
                categoriesRefs = false,
                expensesRefs = false,
                mealsRefs = false,
                depositsRefs = false,
                settlementsRefs = false,
                monthsRefs = false,
                recurringRulesRefs = false,
                mealPollsRefs = false,
                mealSlotsRefs = false,
                bazarDutiesRefs = false,
                auditLogRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (membersRefs) db.members,
                    if (categoriesRefs) db.categories,
                    if (expensesRefs) db.expenses,
                    if (mealsRefs) db.meals,
                    if (depositsRefs) db.deposits,
                    if (settlementsRefs) db.settlements,
                    if (monthsRefs) db.months,
                    if (recurringRulesRefs) db.recurringRules,
                    if (mealPollsRefs) db.mealPolls,
                    if (mealSlotsRefs) db.mealSlots,
                    if (bazarDutiesRefs) db.bazarDuties,
                    if (auditLogRefs) db.auditLog,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (membersRefs)
                        await $_getPrefetchedData<Group, $GroupsTable, Member>(
                          currentTable: table,
                          referencedTable: $$GroupsTableReferences
                              ._membersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).membersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.groupId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (categoriesRefs)
                        await $_getPrefetchedData<
                          Group,
                          $GroupsTable,
                          Category
                        >(
                          currentTable: table,
                          referencedTable: $$GroupsTableReferences
                              ._categoriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).categoriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.groupId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (expensesRefs)
                        await $_getPrefetchedData<Group, $GroupsTable, Expense>(
                          currentTable: table,
                          referencedTable: $$GroupsTableReferences
                              ._expensesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).expensesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.groupId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (mealsRefs)
                        await $_getPrefetchedData<Group, $GroupsTable, Meal>(
                          currentTable: table,
                          referencedTable: $$GroupsTableReferences
                              ._mealsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GroupsTableReferences(db, table, p0).mealsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.groupId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (depositsRefs)
                        await $_getPrefetchedData<Group, $GroupsTable, Deposit>(
                          currentTable: table,
                          referencedTable: $$GroupsTableReferences
                              ._depositsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).depositsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.groupId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (settlementsRefs)
                        await $_getPrefetchedData<
                          Group,
                          $GroupsTable,
                          Settlement
                        >(
                          currentTable: table,
                          referencedTable: $$GroupsTableReferences
                              ._settlementsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).settlementsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.groupId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (monthsRefs)
                        await $_getPrefetchedData<Group, $GroupsTable, Month>(
                          currentTable: table,
                          referencedTable: $$GroupsTableReferences
                              ._monthsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GroupsTableReferences(db, table, p0).monthsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.groupId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (recurringRulesRefs)
                        await $_getPrefetchedData<
                          Group,
                          $GroupsTable,
                          RecurringRule
                        >(
                          currentTable: table,
                          referencedTable: $$GroupsTableReferences
                              ._recurringRulesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).recurringRulesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.groupId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (mealPollsRefs)
                        await $_getPrefetchedData<
                          Group,
                          $GroupsTable,
                          MealPoll
                        >(
                          currentTable: table,
                          referencedTable: $$GroupsTableReferences
                              ._mealPollsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).mealPollsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.groupId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (mealSlotsRefs)
                        await $_getPrefetchedData<
                          Group,
                          $GroupsTable,
                          MealSlot
                        >(
                          currentTable: table,
                          referencedTable: $$GroupsTableReferences
                              ._mealSlotsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).mealSlotsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.groupId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (bazarDutiesRefs)
                        await $_getPrefetchedData<
                          Group,
                          $GroupsTable,
                          BazarDuty
                        >(
                          currentTable: table,
                          referencedTable: $$GroupsTableReferences
                              ._bazarDutiesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).bazarDutiesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.groupId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (auditLogRefs)
                        await $_getPrefetchedData<
                          Group,
                          $GroupsTable,
                          AuditLogData
                        >(
                          currentTable: table,
                          referencedTable: $$GroupsTableReferences
                              ._auditLogRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).auditLogRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.groupId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$GroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GroupsTable,
      Group,
      $$GroupsTableFilterComposer,
      $$GroupsTableOrderingComposer,
      $$GroupsTableAnnotationComposer,
      $$GroupsTableCreateCompanionBuilder,
      $$GroupsTableUpdateCompanionBuilder,
      (Group, $$GroupsTableReferences),
      Group,
      PrefetchHooks Function({
        bool membersRefs,
        bool categoriesRefs,
        bool expensesRefs,
        bool mealsRefs,
        bool depositsRefs,
        bool settlementsRefs,
        bool monthsRefs,
        bool recurringRulesRefs,
        bool mealPollsRefs,
        bool mealSlotsRefs,
        bool bazarDutiesRefs,
        bool auditLogRefs,
      })
    >;
typedef $$MembersTableCreateCompanionBuilder =
    MembersCompanion Function({
      required String id,
      required String groupId,
      required String name,
      Value<String?> phone,
      Value<String?> photoPath,
      required int joinDate,
      Value<int?> leaveDate,
      Value<bool> active,
      Value<String> role,
      Value<String> permissions,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$MembersTableUpdateCompanionBuilder =
    MembersCompanion Function({
      Value<String> id,
      Value<String> groupId,
      Value<String> name,
      Value<String?> phone,
      Value<String?> photoPath,
      Value<int> joinDate,
      Value<int?> leaveDate,
      Value<bool> active,
      Value<String> role,
      Value<String> permissions,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$MembersTableReferences
    extends BaseReferences<_$AppDatabase, $MembersTable, Member> {
  $$MembersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GroupsTable _groupIdTable(_$AppDatabase db) =>
      db.groups.createAlias('members__group_id__groups__id');

  $$GroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<String>('group_id')!;

    final manager = $$GroupsTableTableManager(
      $_db,
      $_db.groups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ExpensePayersTable, List<ExpensePayer>>
  _expensePayersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.expensePayers,
    aliasName: 'members__id__expense_payers__member_id',
  );

  $$ExpensePayersTableProcessedTableManager get expensePayersRefs {
    final manager = $$ExpensePayersTableTableManager(
      $_db,
      $_db.expensePayers,
    ).filter((f) => f.memberId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensePayersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ExpenseSplitsTable, List<ExpenseSplit>>
  _expenseSplitsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.expenseSplits,
    aliasName: 'members__id__expense_splits__member_id',
  );

  $$ExpenseSplitsTableProcessedTableManager get expenseSplitsRefs {
    final manager = $$ExpenseSplitsTableTableManager(
      $_db,
      $_db.expenseSplits,
    ).filter((f) => f.memberId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_expenseSplitsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MealsTable, List<Meal>> _mealsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.meals,
    aliasName: 'members__id__meals__member_id',
  );

  $$MealsTableProcessedTableManager get mealsRefs {
    final manager = $$MealsTableTableManager(
      $_db,
      $_db.meals,
    ).filter((f) => f.memberId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_mealsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DepositsTable, List<Deposit>> _depositsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.deposits,
    aliasName: 'members__id__deposits__member_id',
  );

  $$DepositsTableProcessedTableManager get depositsRefs {
    final manager = $$DepositsTableTableManager(
      $_db,
      $_db.deposits,
    ).filter((f) => f.memberId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_depositsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SettlementsTable, List<Settlement>>
  _settlementsSentTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.settlements,
    aliasName: 'members__id__settlements__from_member_id',
  );

  $$SettlementsTableProcessedTableManager get settlementsSent {
    final manager = $$SettlementsTableTableManager(
      $_db,
      $_db.settlements,
    ).filter((f) => f.fromMemberId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_settlementsSentTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SettlementsTable, List<Settlement>>
  _settlementsReceivedTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.settlements,
    aliasName: 'members__id__settlements__to_member_id',
  );

  $$SettlementsTableProcessedTableManager get settlementsReceived {
    final manager = $$SettlementsTableTableManager(
      $_db,
      $_db.settlements,
    ).filter((f) => f.toMemberId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _settlementsReceivedTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MealPollsTable, List<MealPoll>>
  _mealPollsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mealPolls,
    aliasName: 'members__id__meal_polls__created_by_member_id',
  );

  $$MealPollsTableProcessedTableManager get mealPollsRefs {
    final manager = $$MealPollsTableTableManager($_db, $_db.mealPolls).filter(
      (f) => f.createdByMemberId.id.sqlEquals($_itemColumn<String>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_mealPollsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MealPollVotesTable, List<MealPollVote>>
  _mealPollVotesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mealPollVotes,
    aliasName: 'members__id__meal_poll_votes__member_id',
  );

  $$MealPollVotesTableProcessedTableManager get mealPollVotesRefs {
    final manager = $$MealPollVotesTableTableManager(
      $_db,
      $_db.mealPollVotes,
    ).filter((f) => f.memberId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_mealPollVotesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MemberMealRoutinesTable, List<MemberMealRoutine>>
  _memberMealRoutinesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.memberMealRoutines,
        aliasName: 'members__id__member_meal_routines__member_id',
      );

  $$MemberMealRoutinesTableProcessedTableManager get memberMealRoutinesRefs {
    final manager = $$MemberMealRoutinesTableTableManager(
      $_db,
      $_db.memberMealRoutines,
    ).filter((f) => f.memberId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _memberMealRoutinesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MealLeavesTable, List<MealLeave>>
  _mealLeavesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mealLeaves,
    aliasName: 'members__id__meal_leaves__member_id',
  );

  $$MealLeavesTableProcessedTableManager get mealLeavesRefs {
    final manager = $$MealLeavesTableTableManager(
      $_db,
      $_db.mealLeaves,
    ).filter((f) => f.memberId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_mealLeavesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BazarDutiesTable, List<BazarDuty>>
  _bazarDutiesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.bazarDuties,
    aliasName: 'members__id__bazar_duties__member_id',
  );

  $$BazarDutiesTableProcessedTableManager get bazarDutiesRefs {
    final manager = $$BazarDutiesTableTableManager(
      $_db,
      $_db.bazarDuties,
    ).filter((f) => f.memberId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_bazarDutiesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MembersTableFilterComposer
    extends Composer<_$AppDatabase, $MembersTable> {
  $$MembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get joinDate => $composableBuilder(
    column: $table.joinDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get leaveDate => $composableBuilder(
    column: $table.leaveDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get permissions => $composableBuilder(
    column: $table.permissions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$GroupsTableFilterComposer get groupId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableFilterComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> expensePayersRefs(
    Expression<bool> Function($$ExpensePayersTableFilterComposer f) f,
  ) {
    final $$ExpensePayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expensePayers,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensePayersTableFilterComposer(
            $db: $db,
            $table: $db.expensePayers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> expenseSplitsRefs(
    Expression<bool> Function($$ExpenseSplitsTableFilterComposer f) f,
  ) {
    final $$ExpenseSplitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenseSplits,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpenseSplitsTableFilterComposer(
            $db: $db,
            $table: $db.expenseSplits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> mealsRefs(
    Expression<bool> Function($$MealsTableFilterComposer f) f,
  ) {
    final $$MealsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableFilterComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> depositsRefs(
    Expression<bool> Function($$DepositsTableFilterComposer f) f,
  ) {
    final $$DepositsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.deposits,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepositsTableFilterComposer(
            $db: $db,
            $table: $db.deposits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> settlementsSent(
    Expression<bool> Function($$SettlementsTableFilterComposer f) f,
  ) {
    final $$SettlementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.settlements,
      getReferencedColumn: (t) => t.fromMemberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SettlementsTableFilterComposer(
            $db: $db,
            $table: $db.settlements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> settlementsReceived(
    Expression<bool> Function($$SettlementsTableFilterComposer f) f,
  ) {
    final $$SettlementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.settlements,
      getReferencedColumn: (t) => t.toMemberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SettlementsTableFilterComposer(
            $db: $db,
            $table: $db.settlements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> mealPollsRefs(
    Expression<bool> Function($$MealPollsTableFilterComposer f) f,
  ) {
    final $$MealPollsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealPolls,
      getReferencedColumn: (t) => t.createdByMemberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealPollsTableFilterComposer(
            $db: $db,
            $table: $db.mealPolls,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> mealPollVotesRefs(
    Expression<bool> Function($$MealPollVotesTableFilterComposer f) f,
  ) {
    final $$MealPollVotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealPollVotes,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealPollVotesTableFilterComposer(
            $db: $db,
            $table: $db.mealPollVotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> memberMealRoutinesRefs(
    Expression<bool> Function($$MemberMealRoutinesTableFilterComposer f) f,
  ) {
    final $$MemberMealRoutinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.memberMealRoutines,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemberMealRoutinesTableFilterComposer(
            $db: $db,
            $table: $db.memberMealRoutines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> mealLeavesRefs(
    Expression<bool> Function($$MealLeavesTableFilterComposer f) f,
  ) {
    final $$MealLeavesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealLeaves,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealLeavesTableFilterComposer(
            $db: $db,
            $table: $db.mealLeaves,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> bazarDutiesRefs(
    Expression<bool> Function($$BazarDutiesTableFilterComposer f) f,
  ) {
    final $$BazarDutiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bazarDuties,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BazarDutiesTableFilterComposer(
            $db: $db,
            $table: $db.bazarDuties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MembersTableOrderingComposer
    extends Composer<_$AppDatabase, $MembersTable> {
  $$MembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get joinDate => $composableBuilder(
    column: $table.joinDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get leaveDate => $composableBuilder(
    column: $table.leaveDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get permissions => $composableBuilder(
    column: $table.permissions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$GroupsTableOrderingComposer get groupId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableOrderingComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $MembersTable> {
  $$MembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<int> get joinDate =>
      $composableBuilder(column: $table.joinDate, builder: (column) => column);

  GeneratedColumn<int> get leaveDate =>
      $composableBuilder(column: $table.leaveDate, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get permissions => $composableBuilder(
    column: $table.permissions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$GroupsTableAnnotationComposer get groupId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> expensePayersRefs<T extends Object>(
    Expression<T> Function($$ExpensePayersTableAnnotationComposer a) f,
  ) {
    final $$ExpensePayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expensePayers,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensePayersTableAnnotationComposer(
            $db: $db,
            $table: $db.expensePayers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> expenseSplitsRefs<T extends Object>(
    Expression<T> Function($$ExpenseSplitsTableAnnotationComposer a) f,
  ) {
    final $$ExpenseSplitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenseSplits,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpenseSplitsTableAnnotationComposer(
            $db: $db,
            $table: $db.expenseSplits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> mealsRefs<T extends Object>(
    Expression<T> Function($$MealsTableAnnotationComposer a) f,
  ) {
    final $$MealsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableAnnotationComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> depositsRefs<T extends Object>(
    Expression<T> Function($$DepositsTableAnnotationComposer a) f,
  ) {
    final $$DepositsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.deposits,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepositsTableAnnotationComposer(
            $db: $db,
            $table: $db.deposits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> settlementsSent<T extends Object>(
    Expression<T> Function($$SettlementsTableAnnotationComposer a) f,
  ) {
    final $$SettlementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.settlements,
      getReferencedColumn: (t) => t.fromMemberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SettlementsTableAnnotationComposer(
            $db: $db,
            $table: $db.settlements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> settlementsReceived<T extends Object>(
    Expression<T> Function($$SettlementsTableAnnotationComposer a) f,
  ) {
    final $$SettlementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.settlements,
      getReferencedColumn: (t) => t.toMemberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SettlementsTableAnnotationComposer(
            $db: $db,
            $table: $db.settlements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> mealPollsRefs<T extends Object>(
    Expression<T> Function($$MealPollsTableAnnotationComposer a) f,
  ) {
    final $$MealPollsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealPolls,
      getReferencedColumn: (t) => t.createdByMemberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealPollsTableAnnotationComposer(
            $db: $db,
            $table: $db.mealPolls,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> mealPollVotesRefs<T extends Object>(
    Expression<T> Function($$MealPollVotesTableAnnotationComposer a) f,
  ) {
    final $$MealPollVotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealPollVotes,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealPollVotesTableAnnotationComposer(
            $db: $db,
            $table: $db.mealPollVotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> memberMealRoutinesRefs<T extends Object>(
    Expression<T> Function($$MemberMealRoutinesTableAnnotationComposer a) f,
  ) {
    final $$MemberMealRoutinesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.memberMealRoutines,
          getReferencedColumn: (t) => t.memberId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MemberMealRoutinesTableAnnotationComposer(
                $db: $db,
                $table: $db.memberMealRoutines,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> mealLeavesRefs<T extends Object>(
    Expression<T> Function($$MealLeavesTableAnnotationComposer a) f,
  ) {
    final $$MealLeavesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealLeaves,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealLeavesTableAnnotationComposer(
            $db: $db,
            $table: $db.mealLeaves,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> bazarDutiesRefs<T extends Object>(
    Expression<T> Function($$BazarDutiesTableAnnotationComposer a) f,
  ) {
    final $$BazarDutiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bazarDuties,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BazarDutiesTableAnnotationComposer(
            $db: $db,
            $table: $db.bazarDuties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MembersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MembersTable,
          Member,
          $$MembersTableFilterComposer,
          $$MembersTableOrderingComposer,
          $$MembersTableAnnotationComposer,
          $$MembersTableCreateCompanionBuilder,
          $$MembersTableUpdateCompanionBuilder,
          (Member, $$MembersTableReferences),
          Member,
          PrefetchHooks Function({
            bool groupId,
            bool expensePayersRefs,
            bool expenseSplitsRefs,
            bool mealsRefs,
            bool depositsRefs,
            bool settlementsSent,
            bool settlementsReceived,
            bool mealPollsRefs,
            bool mealPollVotesRefs,
            bool memberMealRoutinesRefs,
            bool mealLeavesRefs,
            bool bazarDutiesRefs,
          })
        > {
  $$MembersTableTableManager(_$AppDatabase db, $MembersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> groupId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<int> joinDate = const Value.absent(),
                Value<int?> leaveDate = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> permissions = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MembersCompanion(
                id: id,
                groupId: groupId,
                name: name,
                phone: phone,
                photoPath: photoPath,
                joinDate: joinDate,
                leaveDate: leaveDate,
                active: active,
                role: role,
                permissions: permissions,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String groupId,
                required String name,
                Value<String?> phone = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                required int joinDate,
                Value<int?> leaveDate = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> permissions = const Value.absent(),
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => MembersCompanion.insert(
                id: id,
                groupId: groupId,
                name: name,
                phone: phone,
                photoPath: photoPath,
                joinDate: joinDate,
                leaveDate: leaveDate,
                active: active,
                role: role,
                permissions: permissions,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MembersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                groupId = false,
                expensePayersRefs = false,
                expenseSplitsRefs = false,
                mealsRefs = false,
                depositsRefs = false,
                settlementsSent = false,
                settlementsReceived = false,
                mealPollsRefs = false,
                mealPollVotesRefs = false,
                memberMealRoutinesRefs = false,
                mealLeavesRefs = false,
                bazarDutiesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (expensePayersRefs) db.expensePayers,
                    if (expenseSplitsRefs) db.expenseSplits,
                    if (mealsRefs) db.meals,
                    if (depositsRefs) db.deposits,
                    if (settlementsSent) db.settlements,
                    if (settlementsReceived) db.settlements,
                    if (mealPollsRefs) db.mealPolls,
                    if (mealPollVotesRefs) db.mealPollVotes,
                    if (memberMealRoutinesRefs) db.memberMealRoutines,
                    if (mealLeavesRefs) db.mealLeaves,
                    if (bazarDutiesRefs) db.bazarDuties,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (groupId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.groupId,
                                    referencedTable: $$MembersTableReferences
                                        ._groupIdTable(db),
                                    referencedColumn: $$MembersTableReferences
                                        ._groupIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (expensePayersRefs)
                        await $_getPrefetchedData<
                          Member,
                          $MembersTable,
                          ExpensePayer
                        >(
                          currentTable: table,
                          referencedTable: $$MembersTableReferences
                              ._expensePayersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MembersTableReferences(
                                db,
                                table,
                                p0,
                              ).expensePayersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.memberId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (expenseSplitsRefs)
                        await $_getPrefetchedData<
                          Member,
                          $MembersTable,
                          ExpenseSplit
                        >(
                          currentTable: table,
                          referencedTable: $$MembersTableReferences
                              ._expenseSplitsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MembersTableReferences(
                                db,
                                table,
                                p0,
                              ).expenseSplitsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.memberId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (mealsRefs)
                        await $_getPrefetchedData<Member, $MembersTable, Meal>(
                          currentTable: table,
                          referencedTable: $$MembersTableReferences
                              ._mealsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MembersTableReferences(db, table, p0).mealsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.memberId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (depositsRefs)
                        await $_getPrefetchedData<
                          Member,
                          $MembersTable,
                          Deposit
                        >(
                          currentTable: table,
                          referencedTable: $$MembersTableReferences
                              ._depositsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MembersTableReferences(
                                db,
                                table,
                                p0,
                              ).depositsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.memberId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (settlementsSent)
                        await $_getPrefetchedData<
                          Member,
                          $MembersTable,
                          Settlement
                        >(
                          currentTable: table,
                          referencedTable: $$MembersTableReferences
                              ._settlementsSentTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MembersTableReferences(
                                db,
                                table,
                                p0,
                              ).settlementsSent,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.fromMemberId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (settlementsReceived)
                        await $_getPrefetchedData<
                          Member,
                          $MembersTable,
                          Settlement
                        >(
                          currentTable: table,
                          referencedTable: $$MembersTableReferences
                              ._settlementsReceivedTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MembersTableReferences(
                                db,
                                table,
                                p0,
                              ).settlementsReceived,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.toMemberId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (mealPollsRefs)
                        await $_getPrefetchedData<
                          Member,
                          $MembersTable,
                          MealPoll
                        >(
                          currentTable: table,
                          referencedTable: $$MembersTableReferences
                              ._mealPollsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MembersTableReferences(
                                db,
                                table,
                                p0,
                              ).mealPollsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.createdByMemberId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (mealPollVotesRefs)
                        await $_getPrefetchedData<
                          Member,
                          $MembersTable,
                          MealPollVote
                        >(
                          currentTable: table,
                          referencedTable: $$MembersTableReferences
                              ._mealPollVotesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MembersTableReferences(
                                db,
                                table,
                                p0,
                              ).mealPollVotesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.memberId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (memberMealRoutinesRefs)
                        await $_getPrefetchedData<
                          Member,
                          $MembersTable,
                          MemberMealRoutine
                        >(
                          currentTable: table,
                          referencedTable: $$MembersTableReferences
                              ._memberMealRoutinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MembersTableReferences(
                                db,
                                table,
                                p0,
                              ).memberMealRoutinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.memberId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (mealLeavesRefs)
                        await $_getPrefetchedData<
                          Member,
                          $MembersTable,
                          MealLeave
                        >(
                          currentTable: table,
                          referencedTable: $$MembersTableReferences
                              ._mealLeavesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MembersTableReferences(
                                db,
                                table,
                                p0,
                              ).mealLeavesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.memberId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (bazarDutiesRefs)
                        await $_getPrefetchedData<
                          Member,
                          $MembersTable,
                          BazarDuty
                        >(
                          currentTable: table,
                          referencedTable: $$MembersTableReferences
                              ._bazarDutiesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MembersTableReferences(
                                db,
                                table,
                                p0,
                              ).bazarDutiesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.memberId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MembersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MembersTable,
      Member,
      $$MembersTableFilterComposer,
      $$MembersTableOrderingComposer,
      $$MembersTableAnnotationComposer,
      $$MembersTableCreateCompanionBuilder,
      $$MembersTableUpdateCompanionBuilder,
      (Member, $$MembersTableReferences),
      Member,
      PrefetchHooks Function({
        bool groupId,
        bool expensePayersRefs,
        bool expenseSplitsRefs,
        bool mealsRefs,
        bool depositsRefs,
        bool settlementsSent,
        bool settlementsReceived,
        bool mealPollsRefs,
        bool mealPollVotesRefs,
        bool memberMealRoutinesRefs,
        bool mealLeavesRefs,
        bool bazarDutiesRefs,
      })
    >;
typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      required String id,
      Value<String?> groupId,
      required String name,
      Value<String?> defaultKey,
      Value<bool> isMealCategory,
      required String icon,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<String> id,
      Value<String?> groupId,
      Value<String> name,
      Value<String?> defaultKey,
      Value<bool> isMealCategory,
      Value<String> icon,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GroupsTable _groupIdTable(_$AppDatabase db) =>
      db.groups.createAlias('categories__group_id__groups__id');

  $$GroupsTableProcessedTableManager? get groupId {
    final $_column = $_itemColumn<String>('group_id');
    if ($_column == null) return null;
    final manager = $$GroupsTableTableManager(
      $_db,
      $_db.groups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ExpensesTable, List<Expense>> _expensesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.expenses,
    aliasName: 'categories__id__expenses__category_id',
  );

  $$ExpensesTableProcessedTableManager get expensesRefs {
    final manager = $$ExpensesTableTableManager(
      $_db,
      $_db.expenses,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultKey => $composableBuilder(
    column: $table.defaultKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isMealCategory => $composableBuilder(
    column: $table.isMealCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$GroupsTableFilterComposer get groupId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableFilterComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> expensesRefs(
    Expression<bool> Function($$ExpensesTableFilterComposer f) f,
  ) {
    final $$ExpensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableFilterComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultKey => $composableBuilder(
    column: $table.defaultKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isMealCategory => $composableBuilder(
    column: $table.isMealCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$GroupsTableOrderingComposer get groupId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableOrderingComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get defaultKey => $composableBuilder(
    column: $table.defaultKey,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isMealCategory => $composableBuilder(
    column: $table.isMealCategory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$GroupsTableAnnotationComposer get groupId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> expensesRefs<T extends Object>(
    Expression<T> Function($$ExpensesTableAnnotationComposer a) f,
  ) {
    final $$ExpensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableAnnotationComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, $$CategoriesTableReferences),
          Category,
          PrefetchHooks Function({bool groupId, bool expensesRefs})
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> groupId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> defaultKey = const Value.absent(),
                Value<bool> isMealCategory = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                groupId: groupId,
                name: name,
                defaultKey: defaultKey,
                isMealCategory: isMealCategory,
                icon: icon,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> groupId = const Value.absent(),
                required String name,
                Value<String?> defaultKey = const Value.absent(),
                Value<bool> isMealCategory = const Value.absent(),
                required String icon,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                groupId: groupId,
                name: name,
                defaultKey: defaultKey,
                isMealCategory: isMealCategory,
                icon: icon,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({groupId = false, expensesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (expensesRefs) db.expenses],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (groupId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.groupId,
                                referencedTable: $$CategoriesTableReferences
                                    ._groupIdTable(db),
                                referencedColumn: $$CategoriesTableReferences
                                    ._groupIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (expensesRefs)
                    await $_getPrefetchedData<
                      Category,
                      $CategoriesTable,
                      Expense
                    >(
                      currentTable: table,
                      referencedTable: $$CategoriesTableReferences
                          ._expensesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CategoriesTableReferences(
                            db,
                            table,
                            p0,
                          ).expensesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.categoryId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, $$CategoriesTableReferences),
      Category,
      PrefetchHooks Function({bool groupId, bool expensesRefs})
    >;
typedef $$ExpensesTableCreateCompanionBuilder =
    ExpensesCompanion Function({
      required String id,
      required String groupId,
      required int amountPaisa,
      required int date,
      required String categoryId,
      Value<String?> note,
      Value<String?> receiptPath,
      Value<bool> isRecurringInstance,
      Value<bool> deleted,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$ExpensesTableUpdateCompanionBuilder =
    ExpensesCompanion Function({
      Value<String> id,
      Value<String> groupId,
      Value<int> amountPaisa,
      Value<int> date,
      Value<String> categoryId,
      Value<String?> note,
      Value<String?> receiptPath,
      Value<bool> isRecurringInstance,
      Value<bool> deleted,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$ExpensesTableReferences
    extends BaseReferences<_$AppDatabase, $ExpensesTable, Expense> {
  $$ExpensesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GroupsTable _groupIdTable(_$AppDatabase db) =>
      db.groups.createAlias('expenses__group_id__groups__id');

  $$GroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<String>('group_id')!;

    final manager = $$GroupsTableTableManager(
      $_db,
      $_db.groups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('expenses__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<String>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ExpensePayersTable, List<ExpensePayer>>
  _expensePayersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.expensePayers,
    aliasName: 'expenses__id__expense_payers__expense_id',
  );

  $$ExpensePayersTableProcessedTableManager get expensePayersRefs {
    final manager = $$ExpensePayersTableTableManager(
      $_db,
      $_db.expensePayers,
    ).filter((f) => f.expenseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensePayersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ExpenseSplitsTable, List<ExpenseSplit>>
  _expenseSplitsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.expenseSplits,
    aliasName: 'expenses__id__expense_splits__expense_id',
  );

  $$ExpenseSplitsTableProcessedTableManager get expenseSplitsRefs {
    final manager = $$ExpenseSplitsTableTableManager(
      $_db,
      $_db.expenseSplits,
    ).filter((f) => f.expenseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_expenseSplitsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountPaisa => $composableBuilder(
    column: $table.amountPaisa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptPath => $composableBuilder(
    column: $table.receiptPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRecurringInstance => $composableBuilder(
    column: $table.isRecurringInstance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$GroupsTableFilterComposer get groupId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableFilterComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> expensePayersRefs(
    Expression<bool> Function($$ExpensePayersTableFilterComposer f) f,
  ) {
    final $$ExpensePayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expensePayers,
      getReferencedColumn: (t) => t.expenseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensePayersTableFilterComposer(
            $db: $db,
            $table: $db.expensePayers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> expenseSplitsRefs(
    Expression<bool> Function($$ExpenseSplitsTableFilterComposer f) f,
  ) {
    final $$ExpenseSplitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenseSplits,
      getReferencedColumn: (t) => t.expenseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpenseSplitsTableFilterComposer(
            $db: $db,
            $table: $db.expenseSplits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountPaisa => $composableBuilder(
    column: $table.amountPaisa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptPath => $composableBuilder(
    column: $table.receiptPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRecurringInstance => $composableBuilder(
    column: $table.isRecurringInstance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$GroupsTableOrderingComposer get groupId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableOrderingComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountPaisa => $composableBuilder(
    column: $table.amountPaisa,
    builder: (column) => column,
  );

  GeneratedColumn<int> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get receiptPath => $composableBuilder(
    column: $table.receiptPath,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isRecurringInstance => $composableBuilder(
    column: $table.isRecurringInstance,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$GroupsTableAnnotationComposer get groupId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> expensePayersRefs<T extends Object>(
    Expression<T> Function($$ExpensePayersTableAnnotationComposer a) f,
  ) {
    final $$ExpensePayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expensePayers,
      getReferencedColumn: (t) => t.expenseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensePayersTableAnnotationComposer(
            $db: $db,
            $table: $db.expensePayers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> expenseSplitsRefs<T extends Object>(
    Expression<T> Function($$ExpenseSplitsTableAnnotationComposer a) f,
  ) {
    final $$ExpenseSplitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenseSplits,
      getReferencedColumn: (t) => t.expenseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpenseSplitsTableAnnotationComposer(
            $db: $db,
            $table: $db.expenseSplits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpensesTable,
          Expense,
          $$ExpensesTableFilterComposer,
          $$ExpensesTableOrderingComposer,
          $$ExpensesTableAnnotationComposer,
          $$ExpensesTableCreateCompanionBuilder,
          $$ExpensesTableUpdateCompanionBuilder,
          (Expense, $$ExpensesTableReferences),
          Expense,
          PrefetchHooks Function({
            bool groupId,
            bool categoryId,
            bool expensePayersRefs,
            bool expenseSplitsRefs,
          })
        > {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> groupId = const Value.absent(),
                Value<int> amountPaisa = const Value.absent(),
                Value<int> date = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> receiptPath = const Value.absent(),
                Value<bool> isRecurringInstance = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExpensesCompanion(
                id: id,
                groupId: groupId,
                amountPaisa: amountPaisa,
                date: date,
                categoryId: categoryId,
                note: note,
                receiptPath: receiptPath,
                isRecurringInstance: isRecurringInstance,
                deleted: deleted,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String groupId,
                required int amountPaisa,
                required int date,
                required String categoryId,
                Value<String?> note = const Value.absent(),
                Value<String?> receiptPath = const Value.absent(),
                Value<bool> isRecurringInstance = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ExpensesCompanion.insert(
                id: id,
                groupId: groupId,
                amountPaisa: amountPaisa,
                date: date,
                categoryId: categoryId,
                note: note,
                receiptPath: receiptPath,
                isRecurringInstance: isRecurringInstance,
                deleted: deleted,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExpensesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                groupId = false,
                categoryId = false,
                expensePayersRefs = false,
                expenseSplitsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (expensePayersRefs) db.expensePayers,
                    if (expenseSplitsRefs) db.expenseSplits,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (groupId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.groupId,
                                    referencedTable: $$ExpensesTableReferences
                                        ._groupIdTable(db),
                                    referencedColumn: $$ExpensesTableReferences
                                        ._groupIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (categoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoryId,
                                    referencedTable: $$ExpensesTableReferences
                                        ._categoryIdTable(db),
                                    referencedColumn: $$ExpensesTableReferences
                                        ._categoryIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (expensePayersRefs)
                        await $_getPrefetchedData<
                          Expense,
                          $ExpensesTable,
                          ExpensePayer
                        >(
                          currentTable: table,
                          referencedTable: $$ExpensesTableReferences
                              ._expensePayersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExpensesTableReferences(
                                db,
                                table,
                                p0,
                              ).expensePayersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.expenseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (expenseSplitsRefs)
                        await $_getPrefetchedData<
                          Expense,
                          $ExpensesTable,
                          ExpenseSplit
                        >(
                          currentTable: table,
                          referencedTable: $$ExpensesTableReferences
                              ._expenseSplitsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExpensesTableReferences(
                                db,
                                table,
                                p0,
                              ).expenseSplitsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.expenseId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpensesTable,
      Expense,
      $$ExpensesTableFilterComposer,
      $$ExpensesTableOrderingComposer,
      $$ExpensesTableAnnotationComposer,
      $$ExpensesTableCreateCompanionBuilder,
      $$ExpensesTableUpdateCompanionBuilder,
      (Expense, $$ExpensesTableReferences),
      Expense,
      PrefetchHooks Function({
        bool groupId,
        bool categoryId,
        bool expensePayersRefs,
        bool expenseSplitsRefs,
      })
    >;
typedef $$ExpensePayersTableCreateCompanionBuilder =
    ExpensePayersCompanion Function({
      required String expenseId,
      required String memberId,
      required int amountPaidPaisa,
      Value<int> rowid,
    });
typedef $$ExpensePayersTableUpdateCompanionBuilder =
    ExpensePayersCompanion Function({
      Value<String> expenseId,
      Value<String> memberId,
      Value<int> amountPaidPaisa,
      Value<int> rowid,
    });

final class $$ExpensePayersTableReferences
    extends BaseReferences<_$AppDatabase, $ExpensePayersTable, ExpensePayer> {
  $$ExpensePayersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ExpensesTable _expenseIdTable(_$AppDatabase db) =>
      db.expenses.createAlias('expense_payers__expense_id__expenses__id');

  $$ExpensesTableProcessedTableManager get expenseId {
    final $_column = $_itemColumn<String>('expense_id')!;

    final manager = $$ExpensesTableTableManager(
      $_db,
      $_db.expenses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_expenseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MembersTable _memberIdTable(_$AppDatabase db) =>
      db.members.createAlias('expense_payers__member_id__members__id');

  $$MembersTableProcessedTableManager get memberId {
    final $_column = $_itemColumn<String>('member_id')!;

    final manager = $$MembersTableTableManager(
      $_db,
      $_db.members,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExpensePayersTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensePayersTable> {
  $$ExpensePayersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get amountPaidPaisa => $composableBuilder(
    column: $table.amountPaidPaisa,
    builder: (column) => ColumnFilters(column),
  );

  $$ExpensesTableFilterComposer get expenseId {
    final $$ExpensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.expenseId,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableFilterComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableFilterComposer get memberId {
    final $$MembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableFilterComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensePayersTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensePayersTable> {
  $$ExpensePayersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get amountPaidPaisa => $composableBuilder(
    column: $table.amountPaidPaisa,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExpensesTableOrderingComposer get expenseId {
    final $$ExpensesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.expenseId,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableOrderingComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableOrderingComposer get memberId {
    final $$MembersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableOrderingComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensePayersTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensePayersTable> {
  $$ExpensePayersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get amountPaidPaisa => $composableBuilder(
    column: $table.amountPaidPaisa,
    builder: (column) => column,
  );

  $$ExpensesTableAnnotationComposer get expenseId {
    final $$ExpensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.expenseId,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableAnnotationComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableAnnotationComposer get memberId {
    final $$MembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableAnnotationComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensePayersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpensePayersTable,
          ExpensePayer,
          $$ExpensePayersTableFilterComposer,
          $$ExpensePayersTableOrderingComposer,
          $$ExpensePayersTableAnnotationComposer,
          $$ExpensePayersTableCreateCompanionBuilder,
          $$ExpensePayersTableUpdateCompanionBuilder,
          (ExpensePayer, $$ExpensePayersTableReferences),
          ExpensePayer,
          PrefetchHooks Function({bool expenseId, bool memberId})
        > {
  $$ExpensePayersTableTableManager(_$AppDatabase db, $ExpensePayersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensePayersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensePayersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensePayersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> expenseId = const Value.absent(),
                Value<String> memberId = const Value.absent(),
                Value<int> amountPaidPaisa = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExpensePayersCompanion(
                expenseId: expenseId,
                memberId: memberId,
                amountPaidPaisa: amountPaidPaisa,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String expenseId,
                required String memberId,
                required int amountPaidPaisa,
                Value<int> rowid = const Value.absent(),
              }) => ExpensePayersCompanion.insert(
                expenseId: expenseId,
                memberId: memberId,
                amountPaidPaisa: amountPaidPaisa,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExpensePayersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({expenseId = false, memberId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (expenseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.expenseId,
                                referencedTable: $$ExpensePayersTableReferences
                                    ._expenseIdTable(db),
                                referencedColumn: $$ExpensePayersTableReferences
                                    ._expenseIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (memberId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.memberId,
                                referencedTable: $$ExpensePayersTableReferences
                                    ._memberIdTable(db),
                                referencedColumn: $$ExpensePayersTableReferences
                                    ._memberIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ExpensePayersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpensePayersTable,
      ExpensePayer,
      $$ExpensePayersTableFilterComposer,
      $$ExpensePayersTableOrderingComposer,
      $$ExpensePayersTableAnnotationComposer,
      $$ExpensePayersTableCreateCompanionBuilder,
      $$ExpensePayersTableUpdateCompanionBuilder,
      (ExpensePayer, $$ExpensePayersTableReferences),
      ExpensePayer,
      PrefetchHooks Function({bool expenseId, bool memberId})
    >;
typedef $$ExpenseSplitsTableCreateCompanionBuilder =
    ExpenseSplitsCompanion Function({
      required String expenseId,
      required String memberId,
      required int amountPaisa,
      required String splitType,
      Value<int> rowid,
    });
typedef $$ExpenseSplitsTableUpdateCompanionBuilder =
    ExpenseSplitsCompanion Function({
      Value<String> expenseId,
      Value<String> memberId,
      Value<int> amountPaisa,
      Value<String> splitType,
      Value<int> rowid,
    });

final class $$ExpenseSplitsTableReferences
    extends BaseReferences<_$AppDatabase, $ExpenseSplitsTable, ExpenseSplit> {
  $$ExpenseSplitsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ExpensesTable _expenseIdTable(_$AppDatabase db) =>
      db.expenses.createAlias('expense_splits__expense_id__expenses__id');

  $$ExpensesTableProcessedTableManager get expenseId {
    final $_column = $_itemColumn<String>('expense_id')!;

    final manager = $$ExpensesTableTableManager(
      $_db,
      $_db.expenses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_expenseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MembersTable _memberIdTable(_$AppDatabase db) =>
      db.members.createAlias('expense_splits__member_id__members__id');

  $$MembersTableProcessedTableManager get memberId {
    final $_column = $_itemColumn<String>('member_id')!;

    final manager = $$MembersTableTableManager(
      $_db,
      $_db.members,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExpenseSplitsTableFilterComposer
    extends Composer<_$AppDatabase, $ExpenseSplitsTable> {
  $$ExpenseSplitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get amountPaisa => $composableBuilder(
    column: $table.amountPaisa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get splitType => $composableBuilder(
    column: $table.splitType,
    builder: (column) => ColumnFilters(column),
  );

  $$ExpensesTableFilterComposer get expenseId {
    final $$ExpensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.expenseId,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableFilterComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableFilterComposer get memberId {
    final $$MembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableFilterComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpenseSplitsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpenseSplitsTable> {
  $$ExpenseSplitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get amountPaisa => $composableBuilder(
    column: $table.amountPaisa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get splitType => $composableBuilder(
    column: $table.splitType,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExpensesTableOrderingComposer get expenseId {
    final $$ExpensesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.expenseId,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableOrderingComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableOrderingComposer get memberId {
    final $$MembersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableOrderingComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpenseSplitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpenseSplitsTable> {
  $$ExpenseSplitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get amountPaisa => $composableBuilder(
    column: $table.amountPaisa,
    builder: (column) => column,
  );

  GeneratedColumn<String> get splitType =>
      $composableBuilder(column: $table.splitType, builder: (column) => column);

  $$ExpensesTableAnnotationComposer get expenseId {
    final $$ExpensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.expenseId,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableAnnotationComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableAnnotationComposer get memberId {
    final $$MembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableAnnotationComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpenseSplitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpenseSplitsTable,
          ExpenseSplit,
          $$ExpenseSplitsTableFilterComposer,
          $$ExpenseSplitsTableOrderingComposer,
          $$ExpenseSplitsTableAnnotationComposer,
          $$ExpenseSplitsTableCreateCompanionBuilder,
          $$ExpenseSplitsTableUpdateCompanionBuilder,
          (ExpenseSplit, $$ExpenseSplitsTableReferences),
          ExpenseSplit,
          PrefetchHooks Function({bool expenseId, bool memberId})
        > {
  $$ExpenseSplitsTableTableManager(_$AppDatabase db, $ExpenseSplitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpenseSplitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpenseSplitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpenseSplitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> expenseId = const Value.absent(),
                Value<String> memberId = const Value.absent(),
                Value<int> amountPaisa = const Value.absent(),
                Value<String> splitType = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExpenseSplitsCompanion(
                expenseId: expenseId,
                memberId: memberId,
                amountPaisa: amountPaisa,
                splitType: splitType,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String expenseId,
                required String memberId,
                required int amountPaisa,
                required String splitType,
                Value<int> rowid = const Value.absent(),
              }) => ExpenseSplitsCompanion.insert(
                expenseId: expenseId,
                memberId: memberId,
                amountPaisa: amountPaisa,
                splitType: splitType,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExpenseSplitsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({expenseId = false, memberId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (expenseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.expenseId,
                                referencedTable: $$ExpenseSplitsTableReferences
                                    ._expenseIdTable(db),
                                referencedColumn: $$ExpenseSplitsTableReferences
                                    ._expenseIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (memberId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.memberId,
                                referencedTable: $$ExpenseSplitsTableReferences
                                    ._memberIdTable(db),
                                referencedColumn: $$ExpenseSplitsTableReferences
                                    ._memberIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ExpenseSplitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpenseSplitsTable,
      ExpenseSplit,
      $$ExpenseSplitsTableFilterComposer,
      $$ExpenseSplitsTableOrderingComposer,
      $$ExpenseSplitsTableAnnotationComposer,
      $$ExpenseSplitsTableCreateCompanionBuilder,
      $$ExpenseSplitsTableUpdateCompanionBuilder,
      (ExpenseSplit, $$ExpenseSplitsTableReferences),
      ExpenseSplit,
      PrefetchHooks Function({bool expenseId, bool memberId})
    >;
typedef $$MealsTableCreateCompanionBuilder =
    MealsCompanion Function({
      required String id,
      required String groupId,
      required String memberId,
      required int date,
      Value<double> count,
      Value<double> guestCount,
      Value<String?> slotsJson,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$MealsTableUpdateCompanionBuilder =
    MealsCompanion Function({
      Value<String> id,
      Value<String> groupId,
      Value<String> memberId,
      Value<int> date,
      Value<double> count,
      Value<double> guestCount,
      Value<String?> slotsJson,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$MealsTableReferences
    extends BaseReferences<_$AppDatabase, $MealsTable, Meal> {
  $$MealsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GroupsTable _groupIdTable(_$AppDatabase db) =>
      db.groups.createAlias('meals__group_id__groups__id');

  $$GroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<String>('group_id')!;

    final manager = $$GroupsTableTableManager(
      $_db,
      $_db.groups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MembersTable _memberIdTable(_$AppDatabase db) =>
      db.members.createAlias('meals__member_id__members__id');

  $$MembersTableProcessedTableManager get memberId {
    final $_column = $_itemColumn<String>('member_id')!;

    final manager = $$MembersTableTableManager(
      $_db,
      $_db.members,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MealsTableFilterComposer extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get guestCount => $composableBuilder(
    column: $table.guestCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slotsJson => $composableBuilder(
    column: $table.slotsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$GroupsTableFilterComposer get groupId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableFilterComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableFilterComposer get memberId {
    final $$MembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableFilterComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealsTableOrderingComposer
    extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get guestCount => $composableBuilder(
    column: $table.guestCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slotsJson => $composableBuilder(
    column: $table.slotsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$GroupsTableOrderingComposer get groupId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableOrderingComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableOrderingComposer get memberId {
    final $$MembersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableOrderingComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);

  GeneratedColumn<double> get guestCount => $composableBuilder(
    column: $table.guestCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get slotsJson =>
      $composableBuilder(column: $table.slotsJson, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$GroupsTableAnnotationComposer get groupId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableAnnotationComposer get memberId {
    final $$MembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableAnnotationComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealsTable,
          Meal,
          $$MealsTableFilterComposer,
          $$MealsTableOrderingComposer,
          $$MealsTableAnnotationComposer,
          $$MealsTableCreateCompanionBuilder,
          $$MealsTableUpdateCompanionBuilder,
          (Meal, $$MealsTableReferences),
          Meal,
          PrefetchHooks Function({bool groupId, bool memberId})
        > {
  $$MealsTableTableManager(_$AppDatabase db, $MealsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> groupId = const Value.absent(),
                Value<String> memberId = const Value.absent(),
                Value<int> date = const Value.absent(),
                Value<double> count = const Value.absent(),
                Value<double> guestCount = const Value.absent(),
                Value<String?> slotsJson = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MealsCompanion(
                id: id,
                groupId: groupId,
                memberId: memberId,
                date: date,
                count: count,
                guestCount: guestCount,
                slotsJson: slotsJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String groupId,
                required String memberId,
                required int date,
                Value<double> count = const Value.absent(),
                Value<double> guestCount = const Value.absent(),
                Value<String?> slotsJson = const Value.absent(),
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => MealsCompanion.insert(
                id: id,
                groupId: groupId,
                memberId: memberId,
                date: date,
                count: count,
                guestCount: guestCount,
                slotsJson: slotsJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$MealsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({groupId = false, memberId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (groupId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.groupId,
                                referencedTable: $$MealsTableReferences
                                    ._groupIdTable(db),
                                referencedColumn: $$MealsTableReferences
                                    ._groupIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (memberId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.memberId,
                                referencedTable: $$MealsTableReferences
                                    ._memberIdTable(db),
                                referencedColumn: $$MealsTableReferences
                                    ._memberIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MealsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealsTable,
      Meal,
      $$MealsTableFilterComposer,
      $$MealsTableOrderingComposer,
      $$MealsTableAnnotationComposer,
      $$MealsTableCreateCompanionBuilder,
      $$MealsTableUpdateCompanionBuilder,
      (Meal, $$MealsTableReferences),
      Meal,
      PrefetchHooks Function({bool groupId, bool memberId})
    >;
typedef $$DepositsTableCreateCompanionBuilder =
    DepositsCompanion Function({
      required String id,
      required String groupId,
      required String memberId,
      required int amountPaisa,
      required int date,
      Value<String?> note,
      Value<String> purpose,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$DepositsTableUpdateCompanionBuilder =
    DepositsCompanion Function({
      Value<String> id,
      Value<String> groupId,
      Value<String> memberId,
      Value<int> amountPaisa,
      Value<int> date,
      Value<String?> note,
      Value<String> purpose,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$DepositsTableReferences
    extends BaseReferences<_$AppDatabase, $DepositsTable, Deposit> {
  $$DepositsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GroupsTable _groupIdTable(_$AppDatabase db) =>
      db.groups.createAlias('deposits__group_id__groups__id');

  $$GroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<String>('group_id')!;

    final manager = $$GroupsTableTableManager(
      $_db,
      $_db.groups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MembersTable _memberIdTable(_$AppDatabase db) =>
      db.members.createAlias('deposits__member_id__members__id');

  $$MembersTableProcessedTableManager get memberId {
    final $_column = $_itemColumn<String>('member_id')!;

    final manager = $$MembersTableTableManager(
      $_db,
      $_db.members,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DepositsTableFilterComposer
    extends Composer<_$AppDatabase, $DepositsTable> {
  $$DepositsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountPaisa => $composableBuilder(
    column: $table.amountPaisa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purpose => $composableBuilder(
    column: $table.purpose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$GroupsTableFilterComposer get groupId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableFilterComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableFilterComposer get memberId {
    final $$MembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableFilterComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DepositsTableOrderingComposer
    extends Composer<_$AppDatabase, $DepositsTable> {
  $$DepositsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountPaisa => $composableBuilder(
    column: $table.amountPaisa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purpose => $composableBuilder(
    column: $table.purpose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$GroupsTableOrderingComposer get groupId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableOrderingComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableOrderingComposer get memberId {
    final $$MembersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableOrderingComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DepositsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DepositsTable> {
  $$DepositsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountPaisa => $composableBuilder(
    column: $table.amountPaisa,
    builder: (column) => column,
  );

  GeneratedColumn<int> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get purpose =>
      $composableBuilder(column: $table.purpose, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$GroupsTableAnnotationComposer get groupId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableAnnotationComposer get memberId {
    final $$MembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableAnnotationComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DepositsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DepositsTable,
          Deposit,
          $$DepositsTableFilterComposer,
          $$DepositsTableOrderingComposer,
          $$DepositsTableAnnotationComposer,
          $$DepositsTableCreateCompanionBuilder,
          $$DepositsTableUpdateCompanionBuilder,
          (Deposit, $$DepositsTableReferences),
          Deposit,
          PrefetchHooks Function({bool groupId, bool memberId})
        > {
  $$DepositsTableTableManager(_$AppDatabase db, $DepositsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DepositsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DepositsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DepositsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> groupId = const Value.absent(),
                Value<String> memberId = const Value.absent(),
                Value<int> amountPaisa = const Value.absent(),
                Value<int> date = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String> purpose = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DepositsCompanion(
                id: id,
                groupId: groupId,
                memberId: memberId,
                amountPaisa: amountPaisa,
                date: date,
                note: note,
                purpose: purpose,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String groupId,
                required String memberId,
                required int amountPaisa,
                required int date,
                Value<String?> note = const Value.absent(),
                Value<String> purpose = const Value.absent(),
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => DepositsCompanion.insert(
                id: id,
                groupId: groupId,
                memberId: memberId,
                amountPaisa: amountPaisa,
                date: date,
                note: note,
                purpose: purpose,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DepositsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({groupId = false, memberId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (groupId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.groupId,
                                referencedTable: $$DepositsTableReferences
                                    ._groupIdTable(db),
                                referencedColumn: $$DepositsTableReferences
                                    ._groupIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (memberId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.memberId,
                                referencedTable: $$DepositsTableReferences
                                    ._memberIdTable(db),
                                referencedColumn: $$DepositsTableReferences
                                    ._memberIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DepositsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DepositsTable,
      Deposit,
      $$DepositsTableFilterComposer,
      $$DepositsTableOrderingComposer,
      $$DepositsTableAnnotationComposer,
      $$DepositsTableCreateCompanionBuilder,
      $$DepositsTableUpdateCompanionBuilder,
      (Deposit, $$DepositsTableReferences),
      Deposit,
      PrefetchHooks Function({bool groupId, bool memberId})
    >;
typedef $$SettlementsTableCreateCompanionBuilder =
    SettlementsCompanion Function({
      required String id,
      required String groupId,
      required String fromMemberId,
      required String toMemberId,
      required int amountPaisa,
      required int date,
      Value<String?> method,
      Value<String?> note,
      Value<String> purpose,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$SettlementsTableUpdateCompanionBuilder =
    SettlementsCompanion Function({
      Value<String> id,
      Value<String> groupId,
      Value<String> fromMemberId,
      Value<String> toMemberId,
      Value<int> amountPaisa,
      Value<int> date,
      Value<String?> method,
      Value<String?> note,
      Value<String> purpose,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$SettlementsTableReferences
    extends BaseReferences<_$AppDatabase, $SettlementsTable, Settlement> {
  $$SettlementsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GroupsTable _groupIdTable(_$AppDatabase db) =>
      db.groups.createAlias('settlements__group_id__groups__id');

  $$GroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<String>('group_id')!;

    final manager = $$GroupsTableTableManager(
      $_db,
      $_db.groups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MembersTable _fromMemberIdTable(_$AppDatabase db) =>
      db.members.createAlias('settlements__from_member_id__members__id');

  $$MembersTableProcessedTableManager get fromMemberId {
    final $_column = $_itemColumn<String>('from_member_id')!;

    final manager = $$MembersTableTableManager(
      $_db,
      $_db.members,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_fromMemberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MembersTable _toMemberIdTable(_$AppDatabase db) =>
      db.members.createAlias('settlements__to_member_id__members__id');

  $$MembersTableProcessedTableManager get toMemberId {
    final $_column = $_itemColumn<String>('to_member_id')!;

    final manager = $$MembersTableTableManager(
      $_db,
      $_db.members,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_toMemberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SettlementsTableFilterComposer
    extends Composer<_$AppDatabase, $SettlementsTable> {
  $$SettlementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountPaisa => $composableBuilder(
    column: $table.amountPaisa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purpose => $composableBuilder(
    column: $table.purpose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$GroupsTableFilterComposer get groupId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableFilterComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableFilterComposer get fromMemberId {
    final $$MembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromMemberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableFilterComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableFilterComposer get toMemberId {
    final $$MembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toMemberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableFilterComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SettlementsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettlementsTable> {
  $$SettlementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountPaisa => $composableBuilder(
    column: $table.amountPaisa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purpose => $composableBuilder(
    column: $table.purpose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$GroupsTableOrderingComposer get groupId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableOrderingComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableOrderingComposer get fromMemberId {
    final $$MembersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromMemberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableOrderingComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableOrderingComposer get toMemberId {
    final $$MembersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toMemberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableOrderingComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SettlementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettlementsTable> {
  $$SettlementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountPaisa => $composableBuilder(
    column: $table.amountPaisa,
    builder: (column) => column,
  );

  GeneratedColumn<int> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get purpose =>
      $composableBuilder(column: $table.purpose, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$GroupsTableAnnotationComposer get groupId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableAnnotationComposer get fromMemberId {
    final $$MembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromMemberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableAnnotationComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableAnnotationComposer get toMemberId {
    final $$MembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toMemberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableAnnotationComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SettlementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettlementsTable,
          Settlement,
          $$SettlementsTableFilterComposer,
          $$SettlementsTableOrderingComposer,
          $$SettlementsTableAnnotationComposer,
          $$SettlementsTableCreateCompanionBuilder,
          $$SettlementsTableUpdateCompanionBuilder,
          (Settlement, $$SettlementsTableReferences),
          Settlement,
          PrefetchHooks Function({
            bool groupId,
            bool fromMemberId,
            bool toMemberId,
          })
        > {
  $$SettlementsTableTableManager(_$AppDatabase db, $SettlementsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettlementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettlementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettlementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> groupId = const Value.absent(),
                Value<String> fromMemberId = const Value.absent(),
                Value<String> toMemberId = const Value.absent(),
                Value<int> amountPaisa = const Value.absent(),
                Value<int> date = const Value.absent(),
                Value<String?> method = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String> purpose = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettlementsCompanion(
                id: id,
                groupId: groupId,
                fromMemberId: fromMemberId,
                toMemberId: toMemberId,
                amountPaisa: amountPaisa,
                date: date,
                method: method,
                note: note,
                purpose: purpose,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String groupId,
                required String fromMemberId,
                required String toMemberId,
                required int amountPaisa,
                required int date,
                Value<String?> method = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String> purpose = const Value.absent(),
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SettlementsCompanion.insert(
                id: id,
                groupId: groupId,
                fromMemberId: fromMemberId,
                toMemberId: toMemberId,
                amountPaisa: amountPaisa,
                date: date,
                method: method,
                note: note,
                purpose: purpose,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SettlementsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({groupId = false, fromMemberId = false, toMemberId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (groupId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.groupId,
                                    referencedTable:
                                        $$SettlementsTableReferences
                                            ._groupIdTable(db),
                                    referencedColumn:
                                        $$SettlementsTableReferences
                                            ._groupIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (fromMemberId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.fromMemberId,
                                    referencedTable:
                                        $$SettlementsTableReferences
                                            ._fromMemberIdTable(db),
                                    referencedColumn:
                                        $$SettlementsTableReferences
                                            ._fromMemberIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (toMemberId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.toMemberId,
                                    referencedTable:
                                        $$SettlementsTableReferences
                                            ._toMemberIdTable(db),
                                    referencedColumn:
                                        $$SettlementsTableReferences
                                            ._toMemberIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$SettlementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettlementsTable,
      Settlement,
      $$SettlementsTableFilterComposer,
      $$SettlementsTableOrderingComposer,
      $$SettlementsTableAnnotationComposer,
      $$SettlementsTableCreateCompanionBuilder,
      $$SettlementsTableUpdateCompanionBuilder,
      (Settlement, $$SettlementsTableReferences),
      Settlement,
      PrefetchHooks Function({bool groupId, bool fromMemberId, bool toMemberId})
    >;
typedef $$MonthsTableCreateCompanionBuilder =
    MonthsCompanion Function({
      required String id,
      required String groupId,
      required String yearMonth,
      Value<int?> closedAt,
      Value<int?> mealRatePaisa,
      Value<String?> snapshotJson,
      Value<int?> mealClosedAt,
      Value<String?> mealSnapshotJson,
      Value<int> rowid,
    });
typedef $$MonthsTableUpdateCompanionBuilder =
    MonthsCompanion Function({
      Value<String> id,
      Value<String> groupId,
      Value<String> yearMonth,
      Value<int?> closedAt,
      Value<int?> mealRatePaisa,
      Value<String?> snapshotJson,
      Value<int?> mealClosedAt,
      Value<String?> mealSnapshotJson,
      Value<int> rowid,
    });

final class $$MonthsTableReferences
    extends BaseReferences<_$AppDatabase, $MonthsTable, Month> {
  $$MonthsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GroupsTable _groupIdTable(_$AppDatabase db) =>
      db.groups.createAlias('months__group_id__groups__id');

  $$GroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<String>('group_id')!;

    final manager = $$GroupsTableTableManager(
      $_db,
      $_db.groups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MonthsTableFilterComposer
    extends Composer<_$AppDatabase, $MonthsTable> {
  $$MonthsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get yearMonth => $composableBuilder(
    column: $table.yearMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mealRatePaisa => $composableBuilder(
    column: $table.mealRatePaisa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get snapshotJson => $composableBuilder(
    column: $table.snapshotJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mealClosedAt => $composableBuilder(
    column: $table.mealClosedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealSnapshotJson => $composableBuilder(
    column: $table.mealSnapshotJson,
    builder: (column) => ColumnFilters(column),
  );

  $$GroupsTableFilterComposer get groupId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableFilterComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MonthsTableOrderingComposer
    extends Composer<_$AppDatabase, $MonthsTable> {
  $$MonthsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get yearMonth => $composableBuilder(
    column: $table.yearMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mealRatePaisa => $composableBuilder(
    column: $table.mealRatePaisa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get snapshotJson => $composableBuilder(
    column: $table.snapshotJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mealClosedAt => $composableBuilder(
    column: $table.mealClosedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealSnapshotJson => $composableBuilder(
    column: $table.mealSnapshotJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$GroupsTableOrderingComposer get groupId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableOrderingComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MonthsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MonthsTable> {
  $$MonthsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get yearMonth =>
      $composableBuilder(column: $table.yearMonth, builder: (column) => column);

  GeneratedColumn<int> get closedAt =>
      $composableBuilder(column: $table.closedAt, builder: (column) => column);

  GeneratedColumn<int> get mealRatePaisa => $composableBuilder(
    column: $table.mealRatePaisa,
    builder: (column) => column,
  );

  GeneratedColumn<String> get snapshotJson => $composableBuilder(
    column: $table.snapshotJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get mealClosedAt => $composableBuilder(
    column: $table.mealClosedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mealSnapshotJson => $composableBuilder(
    column: $table.mealSnapshotJson,
    builder: (column) => column,
  );

  $$GroupsTableAnnotationComposer get groupId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MonthsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MonthsTable,
          Month,
          $$MonthsTableFilterComposer,
          $$MonthsTableOrderingComposer,
          $$MonthsTableAnnotationComposer,
          $$MonthsTableCreateCompanionBuilder,
          $$MonthsTableUpdateCompanionBuilder,
          (Month, $$MonthsTableReferences),
          Month,
          PrefetchHooks Function({bool groupId})
        > {
  $$MonthsTableTableManager(_$AppDatabase db, $MonthsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MonthsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MonthsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MonthsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> groupId = const Value.absent(),
                Value<String> yearMonth = const Value.absent(),
                Value<int?> closedAt = const Value.absent(),
                Value<int?> mealRatePaisa = const Value.absent(),
                Value<String?> snapshotJson = const Value.absent(),
                Value<int?> mealClosedAt = const Value.absent(),
                Value<String?> mealSnapshotJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MonthsCompanion(
                id: id,
                groupId: groupId,
                yearMonth: yearMonth,
                closedAt: closedAt,
                mealRatePaisa: mealRatePaisa,
                snapshotJson: snapshotJson,
                mealClosedAt: mealClosedAt,
                mealSnapshotJson: mealSnapshotJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String groupId,
                required String yearMonth,
                Value<int?> closedAt = const Value.absent(),
                Value<int?> mealRatePaisa = const Value.absent(),
                Value<String?> snapshotJson = const Value.absent(),
                Value<int?> mealClosedAt = const Value.absent(),
                Value<String?> mealSnapshotJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MonthsCompanion.insert(
                id: id,
                groupId: groupId,
                yearMonth: yearMonth,
                closedAt: closedAt,
                mealRatePaisa: mealRatePaisa,
                snapshotJson: snapshotJson,
                mealClosedAt: mealClosedAt,
                mealSnapshotJson: mealSnapshotJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$MonthsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({groupId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (groupId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.groupId,
                                referencedTable: $$MonthsTableReferences
                                    ._groupIdTable(db),
                                referencedColumn: $$MonthsTableReferences
                                    ._groupIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MonthsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MonthsTable,
      Month,
      $$MonthsTableFilterComposer,
      $$MonthsTableOrderingComposer,
      $$MonthsTableAnnotationComposer,
      $$MonthsTableCreateCompanionBuilder,
      $$MonthsTableUpdateCompanionBuilder,
      (Month, $$MonthsTableReferences),
      Month,
      PrefetchHooks Function({bool groupId})
    >;
typedef $$RecurringRulesTableCreateCompanionBuilder =
    RecurringRulesCompanion Function({
      required String id,
      required String groupId,
      required String templateJson,
      required int dayOfMonth,
      Value<bool> active,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$RecurringRulesTableUpdateCompanionBuilder =
    RecurringRulesCompanion Function({
      Value<String> id,
      Value<String> groupId,
      Value<String> templateJson,
      Value<int> dayOfMonth,
      Value<bool> active,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$RecurringRulesTableReferences
    extends BaseReferences<_$AppDatabase, $RecurringRulesTable, RecurringRule> {
  $$RecurringRulesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $GroupsTable _groupIdTable(_$AppDatabase db) =>
      db.groups.createAlias('recurring_rules__group_id__groups__id');

  $$GroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<String>('group_id')!;

    final manager = $$GroupsTableTableManager(
      $_db,
      $_db.groups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RecurringRulesTableFilterComposer
    extends Composer<_$AppDatabase, $RecurringRulesTable> {
  $$RecurringRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get templateJson => $composableBuilder(
    column: $table.templateJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayOfMonth => $composableBuilder(
    column: $table.dayOfMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$GroupsTableFilterComposer get groupId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableFilterComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecurringRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurringRulesTable> {
  $$RecurringRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get templateJson => $composableBuilder(
    column: $table.templateJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayOfMonth => $composableBuilder(
    column: $table.dayOfMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$GroupsTableOrderingComposer get groupId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableOrderingComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecurringRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurringRulesTable> {
  $$RecurringRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get templateJson => $composableBuilder(
    column: $table.templateJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dayOfMonth => $composableBuilder(
    column: $table.dayOfMonth,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$GroupsTableAnnotationComposer get groupId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecurringRulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecurringRulesTable,
          RecurringRule,
          $$RecurringRulesTableFilterComposer,
          $$RecurringRulesTableOrderingComposer,
          $$RecurringRulesTableAnnotationComposer,
          $$RecurringRulesTableCreateCompanionBuilder,
          $$RecurringRulesTableUpdateCompanionBuilder,
          (RecurringRule, $$RecurringRulesTableReferences),
          RecurringRule,
          PrefetchHooks Function({bool groupId})
        > {
  $$RecurringRulesTableTableManager(
    _$AppDatabase db,
    $RecurringRulesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurringRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecurringRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecurringRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> groupId = const Value.absent(),
                Value<String> templateJson = const Value.absent(),
                Value<int> dayOfMonth = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecurringRulesCompanion(
                id: id,
                groupId: groupId,
                templateJson: templateJson,
                dayOfMonth: dayOfMonth,
                active: active,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String groupId,
                required String templateJson,
                required int dayOfMonth,
                Value<bool> active = const Value.absent(),
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RecurringRulesCompanion.insert(
                id: id,
                groupId: groupId,
                templateJson: templateJson,
                dayOfMonth: dayOfMonth,
                active: active,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecurringRulesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({groupId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (groupId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.groupId,
                                referencedTable: $$RecurringRulesTableReferences
                                    ._groupIdTable(db),
                                referencedColumn:
                                    $$RecurringRulesTableReferences
                                        ._groupIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RecurringRulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecurringRulesTable,
      RecurringRule,
      $$RecurringRulesTableFilterComposer,
      $$RecurringRulesTableOrderingComposer,
      $$RecurringRulesTableAnnotationComposer,
      $$RecurringRulesTableCreateCompanionBuilder,
      $$RecurringRulesTableUpdateCompanionBuilder,
      (RecurringRule, $$RecurringRulesTableReferences),
      RecurringRule,
      PrefetchHooks Function({bool groupId})
    >;
typedef $$MealPollsTableCreateCompanionBuilder =
    MealPollsCompanion Function({
      required String id,
      required String groupId,
      required int date,
      required String type,
      Value<String?> title,
      Value<String?> optionsJson,
      required int closeAt,
      required String createdByMemberId,
      Value<String?> nonVoterPolicy,
      Value<bool> closed,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$MealPollsTableUpdateCompanionBuilder =
    MealPollsCompanion Function({
      Value<String> id,
      Value<String> groupId,
      Value<int> date,
      Value<String> type,
      Value<String?> title,
      Value<String?> optionsJson,
      Value<int> closeAt,
      Value<String> createdByMemberId,
      Value<String?> nonVoterPolicy,
      Value<bool> closed,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$MealPollsTableReferences
    extends BaseReferences<_$AppDatabase, $MealPollsTable, MealPoll> {
  $$MealPollsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GroupsTable _groupIdTable(_$AppDatabase db) =>
      db.groups.createAlias('meal_polls__group_id__groups__id');

  $$GroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<String>('group_id')!;

    final manager = $$GroupsTableTableManager(
      $_db,
      $_db.groups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MembersTable _createdByMemberIdTable(_$AppDatabase db) =>
      db.members.createAlias('meal_polls__created_by_member_id__members__id');

  $$MembersTableProcessedTableManager get createdByMemberId {
    final $_column = $_itemColumn<String>('created_by_member_id')!;

    final manager = $$MembersTableTableManager(
      $_db,
      $_db.members,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_createdByMemberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MealPollVotesTable, List<MealPollVote>>
  _mealPollVotesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mealPollVotes,
    aliasName: 'meal_polls__id__meal_poll_votes__poll_id',
  );

  $$MealPollVotesTableProcessedTableManager get mealPollVotesRefs {
    final manager = $$MealPollVotesTableTableManager(
      $_db,
      $_db.mealPollVotes,
    ).filter((f) => f.pollId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_mealPollVotesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MealPollsTableFilterComposer
    extends Composer<_$AppDatabase, $MealPollsTable> {
  $$MealPollsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get optionsJson => $composableBuilder(
    column: $table.optionsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get closeAt => $composableBuilder(
    column: $table.closeAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nonVoterPolicy => $composableBuilder(
    column: $table.nonVoterPolicy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get closed => $composableBuilder(
    column: $table.closed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$GroupsTableFilterComposer get groupId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableFilterComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableFilterComposer get createdByMemberId {
    final $$MembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.createdByMemberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableFilterComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> mealPollVotesRefs(
    Expression<bool> Function($$MealPollVotesTableFilterComposer f) f,
  ) {
    final $$MealPollVotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealPollVotes,
      getReferencedColumn: (t) => t.pollId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealPollVotesTableFilterComposer(
            $db: $db,
            $table: $db.mealPollVotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MealPollsTableOrderingComposer
    extends Composer<_$AppDatabase, $MealPollsTable> {
  $$MealPollsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get optionsJson => $composableBuilder(
    column: $table.optionsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get closeAt => $composableBuilder(
    column: $table.closeAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nonVoterPolicy => $composableBuilder(
    column: $table.nonVoterPolicy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get closed => $composableBuilder(
    column: $table.closed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$GroupsTableOrderingComposer get groupId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableOrderingComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableOrderingComposer get createdByMemberId {
    final $$MembersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.createdByMemberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableOrderingComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealPollsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealPollsTable> {
  $$MealPollsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get optionsJson => $composableBuilder(
    column: $table.optionsJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get closeAt =>
      $composableBuilder(column: $table.closeAt, builder: (column) => column);

  GeneratedColumn<String> get nonVoterPolicy => $composableBuilder(
    column: $table.nonVoterPolicy,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get closed =>
      $composableBuilder(column: $table.closed, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$GroupsTableAnnotationComposer get groupId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableAnnotationComposer get createdByMemberId {
    final $$MembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.createdByMemberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableAnnotationComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> mealPollVotesRefs<T extends Object>(
    Expression<T> Function($$MealPollVotesTableAnnotationComposer a) f,
  ) {
    final $$MealPollVotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealPollVotes,
      getReferencedColumn: (t) => t.pollId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealPollVotesTableAnnotationComposer(
            $db: $db,
            $table: $db.mealPollVotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MealPollsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealPollsTable,
          MealPoll,
          $$MealPollsTableFilterComposer,
          $$MealPollsTableOrderingComposer,
          $$MealPollsTableAnnotationComposer,
          $$MealPollsTableCreateCompanionBuilder,
          $$MealPollsTableUpdateCompanionBuilder,
          (MealPoll, $$MealPollsTableReferences),
          MealPoll,
          PrefetchHooks Function({
            bool groupId,
            bool createdByMemberId,
            bool mealPollVotesRefs,
          })
        > {
  $$MealPollsTableTableManager(_$AppDatabase db, $MealPollsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealPollsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealPollsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealPollsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> groupId = const Value.absent(),
                Value<int> date = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> optionsJson = const Value.absent(),
                Value<int> closeAt = const Value.absent(),
                Value<String> createdByMemberId = const Value.absent(),
                Value<String?> nonVoterPolicy = const Value.absent(),
                Value<bool> closed = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MealPollsCompanion(
                id: id,
                groupId: groupId,
                date: date,
                type: type,
                title: title,
                optionsJson: optionsJson,
                closeAt: closeAt,
                createdByMemberId: createdByMemberId,
                nonVoterPolicy: nonVoterPolicy,
                closed: closed,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String groupId,
                required int date,
                required String type,
                Value<String?> title = const Value.absent(),
                Value<String?> optionsJson = const Value.absent(),
                required int closeAt,
                required String createdByMemberId,
                Value<String?> nonVoterPolicy = const Value.absent(),
                Value<bool> closed = const Value.absent(),
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => MealPollsCompanion.insert(
                id: id,
                groupId: groupId,
                date: date,
                type: type,
                title: title,
                optionsJson: optionsJson,
                closeAt: closeAt,
                createdByMemberId: createdByMemberId,
                nonVoterPolicy: nonVoterPolicy,
                closed: closed,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MealPollsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                groupId = false,
                createdByMemberId = false,
                mealPollVotesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (mealPollVotesRefs) db.mealPollVotes,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (groupId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.groupId,
                                    referencedTable: $$MealPollsTableReferences
                                        ._groupIdTable(db),
                                    referencedColumn: $$MealPollsTableReferences
                                        ._groupIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (createdByMemberId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.createdByMemberId,
                                    referencedTable: $$MealPollsTableReferences
                                        ._createdByMemberIdTable(db),
                                    referencedColumn: $$MealPollsTableReferences
                                        ._createdByMemberIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (mealPollVotesRefs)
                        await $_getPrefetchedData<
                          MealPoll,
                          $MealPollsTable,
                          MealPollVote
                        >(
                          currentTable: table,
                          referencedTable: $$MealPollsTableReferences
                              ._mealPollVotesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MealPollsTableReferences(
                                db,
                                table,
                                p0,
                              ).mealPollVotesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.pollId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MealPollsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealPollsTable,
      MealPoll,
      $$MealPollsTableFilterComposer,
      $$MealPollsTableOrderingComposer,
      $$MealPollsTableAnnotationComposer,
      $$MealPollsTableCreateCompanionBuilder,
      $$MealPollsTableUpdateCompanionBuilder,
      (MealPoll, $$MealPollsTableReferences),
      MealPoll,
      PrefetchHooks Function({
        bool groupId,
        bool createdByMemberId,
        bool mealPollVotesRefs,
      })
    >;
typedef $$MealPollVotesTableCreateCompanionBuilder =
    MealPollVotesCompanion Function({
      required String pollId,
      required String memberId,
      required String valueJson,
      required int votedAt,
      Value<int> rowid,
    });
typedef $$MealPollVotesTableUpdateCompanionBuilder =
    MealPollVotesCompanion Function({
      Value<String> pollId,
      Value<String> memberId,
      Value<String> valueJson,
      Value<int> votedAt,
      Value<int> rowid,
    });

final class $$MealPollVotesTableReferences
    extends BaseReferences<_$AppDatabase, $MealPollVotesTable, MealPollVote> {
  $$MealPollVotesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MealPollsTable _pollIdTable(_$AppDatabase db) =>
      db.mealPolls.createAlias('meal_poll_votes__poll_id__meal_polls__id');

  $$MealPollsTableProcessedTableManager get pollId {
    final $_column = $_itemColumn<String>('poll_id')!;

    final manager = $$MealPollsTableTableManager(
      $_db,
      $_db.mealPolls,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pollIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MembersTable _memberIdTable(_$AppDatabase db) =>
      db.members.createAlias('meal_poll_votes__member_id__members__id');

  $$MembersTableProcessedTableManager get memberId {
    final $_column = $_itemColumn<String>('member_id')!;

    final manager = $$MembersTableTableManager(
      $_db,
      $_db.members,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MealPollVotesTableFilterComposer
    extends Composer<_$AppDatabase, $MealPollVotesTable> {
  $$MealPollVotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get valueJson => $composableBuilder(
    column: $table.valueJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get votedAt => $composableBuilder(
    column: $table.votedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MealPollsTableFilterComposer get pollId {
    final $$MealPollsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pollId,
      referencedTable: $db.mealPolls,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealPollsTableFilterComposer(
            $db: $db,
            $table: $db.mealPolls,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableFilterComposer get memberId {
    final $$MembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableFilterComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealPollVotesTableOrderingComposer
    extends Composer<_$AppDatabase, $MealPollVotesTable> {
  $$MealPollVotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get valueJson => $composableBuilder(
    column: $table.valueJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get votedAt => $composableBuilder(
    column: $table.votedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MealPollsTableOrderingComposer get pollId {
    final $$MealPollsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pollId,
      referencedTable: $db.mealPolls,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealPollsTableOrderingComposer(
            $db: $db,
            $table: $db.mealPolls,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableOrderingComposer get memberId {
    final $$MembersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableOrderingComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealPollVotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealPollVotesTable> {
  $$MealPollVotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get valueJson =>
      $composableBuilder(column: $table.valueJson, builder: (column) => column);

  GeneratedColumn<int> get votedAt =>
      $composableBuilder(column: $table.votedAt, builder: (column) => column);

  $$MealPollsTableAnnotationComposer get pollId {
    final $$MealPollsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pollId,
      referencedTable: $db.mealPolls,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealPollsTableAnnotationComposer(
            $db: $db,
            $table: $db.mealPolls,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableAnnotationComposer get memberId {
    final $$MembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableAnnotationComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealPollVotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealPollVotesTable,
          MealPollVote,
          $$MealPollVotesTableFilterComposer,
          $$MealPollVotesTableOrderingComposer,
          $$MealPollVotesTableAnnotationComposer,
          $$MealPollVotesTableCreateCompanionBuilder,
          $$MealPollVotesTableUpdateCompanionBuilder,
          (MealPollVote, $$MealPollVotesTableReferences),
          MealPollVote,
          PrefetchHooks Function({bool pollId, bool memberId})
        > {
  $$MealPollVotesTableTableManager(_$AppDatabase db, $MealPollVotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealPollVotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealPollVotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealPollVotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> pollId = const Value.absent(),
                Value<String> memberId = const Value.absent(),
                Value<String> valueJson = const Value.absent(),
                Value<int> votedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MealPollVotesCompanion(
                pollId: pollId,
                memberId: memberId,
                valueJson: valueJson,
                votedAt: votedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String pollId,
                required String memberId,
                required String valueJson,
                required int votedAt,
                Value<int> rowid = const Value.absent(),
              }) => MealPollVotesCompanion.insert(
                pollId: pollId,
                memberId: memberId,
                valueJson: valueJson,
                votedAt: votedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MealPollVotesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({pollId = false, memberId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (pollId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.pollId,
                                referencedTable: $$MealPollVotesTableReferences
                                    ._pollIdTable(db),
                                referencedColumn: $$MealPollVotesTableReferences
                                    ._pollIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (memberId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.memberId,
                                referencedTable: $$MealPollVotesTableReferences
                                    ._memberIdTable(db),
                                referencedColumn: $$MealPollVotesTableReferences
                                    ._memberIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MealPollVotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealPollVotesTable,
      MealPollVote,
      $$MealPollVotesTableFilterComposer,
      $$MealPollVotesTableOrderingComposer,
      $$MealPollVotesTableAnnotationComposer,
      $$MealPollVotesTableCreateCompanionBuilder,
      $$MealPollVotesTableUpdateCompanionBuilder,
      (MealPollVote, $$MealPollVotesTableReferences),
      MealPollVote,
      PrefetchHooks Function({bool pollId, bool memberId})
    >;
typedef $$MealSlotsTableCreateCompanionBuilder =
    MealSlotsCompanion Function({
      required String id,
      required String groupId,
      required String name,
      Value<String?> defaultKey,
      Value<double> weight,
      Value<int> sortOrder,
      Value<bool> active,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$MealSlotsTableUpdateCompanionBuilder =
    MealSlotsCompanion Function({
      Value<String> id,
      Value<String> groupId,
      Value<String> name,
      Value<String?> defaultKey,
      Value<double> weight,
      Value<int> sortOrder,
      Value<bool> active,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$MealSlotsTableReferences
    extends BaseReferences<_$AppDatabase, $MealSlotsTable, MealSlot> {
  $$MealSlotsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GroupsTable _groupIdTable(_$AppDatabase db) =>
      db.groups.createAlias('meal_slots__group_id__groups__id');

  $$GroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<String>('group_id')!;

    final manager = $$GroupsTableTableManager(
      $_db,
      $_db.groups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MemberMealRoutinesTable, List<MemberMealRoutine>>
  _memberMealRoutinesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.memberMealRoutines,
        aliasName: 'meal_slots__id__member_meal_routines__slot_id',
      );

  $$MemberMealRoutinesTableProcessedTableManager get memberMealRoutinesRefs {
    final manager = $$MemberMealRoutinesTableTableManager(
      $_db,
      $_db.memberMealRoutines,
    ).filter((f) => f.slotId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _memberMealRoutinesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MealSlotsTableFilterComposer
    extends Composer<_$AppDatabase, $MealSlotsTable> {
  $$MealSlotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultKey => $composableBuilder(
    column: $table.defaultKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$GroupsTableFilterComposer get groupId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableFilterComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> memberMealRoutinesRefs(
    Expression<bool> Function($$MemberMealRoutinesTableFilterComposer f) f,
  ) {
    final $$MemberMealRoutinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.memberMealRoutines,
      getReferencedColumn: (t) => t.slotId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemberMealRoutinesTableFilterComposer(
            $db: $db,
            $table: $db.memberMealRoutines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MealSlotsTableOrderingComposer
    extends Composer<_$AppDatabase, $MealSlotsTable> {
  $$MealSlotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultKey => $composableBuilder(
    column: $table.defaultKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$GroupsTableOrderingComposer get groupId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableOrderingComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealSlotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealSlotsTable> {
  $$MealSlotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get defaultKey => $composableBuilder(
    column: $table.defaultKey,
    builder: (column) => column,
  );

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$GroupsTableAnnotationComposer get groupId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> memberMealRoutinesRefs<T extends Object>(
    Expression<T> Function($$MemberMealRoutinesTableAnnotationComposer a) f,
  ) {
    final $$MemberMealRoutinesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.memberMealRoutines,
          getReferencedColumn: (t) => t.slotId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MemberMealRoutinesTableAnnotationComposer(
                $db: $db,
                $table: $db.memberMealRoutines,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$MealSlotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealSlotsTable,
          MealSlot,
          $$MealSlotsTableFilterComposer,
          $$MealSlotsTableOrderingComposer,
          $$MealSlotsTableAnnotationComposer,
          $$MealSlotsTableCreateCompanionBuilder,
          $$MealSlotsTableUpdateCompanionBuilder,
          (MealSlot, $$MealSlotsTableReferences),
          MealSlot,
          PrefetchHooks Function({bool groupId, bool memberMealRoutinesRefs})
        > {
  $$MealSlotsTableTableManager(_$AppDatabase db, $MealSlotsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealSlotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealSlotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealSlotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> groupId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> defaultKey = const Value.absent(),
                Value<double> weight = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MealSlotsCompanion(
                id: id,
                groupId: groupId,
                name: name,
                defaultKey: defaultKey,
                weight: weight,
                sortOrder: sortOrder,
                active: active,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String groupId,
                required String name,
                Value<String?> defaultKey = const Value.absent(),
                Value<double> weight = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> active = const Value.absent(),
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => MealSlotsCompanion.insert(
                id: id,
                groupId: groupId,
                name: name,
                defaultKey: defaultKey,
                weight: weight,
                sortOrder: sortOrder,
                active: active,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MealSlotsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({groupId = false, memberMealRoutinesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (memberMealRoutinesRefs) db.memberMealRoutines,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (groupId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.groupId,
                                    referencedTable: $$MealSlotsTableReferences
                                        ._groupIdTable(db),
                                    referencedColumn: $$MealSlotsTableReferences
                                        ._groupIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (memberMealRoutinesRefs)
                        await $_getPrefetchedData<
                          MealSlot,
                          $MealSlotsTable,
                          MemberMealRoutine
                        >(
                          currentTable: table,
                          referencedTable: $$MealSlotsTableReferences
                              ._memberMealRoutinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MealSlotsTableReferences(
                                db,
                                table,
                                p0,
                              ).memberMealRoutinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.slotId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MealSlotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealSlotsTable,
      MealSlot,
      $$MealSlotsTableFilterComposer,
      $$MealSlotsTableOrderingComposer,
      $$MealSlotsTableAnnotationComposer,
      $$MealSlotsTableCreateCompanionBuilder,
      $$MealSlotsTableUpdateCompanionBuilder,
      (MealSlot, $$MealSlotsTableReferences),
      MealSlot,
      PrefetchHooks Function({bool groupId, bool memberMealRoutinesRefs})
    >;
typedef $$MemberMealRoutinesTableCreateCompanionBuilder =
    MemberMealRoutinesCompanion Function({
      required String id,
      required String memberId,
      required String slotId,
      Value<int?> weekday,
      Value<bool> enabled,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$MemberMealRoutinesTableUpdateCompanionBuilder =
    MemberMealRoutinesCompanion Function({
      Value<String> id,
      Value<String> memberId,
      Value<String> slotId,
      Value<int?> weekday,
      Value<bool> enabled,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$MemberMealRoutinesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MemberMealRoutinesTable,
          MemberMealRoutine
        > {
  $$MemberMealRoutinesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MembersTable _memberIdTable(_$AppDatabase db) =>
      db.members.createAlias('member_meal_routines__member_id__members__id');

  $$MembersTableProcessedTableManager get memberId {
    final $_column = $_itemColumn<String>('member_id')!;

    final manager = $$MembersTableTableManager(
      $_db,
      $_db.members,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MealSlotsTable _slotIdTable(_$AppDatabase db) =>
      db.mealSlots.createAlias('member_meal_routines__slot_id__meal_slots__id');

  $$MealSlotsTableProcessedTableManager get slotId {
    final $_column = $_itemColumn<String>('slot_id')!;

    final manager = $$MealSlotsTableTableManager(
      $_db,
      $_db.mealSlots,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_slotIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MemberMealRoutinesTableFilterComposer
    extends Composer<_$AppDatabase, $MemberMealRoutinesTable> {
  $$MemberMealRoutinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MembersTableFilterComposer get memberId {
    final $$MembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableFilterComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MealSlotsTableFilterComposer get slotId {
    final $$MealSlotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.slotId,
      referencedTable: $db.mealSlots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealSlotsTableFilterComposer(
            $db: $db,
            $table: $db.mealSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemberMealRoutinesTableOrderingComposer
    extends Composer<_$AppDatabase, $MemberMealRoutinesTable> {
  $$MemberMealRoutinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MembersTableOrderingComposer get memberId {
    final $$MembersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableOrderingComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MealSlotsTableOrderingComposer get slotId {
    final $$MealSlotsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.slotId,
      referencedTable: $db.mealSlots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealSlotsTableOrderingComposer(
            $db: $db,
            $table: $db.mealSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemberMealRoutinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MemberMealRoutinesTable> {
  $$MemberMealRoutinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$MembersTableAnnotationComposer get memberId {
    final $$MembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableAnnotationComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MealSlotsTableAnnotationComposer get slotId {
    final $$MealSlotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.slotId,
      referencedTable: $db.mealSlots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealSlotsTableAnnotationComposer(
            $db: $db,
            $table: $db.mealSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemberMealRoutinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MemberMealRoutinesTable,
          MemberMealRoutine,
          $$MemberMealRoutinesTableFilterComposer,
          $$MemberMealRoutinesTableOrderingComposer,
          $$MemberMealRoutinesTableAnnotationComposer,
          $$MemberMealRoutinesTableCreateCompanionBuilder,
          $$MemberMealRoutinesTableUpdateCompanionBuilder,
          (MemberMealRoutine, $$MemberMealRoutinesTableReferences),
          MemberMealRoutine,
          PrefetchHooks Function({bool memberId, bool slotId})
        > {
  $$MemberMealRoutinesTableTableManager(
    _$AppDatabase db,
    $MemberMealRoutinesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemberMealRoutinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MemberMealRoutinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MemberMealRoutinesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> memberId = const Value.absent(),
                Value<String> slotId = const Value.absent(),
                Value<int?> weekday = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemberMealRoutinesCompanion(
                id: id,
                memberId: memberId,
                slotId: slotId,
                weekday: weekday,
                enabled: enabled,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String memberId,
                required String slotId,
                Value<int?> weekday = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => MemberMealRoutinesCompanion.insert(
                id: id,
                memberId: memberId,
                slotId: slotId,
                weekday: weekday,
                enabled: enabled,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MemberMealRoutinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({memberId = false, slotId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (memberId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.memberId,
                                referencedTable:
                                    $$MemberMealRoutinesTableReferences
                                        ._memberIdTable(db),
                                referencedColumn:
                                    $$MemberMealRoutinesTableReferences
                                        ._memberIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (slotId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.slotId,
                                referencedTable:
                                    $$MemberMealRoutinesTableReferences
                                        ._slotIdTable(db),
                                referencedColumn:
                                    $$MemberMealRoutinesTableReferences
                                        ._slotIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MemberMealRoutinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MemberMealRoutinesTable,
      MemberMealRoutine,
      $$MemberMealRoutinesTableFilterComposer,
      $$MemberMealRoutinesTableOrderingComposer,
      $$MemberMealRoutinesTableAnnotationComposer,
      $$MemberMealRoutinesTableCreateCompanionBuilder,
      $$MemberMealRoutinesTableUpdateCompanionBuilder,
      (MemberMealRoutine, $$MemberMealRoutinesTableReferences),
      MemberMealRoutine,
      PrefetchHooks Function({bool memberId, bool slotId})
    >;
typedef $$MealLeavesTableCreateCompanionBuilder =
    MealLeavesCompanion Function({
      required String id,
      required String memberId,
      required int fromDate,
      required int toDate,
      Value<String?> note,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$MealLeavesTableUpdateCompanionBuilder =
    MealLeavesCompanion Function({
      Value<String> id,
      Value<String> memberId,
      Value<int> fromDate,
      Value<int> toDate,
      Value<String?> note,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$MealLeavesTableReferences
    extends BaseReferences<_$AppDatabase, $MealLeavesTable, MealLeave> {
  $$MealLeavesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MembersTable _memberIdTable(_$AppDatabase db) =>
      db.members.createAlias('meal_leaves__member_id__members__id');

  $$MembersTableProcessedTableManager get memberId {
    final $_column = $_itemColumn<String>('member_id')!;

    final manager = $$MembersTableTableManager(
      $_db,
      $_db.members,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MealLeavesTableFilterComposer
    extends Composer<_$AppDatabase, $MealLeavesTable> {
  $$MealLeavesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fromDate => $composableBuilder(
    column: $table.fromDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get toDate => $composableBuilder(
    column: $table.toDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MembersTableFilterComposer get memberId {
    final $$MembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableFilterComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealLeavesTableOrderingComposer
    extends Composer<_$AppDatabase, $MealLeavesTable> {
  $$MealLeavesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fromDate => $composableBuilder(
    column: $table.fromDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get toDate => $composableBuilder(
    column: $table.toDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MembersTableOrderingComposer get memberId {
    final $$MembersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableOrderingComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealLeavesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealLeavesTable> {
  $$MealLeavesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get fromDate =>
      $composableBuilder(column: $table.fromDate, builder: (column) => column);

  GeneratedColumn<int> get toDate =>
      $composableBuilder(column: $table.toDate, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$MembersTableAnnotationComposer get memberId {
    final $$MembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableAnnotationComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealLeavesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealLeavesTable,
          MealLeave,
          $$MealLeavesTableFilterComposer,
          $$MealLeavesTableOrderingComposer,
          $$MealLeavesTableAnnotationComposer,
          $$MealLeavesTableCreateCompanionBuilder,
          $$MealLeavesTableUpdateCompanionBuilder,
          (MealLeave, $$MealLeavesTableReferences),
          MealLeave,
          PrefetchHooks Function({bool memberId})
        > {
  $$MealLeavesTableTableManager(_$AppDatabase db, $MealLeavesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealLeavesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealLeavesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealLeavesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> memberId = const Value.absent(),
                Value<int> fromDate = const Value.absent(),
                Value<int> toDate = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MealLeavesCompanion(
                id: id,
                memberId: memberId,
                fromDate: fromDate,
                toDate: toDate,
                note: note,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String memberId,
                required int fromDate,
                required int toDate,
                Value<String?> note = const Value.absent(),
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => MealLeavesCompanion.insert(
                id: id,
                memberId: memberId,
                fromDate: fromDate,
                toDate: toDate,
                note: note,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MealLeavesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({memberId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (memberId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.memberId,
                                referencedTable: $$MealLeavesTableReferences
                                    ._memberIdTable(db),
                                referencedColumn: $$MealLeavesTableReferences
                                    ._memberIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MealLeavesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealLeavesTable,
      MealLeave,
      $$MealLeavesTableFilterComposer,
      $$MealLeavesTableOrderingComposer,
      $$MealLeavesTableAnnotationComposer,
      $$MealLeavesTableCreateCompanionBuilder,
      $$MealLeavesTableUpdateCompanionBuilder,
      (MealLeave, $$MealLeavesTableReferences),
      MealLeave,
      PrefetchHooks Function({bool memberId})
    >;
typedef $$BazarDutiesTableCreateCompanionBuilder =
    BazarDutiesCompanion Function({
      required String id,
      required String groupId,
      required String memberId,
      required int date,
      Value<String?> note,
      Value<bool> done,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$BazarDutiesTableUpdateCompanionBuilder =
    BazarDutiesCompanion Function({
      Value<String> id,
      Value<String> groupId,
      Value<String> memberId,
      Value<int> date,
      Value<String?> note,
      Value<bool> done,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$BazarDutiesTableReferences
    extends BaseReferences<_$AppDatabase, $BazarDutiesTable, BazarDuty> {
  $$BazarDutiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GroupsTable _groupIdTable(_$AppDatabase db) =>
      db.groups.createAlias('bazar_duties__group_id__groups__id');

  $$GroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<String>('group_id')!;

    final manager = $$GroupsTableTableManager(
      $_db,
      $_db.groups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MembersTable _memberIdTable(_$AppDatabase db) =>
      db.members.createAlias('bazar_duties__member_id__members__id');

  $$MembersTableProcessedTableManager get memberId {
    final $_column = $_itemColumn<String>('member_id')!;

    final manager = $$MembersTableTableManager(
      $_db,
      $_db.members,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BazarDutiesTableFilterComposer
    extends Composer<_$AppDatabase, $BazarDutiesTable> {
  $$BazarDutiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$GroupsTableFilterComposer get groupId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableFilterComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableFilterComposer get memberId {
    final $$MembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableFilterComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BazarDutiesTableOrderingComposer
    extends Composer<_$AppDatabase, $BazarDutiesTable> {
  $$BazarDutiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$GroupsTableOrderingComposer get groupId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableOrderingComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableOrderingComposer get memberId {
    final $$MembersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableOrderingComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BazarDutiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BazarDutiesTable> {
  $$BazarDutiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get done =>
      $composableBuilder(column: $table.done, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$GroupsTableAnnotationComposer get groupId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableAnnotationComposer get memberId {
    final $$MembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableAnnotationComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BazarDutiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BazarDutiesTable,
          BazarDuty,
          $$BazarDutiesTableFilterComposer,
          $$BazarDutiesTableOrderingComposer,
          $$BazarDutiesTableAnnotationComposer,
          $$BazarDutiesTableCreateCompanionBuilder,
          $$BazarDutiesTableUpdateCompanionBuilder,
          (BazarDuty, $$BazarDutiesTableReferences),
          BazarDuty,
          PrefetchHooks Function({bool groupId, bool memberId})
        > {
  $$BazarDutiesTableTableManager(_$AppDatabase db, $BazarDutiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BazarDutiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BazarDutiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BazarDutiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> groupId = const Value.absent(),
                Value<String> memberId = const Value.absent(),
                Value<int> date = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> done = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BazarDutiesCompanion(
                id: id,
                groupId: groupId,
                memberId: memberId,
                date: date,
                note: note,
                done: done,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String groupId,
                required String memberId,
                required int date,
                Value<String?> note = const Value.absent(),
                Value<bool> done = const Value.absent(),
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => BazarDutiesCompanion.insert(
                id: id,
                groupId: groupId,
                memberId: memberId,
                date: date,
                note: note,
                done: done,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BazarDutiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({groupId = false, memberId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (groupId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.groupId,
                                referencedTable: $$BazarDutiesTableReferences
                                    ._groupIdTable(db),
                                referencedColumn: $$BazarDutiesTableReferences
                                    ._groupIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (memberId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.memberId,
                                referencedTable: $$BazarDutiesTableReferences
                                    ._memberIdTable(db),
                                referencedColumn: $$BazarDutiesTableReferences
                                    ._memberIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BazarDutiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BazarDutiesTable,
      BazarDuty,
      $$BazarDutiesTableFilterComposer,
      $$BazarDutiesTableOrderingComposer,
      $$BazarDutiesTableAnnotationComposer,
      $$BazarDutiesTableCreateCompanionBuilder,
      $$BazarDutiesTableUpdateCompanionBuilder,
      (BazarDuty, $$BazarDutiesTableReferences),
      BazarDuty,
      PrefetchHooks Function({bool groupId, bool memberId})
    >;
typedef $$AuditLogTableCreateCompanionBuilder =
    AuditLogCompanion Function({
      required String id,
      required String groupId,
      required String entity,
      required String entityId,
      required String action,
      required int timestamp,
      Value<String?> diffJson,
      Value<int> rowid,
    });
typedef $$AuditLogTableUpdateCompanionBuilder =
    AuditLogCompanion Function({
      Value<String> id,
      Value<String> groupId,
      Value<String> entity,
      Value<String> entityId,
      Value<String> action,
      Value<int> timestamp,
      Value<String?> diffJson,
      Value<int> rowid,
    });

final class $$AuditLogTableReferences
    extends BaseReferences<_$AppDatabase, $AuditLogTable, AuditLogData> {
  $$AuditLogTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GroupsTable _groupIdTable(_$AppDatabase db) =>
      db.groups.createAlias('audit_log__group_id__groups__id');

  $$GroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<String>('group_id')!;

    final manager = $$GroupsTableTableManager(
      $_db,
      $_db.groups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AuditLogTableFilterComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get diffJson => $composableBuilder(
    column: $table.diffJson,
    builder: (column) => ColumnFilters(column),
  );

  $$GroupsTableFilterComposer get groupId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableFilterComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AuditLogTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get diffJson => $composableBuilder(
    column: $table.diffJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$GroupsTableOrderingComposer get groupId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableOrderingComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AuditLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entity =>
      $composableBuilder(column: $table.entity, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<int> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get diffJson =>
      $composableBuilder(column: $table.diffJson, builder: (column) => column);

  $$GroupsTableAnnotationComposer get groupId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AuditLogTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuditLogTable,
          AuditLogData,
          $$AuditLogTableFilterComposer,
          $$AuditLogTableOrderingComposer,
          $$AuditLogTableAnnotationComposer,
          $$AuditLogTableCreateCompanionBuilder,
          $$AuditLogTableUpdateCompanionBuilder,
          (AuditLogData, $$AuditLogTableReferences),
          AuditLogData,
          PrefetchHooks Function({bool groupId})
        > {
  $$AuditLogTableTableManager(_$AppDatabase db, $AuditLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> groupId = const Value.absent(),
                Value<String> entity = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<int> timestamp = const Value.absent(),
                Value<String?> diffJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuditLogCompanion(
                id: id,
                groupId: groupId,
                entity: entity,
                entityId: entityId,
                action: action,
                timestamp: timestamp,
                diffJson: diffJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String groupId,
                required String entity,
                required String entityId,
                required String action,
                required int timestamp,
                Value<String?> diffJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuditLogCompanion.insert(
                id: id,
                groupId: groupId,
                entity: entity,
                entityId: entityId,
                action: action,
                timestamp: timestamp,
                diffJson: diffJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AuditLogTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({groupId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (groupId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.groupId,
                                referencedTable: $$AuditLogTableReferences
                                    ._groupIdTable(db),
                                referencedColumn: $$AuditLogTableReferences
                                    ._groupIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AuditLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuditLogTable,
      AuditLogData,
      $$AuditLogTableFilterComposer,
      $$AuditLogTableOrderingComposer,
      $$AuditLogTableAnnotationComposer,
      $$AuditLogTableCreateCompanionBuilder,
      $$AuditLogTableUpdateCompanionBuilder,
      (AuditLogData, $$AuditLogTableReferences),
      AuditLogData,
      PrefetchHooks Function({bool groupId})
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      Value<String?> value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String?> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String?> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                Value<String?> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GroupsTableTableManager get groups =>
      $$GroupsTableTableManager(_db, _db.groups);
  $$MembersTableTableManager get members =>
      $$MembersTableTableManager(_db, _db.members);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$ExpensePayersTableTableManager get expensePayers =>
      $$ExpensePayersTableTableManager(_db, _db.expensePayers);
  $$ExpenseSplitsTableTableManager get expenseSplits =>
      $$ExpenseSplitsTableTableManager(_db, _db.expenseSplits);
  $$MealsTableTableManager get meals =>
      $$MealsTableTableManager(_db, _db.meals);
  $$DepositsTableTableManager get deposits =>
      $$DepositsTableTableManager(_db, _db.deposits);
  $$SettlementsTableTableManager get settlements =>
      $$SettlementsTableTableManager(_db, _db.settlements);
  $$MonthsTableTableManager get months =>
      $$MonthsTableTableManager(_db, _db.months);
  $$RecurringRulesTableTableManager get recurringRules =>
      $$RecurringRulesTableTableManager(_db, _db.recurringRules);
  $$MealPollsTableTableManager get mealPolls =>
      $$MealPollsTableTableManager(_db, _db.mealPolls);
  $$MealPollVotesTableTableManager get mealPollVotes =>
      $$MealPollVotesTableTableManager(_db, _db.mealPollVotes);
  $$MealSlotsTableTableManager get mealSlots =>
      $$MealSlotsTableTableManager(_db, _db.mealSlots);
  $$MemberMealRoutinesTableTableManager get memberMealRoutines =>
      $$MemberMealRoutinesTableTableManager(_db, _db.memberMealRoutines);
  $$MealLeavesTableTableManager get mealLeaves =>
      $$MealLeavesTableTableManager(_db, _db.mealLeaves);
  $$BazarDutiesTableTableManager get bazarDuties =>
      $$BazarDutiesTableTableManager(_db, _db.bazarDuties);
  $$AuditLogTableTableManager get auditLog =>
      $$AuditLogTableTableManager(_db, _db.auditLog);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
