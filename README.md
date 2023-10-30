# 三只熊中文控制台 / Szx Chinese Console

### B站视频链接：[https://www.bilibili.com/video/BV16M4y1j7XN](https://www.bilibili.com/video/BV16M4y1j7XN)

### steam创意工坊链接：[https://steamcommunity.com/sharedfiles/filedetails/?id=3001774454](https://steamcommunity.com/sharedfiles/filedetails/?id=3001774454)

## 简介：

这是拥有诸多功能的控制台mod，游玩本mod你需要进入游戏后，将你的全屏[F]、静音[M]、暂停[P]三个按键改为[F9][F10][F11]，以保证你能使用mod的正常功能。（v2.03更新：你无需在option.ini文件中把以撒的官方控制台关闭，也可以正常使用本控制台mod）

简要的操作说明我会列在下面，对于具体的控制台功能详情，可以来看我的b站视频，我叫'enthusiasmgame'。视频讲解地会比较细致，也更加容易理解~

有任何问题欢迎在讨论区留言，祝大家玩的愉快！

## 按键介绍：
### 控制台基本功能按键：

- [`] 打开控制台(无延迟)(这意味着你可以立即按快捷指令、关闭控制台或其他操作)

- [LAlt]+[`] 打开或关闭官方控制台

- [Enter/KpEnter] 在输入框为空时关闭控制台(无延迟)

- [Esc] 关闭控制台

- [Ins] 打开/关闭Debug文字显示 [默认开启]

- [LCtrl/RCtrl] 搜索栏或搜索框向上/向下翻页或滚动翻页(搜索栏不支持快捷生效按键，后面会提到'搜索框'和'快捷生效按键'的概念)

- [RAlt] 切换搜索框内语言为中文/英文

- [Tab] 切换输入语言为中文/英文

### 输入与显示部分按键:

- [任意字符按键] 将按键内容输入进输入框

- [Left] 输入框光标左移一位

- [Right] 输入框光标右移一位

- [Backspace] 在输入框光标位置删除一个字符

- [Delete] 在输入框光标位置优先向右删除一个字符

- [Home] 输入框光标移到最前

- [End] 输入框光标移到最后

- [Up] 输入框跳到上一条指令

- [Down] 输入框跳到下一条指令

- [PgUp/PgDn] 显示框向上/向下滚动翻页

- [Enter/KpEnter] 输入当前指令

- [Space] 中文输入模式输入第1个汉字选项

- [Num1-9] 中文输入模式输入第1-9个汉字选项

([任意字符按键], [Left], [Right], [Backspace], [Delete]支持长按进入快速模式)

### 搜索框快捷生效按键:

- [LAlt]+[Num1-9] 快捷生效{结果1-结果9} (搜索框内有结果时)

- [LAlt]+[Num0] 快捷生效{所有搜索框内结果} 

## 功能介绍：

### 你可以使用[F1-F8]执行一些快捷指令：

- [F1] 紧急后悔('饿啊'阶段也可使用) [LAlt+F1] 控制台关闭时也可触发

- [F2] 一键吞饰品 [LAlt+F2] 控制台关闭时也可触发

- [F3] 强制蒙眼/解除蒙眼

- [F4] 键盘映射 {打开/关闭} [默认关闭]

- [F5] 测试模式(用于调试和测试) {打开/关闭}

- [F6] 道具品质显示 {打开/关闭} 长按[Tab]显示道具品质 [默认开启]

- [F7] ban道具 (ban单一id道具或ban全道具品质)

- [F8] 原地换人 (包括游戏不正常开放的角色，如带攻击倍率的里拉2或里骨之魂)

### 除了快捷指令，你还可以使用所有官方控制台能用的指令，包括普通指令和lua指令。此外，大部分普通指令拥有一个使用说明和参数介绍的中文搜索栏并且支持更近一步的缩写形式，包括：

- [s]或[stage] 楼层传送

