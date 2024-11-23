# 三只熊中文控制台 / Szx Chinese Console

### B站视频链接：[https://www.bilibili.com/video/BV16M4y1j7XN](https://www.bilibili.com/video/BV16M4y1j7XN)

### steam创意工坊链接：[https://steamcommunity.com/sharedfiles/filedetails/?id=3001774454](https://steamcommunity.com/sharedfiles/filedetails/?id=3001774454)

## 简介：

这是拥有诸多功能的控制台mod！

（v2.24更新：若安装了IsaacSocket，打开三只熊中文控制台界面时游戏会完全暂停）

（v2.21更新：你无需将全屏[F]、静音[M]、暂停[P]三个按键改为[F9][F10][F11]，输入指令时不再触发全屏、静音、暂停效果）

（v2.03更新：你无需在option.ini文件中把以撒的官方控制台关闭，也可以正常使用本控制台mod）

简要的操作说明我会列在下面，对于具体的控制台功能详情，可以来看我的b站视频，我叫'enthusiasmgame'。视频讲解地会比较细致，也更加容易理解~

有任何问题欢迎在讨论区留言，祝大家玩的愉快！

## 按键介绍：
### 控制台基本功能按键：

- [`] 打开控制台(无延迟)(这意味着你可以立即按快捷指令、关闭控制台或其他操作)

- [LAlt]+[`] 打开或关闭官方控制台

- [Enter/KpEnter] 在输入框为空时关闭控制台(无延迟)

- [Esc] 关闭控制台

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

- [F4] 键盘映射 {打开/关闭}

- [F5] 测试模式(用于调试和测试) {打开/关闭}

- [F6] 功能选项菜单

    - [F1] 道具品级文字显示 {打开/关闭} （长按[Tab]在道具底座上显示，表明道具品质等级）

    - [F2] debug文字显示 {打开/关闭} （启用debug3、4、8、9、10时显示）

    - [F3] 道具池图片显示 {打开/关闭} （长按[Tab]在道具底座上显示，表明道具所属道具池）

    - [F4] 道具池图片显示参数设置

        - [F1] 致盲诅咒时仍显示道具池 {打开/关闭}

        - [F2] 角色拥有混沌时仍显示道具池 {打开/关闭}

    - [F5] 调整控制台内的文字/图像位置

        - [F1] 调整控制台主体的位置

        - [F2] 调整键盘映射的位置

        - [F3] 调整debug3的文字位置

        - [F4] 调整debug8的文字位置

        - [F5] 调整debug4和9的文字位置

    - [F6] 控制台打印文字淡出 {打开/关闭}

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

#### 三只熊中文控制台会记录每一局游戏的种子，以及对应的游戏模式和开局角色（包括mod角色），玩家可以输入：

- [ls]或[listseed] 查看种子记录

- [ds]或[deleteseed] 删除部分种子记录

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

## 搜索模式介绍：（英文字母不区分大小写）

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

## 若您订阅并打开了IsaacSocket这个mod，并且正确启动了IsaacSocket连接工具，你可以使用以下额外功能：

- 打开三只熊中文控制台界面时游戏会完全暂停

- 不再能使用mod内置的中文输入法，但能直接使用系统中文输入法输入任何字或词(只要该字符在字体库中就会显示)

