local json = require("json")

--rewrite print() function
local toBeAddedPrintStrTable = {}
local oldPrint = print
local function newPrint(...)
	local params = {...}
	local tempStr = ""
	for i = 1, select("#", ...) do
		tempStr = tempStr .. tostring(params[i]) .. " "
	end
	table.insert(toBeAddedPrintStrTable, tempStr)
	return oldPrint(...)
end
rawset(_G, "print", newPrint)

--global variables for szx's other mods(line 5114: global api for all mods)
sanzhixiong = {}
sanzhixiong.consoleOn = false
sanzhixiong.isBlindMode = false
sanzhixiong.canFrameUpdateBlindState = false
sanzhixiong.debugTable = {
	[1] = {nil ,nil ,false},
	[2] = {nil ,nil ,false},
	[3] = {61, 3, false},
	[4] = {5, 108, false},
	[5] = {nil ,nil ,false},
	[6] = {nil ,nil ,false},
	[7] = {nil ,nil ,false},
	[8] = {8, 23, false},
	[9] = {5, 144, false},
	[10] = {0, 0, false},
	[11] = {nil ,nil ,false},
	[12] = {nil ,nil ,false},
	[13] = {nil ,nil ,false},
	[14] = {nil ,nil ,false}
}

Options.DebugConsoleEnabled = false

local mod = RegisterMod("szx_chinese_console", 1)
local game = Game()
local font = Font()

--for luamod command or in-game ReloadLua()
if Isaac.GetPlayer(0) ~= nil then
	if mod:HasData() then
		local jsonTable = json.decode(mod:LoadData())
		if jsonTable.officialConsoleOn ~= nil then
			Options.DebugConsoleEnabled = jsonTable.officialConsoleOn
		end
	end
end

local function cloneTable(originalTable)
	local clone = {}
	for key, value in pairs(originalTable) do
		if type(value) == "table" then
			clone[key] = cloneTable(value)
		else
			clone[key] = value
		end
	end
	return clone
end

local chineseCharacterTable = require('./constants/chineseCharacterTable')

local itemOrderMap = cloneTable(require('./constants/itemOrderMap'))
local collectibleOrTrinketTagsEnglishTable = cloneTable(require('./constants/collectibleOrTrinketTagsEnglishTable'))
local collectibleOrTrinketTagsChineseTable = cloneTable(require('./constants/collectibleOrTrinketTagsChineseTable'))
local collectibleOrTrinketNickNameTable = cloneTable(require('./constants/collectibleOrTrinketNickNameTable'))
local cardTable = cloneTable(require('./constants/cardTable'))
local pillTable = cloneTable(require('./constants/pillTable'))
local poopTable = cloneTable(require('./constants/poopTable'))

local spawnTableOrderMap = require('./constants/spawnTableOrderMap')
local spawnTable = require('./constants/spawnTable')
local spawnSubTypeTable = require('./constants/spawnSubTypeTable')
local spawnTableReWrite = require('./constants/spawnTableReWrite')
local slotTable = require('./constants/slotTable')

local stageTable = require('./constants/stageTable')
local greedModeStageTable = require('./constants/greedModeStageTable')
local stageTableOrderMap = require('./constants/stageTableOrderMap')

local originalKeyboard = require('./constants/originalKeyboard')
local keyboardCharTable = require('./constants/keyboardCharTable')
local keyboardActionTable = require('./constants/keyboardActionTable')

local basicCommandList = require('./constants/basicCommandList')
local basicCommandTable = require('./constants/basicCommandTable')

local instructionTextTable = cloneTable(require('./constants/instructionTextTable'))
local characterMap = cloneTable(require('./constants/characterMap'))
local consoleInstructionPageTbl = cloneTable(require('./constants/consoleInstructionPageTbl'))

--load font
local fontScaledTable = {1, 1}
local function loadFont()
	local _, err = pcall(require, "")
	local _, basePathStart = string.find(err, "no file '", 1)
	local _, modPathStart = string.find(err, "no file '", basePathStart)
	local modPathEnd, _ = string.find(err, ".lua", modPathStart)
	local path = string.sub(err, modPathStart + 1, modPathEnd - 1)
	path = string.gsub(path, "\\", "/")
	path = string.gsub(path, "//", "/")
	path = string.gsub(path, ":/", ":\\")
	font:Load(path .. "resources/font/eid9/eid9_9px.fnt")
end
loadFont()

--font variables
local consoleTitle = "三只熊中文控制台 V3.09"
local consoleInstructionPos = {72, 195, 15} --posX, posY, lineGap
local consoleInstructionPage = consoleInstructionPageTbl.HOME
local consoleInstructionColor = {0.4, 0.1, 0.9} --purple
local offsetDebug10 = {-10, -5}
local gameOverOffsetY = 0
local qualityTextOffset = -10
local itemQualityList = {}
local qualityTextColorList = {
	{0.6, 0.6, 0.6},
	{0.35, 0.7, 0.35},
	{0.15, 0.35, 0.7},
	{0.8, 0.2, 0.6},
	{0.8, 0.65, 0.15},
	{0.8, 0.1, 0.1},
	{0.15, 0.7, 0.7},
	{0.075, 0.35, 0.35}
}

--load sprite
local spriteConsoleBackground = Sprite()
spriteConsoleBackground:Load("gfx/console_background.anm2", true)
local spriteKeyboard = Sprite()
spriteKeyboard:Load("gfx/keyboard_overlay.anm2", true)
local questionMarkSprite = Sprite()
questionMarkSprite:Load("gfx/005.100_collectible.anm2", true)
questionMarkSprite:ReplaceSpritesheet(1, "gfx/items/collectibles/questionmark.png")
questionMarkSprite:LoadGraphics()
local itemPoolSprite = Sprite()
itemPoolSprite:Load("gfx/item_pools.anm2", true)
--option variables
local selectedOption = 1
--console variables
local consoleBanned = false
local chineseModeOn = false
local lastFrameGamePaused = false
local consoleIsOnWhileGamePaused = false
local canConsoleRestart = true
local switchModeFadedTimer = 0
local switchModeFadedStr = ""
local canBeInGameLuamod = nil
local isIsaacSocketForcedPaused = nil
local shouldDisplayFPS = nil
local isaacSocketCountTable = {
	["edenTokenNum"] = nil,
	["donationNum"] = nil,
	["greedDonationNum"] = nil,
	["gameSpeed"] = nil,
	["edensBlessing"] = nil
}
local renderTimer = 0
local inOptionMenuStateTbl = {
	NOT_IN = 0,
	IN = 1,
	ARROW_BANNED = 2,
	ARROW_BANNED_AND_DISPLAY_DEBUG = 3
}
local inOptionMenuState = inOptionMenuStateTbl.NOT_IN
local originalStateTbl = {
	keyboard = false,
	debug3 = true,
	debug8 = true,
	debug49 = true
}
--keyboardOverlay variables
local keyboardOverlayOn = false
local keyboardPos = Vector(351, 208)
local keyboardScale = 0.91
--string variables
local feedbackString = [[]]
local userCurString = [[]]
local userLastString = [[]]
local userStringIndex = nil
local userStringList = {}
local lastExecutedStrTable = {"", nil}
--display box variables
local displayBox = {}
local displayLanguage = true
local displayBoxInsertMode = {
	USER_STR = 1,
	CLEAR_BOX = 2,
	PRINT_STR = 3,
	REMOVE_PRINT = 4
}
local maxFadedLineNum = 10
local displayUpdateMode = displayBoxInsertMode.USER_STR
--display boundary variables
local minMaxCharNumInLine = 33
local widthLimitInLine = 320
--cursor variables
local cursorFrame = 0
local cursorIndex = 0
local cursorChar = "|"
local moveCursorFrame = 0
local notCountGraveAccent = 0
local pausedFrame = 0
local continueDisplayCursorForQuarterSecond = false
local needCheckRelease = false
--page scroll variables
local pageScrollFrame = 5
local pageOffsetY = 0
--mode variables
local isGreed = false
local updateBlindMode = false
local gameStartFrame = 1
local blindChallengeList = {6, 8, 13, 19, 23, 27, 30, 36, 38, 42}
local isTestMode = false
local functionMenu = {
    ["itemQuality"] = true,
    ["debugText"] = true,
    ["itemPool"] = true,
    ["itemPoolSetting"] = {
        ["blindCurse"] = false,
        ["chaos"] = false
    }
}
local seedList = {}
local componentOffsetTbl = {
	consoleX = 72,
	consoleY = 195,
	keyboardX = 351,
	keyboardY = 208,
	debug3X = 61,
	debug3Y = 3,
	debug8X = 8,
	debug8Y = 23,
	debug4X = 5,
	debug4Y = 108,
	debug9X = 5,
	debug9Y = 144
}
if mod:HasData() then
	local jsonTable = json.decode(mod:LoadData())
	if jsonTable.seedList ~= nil then
		for i = 1, #jsonTable.seedList do
			table.insert(seedList, jsonTable.seedList[i])
		end
	end
	local tempTbl = jsonTable.componentOffsetTbl
	if tempTbl ~= nil then
		componentOffsetTbl.consoleX = tempTbl.consoleX
		consoleInstructionPos[1] = componentOffsetTbl.consoleX
		componentOffsetTbl.consoleY = tempTbl.consoleY
		consoleInstructionPos[2] = componentOffsetTbl.consoleY
		componentOffsetTbl.keyboardX = tempTbl.keyboardX
		keyboardPos.X = componentOffsetTbl.keyboardX
		componentOffsetTbl.keyboardY = tempTbl.keyboardY
		keyboardPos.Y = componentOffsetTbl.keyboardY
		componentOffsetTbl.debug3X = tempTbl.debug3X
		sanzhixiong.debugTable[3][1] = componentOffsetTbl.debug3X
		componentOffsetTbl.debug3Y = tempTbl.debug3Y
		sanzhixiong.debugTable[3][2] = componentOffsetTbl.debug3Y
		componentOffsetTbl.debug8X = tempTbl.debug8X
		sanzhixiong.debugTable[8][1] = componentOffsetTbl.debug8X
		componentOffsetTbl.debug8Y = tempTbl.debug8Y
		sanzhixiong.debugTable[8][2] = componentOffsetTbl.debug8Y
		componentOffsetTbl.debug4X = tempTbl.debug4X
		sanzhixiong.debugTable[4][1] = componentOffsetTbl.debug4X
		componentOffsetTbl.debug4Y = tempTbl.debug4Y
		sanzhixiong.debugTable[4][2] = componentOffsetTbl.debug4Y
		componentOffsetTbl.debug9X = tempTbl.debug9X
		sanzhixiong.debugTable[9][1] = componentOffsetTbl.debug9X
		componentOffsetTbl.debug9Y = tempTbl.debug9Y
		sanzhixiong.debugTable[9][2] = componentOffsetTbl.debug9Y
	end
end
--logic action variables from render
local isConsoleReady = false
local letPlayerControl = false
local needEmergencyBack = false
local needSwitchTestMode = nil
local needSwallowTrinket = false
local toBeLoadedExecuteStrList = {}
local toBeBannedItemIDList = {}
local toBeBannedItemQualityList = {}
local needAnimate = {}
local needAddChineseNameList = {}
local canUpdateModItemChineseName = false
--chinese mode variables
local characterDisplayTable = ""
local curCharactersPage = 0
local charLengthStr = ""
local lastCharLengthStr = ""
local pinyinExcludeStr = ""
local lastPinyinExcludeStr = ""
local pinyinLength = 0
local lastPinyinLength = 0
local charLengthStrList = {}
local pinyinExcludeStrList = {}
--search variables
local searchResultTable = {}
local searchPage = 0
local searchInstructionOffsetY = 0
local lastSearchStrInPage = ""
local searchBoxOffsetX = {0, 75, 200}
local searchBoxWidthLimitInLine = {25, -50}
local lastSearchKeyWord = nil

local function saveData()
	local saveDataTable = {}
	saveDataTable.officialConsoleOn = Options.DebugConsoleEnabled
	saveDataTable.commandStrings = userStringList
	saveDataTable.characterLengthStrings = charLengthStrList
	saveDataTable.pinyinExcludeStrings = pinyinExcludeStrList
	saveDataTable.F4 = keyboardOverlayOn
	saveDataTable.F5 = isTestMode
	saveDataTable.F6 = functionMenu
	saveDataTable.seedList = seedList
	saveDataTable.componentOffsetTbl = componentOffsetTbl
	mod:SaveData(json.encode(saveDataTable))
end

local function stringInsert(str, pos, insertStr)
	if insertStr == nil then
        insertStr = pos
        pos = #str + 1
    end
    if pos == 1 then
        return insertStr .. str
    elseif pos == #str + 1 then
		return str .. insertStr
	else
        return string.sub(str, 1, pos - 1) .. insertStr .. string.sub(str, pos)
    end
end

local function stringRemove(str, pos)
    if pos == 1 then
        return string.sub(str, 2)
    elseif pos == #str then
        return string.sub(str, 1, pos - 1)
    else
        return string.sub(str, 1, pos - 1) .. string.sub(str, pos + 1)
    end
end

local function getTableLength(tbl)
	local length = 0
	for key, value in pairs(tbl) do
		length = length + 1
	end
	return length
end

local function updatePlayerControlState(letControl)
	local playerNum = game:GetNumPlayers()
	for i = 0, playerNum - 1 do
		local player = Isaac.GetPlayer(i)
		if not letControl then
			player.ControlsCooldown = 2
		end
	end
end

local function executeAnimation(n)
	local playerNum = game:GetNumPlayers()
	for i = 0, playerNum - 1 do
		local player = Isaac.GetPlayer(i)
		if n == 1 then
			player:AnimateHappy()
		elseif n == 2 then
			player:AnimateSad()
		end
	end
end

local function isAltChoice(entity)
	local sprite = entity:GetSprite()
	local animationName = sprite:GetAnimation()
	if animationName ~= "Idle" and animationName ~= "ShopIdle" then
		return false
	end
	questionMarkSprite:SetFrame(animationName, sprite:GetFrame())
	for i = -1, 1, 1 do
		for j = -40, 10, 3 do
			local qColor = questionMarkSprite:GetTexel(Vector(i, j), Vector(0, 0), 1, 1)
			local eColor = sprite:GetTexel(Vector(i, j), Vector(0, 0), 1, 1)
			if qColor.Red ~= eColor.Red or qColor.Green ~= eColor.Green or qColor.Blue ~= eColor.Blue then
				return false
			end
		end
	end
	return true
end

local function displaySwitchModeFadedStr(str)
	local alphaValue = 1
	if switchModeFadedTimer < 50 then
		alphaValue = 0.02 * switchModeFadedTimer
	end
	font:DrawStringScaledUTF8(str, 0.5 * (Isaac.GetScreenWidth() - font:GetStringWidthUTF8(str)), 0, 1, 1, KColor(1, 1, 1, alphaValue), 0, false) -- white
	switchModeFadedTimer = switchModeFadedTimer - 1
end

local function displayKeyboard()
	spriteKeyboard:Play("Keys")
	for key, value in pairs(keyboardActionTable) do
		local pressed = Input.IsActionPressed(value[1], 0)
		if pressed ~= value.last then
			spriteKeyboard:SetLayerFrame(key, pressed and 1 or 0)
		end
		value.last = pressed
	end
	spriteKeyboard:SetLayerFrame(12, 0)
	spriteKeyboard:Render(keyboardPos, Vector(0, 0), Vector(0, 0))
end

local function displayDebugText()
	if IsaacSocket ~= nil then
		local debugFlag = IsaacSocket.IsaacAPI.GetDebugFlag()
		for i = 1, 14 do
			if debugFlag & 2 ^ (i - 1) == 0 then
				sanzhixiong.debugTable[i][3] = false
			else
				sanzhixiong.debugTable[i][3] = true
			end
		end
	end
	if functionMenu.debugText then
		for key, value in pairs(sanzhixiong.debugTable) do
			if (value[3] == true or inOptionMenuState == inOptionMenuStateTbl.ARROW_BANNED_AND_DISPLAY_DEBUG) and value[1] ~= nil then
				if key == 10 then
					local room = game:GetRoom()
					local isMirrored = room:IsMirrorWorld()
					local screenWidth = Isaac.GetScreenWidth()
					local player = Isaac.GetPlayer(0)
					local playerPos = Isaac.WorldToScreen(player.Position)
					if isMirrored then
						value[1] = screenWidth - playerPos.X + offsetDebug10[1]
					else
						value[1] = playerPos.X + offsetDebug10[1]
					end
					value[2] = playerPos.Y + offsetDebug10[2]
				end
				font:DrawStringScaledUTF8("d#" .. key, value[1], value[2], 1, 1, KColor(1, 0.75, 0, 1), 0, false)
			end
		end
	end
end

local function nextPage()
	if Input.IsButtonTriggered(Keyboard.KEY_RIGHT_CONTROL, 0) then
		consoleInstructionPage = consoleInstructionPage + 1
	end
end

local function lastPage()
	if Input.IsButtonTriggered(Keyboard.KEY_LEFT_CONTROL, 0) then
		consoleInstructionPage = consoleInstructionPage - 1
	end
end

