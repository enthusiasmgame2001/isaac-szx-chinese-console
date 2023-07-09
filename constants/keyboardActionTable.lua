local keyboardActionTable = {
	[0] = {ButtonAction.ACTION_UP}, --W
	[1] = {ButtonAction.ACTION_LEFT}, --A
	[2] = {ButtonAction.ACTION_DOWN}, --S
	[3] = {ButtonAction.ACTION_RIGHT}, --D

	[4] = {ButtonAction.ACTION_SHOOTUP}, --UP
	[5] = {ButtonAction.ACTION_SHOOTLEFT}, --LEFT
	[7] = {ButtonAction.ACTION_SHOOTDOWN}, --DOWN
	[6] = {ButtonAction.ACTION_SHOOTRIGHT}, --RIGHT

	[8] = {ButtonAction.ACTION_DROP}, --CTRL
	[9] = {ButtonAction.ACTION_ITEM}, --SPACE
	[10] = {ButtonAction.ACTION_BOMB}, --BOMB
	[11] = {ButtonAction.ACTION_PILLCARD}, --PILL
}

return keyboardActionTable