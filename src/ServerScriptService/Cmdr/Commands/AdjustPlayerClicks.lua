return {
	Name = "adjustPlayerClicks";
	Aliases = {"aPC"};
	Description = "Adjust Player's Clicks";
	Group = "Admin";
	Args = {
		{
			Type = "player";
			Name = "Player";
			Description = "The Player";
		},
		{
			Type = "number";
			Name = "Amount of Clicks";
			Description = "The amount of Clicks to add or subtract from the player";
		},
	}
}