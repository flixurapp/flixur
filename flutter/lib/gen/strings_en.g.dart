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

	/// en: 'API Request Failed'
	String get api_request_fail => 'API Request Failed';

	/// en: 'Flixur'
	String get app_name => 'Flixur';

	/// en: 'Cancel'
	String get btn_cancel => 'Cancel';

	/// en: 'OK'
	String get btn_ok => 'OK';

	/// en: 'OR'
	String get or_line => 'OR';

	/// en: 'Password'
	String get password => 'Password';

	late final Translations$routes$en routes = Translations$routes$en._(_root);
	late final Translations$storage$en storage = Translations$storage$en._(_root);

	/// en: 'Username'
	String get username => 'Username';
}

// Path: routes
class Translations$routes$en {
	Translations$routes$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$routes$startup$en startup = Translations$routes$startup$en._(_root);
}

// Path: storage
class Translations$storage$en {
	Translations$storage$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Failed to store secure value.'
	String get store_fail => 'Failed to store secure value.';

	/// en: 'Storage Failure'
	String get store_fail_title => 'Storage Failure';
}

// Path: routes.startup
class Translations$routes$startup$en {
	Translations$routes$startup$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$routes$startup$login$en login = Translations$routes$startup$login$en._(_root);
	late final Translations$routes$startup$server_url$en server_url = Translations$routes$startup$server_url$en._(_root);
	late final Translations$routes$startup$setup$en setup = Translations$routes$startup$setup$en._(_root);
}

// Path: routes.startup.login
class Translations$routes$startup$login$en {
	Translations$routes$startup$login$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Log In'
	String get app_bar => 'Log In';

	/// en: 'Log In'
	String get login => 'Log In';
}

// Path: routes.startup.server_url
class Translations$routes$startup$server_url$en {
	Translations$routes$startup$server_url$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Connect'
	String get connect => 'Connect';

	/// en: 'Server URL'
	String get url => 'Server URL';

	/// en: 'Server URL is not valid!'
	String get url_error => 'Server URL is not valid!';

	/// en: 'Welcome!'
	String get welcome => 'Welcome!';
}

// Path: routes.startup.setup
class Translations$routes$startup$setup$en {
	Translations$routes$startup$setup$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Server Setup'
	String get app_bar => 'Server Setup';

	/// en: 'To get started, enter the credentials for the initial admin user. You will be automatically logged in.'
	String get body => 'To get started, enter the credentials for the initial admin user. You will be automatically logged in.';

	/// en: 'Setup Code'
	String get code => 'Setup Code';

	/// en: 'You can get the setup code from the server console. You only need to do this once to set up the server.'
	String get code_info => 'You can get the setup code from the server console. You only need to do this once to set up the server.';

	/// en: 'Complete Setup'
	String get complete => 'Complete Setup';

	/// en: 'Setup Failed'
	String get failed => 'Setup Failed';

	Map<String, String> get failed_codes => {
		'INCORRECT_PASSWORD': 'Invalid setup code! Make sure you copied it from the server console.',
		'INVALID_INPUT.username': 'Username must contain printable ASCII characters only.',
		'TOO_SHORT.password': 'Password must be at least 12 characters.',
		'TOO_SHORT.username': 'Username must be at least 2 characters.',
	};

	/// en: 'Welcome to Flixur!'
	String get title => 'Welcome to ${_root.app_name}!';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'api_request_fail' => 'API Request Failed',
			'app_name' => 'Flixur',
			'btn_cancel' => 'Cancel',
			'btn_ok' => 'OK',
			'or_line' => 'OR',
			'password' => 'Password',
			'routes.startup.login.app_bar' => 'Log In',
			'routes.startup.login.login' => 'Log In',
			'routes.startup.server_url.connect' => 'Connect',
			'routes.startup.server_url.url' => 'Server URL',
			'routes.startup.server_url.url_error' => 'Server URL is not valid!',
			'routes.startup.server_url.welcome' => 'Welcome!',
			'routes.startup.setup.app_bar' => 'Server Setup',
			'routes.startup.setup.body' => 'To get started, enter the credentials for the initial admin user. You will be automatically logged in.',
			'routes.startup.setup.code' => 'Setup Code',
			'routes.startup.setup.code_info' => 'You can get the setup code from the server console. You only need to do this once to set up the server.',
			'routes.startup.setup.complete' => 'Complete Setup',
			'routes.startup.setup.failed' => 'Setup Failed',
			'routes.startup.setup.failed_codes.INCORRECT_PASSWORD' => 'Invalid setup code! Make sure you copied it from the server console.',
			'routes.startup.setup.failed_codes."INVALID_INPUT.username"' => 'Username must contain printable ASCII characters only.',
			'routes.startup.setup.failed_codes."TOO_SHORT.password"' => 'Password must be at least 12 characters.',
			'routes.startup.setup.failed_codes."TOO_SHORT.username"' => 'Username must be at least 2 characters.',
			'routes.startup.setup.title' => 'Welcome to ${_root.app_name}!',
			'storage.store_fail' => 'Failed to store secure value.',
			'storage.store_fail_title' => 'Storage Failure',
			'username' => 'Username',
			_ => null,
		};
	}
}
