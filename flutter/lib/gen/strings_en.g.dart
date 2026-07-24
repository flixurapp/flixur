///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final Translations$routes$en routes = Translations$routes$en._(_root);
}

// Path: routes
class Translations$routes$en {
	Translations$routes$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$routes$setup$en setup = Translations$routes$setup$en._(_root);
}

// Path: routes.setup
class Translations$routes$setup$en {
	Translations$routes$setup$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$routes$setup$server_url$en server_url = Translations$routes$setup$server_url$en._(_root);
}

// Path: routes.setup.server_url
class Translations$routes$setup$server_url$en {
	Translations$routes$setup$server_url$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Connect'
	String get connect => 'Connect';

	/// en: 'Failed to connect to server.'
	String get server_ping_error => 'Failed to connect to server.';

	/// en: 'Server URL'
	String get url => 'Server URL';

	/// en: 'Server URL is not valid!'
	String get url_error => 'Server URL is not valid!';

	/// en: 'Welcome!'
	String get welcome => 'Welcome!';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'routes.setup.server_url.connect' => 'Connect',
			'routes.setup.server_url.server_ping_error' => 'Failed to connect to server.',
			'routes.setup.server_url.url' => 'Server URL',
			'routes.setup.server_url.url_error' => 'Server URL is not valid!',
			'routes.setup.server_url.welcome' => 'Welcome!',
			_ => null,
		};
	}
}
