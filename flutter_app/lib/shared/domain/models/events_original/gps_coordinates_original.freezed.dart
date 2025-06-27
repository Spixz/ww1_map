// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gps_coordinates_original.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GpsCoordinatesOriginal _$GpsCoordinatesOriginalFromJson(
  Map<String, dynamic> json,
) {
  return _GpsCoordinatesOriginal.fromJson(json);
}

/// @nodoc
mixin _$GpsCoordinatesOriginal {
  double get longitude => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;

  /// Serializes this GpsCoordinatesOriginal to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GpsCoordinatesOriginal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GpsCoordinatesOriginalCopyWith<GpsCoordinatesOriginal> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GpsCoordinatesOriginalCopyWith<$Res> {
  factory $GpsCoordinatesOriginalCopyWith(
    GpsCoordinatesOriginal value,
    $Res Function(GpsCoordinatesOriginal) then,
  ) = _$GpsCoordinatesOriginalCopyWithImpl<$Res, GpsCoordinatesOriginal>;
  @useResult
  $Res call({double longitude, double latitude});
}

/// @nodoc
class _$GpsCoordinatesOriginalCopyWithImpl<
  $Res,
  $Val extends GpsCoordinatesOriginal
>
    implements $GpsCoordinatesOriginalCopyWith<$Res> {
  _$GpsCoordinatesOriginalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GpsCoordinatesOriginal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? longitude = null, Object? latitude = null}) {
    return _then(
      _value.copyWith(
            longitude:
                null == longitude
                    ? _value.longitude
                    : longitude // ignore: cast_nullable_to_non_nullable
                        as double,
            latitude:
                null == latitude
                    ? _value.latitude
                    : latitude // ignore: cast_nullable_to_non_nullable
                        as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GpsCoordinatesOriginalImplCopyWith<$Res>
    implements $GpsCoordinatesOriginalCopyWith<$Res> {
  factory _$$GpsCoordinatesOriginalImplCopyWith(
    _$GpsCoordinatesOriginalImpl value,
    $Res Function(_$GpsCoordinatesOriginalImpl) then,
  ) = __$$GpsCoordinatesOriginalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double longitude, double latitude});
}

/// @nodoc
class __$$GpsCoordinatesOriginalImplCopyWithImpl<$Res>
    extends
        _$GpsCoordinatesOriginalCopyWithImpl<$Res, _$GpsCoordinatesOriginalImpl>
    implements _$$GpsCoordinatesOriginalImplCopyWith<$Res> {
  __$$GpsCoordinatesOriginalImplCopyWithImpl(
    _$GpsCoordinatesOriginalImpl _value,
    $Res Function(_$GpsCoordinatesOriginalImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GpsCoordinatesOriginal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? longitude = null, Object? latitude = null}) {
    return _then(
      _$GpsCoordinatesOriginalImpl(
        longitude:
            null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                    as double,
        latitude:
            null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                    as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GpsCoordinatesOriginalImpl extends _GpsCoordinatesOriginal {
  _$GpsCoordinatesOriginalImpl({
    required this.longitude,
    required this.latitude,
  }) : super._();

  factory _$GpsCoordinatesOriginalImpl.fromJson(Map<String, dynamic> json) =>
      _$$GpsCoordinatesOriginalImplFromJson(json);

  @override
  final double longitude;
  @override
  final double latitude;

  @override
  String toString() {
    return 'GpsCoordinatesOriginal(longitude: $longitude, latitude: $latitude)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GpsCoordinatesOriginalImpl &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, longitude, latitude);

  /// Create a copy of GpsCoordinatesOriginal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GpsCoordinatesOriginalImplCopyWith<_$GpsCoordinatesOriginalImpl>
  get copyWith =>
      __$$GpsCoordinatesOriginalImplCopyWithImpl<_$GpsCoordinatesOriginalImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GpsCoordinatesOriginalImplToJson(this);
  }
}

abstract class _GpsCoordinatesOriginal extends GpsCoordinatesOriginal {
  factory _GpsCoordinatesOriginal({
    required final double longitude,
    required final double latitude,
  }) = _$GpsCoordinatesOriginalImpl;
  _GpsCoordinatesOriginal._() : super._();

  factory _GpsCoordinatesOriginal.fromJson(Map<String, dynamic> json) =
      _$GpsCoordinatesOriginalImpl.fromJson;

  @override
  double get longitude;
  @override
  double get latitude;

  /// Create a copy of GpsCoordinatesOriginal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GpsCoordinatesOriginalImplCopyWith<_$GpsCoordinatesOriginalImpl>
  get copyWith => throw _privateConstructorUsedError;
}