- 在游戏内暂停菜单也可以按[`]呼出三只熊中文控制台界面

- 在官方控制台内按下[LCtrl+c]复制当前输入框内容到系统剪贴板

- 在三只熊中文控制台内按下[LCtrl+c]复制当前输入框内容到系统剪贴板

- 在三只熊中文控制台内按下[LCtrl+v]将系统剪贴板纯文字黏贴到当前输入框中，并依次执行换行符前语句

- 使用[eden]指令修改伊甸币数量

- 使用[vac]指令查看解锁/未解锁成就编号

- 使用[uac]或[lac]指令解锁/锁上指定编号成就或全部成就

- 使用[dnt]或[gdnt]指令修改捐款机/贪婪捐款机数量

- 使用[speed]指令修改游戏速度（若游戏速度不为1，右上角会有游戏速度实时文字显示）

- 若游戏速度不为1，按下[Ins]快速还原游戏速度(因为过快或过慢的游戏速度将难以使用控制台还原游戏速度)

- 使用[adc]或[fdc]指令新建或释放调试控制台（和游戏程序绑定）

- 使用[output]指令输出文字至调试控制台

- 使用[lualua]指令，重置lua环境

- debug文字显示始终与实际游戏一致，不会受rewind等因素影响

## 三只熊中文控制台向全体mod作者开放了接口：

    _SZX_CHINESE_CONSOLE_.setModItemChineseName(tbl)

- 按照下面的格式将mod道具/饰品/卡牌/胶囊的信息放入一个表中，传入上面这个接口函数，即可在三只熊中文控制台内显示其中文名，并支持包含中文的名称搜索：

- 作为接口函数参数的表中每个元素均为表，代表一个物品，每个子表包含两个元素，第一个元素代表物品类别和该局游戏内的序号（前缀"c""t""k""p"分配代表道具、饰品、卡牌、胶囊），第二个元素为该物品的中文名称

### 示例代码：

    local tbl = {
    {"c733", "这局游戏733号道具的中文名"},
    {"t190", "这局游戏190号饰品的中文名"},
    {"k98", "这局游戏98号卡牌的中文名"},
    {"p50", "这局游戏50号胶囊的中文名"}
    }
    _SZX_CHINESE_CONSOLE_.setModItemChineseName(tbl)

### 兼容EID：

- 若制作mod物品的作者没有在其代码中使用本接口，但兼容了EID，那么玩家在开启EID的情况下仍然可在三只熊中文控制台内查看其物品中文名，并支持包含中文的名称搜索

## 更新日志：

### v3.02更新

- 扩充了中文输入字库

### v3.01更新

- 增加了[ls]查看种子记录和[ds]删除部分种子记录的指令（现在起三只熊中文控制台会记录每一局游戏的种子，以及对应的游戏模式和开局角色（包括mod角色））

- 增加了调整控制台位置、键盘映射位置、debug文字位置的功能（[F6]功能选项菜单内）

- 增加了[F6]功能选项菜单及其各级子菜单中的恢复默认按键

- 增加了开关控制台打印文字淡出的功能选项设置（[F6]功能选项菜单内）

- 修复了使用[F7]快速输入的"ban "指令在移动光标时出现的报错问题

### v2.36更新

- 修复了[debug]或[d]指令传入参数不合法时的报错问题

- 修复了[dnt]和[gdnt]指令清空游戏内置计数器的问题

### v2.35更新

- 修复了在三只熊中文控制台内输入本应显示报错信息的部分lua命令在输入后报错信息不显示并引起额外报错的问题

### v2.34更新

- 优化了右上角实际游戏速度的显示逻辑

- 修复了在IsaacSocket运行时长按键盘输入文字过快的问题

- 适配最新的IsaacSocket连接程序

### v2.33更新

- 修复了在三只熊中文控制台界面读取历史指令的操作中可能出现的报错问题

- 修复了修改游戏速度指令[speed]在1.0以上游戏速度可能失效的问题

- 查看解锁/未解锁成就指令[vac]的显示文字增加一次换行

- 增加了快速还原游戏速度按键[Ins]（过快或过慢的游戏速度将难以使用控制台还原游戏速度）

- 增加了右上角实际游戏速度的显示（若使用了[speed]指令）

- 适配最新的IsaacSocket连接程序

### v2.32更新

- 更改了三只熊中文控制台主界面[F6]效果，现在起[F6]为功能选项菜单

- 增加了底座道具的道具池显示功能，在[F6]功能选项菜单中可以开关此选项

- 取消了[Ins]快捷键，并将其效果合并入[F6]功能选项菜单中

- 更改了部分搜索栏文字

- 优化了修改捐款数量、修改贪婪捐款数量的逻辑，便于用户理解

- 增加了一个额外指令：修改游戏速度(需要安装IsaacSocket)

### v2.31更新

- 现在起开启新的一局游戏不再将搜索框语言重置为英文

- 增加了修改捐款数量、修改贪婪捐款数量，共两个指令(需要安装IsaacSocket)

### v2.30更新

- 修复了v2.23更新导致的当测试模式[F5]已打开时开启新的一局游戏后仍会视为测试模式已打开的问题

### v2.29更新

- 修复了在新游戏第一帧逻辑帧之前三只熊中文控制台界面可能出现的问题

### v2.28更新

- 增加了解锁成就、锁上成就、查看解锁/未解锁成就，共三个指令(需要安装IsaacSocket)

- 更改了新建调试控制台和释放调试控制台的指令缩写

### v2.27更新

- 优化了部分搜索栏界面显示逻辑

- 现在起若安装了IsaacSocket，可以使用电脑中文输入法输入任何字或词(只要该字符在字体库中就会显示)

- 现在起若安装了IsaacSocket，可以进入三只熊中文控制台主界面第四页，增加了四条额外指令，包括修改伊甸币数量、新建调试控制台、释放调试控制台、输出文字至调试控制台

### v2.26更新

- 增加了使用[LAlt]+[num1-9或num0]快捷操作后的顶部提示信息

- 增加了rep或repeat指令生效后的提示信息，包括指令内容与生效次数

- 修复了rep或repeat指令在开启新的一局游戏后失效的问题

- 修复了rep或repeat指令在IsaacSocket安装时不能正确执行用户期望指令的问题

- 修复了[LAlt]+[num1-9或num0]快捷操作在IsaacSocket安装时不能正确执行用户期望指令的问题

- 适配最新的IsaacSocket连接程序，优化部分代码逻辑

- 现在起若安装了IsaacSocket，在官方控制台内按[LCtrl+c]也会复制当前文字(在三只熊中文控制台内按[LCtrl+c]同样会复制当前文字)

- 现在起若安装了IsaacSocket，在游戏内暂停菜单也可以按[`]呼出三只熊控制台

