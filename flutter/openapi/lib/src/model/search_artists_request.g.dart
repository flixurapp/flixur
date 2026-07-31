// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_artists_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SearchArtistsRequest extends SearchArtistsRequest {
  @override
  final String? dollarSchema;
  @override
  final int? limit;
  @override
  final String? plugin;
  @override
  final String query;

  factory _$SearchArtistsRequest(
          [void Function(SearchArtistsRequestBuilder)? updates]) =>
      (SearchArtistsRequestBuilder()..update(updates))._build();

  _$SearchArtistsRequest._(
      {this.dollarSchema, this.limit, this.plugin, required this.query})
      : super._();
  @override
  SearchArtistsRequest rebuild(
          void Function(SearchArtistsRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SearchArtistsRequestBuilder toBuilder() =>
      SearchArtistsRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SearchArtistsRequest &&
        dollarSchema == other.dollarSchema &&
        limit == other.limit &&
        plugin == other.plugin &&
        query == other.query;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, dollarSchema.hashCode);
    _$hash = $jc(_$hash, limit.hashCode);
    _$hash = $jc(_$hash, plugin.hashCode);
    _$hash = $jc(_$hash, query.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SearchArtistsRequest')
          ..add('dollarSchema', dollarSchema)
          ..add('limit', limit)
          ..add('plugin', plugin)
          ..add('query', query))
        .toString();
  }
}

class SearchArtistsRequestBuilder
    implements Builder<SearchArtistsRequest, SearchArtistsRequestBuilder> {
  _$SearchArtistsRequest? _$v;

  String? _dollarSchema;
  String? get dollarSchema => _$this._dollarSchema;
  set dollarSchema(String? dollarSchema) => _$this._dollarSchema = dollarSchema;

  int? _limit;
  int? get limit => _$this._limit;
  set limit(int? limit) => _$this._limit = limit;

  String? _plugin;
  String? get plugin => _$this._plugin;
  set plugin(String? plugin) => _$this._plugin = plugin;

  String? _query;
  String? get query => _$this._query;
  set query(String? query) => _$this._query = query;

  SearchArtistsRequestBuilder() {
    SearchArtistsRequest._defaults(this);
  }

  SearchArtistsRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _dollarSchema = $v.dollarSchema;
      _limit = $v.limit;
      _plugin = $v.plugin;
      _query = $v.query;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SearchArtistsRequest other) {
    _$v = other as _$SearchArtistsRequest;
  }

  @override
  void update(void Function(SearchArtistsRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SearchArtistsRequest build() => _build();

  _$SearchArtistsRequest _build() {
    final _$result = _$v ??
        _$SearchArtistsRequest._(
          dollarSchema: dollarSchema,
          limit: limit,
          plugin: plugin,
          query: BuiltValueNullFieldError.checkNotNull(
              query, r'SearchArtistsRequest', 'query'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