local function displayInstuctionTextAndBackGround(leftAltPressed, searchKeyWord)
	spriteConsoleBackground:Play("Keys")
	spriteConsoleBackground:SetLayerFrame(0, 0)
	spriteConsoleBackground:Render(Vector(0, 0), Vector(0, 0), Vector(0, 0))
	if consoleInstructionPage == consoleInstructionPageTbl.SEARCHING then
		local curSearchBoxOffsetX = searchBoxOffsetX[1]
		local curSearchBoxWidthLimitInLine = searchBoxWidthLimitInLine[1]
		if chineseModeOn then
			curSearchBoxOffsetX = searchBoxOffsetX[2]
			curSearchBoxWidthLimitInLine = searchBoxWidthLimitInLine[2]
		end
		if lastSearchStrInPage ~= userCurString then
			searchInstructionOffsetY = 0
		end
		if Input.IsButtonPressed(Keyboard.KEY_LEFT_CONTROL,0) then
			searchInstructionOffsetY = searchInstructionOffsetY + pageScrollFrame
			if searchInstructionOffsetY > 0 then
				searchInstructionOffsetY = 0
			end
		elseif Input.IsButtonPressed(Keyboard.KEY_RIGHT_CONTROL,0) then
			searchInstructionOffsetY = searchInstructionOffsetY - pageScrollFrame
		end
		if next(searchResultTable) == nil then
			local fontText = "No match found"
			if not displayLanguage then
				fontText = "无匹配结果"
			end
			font:DrawStringScaledUTF8(fontText, consoleInstructionPos[1] + curSearchBoxOffsetX, consoleInstructionPos[2] + consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("名称搜索[name] 标签搜索#[tag] 条件搜索$[key]:[value]", consoleInstructionPos[1] + 75, consoleInstructionPos[2] + 4 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(1, 0.75, 0, 1), 0, false)
		else
			local remainStr = ""
			local wordCountTable = {}
			local countNum = 1
			local executeMapList = {spawnTableOrderMap, stageTableOrderMap}
			local curExecuteMap = nil
			local isInExecuteTable = false
			if searchKeyWord == -5 then
				curExecuteMap = executeMapList[1]
				isInExecuteTable = true
			elseif searchKeyWord == -13 then
				curExecuteMap = executeMapList[2]
				isInExecuteTable = true
			end
			if isInExecuteTable then
				for _, code in ipairs(curExecuteMap) do
					local name = searchResultTable[code]
					if name ~= nil then					
						local nextResultStr = ""
						if leftAltPressed and countNum <= 9 then
							nextResultStr = "[#" .. countNum .. "]" .. name .. "   "
						else
							nextResultStr = "[" .. code .. "]" .. name .. "   "
						end
						table.insert(wordCountTable, #nextResultStr)
						remainStr = remainStr .. nextResultStr
						countNum = countNum + 1
					end
				end
			else
				for _, code in ipairs(itemOrderMap) do
					local name = searchResultTable[code]
					if name == nil then
						name = searchResultTable[code:upper()]
					end
					if name ~= nil then
						local nextResultStr = ""
						if leftAltPressed and countNum <= 9 then
							nextResultStr = "[#" .. countNum .. "]" .. name .. "   "
						else
							nextResultStr = "[" .. code .. "]" .. name .. "   "
						end
						table.insert(wordCountTable, #nextResultStr)
						remainStr = remainStr .. nextResultStr
						countNum = countNum + 1
					end
				end
			end
			local instructionBox = {}
			local insertEnd = false
			while not insertEnd do
				if #wordCountTable == 1 then
					table.insert(instructionBox, remainStr)
					break
				end
				local curLineWidth = 0
				local nextLineStr = ""
				local nextWordLength = 0
				while curLineWidth < widthLimitInLine + curSearchBoxWidthLimitInLine do
					if curLineWidth > 0 then
						if #wordCountTable == 1 then
							insertEnd = true
							break
						end
						table.remove(wordCountTable, 1)
						remainStr = remainStr:sub(nextWordLength + 1)
					end
					nextWordLength = tonumber(wordCountTable[1])
					local addStr = remainStr:sub(1, nextWordLength)
					local tempStr = nextLineStr
					nextLineStr = nextLineStr .. addStr
					curLineWidth = curLineWidth + font:GetStringWidthUTF8(addStr)
					if curLineWidth >= widthLimitInLine + curSearchBoxWidthLimitInLine then
						nextLineStr = tempStr
					end
				end
				table.insert(instructionBox, nextLineStr)
			end
			if #instructionBox >= 4 then
				if searchInstructionOffsetY <= (4 - #instructionBox) * consoleInstructionPos[3] then
					searchInstructionOffsetY = (4 - #instructionBox) * consoleInstructionPos[3]
				end
			else
				if searchInstructionOffsetY <= 0 then
					searchInstructionOffsetY = 0
				end
			end
			-- display instruction box
			local displayPosY = consoleInstructionPos[2]
			for i = 1, #instructionBox do
				local displayStr = instructionBox[i]
				displayPosY = displayPosY + consoleInstructionPos[3]
				if displayPosY + searchInstructionOffsetY >= consoleInstructionPos[2] + consoleInstructionPos[3] then
					font:DrawStringScaledUTF8(displayStr, consoleInstructionPos[1] + curSearchBoxOffsetX, displayPosY + searchInstructionOffsetY, fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
				end
			end
			font:DrawStringScaledUTF8("长按[LAlt]+[Num1-9]快捷生效", consoleInstructionPos[1] + searchBoxOffsetX[3], consoleInstructionPos[2], fontScaledTable[1], fontScaledTable[2], KColor(1, 0.75, 0, 1), 0, false)
			if displayLanguage then
				font:DrawStringScaledUTF8("[RAlt]切换中文显示", consoleInstructionPos[1] + searchBoxOffsetX[3] + 20, consoleInstructionPos[2] - consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(1, 0.75, 0, 1), 0, false)
			else
				font:DrawStringScaledUTF8("[RAlt]切换英文显示", consoleInstructionPos[1] + searchBoxOffsetX[3] + 20, consoleInstructionPos[2] - consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(1, 0.75, 0, 1), 0, false)
			end
		end
		lastSearchStrInPage = userCurString
	end
	if chineseModeOn then
		if pinyinLength ~= lastPinyinLength then
			curCharactersPage = 0
		end
		font:DrawStringScaledUTF8("[Tab]切换英文输入", consoleInstructionPos[1] - 15, consoleInstructionPos[2] + 4 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(1, 0.75, 0, 1), 0, false)
		if #characterDisplayTable == 0 then
			font:DrawStringScaledUTF8("无匹配汉字", consoleInstructionPos[1], consoleInstructionPos[2] + consoleInstructionPos[3] + gameOverOffsetY, fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			return
		end
		local curDisPlayTable = ""
		local curIndex = 1 + curCharactersPage * 27
		local diff = #characterDisplayTable - curIndex
		if diff < 27 then
			curDisPlayTable = characterDisplayTable:sub(curIndex)
		else
			curDisPlayTable = characterDisplayTable:sub(curIndex, curIndex + 26)
		end
		local curDisPlayTableLength = #curDisPlayTable
		local characterList = {}
		for i = 1, curDisPlayTableLength / 3 do
			characterList[i] = curDisPlayTable:sub(i * 3 - 2, i * 3)
		end
		local instructionChinese = {}
		if curDisPlayTableLength <= 9 then
			if curDisPlayTableLength == 3 then
				instructionChinese[1] = "[1]" .. characterList[1]
			elseif curDisPlayTableLength == 6 then
				instructionChinese[1] = "[1]" .. characterList[1] .. " [2]" .. characterList[2]
			else
				instructionChinese[1] = "[1]" .. characterList[1] .. " [2]" .. characterList[2] .. " [3]" .. characterList[3]
			end
		elseif curDisPlayTableLength <= 18 then
			instructionChinese[1] = "[1]" .. characterList[1] .. " [2]" .. characterList[2] .. " [3]" .. characterList[3]
			if curDisPlayTableLength == 12 then
				instructionChinese[2] = "[4]" .. characterList[4]
			elseif curDisPlayTableLength == 15 then
				instructionChinese[2] = "[4]" .. characterList[4] .. " [5]" .. characterList[5]
			else
				instructionChinese[2] = "[4]" .. characterList[4] .. " [5]" .. characterList[5] .. " [6]" .. characterList[6]
			end
		else
			instructionChinese[1] = "[1]" .. characterList[1] .. " [2]" .. characterList[2] .. " [3]" .. characterList[3]
			instructionChinese[2] = "[4]" .. characterList[4] .. " [5]" .. characterList[5] .. " [6]" .. characterList[6]
			if curDisPlayTableLength == 21 then
				instructionChinese[3] = "[7]" .. characterList[7]
			elseif curDisPlayTableLength == 24 then
				instructionChinese[3] = "[7]" .. characterList[7] .. " [8]" .. characterList[8]
			else
				instructionChinese[3] = "[7]" .. characterList[7] .. " [8]" .. characterList[8] .. " [9]" .. characterList[9]
			end
		end
		local lineNum = 0
		local characterNum = #characterList
		if characterNum <= 3 then
			lineNum = 1
		elseif characterNum <= 6 then
			lineNum = 2
		else
			lineNum = 3
		end
		for i = 1, lineNum do
    		font:DrawStringScaledUTF8(instructionChinese[i], consoleInstructionPos[1], consoleInstructionPos[2] + i * consoleInstructionPos[3] + gameOverOffsetY, fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
		end
		local maxPageNum = #characterDisplayTable / 3 // 9
		if #characterDisplayTable / 3 % 9 == 0 then
			maxPageNum = maxPageNum - 1
		end
		if Input.IsButtonTriggered(Keyboard.KEY_LEFT_CONTROL, 0) then
			if curCharactersPage > 0 then
				curCharactersPage = curCharactersPage - 1
			end
		elseif Input.IsButtonTriggered(Keyboard.KEY_RIGHT_CONTROL, 0) then 
			if curCharactersPage < maxPageNum then
				curCharactersPage = curCharactersPage + 1
			end
		end
		lastPinyinLength = pinyinLength
	else
		if consoleInstructionPage == consoleInstructionPageTbl.HOME then -- page 1
			for i = 1, 3 do
    			font:DrawStringScaledUTF8(instructionTextTable.instructionDefault[i], consoleInstructionPos[1], consoleInstructionPos[2] + i * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			end
			font:DrawStringScaledUTF8(instructionTextTable.instructionDefault[4], consoleInstructionPos[1], consoleInstructionPos[2] + 4 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(1, 0.75, 0, 1), 0, false)
			nextPage()
		elseif consoleInstructionPage == consoleInstructionPageTbl.PAGE_2 then -- page 2
			for i = 1, 3 do
				font:DrawStringScaledUTF8(instructionTextTable.instructionDefault[i + 4], consoleInstructionPos[1], consoleInstructionPos[2] + i * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			end
			font:DrawStringScaledUTF8(instructionTextTable.instructionDefault[8], consoleInstructionPos[1], consoleInstructionPos[2] + 4 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(1, 0.75, 0, 1), 0, false)
			lastPage()
			nextPage()
		elseif consoleInstructionPage == consoleInstructionPageTbl.PAGE_3 then -- page 3
			for i = 1, 3 do
				font:DrawStringScaledUTF8(instructionTextTable.instructionDefault[i + 8], consoleInstructionPos[1], consoleInstructionPos[2] + i * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			end
			font:DrawStringScaledUTF8(instructionTextTable.instructionDefault[12], consoleInstructionPos[1], consoleInstructionPos[2] + 4 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(1, 0.75, 0, 1), 0, false)
			lastPage()
			--for IsaacSocket
			if IsaacSocket ~= nil then
				font:DrawStringScaledUTF8("IsaacSocketの", consoleInstructionPos[1] + 280, consoleInstructionPos[2] + 1 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1] + 0.2, consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
				font:DrawStringScaledUTF8("↓额外功能↓", consoleInstructionPos[1] + 280, consoleInstructionPos[2] + 2 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1] + 0.2, consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
				font:DrawStringScaledUTF8("[RCtrl]下一页", consoleInstructionPos[1] + 280, consoleInstructionPos[2] + 3 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1] + 0.2, consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
				if Input.IsButtonTriggered(Keyboard.KEY_RIGHT_CONTROL, 0) then
					consoleInstructionPage = consoleInstructionPageTbl.PAGE_4
				end
			end
		elseif consoleInstructionPage == consoleInstructionPageTbl.DEATH then
			for i = 1, 4 do
    			font:DrawStringScaledUTF8(instructionTextTable.instructionDeath[i], consoleInstructionPos[1], consoleInstructionPos[2] + i * consoleInstructionPos[3] + gameOverOffsetY, fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			end
		elseif consoleInstructionPage == consoleInstructionPageTbl.CHARACTER_1 or consoleInstructionPage == consoleInstructionPageTbl.RESTART_1 then
			for i = 1, 3 do
    			font:DrawStringScaledUTF8(instructionTextTable.instructionChangePlayerType[i], consoleInstructionPos[1], consoleInstructionPos[2] + i * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			end
			nextPage()
		elseif consoleInstructionPage == consoleInstructionPageTbl.CHARACTER_2 or consoleInstructionPage == consoleInstructionPageTbl.RESTART_2 then
			for i = 1, 3 do
    			font:DrawStringScaledUTF8(instructionTextTable.instructionChangePlayerType[i + 3], consoleInstructionPos[1], consoleInstructionPos[2] + i * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			end
			lastPage()
			nextPage()
		elseif consoleInstructionPage == consoleInstructionPageTbl.CHARACTER_3 or consoleInstructionPage == consoleInstructionPageTbl.RESTART_3 then
			for i = 1, 3 do
				font:DrawStringScaledUTF8(instructionTextTable.instructionChangePlayerType[i + 6], consoleInstructionPos[1], consoleInstructionPos[2] + i * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			end
			lastPage()
		elseif consoleInstructionPage == consoleInstructionPageTbl.BAN then
			for i = 1, 3 do
				font:DrawStringScaledUTF8(instructionTextTable.instructionBan[i], consoleInstructionPos[1], consoleInstructionPos[2] + i * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			end
		elseif consoleInstructionPage == consoleInstructionPageTbl.STAGE then
			for i = 1, 3 do
				local displayText = ""
				if isGreed then
					displayText = instructionTextTable.instructionStage[2][i]
				else
					displayText = instructionTextTable.instructionStage[1][i]
				end
				font:DrawStringScaledUTF8(displayText, consoleInstructionPos[1], consoleInstructionPos[2] + i * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			end
		elseif consoleInstructionPage == consoleInstructionPageTbl.GIVEITEM then
			for i = 1, 3 do
				font:DrawStringScaledUTF8(instructionTextTable.instructionGiveitem[i], consoleInstructionPos[1], consoleInstructionPos[2] + i * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			end
		elseif consoleInstructionPage == consoleInstructionPageTbl.REMOVE then
			for i = 1, 3 do
				font:DrawStringScaledUTF8(instructionTextTable.instructionRemove[i], consoleInstructionPos[1], consoleInstructionPos[2] + i * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			end
		elseif consoleInstructionPage == consoleInstructionPageTbl.USEITEM then
			for i = 1, 3 do
				font:DrawStringScaledUTF8(instructionTextTable.instructionUseitem[i], consoleInstructionPos[1], consoleInstructionPos[2] + i * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			end
		elseif consoleInstructionPage == consoleInstructionPageTbl.SPAWN then
			for i = 1, 3 do
				font:DrawStringScaledUTF8(instructionTextTable.instructionSpawn[i], consoleInstructionPos[1], consoleInstructionPos[2] + i * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			end
		elseif consoleInstructionPage == consoleInstructionPageTbl.DEBUG_1 then
			for i = 1, 3 do
				font:DrawStringScaledUTF8(instructionTextTable.instructionDebug[i], consoleInstructionPos[1], consoleInstructionPos[2] + i * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			end
			nextPage()
		elseif consoleInstructionPage == consoleInstructionPageTbl.DEBUG_2 then
			for i = 1, 3 do
				font:DrawStringScaledUTF8(instructionTextTable.instructionDebug[i + 3], consoleInstructionPos[1], consoleInstructionPos[2] + i * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			end
			lastPage()
		elseif consoleInstructionPage == consoleInstructionPageTbl.REPEAT then
			for i = 1, 3 do
				font:DrawStringScaledUTF8(instructionTextTable.instructionRepeat[i], consoleInstructionPos[1], consoleInstructionPos[2] + i * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			end
		elseif consoleInstructionPage == consoleInstructionPageTbl.CLEAR then
			font:DrawStringScaledUTF8(instructionTextTable.instructionClear[1], consoleInstructionPos[1], consoleInstructionPos[2] + consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
		elseif consoleInstructionPage == consoleInstructionPageTbl.CHALLENGE_1 then
			for i = 1, 3 do
				font:DrawStringScaledUTF8(instructionTextTable.instructionChallenge[i], consoleInstructionPos[1], consoleInstructionPos[2] + i * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			end
			nextPage()
		elseif consoleInstructionPage == consoleInstructionPageTbl.CHALLENGE_2 then
			for i = 1, 3 do
				font:DrawStringScaledUTF8(instructionTextTable.instructionChallenge[i + 3], consoleInstructionPos[1], consoleInstructionPos[2] + i * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			end
			nextPage()
			lastPage()
		elseif consoleInstructionPage == consoleInstructionPageTbl.CHALLENGE_3 then
			for i = 1, 3 do
				font:DrawStringScaledUTF8(instructionTextTable.instructionChallenge[i + 6], consoleInstructionPos[1], consoleInstructionPos[2] + i * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			end
			nextPage()
			lastPage()
		elseif consoleInstructionPage == consoleInstructionPageTbl.CHALLENGE_4 then
			for i = 1, 3 do
				font:DrawStringScaledUTF8(instructionTextTable.instructionChallenge[i + 9], consoleInstructionPos[1], consoleInstructionPos[2] + i * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			end
			lastPage()
		elseif consoleInstructionPage == consoleInstructionPageTbl.GRIDSPAWN_1 then
			for i = 1, 3 do
				font:DrawStringScaledUTF8(instructionTextTable.instructionGridspawn[i], consoleInstructionPos[1], consoleInstructionPos[2] + i * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			end
			nextPage()
		elseif consoleInstructionPage == consoleInstructionPageTbl.GRIDSPAWN_2 then
			for i = 1, 3 do
				font:DrawStringScaledUTF8(instructionTextTable.instructionGridspawn[i + 3], consoleInstructionPos[1], consoleInstructionPos[2] + i * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			end
			lastPage()
		elseif consoleInstructionPage == consoleInstructionPageTbl.COSTUME then
			for i = 1, 3 do
				font:DrawStringScaledUTF8(instructionTextTable.instructionCostumetest[i], consoleInstructionPos[1], consoleInstructionPos[2] + i * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			end
		elseif consoleInstructionPage == consoleInstructionPageTbl.CURSE_1 then
			for i = 1, 3 do
				font:DrawStringScaledUTF8(instructionTextTable.instructionCurse[i], consoleInstructionPos[1], consoleInstructionPos[2] + i * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			end
			nextPage()
		elseif consoleInstructionPage == consoleInstructionPageTbl.CURSE_2 then
			for i = 1, 3 do
				font:DrawStringScaledUTF8(instructionTextTable.instructionCurse[i + 3], consoleInstructionPos[1], consoleInstructionPos[2] + i * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			end
			lastPage()
		elseif consoleInstructionPage == consoleInstructionPageTbl.GOTO then
			for i = 1, 3 do
				font:DrawStringScaledUTF8(instructionTextTable.instructionGoto[i], consoleInstructionPos[1], consoleInstructionPos[2] + i * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			end
		elseif consoleInstructionPage == consoleInstructionPageTbl.REWIND then
			font:DrawStringScaledUTF8(instructionTextTable.instructionRewind[1], consoleInstructionPos[1], consoleInstructionPos[2] + consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
		elseif consoleInstructionPage == consoleInstructionPageTbl.CUTSCENE_1 then
			for i = 1, 3 do
				font:DrawStringScaledUTF8(instructionTextTable.instructionCutscene[i], consoleInstructionPos[1], consoleInstructionPos[2] + i * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			end
			nextPage()
		elseif consoleInstructionPage == consoleInstructionPageTbl.CUTSCENE_2 then
			for i = 1, 3 do
				font:DrawStringScaledUTF8(instructionTextTable.instructionCutscene[i + 3], consoleInstructionPos[1], consoleInstructionPos[2] + i * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			end
			lastPage()
		elseif consoleInstructionPage == consoleInstructionPageTbl.PAGE_4 then --for IsaacSocket (page 4)
			local edenInstruction = "[eden]修改伊甸币数量<当前数量"
			if isaacSocketCountTable.edenTokenNum ~= nil then
				edenInstruction = edenInstruction .. isaacSocketCountTable.edenTokenNum
			end
			edenInstruction = edenInstruction .. ">      [vac]查看解锁/未解锁成就编号"
			font:DrawStringScaledUTF8(edenInstruction, consoleInstructionPos[1], consoleInstructionPos[2] + 1 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1] + 0.2, consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			local greedDonationInstruction = "[gdnt]修改贪婪捐款数量<当前数量"
			if isaacSocketCountTable.greedDonationNum ~= nil then
				greedDonationInstruction = greedDonationInstruction .. isaacSocketCountTable.greedDonationNum % 1000
			end
			greedDonationInstruction = greedDonationInstruction .. ">      [uac]解锁指定成就      [lac]锁上指定成就"
			font:DrawStringScaledUTF8(greedDonationInstruction, consoleInstructionPos[1], consoleInstructionPos[2] + 2 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1] + 0.2, consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			local donationInstruction = "[dnt]修改捐款数量<当前数量"
			if isaacSocketCountTable.donationNum ~= nil then
				donationInstruction = donationInstruction .. isaacSocketCountTable.donationNum % 1000
			end
			donationInstruction = donationInstruction .. ">      [LCtrl]上一页      [RCtrl]下一页"
			font:DrawStringScaledUTF8(donationInstruction, consoleInstructionPos[1], consoleInstructionPos[2] + 3 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1] + 0.2, consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("解锁成就后不会自动添加角色面板的终点标记，但是应解锁的物品均已解锁", consoleInstructionPos[1], consoleInstructionPos[2] + 4 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(1, 0.75, 0, 1), 0, false)
			if Input.IsButtonTriggered(Keyboard.KEY_LEFT_CONTROL, 0) then
				consoleInstructionPage = consoleInstructionPageTbl.PAGE_3
			end
			if Input.IsButtonTriggered(Keyboard.KEY_RIGHT_CONTROL, 0) then
				consoleInstructionPage = consoleInstructionPageTbl.PAGE_5
			end
		elseif consoleInstructionPage == consoleInstructionPageTbl.EDEN then --for IsaacSocket [eden]
			local edenInstruction = "[X]将伊甸币数量修改为X个<当前数量"
			if isaacSocketCountTable.edenTokenNum ~= nil then
				edenInstruction = edenInstruction .. isaacSocketCountTable.edenTokenNum
			end
			font:DrawStringScaledUTF8(edenInstruction .. ">", consoleInstructionPos[1], consoleInstructionPos[2] + 1 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1] + 0.2, consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("（X只能是0到2147483647之间的整数）", consoleInstructionPos[1], consoleInstructionPos[2] + 2 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1] + 0.2, consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
		elseif consoleInstructionPage == consoleInstructionPageTbl.ALLOCATE_DEBUG_CONSOLE then --for IsaacSocket [adc]
			font:DrawStringScaledUTF8("adc新建调试控制台并与游戏关联", consoleInstructionPos[1], consoleInstructionPos[2] + 1 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1] + 0.2, consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("（若物理关闭与游戏关联的调试控制台，游戏也会一起关闭）", consoleInstructionPos[1], consoleInstructionPos[2] + 2 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1] + 0.2, consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
		elseif consoleInstructionPage == consoleInstructionPageTbl.FREE_DEBUG_CONSOLE then --for IsaacSocket [fdc]
			font:DrawStringScaledUTF8("fdc解除调试控制台与游戏之间的关联", consoleInstructionPos[1], consoleInstructionPos[2] + 1 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1] + 0.2, consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("（解除关联的调试控制台窗口需要手动关闭）", consoleInstructionPos[1], consoleInstructionPos[2] + 2 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1] + 0.2, consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
		elseif consoleInstructionPage == consoleInstructionPageTbl.OUTPUT then --for IsaacSocket [output]
			font:DrawStringScaledUTF8("[任意内容]向与游戏关联的调试控制台输出这些文字", consoleInstructionPos[1], consoleInstructionPos[2] + 1 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1] + 0.2, consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("（可以使用[rep]或[repeat]指令重复执行多次）", consoleInstructionPos[1], consoleInstructionPos[2] + 2 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1] + 0.2, consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("（执行[output]指令时，若调试控制台内文本被选中，", consoleInstructionPos[1], consoleInstructionPos[2] + 3 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1] + 0.2, consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("   游戏会卡住，请在调试控制台内按鼠标右键以取消选中）", consoleInstructionPos[1], consoleInstructionPos[2] + 4 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1] + 0.2, consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
		elseif consoleInstructionPage == consoleInstructionPageTbl.UNLOCK_ACHIEVEMENT then --for IsaacSocket [uac]
			font:DrawStringScaledUTF8("[X]解锁成就X", consoleInstructionPos[1], consoleInstructionPos[2] + 1 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1] + 0.2, consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("（X为1到637之间的整数，可通过[vac]指令查看解锁/未解锁成就编号）", consoleInstructionPos[1], consoleInstructionPos[2] + 2 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1] + 0.2, consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("（若X填入all，则解锁全成就）", consoleInstructionPos[1], consoleInstructionPos[2] + 3 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1] + 0.2, consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
		elseif consoleInstructionPage == consoleInstructionPageTbl.LOCK_ACHIEVEMENT then --for IsaacSocket [lac]
			font:DrawStringScaledUTF8("[X]锁上成就X", consoleInstructionPos[1], consoleInstructionPos[2] + 1 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1] + 0.2, consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("（X为1到637之间的整数，可通过[vac]指令查看解锁/未解锁成就编号）", consoleInstructionPos[1], consoleInstructionPos[2] + 2 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1] + 0.2, consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("（若X填入all，则锁上全成就）", consoleInstructionPos[1], consoleInstructionPos[2] + 3 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1] + 0.2, consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
		elseif consoleInstructionPage == consoleInstructionPageTbl.VIEW_ACHIEVEMENT then --for IsaacSocket [vac]
			font:DrawStringScaledUTF8("vac查看解锁/未解锁成就编号", consoleInstructionPos[1], consoleInstructionPos[2] + 1 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1] + 0.2, consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
		elseif consoleInstructionPage == consoleInstructionPageTbl.PAGE_5 then -- for IsaacSocket (page 5)
			local gameSpeedInstruction = "[speed]修改游戏速度<当前目标速度"
			if isaacSocketCountTable.gameSpeed ~= nil then
				gameSpeedInstruction = gameSpeedInstruction .. isaacSocketCountTable.gameSpeed
			end
			font:DrawStringScaledUTF8(gameSpeedInstruction .. ">", consoleInstructionPos[1], consoleInstructionPos[2] + 1 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1] + 0.2, consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			local edensBlessingInstruction = "[seb]设置下局玫瑰数量<当前数量"
			if isaacSocketCountTable.edensBlessing ~= nil then
				edensBlessingInstruction = edensBlessingInstruction .. isaacSocketCountTable.edensBlessing
			end
			font:DrawStringScaledUTF8(edensBlessingInstruction .. ">", consoleInstructionPos[1], consoleInstructionPos[2] + 2 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1] + 0.2, consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("[vws]查看连胜数      [LCtrl]上一页      [RCtrl]下一页", consoleInstructionPos[1], consoleInstructionPos[2] + 3 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1] + 0.2, consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			if Input.IsButtonTriggered(Keyboard.KEY_LEFT_CONTROL, 0) then
				consoleInstructionPage = consoleInstructionPageTbl.PAGE_4
			end
			if Input.IsButtonTriggered(Keyboard.KEY_RIGHT_CONTROL, 0) then
				consoleInstructionPage = consoleInstructionPageTbl.PAGE_6
			end
		elseif consoleInstructionPage == consoleInstructionPageTbl.PAGE_6 then -- for IsaacSocket (page 6)
			font:DrawStringScaledUTF8("[adc]新建调试控制台      [fdc]释放调试控制台", consoleInstructionPos[1], consoleInstructionPos[2] + 1 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1] + 0.2, consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("[output]输出文字至调试控制台      [LCtrl]上一页", consoleInstructionPos[1], consoleInstructionPos[2] + 2 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1] + 0.2, consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("有关联游戏的调试控制台存在时[output]指令才会生效", consoleInstructionPos[1], consoleInstructionPos[2] + 4 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(1, 0.75, 0, 1), 0, false)
			if Input.IsButtonTriggered(Keyboard.KEY_LEFT_CONTROL, 0) then
				consoleInstructionPage = consoleInstructionPageTbl.PAGE_5
			end
		elseif consoleInstructionPage == consoleInstructionPageTbl.DONATION then -- for IsaacSocket [dnt]
			local donationInstruction = "[X]将捐款数量修改为X<当前数量"
			if isaacSocketCountTable.donationNum ~= nil then
				donationInstruction = donationInstruction .. isaacSocketCountTable.donationNum % 1000
			end
			font:DrawStringScaledUTF8(donationInstruction .. ">", consoleInstructionPos[1], consoleInstructionPos[2] + 1 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1] + 0.2, consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("（X只能是0到999之间的整数）", consoleInstructionPos[1], consoleInstructionPos[2] + 2 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1] + 0.2, consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
		elseif consoleInstructionPage == consoleInstructionPageTbl.GREED_DONATION then -- for IsaacSocket [gdnt]
			local greedDonationInstruction = "[X]将贪婪捐款数量修改为X<当前数量"
			if isaacSocketCountTable.greedDonationNum ~= nil then
				greedDonationInstruction = greedDonationInstruction .. isaacSocketCountTable.greedDonationNum % 1000
			end
			font:DrawStringScaledUTF8(greedDonationInstruction .. ">", consoleInstructionPos[1], consoleInstructionPos[2] + 1 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1] + 0.2, consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("（X只能是0到999之间的整数）", consoleInstructionPos[1], consoleInstructionPos[2] + 2 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1] + 0.2, consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
		elseif consoleInstructionPage == consoleInstructionPageTbl.SPEED then -- for IsaacSocket [speed]
			local gameSpeedInstruction = "[X]将目标游戏速度修改为X倍<当前目标速度"
			if isaacSocketCountTable.gameSpeed ~= nil then
				gameSpeedInstruction = gameSpeedInstruction .. isaacSocketCountTable.gameSpeed
			end
			font:DrawStringScaledUTF8(gameSpeedInstruction .. ">", consoleInstructionPos[1], consoleInstructionPos[2] + 1 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1] + 0.2, consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("（X只能是0.1到100之间的数）", consoleInstructionPos[1], consoleInstructionPos[2] + 2 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1] + 0.2, consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("（实际游戏速度会受设备影响而动态浮动，因此未必能达到目标速度）", consoleInstructionPos[1], consoleInstructionPos[2] + 3 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1] + 0.2, consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("[Ins]重置目标游戏速度为1.00", consoleInstructionPos[1], consoleInstructionPos[2] + 4 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(1, 0.75, 0, 1), 0, false)
		elseif consoleInstructionPage == consoleInstructionPageTbl.OPTION_MENU_HOME then -- for [F6] submenu
			font:DrawStringScaledUTF8("[F1]开关道具品级文字显示                 [F2]开关debug文字显示", consoleInstructionPos[1], consoleInstructionPos[2] + 1 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("[F3]开关道具池图片显示                     [F4]道具池图片显示参数设置", consoleInstructionPos[1], consoleInstructionPos[2] + 2 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("[F5]调整控制台内的文字/图像位置      [F6]开关控制台打印文字淡出", consoleInstructionPos[1], consoleInstructionPos[2] + 3 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("[F8]恢复默认（除[F5][F6]之外）           [LCtrl]返回主页面", consoleInstructionPos[1], consoleInstructionPos[2] + 4 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			if Input.IsButtonTriggered(Keyboard.KEY_LEFT_CONTROL, 0) then
				consoleInstructionPage = consoleInstructionPageTbl.HOME
			end
		elseif consoleInstructionPage == consoleInstructionPageTbl.OPTION_MENU_F4 then -- for [F6][F4] submenu
			font:DrawStringScaledUTF8("[F1]开关致盲诅咒时仍显示道具池", consoleInstructionPos[1], consoleInstructionPos[2] + 1 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("[F2]开关角色拥有混沌时仍显示道具池", consoleInstructionPos[1], consoleInstructionPos[2] + 2 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("[LCtrl]返回功能选项菜单", consoleInstructionPos[1], consoleInstructionPos[2] + 3 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			if Input.IsButtonTriggered(Keyboard.KEY_LEFT_CONTROL, 0) then
				consoleInstructionPage = consoleInstructionPageTbl.OPTION_MENU_HOME
			end
		elseif consoleInstructionPage == consoleInstructionPageTbl.LISTSEED then -- for [ls] or [listseed]
			font:DrawStringScaledUTF8(instructionTextTable.instructionListseed[1], consoleInstructionPos[1], consoleInstructionPos[2] + consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
		elseif consoleInstructionPage == consoleInstructionPageTbl.DELETESEED then -- for [ds] or [deleteseed]
			for i = 1, 2 do
				font:DrawStringScaledUTF8(instructionTextTable.instructionDeleteseed[i], consoleInstructionPos[1], consoleInstructionPos[2] + i * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			end
		elseif consoleInstructionPage == consoleInstructionPageTbl.OPTION_MENU_F5 then -- for [F6][F5] console position adjustment submenu
			font:DrawStringScaledUTF8("[F1]调整控制台主体的位置          [F2]调整键盘映射的位置", consoleInstructionPos[1], consoleInstructionPos[2] + 1 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("[F3]调整debug3的文字位置          [F4]调整debug8的文字位置", consoleInstructionPos[1], consoleInstructionPos[2] + 2 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("[F5]调整debug4和9的文字位置     [F8]全部恢复默认", consoleInstructionPos[1], consoleInstructionPos[2] + 3 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("[LCtrl]返回功能选项菜单", consoleInstructionPos[1], consoleInstructionPos[2] + 4 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			if Input.IsButtonTriggered(Keyboard.KEY_LEFT_CONTROL, 0) then
				consoleInstructionPage = consoleInstructionPageTbl.OPTION_MENU_HOME
			end
		elseif consoleInstructionPage == consoleInstructionPageTbl.OPTION_MENU_F5_CONSOLE then -- for [F6][F5][F1] console positon adjustment
			font:DrawStringScaledUTF8("长按上下左右键调整控制台主体的位置，至少保证第四行金色文字能完整显示", consoleInstructionPos[1], consoleInstructionPos[2] + 1 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("长按上下左右键调整控制台主体的位置，至少保证第四行金色文字能完整显示", consoleInstructionPos[1], consoleInstructionPos[2] + 2 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("长按上下左右键调整控制台主体的位置，至少保证第四行金色文字能完整显示", consoleInstructionPos[1], consoleInstructionPos[2] + 3 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("[LCtrl]返回功能选项菜单    [F8]恢复默认", consoleInstructionPos[1], consoleInstructionPos[2] + 4 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(1, 0.75, 0, 1), 0, false)
			if Input.IsButtonTriggered(Keyboard.KEY_LEFT_CONTROL, 0) then
				consoleInstructionPage = consoleInstructionPageTbl.OPTION_MENU_F5
			end
		elseif consoleInstructionPage == consoleInstructionPageTbl.OPTION_MENU_F5_KEYBOARD then -- for [F6][F5][F2] keyboard overlay positon adjustment
			font:DrawStringScaledUTF8("长按上下左右键调整键盘映射的位置", consoleInstructionPos[1], consoleInstructionPos[2] + 1 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("（在控制台主界面中按[F4]开启/关闭键盘映射）", consoleInstructionPos[1], consoleInstructionPos[2] + 2 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("[LCtrl]返回功能选项菜单    [F8]恢复默认", consoleInstructionPos[1], consoleInstructionPos[2] + 3 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(1, 0.75, 0, 1), 0, false)
			if Input.IsButtonTriggered(Keyboard.KEY_LEFT_CONTROL, 0) then
				consoleInstructionPage = consoleInstructionPageTbl.OPTION_MENU_F5
			end
		elseif consoleInstructionPage == consoleInstructionPageTbl.OPTION_MENU_F5_DEBUG_3 then -- for [F6][F5][F3] debug3 text positon adjustment
			font:DrawStringScaledUTF8("长按上下左右键调整debug3文字的位置", consoleInstructionPos[1], consoleInstructionPos[2] + 1 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("（在[F6]功能选项菜单中可以开启/关闭debug文字显示）", consoleInstructionPos[1], consoleInstructionPos[2] + 2 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("[LCtrl]返回功能选项菜单    [F8]恢复默认", consoleInstructionPos[1], consoleInstructionPos[2] + 3 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(1, 0.75, 0, 1), 0, false)
			if Input.IsButtonTriggered(Keyboard.KEY_LEFT_CONTROL, 0) then
				consoleInstructionPage = consoleInstructionPageTbl.OPTION_MENU_F5
			end
		elseif consoleInstructionPage == consoleInstructionPageTbl.OPTION_MENU_F5_DEBUG_8 then -- for [F6][F5][F4] debug8 text positon adjustment
			font:DrawStringScaledUTF8("长按上下左右键调整debug8文字的位置", consoleInstructionPos[1], consoleInstructionPos[2] + 1 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("（在[F6]功能选项菜单中可以开启/关闭debug文字显示）", consoleInstructionPos[1], consoleInstructionPos[2] + 2 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("[LCtrl]返回功能选项菜单    [F8]恢复默认", consoleInstructionPos[1], consoleInstructionPos[2] + 3 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(1, 0.75, 0, 1), 0, false)
			if Input.IsButtonTriggered(Keyboard.KEY_LEFT_CONTROL, 0) then
				consoleInstructionPage = consoleInstructionPageTbl.OPTION_MENU_F5
			end
		elseif consoleInstructionPage == consoleInstructionPageTbl.OPTION_MENU_F5_DEBUG_4_AND_9 then -- for [F6][F5][F5] debug4&9 text positon adjustment
			font:DrawStringScaledUTF8("长按上下左右键调整debug4&9文字的位置", consoleInstructionPos[1], consoleInstructionPos[2] + 1 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("（在[F6]功能选项菜单中可以开启/关闭debug文字显示）", consoleInstructionPos[1], consoleInstructionPos[2] + 2 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("[LCtrl]返回功能选项菜单    [F8]恢复默认", consoleInstructionPos[1], consoleInstructionPos[2] + 3 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(1, 0.75, 0, 1), 0, false)
			if Input.IsButtonTriggered(Keyboard.KEY_LEFT_CONTROL, 0) then
				consoleInstructionPage = consoleInstructionPageTbl.OPTION_MENU_F5
			end
		elseif consoleInstructionPage == consoleInstructionPageTbl.DISPLAY_WIN_STREAK then -- for isaacsocket [vws]
			font:DrawStringScaledUTF8(instructionTextTable.instructionDisplayWinStreak[1], consoleInstructionPos[1], consoleInstructionPos[2] + consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1], consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
		elseif consoleInstructionPage == consoleInstructionPageTbl.SET_EDENS_BLESSING then -- for isaacsocket [seb]
			local edensBlessingInstruction = "[X]将下局玫瑰数量修改为X个<当前数量"
			if isaacSocketCountTable.edensBlessing ~= nil then
				edensBlessingInstruction = edensBlessingInstruction .. isaacSocketCountTable.edensBlessing
			end
			font:DrawStringScaledUTF8(edensBlessingInstruction .. ">", consoleInstructionPos[1], consoleInstructionPos[2] + 1 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1] + 0.2, consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("（X只能是0到10之间的整数）", consoleInstructionPos[1], consoleInstructionPos[2] + 2 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(consoleInstructionColor[1] + 0.2, consoleInstructionColor[2], consoleInstructionColor[3], 1), 0, false)
			font:DrawStringScaledUTF8("玫瑰数量大于10也只会生效10个", consoleInstructionPos[1], consoleInstructionPos[2] + 4 * consoleInstructionPos[3], fontScaledTable[1], fontScaledTable[2], KColor(1, 0.75, 0, 1, 0, false), 0, false)
		end
	end
end

local function getByteNum(byte)
    for i = 0, 7 do
        if (byte << i) & 128 == 0 then
            return i
        end
    end
    return 7
end

local function getChinesePartStr(str)
	local strLength = #str
	local charLengthStr = ""
	local pinyinExcludeStr = ""
	local i = 1
	while i <= strLength do
		local char = str:sub(i, i)
		local byte = string.byte(char)
		local count = getByteNum(byte)
		if count == 0 then
			charLengthStr = charLengthStr .. "1"
			pinyinExcludeStr = pinyinExcludeStr .. "1"
			i = i + 1
		else
			local substring = str:sub(i, i + count - 1)
			charLengthStr = charLengthStr .. count
			pinyinExcludeStr = pinyinExcludeStr .. "1"
			i = i + count
		end
	end
	return charLengthStr, pinyinExcludeStr
end

local function initButtonTriggered()
	needCheckRelease = true
	continueDisplayCursorForQuarterSecond = true
	cursorFrame = 0
	moveCursorFrame = 0
end

local function charInput(charWithoutShift, charWithShift, isShiftPressed)
	local needAddedChar = ''
	if isShiftPressed then
		needAddedChar = charWithShift
	else
		needAddedChar = charWithoutShift
	end
	if userCurString == [[]] or cursorIndex == #userCurString then
		userCurString = (userCurString .. needAddedChar)
	elseif cursorIndex == 0 then
		userCurString = (needAddedChar .. userCurString)
	else
		userCurString = (userCurString:sub(1, cursorIndex) .. needAddedChar .. userCurString:sub(cursorIndex + 1))
	end
	cursorIndex = cursorIndex + 1
	--Chinese part
	if cursorIndex == 1 then
		charLengthStr = stringInsert(charLengthStr, 1, "1")
		if chineseModeOn then
			if needAddedChar >= "a" and needAddedChar <= "z" then
				pinyinExcludeStr = stringInsert(pinyinExcludeStr, 1, "0")
			else
				pinyinExcludeStr = stringInsert(pinyinExcludeStr, 1, "1")
			end
		else
			pinyinExcludeStr = stringInsert(pinyinExcludeStr, 1, "1")
		end
		return
	end
	local insertIdx = 0
	local sum = 0
	for i = 1, #charLengthStr do
		sum = sum + charLengthStr:sub(i, i)
		if sum == cursorIndex - 1 then
			insertIdx = i
			break
		end
	end
	charLengthStr = stringInsert(charLengthStr, insertIdx + 1, "1")
	if chineseModeOn then
		if needAddedChar >= "a" and needAddedChar <= "z" then
			pinyinExcludeStr = stringInsert(pinyinExcludeStr, insertIdx + 1, "0")
		else
			pinyinExcludeStr = stringInsert(pinyinExcludeStr, insertIdx + 1, "1")
		end
	else
		pinyinExcludeStr = stringInsert(pinyinExcludeStr, insertIdx + 1, "1")
	end
	--Chinese part end
end

local function updateDisplayBox(str, mode, shouldFaded)
	if mode == displayBoxInsertMode.USER_STR then
		--insert a new user string
		local insertEnd = false
		local remainStr = (">>" .. str)
		while not insertEnd do
			if #remainStr <= minMaxCharNumInLine then
				table.insert(displayBox, {remainStr, 1})
				insertEnd = true
			else
				local nextLineStr = string.sub(remainStr, 1, minMaxCharNumInLine)
				remainStr = string.sub(remainStr, minMaxCharNumInLine + 1)
				local curWidth = font:GetStringWidthUTF8(nextLineStr)
				while curWidth < widthLimitInLine do
					nextLineStr = (nextLineStr .. string.sub(remainStr, 1, 1))
					if #remainStr==1 then
						insertEnd = true
						break
					end
					remainStr = string.sub(remainStr, 2)
					curWidth = font:GetStringWidthUTF8(nextLineStr)
				end
				table.insert(displayBox, {nextLineStr, 1})
			end
		end
	elseif mode == displayBoxInsertMode.CLEAR_BOX then
		--clear displaybox
		displayBox = {}
		userLastString = [[]]
		userStringIndex = nil
		userStringList = {}
		lastCharLengthStr = ""
		charLengthStrList = {}
		lastPinyinExcludeStr = ""
		pinyinExcludeStrList = {}
		displayUpdateMode = displayBoxInsertMode.USER_STR
	elseif mode == displayBoxInsertMode.PRINT_STR then
		--Compensate some alpha value for previous faded print string
		local displayBoxLength = #displayBox
		local compensateTimerOffset = 15
		local compensateTimerOffsetFound = false
		for i = displayBoxLength, 1, -1 do
			if displayBox[i][2] < 183 then
				compensateTimerOffsetFound = true
				if displayBox[i][2] - 8 <= 0 then
					compensateTimerOffset = 0
				elseif displayBox[i][2] - 8 < compensateTimerOffset then
					compensateTimerOffset = displayBox[i][2] - 8
				end
			end
			if compensateTimerOffsetFound then
				if i > displayBoxLength - maxFadedLineNum then
					if displayBox[i][2] > 3 and displayBox[i][2] < 183 then
						displayBox[i][2] = displayBox[i][2] - compensateTimerOffset
					end
				end
			end
		end
		--insert a new print string
		local insertEnd = false
		local remainStr = str
		local colorMark = 3
		if not shouldFaded then
			colorMark = 183
		end
		while not insertEnd do
			if #remainStr <= minMaxCharNumInLine then
				table.insert(displayBox, {remainStr, colorMark})
				insertEnd = true
			else
				local nextLineStr = string.sub(remainStr, 1, minMaxCharNumInLine)
				remainStr = string.sub(remainStr, minMaxCharNumInLine + 1)
				local curWidth = font:GetStringWidthUTF8(nextLineStr)
				while curWidth < widthLimitInLine do
					nextLineStr = (nextLineStr .. string.sub(remainStr, 1, 1))
					if #remainStr==1 then
						insertEnd = true
						break
					end
					remainStr = string.sub(remainStr, 2)
					curWidth = font:GetStringWidthUTF8(nextLineStr)
				end
				table.insert(displayBox, {nextLineStr, colorMark})
			end
		end
	elseif mode == displayBoxInsertMode.REMOVE_PRINT then
		if #displayBox > 11000 then
			local displayBoxLength = #displayBox
			local number = 0
			local toBeRemovedIndexList = {}
			for idx, tbl in ipairs(displayBox) do
				if tbl[2] >= 3 and tbl[2] <= 183 then
					table.insert(toBeRemovedIndexList, idx)
					number = number + 1
					if number == 1000 or idx > displayBoxLength - 1000 then
						break
					end
				end
			end
			for i = #toBeRemovedIndexList, 1, -1 do
				table.remove(displayBox, toBeRemovedIndexList[i])
			end
		end
	end
end

local function getAssertKey(inputKey)
	local assertKeyList = {"quality", "maxcharges", "chargetype", "shopprice", "devilprice"}
	for _, assertKey in pairs(assertKeyList) do
		if #assertKey >= #inputKey then
			if assertKey:sub(1, #inputKey) == inputKey then
				return assertKey
			end
		end
	end
end

local function updateSearchResultTable(targetStr)
	searchResultTable = {}
	local str = targetStr
	for i, command in ipairs(basicCommandList) do
		if #str > #command then
			local basicKeyWord = str:sub(1, #command)
			if basicKeyWord == command then
				if i >= 7 and i <= 22 then
					local restStr = str:sub(#command + 1)
					-- search process for [stage] command
					if  i == 19 or i == 20 then
						local curStageTable = stageTable
						if isGreed then
							curStageTable = greedModeStageTable
						end
						local isFind = false
						for j, nameList in pairs(curStageTable) do
							local targetStr = tostring(j)
							if #targetStr >= #restStr then
								if targetStr:sub(1, #restStr) == restStr then
									if displayLanguage then
										searchResultTable[targetStr] = nameList[1]
									else
										searchResultTable[targetStr] = nameList[2]
									end
									isFind = true
								end
							end
						end
						if isFind then
							return -13
						else
							searchResultTable = {}
							return
						end
					end
					-- search process for [spawn] command
					if i == 21 or i == 22 then
						-- index search for collectibles, trinkets and cards (spawn 5.100. or spawn 5.350. or spawn 5.300.)
						if restStr ~= "5" and restStr:sub(1, 1) ~= "6" and #restStr >= 6 then
							if restStr:sub(1, 2) == "5." then
								local variantStr = restStr:sub(3, 5)
								if variantStr == "100" or variantStr == "350" or variantStr == "300" then
									if restStr:sub(6, 6) == "." then
										local inputCode = ""
										if variantStr == "100" then
											inputCode = "c"
										elseif variantStr == "350" then
											inputCode = "t"
										else
											inputCode = "k"
										end
										local isGoldTrinket = false
										if #restStr > 6 then
											inputCode = inputCode .. restStr:sub(7)
											if variantStr == "350" and inputCode:sub(-1) == "+" then
												inputCode = inputCode:sub(1, -2)
												isGoldTrinket = true
											end
										end
										if variantStr == "300" then
											if #restStr == 6 then
												for j, nameList in ipairs(cardTable) do
													local code = "k" .. j
													if displayLanguage then
														searchResultTable[code] = nameList[1]
													else
														searchResultTable[code] = nameList[2]
													end
												end
												return i
											else
												local inputIndex = restStr:sub(7)
												local isFind = false
												for j, nameList in ipairs(cardTable) do
													local targetIndex = tostring(j)
													if #targetIndex >= #inputIndex then
														if targetIndex:sub(1, #inputIndex) == inputIndex then
															local code = "k" .. j
															if displayLanguage then
																searchResultTable[code] = nameList[1]
															else
																searchResultTable[code] = nameList[2]
															end
															isFind = true
														end
													end
												end
												if isFind then
													return i
												end
											end
										else
											for code, attr in pairs(collectibleOrTrinketTagsEnglishTable) do
												if #code >= #inputCode then
													if code:sub(1, #inputCode) == inputCode then
														if isGoldTrinket then
															code = code:upper()
														end
														if displayLanguage then
															searchResultTable[code] = attr["name"]
														else
															searchResultTable[code] = collectibleOrTrinketTagsChineseTable[code:lower()]["name"]
														end
													end
												end
											end
											return i
										end
									end
								end
							end
						end
						-- index search for pickups or slots (spawn 5, spawn 6)
						if restStr:sub(1, 1) == "5" then		
							-- subtype search with rewriting spawn 5.50. spawn 5.40. spawn 5.380.
							local isFind = false
							if #restStr >= 5 and restStr:sub(1, 2) == "5." then
								local canEnterSubTypeSearch = false
								if restStr:sub(5, 5) == "." then
									canEnterSubTypeSearch = true
								elseif #restStr >= 6 and restStr:sub(6, 6) == "." then
									canEnterSubTypeSearch = true
								end
								if canEnterSubTypeSearch then
									for spawnCode, nameList in pairs(spawnTableReWrite) do
										if spawnCode == restStr then
											for i = 1, #nameList do
												local name = nameList[i]
												searchResultTable[name] = spawnSubTypeTable[name]
											end
											isFind = true
										end
									end
									for spawnCode, name in pairs(spawnSubTypeTable) do
										if #spawnCode >= #restStr then
											if spawnCode:sub(1, #restStr) == restStr then
												searchResultTable[spawnCode] = name
												isFind = true
											end
										end
									end
									if isFind then
										return -5
									end
								end
							end
							-- variant search for spawn 5 and spawn 5.
							for spawnCode, name in pairs(spawnTable) do
								if #spawnCode >= #restStr then
									if spawnCode:sub(1, #restStr) == restStr then
										searchResultTable[spawnCode] = name
										isFind = true
									end
								end
							end
							if restStr == "5.38" or restStr == "5.380" then
								searchResultTable["5.380.10"] = spawnSubTypeTable["5.380.10"]
							end
							-- reconsider the excluded result due to rewriting
							if not isFind then
								for _, codeList in pairs(spawnTableReWrite) do
									for _, code in ipairs(codeList) do
										if restStr == code then
											searchResultTable[code] = spawnSubTypeTable[code]
											isFind = true
										end
									end
									if restStr == "5.42" then
										searchResultTable["5.42.1"] = spawnSubTypeTable["5.42.1"]
									end
								end
							end
							if isFind then
								return -5
							end
						elseif restStr:sub(1, 1) == "6" then
							-- slots search (spawn 6)
							if restStr == "6" or restStr == "6." then
								for j, nameList in ipairs(slotTable) do
									local spawnCode = "6." .. j
									if displayLanguage then
										searchResultTable[spawnCode] = nameList[1]
									else
										searchResultTable[spawnCode] = nameList[2]
									end
								end
								return -5
							elseif #restStr > 2 then
								local inputIndex = restStr:sub(3)
								local isFind = false
								for j, nameList in ipairs(slotTable) do
									local targetIndex = tostring(j)
									if #targetIndex >= #inputIndex then
										if targetIndex:sub(1, #inputIndex) == inputIndex then
											local spawnCode = "6." .. j
											if displayLanguage then
												searchResultTable[spawnCode] = nameList[1]
											else
												searchResultTable[spawnCode] = nameList[2]
											end
											isFind = true
										end
									end
								end
								if isFind then
									return -5
								end
							end
						end
					end
					-- index search for g and r and u (including giveitem, r2 and so on)
					if i >= 7 and i <= 18 then
						-- giveitem part (cards, pills)
						if i >= 7 and i <= 10 then
							local firstWord = restStr:sub(1, 1)
							local restStrLength = #restStr
							local isFind = false
							if firstWord == "k" then
								-- cards search
								if restStrLength == 1 then
									for j, nameList in ipairs(cardTable) do
										local code = "k" .. j
										if displayLanguage then
											searchResultTable[code] = nameList[1]
										else
											searchResultTable[code] = nameList[2]
										end
									end
									return i
								else
									local inputIndex = restStr:sub(2)
									for j, nameList in ipairs(cardTable) do
										local targetIndex = tostring(j)
										if #targetIndex >= #inputIndex then
											if targetIndex:sub(1, #inputIndex) == inputIndex then
												local code = "k" .. j
												if displayLanguage then
													searchResultTable[code] = nameList[1]
												else
													searchResultTable[code] = nameList[2]
												end
												isFind = true
											end
										end
									end
									if isFind then
										return i
									end
								end
							elseif firstWord == "p" or firstWord == "P" then
								-- pill search
								if restStrLength == 1 then
									for j, nameList in pairs(pillTable) do
										local code = firstWord .. j
										if displayLanguage then
											searchResultTable[code] = nameList[1]
										else
											searchResultTable[code] = nameList[2]
										end
									end
									return i
								else
									local inputIndex = restStr:sub(2)
									for j, nameList in pairs(pillTable) do
										local targetIndex = tostring(j)
										if #targetIndex >= #inputIndex then
											if targetIndex:sub(1, #inputIndex) == inputIndex then
												local code = firstWord .. j
												if displayLanguage then
													searchResultTable[code] = nameList[1]
												else
													searchResultTable[code] = nameList[2]
												end
												isFind = true
											end
										end
									end
									if isFind then
										return i
									end
								end
							end
						end
						-- useitem part (cards, pills, poops)
						if i >= 15 and i <= 18 then
							local firstWord = restStr:sub(1, 1)
							local restStrLength = #restStr
							local isFind = false	
							if firstWord == "k" then 
								-- cards search
								if restStrLength == 1 then
									for j, nameList in ipairs(cardTable) do
										local code = "k" .. j
										if displayLanguage then
											searchResultTable[code] = nameList[1]
										else
											searchResultTable[code] = nameList[2]
										end
									end
									return i
								else
									local inputIndex = restStr:sub(2)
									for j, nameList in ipairs(cardTable) do
										local targetIndex = tostring(j)
										if #targetIndex >= #inputIndex then
											if targetIndex:sub(1, #inputIndex) == inputIndex then
												local code = "k" .. j
												if displayLanguage then
													searchResultTable[code] = nameList[1]
												else
													searchResultTable[code] = nameList[2]
												end
												isFind = true
											end
										end
									end
									if isFind then
										return i
									end
								end
							elseif firstWord == "p" or firstWord == "P" then
								-- pill search
								if restStrLength == 1 then
									for j, nameList in pairs(pillTable) do
										local code = firstWord .. j
										if displayLanguage then
											searchResultTable[code] = nameList[1]
										else
											searchResultTable[code] = nameList[2]
										end
									end
									return i
								else
									local inputIndex = restStr:sub(2)
									for j, nameList in pairs(pillTable) do
										local targetIndex = tostring(j)
										if #targetIndex >= #inputIndex then
											if targetIndex:sub(1, #inputIndex) == inputIndex then
												local code = firstWord .. j
												if displayLanguage then
													searchResultTable[code] = nameList[1]
												else
													searchResultTable[code] = nameList[2]
												end
												isFind = true
											end
										end
									end
									if isFind then
										return i
									end
								end
							elseif firstWord == "b" then
								-- poop search
								if restStrLength == 1 then
									for j, nameList in ipairs(poopTable) do
										local code = "b" .. j
										if displayLanguage then
											searchResultTable[code] = nameList[1]
										else
											searchResultTable[code] = nameList[2]
										end
									end
									return i
								else
									local inputIndex = restStr:sub(2)
									for j, nameList in ipairs(poopTable) do
										local targetIndex = tostring(j)
										if #targetIndex >= #inputIndex then
											if targetIndex:sub(1, #inputIndex) == inputIndex then
												local code = "b" .. j
												if displayLanguage then
													searchResultTable[code] = nameList[1]
												else
													searchResultTable[code] = nameList[2]
												end
												isFind = true
											end
										end
									end
									if isFind then
										return i
									end
								end
							end
						end
						-- judge if user input satisfy the format of index search, if not, swtich to main search
						local startSearch = false
						local isGoldenTrinket = false
						if #restStr == 1 then
							-- format g c, g t, g T, make the format-unsatisfied result excluded
							local firstWord = restStr:sub(1, 1)
							if i >= 15 and i <= 18 then -- useitem (collectible)
								if firstWord == "c" then
									startSearch = true
								end
							elseif firstWord == "c" or firstWord == "t" or firstWord == "T" then
								startSearch = true
								if firstWord == "T" then
									isGoldenTrinket = true
								end
							end
						else
							-- format g c[num] r t[num] r T[num], make the format-unsatisfied result excluded
							local firstWord = restStr:sub(1, 1)
							local secondWord = restStr:sub(2, 2)
							if secondWord >= "1" and secondWord <= "9" then
								if firstWord == "c" or firstWord == "t" or firstWord == "T" then
									startSearch = true
									if firstWord == "T" then
										isGoldenTrinket = true
									end
								end
							-- skip searching for g-[num] r-[num] u-[num], this will be handeled in getExecuteString()
							elseif secondWord == "-" then
								return
							end
						end
						-- index search for g c and r c including giveitem2 c and so on
						if startSearch then
							local inputCode = restStr:lower()
							for code, attr in pairs(collectibleOrTrinketTagsEnglishTable) do
								if #code >= #inputCode then
									if code:sub(1, #inputCode) == inputCode then
										local finalCode = code
										if isGoldenTrinket then
											finalCode = finalCode:upper()
										end
										if displayLanguage then
											searchResultTable[finalCode] = attr["name"]
										else
											searchResultTable[finalCode] = collectibleOrTrinketTagsChineseTable[code]["name"]
										end
									end
								end
							end
							return i
						end
					end
					-- main search for sp, g, r, u including spawn, use, g2, remove2, and so on (name search, tag search, condition search)
					local databaseTableList = {collectibleOrTrinketTagsEnglishTable, collectibleOrTrinketTagsChineseTable, collectibleOrTrinketNickNameTable}
					local requestList = {}
					local requestCharLenList = {}
					local tempResultTable = {}
					local tempResultCharLenList = {}
					local inputNameUpper = ""
					local nameSearchLastRequestIndex = 1
					for splitStr in restStr:gmatch("%S+") do
						table.insert(requestList, splitStr)
					end
					local inputNameSplit = nil
					for j, request in ipairs(requestList) do
						local keyWord = request:sub(1, 1)
						if keyWord == "#" then
							--tag search
							if inputNameSplit == false then
								inputNameSplit = true
							end
							if #request == 1 then
								searchResultTable = {}
								return
							else
								local inputTagUpper = request:sub(2)
								local inputTag = inputTagUpper:lower()
								if next(tempResultTable) == nil then
									if j == 1 then
										for i, table in ipairs(databaseTableList) do
											if i > 2 then
												break
											end
											for code, attr in pairs(table) do
												local tagList = attr["tag"]
												for _, tagInTable in ipairs(tagList) do
													if tagInTable:lower():sub(1, #inputTag) == inputTag then
														if displayLanguage then
															if i == 1 then
																tempResultTable[code] = attr["name"]
															else
																tempResultTable[code] = collectibleOrTrinketTagsEnglishTable[code]["name"]
															end
														else
															if i == 1 then
																tempResultTable[code] = collectibleOrTrinketTagsChineseTable[code]["name"]
															else
																tempResultTable[code] = attr["name"]
															end
														end
														break
													end
												end
											end
										end
									end
								else
									for code, _ in pairs(tempResultTable) do
										local hasTag = false
										for i, table in ipairs(databaseTableList) do
											if hasTag or i > 2 then
												break
											end
											local attr = table[code]
											local tagList = attr["tag"]
											for _, tagInTable in ipairs(tagList) do
												if tagInTable:lower():sub(1, #inputTag) == inputTag then
													hasTag = true
													break
												end
											end
										end
										if not hasTag then
											tempResultTable[code] = nil
										end
									end
								end
							end
						elseif keyWord == "$" then
							--condition search
							if inputNameSplit == false then
								inputNameSplit = true
							end
							if #request == 1 then
								searchResultTable = {}
								return
							else
								local wholeAssert = request:sub(2)
								if #wholeAssert <= 2 then
									searchResultTable = {}
									return
								else
									local startIdx, _ = string.find(wholeAssert, ":")
									if startIdx == nil or startIdx == 1 or startIdx == #wholeAssert then
										searchResultTable = {}
										return
									else
										local inputAssertKey = wholeAssert:sub(1, startIdx - 1):lower()
										local inputAssertValue = wholeAssert:sub(startIdx + 1):lower()
										if next(tempResultTable) == nil then
											if j == 1 then
												for code, attr in pairs(collectibleOrTrinketTagsEnglishTable) do
													local checkAssertValue = attr[getAssertKey(inputAssertKey)]
													if checkAssertValue ~= nil and inputAssertValue == checkAssertValue then
														if displayLanguage then
															tempResultTable[code] = attr["name"]
														else
															tempResultTable[code] = collectibleOrTrinketTagsChineseTable[code]["name"]
														end
													end
												end
											end
										else
											for code, _ in pairs(tempResultTable) do
												local attr = collectibleOrTrinketTagsEnglishTable[code]
												local checkAssertValue = attr[getAssertKey(inputAssertKey)]
												if checkAssertValue == nil or inputAssertValue ~= checkAssertValue then
													tempResultTable[code] = nil
												end
											end
										end
									end
								end
							end
						else
							-- name search
							if inputNameSplit == nil then
								inputNameSplit = false
								inputNameUpper = inputNameUpper .. request
							elseif inputNameSplit then
								searchResultTable = {}
								return
							else
								inputNameUpper = inputNameUpper .. " " .. request
								nameSearchLastRequestIndex = nameSearchLastRequestIndex + 1
							end
							if j == #requestList or requestList[j+1]:sub(1, 1) == "#" or requestList[j+1]:sub(1, 1) == "$" then
								local inputName = inputNameUpper:lower()
								local inputLength = #inputName
								if next(tempResultTable) == nil then
									if j == nameSearchLastRequestIndex then
										for i, tbl in ipairs(databaseTableList) do
											for code, attr in pairs(tbl) do
												local targetNameList = {}
												if i == 1 or i == 2 then
													table.insert(targetNameList, attr["name"])
												else
													for _, name in ipairs(attr) do
														table.insert(targetNameList, name)
													end
												end
												for _, name in ipairs(targetNameList) do
													local nameInTable = name:lower()
													local targetLength = #nameInTable
													if inputLength <= targetLength then
														local diffLength = targetLength - inputLength
														for k = 1, diffLength + 1 do
															if nameInTable:sub(k, k + inputLength - 1) == inputName then
																if displayLanguage then
																	tempResultTable[code] = collectibleOrTrinketTagsEnglishTable[code]["name"]
																else
																	tempResultTable[code] = collectibleOrTrinketTagsChineseTable[code]["name"]
																end
																break
															end
														end
													end
												end
											end
										end
									end
								else
									for code, _ in pairs(tempResultTable) do
										local isFind = false
										for i, tbl in ipairs(databaseTableList) do
											if isFind then
												break
											end
											local targetNameList = {}
											if i == 1 or i == 2 then
												table.insert(targetNameList, tbl[code]["name"])
											else
												local nameList = tbl[code]
												for _, name in ipairs(nameList) do
													table.insert(targetNameList, name)
												end
											end
											for _, name in ipairs(targetNameList) do
												if isFind then
													break
												end
												local nameInTable = name:lower()
												local targetLength = #nameInTable
												if inputLength <= targetLength then
													local diffLength = targetLength - inputLength
													for k = 1, diffLength + 1 do
														if nameInTable:sub(k, k + inputLength - 1) == inputName then
															isFind = true
															break
														end
													end
												end
											end
										end
										if not isFind then
											tempResultTable[code] = nil
										end
									end
								end
							end
						end
					end
					for code, name in pairs(tempResultTable) do
						if i >= 15 and i <= 18 then
							if code:sub(1, 1) == "c" then
								searchResultTable[code] = name
							end
						else
							searchResultTable[code] = name
						end
					end
					return i --The string prefix that matches i = 7, 22 will cause the function return the index i even if the whole string does not take any effect.
				end
			end
		end
	end
	searchResultTable = {}
end

local function getExecuteString(str, searchKeyWord, needDisplayStringTable)
	if str == "lualua" then
		if IsaacSocket ~= nil then
			IsaacSocket.IsaacAPI.ReloadLua()
			return -1
		end
	elseif #str > 7 and str:sub(1, 7) == "luamod " then
		saveData()
		Isaac.ExecuteCommand(str)
		return -1
	end
	if str == "rewind" or str == "rew" then
		if consoleInstructionPage == consoleInstructionPageTbl.DEATH then
			consoleInstructionPage = consoleInstructionPageTbl.HOME
			gameOverOffsetY = 0
		end
		Isaac.ExecuteCommand("rewind")
		return -1
	end
	if consoleInstructionPage ~= consoleInstructionPageTbl.DEATH then
		--for IsaacSocket
		if IsaacSocket ~= nil then
			if #str > 5 and str:sub(1, 5) == "eden " then
				local numStr = str:sub(6)
				local num = tonumber(numStr)
				if num and math.floor(num) == num and num >= 0 and num < 2147483648 then
					IsaacSocket.IsaacAPI.SetEdenTokens(math.floor(num))
					isaacSocketCountTable.edenTokenNum = IsaacSocket.IsaacAPI.GetEdenTokens()
					return -1
				end
			end
			if #str > 4 and str:sub(1, 4) == "seb " then
				local numStr = str:sub(5)
				local num = tonumber(numStr)
				if num and math.floor(num) == num and num >= 0 and num <= 10 then
					local imageBase = IsaacSocket.Memory.GetImageBase()
					local managerOffset = 0x7FD680
					local edensBlessingOffset = 0x494
					local edensBlessingAddress = IsaacSocket.Memory.CalcAddress(imageBase + managerOffset, edensBlessingOffset)
					IsaacSocket.Memory.WriteUInt32(edensBlessingAddress, math.floor(num))
					isaacSocketCountTable.edensBlessing = IsaacSocket.Memory.ReadUInt32(edensBlessingAddress)
					return -1
				end
			end
			if str == "adc" then
				IsaacSocket.WinAPI.AllocConsole()
				return -1
			end
			if str == "fdc" then
				IsaacSocket.WinAPI.FreeConsole()
				return -1
			end
			if str == "vws" then
				local imageBase = IsaacSocket.Memory.GetImageBase()
				local managerOffset = 0x7FD680
				local winOffset = 0x324
				local loseOffset = 0x490
				local winAddress = IsaacSocket.Memory.CalcAddress(imageBase + managerOffset, winOffset)
				local loseAddress = IsaacSocket.Memory.CalcAddress(imageBase + managerOffset, loseOffset)
				local winStreakPositive = IsaacSocket.Memory.ReadUInt32(winAddress)
				local winStreakNegative = IsaacSocket.Memory.ReadUInt32(loseAddress)
				local winStreakStr = "当前连胜数为："
				if winStreakPositive == 0 and winStreakNegative == 0 then
					winStreakStr = winStreakStr .. "0"
				elseif winStreakPositive > 0 then
					winStreakStr = winStreakStr .. winStreakPositive
				else
					winStreakStr = winStreakStr .. "-" .. winStreakNegative
				end
				table.insert(needDisplayStringTable, winStreakStr)
				return -1
			end
			if #str > 7 and str:sub(1, 7) == "output " then
				local outputStr = str:sub(8)
				IsaacSocket.System.ConsoleOutput(outputStr .. "\n")
				lastExecutedStrTable = {[[IsaacSocket.System.ConsoleOutput("]] .. outputStr .. "\\n" .. [[")]], true}
				return -1
			end
			if #str > 4 and str:sub(1, 4) == "uac " then
				local numStr = str:sub(5)
				if numStr == "all" then
					IsaacSocket.IsaacAPI.UnlockAchievement(0, true)
					table.insert(needDisplayStringTable, "已解锁全成就")
					return -1
				end
				local num = tonumber(numStr)
				if num and math.floor(num) == num and num >= 1 and num <= 637 then
					IsaacSocket.IsaacAPI.UnlockAchievement(math.floor(num), true)
					table.insert(needDisplayStringTable, "已解锁成就" .. math.floor(num))
					return -1
				end
			end
			if #str > 4 and str:sub(1, 4) == "lac " then
				local numStr = str:sub(5)
				if numStr == "all" then
					IsaacSocket.IsaacAPI.UnlockAchievement(0, false)
					table.insert(needDisplayStringTable, "已锁上全成就")
					return -1
				end
				local num = tonumber(numStr)
				if num and math.floor(num) == num and num >= 1 and num <= 637 then
					IsaacSocket.IsaacAPI.UnlockAchievement(math.floor(num), false)
					table.insert(needDisplayStringTable, "已锁上成就" .. math.floor(num))
					return -1
				end
			end
			if str == "vac" then
				local unlockedAchievementStr = "已解锁成就："
				local lockedAchievementStr = "未解锁成就："
				for i = 1, 637 do
					if IsaacSocket.IsaacAPI.IsAchievementUnlocked(i) then
						unlockedAchievementStr = unlockedAchievementStr .. i .. " "
					else
						lockedAchievementStr = lockedAchievementStr .. i .. " "
					end
				end
				if unlockedAchievementStr == "已解锁成就：" then
					unlockedAchievementStr = unlockedAchievementStr .. "无   "
				end
				if lockedAchievementStr == "未解锁成就：" then
					lockedAchievementStr = lockedAchievementStr .. "无   "
				end
				table.insert(needDisplayStringTable, unlockedAchievementStr)
				table.insert(needDisplayStringTable, lockedAchievementStr)
				return -1
			end
			if #str > 4 and str:sub(1, 4) == "dnt " then
				local numStr = str:sub(5)
				local num = tonumber(numStr)
				if num and math.floor(num) == num and num >= 0 and num < 1000 then
					isaacSocketCountTable.donationNum = IsaacSocket.IsaacAPI.GetDonationCount()
					IsaacSocket.IsaacAPI.SetDonationCount(isaacSocketCountTable.donationNum // 1000 * 1000 + math.floor(num))
					isaacSocketCountTable.donationNum = IsaacSocket.IsaacAPI.GetDonationCount()
					return -1
				end
			end
			if #str > 5 and str:sub(1, 5) == "gdnt " then
				local numStr = str:sub(6)
				local num = tonumber(numStr)
				if num and math.floor(num) == num and num >= 0 and num < 1000 then
					isaacSocketCountTable.greedDonationNum = IsaacSocket.IsaacAPI.GetGreedDonationCount()
					IsaacSocket.IsaacAPI.SetGreedDonationCount(isaacSocketCountTable.greedDonationNum // 1000 * 1000 + math.floor(num))
					isaacSocketCountTable.greedDonationNum = IsaacSocket.IsaacAPI.GetGreedDonationCount()
					return -1
				end
			end
			if #str > 6 and str:sub(1, 6) == "speed " then
				local numStr = str:sub(7)
				local num = tonumber(numStr)
				if num and num >= 0.1 and num <= 100 then
					Options.VSync = false
					IsaacSocket.IsaacAPI.SetFrameInterval(1 / 60 / num)
					isaacSocketCountTable.gameSpeed = string.format("%.2f" , 1 / IsaacSocket.IsaacAPI.GetFrameInterval() / 60)
					return -1
				end
			end
		end
		if str == "clear" or str == "cl" then
			displayUpdateMode = displayBoxInsertMode.CLEAR_BOX
			return -1
		end
		if str == "ls" or str == "listseed" then
			for _, seedTbl in ipairs(seedList) do
				local seedStr = ""
				seedStr = seedStr .. seedTbl.seedStr .. " "
				local difficultyMap = {
					[0] = "普通模式",
					[1] = "困难模式",
					[2] = "贪婪模式",
					[3] = "困贪模式"
				}
				if seedTbl.challenge == 0 then
					if difficultyMap[seedTbl.mode] ~= nil then
						seedStr = seedStr .. difficultyMap[seedTbl.mode] .. " "
					else
						seedStr = seedStr .. "模式" .. seedTbl.mode .. " "
					end
					if characterMap[seedTbl.player] ~= nil then
						seedStr = seedStr .. characterMap[seedTbl.player]
					else
						seedStr = seedStr .. seedTbl.player
					end
				elseif seedTbl.challenge <= 45 then
					seedStr = seedStr .. "挑战" .. seedTbl.challenge
				else
					seedStr = seedStr .. "自定义挑战" .. seedTbl.challenge - 45
				end
				table.insert(needDisplayStringTable, seedStr)
			end
			return -1
		end
		if (#str > 3 and str:sub(1, 3) == "ds ") or (#str > 11 and str:sub(1, 11) == "deleteseed ") then
			local numStr = nil
			if str:sub(1, 3) == "ds " then 
				numStr = str:sub(4)
			else
				numStr = str:sub(12)
			end
			local num = tonumber(numStr)
			if num and math.floor(num) == num and num >= 1 and num <= 20 then
				local seedNum = #seedList
				if num < seedNum then
					for i = 1, seedNum - num do
						table.remove(seedList, 1)
					end
				end
				saveData()
				table.insert(needDisplayStringTable, "已将最近" .. num .. "局之前的种子记录删除")
				return -1
			end
		end
		if next(searchResultTable) ~= nil then
			local executeMapList = {spawnTableOrderMap, stageTableOrderMap}
			local executeKeyWordList = {"spawn", "stage"}
			local curExecuteMap = nil
			local curExecuteKeyWord = ""
			local isInExecuteTable = false
			if searchKeyWord == -5 then
				curExecuteMap = executeMapList[1]
				curExecuteKeyWord = executeKeyWordList[1]
				isInExecuteTable = true
			elseif searchKeyWord == -13 then
				curExecuteMap = executeMapList[2]
				curExecuteKeyWord = executeKeyWordList[2]
				isInExecuteTable = true
			end
			if isInExecuteTable then
				for _, code in ipairs(curExecuteMap) do 
					if searchResultTable[code] ~= nil then
						if searchKeyWord == -5 then --spawn
							return [[Isaac.ExecuteCommand("]] .. curExecuteKeyWord .. [[ ]] .. code .. [[")]], true
						elseif searchKeyWord == -13 then --stage
							return [[Isaac.ExecuteCommand("]] .. curExecuteKeyWord .. [[ ]] .. code .. [[")]], true, true --executed immediately if IsaacSocket is on
						else
							print("search key error: ", searchKeyWord)
						end
					end
				end
			end
			for _, code in ipairs(itemOrderMap) do
				local result = nil
				if searchResultTable[code] ~= nil then
					result = code
				else
					local upperCode = code:upper()
					if searchResultTable[upperCode] ~= nil then
						result = upperCode
					end
				end
				if result ~= nil then
					local itemType = result:sub(1, 1)
					local variant = ""
					local isGoldenTrinket = false
					if itemType == "c" then
						variant = "100"
					elseif itemType == "k" then
						variant = "300"
					elseif itemType == "t" or itemType == "T" then
						variant = "350"
					end
					local subType = result:sub(2)
					if searchKeyWord == 21 or searchKeyWord == 22 then --spawn
						if itemType == "T" then
							subType = subType + 32768
						end
						return [[Isaac.ExecuteCommand("spawn 5.]] .. variant .. [[.]] .. subType .. [[")]], true
					elseif searchKeyWord >= 15 and searchKeyWord <= 18 then --useitem
						local playerId = 0
						if searchKeyWord == 17 or searchKeyWord == 18 then
							playerId = 1
						end
						if itemType == "c" then
							return [[Isaac.GetPlayer(]] .. playerId .. [[):UseActiveItem(]] .. subType .. [[)]], true
						elseif itemType == "k" then
							return [[Isaac.GetPlayer(]] .. playerId .. [[):UseCard(]] .. subType .. [[)]], true
						elseif itemType == "p" then
							return [[Isaac.GetPlayer(]] .. playerId .. [[):UsePill(]] .. subType .. [[,30)]], true
						elseif itemType == "P" then
							return [[Isaac.GetPlayer(]] .. playerId .. [[):UsePill(]] .. subType .. [[,2070)]], true
						elseif itemType == "b" then
							return [[Isaac.GetPlayer(]] .. playerId .. [[):UsePoopSpell(]] .. subType .. [[)]], true
						end
					elseif itemType == "k" then
						return [[Isaac.ExecuteCommand("]] .. basicCommandList[searchKeyWord] .. itemType .. subType .. [[")]], true, true --executed immediately if IsaacSocket is on
					else
						return [[Isaac.ExecuteCommand("]] .. basicCommandList[searchKeyWord] .. itemType .. subType .. [[")]], true
					end
				end
			end
		end
	end
	local isBasicCommand = false
	local isLua = false
	local isRepeat = false
	local repeatNum = nil
	local isDebug = false
	local debugNum = nil
	local isChangePlayer = false
	local changePlayNum = nil
	local isBanItem = false
	local banItemParam = nil
	local banItemType = nil
	local isGOrR = false
	local gOrRParam = nil
	local uParam = nil
	local gOrRKeyWord = nil
	local executeString = [[]]
	for i, command in ipairs(basicCommandList) do
		if #str > #command then
			local keyWord = str:sub(1, #command)
			if keyWord == command then
				isBasicCommand = true
				if i == 1 or i == 2 then --"l ", "lua "
					isLua = true
					executeString = str:sub(#command + 1)
				elseif i == 3 or i == 4 then --"rep ", "repeat "
					isRepeat = true
					local numStr = str:sub(#command + 1)
					local num = tonumber(numStr)
					if num and math.floor(num) == num and num > 0 then
						repeatNum = num
					end
				elseif i == 5 or i == 6 then --"d ", "debug "
					isDebug = true
					local numStr = str:sub(#command + 1)
					local num = tonumber(numStr)
					if num and math.floor(num) == num and num > 0 then
						debugNum = num
					end
					executeString = (basicCommandTable[keyWord] .. numStr)
				elseif i == 37 then --"原地换人 "
					isChangePlayer = true
					local numStr = str:sub(#command + 1)
					local num = tonumber(numStr)
					if num and math.floor(num) == num and num >= 0 then
						changePlayNum = num
					end
				elseif i == 38 then --"ban "
					isBanItem = true
					local paramStr = str:sub(#command + 1)
					local num = tonumber(paramStr)
					if num and math.floor(num) == num and num > 0 then
						banItemParam = num
						banItemType = true --true for ban single item by ID
					else
						if paramStr:sub(1, 1) == "q" then
							if #paramStr == 1 then
								return -1
							end
							local restNumStr = paramStr:sub(2)
							local quality = tonumber(restNumStr)
							if quality and math.floor(quality) == quality and quality >= 0 then
								banItemParam = quality
								banItemType = false --true for ban all items with specific quality
							end
						end
					end
				elseif i >= 7 and i <= 18 then --"g ", "giveitem ", "g2 ", "giveitem2 ", "r ", "remove ", "r2 ", "remove2 ", "u ", "useitem ", "u2 ", "useitem2 ",
					isGOrR = true
					local paramStr = str:sub(#command + 1)
					local codePrefix = paramStr:sub(1, 1)
					if codePrefix == "c" then
						if #paramStr == 1 then
							return -1
						end
						local num = tonumber(paramStr:sub(2))
						if num and math.floor(num) == num and num < 0 then
							gOrRParam = num
							uParam = "c"
							gOrRKeyWord = basicCommandTable[keyWord]
						end
					end
				else --[[
						"s ", "stage ", "sp ", "spawn ", "res ", "restart ", --[19-24]
						"gs ", "gridspawn ", "cha ", "challenge ", "cos ", "costumetest " --[25-30]
						"cur ", "curse ", "cut ", "cutscene ", "go ", "goto " --[31-36]
					]]--
					executeString = (basicCommandTable[keyWord] .. str:sub(#command + 1))
				end
				break
			end
		end
	end
	if isBasicCommand then
		if isLua then
			return executeString, true, true
		else
			if consoleInstructionPage ~= consoleInstructionPageTbl.DEATH then
				if isRepeat then
					if repeatNum ~= nil then
						if lastExecutedStrTable[1] ~= "" then
							if lastExecutedStrTable[1]:sub(1, 27) == [[Isaac.ExecuteCommand("debug]] then
								if repeatNum % 2 == 1 then
									local numStr, _ = lastExecutedStrTable[1]:sub(29, 30):gsub("\"$", "")
									local debugNum = tonumber(numStr)
									sanzhixiong.debugTable[debugNum][3] = not sanzhixiong.debugTable[debugNum][3]
								end
							end
							local toBeInsertedStr = lastExecutedStrTable[1]
							if toBeInsertedStr:sub(1, 22) == [[Isaac.ExecuteCommand("]] then
								toBeInsertedStr = toBeInsertedStr:sub(23, -3)
							else
								if toBeInsertedStr:sub(1, 33) == "IsaacSocket.System.ConsoleOutput(" then
									toBeInsertedStr = "output " .. toBeInsertedStr:sub(35, -5)
								else
									toBeInsertedStr = "lua " .. toBeInsertedStr
								end
							end
							table.insert(needDisplayStringTable, toBeInsertedStr .. "【执行" .. repeatNum .. "次】")
							if lastExecutedStrTable[2] then
								return "for _=1," .. repeatNum .. " do " .. lastExecutedStrTable[1] .. " end", false, true --executed immediately if IsaacSocket is on
							else
								return "for _=1," .. repeatNum .. " do " .. lastExecutedStrTable[1] .. " end", false
							end
						else
							return -1
						end
					else
						return -1
					end
				elseif isDebug then
					if debugNum ~= nil then
						if debugNum >= 1 and debugNum <= 14 then
							sanzhixiong.debugTable[debugNum][3] = not sanzhixiong.debugTable[debugNum][3]
						end
						return [[Isaac.ExecuteCommand("]] .. executeString .. [[")]], true
					else
						return -1
					end
				elseif isChangePlayer then
					if changePlayNum ~= nil then
						return [[Isaac.GetPlayer(0):ChangePlayerType(]] .. changePlayNum .. [[)]], true
					else
						return -1
					end
				elseif isBanItem then
					if banItemParam ~= nil then
						if banItemType then
							table.insert(toBeBannedItemIDList, banItemParam)
							return -1
						else
							table.insert(toBeBannedItemQualityList, banItemParam)
							return -1
						end
					else
						return str, false --Error information will be displayed to inform user that ban command did not take effect
					end
				elseif isGOrR then
					if gOrRParam ~= nil then --g or r or u error collectibles
						if gOrRKeyWord == "giveitem " then
							return [[Isaac.GetPlayer(0):AddCollectible(]] .. gOrRParam .. [[)]], true
						elseif gOrRKeyWord == "remove " then
							return [[Isaac.GetPlayer(0):RemoveCollectible(]] .. gOrRParam ..[[)]], true
						elseif gOrRKeyWord == "useitem " then
							return [[Isaac.GetPlayer(0):UseActiveItem(]] .. gOrRParam ..[[)]], true
						elseif gOrRKeyWord == "giveitem2 " then
							return [[Isaac.GetPlayer(1):AddCollectible(]] .. gOrRParam .. [[)]], true
						elseif gOrRKeyWord == "remove2 " then
							return [[Isaac.GetPlayer(1):RemoveCollectible(]] .. gOrRParam .. [[)]], true
						elseif gOrRKeyWord == "useitem2 " then
							return [[Isaac.GetPlayer(1):UseActiveItem(]] .. gOrRParam .. [[)]], true
						end
					else
						return [[Isaac.ExecuteCommand("]] .. str .. [[")]], true
					end
				else
					return [[Isaac.ExecuteCommand("]] .. executeString .. [[")]], true
				end
			end
		end
	else
		if consoleInstructionPage ~= consoleInstructionPageTbl.DEATH then
			return [[Isaac.ExecuteCommand("]] .. str .. [[")]], true
		end
	end
end

local function combiNewLineChar(text)
	local processedText = text:gsub("\r", "\n")
	processedText = processedText:gsub("^%s*\n+", "")
	processedText = processedText:gsub("\n+", "\n")
	return processedText
end

local function loadExecuteString(executeString)
	local isSuccess, result = pcall(function() return assert(load(executeString))() end)
	if not isSuccess then
		--cut the path information since it only shows the line index which contains "assert" 
		local startIndex, _ = string.find(result, "%[string")
		if startIndex ~= nil then
			result = string.sub(result, startIndex - 1)
		end
		feedbackString = ("Error: " .. result)
	end
end

local function paste(pasteText)
	-- clipboard is empty
	local pasteTextLength = #pasteText
	if pasteTextLength == 0 then
		return
	end
	-- combine pasteText and user string
	local restText = combiNewLineChar(pasteText)
	pasteTextLength = #restText
	if userCurString == [[]] or cursorIndex == #userCurString then
		restText = (userCurString .. restText)
	elseif cursorIndex == 0 then
		restText = (restText .. userCurString)
	else
		restText = (userCurString:sub(1, cursorIndex) .. restText .. userCurString:sub(cursorIndex + 1))
	end
	-- get toBeExecuteLine and restText
	local toBeExecuteLineTable = {}
	local index = 1
	while index ~= 0 do
		local char = restText:sub(index, index)
		if char == "\n" then
			local toBeExecuteLine = restText:sub(1, index - 1)
			table.insert(toBeExecuteLineTable, toBeExecuteLine)
			restText = restText:sub(index)
			if #restText == 1 then
				restText = ""
				index = 0
			else
				restText = restText:sub(2)
				pasteTextLength = #restText
				index = 1
			end
		else
			if index == #restText then
				index = 0
			else
				index = index + 1
			end
		end
	end
	if #toBeExecuteLineTable == 0 then --paste without '\n'
		--reset user current string and the cursor
		local pasteLengthStr, pastePinyinExcludeStr = getChinesePartStr(restText)
		userCurString = restText
		charLengthStr = pasteLengthStr
		pinyinExcludeStr = pastePinyinExcludeStr
		cursorIndex = cursorIndex + pasteTextLength
	else --paste with '\n'
		-- add toBeExecutedline to toBeLoadedExecuteStrList
		for _, toBeExecuteStr in ipairs(toBeExecuteLineTable) do
			local charLengthStr, pinyinExcludeStr = getChinesePartStr(toBeExecuteStr)
			displayUpdateMode = displayBoxInsertMode.USER_STR
			--update user string
			for i, str in ipairs(userStringList) do
				if str == toBeExecuteStr then
					table.remove(userStringList, i)
					table.remove(charLengthStrList, i)
					table.remove(pinyinExcludeStrList, i)
					break
				end
			end
			table.insert(userStringList, toBeExecuteStr)
			table.insert(charLengthStrList, charLengthStr)
			table.insert(pinyinExcludeStrList, pinyinExcludeStr)
			userLastString = toBeExecuteStr
			lastCharLengthStr = charLengthStr
			lastPinyinExcludeStr = pinyinExcludeStr
			userStringIndex = #userStringList
			--execute the command
			local executeString = [[]]
			local canExecuteStringRepeat = nil
			local searchKeyWord = updateSearchResultTable(toBeExecuteStr)
			local needExecuteNow = nil
			local executeNow = false
			local needDisplayStringTable = {}
			executeString, canExecuteStringRepeat, needExecuteNow = getExecuteString(toBeExecuteStr, searchKeyWord, needDisplayStringTable)
			if needExecuteNow and IsaacSocket ~= nil then
				executeNow = true
				loadExecuteString(executeString)
			end
			--update lastExecutedStrTable
			if canExecuteStringRepeat then
				lastExecutedStrTable[1] = executeString
				lastExecutedStrTable[2] = executeNow
			end
			-- executeString is integer -1 means skip the repeat part since it will not be correctly executed
			if executeString ~= -1 and not executeNow then
				table.insert(toBeLoadedExecuteStrList, executeString)
			end
			--update displayBox  
			updateDisplayBox(userLastString, displayUpdateMode)
			for _, str in ipairs(needDisplayStringTable) do
				updateDisplayBox(str, displayBoxInsertMode.PRINT_STR, true)
			end
			needDisplayStringTable = nil
			--save command history
			saveData()
		end
		--reset user current string and the cursor
		if restText == "" then
			userCurString = [[]]
			charLengthStr = ""
			pinyinExcludeStr = ""
			cursorIndex = 0
		else
			local pasteLengthStr, pastePinyinExcludeStr = getChinesePartStr(restText)
			userCurString = restText
			charLengthStr = pasteLengthStr
			pinyinExcludeStr = pastePinyinExcludeStr
			cursorIndex = pasteTextLength
		end
		--update displayBox position
		pageOffsetY = 0
	end
end

local function leftBackspace()
	if userCurString ~= [[]] then
		if cursorIndex ~= 0 then
			if cursorIndex == 1 then
				userCurString = userCurString:sub(cursorIndex + 1)
			elseif cursorIndex == #userCurString then
				userCurString = userCurString:sub(1, -2)
			else
				userCurString = (userCurString:sub(1, cursorIndex - 1) .. userCurString:sub(cursorIndex + 1))
			end
			cursorIndex = cursorIndex - 1
			--Chinese part
			local removeIdx = 0
			local sum = 0
			for i = 1, #charLengthStr do
				sum = sum + charLengthStr:sub(i, i)
				if sum == cursorIndex + 1 then
					removeIdx = i
					break
				end
			end
			local byteNum = tonumber(charLengthStr:sub(removeIdx, removeIdx))
			if cursorIndex == #userCurString then
				userCurString = userCurString:sub(1, -byteNum)
			else
				userCurString = (userCurString:sub(1, cursorIndex - byteNum + 1) .. userCurString:sub(cursorIndex + 1))
			end
			cursorIndex = cursorIndex - byteNum + 1
			charLengthStr = stringRemove(charLengthStr, removeIdx)
			pinyinExcludeStr = stringRemove(pinyinExcludeStr, removeIdx)
		end	
	end
end

local function rightDelete()
	if userCurString ~= [[]] then
		if cursorIndex == 0 then
			userCurString = userCurString:sub(2)
			--Chinese part
			local byteNum = tonumber(charLengthStr:sub(1, 1))
			userCurString = userCurString:sub(byteNum)
			charLengthStr = stringRemove(charLengthStr, 1)
			pinyinExcludeStr = stringRemove(pinyinExcludeStr, 1)
			--Chinese part end
		else
			--Chinese part
			local deleteIdx = 0
			local sum = 0
			for i = 1, #charLengthStr do
				sum = sum + charLengthStr:sub(i, i)
				if sum == cursorIndex then
					deleteIdx = i
					break
				end
			end
			--Chinese part end
			if cursorIndex == #userCurString then
				userCurString = userCurString:sub(1, -2)
				cursorIndex = cursorIndex - 1
				--Chinese part
				local byteNum = tonumber(charLengthStr:sub(deleteIdx, deleteIdx))
				userCurString = userCurString:sub(1, -byteNum)
				cursorIndex = cursorIndex - byteNum + 1
				charLengthStr = stringRemove(charLengthStr, deleteIdx)
				pinyinExcludeStr = stringRemove(pinyinExcludeStr, deleteIdx)
				--Chinese part end
			else
				userCurString = (userCurString:sub(1, cursorIndex) .. userCurString:sub(cursorIndex + 2))
				--Chinese part
				local byteNum = tonumber(charLengthStr:sub(deleteIdx + 1, deleteIdx + 1))
				userCurString = (userCurString:sub(1, cursorIndex) .. userCurString:sub(cursorIndex + byteNum))
				charLengthStr = stringRemove(charLengthStr, deleteIdx + 1)
				pinyinExcludeStr = stringRemove(pinyinExcludeStr, deleteIdx + 1)
				--Chinese part end
			end
		end
	end
end

local function leftMove()
	if cursorIndex ~= 0 then
		cursorIndex = cursorIndex - 1
		--Chinese part
		local moveIdx = 0
		local sum = 0
		for i = 1, #charLengthStr do
			sum = sum + charLengthStr:sub(i, i)
			if sum == cursorIndex + 1 then
				moveIdx = i
				break
			end
		end
		local byteNum = tonumber(charLengthStr:sub(moveIdx, moveIdx))
		cursorIndex = cursorIndex - byteNum + 1
		--Chinese part end
	end
end

local function rightMove()
	if cursorIndex < #userCurString then
		cursorIndex = cursorIndex + 1
		--Chinese part
		if cursorIndex == 1 then
			local byteNum = tonumber(charLengthStr:sub(1, 1))
			cursorIndex = cursorIndex + byteNum - 1
			return
		end
		local moveIdx = 0
		local sum = 0
		for i = 1, #charLengthStr do
			sum = sum + charLengthStr:sub(i, i)
			if sum == cursorIndex - 1 then
				moveIdx = i
				break
			end
		end
		local byteNum = tonumber(charLengthStr:sub(moveIdx + 1, moveIdx + 1))
		cursorIndex = cursorIndex + byteNum - 1
		--Chinese part end
	end
end

local function executeButtonPressed(mode, charWithoutShift, charWithShift, isShiftPressed)
	if continueDisplayCursorForQuarterSecond then
		if cursorFrame >= 15 then
			cursorFrame = 0
			continueDisplayCursorForQuarterSecond = false
		end
	end
	moveCursorFrame = moveCursorFrame + 1
	if moveCursorFrame > 20 then
		cursorFrame = 0
		if mode == 0 then
			charInput(charWithoutShift, charWithShift, isShiftPressed)
		elseif mode == 1 then
			leftBackspace()
		elseif mode == 2 then
			rightDelete()
		elseif mode == 3 then
			leftMove()
		elseif mode == 4 then
			rightMove()
		elseif mode == 5 then
			paste(charWithoutShift)
		end
	end
end

local function checkReleaseButton(lastMoveCursorFrame)
	if needCheckRelease then
		if lastMoveCursorFrame == moveCursorFrame then
			if continueDisplayCursorForQuarterSecond then
				continueDisplayCursorForQuarterSecond = false
			else
				if moveCursorFrame > 20 then
					cursorFrame = 0
				else
					cursorFrame = 15
				end
			end
			needCheckRelease = false
		end
	end
end

local function updateCharacterDisplayTable()
	if cursorIndex > 0 then
		local characterIdx = 0
		local sum = 0
		for i = 1, #charLengthStr do
			sum = sum + charLengthStr:sub(i, i)
			if sum == cursorIndex then
				characterIdx = i
				break
			end
		end
		local startIdx = nil
		local curCharacterIdx = characterIdx
		while startIdx == nil do	
			if charLengthStr:sub(curCharacterIdx, curCharacterIdx) == "1" and pinyinExcludeStr:sub(curCharacterIdx, curCharacterIdx) == "0" then
				if curCharacterIdx == 1 then
					startIdx = 1
				else
					curCharacterIdx = curCharacterIdx - 1
				end
			else
				startIdx = curCharacterIdx + 1
			end
		end
		if startIdx <= characterIdx then
			local diffIdx = characterIdx - startIdx
			local targetString = userCurString:sub(cursorIndex - diffIdx, cursorIndex)
			for key, values in pairs(chineseCharacterTable) do
				if key == targetString then
					characterDisplayTable = values
					pinyinLength = #targetString
					return
				end
			end
			characterDisplayTable = ""
			pinyinLength = 0
		else
			characterDisplayTable = ""
			pinyinLength = 0
		end
	else
		characterDisplayTable = ""
		pinyinLength = 0
	end
end

local function selectAChineseCharacter(key)
	if key == 32 then --[space]
		key = 49 --[num1]
	end
	local targetIndex = key - 48
	if targetIndex <= (#characterDisplayTable - 27 * curCharactersPage) / 3 then
		local startIndex = cursorIndex - pinyinLength
		local targetCharacter = characterDisplayTable:sub(3 * targetIndex + 27 * curCharactersPage - 2, 3 * targetIndex + 27 * curCharactersPage)
		if cursorIndex == #userCurString then
			userCurString = (userCurString:sub(1, - pinyinLength -1)) .. targetCharacter
		else
			userCurString = (userCurString:sub(1, cursorIndex - pinyinLength) .. targetCharacter .. userCurString:sub(cursorIndex+1))
		end
		cursorIndex = cursorIndex - pinyinLength + 3
		if cursorIndex == 3 then
			for i = 1, pinyinLength do
				charLengthStr = stringRemove(charLengthStr, 1)
				pinyinExcludeStr = stringRemove(pinyinExcludeStr, 1)
			end
			charLengthStr = stringInsert(charLengthStr, "3")
			pinyinExcludeStr = stringInsert(pinyinExcludeStr, "1")
			return true
		end
		local insertIdx = 0
		local sum = 0
		for i = 1, #charLengthStr do
			sum = sum + charLengthStr:sub(i, i)
			if sum == cursorIndex + pinyinLength - 3 then
				insertIdx = i
				break
			end
		end
		for i = 1, pinyinLength do
			charLengthStr = stringRemove(charLengthStr, insertIdx - pinyinLength + 1)
			pinyinExcludeStr = stringRemove(pinyinExcludeStr, insertIdx - pinyinLength + 1)
		end
		charLengthStr = stringInsert(charLengthStr, insertIdx - pinyinLength + 1, "3")
		pinyinExcludeStr = stringInsert(pinyinExcludeStr, insertIdx - pinyinLength + 1, "1")
		return true
	else
		return false
	end
end

local function getLineIndexByIdx(index, box)
	local restIdx = index
	for i, lineStr in ipairs(box) do
		local curLineNum = #lineStr
		if restIdx < curLineNum then
			return #box - i, lineStr:sub(1, restIdx)
		elseif i == #box then
			return 0, lineStr
		else
			restIdx = restIdx - curLineNum
		end
	end
end

local function displayPrintString()
	-- display print string in display box
	local displayPosY = consoleInstructionPos[2]
	local displayBoxLength = #displayBox
	if displayBoxLength > 0 then
		for i = displayBoxLength, 1, -1 do
			if i > displayBoxLength - maxFadedLineNum then
				local displayStr = displayBox[i][1]
				displayPosY = displayPosY - consoleInstructionPos[3]
				local colorMark = displayBox[i][2]
				if colorMark >= 3 and colorMark < 183 then
					-- display the print string
					local alphaValue = 0.5
					if colorMark >= 83 then
						alphaValue = alphaValue - (colorMark - 82) * 0.005
					end
					font:DrawStringScaledUTF8(displayStr, consoleInstructionPos[1], displayPosY + gameOverOffsetY, 1, 1, KColor(1, 1, 1, alphaValue), 0, false) -- white
				end
			end
		end
	end
end

local function displayUserString()
	--insert feedback string here rather than in updateDisplayBox() due to lag
	if feedbackString ~= [[]] then
		local insertEnd = false
		local remainStr = feedbackString
		while not insertEnd do
			if #remainStr <= minMaxCharNumInLine then
				table.insert(displayBox, {remainStr, 2})
				insertEnd = true
			else
				local nextLineStr = string.sub(remainStr, 1, minMaxCharNumInLine)
				remainStr = string.sub(remainStr, minMaxCharNumInLine + 1)
				local curWidth = font:GetStringWidthUTF8(nextLineStr)
				while curWidth < widthLimitInLine do
					nextLineStr = (nextLineStr .. string.sub(remainStr, 1, 1))
					if #remainStr == 1 then
						insertEnd = true
						break
					end
					remainStr = string.sub(remainStr, 2)
					curWidth = font:GetStringWidthUTF8(nextLineStr)
				end
				table.insert(displayBox, {nextLineStr, 2})
			end
		end
	end
	feedbackString = [[]]
	local remainStr = userCurString
	-- set temp box (current user string)
	local tempBox = {}
	local insertEnd = false
	while not insertEnd do
		if #remainStr <= minMaxCharNumInLine then
			table.insert(tempBox, remainStr)
			insertEnd = true
		else
			local nextLineStr = string.sub(remainStr, 1, minMaxCharNumInLine)
			remainStr = string.sub(remainStr, minMaxCharNumInLine + 1)
			local curWidth = font:GetStringWidthUTF8(nextLineStr)
			while curWidth < widthLimitInLine do
				nextLineStr = (nextLineStr .. string.sub(remainStr, 1, 1))
				if #remainStr == 1 then
					insertEnd = true
					break
				end
				remainStr = string.sub(remainStr, 2)
				curWidth = font:GetStringWidthUTF8(nextLineStr)
			end
			table.insert(tempBox, nextLineStr)
		end
	end
	if #tempBox == 0 then
		table.insert(tempBox, "")
	end
	--set cursor display variables
	local cursorNeedDisPlay = false
	cursorFrame = cursorFrame + 1
	if cursorFrame > 60 then
		cursorFrame = 1
	end
	local cursorDisplayPosX = 0
	local cursorDisplayPosY = 0
	if cursorFrame <= 15 or cursorFrame > 30 and cursorFrame <= 45 then
		local downCursorLineNum, beforeCursorStr = getLineIndexByIdx(cursorIndex, tempBox)
		local cursorDisplayOffsetX = font:GetStringWidthUTF8(beforeCursorStr)
		cursorDisplayPosX = consoleInstructionPos[1] + cursorDisplayOffsetX
		cursorDisplayPosY = consoleInstructionPos[2] - downCursorLineNum * consoleInstructionPos[3] - 1
		cursorNeedDisPlay = true
	end
	
	-- display temp box (current user string)
	local displayPosY = consoleInstructionPos[2] + consoleInstructionPos[3]
	for i = #tempBox, 1, -1 do
		local displayStr = tempBox[i]
		displayPosY = displayPosY - consoleInstructionPos[3]
		font:DrawStringScaledUTF8(displayStr, consoleInstructionPos[1], displayPosY+gameOverOffsetY, 1, 1, KColor(0.4, 1, 0.4, 1), 0, false) --soft green
	end
	-- display the display box
	if #displayBox > 0 then
		for i = #displayBox, 1, -1 do
			local displayStr = displayBox[i][1]
			displayPosY = displayPosY - consoleInstructionPos[3]
			-- hide the bottom text while page scroll
			if displayPosY + pageOffsetY <= consoleInstructionPos[2] - consoleInstructionPos[3] then
				local renderPosY = displayPosY + pageOffsetY + gameOverOffsetY
				if renderPosY > -20 then
					local colorMark = displayBox[i][2]
					if colorMark == 1 then
						-- display the executed string
						font:DrawStringScaledUTF8(displayStr, consoleInstructionPos[1], renderPosY, 1, 1, KColor(0.4, 0.4, 0.4, 1), 0, false) -- soft grey
					elseif colorMark == 2 then
						-- display the warning string
						font:DrawStringScaledUTF8(displayStr, consoleInstructionPos[1], renderPosY, 1, 1, KColor(1, 0.5, 0.5, 1), 0, false) -- soft red
					elseif colorMark >= 3 and colorMark <= 183 then
						-- display the print string
						font:DrawStringScaledUTF8(displayStr, consoleInstructionPos[1], renderPosY, 1, 1, KColor(1, 1, 1, 1), 0, false) -- white
					else
						print("something wrong: colorMark = " .. colorMark)
					end
				end
			end
		end
	end
	displayPosY = displayPosY - 1.2 * consoleInstructionPos[3]
	-- display the title
	--set the top boundary of page scroll
	if displayPosY + pageOffsetY > consoleInstructionPos[2] - 1.2 * consoleInstructionPos[3] then
		pageOffsetY = consoleInstructionPos[2] - 1.2 * consoleInstructionPos[3] - displayPosY
	end
	font:DrawStringScaledUTF8(consoleTitle, consoleInstructionPos[1], displayPosY + pageOffsetY + gameOverOffsetY, 1.2 * fontScaledTable[1], 1.2 * fontScaledTable[2], KColor(0.9, 0.9, 0.9, 1), 0, false) --soft white
	-- display the cursor
	if cursorNeedDisPlay then
		font:DrawStringScaledUTF8(cursorChar, cursorDisplayPosX, cursorDisplayPosY + gameOverOffsetY, 1, 1, KColor(0.4, 1, 0.4, 1), 0, false) --soft green
	end
end

local function executeQuickSearchResult(isLeftAltPressed, searchKeyWord)
	local quickSearchExecuteStr = [[]]
	if next(searchResultTable) ~= nil then
		if isLeftAltPressed then
			local tableLength = getTableLength(searchResultTable)
			local maxKeyNum = 49
			if tableLength >= 9 then
				maxKeyNum = 57
			else
				maxKeyNum = 48 + tableLength
			end
			local isAllExecute = false
			for key = 48, maxKeyNum do
				if Input.IsButtonTriggered(key, 0) then
					if key == 48 and not isAllExecute then
						isAllExecute = true
					end
					local selectNum = key - 48
					local executeMapList = {spawnTableOrderMap, stageTableOrderMap}
					local executeKeyWordList = {"spawn", "stage"}
					local curExecuteMap = nil
					local curExecuteKeyWord = ""
					local isInExecuteTable = false
					if searchKeyWord == -5 then
						curExecuteMap = executeMapList[1]
						curExecuteKeyWord = executeKeyWordList[1]
						isInExecuteTable = true
					elseif searchKeyWord == -13 then
						curExecuteMap = executeMapList[2]
						curExecuteKeyWord = executeKeyWordList[2]
						isInExecuteTable = true
					end
					if isInExecuteTable then
						for i, code in ipairs(curExecuteMap) do
							if searchResultTable[code] ~= nil then
								selectNum = selectNum - 1
								if isAllExecute or selectNum == 0 then
									quickSearchExecuteStr = [[Isaac.ExecuteCommand("]] .. curExecuteKeyWord .. [[ ]] .. code .. [[")]]
									if searchKeyWord == -13 then
										loadExecuteString(quickSearchExecuteStr)
									else
										table.insert(toBeLoadedExecuteStrList, quickSearchExecuteStr)
									end
									switchModeFadedTimer = 100
									switchModeFadedStr = "执行[#" .. key - 48 .. "]效果"
									if isIsaacSocketForcedPaused and searchKeyWord ~= -13 then
										switchModeFadedStr = "即将" .. switchModeFadedStr
									end
									if key == 48 then
										switchModeFadedStr = switchModeFadedStr .. "（全部执行）"
									end
								end
							end
						end
					else
						for i, code in ipairs(itemOrderMap) do
							local result = searchResultTable[code]
							if result == nil then
								code = code:upper()
								result = searchResultTable[code]
							end
							if result ~= nil then
								local itemType = code:sub(1, 1)
								local variant = ""
								if itemType == "c" then
									variant = "100"
								elseif itemType == "k" then
									variant = "300"
								elseif itemType == "t" or itemType == "T" then
									variant = "350"
								end
								local subType = code:sub(2)
								selectNum = selectNum - 1
								if isAllExecute or selectNum == 0 then
									if searchKeyWord == 21 or searchKeyWord == 22 then --spawn
										if itemType == "T" then
											subType = subType + 32768
										end
										quickSearchExecuteStr = [[Isaac.ExecuteCommand("spawn 5.]] .. variant .. [[.]] .. subType .. [[")]]
										table.insert(toBeLoadedExecuteStrList, quickSearchExecuteStr)
									elseif searchKeyWord >= 15 and searchKeyWord <= 18 then --useitem
										local playerId = 0
										if searchKeyWord == 17 or searchKeyWord == 18 then
											playerId = 1
										end
										if itemType == "c" then
											quickSearchExecuteStr = [[Isaac.GetPlayer(]] .. playerId .. [[):UseActiveItem(]] .. subType .. [[)]]
										elseif itemType == "k" then
											quickSearchExecuteStr = [[Isaac.GetPlayer(]] .. playerId .. [[):UseCard(]] .. subType .. [[)]]
										elseif itemType == "p" then
											quickSearchExecuteStr = [[Isaac.GetPlayer(]] .. playerId .. [[):UsePill(]] .. subType .. [[,30)]]
										elseif itemType == "P" then
											quickSearchExecuteStr = [[Isaac.GetPlayer(]] .. playerId .. [[):UsePill(]] .. subType .. [[,2070)]]
										elseif itemType == "b" then
											quickSearchExecuteStr = [[Isaac.GetPlayer(]] .. playerId .. [[):UsePoopSpell(]] .. subType .. [[)]]
										end
										table.insert(toBeLoadedExecuteStrList, quickSearchExecuteStr)
									else
										quickSearchExecuteStr = [[Isaac.ExecuteCommand("]] .. basicCommandList[searchKeyWord] .. itemType .. subType .. [[")]]
										if itemType == "k" then
											loadExecuteString(quickSearchExecuteStr)
										else
											table.insert(toBeLoadedExecuteStrList, quickSearchExecuteStr)
										end
									end
									switchModeFadedTimer = 100
									switchModeFadedStr = "执行[#" .. key - 48 .. "]效果"
									if isIsaacSocketForcedPaused then
										switchModeFadedStr = "即将" .. switchModeFadedStr
									end
									if key == 48 then
										switchModeFadedStr = switchModeFadedStr .. "（全部执行）"
									end
								end
							end
						end
					end
					return
				end
			end
		end
	end
end

local function showUltraSecretRoom()
	local level = game:GetLevel()
	local rooms = level:GetRooms()
	local roomGridIndexList = {}
	for i = 0, rooms.Size - 1 do
		local roomDescriptor = rooms:Get(i)
		local roomData = roomDescriptor.Data
		if roomData ~= nil then
			local roomType = roomData.Type
			if roomType == RoomType.ROOM_ULTRASECRET then
				table.insert(roomGridIndexList, roomDescriptor.SafeGridIndex)
			end
		end
	end
	for i = 0, 1 do
		for j = 1, #roomGridIndexList do
			level:GetRoomByIdx(roomGridIndexList[j], i).DisplayFlags = 5
		end
	end
	level:UpdateVisibility()
end

local function switchTestMode(mode)
	if mode ~= isTestMode then
		local playerNum = game:GetNumPlayers()
		local queueItemList = {{590, 5}, {260, 1}, {333, 1}, {416, 1}, {454, 1}, {458, 1}, {534, 1}, {633, 1}}
		if mode then
			local itemConfig = Isaac.GetItemConfig()
			for i = 0, playerNum - 1 do
				local player = Isaac.GetPlayer(i)
				if player:GetPlayerType() ~= PlayerType.PLAYER_THESOUL_B then
					--in repentance+ player:QueueItem() will cause the game crash
					--[[
					for i = 1, #queueItemList do
						local curItem = itemConfig:GetCollectible(queueItemList[i][1])
						for _ = 1, queueItemList[i][2] do
							player:QueueItem(curItem, _, true)
						end
					end
					player:FlushQueueItem()
					]]--
					for i = 1, #queueItemList do
						for _ = 1, queueItemList[i][2] do
							player:AddCollectible(queueItemList[i][1])
						end
					end
				end
				player:AddCoins(999)
				player:AddBombs(99)
				player:AddKeys(99)
			end
			game:GetLevel():RemoveCurses(255)
			showUltraSecretRoom()
		else
			for i = 0, playerNum - 1 do
				local player = Isaac.GetPlayer(i)
				if player:GetPlayerType() ~= PlayerType.PLAYER_THESOUL_B then
					for i = 1, #queueItemList do
						for _ = 1, queueItemList[i][2] do
							player:RemoveCollectible(queueItemList[i][1])
						end
					end
				end
			end
		end
		local dbList = {3, 6, 7, 8}
		for i = 1, #dbList do
			if sanzhixiong.debugTable[dbList[i]][3] == not mode then
				Isaac.ExecuteCommand("debug " .. dbList[i])
				sanzhixiong.debugTable[dbList[i]][3] = mode
			end
		end
		isTestMode = mode
		saveData()
	end
end

local function setItemQualityList()
	local itemConfig = Isaac.GetItemConfig()
	for itemIndex = 1, 10000 do
		local item = itemConfig:GetCollectible(itemIndex)
		if item ~= nil then
			table.insert(itemQualityList, item.Quality)
		else
			table.insert(itemQualityList, -1)
		end
	end
end

local function getQualityTextColor(n)
	if n == 1 or n == 2 or n == 3 or n == 4 or n == 5 or n == 6 or n == 7 or n == 8 then
		return qualityTextColorList[n][1], qualityTextColorList[n][2], qualityTextColorList[n][3]
	else
		return 1, 1, 1
	end
end

local function displayItemQualityAndItempool()
	if (functionMenu.itemQuality or functionMenu.itemPool) and (not game:IsPaused() or isIsaacSocketForcedPaused) then
		if Input.IsActionPressed(ButtonAction.ACTION_MAP, 0) then
			local hasChaos = false
			local playerNum = game:GetNumPlayers()
			for i = 0, playerNum - 1 do
				local player = Isaac.GetPlayer(i)
				if player:HasCollectible(CollectibleType.COLLECTIBLE_CHAOS, false) then
					hasChaos = true
					break
				end
			end
			local lastPool = game:GetItemPool():GetLastPool()
			local isChallengeAprilsFool = false
			local isBlindCurse = false
			if game.Challenge == Challenge.CHALLENGE_APRILS_FOOL then
				isChallengeAprilsFool = true
			elseif game:GetLevel():GetCurses() & LevelCurse.CURSE_OF_BLIND ~= 0 then
				isBlindCurse = true
			end
			local room = game:GetRoom()
			local isMirrored = room:IsMirrorWorld()
			local screenWidth = Isaac.GetScreenWidth()
			local level = game:GetLevel()
			local roomName = level:GetRoomByIdx(level:GetCurrentRoomIndex()).Data.Name	
			if functionMenu.itemQuality then
				local glitchedItemExist = false
				for _, entity in pairs(Isaac.GetRoomEntities()) do
					if (entity.Type == 5 and entity.Variant == 100) then
						local itemIndex = entity.SubType
						local pos = Isaac.WorldToScreen(entity.Position)
						local itemQuality = -1
						if (itemIndex > 0 and itemIndex <= 10000) then
							itemQuality = itemQualityList[itemIndex]
							local qualityTextStrTable = {"?级", itemQuality .. "级"}
							local toBeDisplayedText = ""
							local kColorR, kColorG, kColorB = 1, 1, 1
							if isChallengeAprilsFool then
								kColorR, kColorG, kColorB = getQualityTextColor(7)
								toBeDisplayedText = qualityTextStrTable[1]
							elseif roomName == "Death Certificate" then
								kColorR, kColorG, kColorB = getQualityTextColor(itemQuality + 1)
								toBeDisplayedText = qualityTextStrTable[2]
							elseif entity.Touched then
								kColorR, kColorG, kColorB = getQualityTextColor(itemQuality + 1)
								toBeDisplayedText = qualityTextStrTable[2]
							elseif isBlindCurse then
								kColorR, kColorG, kColorB = getQualityTextColor(7)
								toBeDisplayedText = qualityTextStrTable[1]
							elseif isAltChoice(entity) then
								kColorR, kColorG, kColorB = getQualityTextColor(7)
								toBeDisplayedText = qualityTextStrTable[1]
							else
								kColorR, kColorG, kColorB = getQualityTextColor(itemQuality + 1)
								toBeDisplayedText = qualityTextStrTable[2]
							end
							local finalPosX = 0
							if isMirrored then
								finalPosX = screenWidth - pos.X - font:GetStringWidthUTF8(toBeDisplayedText) / 2
							else
								finalPosX = pos.X - font:GetStringWidthUTF8(toBeDisplayedText) / 2
							end
							local finalPosY = pos.Y + qualityTextOffset
							font:DrawStringScaledUTF8(toBeDisplayedText, finalPosX, finalPosY, 1, 1, KColor(kColorR, kColorG, kColorB, 1), 0, false)
						elseif itemIndex > 10000 then
							glitchedItemExist = true
							local kColorR, kColorG, kColorB = getQualityTextColor(8)
							local toBeDisplayedText = tostring(itemIndex - 4294967296) .. "号"
							local finalPosX = 0
							if isMirrored then
								finalPosX = screenWidth - pos.X - font:GetStringWidthUTF8(toBeDisplayedText) / 2
							else
								finalPosX = pos.X - font:GetStringWidthUTF8(toBeDisplayedText) / 2
							end
							local finalPosY = pos.Y + qualityTextOffset
							font:DrawStringScaledUTF8(toBeDisplayedText, finalPosX - 2, finalPosY, 1, 1, KColor(kColorR, kColorG, kColorB, 1), 0, false)
						end
					end
				end
				if glitchedItemExist then
					font:DrawStringScaledUTF8("若有需求，可通过r c[id]去除错误道具和g c[id]获得错误道具(双子中的小红：r2 c[id]和g2 c[id])", 30, 255, 1, 1, KColor(1, 0.75, 0, 1), 0, false)
				end
			end
			if functionMenu.itemPool then
				if (functionMenu.itemPoolSetting.blindCurse or not isBlindCurse) and (functionMenu.itemPoolSetting.chaos or not hasChaos) then
					for _, entity in pairs(Isaac.GetRoomEntities()) do
						if (entity.Type == 5 and entity.Variant == 100 and entity.SubType > 0) then
							local pos = Isaac.WorldToScreen(entity.Position)
							itemPoolSprite:Play("Itempools")
							itemPoolSprite:SetLayerFrame(0, lastPool)
							if isMirrored then
								pos.X = screenWidth - pos.X
							end
							pos.Y = pos.Y + qualityTextOffset
							itemPoolSprite:Render(pos, Vector(0, 0), Vector(0, 0))
						end
					end
				end
			end
		end
	end
end

local function updateInstuctionText()
	if consoleInstructionPage ~= consoleInstructionPageTbl.DEATH then
		--update F7 instruction text
		if userCurString:sub(1, 4) == "ban " then
			if consoleInstructionPage ~= consoleInstructionPageTbl.BAN then
				consoleInstructionPage = consoleInstructionPageTbl.BAN
			end
			return
		else
			if consoleInstructionPage == consoleInstructionPageTbl.BAN then
				consoleInstructionPage = consoleInstructionPageTbl.HOME
			end
		end
		--update F8 instruction text
		if userCurString:sub(1, 13) == "原地换人 "then
			if consoleInstructionPage < consoleInstructionPageTbl.CHARACTER_1 or consoleInstructionPage > consoleInstructionPageTbl.CHARACTER_3 then
				consoleInstructionPage = consoleInstructionPageTbl.CHARACTER_1
			end
			return
		else
			if consoleInstructionPage >= consoleInstructionPageTbl.CHARACTER_1 and consoleInstructionPage <= consoleInstructionPageTbl.CHARACTER_3 then
				consoleInstructionPage = consoleInstructionPageTbl.HOME
			end
		end
		--update restart instruction text
		if userCurString:sub(1, 8) == "restart " or userCurString:sub(1, 4) == "res " then
			if consoleInstructionPage < consoleInstructionPageTbl.RESTART_1 or consoleInstructionPage > consoleInstructionPageTbl.RESTART_3 then
				consoleInstructionPage = consoleInstructionPageTbl.RESTART_1
			end
			return
		else
			if consoleInstructionPage >= consoleInstructionPageTbl.RESTART_1 and consoleInstructionPage <= consoleInstructionPageTbl.RESTART_3 then
				consoleInstructionPage = consoleInstructionPageTbl.PAGE_3
			end
		end
		--update stage instuction text
		if userCurString:sub(1, 6) == "stage " or userCurString:sub(1, 2) == "s " then
			if userCurString ~= "stage " and userCurString ~= "s " then
				if consoleInstructionPage ~= consoleInstructionPageTbl.SEARCHING then
					consoleInstructionPage = consoleInstructionPageTbl.SEARCHING
				end
				return
			elseif consoleInstructionPage ~= consoleInstructionPageTbl.STAGE then
				consoleInstructionPage = consoleInstructionPageTbl.STAGE
				return
			end
		else
			if consoleInstructionPage == consoleInstructionPageTbl.STAGE or consoleInstructionPage == consoleInstructionPageTbl.SEARCHING then
				consoleInstructionPage = consoleInstructionPageTbl.PAGE_2
			end
		end
		--update giveitem instuction text
		if userCurString:sub(1, 9) == "giveitem " or userCurString:sub(1, 2) == "g " or userCurString:sub(1, 10) == "giveitem2 " or userCurString:sub(1, 3) == "g2 " then
			if userCurString ~= "giveitem " and userCurString ~= "g " and userCurString ~= "giveitem2 " and userCurString ~= "g2 " then
				if consoleInstructionPage ~= consoleInstructionPageTbl.SEARCHING then
					consoleInstructionPage = consoleInstructionPageTbl.SEARCHING
				end
				return
			elseif consoleInstructionPage ~= consoleInstructionPageTbl.GIVEITEM then
				consoleInstructionPage = consoleInstructionPageTbl.GIVEITEM
				return
			end
		else
			if consoleInstructionPage == consoleInstructionPageTbl.GIVEITEM or consoleInstructionPage == consoleInstructionPageTbl.SEARCHING then
				consoleInstructionPage = consoleInstructionPageTbl.PAGE_2
			end
		end
		--update remove instuction text
		if userCurString:sub(1, 7) == "remove " or userCurString:sub(1, 2) == "r " or userCurString:sub(1, 8) == "remove2 " or userCurString:sub(1, 3) == "r2 " then
			if userCurString ~= "remove " and userCurString ~= "r " and userCurString ~= "remove2 " and userCurString ~= "r2 " then
				if consoleInstructionPage ~= consoleInstructionPageTbl.SEARCHING then
					consoleInstructionPage = consoleInstructionPageTbl.SEARCHING
				end
				return
			elseif consoleInstructionPage ~= consoleInstructionPageTbl.REMOVE then
				consoleInstructionPage = consoleInstructionPageTbl.REMOVE
				return
			end
		else
			if consoleInstructionPage == consoleInstructionPageTbl.REMOVE or consoleInstructionPage == consoleInstructionPageTbl.SEARCHING then
				consoleInstructionPage = consoleInstructionPageTbl.PAGE_2
			end
		end
		--useitem instuction text
		if userCurString:sub(1, 8) == "useitem " or userCurString:sub(1, 2) == "u " or userCurString:sub(1, 9) == "useitem2 " or userCurString:sub(1, 3) == "u2 " then
			if userCurString ~= "useitem " and userCurString ~= "u " and userCurString ~= "useitem2 " and userCurString ~= "u2 " then
				if consoleInstructionPage ~= consoleInstructionPageTbl.SEARCHING then
					consoleInstructionPage = consoleInstructionPageTbl.SEARCHING
				end
				return
			elseif consoleInstructionPage ~= consoleInstructionPageTbl.USEITEM then
				consoleInstructionPage = consoleInstructionPageTbl.USEITEM
				return
			end
		else
			if consoleInstructionPage == consoleInstructionPageTbl.SEARCHING or consoleInstructionPage == consoleInstructionPageTbl.USEITEM then
				consoleInstructionPage = consoleInstructionPageTbl.PAGE_2
			end
		end
		--update spawn instuction text
		if userCurString:sub(1, 6) == "spawn " or userCurString:sub(1, 3) == "sp " then
			if userCurString ~= "spawn " and userCurString ~= "sp " then
				if consoleInstructionPage ~= consoleInstructionPageTbl.SEARCHING then
					consoleInstructionPage = consoleInstructionPageTbl.SEARCHING
				end
				return
			elseif consoleInstructionPage ~= consoleInstructionPageTbl.SPAWN then
				consoleInstructionPage = consoleInstructionPageTbl.SPAWN
				return
			end
		else
			if consoleInstructionPage == consoleInstructionPageTbl.SPAWN or consoleInstructionPage == consoleInstructionPageTbl.SEARCHING then
				consoleInstructionPage = consoleInstructionPageTbl.PAGE_2
			end
		end
		--update debug instuction text
		if userCurString:sub(1, 6) == "debug " or userCurString:sub(1, 2) == "d " then
			if consoleInstructionPage < consoleInstructionPageTbl.DEBUG_1 or consoleInstructionPage > consoleInstructionPageTbl.DEBUG_2 then
				consoleInstructionPage = consoleInstructionPageTbl.DEBUG_1
			end
			return
		else
			if consoleInstructionPage >= consoleInstructionPageTbl.DEBUG_1 and consoleInstructionPage <= consoleInstructionPageTbl.DEBUG_2 then
				consoleInstructionPage = consoleInstructionPageTbl.PAGE_2
			end
		end
		--update repeat instuction text
		if userCurString:sub(1, 7) == "repeat " or userCurString:sub(1, 4) == "rep " then
			if consoleInstructionPage ~= consoleInstructionPageTbl.REPEAT then
				consoleInstructionPage = consoleInstructionPageTbl.REPEAT
			end
			return
		else
			if consoleInstructionPage == consoleInstructionPageTbl.REPEAT then
				consoleInstructionPage = consoleInstructionPageTbl.PAGE_2
			end
		end
		--update clear instuction text
		if userCurString:sub(1, 5) == "clear" or userCurString:sub(1, 2) == "cl" then
			if consoleInstructionPage ~= consoleInstructionPageTbl.CLEAR then
				consoleInstructionPage = consoleInstructionPageTbl.CLEAR
			end
			return
		else
			if consoleInstructionPage == consoleInstructionPageTbl.CLEAR then
				consoleInstructionPage = consoleInstructionPageTbl.PAGE_2
			end
		end
		--update challenge instruction text
		if userCurString:sub(1, 10) == "challenge " or userCurString:sub(1, 4) == "cha " then
			if consoleInstructionPage < consoleInstructionPageTbl.CHALLENGE_1 or consoleInstructionPage > consoleInstructionPageTbl.CHALLENGE_4 then
				consoleInstructionPage = consoleInstructionPageTbl.CHALLENGE_1
			end
			return
		else
			if consoleInstructionPage >= consoleInstructionPageTbl.CHALLENGE_1 and consoleInstructionPage <= consoleInstructionPageTbl.CHALLENGE_4 then
				consoleInstructionPage = consoleInstructionPageTbl.PAGE_3
			end
		end
		--update gridspawn instruction text
		if userCurString:sub(1, 10) == "gridspawn " or userCurString:sub(1, 3) == "gs " then
			if consoleInstructionPage < consoleInstructionPageTbl.GRIDSPAWN_1 or consoleInstructionPage > consoleInstructionPageTbl.GRIDSPAWN_2 then
				consoleInstructionPage = consoleInstructionPageTbl.GRIDSPAWN_1
			end
			return
		else
			if consoleInstructionPage >= consoleInstructionPageTbl.GRIDSPAWN_1 and consoleInstructionPage <= consoleInstructionPageTbl.GRIDSPAWN_2 then
				consoleInstructionPage = consoleInstructionPageTbl.PAGE_3
			end
		end
		--update costumetest instuction text
		if userCurString:sub(1, 12) == "costumetest " or userCurString:sub(1, 4) == "cos " then
			if consoleInstructionPage ~= consoleInstructionPageTbl.COSTUME then
				consoleInstructionPage = consoleInstructionPageTbl.COSTUME
			end
			return
		else
			if consoleInstructionPage == consoleInstructionPageTbl.COSTUME then
				consoleInstructionPage = consoleInstructionPageTbl.PAGE_3
			end
		end
		--update curse instruction text
		if userCurString:sub(1, 6) == "curse " or userCurString:sub(1, 4) == "cur " then
			if consoleInstructionPage < consoleInstructionPageTbl.CURSE_1 or consoleInstructionPage > consoleInstructionPageTbl.CURSE_2 then
				consoleInstructionPage = consoleInstructionPageTbl.CURSE_1
			end
			return
		else
			if consoleInstructionPage >= consoleInstructionPageTbl.CURSE_1 and consoleInstructionPage <= consoleInstructionPageTbl.CURSE_2 then
				consoleInstructionPage = consoleInstructionPageTbl.PAGE_3
			end
		end
		--update goto instuction text
		if userCurString:sub(1, 5) == "goto " or userCurString:sub(1, 3) == "go " then
			if consoleInstructionPage ~= consoleInstructionPageTbl.GOTO then
				consoleInstructionPage = consoleInstructionPageTbl.GOTO
			end
			return
		else
			if consoleInstructionPage == consoleInstructionPageTbl.GOTO then
				consoleInstructionPage = consoleInstructionPageTbl.PAGE_3
			end
		end
		--update rewind instuction text
		if userCurString:sub(1, 6) == "rewind" or userCurString:sub(1, 3) == "rew" then
			if consoleInstructionPage ~= consoleInstructionPageTbl.REWIND then
				consoleInstructionPage = consoleInstructionPageTbl.REWIND
			end
			return
		else
			if consoleInstructionPage == consoleInstructionPageTbl.REWIND then
				consoleInstructionPage = consoleInstructionPageTbl.PAGE_3
			end
		end
		--update cutscene instuction text
		if userCurString:sub(1, 9) == "cutscene " or userCurString:sub(1, 4) == "cut " then
			if consoleInstructionPage < consoleInstructionPageTbl.CUTSCENE_1 or consoleInstructionPage > consoleInstructionPageTbl.CUTSCENE_2 then
				consoleInstructionPage = consoleInstructionPageTbl.CUTSCENE_1
			end
			return
		else
			if consoleInstructionPage >= consoleInstructionPageTbl.CUTSCENE_1 and consoleInstructionPage <= consoleInstructionPageTbl.CUTSCENE_2 then
				consoleInstructionPage = consoleInstructionPageTbl.PAGE_3
			end
		end
		--update seed instruction text
		if userCurString:sub(1, 8) == "listseed" or userCurString:sub(1, 2) == "ls" then
			if consoleInstructionPage ~= consoleInstructionPageTbl.LISTSEED then
				consoleInstructionPage = consoleInstructionPageTbl.LISTSEED
			end
			return
		else
			if consoleInstructionPage == consoleInstructionPageTbl.LISTSEED then
				consoleInstructionPage = consoleInstructionPageTbl.PAGE_2
			end
		end
		if userCurString:sub(1, 11) == "deleteseed " or userCurString:sub(1, 3) == "ds " then
			if consoleInstructionPage ~= consoleInstructionPageTbl.DELETESEED then
				consoleInstructionPage = consoleInstructionPageTbl.DELETESEED
			end
			return
		else
			if consoleInstructionPage == consoleInstructionPageTbl.DELETESEED then
				consoleInstructionPage = consoleInstructionPageTbl.PAGE_2
			end
		end
		--for IsaacSocket
		if IsaacSocket ~= nil then
			--update eden instruction text
			if userCurString:sub(1, 5) == "eden " then
				if consoleInstructionPage ~= consoleInstructionPageTbl.EDEN then
					consoleInstructionPage = consoleInstructionPageTbl.EDEN
				end
				return
			else
				if consoleInstructionPage == consoleInstructionPageTbl.EDEN then
					consoleInstructionPage = consoleInstructionPageTbl.PAGE_4
				end
			end
			--update adc instruction text
			if userCurString == "adc" then
				if consoleInstructionPage ~= consoleInstructionPageTbl.ALLOCATE_DEBUG_CONSOLE then
					consoleInstructionPage = consoleInstructionPageTbl.ALLOCATE_DEBUG_CONSOLE
				end
				return
			else
				if consoleInstructionPage == consoleInstructionPageTbl.ALLOCATE_DEBUG_CONSOLE then
					consoleInstructionPage = consoleInstructionPageTbl.PAGE_6
				end
			end
			--update fdc instruction text
			if userCurString == "fdc" then
				if consoleInstructionPage ~= consoleInstructionPageTbl.FREE_DEBUG_CONSOLE then
					consoleInstructionPage = consoleInstructionPageTbl.FREE_DEBUG_CONSOLE
				end
				return
			else
				if consoleInstructionPage == consoleInstructionPageTbl.FREE_DEBUG_CONSOLE then
					consoleInstructionPage = consoleInstructionPageTbl.PAGE_6
				end
			end
			--update output instruction text
			if userCurString:sub(1, 7) == "output " then
				if consoleInstructionPage ~= consoleInstructionPageTbl.OUTPUT then
					consoleInstructionPage = consoleInstructionPageTbl.OUTPUT
				end
				return
			else
				if consoleInstructionPage == consoleInstructionPageTbl.OUTPUT then
					consoleInstructionPage = consoleInstructionPageTbl.PAGE_6
				end
			end
			--update unlock achievement text
			if userCurString:sub(1, 4) == "uac " then
				if consoleInstructionPage ~= consoleInstructionPageTbl.UNLOCK_ACHIEVEMENT then
					consoleInstructionPage = consoleInstructionPageTbl.UNLOCK_ACHIEVEMENT
				end
				return
			else
				if consoleInstructionPage == consoleInstructionPageTbl.UNLOCK_ACHIEVEMENT then
					consoleInstructionPage = consoleInstructionPageTbl.PAGE_4
				end
			end
			--update lock achievement text
			if userCurString:sub(1, 4) == "lac " then
				if consoleInstructionPage ~= consoleInstructionPageTbl.LOCK_ACHIEVEMENT then
					consoleInstructionPage = consoleInstructionPageTbl.LOCK_ACHIEVEMENT
				end
				return
			else
				if consoleInstructionPage == consoleInstructionPageTbl.LOCK_ACHIEVEMENT then
					consoleInstructionPage = consoleInstructionPageTbl.PAGE_4
				end
			end
			--update view achievement text
			if userCurString == "vac" then
				if consoleInstructionPage ~= consoleInstructionPageTbl.VIEW_ACHIEVEMENT then
					consoleInstructionPage = consoleInstructionPageTbl.VIEW_ACHIEVEMENT
				end
				return
			else
				if consoleInstructionPage == consoleInstructionPageTbl.VIEW_ACHIEVEMENT then
					consoleInstructionPage = consoleInstructionPageTbl.PAGE_4
				end
			end
			--update dnt instruction text
			if userCurString:sub(1, 4) == "dnt " then
				if consoleInstructionPage ~= consoleInstructionPageTbl.DONATION then
					consoleInstructionPage = consoleInstructionPageTbl.DONATION
				end
				return
			else
				if consoleInstructionPage == consoleInstructionPageTbl.DONATION then
					consoleInstructionPage = consoleInstructionPageTbl.PAGE_4
				end
			end
			--update gdnt instruction text
			if userCurString:sub(1, 5) == "gdnt " then
				if consoleInstructionPage ~= consoleInstructionPageTbl.GREED_DONATION then
					consoleInstructionPage = consoleInstructionPageTbl.GREED_DONATION
				end
				return
			else
				if consoleInstructionPage == consoleInstructionPageTbl.GREED_DONATION then
					consoleInstructionPage = consoleInstructionPageTbl.PAGE_4
				end
			end
			--update speed instruction text
			if userCurString:sub(1, 6) == "speed " then
				if consoleInstructionPage ~= consoleInstructionPageTbl.SPEED then
					consoleInstructionPage = consoleInstructionPageTbl.SPEED
				end
				return
			else
				if consoleInstructionPage == consoleInstructionPageTbl.SPEED then
					consoleInstructionPage = consoleInstructionPageTbl.PAGE_5
				end
			end
			--update display win streak instruction text
			if userCurString:sub(1, 3) == "vws" then
				if consoleInstructionPage ~= consoleInstructionPageTbl.DISPLAY_WIN_STREAK then
					consoleInstructionPage = consoleInstructionPageTbl.DISPLAY_WIN_STREAK
				end
				return
			else
				if consoleInstructionPage == consoleInstructionPageTbl.DISPLAY_WIN_STREAK then
					consoleInstructionPage = consoleInstructionPageTbl.PAGE_5
				end
			end
			--update set edens blessing instruction text
			if userCurString:sub(1, 4) == "seb " then
				if consoleInstructionPage ~= consoleInstructionPageTbl.SET_EDENS_BLESSING then
					consoleInstructionPage = consoleInstructionPageTbl.SET_EDENS_BLESSING
				end
				return
			else
				if consoleInstructionPage == consoleInstructionPageTbl.SET_EDENS_BLESSING then
					consoleInstructionPage = consoleInstructionPageTbl.PAGE_5
				end
			end
		end
	end
end

local function updateTag(item, tag)
	local itemType = item.Type
	if itemType == 1 then
		table.insert(tag, "passive")
	elseif itemType == 2 then
		table.insert(tag, "trinket")
	elseif itemType == 3 then
		table.insert(tag, "active")
	elseif itemType == 4 then
		table.insert(tag, "familiar")
	end
	if item.AddHearts ~= 0 then
		table.insert(tag, "hearts")
	end
	if item.AddCoins ~= 0 then
		table.insert(tag, "coins")
	end
	if item.AddBombs ~= 0 then
		table.insert(tag, "bombs")
	end
	if item.AddKeys ~= 0 then
		table.insert(tag, "keys")
	end
	if item.AddSoulHearts ~= 0 then
		table.insert(tag, "soulhearts")
	end
	if item.AddBlackHearts ~= 0 then
		table.insert(tag, "blackhearts")
	end
	if item.Special then
		table.insert(tag, "special")
	end
end

local function setItemTables()
	local itemConfig = Isaac.GetItemConfig()
	local insertIndexCollectible = 0
	local insertIndexTrinket = 0
	local insertIndexCard = 0
	local insertIndexPill = 0
	for j, item in ipairs(itemOrderMap) do
		if item == "c732" then
			insertIndexCollectible = j + 1
			break
		end
	end
	for i = 1, 4 do
		local startEndNumTable = {{10000, 733}, {2000, 190}, {1000, 98}, {500, 50}}
		for itemIndex = startEndNumTable[i][1], startEndNumTable[i][2], -1 do
			local item = nil
			if i == 1 then
				item = itemConfig:GetCollectible(itemIndex)
			elseif i == 2 then
				item = itemConfig:GetTrinket(itemIndex)
			elseif i == 3 then
				item = itemConfig:GetCard(itemIndex)
			elseif i == 4 then
				item = itemConfig:GetPillEffect(itemIndex)
			end
			if item ~= nil then
				local id = item.ID
				local code = ""
				if i == 1 then
					code = "c" .. id
				elseif i == 2 then
					code = "t" .. id
				elseif i == 3 then
					code = "k" .. id
				elseif i == 4 then
					code = "p" .. id
				end
				-- Compatible with EID
				local eidVariantMap = {
					[1]= 100,
					[2] = 350,
					[3]= 300,
					[4] = 70
				}
				local chName = nil
				if EID ~= nil then
					local nameList = EID.descriptions["zh_cn"].custom["5." .. eidVariantMap[i] .. "." .. id]
					if nameList ~= nil then
						chName = nameList[2]
					end
				end
				if i == 1 or i == 2 then
					collectibleOrTrinketTagsEnglishTable[code] = {}
					local attr = collectibleOrTrinketTagsEnglishTable[code]
					attr["name"] = item.Name
					if i == 1 then
						attr["quality"] = tostring(item.Quality)
						attr["devilprice"] = tostring(item.DevilPrice)
						if item.ShopPrice ~= 15 then
							attr["shopprice"] = tostring(item.ShopPrice)
						end
						if item.Type == 3 then
							attr["maxcharges"] = tostring(item.MaxCharges)
							if item.ChargeType == 1 then
								attr["chargetype"] = "timed"
							elseif item.ChargeType == 2 then
								attr["chargetype"] = "special"
							end
						end
					end
					attr["tag"] = {}
					local tag = attr["tag"]
					updateTag(item, tag)
					local attrTempTable = cloneTable(attr)
					if chName ~= nil then
						attrTempTable.name = chName
					end
					collectibleOrTrinketTagsChineseTable[code] = attrTempTable
					collectibleOrTrinketNickNameTable[code] = {}
				elseif i == 3 then
					cardTable[id] = {item.Name, item.Name}
					if chName ~= nil then
						cardTable[id][2] = chName
					end
				elseif i == 4 then
					pillTable[id] = {item.Name, item.Name}
					if chName ~= nil then
						pillTable[id][2] = chName
					end
				end
				if i == 1 then
					table.insert(itemOrderMap, insertIndexCollectible, code)
				elseif i == 2 then
					table.insert(itemOrderMap, insertIndexTrinket, code)
				elseif i == 3 then
					table.insert(itemOrderMap, insertIndexCard, code)
				elseif i == 4 then
					table.insert(itemOrderMap, insertIndexPill, code)
				end
			end
		end
		if i == 1 then
			for j, item in ipairs(itemOrderMap) do
				if item  == "t189" then
					insertIndexTrinket = j + 1
					break
				end
			end
		elseif i == 2 then
			for j, item in ipairs(itemOrderMap) do
				if item  == "k97" then
					insertIndexCard = j + 1
					break
				end
			end
		elseif i == 3 then
			for j, item in ipairs(itemOrderMap) do
				if item  == "p49" then
					insertIndexPill = j + 1
					break
				end
			end
		end
	end
end

local function optionMenuAdjustment()
	if consoleInstructionPage == consoleInstructionPageTbl.OPTION_MENU_HOME then --[F6] submenu
		--[F1] item quality display
		if Input.IsButtonTriggered(Keyboard.KEY_F1, 0) then
			functionMenu.itemQuality = not functionMenu.itemQuality
			switchModeFadedTimer = 100
			local displayStr = "长按[Tab]显示道具品级"
			if functionMenu.itemQuality then
				displayStr = displayStr .. "已开启"
			else
				displayStr = displayStr .. "已关闭"
			end
			switchModeFadedStr = displayStr
			saveData()
		end
		--[F2] debug text display
		if Input.IsButtonTriggered(Keyboard.KEY_F2, 0) then
			functionMenu.debugText = not functionMenu.debugText
			switchModeFadedTimer = 100
			local displayStr = "debug文字显示"
			if functionMenu.debugText then
				displayStr = displayStr .. "已开启"
			else
				displayStr = displayStr .. "已关闭"
			end
			switchModeFadedStr = displayStr
			saveData()
		end
		--[F3] item pool display
		if Input.IsButtonTriggered(Keyboard.KEY_F3, 0) then
			functionMenu.itemPool = not functionMenu.itemPool
			switchModeFadedTimer = 100
			local displayStr = "长按[Tab]显示道具池"
			if functionMenu.itemPool then
				displayStr = displayStr .. "已开启"
			else
				displayStr = displayStr .. "已关闭"
			end
			switchModeFadedStr = displayStr
			saveData()
		end
		--[F4] item pool submenu
		if Input.IsButtonTriggered(Keyboard.KEY_F4, 0) then
			consoleInstructionPage = consoleInstructionPageTbl.OPTION_MENU_F4
		end
		--[F5] console position adjustment submenu
		if Input.IsButtonTriggered(Keyboard.KEY_F5, 0) then
			consoleInstructionPage = consoleInstructionPageTbl.OPTION_MENU_F5
		end
		--[F6] FadedConsoleDisplay 
		if Input.IsButtonTriggered(Keyboard.KEY_F6, 0) then
			Options.FadedConsoleDisplay = not Options.FadedConsoleDisplay
			switchModeFadedTimer = 100
			local displayStr = "控制台打印文字淡出"
			if Options.FadedConsoleDisplay then
				displayStr = displayStr .. "已开启"
			else
				displayStr = displayStr .. "已关闭"
			end
			switchModeFadedStr = displayStr
		end
		--[F8] Reset to default (except for [F5])
		if Input.IsButtonTriggered(Keyboard.KEY_F8, 0) then
			functionMenu.itemQuality = true
			functionMenu.debugText = true
			functionMenu.itemPool = true
			functionMenu.itemPoolSetting.blindCurse = false
			functionMenu.itemPoolSetting.chaos = false
			switchModeFadedTimer = 100
			switchModeFadedStr = "[F1]到[F4]的所有设置已恢复默认"
			saveData()
		end
	elseif consoleInstructionPage == consoleInstructionPageTbl.OPTION_MENU_F4 then --[F6][F4] submenu
		--[F1] blind curse situation
		if Input.IsButtonTriggered(Keyboard.KEY_F1, 0) then
			functionMenu.itemPoolSetting.blindCurse = not functionMenu.itemPoolSetting.blindCurse
			switchModeFadedTimer = 100
			local displayStr = "致盲诅咒时仍显示道具池"
			if functionMenu.itemPoolSetting.blindCurse then
				displayStr = displayStr .. "已开启"
			else
				displayStr = displayStr .. "已关闭"
			end
			switchModeFadedStr = displayStr
			saveData()
		end
		--[F2] chaos situation
		if Input.IsButtonTriggered(Keyboard.KEY_F2, 0) then
			functionMenu.itemPoolSetting.chaos = not functionMenu.itemPoolSetting.chaos
			switchModeFadedTimer = 100
			local displayStr = "拥有混沌时仍显示道具池"
			if functionMenu.itemPoolSetting.chaos then
				displayStr = displayStr .. "已开启"
			else
				displayStr = displayStr .. "已关闭"
			end
			switchModeFadedStr = displayStr
			saveData()
		end
	elseif consoleInstructionPage == consoleInstructionPageTbl.OPTION_MENU_F5 then --[F6][F5] submenu
		--[F1] console positon adjustment
		if Input.IsButtonTriggered(Keyboard.KEY_F1, 0) then
			consoleInstructionPage = consoleInstructionPageTbl.OPTION_MENU_F5_CONSOLE
		end
		--[F2] keyboard overlay positon adjustment
		if Input.IsButtonTriggered(Keyboard.KEY_F2, 0) then
			consoleInstructionPage = consoleInstructionPageTbl.OPTION_MENU_F5_KEYBOARD
			originalStateTbl.keyboard = keyboardOverlayOn
			keyboardOverlayOn = true
		end
		--[F3] debug3 text positon adjustment
		if Input.IsButtonTriggered(Keyboard.KEY_F3, 0) then
			consoleInstructionPage = consoleInstructionPageTbl.OPTION_MENU_F5_DEBUG_3
		end
		--[F4] debug8 text positon adjustment
		if Input.IsButtonTriggered(Keyboard.KEY_F4, 0) then
			consoleInstructionPage = consoleInstructionPageTbl.OPTION_MENU_F5_DEBUG_8
		end
		--[F5] debug4&9 text positon adjustment
		if Input.IsButtonTriggered(Keyboard.KEY_F5, 0) then
			consoleInstructionPage = consoleInstructionPageTbl.OPTION_MENU_F5_DEBUG_4_AND_9
		end
		--[F8] Reset to default
		if Input.IsButtonTriggered(Keyboard.KEY_F8, 0) then
			componentOffsetTbl.consoleX = 72
			consoleInstructionPos[1] = componentOffsetTbl.consoleX
			componentOffsetTbl.consoleY = 195
			consoleInstructionPos[2] = componentOffsetTbl.consoleY
			componentOffsetTbl.keyboardX = 351
			keyboardPos.X = componentOffsetTbl.keyboardX
			componentOffsetTbl.keyboardY = 208
			keyboardPos.Y = componentOffsetTbl.keyboardY
			componentOffsetTbl.debug3X = 61
			sanzhixiong.debugTable[3][1] = componentOffsetTbl.debug3X
			componentOffsetTbl.debug3Y = 3
			sanzhixiong.debugTable[3][2] = componentOffsetTbl.debug3Y
			componentOffsetTbl.debug8X = 8
			sanzhixiong.debugTable[8][1] = componentOffsetTbl.debug8X
			componentOffsetTbl.debug8Y = 23
			sanzhixiong.debugTable[8][2] = componentOffsetTbl.debug8Y
			componentOffsetTbl.debug4X = 5
			sanzhixiong.debugTable[4][1] = componentOffsetTbl.debug4X
			componentOffsetTbl.debug4Y = 108
			sanzhixiong.debugTable[4][2] = componentOffsetTbl.debug4Y
			componentOffsetTbl.debug9X = 5
			sanzhixiong.debugTable[9][1] = componentOffsetTbl.debug9X
			componentOffsetTbl.debug9Y = 144
			sanzhixiong.debugTable[9][2] = componentOffsetTbl.debug9Y
			switchModeFadedTimer = 100
			switchModeFadedStr = "所有文字/图像位置已恢复默认"
			saveData()
		end
	elseif consoleInstructionPage == consoleInstructionPageTbl.OPTION_MENU_F5_CONSOLE then --[F6][F5][F1] submenu
		if Input.IsButtonTriggered(Keyboard.KEY_UP, 0) then
			componentOffsetTbl.consoleY = componentOffsetTbl.consoleY - 1
			consoleInstructionPos[2] = componentOffsetTbl.consoleY
			saveData()
		end
		if Input.IsButtonTriggered(Keyboard.KEY_DOWN, 0) then
			componentOffsetTbl.consoleY = componentOffsetTbl.consoleY + 1
			consoleInstructionPos[2] = componentOffsetTbl.consoleY
			saveData()
		end
		if Input.IsButtonTriggered(Keyboard.KEY_LEFT, 0) then
			componentOffsetTbl.consoleX = componentOffsetTbl.consoleX - 1
			consoleInstructionPos[1] = componentOffsetTbl.consoleX
			saveData()
		end
		if Input.IsButtonTriggered(Keyboard.KEY_RIGHT, 0) then
			componentOffsetTbl.consoleX = componentOffsetTbl.consoleX + 1
			consoleInstructionPos[1] = componentOffsetTbl.consoleX
			saveData()
		end
		if Input.IsButtonTriggered(Keyboard.KEY_F8, 0) then
			componentOffsetTbl.consoleX = 72
			consoleInstructionPos[1] = componentOffsetTbl.consoleX
			componentOffsetTbl.consoleY = 195
			consoleInstructionPos[2] = componentOffsetTbl.consoleY
			switchModeFadedTimer = 100
			switchModeFadedStr = "控制台主体位置已恢复默认"
			saveData()
		end
	elseif consoleInstructionPage == consoleInstructionPageTbl.OPTION_MENU_F5_KEYBOARD then --[F6][F5][F2] submenu
		if Input.IsButtonTriggered(Keyboard.KEY_UP, 0) then
			componentOffsetTbl.keyboardY = componentOffsetTbl.keyboardY - 1
			keyboardPos.Y = componentOffsetTbl.keyboardY
			saveData()
		end
		if Input.IsButtonTriggered(Keyboard.KEY_DOWN, 0) then
			componentOffsetTbl.keyboardY = componentOffsetTbl.keyboardY + 1
			keyboardPos.Y = componentOffsetTbl.keyboardY
			saveData()
		end
		if Input.IsButtonTriggered(Keyboard.KEY_LEFT, 0) then
			componentOffsetTbl.keyboardX = componentOffsetTbl.keyboardX - 1
			keyboardPos.X = componentOffsetTbl.keyboardX
			saveData()
		end
		if Input.IsButtonTriggered(Keyboard.KEY_RIGHT, 0) then
			componentOffsetTbl.keyboardX = componentOffsetTbl.keyboardX + 1
			keyboardPos.X = componentOffsetTbl.keyboardX
			saveData()
		end
		if Input.IsButtonTriggered(Keyboard.KEY_F8, 0) then
			componentOffsetTbl.keyboardX = 351
			keyboardPos.X = componentOffsetTbl.keyboardX
			componentOffsetTbl.keyboardY = 208
			keyboardPos.Y = componentOffsetTbl.keyboardY
			switchModeFadedTimer = 100
			switchModeFadedStr = "键盘映射位置已恢复默认"
			saveData()
		end
	elseif consoleInstructionPage == consoleInstructionPageTbl.OPTION_MENU_F5_DEBUG_3 then --[F6][F5][F3] submenu
		if Input.IsButtonTriggered(Keyboard.KEY_UP, 0) then
			componentOffsetTbl.debug3Y = componentOffsetTbl.debug3Y - 1
			sanzhixiong.debugTable[3][2] = componentOffsetTbl.debug3Y
			saveData()
		end
		if Input.IsButtonTriggered(Keyboard.KEY_DOWN, 0) then
			componentOffsetTbl.debug3Y = componentOffsetTbl.debug3Y + 1
			sanzhixiong.debugTable[3][2] = componentOffsetTbl.debug3Y
			saveData()
		end
		if Input.IsButtonTriggered(Keyboard.KEY_LEFT, 0) then
			componentOffsetTbl.debug3X = componentOffsetTbl.debug3X - 1
			sanzhixiong.debugTable[3][1] = componentOffsetTbl.debug3X
			saveData()
		end
		if Input.IsButtonTriggered(Keyboard.KEY_RIGHT, 0) then
			componentOffsetTbl.debug3X = componentOffsetTbl.debug3X + 1
			sanzhixiong.debugTable[3][1] = componentOffsetTbl.debug3X
			saveData()
		end
		if Input.IsButtonTriggered(Keyboard.KEY_F8, 0) then
			componentOffsetTbl.debug3X = 61
			sanzhixiong.debugTable[3][1] = componentOffsetTbl.debug3X
			componentOffsetTbl.debug3Y = 3
			sanzhixiong.debugTable[3][2] = componentOffsetTbl.debug3Y
			switchModeFadedTimer = 100
			switchModeFadedStr = "debug3文字位置已恢复默认"
			saveData()
		end
	elseif consoleInstructionPage == consoleInstructionPageTbl.OPTION_MENU_F5_DEBUG_8 then --[F6][F5][F4] submenu
		if Input.IsButtonTriggered(Keyboard.KEY_UP, 0) then
			componentOffsetTbl.debug8Y = componentOffsetTbl.debug8Y - 1
			sanzhixiong.debugTable[8][2] = componentOffsetTbl.debug8Y
			saveData()
		end
		if Input.IsButtonTriggered(Keyboard.KEY_DOWN, 0) then
			componentOffsetTbl.debug8Y = componentOffsetTbl.debug8Y + 1
			sanzhixiong.debugTable[8][2] = componentOffsetTbl.debug8Y
			saveData()
		end
		if Input.IsButtonTriggered(Keyboard.KEY_LEFT, 0) then
			componentOffsetTbl.debug8X = componentOffsetTbl.debug8X - 1
			sanzhixiong.debugTable[8][1] = componentOffsetTbl.debug8X
			saveData()
		end
		if Input.IsButtonTriggered(Keyboard.KEY_RIGHT, 0) then
			componentOffsetTbl.debug8X = componentOffsetTbl.debug8X + 1
			sanzhixiong.debugTable[8][1] = componentOffsetTbl.debug8X
			saveData()
		end
		if Input.IsButtonTriggered(Keyboard.KEY_F8, 0) then
			componentOffsetTbl.debug8X = 8
			sanzhixiong.debugTable[8][1] = componentOffsetTbl.debug8X
			componentOffsetTbl.debug8Y = 23
			sanzhixiong.debugTable[8][2] = componentOffsetTbl.debug8Y
			switchModeFadedTimer = 100
			switchModeFadedStr = "debug8文字位置已恢复默认"
			saveData()
		end
	elseif consoleInstructionPage == consoleInstructionPageTbl.OPTION_MENU_F5_DEBUG_4_AND_9 then --[F6][F5][F5] submenu
		if Input.IsButtonTriggered(Keyboard.KEY_UP, 0) then
			componentOffsetTbl.debug4Y = componentOffsetTbl.debug4Y - 1
			componentOffsetTbl.debug9Y = componentOffsetTbl.debug9Y - 1
			sanzhixiong.debugTable[4][2] = componentOffsetTbl.debug4Y
			sanzhixiong.debugTable[9][2] = componentOffsetTbl.debug9Y
			saveData()
		end
		if Input.IsButtonTriggered(Keyboard.KEY_DOWN, 0) then
			componentOffsetTbl.debug4Y = componentOffsetTbl.debug4Y + 1
			componentOffsetTbl.debug9Y = componentOffsetTbl.debug9Y + 1
			sanzhixiong.debugTable[4][2] = componentOffsetTbl.debug4Y
			sanzhixiong.debugTable[9][2] = componentOffsetTbl.debug9Y
			saveData()
		end
		if Input.IsButtonTriggered(Keyboard.KEY_LEFT, 0) then
			componentOffsetTbl.debug4X = componentOffsetTbl.debug4X - 1
			componentOffsetTbl.debug9X = componentOffsetTbl.debug9X - 1
			sanzhixiong.debugTable[4][1] = componentOffsetTbl.debug4X
			sanzhixiong.debugTable[9][1] = componentOffsetTbl.debug9X
			saveData()
		end
		if Input.IsButtonTriggered(Keyboard.KEY_RIGHT, 0) then
			componentOffsetTbl.debug4X = componentOffsetTbl.debug4X + 1
			componentOffsetTbl.debug9X = componentOffsetTbl.debug9X + 1
			sanzhixiong.debugTable[4][1] = componentOffsetTbl.debug4X
			sanzhixiong.debugTable[9][1] = componentOffsetTbl.debug9X
			saveData()
		end
		if Input.IsButtonTriggered(Keyboard.KEY_F8, 0) then
			componentOffsetTbl.debug4X = 5
			sanzhixiong.debugTable[4][1] = componentOffsetTbl.debug4X
			componentOffsetTbl.debug4Y = 108
			sanzhixiong.debugTable[4][2] = componentOffsetTbl.debug4Y
			componentOffsetTbl.debug9X = 5
			sanzhixiong.debugTable[9][1] = componentOffsetTbl.debug9X
			componentOffsetTbl.debug9Y = 144
			sanzhixiong.debugTable[9][2] = componentOffsetTbl.debug9Y
			switchModeFadedTimer = 100
			switchModeFadedStr = "debug4&9文字位置已恢复默认"
			saveData()
		end
	end
end

local function onGameStart(_, IsContinued)
	if IsContinued == false then
		canUpdateModItemChineseName = false	
		selectedOption = 1
		local tempSeedTbl = {}
		tempSeedTbl.seedStr = Seeds.Seed2String(game:GetSeeds():GetStartSeed())
		tempSeedTbl.mode = game.Difficulty
		tempSeedTbl.challenge = game.Challenge
		local player = game:GetPlayer(0)
		local playerType = player:GetPlayerType()
		if playerType <= 40 then
			tempSeedTbl.player = playerType
		else
			tempSeedTbl.player = player:GetName() .. "(" .. playerType .. ")"
		end
		table.insert(seedList, tempSeedTbl)
		local seedNum = #seedList
		if seedNum > 100 then
			for i = 1, seedNum - 100 do
				table.remove(seedList, 1)
			end
		end
		if seedNum > 500 then
			print("由于三只熊中文控制台先前会记录每局游戏的种子并且无上限，因此积攒了上千局游戏的种子后，可能每局游戏开始会出现明显卡顿。但是当你看到这条打印文字时，说明问题已经修复，现在最多存储最近的100局种子！祝你游戏愉快~ by三只熊")
		end
	else
		isConsoleReady = true
	end
	isGreed = game:IsGreedMode()
	gameStartFrame = 1
	updateBlindMode = true
	for key, value in pairs(sanzhixiong.debugTable) do
		if key == 10 then
			value[1] = 0
			value[2] = 0
		end
		value[3] = false
	end
	spriteKeyboard.Scale = Vector(keyboardScale, keyboardScale)
	canBeInGameLuamod = false
	--for IsaacSocket
	if IsaacSocket ~= nil then
		isaacSocketCountTable.edenTokenNum = IsaacSocket.IsaacAPI.GetEdenTokens()
	end
end

local function onGameExit(_)
	isConsoleReady = false
	updateBlindMode = false
	local isBlindChallenge = false
	local challenge = game.Challenge
	for _, v in ipairs(blindChallengeList) do
		if challenge == v then
			isBlindChallenge = true
			break
		end
	end
	local playerNum = game:GetNumPlayers()
	for i = 0, playerNum - 1 do
		local player = Isaac.GetPlayer(i)
		if isBlindChallenge then
			if player:GetPlayerType() ~= PlayerType.PLAYER_THESOUL_B then
				if player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN_B then
					player:AddNullCostume(NullItemID.ID_FORGOTTEN_B)
				else
					player:AddNullCostume(NullItemID.ID_BLINDFOLD)
				end
			end
		elseif player:GetPlayerType() ~= PlayerType.PLAYER_LILITH then
			player:TryRemoveNullCostume(NullItemID.ID_BLINDFOLD)
		end
	end
end

local function onNewLevel(_)
	if isConsoleReady then
		if isTestMode then
			showUltraSecretRoom()
		end
	end
end

local function onPlayerUpdate(_, player)
	if updateBlindMode then
		if gameStartFrame == 1 then
			if player:GetPlayerType() == PlayerType.PLAYER_LILITH then
				sanzhixiong.isBlindMode = false
			else
				local canShoot = player:CanShoot()
				if canShoot then
					sanzhixiong.isBlindMode = false
				else
					sanzhixiong.isBlindMode = true
				end
			end
		elseif gameStartFrame == 0 then
			if not consoleBanned then
				local canShoot = player:CanShoot()
				local oldChallenge = Isaac.GetChallenge()
				if sanzhixiong.canFrameUpdateBlindState then 
					if sanzhixiong.isBlindMode == canShoot and player:GetPlayerType() ~= PlayerType.PLAYER_LILITH then
						game.Challenge = canShoot and 6 or 0
						player:UpdateCanShoot()
						if canShoot then
							local weap = player:GetActiveWeaponEntity()
							if weap then 
								weap:Remove()
							end
							if player:GetPlayerType() ~= PlayerType.PLAYER_THESOUL_B then
								if player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN_B then
									player:AddNullCostume(NullItemID.ID_FORGOTTEN_B)
								else
									player:AddNullCostume(NullItemID.ID_BLINDFOLD)
								end
							end
						else
							player:TryRemoveNullCostume(NullItemID.ID_BLINDFOLD)
						end
						game.Challenge = oldChallenge
					end
				else
					sanzhixiong.isBlindMode = not player:CanShoot()
				end
				if sanzhixiong.isBlindMode then
					instructionTextTable.instructionDefault[1] = "[F1]紧急后悔            [F2]一键吞饰品           [F3]解除蒙眼"
				else
					instructionTextTable.instructionDefault[1] = "[F1]紧急后悔            [F2]一键吞饰品           [F3]强制蒙眼"
				end
			end
		end
		if gameStartFrame > 0 then
			gameStartFrame = gameStartFrame - 1
		end
	end
end

local function onGameEnd(_, isGameOver)
	if isGameOver then
		consoleInstructionPage = consoleInstructionPageTbl.DEATH
		gameOverOffsetY = -60
	end
end

local function onUpdate(_)
	-- init for in-game luamod
	if canBeInGameLuamod == nil then
		canUpdateModItemChineseName = false	
		--init option variables
		selectedOption = 1
		--init console variables
		isGreed = game:IsGreedMode()
		gameStartFrame = 1
		updateBlindMode = true
		spriteKeyboard.Scale = Vector(keyboardScale, keyboardScale)
	end
	--init option result
	if selectedOption == 0 then
		letPlayerControl = false
	elseif selectedOption > 0 then
		letPlayerControl = true
		selectedOption = -selectedOption
		if selectedOption == -1 then
			--init tables
			itemOrderMap = cloneTable(require('./constants/itemOrderMap'))
			collectibleOrTrinketTagsEnglishTable = cloneTable(require('./constants/collectibleOrTrinketTagsEnglishTable'))
			collectibleOrTrinketTagsChineseTable = cloneTable(require('./constants/collectibleOrTrinketTagsChineseTable'))
			collectibleOrTrinketNickNameTable = cloneTable(require('./constants/collectibleOrTrinketNickNameTable'))
			cardTable = cloneTable(require('./constants/cardTable'))
			pillTable = cloneTable(require('./constants/pillTable'))
			--init console variables
			consoleBanned = false
			sanzhixiong.consoleOn = false
			chineseModeOn = false
			lastFrameGamePaused = false
			consoleIsOnWhileGamePaused = false
			canConsoleRestart = true
			consoleInstructionPage = consoleInstructionPageTbl.HOME
			switchModeFadedTimer = 0
			--init keyboardOverlay variables
			keyboardOverlayOn = false
			originalStateTbl.keyboard = keyboardOverlayOn
			--init user string
			feedbackString = [[]]
			userCurString = [[]]
			--init display box variables
			displayUpdateMode = displayBoxInsertMode.USER_STR
			--init cursor variables
			cursorFrame = 0
			cursorIndex = 0
			moveCursorFrame = 0
			notCountGraveAccent = 0
			pausedFrame = 0
			continueDisplayCursorForQuarterSecond = false
			needCheckRelease = false
			--init page variables
			pageOffsetY = 0
			--init mode variables
			isTestMode = false
			functionMenu.itemQuality = true
			functionMenu.debugText = true
			functionMenu.itemPool = true
			functionMenu.itemPoolSetting.blindCurse = false
			functionMenu.itemPoolSetting.chaos = false
			itemQualityList = {}
			setItemQualityList()
			setItemTables()
			canUpdateModItemChineseName = true
			--init game over variables
			gameOverOffsetY = 0
			--init logic action variables from render
			isConsoleReady = true
			needEmergencyBack = false
			needSwitchTestMode = nil
			needSwallowTrinket = false
			toBeLoadedExecuteStrList = {}
			toBeBannedItemIDList = {}
			toBeBannedItemQualityList = {}
			needAnimate = {false, false}
			sanzhixiong.canFrameUpdateBlindState = false
			--init chinese mode variables
			characterDisplayTable = ""
			curCharactersPage = 0
			charLengthStr = ""
			pinyinExcludeStr = ""
			pinyinLength = 0
			--init search variables
			searchResultTable = {}
			searchPage = 0
			lastSearchStrInPage = ""
			lastSearchKeyWord = nil
			--load command history
			if mod:HasData() then
				local jsonTable = json.decode(mod:LoadData())
				if jsonTable.commandStrings ~= nil then
					userStringList = jsonTable.commandStrings
					userStringIndex = #userStringList
					if userStringIndex == 0 then
						userStringIndex = nil
						userLastString = [[]]
					else
						userLastString = userStringList[userStringIndex]
					end
				end
				if jsonTable.characterLengthStrings ~= nil then
					charLengthStrList = jsonTable.characterLengthStrings
					if #charLengthStrList == 0 then
						lastCharLengthStr = ""
					else
						lastCharLengthStr = charLengthStrList[#charLengthStrList]
					end
				end
				if jsonTable.pinyinExcludeStrings ~= nil then
					pinyinExcludeStrList = jsonTable.pinyinExcludeStrings
					if #pinyinExcludeStrList == 0 then
						lastPinyinExcludeStr = ""
					else
						lastPinyinExcludeStr = pinyinExcludeStrList[#pinyinExcludeStrList]
					end
				end
				if jsonTable.F4 ~= nil then
					keyboardOverlayOn = jsonTable.F4
					originalStateTbl.keyboard = keyboardOverlayOn
				end
				if canBeInGameLuamod == nil then
					if jsonTable.F5 ~= nil then
						isTestMode = jsonTable.F5
					end
				end
				if jsonTable.F6 ~= nil then
					if type(jsonTable.F6) == "table" and type(jsonTable.F6.itemPoolSetting) == "table" then
						functionMenu = jsonTable.F6
					end
				end
			end
			saveData()
		end
	end
	if canBeInGameLuamod == nil then
		canBeInGameLuamod = false
	end
	--execute logic action
	--update player control
	updatePlayerControlState(letPlayerControl)
	--execute emergency using c422
	if needEmergencyBack then
		Isaac.GetPlayer(0):UseActiveItem(422,true,true,true,false)
		needEmergencyBack = false
	end
	--switch test mode
	if needSwitchTestMode ~= nil then
		switchTestMode(needSwitchTestMode)
		needSwitchTestMode = nil
	end
	--execute command from player input
	if #toBeLoadedExecuteStrList > 0 then
		while #toBeLoadedExecuteStrList ~= 0 do
			loadExecuteString(toBeLoadedExecuteStrList[1])
			table.remove(toBeLoadedExecuteStrList, 1)
		end
	end
	--ban single item by ID
	local toBeBannedItemIDNum = #toBeBannedItemIDList
	if toBeBannedItemIDNum > 0 then
		local itemPool = game:GetItemPool()
		for i = 1, toBeBannedItemIDNum do
			itemPool:RemoveCollectible(toBeBannedItemIDList[i])
		end
		table.remove(toBeBannedItemIDList, 1, toBeBannedItemIDNum)
	end
	--ban all items with specific quality
	local toBeBannedItemQualityNum = #toBeBannedItemQualityList
	if toBeBannedItemQualityNum > 0 then
		local itemPool = game:GetItemPool()
		for i = 1, toBeBannedItemQualityNum do
			for itemID = 1,#itemQualityList do
				if (itemQualityList[itemID] == toBeBannedItemQualityList[i]) then
					itemPool:RemoveCollectible(itemID)
				end
			end
		end
		table.remove(toBeBannedItemQualityList, 1, toBeBannedItemQualityNum)
	end
	--swallow the trinket
	if needSwallowTrinket then
		Isaac.GetPlayer(0):UseActiveItem(479)
		local player2 = Isaac.GetPlayer(1)
		if player2 ~= nil then
			player2:UseActiveItem(479)
		end
		needSwallowTrinket = false
	end
	--animate happy or sad
	for i = 1, #needAnimate do
		if needAnimate[i] then
			executeAnimation(i)
			needAnimate[i] = false
		end
	end
	--update mod items Chinese names
	if canUpdateModItemChineseName then
		if #needAddChineseNameList ~= 0 then
			for i = #needAddChineseNameList, 1, -1 do
				local itemInfoTable = needAddChineseNameList[i]
				if #itemInfoTable[1] >= 2 then
					local firstLetter = itemInfoTable[1]:sub(1, 1)
					local restId = itemInfoTable[1]:sub(2)
					if firstLetter == "c" or firstLetter == "t" then
						for code, attr in pairs(collectibleOrTrinketTagsEnglishTable) do
							if code == itemInfoTable[1] then
								collectibleOrTrinketTagsChineseTable[code]["name"] = itemInfoTable[2]
								break
							end
						end
					elseif firstLetter == "k" then
						for id, namePair in pairs(cardTable) do
							if tostring(id) == restId then
								namePair[2] = itemInfoTable[2]
								break
							end
						end
					elseif firstLetter == "p" then
						for id, namePair in pairs(pillTable) do
							if tostring(id) == restId then
								namePair[2] = itemInfoTable[2]
								break
							end
						end
					end
				end
				table.remove(needAddChineseNameList, i)
			end
		end
	end
end

local function onRender(_)
	--sanzhixiong console mode turned on
	if not consoleBanned then
		renderTimer = renderTimer + 1
		if renderTimer == 3600 then
			renderTimer = 0
		end
		if IsaacSocket ~= nil then
			-- update force paused variables
			isIsaacSocketForcedPaused = IsaacSocket.IsaacAPI.IsForcePaused()
			if sanzhixiong.consoleOn then
				if isIsaacSocketForcedPaused == false then
					IsaacSocket.IsaacAPI.ForcePause(true)
					isIsaacSocketForcedPaused = true
				end
			else
				if isIsaacSocketForcedPaused == true then
					IsaacSocket.IsaacAPI.ForcePause(false)
					isIsaacSocketForcedPaused = false
				end
			end
			--copy the text in the original console(ctrl+c)
			if IsaacSocket.IsaacAPI.IsConsoleOpen() then
				local isCtrlPressed = Input.IsButtonPressed(Keyboard.KEY_LEFT_CONTROL, 0)
				for key, value in pairs(keyboardCharTable) do
					if Input.IsButtonTriggered(key, 0) then
						if isCtrlPressed and key == 67 then --ctrl+c copy
							switchModeFadedTimer = 100
							IsaacSocket.System.SetClipboard(IsaacSocket.IsaacAPI.GetConsoleInput())
							switchModeFadedStr = "复制成功"
							break
						end
					end
				end
			end
			--reset target game speed
			if Input.IsButtonTriggered(Keyboard.KEY_INSERT, 0) then
				if isaacSocketCountTable.gameSpeed ~= "1.00" then
					IsaacSocket.IsaacAPI.SetFrameInterval(1 / 60)
					isaacSocketCountTable.gameSpeed = string.format("%.2f" , 1 / IsaacSocket.IsaacAPI.GetFrameInterval() / 60)
					switchModeFadedTimer = 100
					switchModeFadedStr = "目标游戏速度已重置为1.00"
				end
			end
			--update donationNum, greedDonationNum and target game speed
			if renderTimer % 60 == 0 then
				isaacSocketCountTable.donationNum = IsaacSocket.IsaacAPI.GetDonationCount()
				isaacSocketCountTable.greedDonationNum = IsaacSocket.IsaacAPI.GetGreedDonationCount()
				isaacSocketCountTable.gameSpeed = string.format("%.2f" , 1 / IsaacSocket.IsaacAPI.GetFrameInterval() / 60)
				local imageBase = IsaacSocket.Memory.GetImageBase()
				local managerOffset = 0x7FD680
				local edensBlessingOffset = 0x494
				local edensBlessingAddress = IsaacSocket.Memory.CalcAddress(imageBase + managerOffset, edensBlessingOffset)
				isaacSocketCountTable.edensBlessing = IsaacSocket.Memory.ReadUInt32(edensBlessingAddress)
				if isaacSocketCountTable.gameSpeed == "1.00" then
					shouldDisplayFPS = false
				else
					shouldDisplayFPS = true
				end
			end
			--update current FPS and display current game speed text
			if shouldDisplayFPS then
				local fpsText = "游戏速度:" .. string.format("%.2f", IsaacSocket.IsaacAPI.GetFPS() / 60)
				font:DrawStringScaledUTF8(fpsText, Isaac.GetScreenWidth() - 0.5 * font:GetStringWidthUTF8(fpsText), 5, 0.5, 0.5, KColor(1, 0.75, 0, 1), 0, false)
			end
		else
			isIsaacSocketForcedPaused = nil
		end
		--limit on the number of print strings in display box
		updateDisplayBox(nil, displayBoxInsertMode.REMOVE_PRINT)
		--switch official console state
		local stopConsoleButton = false
		if Input.IsButtonPressed(Keyboard.KEY_LEFT_ALT, 0) and Input.IsButtonTriggered(Keyboard.KEY_GRAVE_ACCENT, 0) then
			Options.DebugConsoleEnabled = not Options.DebugConsoleEnabled
			saveData()
			stopConsoleButton = true
			if IsaacSocket ~= nil and IsaacSocket.IsaacAPI.IsPauseMenuForceHidden() then
				IsaacSocket.IsaacAPI.ForceHidePauseMenu(false)
			end
			sanzhixiong.consoleOn = false
			switchModeFadedTimer = 100
			local displayStr = "已切换至"
			if Options.DebugConsoleEnabled then
				displayStr = displayStr .. "以撒官方控制台"
			else
				displayStr = displayStr .. "三只熊中文控制台"
			end
			switchModeFadedStr = displayStr
			letPlayerControl = true
		end
		if switchModeFadedTimer > 0 then
			displaySwitchModeFadedStr(switchModeFadedStr)
		end
		--set keyboard overlay
		if keyboardOverlayOn then
			displayKeyboard()
		end
		--debug text display
		displayDebugText()
		--display item quality and item pool
		displayItemQualityAndItempool()
		--set the variables whether console should be displayed when game paused
		if Input.IsButtonTriggered(Keyboard.KEY_ESCAPE, 0) then
			if lastFrameGamePaused then
				if consoleIsOnWhileGamePaused then
					canConsoleRestart = false
				end
			end
			if IsaacSocket ~= nil and IsaacSocket.IsaacAPI.IsPauseMenuForceHidden() then
				IsaacSocket.IsaacAPI.ForceHidePauseMenu(false)
			end
			sanzhixiong.consoleOn = false
		end
		if Input.IsButtonTriggered(Keyboard.KEY_ENTER, 0) or Input.IsButtonTriggered(Keyboard.KEY_KP_ENTER, 0) then
			if userCurString == [[]] then
				canConsoleRestart = false
			end
		end
		-- display print function in szx chinese console
		local toBeAddedPrintStrTableLength = #toBeAddedPrintStrTable
		if toBeAddedPrintStrTableLength ~= 0 then
			local shouldFaded = true
			if Options.DebugConsoleEnabled or (not game:IsPaused() or consoleInstructionPage == consoleInstructionPageTbl.DEATH or canConsoleRestart) and (sanzhixiong.consoleOn or consoleIsOnWhileGamePaused) then --displayUserString() rendered
				shouldFaded = false
			end
			for i = 1, toBeAddedPrintStrTableLength do
				updateDisplayBox(toBeAddedPrintStrTable[i], displayBoxInsertMode.PRINT_STR, shouldFaded)
			end
			for i = 1, toBeAddedPrintStrTableLength do
				table.remove(toBeAddedPrintStrTable, 1)
			end
		end
		--Only when game is not paused or on death page, user is able to use the console
		--for IsaacSocket
		local canStartConsoleInMenu = false
		if IsaacSocket ~= nil and game:IsPaused() then
			canStartConsoleInMenu = true
		end
		if (canStartConsoleInMenu or not game:IsPaused() or isIsaacSocketForcedPaused or consoleInstructionPage == consoleInstructionPageTbl.DEATH or canConsoleRestart) and not Options.DebugConsoleEnabled then
			local isLeftAltPressed = Input.IsButtonPressed(Keyboard.KEY_LEFT_ALT, 0)
			if canStartConsoleInMenu or not game:IsPaused() or isIsaacSocketForcedPaused or consoleInstructionPage == consoleInstructionPageTbl.DEATH then
				if consoleIsOnWhileGamePaused and canConsoleRestart then
					sanzhixiong.consoleOn = true
					pausedFrame = 30
				end
				canConsoleRestart = true
				consoleIsOnWhileGamePaused = false
				--user hit [`] (open console)
				if not stopConsoleButton and Input.IsButtonTriggered(Keyboard.KEY_GRAVE_ACCENT, 0) then
					if selectedOption == -1 and not sanzhixiong.consoleOn then
						if canStartConsoleInMenu and not IsaacSocket.IsaacAPI.IsPauseMenuForceHidden() then
							IsaacSocket.IsaacAPI.ForceHidePauseMenu(true)
						end
						sanzhixiong.consoleOn = true
						notCountGraveAccent = 2
						pausedFrame = 30
					end
				end
				if notCountGraveAccent > 0 then
					notCountGraveAccent = notCountGraveAccent - 1
				end
				if pausedFrame > 0 then
					pausedFrame = pausedFrame - 1
				end
			end
			--update inOptionMenuState and originalStateTbl
			if consoleInstructionPage == consoleInstructionPageTbl.OPTION_MENU_HOME or consoleInstructionPage == consoleInstructionPageTbl.OPTION_MENU_F4 or consoleInstructionPage == consoleInstructionPageTbl.OPTION_MENU_F5 then
				inOptionMenuState = inOptionMenuStateTbl.IN
			elseif consoleInstructionPage == consoleInstructionPageTbl.OPTION_MENU_F5_CONSOLE or consoleInstructionPage == consoleInstructionPageTbl.OPTION_MENU_F5_KEYBOARD then
				inOptionMenuState = inOptionMenuStateTbl.ARROW_BANNED
			elseif consoleInstructionPage == consoleInstructionPageTbl.OPTION_MENU_F5_DEBUG_3 or consoleInstructionPage == consoleInstructionPageTbl.OPTION_MENU_F5_DEBUG_8 or consoleInstructionPage == consoleInstructionPageTbl.OPTION_MENU_F5_DEBUG_4_AND_9 then
				inOptionMenuState = inOptionMenuStateTbl.ARROW_BANNED_AND_DISPLAY_DEBUG
			else
				inOptionMenuState = inOptionMenuStateTbl.NOT_IN
			end
			if consoleInstructionPage ~= consoleInstructionPageTbl.OPTION_MENU_F5_KEYBOARD then
				if keyboardOverlayOn ~= originalStateTbl.keyboard then
					keyboardOverlayOn = originalStateTbl.keyboard
					saveData()
				end
			end
			--user hit [F1] or [F2] command
			local canEmergeCommand = false
			if (isLeftAltPressed or sanzhixiong.consoleOn) and consoleInstructionPage ~= consoleInstructionPageTbl.DEATH and (not game:IsPaused() or isIsaacSocketForcedPaused) and inOptionMenuState == inOptionMenuStateTbl.NOT_IN then
				canEmergeCommand = true
			end
			if canEmergeCommand then
				--[F1] emergency using c422
				if Input.IsButtonTriggered(Keyboard.KEY_F1, 0) then
					needEmergencyBack = true
					switchModeFadedTimer = 100
					if isIsaacSocketForcedPaused then
						switchModeFadedStr = "即将使用后悔药"
					else
						if isLeftAltPressed then
							switchModeFadedStr = "使用后悔药[快捷指令效果]"
						else
							switchModeFadedStr = "使用后悔药"
						end
					end
				end
				--[F2] swallow the trinket
				if Input.IsButtonTriggered(Keyboard.KEY_F2, 0) then
					needSwallowTrinket = true
					switchModeFadedTimer = 100
					if isIsaacSocketForcedPaused then
						switchModeFadedStr = "即将吞下身上饰品"
					else
						if isLeftAltPressed then
							switchModeFadedStr = "吞下身上饰品[快捷指令效果]"
						else
							switchModeFadedStr = "吞下身上饰品"
						end
					end
				end
			end
			--console is turned on
			if sanzhixiong.consoleOn or consoleIsOnWhileGamePaused then
				local curSearchKeyWord = lastSearchKeyWord
				if sanzhixiong.consoleOn then
					letPlayerControl = false
					if Input.IsButtonTriggered(Keyboard.KEY_RIGHT_ALT, 0) then
						displayLanguage = not displayLanguage
						searchInstructionOffsetY = 0
					end
					--user hit [F3-F8] command
					if consoleInstructionPage ~= consoleInstructionPageTbl.DEATH then
						if inOptionMenuState == inOptionMenuStateTbl.NOT_IN then
							--[F3] blindfolded mode
							if Input.IsButtonTriggered(Keyboard.KEY_F3, 0) then
								sanzhixiong.isBlindMode = not sanzhixiong.isBlindMode
								sanzhixiong.canFrameUpdateBlindState = true
								switchModeFadedTimer = 100
								local displayStr = ""
								if isIsaacSocketForcedPaused then
									displayStr = "即将"
								end
								if sanzhixiong.isBlindMode then
									displayStr = displayStr .. "强制角色蒙眼"
								else
									displayStr = displayStr .. "强制角色不蒙眼"
								end
								switchModeFadedStr = displayStr
							end
							--[F4] keyboard overlay
							if Input.IsButtonTriggered(Keyboard.KEY_F4, 0) then
								keyboardOverlayOn = not keyboardOverlayOn
								originalStateTbl.keyboard = keyboardOverlayOn
								switchModeFadedTimer = 100
								local displayStr = "键盘映射"
								if keyboardOverlayOn then
									displayStr = displayStr .. "已开启"
								else
									displayStr = displayStr .. "已关闭"
								end
								switchModeFadedStr = displayStr
								saveData()
							end
							--[F5] test Mode
							if Input.IsButtonTriggered(Keyboard.KEY_F5, 0) then
								if needSwitchTestMode == nil then
									needSwitchTestMode = not isTestMode
								else
									needSwitchTestMode = not needSwitchTestMode
								end
								switchModeFadedTimer = 100
								local displayStr = ""
								if isIsaacSocketForcedPaused then
									displayStr = "即将"
								end
								if needSwitchTestMode then
									displayStr = displayStr .. "打开测试模式"
								else
									displayStr = displayStr .. "关闭测试模式"
								end
								switchModeFadedStr = displayStr
							end
							--[F6] enter submenu
							if Input.IsButtonTriggered(Keyboard.KEY_F6, 0) then
								consoleInstructionPage = consoleInstructionPageTbl.OPTION_MENU_HOME
								chineseModeOn = false
							end
							--[F7] ban item
							if Input.IsButtonTriggered(Keyboard.KEY_F7, 0) then
								userCurString = "ban "
								cursorIndex = #userCurString
								charLengthStr = "1111"
								pinyinExcludeStr = "1111"
							end
							--[F8] change player type
							if Input.IsButtonTriggered(Keyboard.KEY_F8, 0) then
								userCurString = "原地换人 "
								cursorIndex = #userCurString
								charLengthStr = "33331"
								pinyinExcludeStr = "11111"
							end
						else --option menu
							optionMenuAdjustment()
						end
					end
					--[[receive user regular input:
					user hit [char] (which will be displayed on the screen)
					user hit [backspace] (cut the current user string at the index)
					user hit [delete] (cut the current user string at the index preceding from the right side)
					user hit [left] or [right] (move the cursor)
					All these five actions are allowed to be quickly executed when user press the button and do not release.]]--
					--button triggered
					local pasteText = ""
					local isCtrlPressed = Input.IsButtonPressed(Keyboard.KEY_LEFT_CONTROL, 0)
					local isShiftPressed = Input.IsButtonPressed(Keyboard.KEY_LEFT_SHIFT, 0) or Input.IsButtonPressed(Keyboard.KEY_RIGHT_SHIFT, 0)
					for key, value in pairs(keyboardCharTable) do
						if Input.IsButtonTriggered(key, 0) then
							if isCtrlPressed and key == 67 then --ctrl+c copy
								initButtonTriggered()
								switchModeFadedTimer = 100
								local displayStr = "复制"
								if IsaacSocket ~= nil then
									IsaacSocket.System.SetClipboard(userCurString)
									displayStr = displayStr .. "成功"
								else
									displayStr = displayStr .. "失败"
								end
								switchModeFadedStr = displayStr
								break
							end
							if IsaacSocket ~= nil and IsaacSocket.System.GetClipboard() ~= nil and isCtrlPressed then
								pasteText = IsaacSocket.System.GetClipboard()
								if key == 86 then --ctrl+v paste
									initButtonTriggered()
									paste(pasteText)
									break
								end
							end
							if chineseModeOn then
								if characterDisplayTable ~= "" then
									if key >= 49 and key <= 57 or key == 32 then --[num1-num9] or [space]
										break
									end
								end
							end
							if isLeftAltPressed then
								if key >= 48 and key <= 57 then --[num0-num9]
									break
								end
							end
							if key == 96 and notCountGraveAccent > 0 then --[`]
								break
							else
								pausedFrame = 0
							end
							initButtonTriggered()
							if IsaacSocket == nil then
								charInput(value[1], value[2], isShiftPressed)
							end
							break
						end
					end
					if Input.IsButtonTriggered(Keyboard.KEY_BACKSPACE, 0) then
						initButtonTriggered()
						leftBackspace()
					elseif Input.IsButtonTriggered(Keyboard.KEY_DELETE, 0) then
						initButtonTriggered()
						rightDelete()
					elseif Input.IsButtonTriggered(Keyboard.KEY_LEFT, 0) and inOptionMenuState ~= inOptionMenuStateTbl.ARROW_BANNED and inOptionMenuState ~= inOptionMenuStateTbl.ARROW_BANNED_AND_DISPLAY_DEBUG then
						initButtonTriggered()
						leftMove()
					elseif Input.IsButtonTriggered(Keyboard.KEY_RIGHT, 0) and inOptionMenuState ~= inOptionMenuStateTbl.ARROW_BANNED and inOptionMenuState ~= inOptionMenuStateTbl.ARROW_BANNED_AND_DISPLAY_DEBUG then
						initButtonTriggered()
						rightMove()
					end
					local lastMoveCursorFrame = moveCursorFrame
					--button pressed
					if IsaacSocket == nil then
						for key, value in pairs(keyboardCharTable) do
							if Input.IsButtonPressed(key, 0) then
								if chineseModeOn then
									if characterDisplayTable ~= "" then
										if key >= 49 and key <= 57 or key == 32 then --[num1-num9] or [space]
											break
										end
									end
								end
								if isLeftAltPressed then
									if key >= 48 and key <= 57 then --[num1-num9]
										break
									end
								end
								if pausedFrame > 0 then
									break
								end
								if IsaacSocket ~= nil and IsaacSocket.System.GetClipboard() ~= nil and isCtrlPressed and key == 86 then
									pasteText = IsaacSocket.System.GetClipboard()
									executeButtonPressed(5, pasteText)
								else
									if not isCtrlPressed or key ~= 67 then
										executeButtonPressed(0, value[1], value[2], isShiftPressed)
									end
								end
							end
						end
					end
					if Input.IsButtonPressed(Keyboard.KEY_BACKSPACE, 0) then
						executeButtonPressed(1)
					elseif Input.IsButtonPressed(Keyboard.KEY_DELETE, 0) then
						executeButtonPressed(2)
					elseif Input.IsButtonPressed(Keyboard.KEY_LEFT, 0) and inOptionMenuState ~= inOptionMenuStateTbl.ARROW_BANNED and inOptionMenuState ~= inOptionMenuStateTbl.ARROW_BANNED_AND_DISPLAY_DEBUG then
						executeButtonPressed(3)
					elseif Input.IsButtonPressed(Keyboard.KEY_RIGHT, 0) and inOptionMenuState ~= inOptionMenuStateTbl.ARROW_BANNED and inOptionMenuState ~= inOptionMenuStateTbl.ARROW_BANNED_AND_DISPLAY_DEBUG then
						executeButtonPressed(4)
					end
					--check release button ([char], [backSpace], [delete], [left], [right])
					checkReleaseButton(lastMoveCursorFrame)
					--update chinese character display table
					updateCharacterDisplayTable()
					local searchKeyWord = updateSearchResultTable(userCurString)
					curSearchKeyWord = searchKeyWord
					--user hit [num1-num9] or [space] (select a chinese character)
					if chineseModeOn then
						if characterDisplayTable ~= "" then
							for key = 32, 57 do
								if key == 32 or key >= 49 then --[space] or [num1-num9]
									if Input.IsButtonTriggered(key, 0) then
										selectAChineseCharacter(key)
										break
									end
								end
							end
						end
					end
					--hit [num1-num9] or [num0] quick select search result
					executeQuickSearchResult(isLeftAltPressed, searchKeyWord)
					--user hit [enter] (execute the command and update user string)
					if Input.IsButtonTriggered(Keyboard.KEY_ENTER, 0) or Input.IsButtonTriggered(Keyboard.KEY_KP_ENTER, 0) then
						displayUpdateMode = displayBoxInsertMode.USER_STR
						--update user string
						if userCurString == [[]] then
							sanzhixiong.consoleOn = false
							if IsaacSocket ~= nil and IsaacSocket.IsaacAPI.IsPauseMenuForceHidden() then
								IsaacSocket.IsaacAPI.ForceHidePauseMenu(false)
							end
							return
						end
						for i, str in ipairs(userStringList) do
							if str == userCurString then
								table.remove(userStringList, i)
								table.remove(charLengthStrList, i)
								table.remove(pinyinExcludeStrList, i)
								break
							end
						end
						table.insert(userStringList, userCurString)
						table.insert(charLengthStrList, charLengthStr)
						table.insert(pinyinExcludeStrList, pinyinExcludeStr)
						userLastString = userCurString
						lastCharLengthStr = charLengthStr
						lastPinyinExcludeStr = pinyinExcludeStr
						userStringIndex = #userStringList
						--get executeString command string that will be executed in logic update
						local executeString = [[]]
						local canExecuteStringRepeat = nil
						local needExecuteNow = nil
						local executeNow = false
						local needDisplayStringTable = {}
						executeString, canExecuteStringRepeat, needExecuteNow = getExecuteString(userCurString, searchKeyWord, needDisplayStringTable)
						if needExecuteNow and IsaacSocket ~= nil then
							executeNow = true
							loadExecuteString(executeString)
						end
						--update lastExecutedStrTable
						if canExecuteStringRepeat then
							lastExecutedStrTable[1] = executeString
							lastExecutedStrTable[2] = executeNow
						end
						-- executeString is integer -1 means skip the repeat part since it will not be correctly executed
						if executeString ~= -1 and not executeNow then
							table.insert(toBeLoadedExecuteStrList, executeString)
						end
						--reset user current string and the cursor
						userCurString = [[]]
						charLengthStr = ""
						pinyinExcludeStr = ""
						cursorIndex = 0
						--update displayBox (true for insert, false for clear)
						pageOffsetY = 0
						updateDisplayBox(userLastString, displayUpdateMode)
						for _, str in ipairs(needDisplayStringTable) do
							updateDisplayBox(str, displayBoxInsertMode.PRINT_STR, true)
						end
						needDisplayStringTable = nil
						--save command history
						saveData()
					end
					--user hit [up] or [down] (switch to nearby command)
					if Input.IsButtonTriggered(Keyboard.KEY_UP, 0) and inOptionMenuState ~= inOptionMenuStateTbl.ARROW_BANNED and inOptionMenuState ~= inOptionMenuStateTbl.ARROW_BANNED_AND_DISPLAY_DEBUG then
						if userStringIndex ~= nil then
							userCurString = userLastString
							charLengthStr = lastCharLengthStr
							pinyinExcludeStr = lastPinyinExcludeStr
							cursorIndex = #userCurString
							if userStringIndex > 1 then
								userStringIndex = userStringIndex - 1
								userLastString = userStringList[userStringIndex]
								lastCharLengthStr = charLengthStrList[userStringIndex]
								lastPinyinExcludeStr = pinyinExcludeStrList[userStringIndex]
							elseif userStringIndex == 1 then
								userStringIndex = userStringIndex - 1
							end
						end
					elseif Input.IsButtonTriggered(Keyboard.KEY_DOWN, 0) and inOptionMenuState ~= inOptionMenuStateTbl.ARROW_BANNED and inOptionMenuState ~= inOptionMenuStateTbl.ARROW_BANNED_AND_DISPLAY_DEBUG then
						if userStringIndex == nil then
							userCurString = [[]]
							charLengthStr = ""
							pinyinExcludeStr = ""
							cursorIndex = 0
						else
							if userStringIndex == #userStringList or userStringIndex == #userStringList - 1 then
								userStringIndex = #userStringList
								userCurString = [[]]
								charLengthStr = ""
								pinyinExcludeStr = ""
								userLastString = userStringList[userStringIndex]
								lastCharLengthStr = charLengthStrList[userStringIndex]
								lastPinyinExcludeStr = pinyinExcludeStrList[userStringIndex]
								cursorIndex = 0
							else
								userStringIndex = userStringIndex + 1
								userLastString = userStringList[userStringIndex]
								lastCharLengthStr = charLengthStrList[userStringIndex]
								lastPinyinExcludeStr = pinyinExcludeStrList[userStringIndex]
								userCurString = userStringList[userStringIndex + 1]
								charLengthStr = charLengthStrList[userStringIndex + 1]
								pinyinExcludeStr = pinyinExcludeStrList[userStringIndex + 1]
								cursorIndex = #userCurString
							end
						end
					end
					--user hit [home] (move to the beginning)
					if Input.IsButtonTriggered(Keyboard.KEY_HOME, 0) then
						cursorIndex = 0
					end
					--user hit [end] (move to the end)
					if Input.IsButtonTriggered(Keyboard.KEY_END, 0) then
						cursorIndex = #userCurString
					end
					--user hit [pageup] or [pagedown] (scroll the history command page)
					if Input.IsButtonPressed(Keyboard.KEY_PAGE_UP, 0) then
						pageOffsetY = pageOffsetY + pageScrollFrame
					elseif Input.IsButtonPressed(Keyboard.KEY_PAGE_DOWN, 0) then
						pageOffsetY = pageOffsetY - pageScrollFrame
						--set the bottom boundary of page scroll
						if pageOffsetY < 0 then
							pageOffsetY = 0
						end
					end
					--user hit [tab] (turn on or turn off chinese mode)
					if Input.IsActionTriggered(ButtonAction.ACTION_MAP, 0) then
						if inOptionMenuState == inOptionMenuStateTbl.NOT_IN then
							chineseModeOn = not chineseModeOn
						end
					end
					lastSearchKeyWord = searchKeyWord
					updateInstuctionText()
				end
				--user String display
				displayUserString()
				--display instruction text and background
				displayInstuctionTextAndBackGround(isLeftAltPressed, curSearchKeyWord)
			end
			if not sanzhixiong.consoleOn then
				letPlayerControl = true
			end
		end
		-- display the print string for 3 seconds when FadedConsoleDisplay is true
		if not ((not game:IsPaused() or consoleInstructionPage == consoleInstructionPageTbl.DEATH or canConsoleRestart) and (sanzhixiong.consoleOn or consoleIsOnWhileGamePaused)) then
			if Options.FadedConsoleDisplay then
				displayPrintString()
			end
		end
		if game:IsPaused() and not isIsaacSocketForcedPaused and consoleInstructionPage ~= consoleInstructionPageTbl.DEATH then
			if sanzhixiong.consoleOn == true and (IsaacSocket == nil or not IsaacSocket.IsaacAPI.IsPauseMenuForceHidden()) then
				consoleIsOnWhileGamePaused = true
				sanzhixiong.consoleOn = false
			end
		end
		lastFrameGamePaused = game:IsPaused()
		-- update FadedConsoleDisplay timer
		for _, tbl in ipairs(displayBox) do
			if tbl[2] >= 3 and tbl[2] < 183 then
				tbl[2] = tbl[2] + 1
			end
		end
	end
end

local function onInputAction(_, _, inputHook, button)
	if sanzhixiong.consoleOn or consoleIsOnWhileGamePaused then
		if button == ButtonAction.ACTION_MUTE or button == ButtonAction.ACTION_FULLSCREEN or button == ButtonAction.ACTION_RESTART or button == ButtonAction.ACTION_PAUSE or button == ButtonAction.ACTION_MENUBACK or button == ButtonAction.ACTION_JOINMULTIPLAYER then
			if inputHook == InputHook.IS_ACTION_TRIGGERED or inputHook == InputHook.IS_ACTION_PRESSED then
				return false
			end
		end
	end
	if Input.IsButtonPressed(Keyboard.KEY_LEFT_ALT, 0) then
		if button == ButtonAction.ACTION_CONSOLE then
			if inputHook == InputHook.IS_ACTION_TRIGGERED then
				return false
			end
		end
	end
end

-- Triggered when mod is unloaded (including reload process)
local function onPreModUnload(_, toBeUnloadedMod)
    if toBeUnloadedMod == mod then
		rawset(_G, "print", oldPrint)
	end
end

-- for IsaacSocket
local function onCharInput(_, char)
	if sanzhixiong.consoleOn then
    	paste(char)
	end
end

local function onIsaacSocketConnected(_)
	if isaacSocketCountTable.edenTokenNum == nil then
		isaacSocketCountTable.edenTokenNum = IsaacSocket.IsaacAPI.GetEdenTokens()
	end
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, onGameStart)
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, onGameExit)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, onNewLevel)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, onPlayerUpdate)
mod:AddCallback(ModCallbacks.MC_POST_GAME_END, onGameEnd)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, onUpdate)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, onRender)
mod:AddCallback(ModCallbacks.MC_INPUT_ACTION, onInputAction)
mod:AddCallback(ModCallbacks.MC_PRE_MOD_UNLOAD, onPreModUnload)
-- for IsaacSocket
mod:AddCallback("ISMC_PRE_CHAR_INPUT", onCharInput)
mod:AddCallback("ISMC_POST_OPEN", onIsaacSocketConnected)

-- global api for all mods
_SZX_CHINESE_CONSOLE_ = {}
_SZX_CHINESE_CONSOLE_.setModItemChineseName = function(tbl)
	if type(tbl) ~= "table" then
		print("_SZX_CHINESE_CONSOLE_.setModItemChineseName(attr): attr format failure: attr must be a table")
        return false
    end
    for _, subTable in pairs(tbl) do
        if type(subTable) ~= "table" or #subTable ~= 2 then
			print("_SZX_CHINESE_CONSOLE_.setModItemChineseName(attr): attr format failure: elements of the attr table must be a table with exactly 2 elements")
            return false
        end
		if type(subTable[1]) ~= "string" or type(subTable[2]) ~= "string" then
			print("_SZX_CHINESE_CONSOLE_.setModItemChineseName(attr): attr format failure: elements of each subtable must be a string")
			return false
		end
		table.insert(needAddChineseNameList, cloneTable(subTable))
    end
end