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
			AddChoice("admin", "gavel"),
	)

	reg.Register(Bool("ui.nav.bottomLabels", false).Order(2))
	reg.Register(Bool("ui.nav.railDefaultExpanded", false).Order(2))

	//==
	//== Title Bar
	//==
	reg.RegisterGroup(Group("ui.titlebar").Order(1))

	reg.Register(Bool("ui.titlebar.startMaximized", true).Order(1))
	reg.Register(Bool("ui.titlebar.windowControls", true).Order(1))

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
