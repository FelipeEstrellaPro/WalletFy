// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $GoalsTable extends Goals with TableInfo<$GoalsTable, Goal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
      'emoji', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('🎯'));
  @override
  late final GeneratedColumn<double> targetAmount = GeneratedColumn<double>(
      'target_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<double> currentAmount = GeneratedColumn<double>(
      'current_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  @override
  late final GeneratedColumn<String> deadline = GeneratedColumn<String>(
      'deadline', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
      'color_hex', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('#6366F1'));
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
      'is_archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_archived" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  late final GeneratedColumn<int> streak = GeneratedColumn<int>(
      'streak', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  late final GeneratedColumn<int> frozenStreak = GeneratedColumn<int>(
      'frozen_streak', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  late final GeneratedColumn<String> streakLastDate = GeneratedColumn<String>(
      'streak_last_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        emoji,
        targetAmount,
        currentAmount,
        deadline,
        colorHex,
        description,
        isArchived,
        streak,
        frozenStreak,
        streakLastDate,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Goal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Goal(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      emoji: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}emoji'])!,
      targetAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}target_amount'])!,
      currentAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}current_amount'])!,
      deadline: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}deadline']),
      colorHex: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color_hex'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      isArchived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_archived'])!,
      streak: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}streak'])!,
      frozenStreak: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}frozen_streak'])!,
      streakLastDate: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}streak_last_date']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $GoalsTable createAlias(String alias) {
    return $GoalsTable(attachedDatabase, alias);
  }
}

