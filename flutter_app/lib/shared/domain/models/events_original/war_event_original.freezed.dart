// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'war_event_original.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WarEventOriginal _$WarEventOriginalFromJson(Map<String, dynamic> json) {
  return _WarEventOriginal.fromJson(json);
}

/// @nodoc
mixin _$WarEventOriginal {
  String? get id => throw _privateConstructorUsedError;
  String get regimentId => throw _privateConstructorUsedError;
  EventKind get eventKind => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get documentSource => throw _privateConstructorUsedError;
  int get documentSourcePage => throw _privateConstructorUsedError;
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  GpsCoordinates? get coordinatesForMap => throw _privateConstructorUsedError;

  /// Serializes this WarEventOriginal to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WarEventOriginal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WarEventOriginalCopyWith<WarEventOriginal> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WarEventOriginalCopyWith<$Res> {
  factory $WarEventOriginalCopyWith(
    WarEventOriginal value,
    $Res Function(WarEventOriginal) then,
  ) = _$WarEventOriginalCopyWithImpl<$Res, WarEventOriginal>;
  @useResult
  $Res call({
    String? id,
    String regimentId,
    EventKind eventKind,
    String title,
    String description,
    String documentSource,
    int documentSourcePage,
    DateTime? startDate,
    DateTime? endDate,
    GpsCoordinates? coordinatesForMap,
  });
}

/// @nodoc
class _$WarEventOriginalCopyWithImpl<$Res, $Val extends WarEventOriginal>
    implements $WarEventOriginalCopyWith<$Res> {
  _$WarEventOriginalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WarEventOriginal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? regimentId = null,
    Object? eventKind = null,
    Object? title = null,
    Object? description = null,
    Object? documentSource = null,
    Object? documentSourcePage = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? coordinatesForMap = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                freezed == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String?,
            regimentId:
                null == regimentId
                    ? _value.regimentId
                    : regimentId // ignore: cast_nullable_to_non_nullable
                        as String,
            eventKind:
                null == eventKind
                    ? _value.eventKind
                    : eventKind // ignore: cast_nullable_to_non_nullable
                        as EventKind,
            title:
                null == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String,
            description:
                null == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String,
            documentSource:
                null == documentSource
                    ? _value.documentSource
                    : documentSource // ignore: cast_nullable_to_non_nullable
                        as String,
            documentSourcePage:
                null == documentSourcePage
                    ? _value.documentSourcePage
                    : documentSourcePage // ignore: cast_nullable_to_non_nullable
                        as int,
            startDate:
                freezed == startDate
                    ? _value.startDate
                    : startDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            endDate:
                freezed == endDate
                    ? _value.endDate
                    : endDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            coordinatesForMap:
                freezed == coordinatesForMap
                    ? _value.coordinatesForMap
                    : coordinatesForMap // ignore: cast_nullable_to_non_nullable
                        as GpsCoordinates?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WarEventOriginalImplCopyWith<$Res>
    implements $WarEventOriginalCopyWith<$Res> {
  factory _$$WarEventOriginalImplCopyWith(
    _$WarEventOriginalImpl value,
    $Res Function(_$WarEventOriginalImpl) then,
  ) = __$$WarEventOriginalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    String regimentId,
    EventKind eventKind,
    String title,
    String description,
    String documentSource,
    int documentSourcePage,
    DateTime? startDate,
    DateTime? endDate,
    GpsCoordinates? coordinatesForMap,
  });
}