- 现在起若安装了IsaacSocket，[stage]指令和[giveitem k],[g k],[giveitem2 k],[g2 k]指令会立刻执行，与官方控制台效果一致(若您未安装IsaacSocket则所有指令均会立即执行，因为游戏不会暂停)

### v2.25更新

- 现在起若安装了IsaacSocket，现在lua语句、luamod语句和lualua指令也会在三只熊中文控制台界面立刻执行(游戏完全暂停)

### v2.24更新

- 增加[F1][LAlt+F1][F2][LAlt+F2][F3][F4][F5][F6][Ins]按下后的顶部文字显示

- 增加在三只熊中文控制台内[LCtrl+c]按下后的顶部文字显示(该复制功能需要安装IsaacSocket实现)

- 取消[F6][Ins]和控制台内[LCtrl+c]按下后的角色快乐/悲伤动画

- 现在起若安装了IsaacSocket，打开三只熊中文控制台界面时游戏会完全暂停

### v2.23更新

- 由于以撒官方游戏漏洞，导致无法捕获和改变“加入2p”这个操作，手柄玩家在输入指令后按[Enter]键仍然会召唤出2p玩家或2p宝宝的问题暂时无法解决，手柄玩家建议使用[小键盘Enter]来输入指令

- 现在即便大退以撒游戏，重载本模组，甚至游戏崩溃，历史指令仍然会被保存(按[上]键调用)

- 现在开启一局新的游戏或长按r键不再清空显示框内的历史文字信息

- 现在#d3、#d4、#d8、#d9、#d10的文字显示是否开启不再随着每一局新游戏而默认启动，而是会保存设置（仍然按[Ins]键打开/关闭）

- 现在长按[Tab]显示道具品质是否开启不再随着每一局新游戏而默认启动，而是会保存设置（仍然在打开控制台时按[F6]键打开/关闭）

- 现在键盘映射是否开启不再随着每一局新游戏而默认启动，而是会保存设置（仍然在打开控制台时按[F4]键打开/关闭）

- 现在如果本模组在游戏内被重载，控制台种类会和重载前保持一致而不是默认的三只熊中文控制台

- 增加了"lualua"指令，若安装了IsaacSocket将调用其ReloadLua()函数，即重置lua环境

- 修复了有时输入中文打不了字或者光标不能正确移动的问题

### v2.22更新

- 修复了v2.21更新后手柄玩家在输入指令后按[Enter]键仍然会召唤出2p玩家或2p宝宝的问题