class Goal extends DataClass implements Insertable<Goal> {
  final int id;
  final String title;
  final String emoji;
  final double targetAmount;
  final double currentAmount;
  final String? deadline;
  final String colorHex;
  final String? description;
  final bool isArchived;
  final int streak;
  final int frozenStreak;
  final String? streakLastDate;
  final String createdAt;
  const Goal(
      {required this.id,
      required this.title,
      required this.emoji,
      required this.targetAmount,
      required this.currentAmount,
      this.deadline,
      required this.colorHex,
      this.description,
      required this.isArchived,
      required this.streak,
      required this.frozenStreak,
      this.streakLastDate,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['emoji'] = Variable<String>(emoji);
    map['target_amount'] = Variable<double>(targetAmount);
    map['current_amount'] = Variable<double>(currentAmount);
    if (!nullToAbsent || deadline != null) {
      map['deadline'] = Variable<String>(deadline);
    }
    map['color_hex'] = Variable<String>(colorHex);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_archived'] = Variable<bool>(isArchived);
    map['streak'] = Variable<int>(streak);
    map['frozen_streak'] = Variable<int>(frozenStreak);
    if (!nullToAbsent || streakLastDate != null) {
      map['streak_last_date'] = Variable<String>(streakLastDate);
    }
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  GoalsCompanion toCompanion(bool nullToAbsent) {
    return GoalsCompanion(
      id: Value(id),
      title: Value(title),
      emoji: Value(emoji),
      targetAmount: Value(targetAmount),
      currentAmount: Value(currentAmount),
      deadline: deadline == null && nullToAbsent
          ? const Value.absent()
          : Value(deadline),
      colorHex: Value(colorHex),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isArchived: Value(isArchived),
      streak: Value(streak),
      frozenStreak: Value(frozenStreak),
      streakLastDate: streakLastDate == null && nullToAbsent
          ? const Value.absent()
          : Value(streakLastDate),
      createdAt: Value(createdAt),
    );
  }

  factory Goal.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Goal(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      emoji: serializer.fromJson<String>(json['emoji']),
      targetAmount: serializer.fromJson<double>(json['targetAmount']),
      currentAmount: serializer.fromJson<double>(json['currentAmount']),
      deadline: serializer.fromJson<String?>(json['deadline']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      description: serializer.fromJson<String?>(json['description']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      streak: serializer.fromJson<int>(json['streak']),
      frozenStreak: serializer.fromJson<int>(json['frozenStreak']),
      streakLastDate: serializer.fromJson<String?>(json['streakLastDate']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'emoji': serializer.toJson<String>(emoji),
      'targetAmount': serializer.toJson<double>(targetAmount),
      'currentAmount': serializer.toJson<double>(currentAmount),
      'deadline': serializer.toJson<String?>(deadline),
      'colorHex': serializer.toJson<String>(colorHex),
      'description': serializer.toJson<String?>(description),
      'isArchived': serializer.toJson<bool>(isArchived),
      'streak': serializer.toJson<int>(streak),
      'frozenStreak': serializer.toJson<int>(frozenStreak),
      'streakLastDate': serializer.toJson<String?>(streakLastDate),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  Goal copyWith(
          {int? id,
          String? title,
          String? emoji,
          double? targetAmount,
          double? currentAmount,
          Value<String?> deadline = const Value.absent(),
          String? colorHex,
          Value<String?> description = const Value.absent(),
          bool? isArchived,
          int? streak,
          int? frozenStreak,
          Value<String?> streakLastDate = const Value.absent(),
          String? createdAt}) =>
      Goal(
        id: id ?? this.id,
        title: title ?? this.title,
        emoji: emoji ?? this.emoji,
        targetAmount: targetAmount ?? this.targetAmount,
        currentAmount: currentAmount ?? this.currentAmount,
        deadline: deadline.present ? deadline.value : this.deadline,
        colorHex: colorHex ?? this.colorHex,
        description: description.present ? description.value : this.description,
        isArchived: isArchived ?? this.isArchived,
        streak: streak ?? this.streak,
        frozenStreak: frozenStreak ?? this.frozenStreak,
        streakLastDate:
            streakLastDate.present ? streakLastDate.value : this.streakLastDate,
        createdAt: createdAt ?? this.createdAt,
      );
  Goal copyWithCompanion(GoalsCompanion data) {
    return Goal(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      targetAmount: data.targetAmount.present
          ? data.targetAmount.value
          : this.targetAmount,
      currentAmount: data.currentAmount.present
          ? data.currentAmount.value
          : this.currentAmount,
      deadline: data.deadline.present ? data.deadline.value : this.deadline,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      description:
          data.description.present ? data.description.value : this.description,
      isArchived:
          data.isArchived.present ? data.isArchived.value : this.isArchived,
      streak: data.streak.present ? data.streak.value : this.streak,
      frozenStreak: data.frozenStreak.present
          ? data.frozenStreak.value
          : this.frozenStreak,
      streakLastDate: data.streakLastDate.present
          ? data.streakLastDate.value
          : this.streakLastDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Goal(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('emoji: $emoji, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('currentAmount: $currentAmount, ')
          ..write('deadline: $deadline, ')
          ..write('colorHex: $colorHex, ')
          ..write('description: $description, ')
          ..write('isArchived: $isArchived, ')
          ..write('streak: $streak, ')
          ..write('frozenStreak: $frozenStreak, ')
          ..write('streakLastDate: $streakLastDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      emoji,
      targetAmount,
      currentAmount,
      deadline,
      colorHex,
      description,
      isArchived,
      streak,
      frozenStreak,
      streakLastDate,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Goal &&
          other.id == this.id &&
          other.title == this.title &&
          other.emoji == this.emoji &&
          other.targetAmount == this.targetAmount &&
          other.currentAmount == this.currentAmount &&
          other.deadline == this.deadline &&
          other.colorHex == this.colorHex &&
          other.description == this.description &&
          other.isArchived == this.isArchived &&
          other.streak == this.streak &&
          other.frozenStreak == this.frozenStreak &&
          other.streakLastDate == this.streakLastDate &&
          other.createdAt == this.createdAt);
}

class GoalsCompanion extends UpdateCompanion<Goal> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> emoji;
  final Value<double> targetAmount;
  final Value<double> currentAmount;
  final Value<String?> deadline;
  final Value<String> colorHex;
  final Value<String?> description;
  final Value<bool> isArchived;
  final Value<int> streak;
  final Value<int> frozenStreak;
  final Value<String?> streakLastDate;
  final Value<String> createdAt;
  const GoalsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.emoji = const Value.absent(),
    this.targetAmount = const Value.absent(),
    this.currentAmount = const Value.absent(),
    this.deadline = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.description = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.streak = const Value.absent(),
    this.frozenStreak = const Value.absent(),
    this.streakLastDate = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  GoalsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.emoji = const Value.absent(),
    required double targetAmount,
    this.currentAmount = const Value.absent(),
    this.deadline = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.description = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.streak = const Value.absent(),
    this.frozenStreak = const Value.absent(),
    this.streakLastDate = const Value.absent(),
    required String createdAt,
  })  : title = Value(title),
        targetAmount = Value(targetAmount),
        createdAt = Value(createdAt);
  static Insertable<Goal> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? emoji,
    Expression<double>? targetAmount,
    Expression<double>? currentAmount,
    Expression<String>? deadline,
    Expression<String>? colorHex,
    Expression<String>? description,
    Expression<bool>? isArchived,
    Expression<int>? streak,
    Expression<int>? frozenStreak,
    Expression<String>? streakLastDate,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (emoji != null) 'emoji': emoji,
      if (targetAmount != null) 'target_amount': targetAmount,
      if (currentAmount != null) 'current_amount': currentAmount,
      if (deadline != null) 'deadline': deadline,
      if (colorHex != null) 'color_hex': colorHex,
      if (description != null) 'description': description,
      if (isArchived != null) 'is_archived': isArchived,
      if (streak != null) 'streak': streak,
      if (frozenStreak != null) 'frozen_streak': frozenStreak,
      if (streakLastDate != null) 'streak_last_date': streakLastDate,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  GoalsCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? emoji,
      Value<double>? targetAmount,
      Value<double>? currentAmount,
      Value<String?>? deadline,
      Value<String>? colorHex,
      Value<String?>? description,
      Value<bool>? isArchived,
      Value<int>? streak,
      Value<int>? frozenStreak,
      Value<String?>? streakLastDate,
      Value<String>? createdAt}) {
    return GoalsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      emoji: emoji ?? this.emoji,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      deadline: deadline ?? this.deadline,
      colorHex: colorHex ?? this.colorHex,
      description: description ?? this.description,
      isArchived: isArchived ?? this.isArchived,
      streak: streak ?? this.streak,
      frozenStreak: frozenStreak ?? this.frozenStreak,
      streakLastDate: streakLastDate ?? this.streakLastDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (targetAmount.present) {
      map['target_amount'] = Variable<double>(targetAmount.value);
    }
    if (currentAmount.present) {
      map['current_amount'] = Variable<double>(currentAmount.value);
    }
    if (deadline.present) {
      map['deadline'] = Variable<String>(deadline.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (streak.present) {
      map['streak'] = Variable<int>(streak.value);
    }
    if (frozenStreak.present) {
      map['frozen_streak'] = Variable<int>(frozenStreak.value);
    }
    if (streakLastDate.present) {
      map['streak_last_date'] = Variable<String>(streakLastDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('emoji: $emoji, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('currentAmount: $currentAmount, ')
          ..write('deadline: $deadline, ')
          ..write('colorHex: $colorHex, ')
          ..write('description: $description, ')
          ..write('isArchived: $isArchived, ')
          ..write('streak: $streak, ')
          ..write('frozenStreak: $frozenStreak, ')
          ..write('streakLastDate: $streakLastDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  @override
  late final GeneratedColumn<int> goalId = GeneratedColumn<int>(
      'goal_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES goals (id)'));
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, goalId, amount, date, category, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      goalId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}goal_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final int id;
  final int goalId;
  final double amount;
  final String date;
  final String category;
  final String? note;
  const Transaction(
      {required this.id,
      required this.goalId,
      required this.amount,
      required this.date,
      required this.category,
      this.note});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['goal_id'] = Variable<int>(goalId);
    map['amount'] = Variable<double>(amount);
    map['date'] = Variable<String>(date);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      goalId: Value(goalId),
      amount: Value(amount),
      date: Value(date),
      category: Value(category),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<int>(json['id']),
      goalId: serializer.fromJson<int>(json['goalId']),
      amount: serializer.fromJson<double>(json['amount']),
      date: serializer.fromJson<String>(json['date']),
      category: serializer.fromJson<String>(json['category']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'goalId': serializer.toJson<int>(goalId),
      'amount': serializer.toJson<double>(amount),
      'date': serializer.toJson<String>(date),
      'category': serializer.toJson<String>(category),
      'note': serializer.toJson<String?>(note),
    };
  }

  Transaction copyWith(
          {int? id,
          int? goalId,
          double? amount,
          String? date,
          String? category,
          Value<String?> note = const Value.absent()}) =>
      Transaction(
        id: id ?? this.id,
        goalId: goalId ?? this.goalId,
        amount: amount ?? this.amount,
        date: date ?? this.date,
        category: category ?? this.category,
        note: note.present ? note.value : this.note,
      );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      amount: data.amount.present ? data.amount.value : this.amount,
      date: data.date.present ? data.date.value : this.date,
      category: data.category.present ? data.category.value : this.category,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('category: $category, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, goalId, amount, date, category, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.goalId == this.goalId &&
          other.amount == this.amount &&
          other.date == this.date &&
          other.category == this.category &&
          other.note == this.note);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> id;
  final Value<int> goalId;
  final Value<double> amount;
  final Value<String> date;
  final Value<String> category;
  final Value<String?> note;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.goalId = const Value.absent(),
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
    this.category = const Value.absent(),
    this.note = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required int goalId,
    required double amount,
    required String date,
    required String category,
    this.note = const Value.absent(),
  })  : goalId = Value(goalId),
        amount = Value(amount),
        date = Value(date),
        category = Value(category);
  static Insertable<Transaction> custom({
    Expression<int>? id,
    Expression<int>? goalId,
    Expression<double>? amount,
    Expression<String>? date,
    Expression<String>? category,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (goalId != null) 'goal_id': goalId,
      if (amount != null) 'amount': amount,
      if (date != null) 'date': date,
      if (category != null) 'category': category,
      if (note != null) 'note': note,
    });
  }

  TransactionsCompanion copyWith(
      {Value<int>? id,
      Value<int>? goalId,
      Value<double>? amount,
      Value<String>? date,
      Value<String>? category,
      Value<String?>? note}) {
    return TransactionsCompanion(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<int>(goalId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('category: $category, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $UserSettingsTable extends UserSettings
    with TableInfo<$UserSettingsTable, UserSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSettingsTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  @override
  late final GeneratedColumn<String> userName = GeneratedColumn<String>(
      'user_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  @override
  late final GeneratedColumn<String> avatarPath = GeneratedColumn<String>(
      'avatar_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> themeSeedColor = GeneratedColumn<String>(
      'theme_seed_color', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('#6366F1'));
  @override
  late final GeneratedColumn<int> themeMode = GeneratedColumn<int>(
      'theme_mode', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  late final GeneratedColumn<bool> reminderEnabled = GeneratedColumn<bool>(
      'reminder_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("reminder_enabled" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  late final GeneratedColumn<String> reminderTime = GeneratedColumn<String>(
      'reminder_time', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('08:00'));
  @override
  late final GeneratedColumn<String> streakLastDate = GeneratedColumn<String>(
      'streak_last_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<int> globalStreak = GeneratedColumn<int>(
      'global_streak', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  late final GeneratedColumn<int> globalFrozenStreak = GeneratedColumn<int>(
      'global_frozen_streak', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  late final GeneratedColumn<String> ollamaUrl = GeneratedColumn<String>(
      'ollama_url', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('http://localhost:11434'));
  @override
  late final GeneratedColumn<String> ollamaModel = GeneratedColumn<String>(
      'ollama_model', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('llama3'));
  @override
  late final GeneratedColumn<String> onboardingCompletedAt =
      GeneratedColumn<String>('onboarding_completed_at', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userName,
        avatarPath,
        themeSeedColor,
        themeMode,
        reminderEnabled,
        reminderTime,
        streakLastDate,
        globalStreak,
        globalFrozenStreak,
        ollamaUrl,
        ollamaModel,
        onboardingCompletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_settings';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSetting(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_name'])!,
      avatarPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_path']),
      themeSeedColor: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}theme_seed_color'])!,
      themeMode: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}theme_mode'])!,
      reminderEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}reminder_enabled'])!,
      reminderTime: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reminder_time'])!,
      streakLastDate: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}streak_last_date']),
      globalStreak: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}global_streak'])!,
      globalFrozenStreak: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}global_frozen_streak'])!,
      ollamaUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ollama_url'])!,
      ollamaModel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ollama_model'])!,
      onboardingCompletedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}onboarding_completed_at']),
    );
  }

  @override
  $UserSettingsTable createAlias(String alias) {
    return $UserSettingsTable(attachedDatabase, alias);
  }
}

class UserSetting extends DataClass implements Insertable<UserSetting> {
  final int id;
  final String userName;
  final String? avatarPath;
  final String themeSeedColor;
  final int themeMode;
  final bool reminderEnabled;
  final String reminderTime;
  final String? streakLastDate;
  final int globalStreak;
  final int globalFrozenStreak;
  final String ollamaUrl;
  final String ollamaModel;
  final String? onboardingCompletedAt;
  const UserSetting(
      {required this.id,
      required this.userName,
      this.avatarPath,
      required this.themeSeedColor,
      required this.themeMode,
      required this.reminderEnabled,
      required this.reminderTime,
      this.streakLastDate,
      required this.globalStreak,
      required this.globalFrozenStreak,
      required this.ollamaUrl,
      required this.ollamaModel,
      this.onboardingCompletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_name'] = Variable<String>(userName);
    if (!nullToAbsent || avatarPath != null) {
      map['avatar_path'] = Variable<String>(avatarPath);
    }
    map['theme_seed_color'] = Variable<String>(themeSeedColor);
    map['theme_mode'] = Variable<int>(themeMode);
    map['reminder_enabled'] = Variable<bool>(reminderEnabled);
    map['reminder_time'] = Variable<String>(reminderTime);
    if (!nullToAbsent || streakLastDate != null) {
      map['streak_last_date'] = Variable<String>(streakLastDate);
    }
    map['global_streak'] = Variable<int>(globalStreak);
    map['global_frozen_streak'] = Variable<int>(globalFrozenStreak);
    map['ollama_url'] = Variable<String>(ollamaUrl);
    map['ollama_model'] = Variable<String>(ollamaModel);
    if (!nullToAbsent || onboardingCompletedAt != null) {
      map['onboarding_completed_at'] = Variable<String>(onboardingCompletedAt);
    }
    return map;
  }

  UserSettingsCompanion toCompanion(bool nullToAbsent) {
    return UserSettingsCompanion(
      id: Value(id),
      userName: Value(userName),
      avatarPath: avatarPath == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarPath),
      themeSeedColor: Value(themeSeedColor),
      themeMode: Value(themeMode),
      reminderEnabled: Value(reminderEnabled),
      reminderTime: Value(reminderTime),
      streakLastDate: streakLastDate == null && nullToAbsent
          ? const Value.absent()
          : Value(streakLastDate),
      globalStreak: Value(globalStreak),
      globalFrozenStreak: Value(globalFrozenStreak),
      ollamaUrl: Value(ollamaUrl),
      ollamaModel: Value(ollamaModel),
      onboardingCompletedAt: onboardingCompletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(onboardingCompletedAt),
    );
  }

  factory UserSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSetting(
      id: serializer.fromJson<int>(json['id']),
      userName: serializer.fromJson<String>(json['userName']),
      avatarPath: serializer.fromJson<String?>(json['avatarPath']),
      themeSeedColor: serializer.fromJson<String>(json['themeSeedColor']),
      themeMode: serializer.fromJson<int>(json['themeMode']),
      reminderEnabled: serializer.fromJson<bool>(json['reminderEnabled']),
      reminderTime: serializer.fromJson<String>(json['reminderTime']),
      streakLastDate: serializer.fromJson<String?>(json['streakLastDate']),
      globalStreak: serializer.fromJson<int>(json['globalStreak']),
      globalFrozenStreak: serializer.fromJson<int>(json['globalFrozenStreak']),
      ollamaUrl: serializer.fromJson<String>(json['ollamaUrl']),
      ollamaModel: serializer.fromJson<String>(json['ollamaModel']),
      onboardingCompletedAt:
          serializer.fromJson<String?>(json['onboardingCompletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userName': serializer.toJson<String>(userName),
      'avatarPath': serializer.toJson<String?>(avatarPath),
      'themeSeedColor': serializer.toJson<String>(themeSeedColor),
      'themeMode': serializer.toJson<int>(themeMode),
      'reminderEnabled': serializer.toJson<bool>(reminderEnabled),
      'reminderTime': serializer.toJson<String>(reminderTime),
      'streakLastDate': serializer.toJson<String?>(streakLastDate),
      'globalStreak': serializer.toJson<int>(globalStreak),
      'globalFrozenStreak': serializer.toJson<int>(globalFrozenStreak),
      'ollamaUrl': serializer.toJson<String>(ollamaUrl),
      'ollamaModel': serializer.toJson<String>(ollamaModel),
      'onboardingCompletedAt':
          serializer.toJson<String?>(onboardingCompletedAt),
    };
  }

  UserSetting copyWith(
          {int? id,
          String? userName,
          Value<String?> avatarPath = const Value.absent(),
          String? themeSeedColor,
          int? themeMode,
          bool? reminderEnabled,
          String? reminderTime,
          Value<String?> streakLastDate = const Value.absent(),
          int? globalStreak,
          int? globalFrozenStreak,
          String? ollamaUrl,
          String? ollamaModel,
          Value<String?> onboardingCompletedAt = const Value.absent()}) =>
      UserSetting(
        id: id ?? this.id,
        userName: userName ?? this.userName,
        avatarPath: avatarPath.present ? avatarPath.value : this.avatarPath,
        themeSeedColor: themeSeedColor ?? this.themeSeedColor,
        themeMode: themeMode ?? this.themeMode,
        reminderEnabled: reminderEnabled ?? this.reminderEnabled,
        reminderTime: reminderTime ?? this.reminderTime,
        streakLastDate:
            streakLastDate.present ? streakLastDate.value : this.streakLastDate,
        globalStreak: globalStreak ?? this.globalStreak,
        globalFrozenStreak: globalFrozenStreak ?? this.globalFrozenStreak,
        ollamaUrl: ollamaUrl ?? this.ollamaUrl,
        ollamaModel: ollamaModel ?? this.ollamaModel,
        onboardingCompletedAt: onboardingCompletedAt.present
            ? onboardingCompletedAt.value
            : this.onboardingCompletedAt,
      );
  UserSetting copyWithCompanion(UserSettingsCompanion data) {
    return UserSetting(
      id: data.id.present ? data.id.value : this.id,
      userName: data.userName.present ? data.userName.value : this.userName,
      avatarPath:
          data.avatarPath.present ? data.avatarPath.value : this.avatarPath,
      themeSeedColor: data.themeSeedColor.present
          ? data.themeSeedColor.value
          : this.themeSeedColor,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      reminderEnabled: data.reminderEnabled.present
          ? data.reminderEnabled.value
          : this.reminderEnabled,
      reminderTime: data.reminderTime.present
          ? data.reminderTime.value
          : this.reminderTime,
      streakLastDate: data.streakLastDate.present
          ? data.streakLastDate.value
          : this.streakLastDate,
      globalStreak: data.globalStreak.present
          ? data.globalStreak.value
          : this.globalStreak,
      globalFrozenStreak: data.globalFrozenStreak.present
          ? data.globalFrozenStreak.value
          : this.globalFrozenStreak,
      ollamaUrl: data.ollamaUrl.present ? data.ollamaUrl.value : this.ollamaUrl,
      ollamaModel:
          data.ollamaModel.present ? data.ollamaModel.value : this.ollamaModel,
      onboardingCompletedAt: data.onboardingCompletedAt.present
          ? data.onboardingCompletedAt.value
          : this.onboardingCompletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSetting(')
          ..write('id: $id, ')
          ..write('userName: $userName, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('themeSeedColor: $themeSeedColor, ')
          ..write('themeMode: $themeMode, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('streakLastDate: $streakLastDate, ')
          ..write('globalStreak: $globalStreak, ')
          ..write('globalFrozenStreak: $globalFrozenStreak, ')
          ..write('ollamaUrl: $ollamaUrl, ')
          ..write('ollamaModel: $ollamaModel, ')
          ..write('onboardingCompletedAt: $onboardingCompletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      userName,
      avatarPath,
      themeSeedColor,
      themeMode,
      reminderEnabled,
      reminderTime,
      streakLastDate,
      globalStreak,
      globalFrozenStreak,
      ollamaUrl,
      ollamaModel,
      onboardingCompletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSetting &&
          other.id == this.id &&
          other.userName == this.userName &&
          other.avatarPath == this.avatarPath &&
          other.themeSeedColor == this.themeSeedColor &&
          other.themeMode == this.themeMode &&
          other.reminderEnabled == this.reminderEnabled &&
          other.reminderTime == this.reminderTime &&
          other.streakLastDate == this.streakLastDate &&
          other.globalStreak == this.globalStreak &&
          other.globalFrozenStreak == this.globalFrozenStreak &&
          other.ollamaUrl == this.ollamaUrl &&
          other.ollamaModel == this.ollamaModel &&
          other.onboardingCompletedAt == this.onboardingCompletedAt);
}

class UserSettingsCompanion extends UpdateCompanion<UserSetting> {
  final Value<int> id;
  final Value<String> userName;
  final Value<String?> avatarPath;
  final Value<String> themeSeedColor;
  final Value<int> themeMode;
  final Value<bool> reminderEnabled;
  final Value<String> reminderTime;
  final Value<String?> streakLastDate;
  final Value<int> globalStreak;
  final Value<int> globalFrozenStreak;
  final Value<String> ollamaUrl;
  final Value<String> ollamaModel;
  final Value<String?> onboardingCompletedAt;
  const UserSettingsCompanion({
    this.id = const Value.absent(),
    this.userName = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.themeSeedColor = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.reminderTime = const Value.absent(),
    this.streakLastDate = const Value.absent(),
    this.globalStreak = const Value.absent(),
    this.globalFrozenStreak = const Value.absent(),
    this.ollamaUrl = const Value.absent(),
    this.ollamaModel = const Value.absent(),
    this.onboardingCompletedAt = const Value.absent(),
  });
  UserSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.userName = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.themeSeedColor = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.reminderTime = const Value.absent(),
    this.streakLastDate = const Value.absent(),
    this.globalStreak = const Value.absent(),
    this.globalFrozenStreak = const Value.absent(),
    this.ollamaUrl = const Value.absent(),
    this.ollamaModel = const Value.absent(),
    this.onboardingCompletedAt = const Value.absent(),
  });
  static Insertable<UserSetting> custom({
    Expression<int>? id,
    Expression<String>? userName,
    Expression<String>? avatarPath,
    Expression<String>? themeSeedColor,
    Expression<int>? themeMode,
    Expression<bool>? reminderEnabled,
    Expression<String>? reminderTime,
    Expression<String>? streakLastDate,
    Expression<int>? globalStreak,
    Expression<int>? globalFrozenStreak,
    Expression<String>? ollamaUrl,
    Expression<String>? ollamaModel,
    Expression<String>? onboardingCompletedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userName != null) 'user_name': userName,
      if (avatarPath != null) 'avatar_path': avatarPath,
      if (themeSeedColor != null) 'theme_seed_color': themeSeedColor,
      if (themeMode != null) 'theme_mode': themeMode,
      if (reminderEnabled != null) 'reminder_enabled': reminderEnabled,
      if (reminderTime != null) 'reminder_time': reminderTime,
      if (streakLastDate != null) 'streak_last_date': streakLastDate,
      if (globalStreak != null) 'global_streak': globalStreak,
      if (globalFrozenStreak != null)
        'global_frozen_streak': globalFrozenStreak,
      if (ollamaUrl != null) 'ollama_url': ollamaUrl,
      if (ollamaModel != null) 'ollama_model': ollamaModel,
      if (onboardingCompletedAt != null)
        'onboarding_completed_at': onboardingCompletedAt,
    });
  }

  UserSettingsCompanion copyWith(
      {Value<int>? id,
      Value<String>? userName,
      Value<String?>? avatarPath,
      Value<String>? themeSeedColor,
      Value<int>? themeMode,
      Value<bool>? reminderEnabled,
      Value<String>? reminderTime,
      Value<String?>? streakLastDate,
      Value<int>? globalStreak,
      Value<int>? globalFrozenStreak,
      Value<String>? ollamaUrl,
      Value<String>? ollamaModel,
      Value<String?>? onboardingCompletedAt}) {
    return UserSettingsCompanion(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      avatarPath: avatarPath ?? this.avatarPath,
      themeSeedColor: themeSeedColor ?? this.themeSeedColor,
      themeMode: themeMode ?? this.themeMode,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      streakLastDate: streakLastDate ?? this.streakLastDate,
      globalStreak: globalStreak ?? this.globalStreak,
      globalFrozenStreak: globalFrozenStreak ?? this.globalFrozenStreak,
      ollamaUrl: ollamaUrl ?? this.ollamaUrl,
      ollamaModel: ollamaModel ?? this.ollamaModel,
      onboardingCompletedAt:
          onboardingCompletedAt ?? this.onboardingCompletedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userName.present) {
      map['user_name'] = Variable<String>(userName.value);
    }
    if (avatarPath.present) {
      map['avatar_path'] = Variable<String>(avatarPath.value);
    }
    if (themeSeedColor.present) {
      map['theme_seed_color'] = Variable<String>(themeSeedColor.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<int>(themeMode.value);
    }
    if (reminderEnabled.present) {
      map['reminder_enabled'] = Variable<bool>(reminderEnabled.value);
    }
    if (reminderTime.present) {
      map['reminder_time'] = Variable<String>(reminderTime.value);
    }
    if (streakLastDate.present) {
      map['streak_last_date'] = Variable<String>(streakLastDate.value);
    }
    if (globalStreak.present) {
      map['global_streak'] = Variable<int>(globalStreak.value);
    }
    if (globalFrozenStreak.present) {
      map['global_frozen_streak'] = Variable<int>(globalFrozenStreak.value);
    }
    if (ollamaUrl.present) {
      map['ollama_url'] = Variable<String>(ollamaUrl.value);
    }
    if (ollamaModel.present) {
      map['ollama_model'] = Variable<String>(ollamaModel.value);
    }
    if (onboardingCompletedAt.present) {
      map['onboarding_completed_at'] =
          Variable<String>(onboardingCompletedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsCompanion(')
          ..write('id: $id, ')
          ..write('userName: $userName, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('themeSeedColor: $themeSeedColor, ')
          ..write('themeMode: $themeMode, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('streakLastDate: $streakLastDate, ')
          ..write('globalStreak: $globalStreak, ')
          ..write('globalFrozenStreak: $globalFrozenStreak, ')
          ..write('ollamaUrl: $ollamaUrl, ')
          ..write('ollamaModel: $ollamaModel, ')
          ..write('onboardingCompletedAt: $onboardingCompletedAt')
          ..write(')'))
        .toString();
  }
}

class $ChatMessagesTable extends ChatMessages
    with TableInfo<$ChatMessagesTable, ChatMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatMessagesTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> timestamp = GeneratedColumn<String>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
      'session_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns =>
      [id, role, content, timestamp, sessionId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_messages';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatMessage(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}timestamp'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}session_id'])!,
    );
  }

  @override
  $ChatMessagesTable createAlias(String alias) {
    return $ChatMessagesTable(attachedDatabase, alias);
  }
}

class ChatMessage extends DataClass implements Insertable<ChatMessage> {
  final int id;
  final String role;
  final String content;
  final String timestamp;
  final int sessionId;
  const ChatMessage(
      {required this.id,
      required this.role,
      required this.content,
      required this.timestamp,
      required this.sessionId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['role'] = Variable<String>(role);
    map['content'] = Variable<String>(content);
    map['timestamp'] = Variable<String>(timestamp);
    map['session_id'] = Variable<int>(sessionId);
    return map;
  }

  ChatMessagesCompanion toCompanion(bool nullToAbsent) {
    return ChatMessagesCompanion(
      id: Value(id),
      role: Value(role),
      content: Value(content),
      timestamp: Value(timestamp),
      sessionId: Value(sessionId),
    );
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatMessage(
      id: serializer.fromJson<int>(json['id']),
      role: serializer.fromJson<String>(json['role']),
      content: serializer.fromJson<String>(json['content']),
      timestamp: serializer.fromJson<String>(json['timestamp']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'role': serializer.toJson<String>(role),
      'content': serializer.toJson<String>(content),
      'timestamp': serializer.toJson<String>(timestamp),
      'sessionId': serializer.toJson<int>(sessionId),
    };
  }

  ChatMessage copyWith(
          {int? id,
          String? role,
          String? content,
          String? timestamp,
          int? sessionId}) =>
      ChatMessage(
        id: id ?? this.id,
        role: role ?? this.role,
        content: content ?? this.content,
        timestamp: timestamp ?? this.timestamp,
        sessionId: sessionId ?? this.sessionId,
      );
  ChatMessage copyWithCompanion(ChatMessagesCompanion data) {
    return ChatMessage(
      id: data.id.present ? data.id.value : this.id,
      role: data.role.present ? data.role.value : this.role,
      content: data.content.present ? data.content.value : this.content,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessage(')
          ..write('id: $id, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('timestamp: $timestamp, ')
          ..write('sessionId: $sessionId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, role, content, timestamp, sessionId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatMessage &&
          other.id == this.id &&
          other.role == this.role &&
          other.content == this.content &&
          other.timestamp == this.timestamp &&
          other.sessionId == this.sessionId);
}

class ChatMessagesCompanion extends UpdateCompanion<ChatMessage> {
  final Value<int> id;
  final Value<String> role;
  final Value<String> content;
  final Value<String> timestamp;
  final Value<int> sessionId;
  const ChatMessagesCompanion({
    this.id = const Value.absent(),
    this.role = const Value.absent(),
    this.content = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.sessionId = const Value.absent(),
  });
  ChatMessagesCompanion.insert({
    this.id = const Value.absent(),
    required String role,
    required String content,
    required String timestamp,
    this.sessionId = const Value.absent(),
  })  : role = Value(role),
        content = Value(content),
        timestamp = Value(timestamp);
  static Insertable<ChatMessage> custom({
    Expression<int>? id,
    Expression<String>? role,
    Expression<String>? content,
    Expression<String>? timestamp,
    Expression<int>? sessionId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (role != null) 'role': role,
      if (content != null) 'content': content,
      if (timestamp != null) 'timestamp': timestamp,
      if (sessionId != null) 'session_id': sessionId,
    });
  }

  ChatMessagesCompanion copyWith(
      {Value<int>? id,
      Value<String>? role,
      Value<String>? content,
      Value<String>? timestamp,
      Value<int>? sessionId}) {
    return ChatMessagesCompanion(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      sessionId: sessionId ?? this.sessionId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<String>(timestamp.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessagesCompanion(')
          ..write('id: $id, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('timestamp: $timestamp, ')
          ..write('sessionId: $sessionId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GoalsTable goals = $GoalsTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $UserSettingsTable userSettings = $UserSettingsTable(this);
  late final $ChatMessagesTable chatMessages = $ChatMessagesTable(this);
  late final GoalsDao goalsDao = GoalsDao(this as AppDatabase);
  late final TransactionsDao transactionsDao =
      TransactionsDao(this as AppDatabase);
  late final SettingsDao settingsDao = SettingsDao(this as AppDatabase);
  late final ChatDao chatDao = ChatDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [goals, transactions, userSettings, chatMessages];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$GoalsTableCreateCompanionBuilder = GoalsCompanion Function({
  Value<int> id,
  required String title,
  Value<String> emoji,
  required double targetAmount,
  Value<double> currentAmount,
  Value<String?> deadline,
  Value<String> colorHex,
  Value<String?> description,
  Value<bool> isArchived,
  Value<int> streak,
  Value<int> frozenStreak,
  Value<String?> streakLastDate,
  required String createdAt,
});
typedef $$GoalsTableUpdateCompanionBuilder = GoalsCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String> emoji,
  Value<double> targetAmount,
  Value<double> currentAmount,
  Value<String?> deadline,
  Value<String> colorHex,
  Value<String?> description,
  Value<bool> isArchived,
  Value<int> streak,
  Value<int> frozenStreak,
  Value<String?> streakLastDate,
  Value<String> createdAt,
});

final class $$GoalsTableReferences
    extends BaseReferences<_$AppDatabase, $GoalsTable, Goal> {
  $$GoalsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
      _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.transactions,
          aliasName: $_aliasNameGenerator(db.goals.id, db.transactions.goalId));

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter((f) => f.goalId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$GoalsTableFilterComposer extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get emoji => $composableBuilder(
      column: $table.emoji, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get targetAmount => $composableBuilder(
      column: $table.targetAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get currentAmount => $composableBuilder(
      column: $table.currentAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deadline => $composableBuilder(
      column: $table.deadline, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get colorHex => $composableBuilder(
      column: $table.colorHex, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get streak => $composableBuilder(
      column: $table.streak, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get frozenStreak => $composableBuilder(
      column: $table.frozenStreak, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get streakLastDate => $composableBuilder(
      column: $table.streakLastDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> transactionsRefs(
      Expression<bool> Function($$TransactionsTableFilterComposer f) f) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.goalId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableFilterComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$GoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get emoji => $composableBuilder(
      column: $table.emoji, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get targetAmount => $composableBuilder(
      column: $table.targetAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get currentAmount => $composableBuilder(
      column: $table.currentAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deadline => $composableBuilder(
      column: $table.deadline, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get colorHex => $composableBuilder(
      column: $table.colorHex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get streak => $composableBuilder(
      column: $table.streak, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get frozenStreak => $composableBuilder(
      column: $table.frozenStreak,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get streakLastDate => $composableBuilder(
      column: $table.streakLastDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$GoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<double> get targetAmount => $composableBuilder(
      column: $table.targetAmount, builder: (column) => column);

  GeneratedColumn<double> get currentAmount => $composableBuilder(
      column: $table.currentAmount, builder: (column) => column);

  GeneratedColumn<String> get deadline =>
      $composableBuilder(column: $table.deadline, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => column);

  GeneratedColumn<int> get streak =>
      $composableBuilder(column: $table.streak, builder: (column) => column);

  GeneratedColumn<int> get frozenStreak => $composableBuilder(
      column: $table.frozenStreak, builder: (column) => column);

  GeneratedColumn<String> get streakLastDate => $composableBuilder(
      column: $table.streakLastDate, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> transactionsRefs<T extends Object>(
      Expression<T> Function($$TransactionsTableAnnotationComposer a) f) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.goalId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$GoalsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GoalsTable,
    Goal,
    $$GoalsTableFilterComposer,
    $$GoalsTableOrderingComposer,
    $$GoalsTableAnnotationComposer,
    $$GoalsTableCreateCompanionBuilder,
    $$GoalsTableUpdateCompanionBuilder,
    (Goal, $$GoalsTableReferences),
    Goal,
    PrefetchHooks Function({bool transactionsRefs})> {
  $$GoalsTableTableManager(_$AppDatabase db, $GoalsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> emoji = const Value.absent(),
            Value<double> targetAmount = const Value.absent(),
            Value<double> currentAmount = const Value.absent(),
            Value<String?> deadline = const Value.absent(),
            Value<String> colorHex = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
            Value<int> streak = const Value.absent(),
            Value<int> frozenStreak = const Value.absent(),
            Value<String?> streakLastDate = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
          }) =>
              GoalsCompanion(
            id: id,
            title: title,
            emoji: emoji,
            targetAmount: targetAmount,
            currentAmount: currentAmount,
            deadline: deadline,
            colorHex: colorHex,
            description: description,
            isArchived: isArchived,
            streak: streak,
            frozenStreak: frozenStreak,
            streakLastDate: streakLastDate,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            Value<String> emoji = const Value.absent(),
            required double targetAmount,
            Value<double> currentAmount = const Value.absent(),
            Value<String?> deadline = const Value.absent(),
            Value<String> colorHex = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
            Value<int> streak = const Value.absent(),
            Value<int> frozenStreak = const Value.absent(),
            Value<String?> streakLastDate = const Value.absent(),
            required String createdAt,
          }) =>
              GoalsCompanion.insert(
            id: id,
            title: title,
            emoji: emoji,
            targetAmount: targetAmount,
            currentAmount: currentAmount,
            deadline: deadline,
            colorHex: colorHex,
            description: description,
            isArchived: isArchived,
            streak: streak,
            frozenStreak: frozenStreak,
            streakLastDate: streakLastDate,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$GoalsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({transactionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (transactionsRefs) db.transactions],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionsRefs)
                    await $_getPrefetchedData<Goal, $GoalsTable, Transaction>(
                        currentTable: table,
                        referencedTable:
                            $$GoalsTableReferences._transactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$GoalsTableReferences(db, table, p0)
                                .transactionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.goalId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$GoalsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GoalsTable,
    Goal,
    $$GoalsTableFilterComposer,
    $$GoalsTableOrderingComposer,
    $$GoalsTableAnnotationComposer,
    $$GoalsTableCreateCompanionBuilder,
    $$GoalsTableUpdateCompanionBuilder,
    (Goal, $$GoalsTableReferences),
    Goal,
    PrefetchHooks Function({bool transactionsRefs})>;
typedef $$TransactionsTableCreateCompanionBuilder = TransactionsCompanion
    Function({
  Value<int> id,
  required int goalId,
  required double amount,
  required String date,
  required String category,
  Value<String?> note,
});
typedef $$TransactionsTableUpdateCompanionBuilder = TransactionsCompanion
    Function({
  Value<int> id,
  Value<int> goalId,
  Value<double> amount,
  Value<String> date,
  Value<String> category,
  Value<String?> note,
});

final class $$TransactionsTableReferences
    extends BaseReferences<_$AppDatabase, $TransactionsTable, Transaction> {
  $$TransactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GoalsTable _goalIdTable(_$AppDatabase db) => db.goals
      .createAlias($_aliasNameGenerator(db.transactions.goalId, db.goals.id));

  $$GoalsTableProcessedTableManager get goalId {
    final $_column = $_itemColumn<int>('goal_id')!;

    final manager = $$GoalsTableTableManager($_db, $_db.goals)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_goalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  $$GoalsTableFilterComposer get goalId {
    final $$GoalsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.goalId,
        referencedTable: $db.goals,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GoalsTableFilterComposer(
              $db: $db,
              $table: $db.goals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  $$GoalsTableOrderingComposer get goalId {
    final $$GoalsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.goalId,
        referencedTable: $db.goals,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GoalsTableOrderingComposer(
              $db: $db,
              $table: $db.goals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$GoalsTableAnnotationComposer get goalId {
    final $$GoalsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.goalId,
        referencedTable: $db.goals,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GoalsTableAnnotationComposer(
              $db: $db,
              $table: $db.goals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (Transaction, $$TransactionsTableReferences),
    Transaction,
    PrefetchHooks Function({bool goalId})> {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> goalId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String?> note = const Value.absent(),
          }) =>
              TransactionsCompanion(
            id: id,
            goalId: goalId,
            amount: amount,
            date: date,
            category: category,
            note: note,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int goalId,
            required double amount,
            required String date,
            required String category,
            Value<String?> note = const Value.absent(),
          }) =>
              TransactionsCompanion.insert(
            id: id,
            goalId: goalId,
            amount: amount,
            date: date,
            category: category,
            note: note,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TransactionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({goalId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (goalId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.goalId,
                    referencedTable:
                        $$TransactionsTableReferences._goalIdTable(db),
                    referencedColumn:
                        $$TransactionsTableReferences._goalIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TransactionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (Transaction, $$TransactionsTableReferences),
    Transaction,
    PrefetchHooks Function({bool goalId})>;
typedef $$UserSettingsTableCreateCompanionBuilder = UserSettingsCompanion
    Function({
  Value<int> id,
  Value<String> userName,
  Value<String?> avatarPath,
  Value<String> themeSeedColor,
  Value<int> themeMode,
  Value<bool> reminderEnabled,
  Value<String> reminderTime,
  Value<String?> streakLastDate,
  Value<int> globalStreak,
  Value<int> globalFrozenStreak,
  Value<String> ollamaUrl,
  Value<String> ollamaModel,
  Value<String?> onboardingCompletedAt,
});
typedef $$UserSettingsTableUpdateCompanionBuilder = UserSettingsCompanion
    Function({
  Value<int> id,
  Value<String> userName,
  Value<String?> avatarPath,
  Value<String> themeSeedColor,
  Value<int> themeMode,
  Value<bool> reminderEnabled,
  Value<String> reminderTime,
  Value<String?> streakLastDate,
  Value<int> globalStreak,
  Value<int> globalFrozenStreak,
  Value<String> ollamaUrl,
  Value<String> ollamaModel,
  Value<String?> onboardingCompletedAt,
});

class $$UserSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userName => $composableBuilder(
      column: $table.userName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatarPath => $composableBuilder(
      column: $table.avatarPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get themeSeedColor => $composableBuilder(
      column: $table.themeSeedColor,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get themeMode => $composableBuilder(
      column: $table.themeMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get reminderEnabled => $composableBuilder(
      column: $table.reminderEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reminderTime => $composableBuilder(
      column: $table.reminderTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get streakLastDate => $composableBuilder(
      column: $table.streakLastDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get globalStreak => $composableBuilder(
      column: $table.globalStreak, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get globalFrozenStreak => $composableBuilder(
      column: $table.globalFrozenStreak,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ollamaUrl => $composableBuilder(
      column: $table.ollamaUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ollamaModel => $composableBuilder(
      column: $table.ollamaModel, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get onboardingCompletedAt => $composableBuilder(
      column: $table.onboardingCompletedAt,
      builder: (column) => ColumnFilters(column));
}

class $$UserSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userName => $composableBuilder(
      column: $table.userName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatarPath => $composableBuilder(
      column: $table.avatarPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get themeSeedColor => $composableBuilder(
      column: $table.themeSeedColor,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get themeMode => $composableBuilder(
      column: $table.themeMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get reminderEnabled => $composableBuilder(
      column: $table.reminderEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reminderTime => $composableBuilder(
      column: $table.reminderTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get streakLastDate => $composableBuilder(
      column: $table.streakLastDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get globalStreak => $composableBuilder(
      column: $table.globalStreak,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get globalFrozenStreak => $composableBuilder(
      column: $table.globalFrozenStreak,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ollamaUrl => $composableBuilder(
      column: $table.ollamaUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ollamaModel => $composableBuilder(
      column: $table.ollamaModel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get onboardingCompletedAt => $composableBuilder(
      column: $table.onboardingCompletedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$UserSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userName =>
      $composableBuilder(column: $table.userName, builder: (column) => column);

  GeneratedColumn<String> get avatarPath => $composableBuilder(
      column: $table.avatarPath, builder: (column) => column);

  GeneratedColumn<String> get themeSeedColor => $composableBuilder(
      column: $table.themeSeedColor, builder: (column) => column);

  GeneratedColumn<int> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<bool> get reminderEnabled => $composableBuilder(
      column: $table.reminderEnabled, builder: (column) => column);

  GeneratedColumn<String> get reminderTime => $composableBuilder(
      column: $table.reminderTime, builder: (column) => column);

  GeneratedColumn<String> get streakLastDate => $composableBuilder(
      column: $table.streakLastDate, builder: (column) => column);

  GeneratedColumn<int> get globalStreak => $composableBuilder(
      column: $table.globalStreak, builder: (column) => column);

  GeneratedColumn<int> get globalFrozenStreak => $composableBuilder(
      column: $table.globalFrozenStreak, builder: (column) => column);

  GeneratedColumn<String> get ollamaUrl =>
      $composableBuilder(column: $table.ollamaUrl, builder: (column) => column);

  GeneratedColumn<String> get ollamaModel => $composableBuilder(
      column: $table.ollamaModel, builder: (column) => column);

  GeneratedColumn<String> get onboardingCompletedAt => $composableBuilder(
      column: $table.onboardingCompletedAt, builder: (column) => column);
}

class $$UserSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserSettingsTable,
    UserSetting,
    $$UserSettingsTableFilterComposer,
    $$UserSettingsTableOrderingComposer,
    $$UserSettingsTableAnnotationComposer,
    $$UserSettingsTableCreateCompanionBuilder,
    $$UserSettingsTableUpdateCompanionBuilder,
    (
      UserSetting,
      BaseReferences<_$AppDatabase, $UserSettingsTable, UserSetting>
    ),
    UserSetting,
    PrefetchHooks Function()> {
  $$UserSettingsTableTableManager(_$AppDatabase db, $UserSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> userName = const Value.absent(),
            Value<String?> avatarPath = const Value.absent(),
            Value<String> themeSeedColor = const Value.absent(),
            Value<int> themeMode = const Value.absent(),
            Value<bool> reminderEnabled = const Value.absent(),
            Value<String> reminderTime = const Value.absent(),
            Value<String?> streakLastDate = const Value.absent(),
            Value<int> globalStreak = const Value.absent(),
            Value<int> globalFrozenStreak = const Value.absent(),
            Value<String> ollamaUrl = const Value.absent(),
            Value<String> ollamaModel = const Value.absent(),
            Value<String?> onboardingCompletedAt = const Value.absent(),
          }) =>
              UserSettingsCompanion(
            id: id,
            userName: userName,
            avatarPath: avatarPath,
            themeSeedColor: themeSeedColor,
            themeMode: themeMode,
            reminderEnabled: reminderEnabled,
            reminderTime: reminderTime,
            streakLastDate: streakLastDate,
            globalStreak: globalStreak,
            globalFrozenStreak: globalFrozenStreak,
            ollamaUrl: ollamaUrl,
            ollamaModel: ollamaModel,
            onboardingCompletedAt: onboardingCompletedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> userName = const Value.absent(),
            Value<String?> avatarPath = const Value.absent(),
            Value<String> themeSeedColor = const Value.absent(),
            Value<int> themeMode = const Value.absent(),
            Value<bool> reminderEnabled = const Value.absent(),
            Value<String> reminderTime = const Value.absent(),
            Value<String?> streakLastDate = const Value.absent(),
            Value<int> globalStreak = const Value.absent(),
            Value<int> globalFrozenStreak = const Value.absent(),
            Value<String> ollamaUrl = const Value.absent(),
            Value<String> ollamaModel = const Value.absent(),
            Value<String?> onboardingCompletedAt = const Value.absent(),
          }) =>
              UserSettingsCompanion.insert(
            id: id,
            userName: userName,
            avatarPath: avatarPath,
            themeSeedColor: themeSeedColor,
            themeMode: themeMode,
            reminderEnabled: reminderEnabled,
            reminderTime: reminderTime,
            streakLastDate: streakLastDate,
            globalStreak: globalStreak,
            globalFrozenStreak: globalFrozenStreak,
            ollamaUrl: ollamaUrl,
            ollamaModel: ollamaModel,
            onboardingCompletedAt: onboardingCompletedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserSettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserSettingsTable,
    UserSetting,
    $$UserSettingsTableFilterComposer,
    $$UserSettingsTableOrderingComposer,
    $$UserSettingsTableAnnotationComposer,
    $$UserSettingsTableCreateCompanionBuilder,
    $$UserSettingsTableUpdateCompanionBuilder,
    (
      UserSetting,
      BaseReferences<_$AppDatabase, $UserSettingsTable, UserSetting>
    ),
    UserSetting,
    PrefetchHooks Function()>;
typedef $$ChatMessagesTableCreateCompanionBuilder = ChatMessagesCompanion
    Function({
  Value<int> id,
  required String role,
  required String content,
  required String timestamp,
  Value<int> sessionId,
});
typedef $$ChatMessagesTableUpdateCompanionBuilder = ChatMessagesCompanion
    Function({
  Value<int> id,
  Value<String> role,
  Value<String> content,
  Value<String> timestamp,
  Value<int> sessionId,
});

class $$ChatMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnFilters(column));
}

class $$ChatMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnOrderings(column));
}

class $$ChatMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<int> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);
}

class $$ChatMessagesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChatMessagesTable,
    ChatMessage,
    $$ChatMessagesTableFilterComposer,
    $$ChatMessagesTableOrderingComposer,
    $$ChatMessagesTableAnnotationComposer,
    $$ChatMessagesTableCreateCompanionBuilder,
    $$ChatMessagesTableUpdateCompanionBuilder,
    (
      ChatMessage,
      BaseReferences<_$AppDatabase, $ChatMessagesTable, ChatMessage>
    ),
    ChatMessage,
    PrefetchHooks Function()> {
  $$ChatMessagesTableTableManager(_$AppDatabase db, $ChatMessagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<String> timestamp = const Value.absent(),
            Value<int> sessionId = const Value.absent(),
          }) =>
              ChatMessagesCompanion(
            id: id,
            role: role,
            content: content,
            timestamp: timestamp,
            sessionId: sessionId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String role,
            required String content,
            required String timestamp,
            Value<int> sessionId = const Value.absent(),
          }) =>
              ChatMessagesCompanion.insert(
            id: id,
            role: role,
            content: content,
            timestamp: timestamp,
            sessionId: sessionId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChatMessagesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChatMessagesTable,
    ChatMessage,
    $$ChatMessagesTableFilterComposer,
    $$ChatMessagesTableOrderingComposer,
    $$ChatMessagesTableAnnotationComposer,
    $$ChatMessagesTableCreateCompanionBuilder,
    $$ChatMessagesTableUpdateCompanionBuilder,
    (
      ChatMessage,
      BaseReferences<_$AppDatabase, $ChatMessagesTable, ChatMessage>
    ),
    ChatMessage,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GoalsTableTableManager get goals =>
      $$GoalsTableTableManager(_db, _db.goals);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$UserSettingsTableTableManager get userSettings =>
      $$UserSettingsTableTableManager(_db, _db.userSettings);
  $$ChatMessagesTableTableManager get chatMessages =>
      $$ChatMessagesTableTableManager(_db, _db.chatMessages);
}