- [g]或[giveitem] 获得物品 (表双子中的哥哥[g2]或[giveitem2])

- [r]或[remove] 移除物品 (表双子中的哥哥[r2]或[remove2])

- [sp]或[spawn] 生成实体

- [d]或[debug] 开关Debug

- [rep]或[repeat] 重复执行上一条成功执行的指令一次或多次

- [cl]或[clear] 清空控制台

- [res]或[restart] 重新开始(可指定角色)

- [cha]或[challenge] 开始指定挑战(或无挑战)

- [gs]或[gridspawn] 生成障碍物

- [cos]或[costumetest] 换装测试

- [cur]或[curse] 添加额外诅咒(包括挑战10中的诅咒)

- [go]或[goto] 传送指定房间

- [rew]或[rewind] 倒回上个房间

- [cut]或[cutscene] 播放指定过场动画
#### 其余指令可以使用但是并没有使用说明、参数介绍或进一步缩写形式，包括但不限于：

- [seed] 使用指定种子游玩

- [luamod] 重新加载指定mod的main.lua

### 常用指令支持更近一步的搜索功能，并且凡是支持搜索功能的指令均可以使用搜索框快捷生效按键：[LAlt]+[Num1-9], [LAlt]+[Num0]

### 搜索功能分为四种：序号搜索、名称搜索、标签搜索、条件搜索，其中序号搜索只能单独使用，名称、标签、条件支持组合使用

#### 支持序号搜索的指令：

- [s]或[stage]

- [sp 5]或[spawn 5] 各级菜单

- [sp 6]或[spawn 6]

- [g c]或[giveitem c]或[g2 c]或[giveitem2 c]

- [g t]或[giveitem t]或[g2 t]或[giveitem2 t]

- [g T]或[giveitem T]或[g2 T]或[giveitem2 T]

- [g k]或[giveitem k]或[g2 k]或[giveitem2 k]

- [g p]或[giveitem p]或[g2 p]或[giveitem2 p]

- [g P]或[giveitem P]或[g2 P]或[giveitem2 P]

- [r c]或[remove c]或[r2 c]或[remove2 c]

- [r t]或[remove t]或[r2 t]或[remove2 t]

#### 支持名称、标签、条件搜索的指令：

- [sp]或[spawn]

- [g]或[giveitem]或[g2]或[giveitem2]

- [r]或[remove]或[r2]或[remove2]

#### 此外，支持两个额外指令：(spawn, giveitem, remove全称形式也可以使用，这里只列出缩写形式)

- [sp 5.350.[id]+] 生成指定id金饰品(id为可选参数)

- [g c-[id]]或[g2 c-[id]] 获得指定id的错误道具(道具品质显示[F6]会告诉你错误道具id，在包含错误道具的房间内长按[Tab])

- [r c-[id]]或[r2 c-[id]] 移除指定id的错误道具(道具品质显示[F6]会告诉你错误道具id，在包含错误道具的房间内长按[Tab])

## 搜索模式介绍：(英文字母不区分大小写）

### 序号搜索：(格式：[序号])

- 从序号的首位开始匹配(这意味着你不能通过搜索"sp 5.100.6"搜索到id为562的道具)，不需要完整匹配

### 名称搜索：(格式：[名称])

- 从名称的任意位置开始匹配，支持中文名称匹配，不需要完整匹配

### 标签搜索：(格式：[#][标签名])

- 从标签的首位开始匹配(这意味着你不能通过"g #secret"搜到"ultraSecret"标签的道具或饰品)，不需要完整匹配

### 条件搜索：(格式：[$][条件名][:][值]) 

- 从条件名的首位开始匹配，条件名不需要完整匹配，值必须和该道具或饰品的该条件名的值完全相同


#### 字段可组合使用，支持语言混搭

### 举例：

