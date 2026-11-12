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
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	dynamic operator[](String key) => _meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations

	/// en: 'API Request Failed'
	String get api_request_fail => 'API Request Failed';

	/// en: 'Flixur'
	String get app_name => 'Flixur';

	/// en: 'Add'
	String get btn_add => 'Add';

	/// en: 'Cancel'
	String get btn_cancel => 'Cancel';

	/// en: 'Create'
	String get btn_create => 'Create';

	/// en: 'Delete'
	String get btn_delete => 'Delete';

	/// en: 'New'
	String get btn_new => 'New';

	/// en: 'OK'
	String get btn_ok => 'OK';

	/// en: 'Remove'
	String get btn_remove => 'Remove';

	/// en: 'Rename'
	String get btn_rename => 'Rename';

	/// en: 'Save'
	String get btn_save => 'Save';

	late final Translations$navigation$en navigation = Translations$navigation$en._(_root);

	/// en: 'OR'
	String get or_line => 'OR';

	/// en: 'Password'
	String get password => 'Password';

	late final Translations$routes$en routes = Translations$routes$en._(_root);
	Map<String, String> get setting_descriptions => {
		'ui.library.cardsPerRow': 'Maximum number of cards to show per row in library grids.',
		'ui.navigation.bottomLabels': 'Show text labels under the icons in the bottom navbar.',
		'ui.navigation.railDefaultExpanded': 'Whether the left navigation rail starts off expanded.',
		'ui.navigation.shownSections': 'Choose which sections are shown in the main navigation.',
		'ui.window.startMaximized': 'Open ${_root.app_name} maximized on launch.',
		'ui.window.useCustom': 'Whether to use a custom titlebar.',
	};
	Map<String, String> get setting_group_names => {
		'ui': 'User Interface',
		'ui.library': 'Library',
		'ui.navigation': 'Navigation',
		'ui.window': 'Window',
	};
	Map<String, String> get setting_names => {
		'ui.library.cardsPerRow': 'Cards Per Row',
		'ui.navigation.bottomLabels': 'Bottom Nav Labels',
		'ui.navigation.railDefaultExpanded': 'Expand Nav Rail',
		'ui.navigation.shownSections': 'Navigation Sections',
		'ui.window.startMaximized': 'Start Maximized',
		'ui.window.useCustom': 'Custom Titlebar',
	};
	late final Translations$titlebar$en titlebar = Translations$titlebar$en._(_root);

	/// en: 'Username'
	String get username => 'Username';
}

// Path: navigation
class Translations$navigation$en {
	Translations$navigation$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	Map<String, String> get section_titles => {
		'activity': 'Activity',
		'admin': 'Admin',
		'downloads': 'Downloads',
		'explore': 'Explore',
		'home': 'Home',
		'library': 'Library',
		'search': 'Search',
		'settings': 'Settings',
	};
}

// Path: routes
class Translations$routes$en {
	Translations$routes$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$routes$settings$en settings = Translations$routes$settings$en._(_root);
	late final Translations$routes$startup$en startup = Translations$routes$startup$en._(_root);
}

// Path: titlebar
class Translations$titlebar$en {
	Translations$titlebar$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Close'
	String get close => 'Close';

	/// en: 'Maximize'
	String get maximize => 'Maximize';

	/// en: 'Minimize'
	String get minimize => 'Minimize';

	/// en: 'Collapse Navigation'
	String get rail_collapse => 'Collapse Navigation';

	/// en: 'Expand Navigation'
	String get rail_expand => 'Expand Navigation';
}

// Path: routes.settings
class Translations$routes$settings$en {
	Translations$routes$settings$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'New Profile'
	String get new_profile => 'New Profile';

	/// en: 'Search settings...'
	String get search_hint => 'Search settings...';
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

	/// en: 'Login Failed'
	String get failed => 'Login Failed';

	Map<String, String> get failed_codes => {
		'INCORRECT_PASSWORD': 'Incorrect password.',
		'INCORRECT_USERNAME': 'Username not found.',
	};

	/// en: 'Log In'
	String get login => 'Log In';

	/// en: 'Log In'
	String get title => 'Log In';
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
			'btn_add' => 'Add',
			'btn_cancel' => 'Cancel',
			'btn_create' => 'Create',
			'btn_delete' => 'Delete',
			'btn_new' => 'New',
			'btn_ok' => 'OK',
			'btn_remove' => 'Remove',
			'btn_rename' => 'Rename',
			'btn_save' => 'Save',
			'navigation.section_titles.activity' => 'Activity',
			'navigation.section_titles.admin' => 'Admin',
			'navigation.section_titles.downloads' => 'Downloads',
			'navigation.section_titles.explore' => 'Explore',
			'navigation.section_titles.home' => 'Home',
			'navigation.section_titles.library' => 'Library',
			'navigation.section_titles.search' => 'Search',
			'navigation.section_titles.settings' => 'Settings',
			'or_line' => 'OR',
			'password' => 'Password',
			'routes.settings.new_profile' => 'New Profile',
			'routes.settings.search_hint' => 'Search settings...',
			'routes.startup.login.failed' => 'Login Failed',
			'routes.startup.login.failed_codes.INCORRECT_PASSWORD' => 'Incorrect password.',
			'routes.startup.login.failed_codes.INCORRECT_USERNAME' => 'Username not found.',
			'routes.startup.login.login' => 'Log In',
			'routes.startup.login.title' => 'Log In',
			'routes.startup.server_url.connect' => 'Connect',
			'routes.startup.server_url.url' => 'Server URL',
			'routes.startup.server_url.url_error' => 'Server URL is not valid!',
			'routes.startup.server_url.welcome' => 'Welcome!',
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
			'setting_descriptions."ui.library.cardsPerRow"' => 'Maximum number of cards to show per row in library grids.',
			'setting_descriptions."ui.navigation.bottomLabels"' => 'Show text labels under the icons in the bottom navbar.',
			'setting_descriptions."ui.navigation.railDefaultExpanded"' => 'Whether the left navigation rail starts off expanded.',
			'setting_descriptions."ui.navigation.shownSections"' => 'Choose which sections are shown in the main navigation.',
			'setting_descriptions."ui.window.startMaximized"' => 'Open ${_root.app_name} maximized on launch.',
			'setting_descriptions."ui.window.useCustom"' => 'Whether to use a custom titlebar.',
			'setting_group_names.ui' => 'User Interface',
			'setting_group_names."ui.library"' => 'Library',
			'setting_group_names."ui.navigation"' => 'Navigation',
			'setting_group_names."ui.window"' => 'Window',
			'setting_names."ui.library.cardsPerRow"' => 'Cards Per Row',
			'setting_names."ui.navigation.bottomLabels"' => 'Bottom Nav Labels',
			'setting_names."ui.navigation.railDefaultExpanded"' => 'Expand Nav Rail',
			'setting_names."ui.navigation.shownSections"' => 'Navigation Sections',
			'setting_names."ui.window.startMaximized"' => 'Start Maximized',
			'setting_names."ui.window.useCustom"' => 'Custom Titlebar',
			'titlebar.close' => 'Close',
			'titlebar.maximize' => 'Maximize',
			'titlebar.minimize' => 'Minimize',
			'titlebar.rail_collapse' => 'Collapse Navigation',
			'titlebar.rail_expand' => 'Expand Navigation',
			'username' => 'Username',
			_ => null,
		};
	}
}
