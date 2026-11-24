package settings

import s "forge.xela.codes/xela/flixur/pluginkit/settings"

// Settings registry for client-scoped settings.
// These settings are owned by each user.
var ClientRegistry = newClientRegistry()

// Creates the registry for client settings.
func newClientRegistry() *s.Registry {
	reg := s.NewRegistry()

	//
	// UI
	//
	reg.RegisterGroup(s.Group("ui").Icon("layout").Order(1))
	reg.Register(s.Float("ui.transparency", 0.5).Order(1).
		Min(0).Max(1).
		Recommended(0.3, 1).Step(0.05))

	//==
	//== Navigation
	//==
	reg.RegisterGroup(s.Group("ui.navigation").Order(1))

	reg.Register(
		s.StringList(
			"ui.navigation.shownSections",
			[]string{"home", "library", "search", "activity", "explore"},
		).Order(1).
			AddChoice("home", "house").
			AddChoice("library", "folders").
			AddChoice("search", "magnifying-glass").
			AddChoice("activity", "heartbeat").
			AddChoice("explore", "binoculars").
			AddChoice("downloads", "download-simple").
			AddChoice("admin", "gavel").
			AddChoice("settings", "gear"),
	)

	reg.Register(s.Bool("ui.navigation.bottomLabels", false).Order(2))
	reg.Register(s.Bool("ui.navigation.railDefaultExpanded", false).Order(2))

	//====
	//==== Testing
	//====
	reg.RegisterGroup(s.Group("ui.navigation.testing").Order(1))

	reg.Register(s.Bool("ui.navigation.testing.bool", false).Order(1))
	reg.Register(s.Int("ui.navigation.testing.int", 0).Order(1))
	reg.Register(s.Int("ui.navigation.testing.int_min", 0).Min(0).Order(1))
	reg.Register(s.Int("ui.navigation.testing.int_max", 0).Max(100).Order(1))
	reg.Register(s.Int("ui.navigation.testing.int_combined", 0).Min(1000).Max(2500).Step(50).Order(1))
	reg.Register(s.Int("ui.navigation.testing.int_combined_rec", 0).Min(0).Max(300).Recommended(150, 200).Step(3).Order(1))
	reg.Register(s.Float("ui.navigation.testing.float", 0).Order(1))
	reg.Register(s.Float("ui.navigation.testing.float_min", 0).Min(0).Order(1))
	reg.Register(s.Float("ui.navigation.testing.float_max", 0).Max(1).Order(1))
	reg.Register(s.Float("ui.navigation.testing.float_01", 0).Min(0).Max(1).Order(1))
	reg.Register(s.Float("ui.navigation.testing.float_combined", 1).Min(1).Max(3).Step(0.5).Order(1))
	reg.Register(s.Float("ui.navigation.testing.float_combined_rec", 0).Min(0).Max(10).Recommended(2, 5).Step(0.25).Order(1))
	reg.Register(s.String("ui.navigation.testing.str", "").Order(1))
	reg.Register(s.String("ui.navigation.testing.str_secret", "").Secret(true).Order(1))
	reg.Register(s.String("ui.navigation.testing.str_max", "").MaxLength(16).Order(1))
	reg.Register(s.String("ui.navigation.testing.str_secret_max", "").Secret(true).MaxLength(128).Order(1))
	reg.Register(s.Enum("ui.navigation.testing.enum", "").AddChoice("x", "x").AddChoice("y").AddChoice("extra_super_long_choice", "phone-disconnect").Order(1))
	reg.Register(s.StringList("ui.navigation.testing.stringlist", []string{}).AddChoice("x", "x").AddChoice("y").AddChoice("extra_super_long_choice", "phone-disconnect").Order(1))
	reg.Register(s.StringList("ui.navigation.testing.stringlist_nochoice", []string{}).MaxItems(4).Order(1))
	reg.Register(s.StringList("ui.navigation.testing.stringlist_lim", []string{}).AddChoice("x", "x").AddChoiceWithDescription("y").AddChoice("extra_super_long_choice", "phone-disconnect").MaxItems(2).Order(1))
	reg.Register(s.StringList("ui.navigation.testing.stringlist_mul", []string{}).AddChoice("x", "x").AddChoice("y").AddChoice("extra_super_long_choice", "phone-disconnect").AllowDuplicates(true).Order(1))

	//==
	//== Window
	//==
	reg.RegisterGroup(s.Group("ui.window").Order(1))

	reg.Register(s.Bool("ui.window.startMaximized", true).Order(1))
	reg.Register(s.Bool("ui.window.useCustom", true).Order(1))

	//==
	//== Library
	//==
	reg.RegisterGroup(s.Group("ui.library").Order(1))

	reg.Register(
		s.Int("ui.library.cardsPerRow", 6).
			Order(1).
			Min(1).Max(99).
			Step(1).Recommended(3, 12),
	)

	//==
	//== Background
	//==
	reg.RegisterGroup(s.Group("ui.background").Order(1))

	reg.Register(
		s.Enum("ui.background.algorithm", "d").Order(1).
			AddChoiceWithDescription("a").
			AddChoiceWithDescription("b").
			AddChoiceWithDescription("c").
			AddChoiceWithDescription("d"),
	)
	reg.Register(s.Float("ui.background.brightness", 0.24).Order(1).
		Min(0).Max(1).
		Step(0.01).Recommended(0.1, 0.5))

	return reg
}
