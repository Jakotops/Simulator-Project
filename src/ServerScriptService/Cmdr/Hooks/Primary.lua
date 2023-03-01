return function (registry)
	registry:RegisterHook("BeforeRun", function(context)
		if context.Group == "Admin" and context.Executor.UserId ~= 205045779 then
			return "You don't have permission to use this command!"
		end
	end)
end