- 例子1：[sp $q:4 #ang] 匹配全部天使标签4级道具 (你可以按[LAlt]+[Num0]将他们全部生成)

- 例子2：[g #bos #dam th] 匹配全部首领标签攻击力标签且英文或中文名称中包含字段"th"的道具或饰品

- 例子3: [r #dev 宝 #攻 $q:2] 匹配全部恶魔标签攻击力标签的2级道具且中文名称中包含字段"宝"的道具

## 标签名一览：（中/英）

- 主动道具, 被动道具, 跟班, 饰品,
- active, passive, familiar, trinket,

- 猫, 苍蝇, 宝宝, 妈妈, 针, 书, 蜘蛛, 蘑菇, 大便, 鲍勃,
- guppy, fly, baby, mom, syringe, book, spider, mushroom, poop, bob,

- 宝箱房, 商店, 宝宝商店, 首领, 隐藏房, 天使, 恶魔, 诅咒, 究极隐藏房, 星象, 图书馆, 金箱子, 红箱子, 木箱子, 旧箱子, 妈妈箱子, 白乞丐, 恶魔乞丐, 钥匙大师, 炸弹乞丐, 腐烂乞丐, 电池乞丐, 三选一, 夹娃娃机,
- treasure, shop, babyShop, boss, secret, angel, devil, curse, ultraSecret, planetarium, library, goldenChest, redChest, woodenChest, oldChest, momsChest, beggar, demonBeggar, keyMaster, bombBum, rottenBeggar, batteryBum, shellGame, craneGame,

- 全部, 移速, 攻击力, 射速, 射程, 弹速, 幸运, 子弹颜色, 子弹特效, 体型, 肤色, 飞行,
- all, speed, damage, firedelay, range, shotspeed, luck, tearcolor, tearflag, size, skincolor, flying,

- 红心, 魂心, 黑心, 硬币, 炸弹, 钥匙,
- hearts, soulhearts, blackhearts, coins, bombs, keys,

- 非贪婪模式, 非伊甸, 非游魂长子权, 非挑战, 非每日, 非店主, 非大量过牌,
- nogreed, noeden, nolostbr, nochallenge, nodaily, nokeeper, nocantrip,

- 特殊道具, 任务, 食物, 怪物手册, 星座, 电池, 科技, 掉落物机制, 唯一跟班,
- special, quest, food, monstermanual, stars, battery, tech, pickupvision, uniquefamiliar,

- 攻击性, 可召唤, 拉萨路共享, 拉萨路全局共享, 死亡,
- offensive, summonable, lazarusshared, lazarussharedglobal, dead

## 条件名与条件名可能的值一览：

### quality:
- 0 1 2 3 4

### maxcharges:
- 0 1 2 3 4 6 12
- 1 6 12 30 64 70 90 110 180 200 250 300 450 900 100000

### chargetype:
- timed special

### shopprice:
- 10 99

### devilprice:
- 1 2
## 更新日志：

### v2.16更新

- 增加了一个接口，mod作者使用这个接口可以让搜索出的mod道具、饰品、卡牌、胶囊拥有中文并且支持中文搜索(之前仅支持英文)

### v2.15更新

- 修复了当角色死亡且开着三只熊中文控制台小概率控制台界面卡住的问题

### v2.14更新

- 修复了当角色死亡且开着三只熊中文控制台小概率触发控制台界面卡主时无法使用[LAlt]+[`]快捷键切换为官方控制台使用rewind的问题

- 去除了使用[LAlt]+[`]快捷键切换两种控制台的角色动画效果

### v2.13更新

- 修复了v2.11版本更新时产生的搜索道具充能类型[$c:]或[$chargetype:]不能正常使用的问题

- 完善了若干道具的民间通俗叫法

### v2.12更新

- 进一步完善了601-732号道具的民间通俗叫法(已完成100%进度：t1-t189和c1-c732)

- 修改了大量中文输入时拼音显示结果的顺序

### v2.11更新

- 优化[ctrl+v]黏贴功能，使得黏贴内容中的换行符前的指令会被执行

- 进一步完善了501-600号道具的民间通俗叫法(已完善进度：t1-t189和c1-c600)

- 修改了大量中文输入时拼音显示结果的顺序

### v2.10更新

- 适配了IsaacSocket模组的[ctrl+c]复制功能和[ctrl+v]黏贴功能(IsaacSocket暂时未发布)

- 修改了部分中文输入时拼音显示结果的顺序

### v2.09更新

- 修复了蒙眼状态下除了莉莉丝的所有角色都被视为里骨的问题

### v2.08更新

- 修复了莉莉丝变成其它人物后无法发射子弹的问题

- 修复了非蒙眼角色在蒙眼状态小退后蒙眼装扮仍保留的问题

- 修复了蒙眼挑战中手动F3解除蒙眼状态后小退，蒙眼装扮未重新添加的问题

- 修复了蒙眼挑战中里骨的黑色特殊蒙眼装扮会被F3覆盖为普通蒙眼装扮的问题

- 去除了里骨之魂在蒙眼状态下添加的无意义的蒙眼装扮

- 进一步完善了401-500号道具的民间通俗叫法(已完善进度：t1-t189和c1-c500)

- 修改了大量中文输入时拼音显示结果的顺序

### v2.07更新

- 新增了[LAlt]+[`]快捷键一键开启官方控制台或关闭官方控制台

### v2.06更新

- 普通维护更新，无实际改动

### v2.05更新

- 普通维护更新，无实际改动

### v2.04更新

- 进一步完善了251-400号道具的民间通俗叫法(已完善进度：t1-t189和c1-c400)

- 修改了大量中文输入时拼音显示结果的顺序

### v2.03更新

- 现在起无论option.ini中EnableDebugConsole为0还是1均可以正常运行本mod

### v2.02更新

- 修复了v1.07版本更新带来的名称搜索超过两个单词搜不到的问题

- 进一步完善了151-250号道具的民间通俗叫法(已完善进度：t1-t189和c1-c250)

- 修改了大量中文输入时拼音显示结果的顺序

### v2.01更新
- 增加了搜索列表中的mod道具和mod饰品，支持序号搜索，支持仅英文的名称搜素，支持全部五个条件名的条件搜索，支持仅英文的部分标签的标签搜索(active, passive, trinket, familiar, hearts, soulhearts, blackhearts, keys, coins, bombs, special)

- 增加了搜索列表中的mod卡牌和mod药丸(仅英文)

- 增加了5级道具的道具品质显示文本颜色

- 进一步完善了1-150号道具的民间通俗叫法(已完善进度：t1-t189和c1-c150)

- 修改了大量中文输入时拼音显示结果的顺序

### v1.07更新
- 修复了搜索模块中结果为空后另加字段会覆盖前几个字段效果的问题

### v1.06更新
- 修复了[s]或[stage]楼层转送指令在贪婪模式中显示错误的问题

- 增加了[s]或[stage]楼层转送指令的细分菜单搜索，支持中英双语

- 调整了15个中文输入时拼音显示结果的顺序

### v1.05更新

- 修复了部分近战武器在蒙眼状态不会收回的问题，如妈刀、骨哥棒槌、里夏娃圣血吸管

### v1.04更新

- 增加了[sp 6]或[spawn 6]可互动实体的细分菜单搜索，支持中英双语

### v1.03更新：

- 修复了中文显示模式下sp或spawn指令的"5.350.[num]+'的失效问题

### v1.02更新：

- 增加道具品质彩色文字显示（原先均为白色）

- 修复了包含1个结果的中文标签‘非店主’搜索不到的问题

- 修复了包含5个结果的道具条件名chargetype的值错误的问题

- 更改包含5个结果的饰品英文标签'familiars'为'familiar', 与道具的'familiar'英文标签统一

- 更改包含1个结果的饰品英文标签'lucks'为'luck', 与道具的'luck'英文标签统一

- 调整了1个中文输入时拼音显示结果的顺序

### v1.01更新：

- 修复[rep]与[repeat]命令和预期不一致的问题

- 修复游戏暂停控制台画面保留状态时能使用[LAlt]+[F1]或[F2]的问题

--------------------------------------------------------------------------------
# Szx Chinese Console
## Brief introduction:

This is a console mod with lots of extra functions. To play this mod, you need to change your keys fullscreen [F], mute [M], pause [P] to [F9], [F10], [F11] to ensure that you can successfully get access to the all functions of the mod.
(v2.03 update: You no longer need to disable Isaac's official console in the 'option.ini' file.)

Brief instructons of the mod will be showed below. For details of the specific console functions, you can watch my video in bilibili. My id is 'enthusiasmgame'. The 5-minute-long promotional video id in blibili is 'BV16M4y1j7XN'. The effects of this mod in video will be more intuitive and easier to understand~

If you have any questions, please leave a message in the discussion forum. Wish you have a good game in the mod.

## Key introduction:

### Console basic keys:

- [`] open the console(no delay)(which means you can immediately hit quick command, close the console or perform other actions)

- [LAlt]+[`] open or close the official console

- [Enter/KpEnter] close the console when input is empty(no delay)

- [Esc] close the console

- [Ins] open/close debug text display [default on]

- [LCtrl/RCtrl] informational texts next/last page or result boxs scroll up/down (informational texts does not support shortcut keys. The concept of 'result box' and 'shortcut keys' will be mentioned later)

- [RAlt] switch the language display in the result box to [Chinese/English]

- [Tab] switch the input language to [Chinese/English]

### input or display keys: ([any char key], [Left], [Right], [Backspace], [Delete] support long-pressed action to enter the quick mode)

- [any char key] input a char into the input box

- [Left] cursor left by one in the input box

- [Right] cursor right by one in the input box

- [Backspace] delete a char at the cursor position in the input box

- [Delete] delete a char at the cursor position pre in the input box preceding from the right side

- [Home] move the cursor to the beginning of the input box

- [End] move the cursor to the end of the input box

- [Up] jump to the last command in the input box

- [Down] jump to the next command in the input box

- [PgUp/PgDn] display box scroll up/down

- [Enter/KpEnter] enter the current command

- [Space] choose the first character option in the Chinese input mode

- [Num1-9] choose the 1st-9th character option in the Chinese input mode

### shortcut keys:

- [LAlt]+[Num1-9] immediately execute the 1st-9th action in the result box(when action exists)

- [LAlt]+[Num0] immediately execute all actions in the result box

## function introduction:

### You can use [F1-F8] to immediately execute an action or actions:

- [F1] emergency Glowing Hourglass(also works when you are dying but not dead[In this time point, hit [F1] will cause the current game file loss, so keep running until you finish the game]) [LAlt+F1] execute the command even if console is off

- [F2] swallow trinkets immediately [LAlt+F2] execute the command even if console is off

- [F3] blindfolded/remove the blindfold

- [F4] keyboard overlay {on/off} [default off]

- [F5] test mode (used for debugging or testing) {on/off}

- [F6] item quality display {on/off} [Tab] long-pressed to show item quality information [default on]

- [F7] ban items from the itempools (including ban single item by its ID or ban all items of one specific quality)

- [F8] change player type immediately to a specific player type (including the player types that do not appear in a normal game, like Dead Tainted Lazarus with damage amplification or Tainted Soul)

### Except these quick commands, you can execute all commands that can be executed in Isaac's official console, including basic command and lua command. Addtionally, most basic commands here have informational texts of use case and parameter instructons and support further abbreviation forms. Including:

- [s]or[stage] teleport the player to a new stage

- [g]or[giveitem] give player 1 an item by given id ([g2]or[giveitem2] for Esau)

- [r]or[remove] remove player 1's item by given id ([r2]or[remove2] for Esau)

- [sp]or[spawn] spawn an entity

- [d]or[debug] open/close debug command

- [rep]or[repeat] repeat the last successfully executed command for one or multiple times

- [cl]or[clear] clear the display box

- [res]or[restart] restart the game(with specific player type)

- [cha]or[challenge] start a challenge(or start a game with no challenges)

- [gs]or[gridspawn] spawn an grid entity

- [cos]or[costumetest] costumetest

- [cur]or[curse] add addtional curse to the game(including the curse in challenge 10)

- [go]or[goto] teleport the player to a specific room

- [rew]or[rewind] rewind to the state in the last room

- [cut]or[cutscene] play a specific cutscene 

#### Other basic commands can also be executed but have no informational texts of use case or parameter instructons and do not support further abbreviation forms. Including, but not limited to:

- [seed] start a game with specific seed

- [luamod] reload 'main.lua' file of a mod


### Frequently used basic commands supports search function. All search-function-supported commands are allowed to be immediately executed with shortcut keys: [LAlt]+[Num1-9], [LAlt]+[Num0]

### There are four search mode: index search, name search, label search, conditional search. Index search can only be used individually, while name, label and conditional search can be combined.

#### Commands that support index search:

- [s] or [stage]

- [sp 5] or [spawn 5] (all sub commands)

- [sp 6] or [spawn 6]

- [g c] or [giveitem c] or [g2 c] or [giveitem2 c]

- [g t] or [giveitem t] or [g2 t] or [giveitem2 t]

- [g T] or [giveitem T] or [g2 T] or [giveitem2 T]

- [g k] or [giveitem k] or [g2 k] or [giveitem2 k]

- [g p] or [giveitem p] or [g2 p] or [giveitem2 p]

- [g P] or [giveitem P] or [g2 P] or [giveitem2 P]

- [r c] or [remove c] or [r2 c] or [remove2 c]

- [r t] or [remove t] or [r2 t] or [remove2 t]

#### Commands that support name, label and conditional search:

- [sp] or [spawn]

- [g] or [giveitem] or [g2] or [giveitem2]

- [r] or [remove] or [r2] or [remove2]

### Besides, two more extra commands are supported in this mod: (In the following lines I will only list the abbreviation form of commands. Their whole forms are also supported)

- [sp 5.350.[id]+] spawn the golden version of a trinket by given id (Here [id] is an optional parameter)

- [g c-[id]] or [g2 c-[id]] give the player an error item by given id (Item quality display[F6] will tell the id of error items. long-press [Tab] to show item quality information)

- [r c-[id]] or [r2 c-[id]] remove the player's error item by given id (Item quality display[F6] will tell the id of error items. long-press [Tab] to show item quality information)

## Search mode introduction: (English letters are case-insensitive.)

### Index search: (format: [id])

- Match the result id from the beginning of it (which means you can not get an item with id 562 by "sp 5.100.6" input). Index search doesn't require exact match.

### Name search: (format: [name])

- Match the result name from any index of it. Support Chinese character as input. Name search doesn't require exact match.

### label search: (format: [#][label name])

- Match the result label from the beginning of it (which means you can not get an "ultraSecret" labelled item by "g #secret" input). Label search doesn't require exact match.

### conditional search: (format: [$][condition name][:][value])

- Match the result condition name from the beginning of it. The condition name doesn't require exact match. But the value must be the exactly same value of that condition.


#### Input words can be combined and language mixing is supported in combination.

### Examples:

- e.g.1: [sp $q:4 #ang] Match all items with both 'angel' label and quality 4 (You can hit [LAlt]+[Num0] to spawn them all immediately.)

- e.g.2: [g #bos #dam th] Match all items with both 'boss' label and 'damage' label and 'th' appears in the item's name.

- e.g.3: [r #dev 宝 #攻 $q:2] Match all items with 'devil' label, '攻击力' label and quality 2 and '宝' appears in the item's name

## List of label names: (Chinese/English)

- 主动道具, 被动道具, 跟班, 饰品,
- active, passive, familiar, trinket,

- 猫, 苍蝇, 宝宝, 妈妈, 针, 书, 蜘蛛, 蘑菇, 大便, 鲍勃,
- guppy, fly, baby, mom, syringe, book, spider, mushroom, poop, bob,

- 宝箱房, 商店, 宝宝商店, 首领, 隐藏房, 天使, 恶魔, 诅咒, 究极隐藏房, 星象, 图书馆, 金箱子, 红箱子, 木箱子, 旧箱子, 妈妈箱子, 白乞丐, 恶魔乞丐, 钥匙大师, 炸弹乞丐, 腐烂乞丐, 电池乞丐, 三选一, 夹娃娃机,
- treasure, shop, babyShop, boss, secret, angel, devil, curse, ultraSecret, planetarium, library, goldenChest, redChest, woodenChest, oldChest, momsChest, beggar, demonBeggar, keyMaster, bombBum, rottenBeggar, batteryBum, shellGame, craneGame,

- 全部, 移速, 攻击力, 射速, 射程, 弹速, 幸运, 子弹颜色, 子弹特效, 体型, 肤色, 飞行,
- all, speed, damage, firedelay, range, shotspeed, luck, tearcolor, tearflag, size, skincolor, flying,

- 红心, 魂心, 黑心, 硬币, 炸弹, 钥匙,
- hearts, soulhearts, blackhearts, coins, bombs, keys,

- 非贪婪模式, 非伊甸, 非游魂长子权, 非挑战, 非每日, 非店主, 非大量过牌,
- nogreed, noeden, nolostbr, nochallenge, nodaily, nokeeper, nocantrip,

- 特殊道具, 任务, 食物, 怪物手册, 星座, 电池, 科技, 掉落物机制, 唯一跟班,
- special, quest, food, monstermanual, stars, battery, tech, pickupvision, uniquefamiliar,

- 攻击性, 可召唤, 拉萨路共享, 拉萨路全局共享, 死亡,
- offensive, summonable, lazarusshared, lazarussharedglobal, dead

## List of condition name and its possible value:

### quality:
- 0 1 2 3 4

### maxcharges:
- 0 1 2 3 4 6 12
- 1 6 12 30 64 70 90 110 180 200 250 300 450 900 100000

### chargetype:
- timed special

### shopprice:
- 10 99

### devilprice:
- 1 2

## Changelog:

### v2.16 update

- Added a new interface that allows mod authors to provide Chinese namesfor mod collectibles, trinkets, cards, and pills. This update also enables Chinese language support for searching, whereas previously only English was supported.

### v2.15 update

- Fixed an issue where the console interface would occasionally freeze when the character died with Szx Chinese console interface is open.

### v2.14 update

- Fixed an issue where occasionally, when a character dies with Szx Chinese console interface is open, it would get stuck, preventing the use of the [LAlt]+[`] shortcut - to switch to the official console in order to use 'rewind' command.

- Removed character animation effects when switching between the two consoles using [LAlt]+[`].

### v2.13 update

- Fixed the issue that occurred during the v2.11 update, where the search for items with the charge type [$c:] or [$chargetype:] could not be used properly.

- Optimized some Chinese nick names of collectibles.

### v2.12 update

- Optimized the Chinese nick names of collectibles. (Progress completed: t1-t189 and c1-c732)

- Adjusted a huge number of pinyin results display order in the option box in Chinese input mode.

### v2.11 update
- Optimized the [ctrl+v] paste functionality allowing for the execution of commands preceding newline character.

- Optimized the Chinese nick names of collectibles. (Completed progress: t1-t189 and c1-c600)

- Adjusted a huge number of pinyin results display order in the option box in Chinese input mode.

### v2.10 update

- Adapted the [Ctrl+C] copy functionality and [Ctrl+V] paste functionality for the IsaacSocket mod(It has not released yet).

- Adjusted parts of pinyin results display order in the option box in Chinese input mode.

### v2.09 update

- Fixed the issue where all characters except for Lilith would be considered as Tainted Forgotten in the blindfolded state.

### v2.08 update

- Fixed the issue where the Lilith-transformed character was unable to shoot.

- Fixed the issue where non-blindfolded characters would retain the blindfold appearance after main menu exit and game re-entry.

- Fixed the issue where manually removing the blindfolded status with [F3] during the blindfolded challenge and then main menu exit and game re-entry would result in the blindfold appearance not being re-added.

- Fixed the issue where the black special blindfold appearance for Tainted Forgotten in the blindfolded challenge would be overwritten to a regular blindfold appearance when using [F3].

- Removed the meaningless blindfold appearance added to Tainted Soul in the blindfolded state.

- Optimized the Chinese nick names of collectibles. (Completed progress: t1-t189 and c1-c500)

- Adjusted a huge number of pinyin results display order in the option box in Chinese input mode.

### v2.07 update

- Add [LAlt]+[`] shortcut to quickly open or close the official console.

### v2.06 update

- Regular maintenance update with no significant changes.

### v2.05 update

- Regular maintenance update with no significant changes.

### v2.04 update

- Optimized the Chinese nick names of collectibles. (Completed progress: t1-t189 and c1-c400)

- Adjusted a huge number of pinyin results display order in the option box in Chinese input mode.

### v2.03 update

- From now on, no matter the value of "EnableDebugConsole" in "option.ini" file is either 0 or 1, this console mod always takes effect.

### v2.02 update

- Fixed the issue in version 1.07 update where name search with more than two words would not yield any results.

- Optimized the Chinese nick names of collectibles. (Completed progress: t1-t189 and c1-c250)

- Adjusted a huge number of pinyin results display order in the option box in Chinese input mode.

### v2.01 update

- Added mod collectibles and mod trinkets into the result box.(Index search supported. English-only name search supported. Conditional search fully supported including all five condition names. English-only label search partly supported(active, passive, trinket, familiar, hearts, soulhearts, blackhearts, keys, coins, bombs, special).)

- Added mod cards and mod pills into the result box.(English-only)

- Added the text color of collectibles with quality 5 in item quality display.

- Optimized the Chinese nick names of collectibles. (Completed progress: t1-t189 and c1-c150)

- Adjusted a huge number of pinyin results display order in the option box in Chinese input mode.

### v1.07 update
- Fixed an issue that the result reappeared when the result box was already empty if user added another search word.

### v1.06 update

- Fixed the problem of wrong informational texts in greed mode by command [s] or [stage].

- Added search mode support for command [s] or [stage] in both Chinese and English.

- Adjusted the order of 15 pinyin results in Chinese input mode.

### v1.05 update

- Fixed an issue where certain weapons wouldn't retract while blindfolded, such as Moms Knife, Bone Club and Sumptorium.

### v1.04 update

- Added search mode support for command [sp 6] or [spawn 6] in both Chinese and English.

### v1.03 update

- Fixed an issue where "sp 5.350.[id]+" or "spawn 5.350.[id]+" can not be displayed in the input box.

### v1.02 update

- Added colored text display for [F6] (It was white previously.)

- Fixed the issue that '非店主' label can not be searched.

- Fixed the issue that 'chargetype' condition had an unexpected value.

- Replaced the 'familiars' label for five trinkets to 'familiar' to align with the 'familiar' label for collectibles.

- Replaced the 'lucks' label for a trinket to 'luck' to align with the 'luck' label for collectibles.

- Adjusted the order of one pinyin result in Chinese input mode.

### v1.01 update

- Resolved an issue where the [rep] or [repeat] command did not produce the expected effects.

- Resolved an issue where the [LAlt]+[F1] or [LAlt]+[F2] command can be taken account in the console-display-remain state when game is paused.