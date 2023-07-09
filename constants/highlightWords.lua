local highlightWords = {
	{{"local ","if "," elseif ","else "," then "," end","while ","do ","repeat ","until ","for ","next",
	"in ","function ","not "," and "," or "," true"," false"," nil"," return"," break","goto "}, 0.1, 0.2, 1}, --blue
	{{"table.","string.","math.","pairs","ipairs","pcall","require ","tonumber","tostring"}, 0.15, 1, 1}, --cyan
	{{"szx","sanzhixiong"}, 1, 0.75, 0}, --golden
}

return highlightWords