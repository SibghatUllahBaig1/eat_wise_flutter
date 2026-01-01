// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RecipesStruct extends BaseStruct {
  RecipesStruct({
    String? title,
    String? content,
    String? image,
    List<String>? tags,
    int? cookTime,
    DateTime? createdAt,
    int? kcal,
    String? description,
  })  : _title = title,
        _content = content,
        _image = image,
        _tags = tags,
        _cookTime = cookTime,
        _createdAt = createdAt,
        _kcal = kcal,
        _description = description;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  set title(String? val) => _title = val;

  bool hasTitle() => _title != null;

  // "content" field.
  String? _content;
  String get content => _content ?? '';
  set content(String? val) => _content = val;

  bool hasContent() => _content != null;

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  set image(String? val) => _image = val;

  bool hasImage() => _image != null;

  // "tags" field.
  List<String>? _tags;
  List<String> get tags => _tags ?? const [];
  set tags(List<String>? val) => _tags = val;

  void updateTags(Function(List<String>) updateFn) {
    updateFn(_tags ??= []);
  }

  bool hasTags() => _tags != null;

  // "cook_time" field.
  int? _cookTime;
  int get cookTime => _cookTime ?? 0;
  set cookTime(int? val) => _cookTime = val;

  void incrementCookTime(int amount) => cookTime = cookTime + amount;

  bool hasCookTime() => _cookTime != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  set createdAt(DateTime? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  // "kcal" field.
  int? _kcal;
  int get kcal => _kcal ?? 0;
  set kcal(int? val) => _kcal = val;

  void incrementKcal(int amount) => kcal = kcal + amount;

  bool hasKcal() => _kcal != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

  static RecipesStruct fromMap(Map<String, dynamic> data) => RecipesStruct(
        title: data['title'] as String?,
        content: data['content'] as String?,
        image: data['image'] as String?,
        tags: getDataList(data['tags']),
        cookTime: castToType<int>(data['cook_time']),
        createdAt: data['created_at'] as DateTime?,
        kcal: castToType<int>(data['kcal']),
        description: data['description'] as String?,
      );

  static RecipesStruct? maybeFromMap(dynamic data) =>
      data is Map ? RecipesStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'title': _title,
        'content': _content,
        'image': _image,
        'tags': _tags,
        'cook_time': _cookTime,
        'created_at': _createdAt,
        'kcal': _kcal,
        'description': _description,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'title': serializeParam(
          _title,
          ParamType.String,
        ),
        'content': serializeParam(
          _content,
          ParamType.String,
        ),
        'image': serializeParam(
          _image,
          ParamType.String,
        ),
        'tags': serializeParam(
          _tags,
          ParamType.String,
          isList: true,
        ),
        'cook_time': serializeParam(
          _cookTime,
          ParamType.int,
        ),
        'created_at': serializeParam(
          _createdAt,
          ParamType.DateTime,
        ),
        'kcal': serializeParam(
          _kcal,
          ParamType.int,
        ),
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
      }.withoutNulls;

  static RecipesStruct fromSerializableMap(Map<String, dynamic> data) =>
      RecipesStruct(
        title: deserializeParam(
          data['title'],
          ParamType.String,
          false,
        ),
        content: deserializeParam(
          data['content'],
          ParamType.String,
          false,
        ),
        image: deserializeParam(
          data['image'],
          ParamType.String,
          false,
        ),
        tags: deserializeParam<String>(
          data['tags'],
          ParamType.String,
          true,
        ),
        cookTime: deserializeParam(
          data['cook_time'],
          ParamType.int,
          false,
        ),
        createdAt: deserializeParam(
          data['created_at'],
          ParamType.DateTime,
          false,
        ),
        kcal: deserializeParam(
          data['kcal'],
          ParamType.int,
          false,
        ),
        description: deserializeParam(
          data['description'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'RecipesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is RecipesStruct &&
        title == other.title &&
        content == other.content &&
        image == other.image &&
        listEquality.equals(tags, other.tags) &&
        cookTime == other.cookTime &&
        createdAt == other.createdAt &&
        kcal == other.kcal &&
        description == other.description;
  }

  @override
  int get hashCode => const ListEquality().hash(
      [title, content, image, tags, cookTime, createdAt, kcal, description]);
}

RecipesStruct createRecipesStruct({
  String? title,
  String? content,
  String? image,
  int? cookTime,
  DateTime? createdAt,
  int? kcal,
  String? description,
}) =>
    RecipesStruct(
      title: title,
      content: content,
      image: image,
      cookTime: cookTime,
      createdAt: createdAt,
      kcal: kcal,
      description: description,
    );
