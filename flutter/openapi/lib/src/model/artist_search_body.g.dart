// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_search_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ArtistSearchBody extends ArtistSearchBody {
  @override
  final String? dollarSchema;
  @override
  final BuiltList<Artist> list;

  factory _$ArtistSearchBody(
          [void Function(ArtistSearchBodyBuilder)? updates]) =>
      (ArtistSearchBodyBuilder()..update(updates))._build();

  _$ArtistSearchBody._({this.dollarSchema, required this.list}) : super._();
  @override
  ArtistSearchBody rebuild(void Function(ArtistSearchBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ArtistSearchBodyBuilder toBuilder() =>
      ArtistSearchBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ArtistSearchBody &&
        dollarSchema == other.dollarSchema &&
        list == other.list;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, dollarSchema.hashCode);
    _$hash = $jc(_$hash, list.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ArtistSearchBody')
          ..add('dollarSchema', dollarSchema)
          ..add('list', list))
        .toString();
  }
}

class ArtistSearchBodyBuilder
    implements Builder<ArtistSearchBody, ArtistSearchBodyBuilder> {
  _$ArtistSearchBody? _$v;

  String? _dollarSchema;
  String? get dollarSchema => _$this._dollarSchema;
  set dollarSchema(String? dollarSchema) => _$this._dollarSchema = dollarSchema;

  ListBuilder<Artist>? _list;
  ListBuilder<Artist> get list => _$this._list ??= ListBuilder<Artist>();
  set list(ListBuilder<Artist>? list) => _$this._list = list;

  ArtistSearchBodyBuilder() {
    ArtistSearchBody._defaults(this);
  }

  ArtistSearchBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _dollarSchema = $v.dollarSchema;
      _list = $v.list.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ArtistSearchBody other) {
    _$v = other as _$ArtistSearchBody;
  }

  @override
  void update(void Function(ArtistSearchBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ArtistSearchBody build() => _build();

  _$ArtistSearchBody _build() {
    _$ArtistSearchBody _$result;
    try {
      _$result = _$v ??
          _$ArtistSearchBody._(
            dollarSchema: dollarSchema,
            list: list.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'list';
        list.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ArtistSearchBody', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
