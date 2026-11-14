package settings

// Settings registry for client-scoped settings.
// These settings are owned by each user.
var ClientRegistry = newClientRegistry()

// Creates the registry for client settings.
func newClientRegistry() *Registry {
	reg := NewRegistry()

	//
	// UI
	//
	reg.RegisterGroup(Group("ui").Icon("layout").Order(1))

	//==
	//== Navigation
	//==
	reg.RegisterGroup(Group("ui.navigation").Order(1))

	reg.Register(
		StringList(
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

	reg.Register(Bool("ui.navigation.bottomLabels", false).Order(2))
	reg.Register(Bool("ui.navigation.railDefaultExpanded", false).Order(2))

	//====
	//==== Testing
	//====
	reg.RegisterGroup(Group("ui.navigation.testing").Order(1))

	reg.Register(Bool("ui.navigation.testing.bool", false).Order(1))
	reg.Register(Int("ui.navigation.testing.int", 0).Order(1))
	reg.Register(Int("ui.navigation.testing.int_min", 0).Min(0).Order(1))
	reg.Register(Int("ui.navigation.testing.int_max", 0).Max(100).Order(1))
	reg.Register(Int("ui.navigation.testing.int_combined", 0).Min(1000).Max(2500).Step(50).Order(1))
	reg.Register(Int("ui.navigation.testing.int_combined_rec", 0).Min(0).Max(300).Recommended(150, 200).Step(3).Order(1))
	reg.Register(Float("ui.navigation.testing.float", 0).Order(1))
	reg.Register(Float("ui.navigation.testing.float_min", 0).Min(0).Order(1))
	reg.Register(Float("ui.navigation.testing.float_max", 0).Max(1).Order(1))
	reg.Register(Float("ui.navigation.testing.float_01", 0).Min(0).Max(1).Order(1))
	reg.Register(Float("ui.navigation.testing.float_combined", 1).Min(1).Max(3).Step(0.5).Order(1))
	reg.Register(Float("ui.navigation.testing.float_combined_rec", 0).Min(0).Max(10).Recommended(2, 5).Step(0.25).Order(1))
	reg.Register(String("ui.navigation.testing.str", "").Order(1))
	reg.Register(String("ui.navigation.testing.str_secret", "").Secret(true).Order(1))
	reg.Register(String("ui.navigation.testing.str_max", "").MaxLength(16).Order(1))
	reg.Register(String("ui.navigation.testing.str_secret_max", "").Secret(true).MaxLength(128).Order(1))
	reg.Register(Enum("ui.navigation.testing.enum", "").AddChoice("x", "x").AddChoice("y").AddChoice("extra_super_long_choice", "phone-disconnect").Order(1))

	//==
	//== Window
	//==
	reg.RegisterGroup(Group("ui.window").Order(1))

	reg.Register(Bool("ui.window.startMaximized", true).Order(1))
	reg.Register(Bool("ui.window.useCustom", true).Order(1))

	//==
	//== Library
	//==
	reg.RegisterGroup(Group("ui.library").Order(1))

	reg.Register(
		Int("ui.library.cardsPerRow", 6).
			Order(1).
			Min(1).Max(99).
			Step(1).Recommended(3, 12),
	)

	return reg
}