### v2.21更新

- 现在起无需将全屏[F]、静音[M]、暂停[P]三个按键改为[F9][F10][F11]，也可以正常使用本控制台mod（不会在输入指令时触发全屏、静音、暂停效果）

- 现在起[Esc]键按一次即可关闭三只熊中文控制台（在输入框为空时按[Enter]或[小键盘Enter]也仍然支持）

- 现在起在死亡结算画面时，三只熊中文控制台若处于打开状态，按[Esc]和[Enter]不再开启新的一局，而是如期望一致，关闭控制台或执行输入框指令

- 现在起在死亡结算画面时，玩家不仅可以执行"rew"或"rewind"指令，也可以执行lua指令（包括"l print()"）（若您安装了IsaacSocket，[ctrl+v]黏贴功能中换行符前的lua语句也会被依次执行）

- 优化了[LAlt]+[`]切换官方控制台或三只熊中文控制台的处理逻辑与显示界面，并附有文字提示

- 修复了在三只熊中文控制台开启时，按[LAlt]+[`]切换官方控制台，三只熊中文控制台不消失的问题

- 修复了手柄玩家在输入指令后按[Enter]键会召唤出2p玩家或2p宝宝的问题

### v2.20更新

- 修复了print函数可能带来的游戏卡顿问题

- 修复了未使用蒙眼状态修改功能[F3]时蒙眼状态和其它模组的兼容问题

- 兼容了IsaacSocket模组中对于DebugFlag的修改并且在IsaacSocket开启情况下#d4、#d8、#d9、#d10的文字显示能始终保证与实际情况一致

- 优化了print函数显示文字缓慢消失效果的动效

- 限制了print函数输出结果在三只熊中文控制台中保留的最大条数

### v2.19更新

- 增加了print函数的控制台内显示输出文字（无论print函数的来源是三只熊中文控制台，官方控制台，或者其它mod）

- 增加了print函数显示文字的缓慢消失效果（当配置文件的FadedConsoleDisplay=1时）

### v2.18更新

- 兼容了EID的mod物品中文名称，先前的接口也仍然保留（对于mod作者而言仍然推荐你既兼容EID，又使用我上次更新的接口，这样无论玩家是否开启EID，均可以在本控制台中显示以及搜索物品中文名称）

### v2.17更新

- 修复了v2.16更新的接口无法修改mod卡牌与mod胶囊的中文名称的问题

- 修复了0号胶囊(剧毒臭屁)在搜索框不显示的问题

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

This is a console mod with lots of extra functions.

(v2.24 update：If IsaacSocket is installed, the game will pause completely when opening Szx Chinse Console interface.)

(v2.21 update: You no longer need to change your keys fullscreen [F], mute [M], pause [P] to [F9], [F10], [F11].)

