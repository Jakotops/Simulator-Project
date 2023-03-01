return {
	Name = "debugRebirths";
	Aliases = {"dR"};
	Description = "Debug Rebirths.";
	Group = "Admin";
	Args = {
		{
			Type = "number";
			Name = "Amount of Rebirths";
			Description = "Amount of Rebirths";
			Optional = true;
		},
	}
}