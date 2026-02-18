// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UserProfileStruct extends BaseStruct {
  UserProfileStruct({
    String? fullName,
    String? email,
    int? age,
    String? gender,
    double? heightCm,
    double? weightKg,
    String? goal,
    String? activityLevel,
    String? dietaryPreference,
    int? calculatedBMR,
    int? calculatedTDEE,
    int? dailyCalorieGoal,
    bool? onboardingCompleted,
  })  : _fullName = fullName,
        _email = email,
        _age = age,
        _gender = gender,
        _heightCm = heightCm,
        _weightKg = weightKg,
        _goal = goal,
        _activityLevel = activityLevel,
        _dietaryPreference = dietaryPreference,
        _calculatedBMR = calculatedBMR,
        _calculatedTDEE = calculatedTDEE,
        _dailyCalorieGoal = dailyCalorieGoal,
        _onboardingCompleted = onboardingCompleted;

  // "fullName" field.
  String? _fullName;
  String get fullName => _fullName ?? '';
  set fullName(String? val) => _fullName = val;
  bool hasFullName() => _fullName != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  set email(String? val) => _email = val;
  bool hasEmail() => _email != null;

  // "age" field.
  int? _age;
  int get age => _age ?? 0;
  set age(int? val) => _age = val;
  void incrementAge(int amount) => age = age + amount;
  bool hasAge() => _age != null;

  // "gender" field.
  String? _gender;
  String get gender => _gender ?? '';
  set gender(String? val) => _gender = val;
  bool hasGender() => _gender != null;

  // "heightCm" field.
  double? _heightCm;
  double get heightCm => _heightCm ?? 0.0;
  set heightCm(double? val) => _heightCm = val;
  void incrementHeightCm(double amount) => heightCm = heightCm + amount;
  bool hasHeightCm() => _heightCm != null;

  // "weightKg" field.
  double? _weightKg;
  double get weightKg => _weightKg ?? 0.0;
  set weightKg(double? val) => _weightKg = val;
  void incrementWeightKg(double amount) => weightKg = weightKg + amount;
  bool hasWeightKg() => _weightKg != null;

  // "goal" field.
  String? _goal;
  String get goal => _goal ?? '';
  set goal(String? val) => _goal = val;
  bool hasGoal() => _goal != null;

  // "activityLevel" field.
  String? _activityLevel;
  String get activityLevel => _activityLevel ?? '';
  set activityLevel(String? val) => _activityLevel = val;
  bool hasActivityLevel() => _activityLevel != null;

  // "dietaryPreference" field.
  String? _dietaryPreference;
  String get dietaryPreference => _dietaryPreference ?? '';
  set dietaryPreference(String? val) => _dietaryPreference = val;
  bool hasDietaryPreference() => _dietaryPreference != null;

  // "calculatedBMR" field.
  int? _calculatedBMR;
  int get calculatedBMR => _calculatedBMR ?? 0;
  set calculatedBMR(int? val) => _calculatedBMR = val;
  void incrementCalculatedBMR(int amount) => calculatedBMR = calculatedBMR + amount;
  bool hasCalculatedBMR() => _calculatedBMR != null;

  // "calculatedTDEE" field.
  int? _calculatedTDEE;
  int get calculatedTDEE => _calculatedTDEE ?? 0;
  set calculatedTDEE(int? val) => _calculatedTDEE = val;
  void incrementCalculatedTDEE(int amount) => calculatedTDEE = calculatedTDEE + amount;
  bool hasCalculatedTDEE() => _calculatedTDEE != null;

  // "dailyCalorieGoal" field.
  int? _dailyCalorieGoal;
  int get dailyCalorieGoal => _dailyCalorieGoal ?? 0;
  set dailyCalorieGoal(int? val) => _dailyCalorieGoal = val;
  void incrementDailyCalorieGoal(int amount) => dailyCalorieGoal = dailyCalorieGoal + amount;
  bool hasDailyCalorieGoal() => _dailyCalorieGoal != null;

  // "onboardingCompleted" field.
  bool? _onboardingCompleted;
  bool get onboardingCompleted => _onboardingCompleted ?? false;
  set onboardingCompleted(bool? val) => _onboardingCompleted = val;
  bool hasOnboardingCompleted() => _onboardingCompleted != null;

  static UserProfileStruct fromMap(Map<String, dynamic> data) =>
      UserProfileStruct(
        fullName: data['fullName'] as String?,
        email: data['email'] as String?,
        age: castToType<int>(data['age']),
        gender: data['gender'] as String?,
        heightCm: castToType<double>(data['heightCm']),
        weightKg: castToType<double>(data['weightKg']),
        goal: data['goal'] as String?,
        activityLevel: data['activityLevel'] as String?,
        dietaryPreference: data['dietaryPreference'] as String?,
        calculatedBMR: castToType<int>(data['calculatedBMR']),
        calculatedTDEE: castToType<int>(data['calculatedTDEE']),
        dailyCalorieGoal: castToType<int>(data['dailyCalorieGoal']),
        onboardingCompleted: data['onboardingCompleted'] as bool?,
      );

  static UserProfileStruct? maybeFromMap(dynamic data) => data is Map
      ? UserProfileStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'fullName': _fullName,
        'email': _email,
        'age': _age,
        'gender': _gender,
        'heightCm': _heightCm,
        'weightKg': _weightKg,
        'goal': _goal,
        'activityLevel': _activityLevel,
        'dietaryPreference': _dietaryPreference,
        'calculatedBMR': _calculatedBMR,
        'calculatedTDEE': _calculatedTDEE,
        'dailyCalorieGoal': _dailyCalorieGoal,
        'onboardingCompleted': _onboardingCompleted,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'fullName': serializeParam(
          _fullName,
          ParamType.String,
        ),
        'email': serializeParam(
          _email,
          ParamType.String,
        ),
        'age': serializeParam(
          _age,
          ParamType.int,
        ),
        'gender': serializeParam(
          _gender,
          ParamType.String,
        ),
        'heightCm': serializeParam(
          _heightCm,
          ParamType.double,
        ),
        'weightKg': serializeParam(
          _weightKg,
          ParamType.double,
        ),
        'goal': serializeParam(
          _goal,
          ParamType.String,
        ),
        'activityLevel': serializeParam(
          _activityLevel,
          ParamType.String,
        ),
        'dietaryPreference': serializeParam(
          _dietaryPreference,
          ParamType.String,
        ),
        'calculatedBMR': serializeParam(
          _calculatedBMR,
          ParamType.int,
        ),
        'calculatedTDEE': serializeParam(
          _calculatedTDEE,
          ParamType.int,
        ),
        'dailyCalorieGoal': serializeParam(
          _dailyCalorieGoal,
          ParamType.int,
        ),
        'onboardingCompleted': serializeParam(
          _onboardingCompleted,
          ParamType.bool,
        ),
      }.withoutNulls;

  static UserProfileStruct fromSerializableMap(Map<String, dynamic> data) =>
      UserProfileStruct(
        fullName: deserializeParam(
          data['fullName'],
          ParamType.String,
          false,
        ),
        email: deserializeParam(
          data['email'],
          ParamType.String,
          false,
        ),
        age: deserializeParam(
          data['age'],
          ParamType.int,
          false,
        ),
        gender: deserializeParam(
          data['gender'],
          ParamType.String,
          false,
        ),
        heightCm: deserializeParam(
          data['heightCm'],
          ParamType.double,
          false,
        ),
        weightKg: deserializeParam(
          data['weightKg'],
          ParamType.double,
          false,
        ),
        goal: deserializeParam(
          data['goal'],
          ParamType.String,
          false,
        ),
        activityLevel: deserializeParam(
          data['activityLevel'],
          ParamType.String,
          false,
        ),
        dietaryPreference: deserializeParam(
          data['dietaryPreference'],
          ParamType.String,
          false,
        ),
        calculatedBMR: deserializeParam(
          data['calculatedBMR'],
          ParamType.int,
          false,
        ),
        calculatedTDEE: deserializeParam(
          data['calculatedTDEE'],
          ParamType.int,
          false,
        ),
        dailyCalorieGoal: deserializeParam(
          data['dailyCalorieGoal'],
          ParamType.int,
          false,
        ),
        onboardingCompleted: deserializeParam(
          data['onboardingCompleted'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'UserProfileStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is UserProfileStruct &&
        fullName == other.fullName &&
        email == other.email &&
        age == other.age &&
        gender == other.gender &&
        heightCm == other.heightCm &&
        weightKg == other.weightKg &&
        goal == other.goal &&
        activityLevel == other.activityLevel &&
        dietaryPreference == other.dietaryPreference &&
        calculatedBMR == other.calculatedBMR &&
        calculatedTDEE == other.calculatedTDEE &&
        dailyCalorieGoal == other.dailyCalorieGoal &&
        onboardingCompleted == other.onboardingCompleted;
  }

  @override
  int get hashCode => const ListEquality().hash([
        fullName,
        email,
        age,
        gender,
        heightCm,
        weightKg,
        goal,
        activityLevel,
        dietaryPreference,
        calculatedBMR,
        calculatedTDEE,
        dailyCalorieGoal,
        onboardingCompleted
      ]);
}

UserProfileStruct createUserProfileStruct({
  String? fullName,
  String? email,
  int? age,
  String? gender,
  double? heightCm,
  double? weightKg,
  String? goal,
  String? activityLevel,
  String? dietaryPreference,
  int? calculatedBMR,
  int? calculatedTDEE,
  int? dailyCalorieGoal,
  bool? onboardingCompleted,
}) =>
    UserProfileStruct(
      fullName: fullName,
      email: email,
      age: age,
      gender: gender,
      heightCm: heightCm,
      weightKg: weightKg,
      goal: goal,
      activityLevel: activityLevel,
      dietaryPreference: dietaryPreference,
      calculatedBMR: calculatedBMR,
      calculatedTDEE: calculatedTDEE,
      dailyCalorieGoal: dailyCalorieGoal,
      onboardingCompleted: onboardingCompleted,
    );

