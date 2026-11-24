package settings

import pb "forge.xela.codes/xela/flixur/pluginkit/proto"

// Creates a choice with an optional iconify icon name.
func newChoice(value string, icon ...string) *pb.SettingsChoice {
	if len(icon) > 1 {
		panic("at most one icon per choice")
	}
	choice := &pb.SettingsChoice{Value: value}
	if len(icon) == 1 {
		choice.Icon = &icon[0]
	}
	return choice
}

// Creates a choice with the description flag set to true among other details.
// See [newChoice]
func newChoiceWithDescription(value string, icon ...string) *pb.SettingsChoice {
	choice := newChoice(value, icon...)
	choice.HasDescription = new(true)
	return choice
}

// Returns values of a choice list.
func choiceValues(choices []*pb.SettingsChoice) []string {
	values := make([]string, len(choices))
	for i, choice := range choices {
		values[i] = choice.Value
	}
	return values
}