(v2.03 update: You no longer need to disable Isaac's official console in the 'option.ini' file.)

Brief instructons of the mod will be showed below. For details of the specific console functions, you can watch my video in bilibili. My id is 'enthusiasmgame'. The 5-minute-long promotional video id in blibili is 'BV16M4y1j7XN'. The effects of this mod in video will be more intuitive and easier to understand~

If you have any questions, please leave a message in the discussion forum. Wish you have a good game in the mod.

## Key introduction:

### Console basic keys:

- [`] open the console(no delay)(which means you can immediately hit quick command, close the console or perform other actions)

- [LAlt]+[`] open or close the official console

- [Enter/KpEnter] close the console when input is empty(no delay)

- [Esc] close the console

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

- [F4] keyboard overlay {on/off}

- [F5] test mode (used for debugging or testing) {on/off}

- [F6] functional options menu {on/off}

    - [F1] Item quality text display {On/Off} (Hold [Tab] to display the item quality on the item pedestal)

    - [F2] Debug text display {On/Off} (Displays when debug 3, 4, 8, 9, 10 are enabled)

    - [F3] Item pool image display {On/Off} (Hold [Tab] to display the item pool on the item pedestal)

    - [F4] Item pool image display settings

        - [F1] Display item pool even with Curse of the Blind {On/Off}

        - [F2] Display item pool even when the character has Chaos {On/Off}

    - [F5] Adjust text/image position in the console

        - [F1] Adjust the main console position

        - [F2] Adjust the keyboard overlay position

        - [F3] Adjust the text position for debug 3

        - [F4] Adjust the text position for debug 8

        - [F5] Adjust the text position for debug 4 and debug 9

    - [F6] Console text fade-out {On/Off}

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

#### Szx Chinese Console will record the seed for each game, along with the corresponding game mode and starting character (including mod characters). Players can input:

- [ls] or [listseed] to view seed records
- [ds] or [deleteseed] to delete partial seed records

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

## If you have subscribed to and activated the IsaacSocket mod, and successfully started the IsaacSocket connection tool, you can access the following additional features:

- The game will completely pause when Szx Chinese Console interface is opened.

- You will no longer be able to use the mod's built-in Chinese input method, but you can directly use your system's Chinese input method to input any characters or words (as long as the character is included in the font library, it will display).

- You can press [`] to bring up Szx Chinese Console interface from the in-game pause menu.

- Press [LCtrl+c] in the official console to copy the current input box content to the system clipboard.

- Press [LCtrl+c] in Szx Chinese Console to copy the current input box content to the system clipboard.

- Press [LCtrl+v] in Szx Chinese Console to paste plain text from the system clipboard into the current input box, and execute statements in sequence based on line breaks.

- Use [eden] command to modify Eden tokens.

- Use [vac] command to view the achievement numbers for unlocked/locked achievements.

- Use [uac] or [lac] commands to unlock or lock specific or all achievements.

- Use [dnt] or [gdnt] commands to modify donation amounts in Donation Machine or Greed Machine.

- Use [speed] command to modify game speed (if the game speed is not 1, a real-time speed indicator will be shown in the upper right corner).

- If the game speed is not set to 1, press [Ins] to quickly restore the game speed (Too fast or too slow game speed may make it difficult to restore the game speed using the console).

- Use [adc] or [fdc] commands to allocate or release a debug console (bound to the game program).

- Use [output] command to output text to the debug console.

- Use [lualua] command to reset the Lua environment.

- Debug text will always stay in sync with the actual game, unaffected by actions like rewinding.

## Szx Chinese Console has opened an interface to all mod authors:

    _SZX_CHINESE_CONSOLE_.setModItemChineseName(tbl)

- You can display the Chinese names of mod collectibles/trinkets/cards/pills in Szx Chinese Console and enable name search in Chinese by passing the item information in a table formatted as follows to the interface function above. 

- Each element in the table passed as a function parameter represents an item and is itself a table containing two elements: the first element represents the item category and its ID in the current game (prefixes "c", "t", "k", and "p" correspond to collectibles, trinkets, cards, and pills respectively), and the second element is the Chinese name of that item.

### Example code:

    local tbl = {
    {"c733", "Chinese name of collectible 733 in this game"},
    {"t190", "Chinese name of trinket 190 in this game"},
    {"k98", "Chinese name of card 98 in this game"},
    {"p50", "Chinese name of pill 50 in this game"}
    }
    _SZX_CHINESE_CONSOLE_.setModItemChineseName(tbl)

### EID Compatibility:

- If a mod author does not use this interface in their code but has made their mod compatible with EID, players will still be able to view Chinese item names and search for them in Szx Chinese Console when EID is enabled.

## Changelog:

### v3.02 update

- Expanded characters in Chinese input mode.

### v3.01 update

- Added the commands [ls] to view seed records and [ds] to delete partial seed records (from now on, Szx Chinese Console will record the seed, game mode, and starting character (including mod characters) for each game).

- Added features to adjust the position of the console, keyboard overlay, and debug texts (available in the [F6] functional options menu).

- Added a "reset to default" button in the [F6] function options menu and all its submenus.

- Added an option to toggle console text fade-out (available in the [F6] functional options menu).

- Fixed an error that occurred when moving the cursor while using the [F7] quick input "ban " command.

### v2.36 update

- Fixed the issue where the [debug] or [d] command would throw an error when invalid parameters were passed.

- Fixed the issue where the [dnt] and [gdnt] commands would reset the in-game counters.

### v2.35 update

- Fixed an issue in Szx Chinese Console where certain Lua commands that were supposed to display error messages did not show the error messages and caused additional errors after being entered.


### v2.34 update

- Optimized the display logic for the actual game speed in the top right corner.

- Fixed the issue of typing text too quickly while running IsaacSocket.

- Updated compatibility with the latest IsaacSocket connection program.

### v2.33 update

- Fixed an issue in Szx Chinese Console interface where errors could occur while reading historical commands.

- Fixed an problem with the [speed] command, where adjusting the game speed above 1.0 could result in ineffectiveness.

- Added an extra line break to the display text of the [vac] command when viewing unlocked/locked achievements.

- Added a hotkey [Ins] for quickly restoring the game speed (Too fast or too slow game speed may make it difficult to restore the game speed using the console).

- Added a display of the actual game speed in the top right corner (if the [speed] command is used).

- Updated compatibility with the latest IsaacSocket connection program.

### v2.32 update

- Changed [F6] effect from Szx Chinese Console main interface; from now on, [F6] will serve as the functional options menu.

- Added an item pool display function; this option can be toggled in the [F6] functional options menu.

- Removed the [Ins] shortcut key and merged its effect into the [F6] functional options menu.

- Updated some search bar text.

- Optimized the logic for modifying donation amounts in Donation Machine or Greed Machine.

- Added an additional command: Modify Game Speed (IsaacSocket installation required).

### v2.31 update

- Starting from now, starting a new game will no longer reset the search box language to English.

- Added two commands: modify donation amounts in Donation Machine or Greed Machine (IsaacSocket installation required).

### v2.30 update

- Fixed the issue introduced in v2.30 update where, when the test mode [F5] was already open, starting a new game would still be considered as the test mode being open.

### v2.29 update

- Fixed potential issues with the interface of Szx Chinese Console before the first logic frame in a new game.

### v2.28 update

- Added three commands: unlock achievements, lock achievements, and view locked/unlocked achievements.(IsaacSocket installation required)

- Changed the command abbreviations for allocating a debug console and releasing the debug console.

### v2.27 update
- Optimized the display logic for some search bar interfaces.

- From now on, if IsaacSocket is installed, you can use the Chinese keyboard of the computer system to input any character or word (as long as the character is in the font library, it will be displayed).

- From now on, if IsaacSocket is installed, you can access the fourth page of Szx Chinese Console main interface, which adds four additional commands, including modifying the amount of Eden Tokens, allocating a debug console, releasing the debug console, and outputting text to the debug console.

### v2.26 update

- Added top prompts for [LAlt]+[num1-9 or num0] opration.

- Added prompts for the effective use of the 'rep' or 'repeat' command, including the command content and the number of times it has been effective.

- Fixed the issue where the 'rep' or 'repeat' command becomes ineffective after starting a new game.

- Fixed the issue where the 'rep' or 'repeat' command does not correctly execute user-expected commands when IsaacSocket is installed.

- Fixed the issue where the [LAlt]+[num1-9 or num0] operation does not correctly execute user-expected commands when IsaacSocket is installed.

- Adapted to the latest IsaacSocket connection program and optimized some code logic.

- From now on, if IsaacSocket is installed, pressing [LCtrl+c] in the official console will copy the current text. (In Szx Chinese Console, pressing [LCtrl+c] will also copy the current text.)

- From now on, if IsaacSocket is installed, Szx Chinese Console interface can be opened even in the in-game pause menu by pressing [`].

- From now on, if IsaacSocket is installed, the [stage] command and [giveitem k], [g k], [giveitem2 k], [g2 k] commands will execute immediately, consistent with the official console. (If you do not have IsaacSocket installed, all commands will execute immediately because the game will not pause.)

### v2.25 update

- Starting now, if IsaacSocket is installed, Lua statements, Luamod statements, and 'lualua' command will now be executed immediately in Szx Chinse Console interface while the game is completely paused.

### v2.24 update

- Added display of top text after pressing [F1], [LAlt+F1], [F2], [LAlt+F2], [F3], [F4], [F5], [F6], [Ins].

- Added display of top text after pressing [LCtrl+c] in Szx Chinese Console (copy function requires IsaacSocket installation).

- Removed character happy/sad animations after pressing [F6], [Ins], and [LCtrl+c] in Szx Chinese Console.

- Starting now, if IsaacSocket is installed, the game will pause completely when opening Szx Chinse Console interface.

### v2.23 update

- Due to a bug in "The Binding of Isaac Rebirth", the "Join 2p" operation cannot be captured and modified, causing an issue where pressing the [Enter] key after entering commands still summons player 2 or player 2 Baby. This problem is temporarily unresolved, and controller players are advised to use the [Numpad Enter] key to input commands.

- Now even if Isaac game is exited, the mod is reloaded, or the game crashes, the command history is still saved and can be recalled by pressing the [Up] key.

- Starting a new game or holding the 'R' key no longer clears the display box of history commands.

- The display of text for #d3, #d4, #d8, #d9, #d10 will no longer default to activate with each new game; instead, the settings will be saved (still toggled with the [Ins] key).

- The function of item quality display with long-press [Tab] will no longer default to activate with each new game; instead, the setting will be saved (still toggled with [F6] when opening the console).

- The keyboard mapping will no longer default to activate with each new game; instead, the setting will be saved (still toggled with [F4] when opening the console).

- If the mod is reloaded in-game, the console type will remain consistent with the type before the reload, instead of defaulting to Szx Chinese Console.

- Added the "lualua" command, which, if IsaacSocket is installed, will invoke its ReloadLua() function, resetting the Lua environment.

- Fixed an issue where sometimes Chinese characters couldn't be typed or the cursor couldn't move correctly.

### v2.22 update

- Fixed an issue in version 2.21 where players using controllers would still summon player 2 or player 2 Baby after entering commands and pressing the [Enter] key.

### v2.21 update

- Starting now, there is no need to remap the fullscreen [F], mute [M], and pause [P] keys to [F9], [F10], [F11]. (Fullscreen, mute, or pause effects will not be triggered while entering commands in Szx Chinese Console.)

- The [Esc] key now closes Szx Chinese Console with a single press. (Pressing [Enter] or [Numpad Enter] in an empty input field remains supported.)

- During the death settlement screen, if Szx Chinese Console is open, pressing [Esc] and [Enter] will no longer initiate a new game. Instead, it will consistently close the console or execute the input command.

- Players, during the death settlement screen, can now execute both "rew" or "rewind" commands and Lua commands (including "l print()"). (If IsaacSocket is installed, pressing [Ctrl+V] in the paste function will execute all Lua statements before the line break.)

- Optimized the logic and display interface for switching between the official console and Szx Chinese Console using [LAlt]+[`], complete with added text prompts.

- Resolved an issue where, with Szx Chinese Console open, switching to the official console using [LAlt]+[`] did not make Szx Chinese Console disappear.

- Fixed a problem where controller players, after entering a command and pressing [Enter], would summon player 2 or player 2 Baby.

### v2.20 update

- Fixed the game lag issue caused by the print function.

- Resolved compatibility issues with the blindfold state modification feature [F3] when not in use, ensuring compatibility with other mods.

- Adapted to modifications in the IsaacSocket module regarding DebugFlag adjustments. When IsaacSocket is active, the text display for #d4, #d8, #d9, #d10 consistently reflects the actual in-game situation.

- Optimized the gradual fading effect for printed text.

- Limited the maximum lines of the print function output in Szx Chinese Console.

### v2.19 update

- Added the display of printed text in the console for the print function (regardless of its source, whether it's from Szx Chinese Console, the official console, or other mods).

- Implemented a gradual fading effect for printed text when the "FadedConsoleDisplay" configuration setting is set to 1.

### v2.18 update

- Compatibility with EID for mod items' Chinese names, while retaining the previous interface. (For mod authors, it is still recommended to both be compatible with EID and utilize the interface in the last update version, so that regardless of whether players have EID enabled, items' Chinese names can be displayed and searched in this console mod).

### v2.17 update

- Fixed the issue where the interface introduced in v2.16 couldn't modify the Chinese names of mod cards and pills.

- Fixed the issue where the 0th pill(Bad Gas) does not displayed in the search box.

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