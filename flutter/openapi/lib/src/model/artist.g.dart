// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Artist extends Artist {
  @override
  final String? description;
  @override
  final int? followers;
  @override
  final String? icon;
  @override
  final String id;
  @override
  final String? location;
  @override
  final String name;
  @override
  final String provider;

  factory _$Artist([void Function(ArtistBuilder)? updates]) =>
      (ArtistBuilder()..update(updates))._build();

  _$Artist._(
      {this.description,
      this.followers,
      this.icon,
      required this.id,
      this.location,
      required this.name,
      required this.provider})
      : super._();
  @override
  Artist rebuild(void Function(ArtistBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ArtistBuilder toBuilder() => ArtistBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Artist &&
        description == other.description &&
        followers == other.followers &&
        icon == other.icon &&
        id == other.id &&
        location == other.location &&
        name == other.name &&
        provider == other.provider;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, followers.hashCode);
    _$hash = $jc(_$hash, icon.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, provider.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Artist')
          ..add('description', description)
          ..add('followers', followers)
          ..add('icon', icon)
          ..add('id', id)
          ..add('location', location)
          ..add('name', name)
          ..add('provider', provider))
        .toString();
  }
}

class ArtistBuilder implements Builder<Artist, ArtistBuilder> {
  _$Artist? _$v;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  int? _followers;
  int? get followers => _$this._followers;
  set followers(int? followers) => _$this._followers = followers;

  String? _icon;
  String? get icon => _$this._icon;
  set icon(String? icon) => _$this._icon = icon;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _location;
  String? get location => _$this._location;
  set location(String? location) => _$this._location = location;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _provider;
  String? get provider => _$this._provider;
  set provider(String? provider) => _$this._provider = provider;

  ArtistBuilder() {
    Artist._defaults(this);
  }

  ArtistBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _description = $v.description;
      _followers = $v.followers;
      _icon = $v.icon;
      _id = $v.id;
      _location = $v.location;
      _name = $v.name;
      _provider = $v.provider;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Artist other) {
    _$v = other as _$Artist;
  }

  @override
  void update(void Function(ArtistBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Artist build() => _build();

  _$Artist _build() {
    final _$result = _$v ??
        _$Artist._(
          description: description,
          followers: followers,
          icon: icon,
          id: BuiltValueNullFieldError.checkNotNull(id, r'Artist', 'id'),
          location: location,
          name: BuiltValueNullFieldError.checkNotNull(name, r'Artist', 'name'),
          provider: BuiltValueNullFieldError.checkNotNull(
              provider, r'Artist', 'provider'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