/// @nodoc
class __$$WarEventOriginalImplCopyWithImpl<$Res>
    extends _$WarEventOriginalCopyWithImpl<$Res, _$WarEventOriginalImpl>
    implements _$$WarEventOriginalImplCopyWith<$Res> {
  __$$WarEventOriginalImplCopyWithImpl(
    _$WarEventOriginalImpl _value,
    $Res Function(_$WarEventOriginalImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WarEventOriginal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? regimentId = null,
    Object? eventKind = null,
    Object? title = null,
    Object? description = null,
    Object? documentSource = null,
    Object? documentSourcePage = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? coordinatesForMap = freezed,
  }) {
    return _then(
      _$WarEventOriginalImpl(
        id:
            freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String?,
        regimentId:
            null == regimentId
                ? _value.regimentId
                : regimentId // ignore: cast_nullable_to_non_nullable
                    as String,
        eventKind:
            null == eventKind
                ? _value.eventKind
                : eventKind // ignore: cast_nullable_to_non_nullable
                    as EventKind,
        title:
            null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String,
        description:
            null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String,
        documentSource:
            null == documentSource
                ? _value.documentSource
                : documentSource // ignore: cast_nullable_to_non_nullable
                    as String,
        documentSourcePage:
            null == documentSourcePage
                ? _value.documentSourcePage
                : documentSourcePage // ignore: cast_nullable_to_non_nullable
                    as int,
        startDate:
            freezed == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        endDate:
            freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        coordinatesForMap:
            freezed == coordinatesForMap
                ? _value.coordinatesForMap
                : coordinatesForMap // ignore: cast_nullable_to_non_nullable
                    as GpsCoordinates?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WarEventOriginalImpl implements _WarEventOriginal {
  _$WarEventOriginalImpl({
    this.id,
    required this.regimentId,
    required this.eventKind,
    required this.title,
    required this.description,
    required this.documentSource,
    required this.documentSourcePage,
    this.startDate,
    this.endDate,
    this.coordinatesForMap,
  });

  factory _$WarEventOriginalImpl.fromJson(Map<String, dynamic> json) =>
      _$$WarEventOriginalImplFromJson(json);

  @override
  final String? id;
  @override
  final String regimentId;
  @override
  final EventKind eventKind;
  @override
  final String title;
  @override
  final String description;
  @override
  final String documentSource;
  @override
  final int documentSourcePage;
  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;
  @override
  final GpsCoordinates? coordinatesForMap;

  @override
  String toString() {
    return 'WarEventOriginal(id: $id, regimentId: $regimentId, eventKind: $eventKind, title: $title, description: $description, documentSource: $documentSource, documentSourcePage: $documentSourcePage, startDate: $startDate, endDate: $endDate, coordinatesForMap: $coordinatesForMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WarEventOriginalImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.regimentId, regimentId) ||
                other.regimentId == regimentId) &&
            (identical(other.eventKind, eventKind) ||
                other.eventKind == eventKind) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.documentSource, documentSource) ||
                other.documentSource == documentSource) &&
            (identical(other.documentSourcePage, documentSourcePage) ||
                other.documentSourcePage == documentSourcePage) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.coordinatesForMap, coordinatesForMap) ||
                other.coordinatesForMap == coordinatesForMap));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    regimentId,
    eventKind,
    title,
    description,
    documentSource,
    documentSourcePage,
    startDate,
    endDate,
    coordinatesForMap,
  );

  /// Create a copy of WarEventOriginal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WarEventOriginalImplCopyWith<_$WarEventOriginalImpl> get copyWith =>
      __$$WarEventOriginalImplCopyWithImpl<_$WarEventOriginalImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WarEventOriginalImplToJson(this);
  }
}

abstract class _WarEventOriginal implements WarEventOriginal {
  factory _WarEventOriginal({
    final String? id,
    required final String regimentId,
    required final EventKind eventKind,
    required final String title,
    required final String description,
    required final String documentSource,
    required final int documentSourcePage,
    final DateTime? startDate,
    final DateTime? endDate,
    final GpsCoordinates? coordinatesForMap,
  }) = _$WarEventOriginalImpl;

  factory _WarEventOriginal.fromJson(Map<String, dynamic> json) =
      _$WarEventOriginalImpl.fromJson;

  @override
  String? get id;
  @override
  String get regimentId;
  @override
  EventKind get eventKind;
  @override
  String get title;
  @override
  String get description;
  @override
  String get documentSource;
  @override
  int get documentSourcePage;
  @override
  DateTime? get startDate;
  @override
  DateTime? get endDate;
  @override
  GpsCoordinates? get coordinatesForMap;

  /// Create a copy of WarEventOriginal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WarEventOriginalImplCopyWith<_$WarEventOriginalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
