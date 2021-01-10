mods = GLOBAL.rawget(GLOBAL, "mods")
if not mods then
	mods = {}
	GLOBAL.rawset(GLOBAL, "mods", mods)
end
mods.RussianLang = {}
local t = mods.RussianLang
t.modinfo = modinfo
--Путь, по которому будут сохраняться рабочие версии po файла и лога обновлений.
--Он нужен потому, что сейчас при синхронизации стим затирает все файлы в папке мода на версии из стима.
t.StorePath = MODROOT--"scripts/languages/"
t.UpdateLogFileName = "updatelog.txt"
t.MainPOfilename = "russian.po"
t.DeclensionsPOfilename = "declensions.po"
--t.ROG_POfilename = "ROG.po"
--t.SW_POfilename = "SW.po"
--t.HAM_POfilename = "HAM.po"
t.UpdatePeriod = {"OncePerLaunch","OncePerDay","OncePerWeek","OncePerMonth","Never"}
t.SteamURL = "https://steamcommunity.com/sharedfiles/filedetails/?id=1562475986"

io = GLOBAL.io
STRINGS = GLOBAL.STRINGS
tonumber = GLOBAL.tonumber
tostring = GLOBAL.tostring
assert = GLOBAL.assert
rawget = GLOBAL.rawget
require = GLOBAL.require
dumptable = GLOBAL.dumptable
GetPlayer = GLOBAL.GetPlayer


t.ROG_Installed = rawget(GLOBAL,"REIGN_OF_GIANTS") and GLOBAL.IsDLCEnabled and GLOBAL.IsDLCEnabled(GLOBAL.REIGN_OF_GIANTS)
t.SW_Installed = rawget(GLOBAL,"CAPY_DLC") and GLOBAL.IsDLCEnabled and GLOBAL.IsDLCEnabled(GLOBAL.CAPY_DLC)
t.H_Installed = rawget(GLOBAL,"PORKLAND_DLC") and GLOBAL.IsDLCEnabled and GLOBAL.IsDLCEnabled(GLOBAL.PORKLAND_DLC)


function GLOBAL.escapeR(str) --Удаляет \r из конца строки. Нужна для строк, загружаемых в юниксе.
	if string.sub(str,#str)=="\r" then return string.sub(str,1,#str-1) else return str end
end
local escapeR=GLOBAL.escapeR



--В этой функции происходит загрузка, подключение и применение русских шрифтов
function ApplyRussianFonts()
	--Имена шрифтов, которые нужно загрузить.
	local RusFontsFileNames={"talkingfont__ru.zip",
				 "stint-ucr50__ru.zip",
				 "stint-ucr20__ru.zip",
				 "opensans50__ru.zip",
				 "belisaplumilla50__ru.zip",
				 "belisaplumilla100__ru.zip",
				 "buttonfont__ru.zip"}
	if GLOBAL.rawget(GLOBAL,"TALKINGFONT_WATHGRITHR") then
		table.insert(RusFontsFileNames,"talkingfont_wathgrithr__ru.zip")
	end
	if GLOBAL.rawget(GLOBAL,"TALKINGFONT_WORMWOOD") then
		table.insert(RusFontsFileNames,"talkingfont_wormwood__ru.zip")
	end
	--ЭТАП ВЫГРУЗКИ: Вначале выгружаем шрифты, если они были загружены

	--Возвращаем в глобальные переменные шрифтов родные алиасы, которые точно работают,
	--чтобы не выкинуло при перезагрузке
	GLOBAL.DEFAULTFONT = "opensans"
	GLOBAL.DIALOGFONT = "opensans"
	GLOBAL.TITLEFONT = "bp100"
	GLOBAL.UIFONT = "bp50"
	GLOBAL.BUTTONFONT="buttonfont"
	GLOBAL.NUMBERFONT = "stint-ucr"
	GLOBAL.TALKINGFONT = "talkingfont"
	if GLOBAL.rawget(GLOBAL,"TALKINGFONT_WATHGRITHR") then
		GLOBAL.TALKINGFONT_WATHGRITHR = "talkingfont_wathgrithr"
	end
	if GLOBAL.rawget(GLOBAL,"TALKINGFONT_WORMWOOD") then
		GLOBAL.TALKINGFONT_WORMWOOD = "talkingfont_wormwood"
	end
	GLOBAL.SMALLNUMBERFONT = "stint-small"
	GLOBAL.BODYTEXTFONT = "stint-ucr"

	--Выгружаем шрифт, и префаб под него
	for i,FileName in ipairs(RusFontsFileNames) do
		GLOBAL.TheSim:UnloadFont("rusfont"..tostring(i))
	end
	GLOBAL.TheSim:UnloadPrefabs({"rusfonts_"..modname})


	--ЭТАП ЗАГРУЗКИ: Загружаем шрифты по новой

	--Формируем список ассетов
	local RusFontsAssets={}
	for i,FileName in ipairs(RusFontsFileNames) do 
		table.insert(RusFontsAssets,GLOBAL.Asset("FONT",MODROOT.."fonts/"..FileName))
	end

	--Создаём префаб, регистрируем его и загружаем
	local RusFontsPrefab=GLOBAL.Prefab("common/rusfonts_"..modname, nil, RusFontsAssets)
	GLOBAL.RegisterPrefabs(RusFontsPrefab)
	GLOBAL.TheSim:LoadPrefabs({"rusfonts_"..modname})

	--Формируем список связанных с файлами алиасов
	for i,FileName in ipairs(RusFontsFileNames) do
		GLOBAL.TheSim:LoadFont(MODROOT.."fonts/"..FileName, "rusfont"..tostring(i))
	end
	--Вписываем в глобальные переменные шрифтов наши алиасы
	GLOBAL.DEFAULTFONT = "rusfont4"
	GLOBAL.DIALOGFONT = "rusfont4"
	GLOBAL.TITLEFONT = "rusfont6"
	GLOBAL.UIFONT = "rusfont5"
	GLOBAL.BUTTONFONT= "rusfont7"
	GLOBAL.NUMBERFONT = "rusfont2"
	GLOBAL.TALKINGFONT = "rusfont1"
	GLOBAL.SMALLNUMBERFONT = "rusfont3"
	GLOBAL.BODYTEXTFONT = "rusfont2"
	if GLOBAL.rawget(GLOBAL,"TALKINGFONT_WATHGRITHR") then
		GLOBAL.TALKINGFONT_WATHGRITHR = "rusfont8"
	end
	if GLOBAL.rawget(GLOBAL,"TALKINGFONT_WORMWOOD") then
		GLOBAL.TALKINGFONT_WORMWOOD = "rusfont9"
	end

end



--Переопределяем функцию закрытия консоли
local OldClose
function NewClose()
	GLOBAL.SetPause(false)
	GLOBAL.TheInput:EnableDebugToggle(true)
	TheFrontEnd:PopScreen()
	--Автоматически скрываем достающий лог (без Ctrl+L)
	TheFrontEnd:HideConsoleLog()
end

--Добавление русских символов в список доступных из консоли
AddClassPostConstruct("screens/consolescreen", function(self) --Выполняем подмену шрифта в спиннере из-за глупой ошибки разрабов в этом виджете
	local NewConsoleValidChars=[[ abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,:;[]<>\@!#$%&()'*+-/=?^_{|}~"абвгдеёжзийклмнопрстуфхцчшщъыьэюяАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯІіЇїЄєҐґ]]
	self.console_edit:SetCharacterFilter( NewConsoleValidChars )
--Включение вставки текста в консоль (и почемму это не включено из коробки?)
	self.console_edit:SetAllowClipboardPaste(true)
--подменяем функцию
	Close=self["Close"]
	self["Close"]=NewClose
end)



Assets={
	Asset("ATLAS",MODROOT.."images/eyebutton.xml"), --Кнопка с глазом
	Asset("ATLAS",MODROOT.."images/gradient.xml"), --Градиент на слишком длинных строках лога в настройках перевода
	Asset("ATLAS",MODROOT.."images/rus_mapgen.xml"), --Русифицированные пиктограммы в окне генерирования нового мира
	--Персонажи
	Asset("ATLAS",MODROOT.."images/rus_locked.xml"), 
	Asset("ATLAS",MODROOT.."images/rus_wickerbottom.xml"), 
	Asset("ATLAS",MODROOT.."images/rus_waxwell.xml"), 
	Asset("ATLAS",MODROOT.."images/rus_willow.xml"), 
	Asset("ATLAS",MODROOT.."images/rus_wilson.xml"), 
	Asset("ATLAS",MODROOT.."images/rus_woodie.xml"), 
	Asset("ATLAS",MODROOT.."images/rus_wes.xml"), 
	Asset("ATLAS",MODROOT.."images/rus_wolfgang.xml"), 
	Asset("ATLAS",MODROOT.."images/rus_wendy.xml"),
	Asset("ATLAS",MODROOT.."images/rus_wagstaff.xml")
}

if t.ROG_Installed or t.SW_Installed or t.H_Installed then
	table.insert(Assets,Asset("ATLAS",MODROOT.."images/rus_wathgrithr.xml"))
	table.insert(Assets,Asset("ATLAS",MODROOT.."images/rus_webber.xml"))
end
if t.SW_Installed or t.H_Installed then
	table.insert(Assets,Asset("ATLAS",MODROOT.."images/rus_walani.xml"))
	table.insert(Assets,Asset("ATLAS",MODROOT.."images/rus_warly.xml"))
	table.insert(Assets,Asset("ATLAS",MODROOT.."images/rus_woodlegs.xml"))
	table.insert(Assets,Asset("ATLAS",MODROOT.."images/rus_wilbur.xml"))
end
if t.H_Installed then
	table.insert(Assets,Asset("ATLAS",MODROOT.."images/rus_warbucks.xml"))
	table.insert(Assets,Asset("ATLAS",MODROOT.."images/rus_wormwood.xml"))
	table.insert(Assets,Asset("ATLAS",MODROOT.."images/rus_wilba.xml"))
	table.insert(Assets,Asset("ATLAS",MODROOT.."images/rus_wheeler.xml"))
end



GLOBAL.getmetatable(GLOBAL.TheSim).__index.UnregisterAllPrefabs = (function()
	local oldUnregisterAllPrefabs = GLOBAL.getmetatable(GLOBAL.TheSim).__index.UnregisterAllPrefabs
	return function(self, ...)
		oldUnregisterAllPrefabs(self, ...)
		ApplyRussianFonts()
	end
end)()

ApplyRussianFonts()

--Вставляем функцию, подключающую русские шрифты
local OldRegisterPrefabs=GLOBAL.ModManager.RegisterPrefabs --Подменяем функцию,в которой нужно подгрузить шрифты и исправить глобальные шрифтовые константы
local function NewRegisterPrefabs(self)
	OldRegisterPrefabs(self)
	ApplyRussianFonts()
	GLOBAL.TheFrontEnd.consoletext:SetFont(GLOBAL.BODYTEXTFONT) --Нужно, чтобы шрифт в консоли не слетал
	GLOBAL.TheFrontEnd.consoletext:SetRegionSize(900, 404) --Чуть-чуть увеличил по вертикали, чтобы не обрезало буквы в нижней строке
end
GLOBAL.ModManager.RegisterPrefabs=NewRegisterPrefabs

--Необходимо подключить русские шрифты в окне создания нового мира
AddClassPostConstruct("screens/worldgenscreen", function(self)
	ApplyRussianFonts()
	--Обновляем два текстовых элемента, которые успели инициализироваться
	self.worldgentext:SetFont(GLOBAL.TITLEFONT)
	self.flavourtext:SetFont(GLOBAL.UIFONT)
end)


GLOBAL.RusUpdatePeriod={"OncePerLaunch","OncePerDay","OncePerWeek","OncePerMonth","Never"}



--Возвращает корректную форму слова день
local function StringTime(n,s)
	local pl_type=n%10==1 and n%100~=11 and 1 or(n%10>=2 and n%10<=4
       		and(n%100<10 or n%100>=20)and 2 or 3)
	s=s or {"день","дня","дней"}
	return s[pl_type]
end 


--Пытается сформировать правильные окончания в словах названия предмета str1 в соответствии действию action
function rebuildname(str1,action,objectname)
	local function repsubstr(str,pos,substr)--вставить подстроку substr в строку str в позиции pos
		pos=pos-1
		return string.sub(str,1,pos)..substr..string.sub(str,pos+#substr+1,#str)
	end
	if not str1 then
		return nil
	end
	local 	sogl=  {['б']=1,['в']=1,['г']=1,['д']=1,['ж']=1,['з']=1,['к']=1,['л']=1,['м']=1,['н']=1,['п']=1,['р']=1,['с']=1,['т']=1,['ф']=1,['х']=1,['ц']=1,['ч']=1,['ш']=1,['щ']=1}

	local sogl2 = {['г']=1,['ж']=1,['к']=1,['х']=1,['ц']=1,['ч']=1,['ш']=1,['щ']=1}
	local sogl3 = {["р"]=1,["л"]=1,["к"]=1,["Р"]=1,["Л"]=1,["К"]=1}

	local animated = {pigman = true, pigguard = true, bunnyman = true, wildbore = true, wildboreguard = true, mermfisher = true, pigman_beautician = true, pigman_florist = true, pigman_erudite = true, pigman_hatmaker = true, pigman_storeowner = true, pigman_banker = true, pigman_collector = true, pigman_hunter = true, pigman_mayor = true, pigman_mechanic = true, pigman_professor = true, pigman_usher = true, pigman_royalguard = true, pigman_royalguard_2 = true, pigman_farmer = true, pigman_miner = true, pigman_queen = true, pigman_beautician_shopkeep = true, pigman_florist_shopkeep = true, pigman_erudite_shopkeep = true, pigman_hatmaker_shopkeep = true, pigman_storeowner_shopkeep = true, pigman_banker_shopkeep = true, pigman_shopkeep = true, pigman_hunter_shopkeep = true, pigman_mayor_shopkeep = true, pigman_farmer_shopkeep = true, pigman_miner_shopkeep = true, pigman_collector_shopkeep = true, pigman_professor_shopkeep = true, pigman_mechanic_shopkeep = true, antman_warrior = true, antman = true, ballphin = true, mandrakeman = true, parrot_pirate = true}
	--
	local pigfemale = {pigman_beautician = true, pigman_florist = true, pigman_erudite = true, pigman_hatmaker = true, pigman_storeowner = true, pigman_beautician_shopkeep = true, pigman_florist_shopkeep = true, pigman_erudite_shopkeep = true, pigman_hatmaker_shopkeep = true, pigman_storeowner_shopkeep = true}
	local seeds = {SEEDS = true, CORN_SEEDS = true, WATERMELON_SEEDS = true, CARROT_SEEDS = true, DRAGONFRUIT_SEEDS = true, DURIAN_SEEDS = true, EGGPLANT_SEEDS = true, POMEGRANATE_SEEDS = true, PUMPKIN_SEEDS = true, SWEET_POTATO_SEEDS = true, COFFEEBEANS = true, DEERCLOPS_EYEBALL = true, COONTAIL = true, ALOE_SEEDS = true, ASPARAGUS_SEEDS = true, RADISH_SEEDS = true}
	local resstr=""
	local delimetr
	local wasnoun=false
	local wordcount=#(str1:gsub("[%s-]","~"):split("~"))
	local counter=0
	local FoundNoun

	for str in string.gmatch(str1.." ","[А-Яа-яЁёA-Za-z0-9#%%'%.]+[%s-]") do
		counter=counter+1
		delimetr=string.sub(str,#str)
		str=string.sub(str,1,#str-1)
		if action=="WALKTO" then --идти к (кому? чему?) Дательный
			if str=="Конрой" then
				str="Конрою"
			elseif str=="Шарки" then
				str="Шарки"
			elseif string.sub(str,#str-1)=="ая" and resstr=="" then
				str=repsubstr(str,#str-1,"ой")
			elseif string.sub(str,#str-1)=="ая" then
				str=repsubstr(str,#str-1,"ей")
			elseif string.sub(str,#str-1)=="яя" then
				str=repsubstr(str,#str-1,"ей")
			elseif string.sub(str,#str-1)=="ец" then
				str=repsubstr(str,#str-1,"цу")
			elseif string.sub(str,#str-1)=="ый" then
				str=repsubstr(str,#str-1,"ому")
			elseif string.sub(str,#str-1)=="ий" then
				str=repsubstr(str,#str-1,"ему")
			elseif string.sub(str,#str-1)=="ое" then
				str=repsubstr(str,#str-1,"ому")
			elseif string.sub(str,#str-3)=="аяся" then
				str=repsubstr(str,#str-3,"ейся")
			elseif string.sub(str,#str-1)=="ее" then
				str=repsubstr(str,#str-1,"ему")
			elseif string.sub(str,#str-1)=="ые" then
				str=repsubstr(str,#str-1,"ым")
			elseif string.sub(str,#str-1)=="ье" and counter<wordcount then
				str=repsubstr(str,#str-1,"ьему")
			elseif string.sub(str,#str-1)=="ой" and resstr=="" then
				str=repsubstr(str,#str-1,"ому")
			elseif string.sub(str,#str-1)=="ья" and resstr=="" then
				str=repsubstr(str,#str-1,"ьей")
			elseif string.sub(str,#str-2)=="орь" then
				str=string.sub(str,1,#str-3).."рю"
			elseif string.sub(str,#str-2)=="вей" then
				str=string.sub(str,1,#str-3).."вью"
			elseif string.sub(str,#str-1)=="ек" then
				str=string.sub(str,1,#str-2).."ку"
				wasnoun=true
			elseif string.sub(str,#str-2)=="ень" then
				str=string.sub(str,1,#str-3).."ню"
			elseif string.sub(str,#str-1)=="ок" then
				str=repsubstr(str,#str-1,"ку")
				wasnoun=true
			elseif string.sub(str,#str-1)=="ть" then
				str=repsubstr(str,#str,"и")
				wasnoun=true
			elseif string.sub(str,#str-1)=="вь" then
				str=repsubstr(str,#str,"и")
				wasnoun=true
			elseif string.sub(str,#str-1)=="ль" then
				str=repsubstr(str,#str,"и")
				wasnoun=true
			elseif string.sub(str,#str-1)=="зь" then
				str=repsubstr(str,#str,"и")
				wasnoun=true
			elseif string.sub(str,#str-1)=="нь" then
				str=repsubstr(str,#str,"ю")
				wasnoun=true
			elseif string.sub(str,#str-1)=="рь" then
				str=repsubstr(str,#str,"ю")
				wasnoun=true
			elseif string.sub(str,#str-1)=="ьи" then
				str=str.."м"
			elseif string.sub(str,#str-1)=="ки" and not wasnoun then
				str=repsubstr(str,#str,"ам")
				wasnoun=true
			elseif string.sub(str,#str)=="ы" and not wasnoun then
				str=repsubstr(str,#str,"ам")
				wasnoun=true
			elseif string.sub(str,#str)=="ы" and not wasnoun then
				str=repsubstr(str,#str,"ам")
				wasnoun=true
			elseif string.sub(str,#str)=="а" and not wasnoun then
				str=repsubstr(str,#str,"е")
				wasnoun=true
			elseif string.sub(str,#str)=="я" and not wasnoun then
				str=repsubstr(str,#str,"е")
				wasnoun=true
			elseif string.sub(str,#str)=="о" and not wasnoun then
				str=repsubstr(str,#str,"у")
				wasnoun=true
			elseif string.sub(str,#str-1)=="це" and not wasnoun then
				str=repsubstr(str,#str-1,"цу")
				wasnoun=true
			elseif string.sub(str,#str)=="е" and not wasnoun then
				str=repsubstr(str,#str,"ю")
				wasnoun=true
			elseif sogl[string.sub(str,#str)] and pigfemale[objectname] and not wasnoun then
				wasnoun=true
			elseif sogl[string.sub(str,#str)] and not wasnoun then
				str=str.."у"
				wasnoun=true
			end
		--Изучить (Кого? Что?) Винительный
		--применительно к имени свиньи, кабана или кролика
		elseif action and objectname and animated[objectname] then 
			if string.sub(str,#str-2)=="нок" then
				str=string.sub(str,1,#str-2).."ка"
			elseif string.sub(str,#str-2)=="лец" then
				str=string.sub(str,1,#str-2).."ьца"
			elseif string.sub(str,#str-1)=="ый" then
				str=string.sub(str,1,#str-2).."ого"
			elseif str=="Конрой" then
				str="Конроя"
			elseif string.sub(str,#str-1)=="ой" then
				str=string.sub(str,1,#str-2).."ого"
			elseif string.sub(str,#str-2)=="чий" then
				str=string.sub(str,1,#str-2).."его"
			elseif string.sub(str,#str-1)=="ец" then
				str=string.sub(str,1,#str-2).."ца"
			elseif string.sub(str,#str-1)=="ая" then
				str=string.sub(str,1,#str-2).."ую"
			elseif string.sub(str,#str)=="а" then
				str=string.sub(str,1,#str-1).."у"
			elseif string.sub(str,#str)=="я" then
				str=string.sub(str,1,#str-1).."ю"
			elseif string.sub(str,#str)=="ь" then
				str=string.sub(str,1,#str-1).."я"
			elseif string.sub(str,#str-2)=="вей" then
				str=string.sub(str,1,#str-3).."вья"
			elseif string.sub(str,#str)=="й" then
				str=string.sub(str,1,#str-1).."я"
			elseif sogl[string.sub(str,#str)] and pigfemale[objectname] then
				str=str
			elseif sogl[string.sub(str,#str)] then
				str=str.."а"
			end
		elseif action=="SHOP" and objectname and seeds[objectname] then
			str=str
		elseif action then --Изучить (Кого? Что?) Винительный
			if string.sub(str,#str-1)=="ая" then
				str=repsubstr(str,#str-1,"ую")
			elseif string.sub(str,#str-1)=="яя" then
				str=repsubstr(str,#str-1,"юю")
			elseif string.sub(str,#str)=="а" then
				str=repsubstr(str,#str,"у")
			elseif string.sub(str,#str-3)=="аяся" then
				str=repsubstr(str,#str-3,"уюся")
			elseif string.sub(str,#str)=="я" then
				str=repsubstr(str,#str,"ю")
			end
		end
		resstr=resstr..str..delimetr
	end
	resstr=string.sub(resstr,1,#resstr-1)
	return resstr
end



GLOBAL.testname=function(name, key)
	if name and (not key) and type(name)=="string" and GLOBAL.rawget(STRINGS.NAMES,name:upper()) then key=name:upper() name=STRINGS.NAMES[key] end
	local output = "Идти к "..rebuildname(name,"WALKTO", key).."\n"
	output = output .. "Осмотреть "..rebuildname(name,"DEFAULTACTION", key)
	print("\n"..output.."\n")
	return output
end

--Сохраняет в файле все имена с действием, указанным в параметре action)
GLOBAL.printnames=function(action,obn)
	local filename = MODROOT..action..".txt"
	local names={}
	local f=assert(io.open(MODROOT.."names_new.txt","r"))
	for line in f:lines() do
		local s1
		if action=="DEFAULTACTION" then	
			s1="Осмотреть "
		elseif action=="WALKTO" then
			s1="Идти к "
		end
		s1=s1..rebuildname(line,action,obn).."\r\n"
		table.insert(names,s1)
	end
	f:close()
	local file = io.open(filename, "w")
	for i,v in ipairs(names) do
		file:write(v)
	end
	file:close()
end



t.RussianNames = {} --Таблица с особыми формами названий предметов в различных падежах
t.ActionsToSave = {} --Таблица сохраняет то-же самое, но является массивом и нужна для сохранения po
t.ShouldBeCapped = {} --Таблица, в которой находится список названий, первое слово которых пишется с большой буквы при склонении.

--Загружает список имён, которые должны начинаться с заглавной буквы. Список должен состоять из названий префабов.
function t.LoadCappedNames(data)
	t.ShouldBeCapped={}
	local filename = t.StorePath..t.DeclensionsPOfilename
	if (data and #data==0) or not GLOBAL.kleifileexists(filename) then return nil end
	local insection=false
	local function parseline(line)
		line=escapeR(line)
		if string.sub(line,1,10)=="# --------" then
			insection=string.find(line,"Должны начинаться с заглавной буквы",1,true)
			elseif insection and string.sub(line,1,1)=="#" then
				t.ShouldBeCapped[string.sub(line,2):lower()]=true
			end
		end
		if data then
			for _,line in ipairs(data) do
				parseline(line)
			end
		else
			local f=assert(io.open(filename,"r"))
			for line in f:lines() do
				parseline(line)
			end
			f:close()
		end

	end



t.NamesGender={} --Таблица с списками имён, отсортированными по полам.
t.NamesGender["he"]={}
t.NamesGender["he2"]={}
t.NamesGender["she"]={}
t.NamesGender["it"]={}
t.NamesGender["plural"]={}
t.NamesGender["plural2"]={}
--Загружает списки имён, в четыре таблицы выше. Списки должны состоять из названий префабов.
--Используется для определения окончания префиксов мокрости.
function t.LoadNamesGender(data)
	t.NamesGender={} 
	t.NamesGender["he"]={}
	t.NamesGender["he2"]={}
	t.NamesGender["she"]={}
	t.NamesGender["it"]={}
	t.NamesGender["plural"]={}
	t.NamesGender["plural2"]={}
	local filename = t.StorePath..t.DeclensionsPOfilename
	if (data and #data==0) or not GLOBAL.kleifileexists(filename) then return nil end
	local insection=false
	local part=nil
	local function parseline(line)
		line=escapeR(line)
		if string.sub(line,1,10)=="# --------" then
			insection=string.find(line,"Род и число предметов",1,true)
		elseif insection and string.sub(line,1,1)=="#" then
			if line=="# МУЖСКОЙ:" then part="he" 
			elseif line=="# МУЖСКОЙ 2 КЛАСС:" then part="he2" --одушевлённое в единственном числе мужского рода
			elseif line=="# ЖЕНСКИЙ:" then part="she" 
			elseif line=="# СРЕДНИЙ:" then part="it" 
			elseif line=="# МНОЖЕСТВЕННОЕ ЧИСЛО:" then part="plural"
			elseif line=="# МНОЖЕСТВЕННОЕ ЧИСЛО 2 КЛАСС:" then part="plural2" --одушевлённое во множественном числе (таких сейчас нет)
			elseif part~=nil then
				t.NamesGender[part][string.sub(line,2):lower()]=true
			end
			
		end
	end
	if data then
		for _,line in ipairs(data) do
			parseline(line)
		end
	else
		local f=assert(io.open(filename,"r"))
		for line in f:lines() do
			parseline(line)
		end
		f:close()
	end
end



--Загружает исправленные названия предметов в нужном падеже из po файла. Если указана data, то парсится она
function t.LoadFixedNames(data)
	t.RussianNames={}
	t.ActionsToSave={}

	local filename = t.StorePath..t.DeclensionsPOfilename

	if (data and #data==0) or not GLOBAL.kleifileexists(filename) then return nil end

	local action=nil
	local predcessorword=""
	local f,errorlog=nil,{}

	local function parseline(line)
		line=escapeR(line)
		if string.sub(line,1,10)=="# --------" then --Возможно начинается сегмент с одним из действий
			action=string.match(line,"Действие%s+(.*)%s*$") --Пытаемся вычленить название действия
			if action then
				action=action:upper()
				if action=="DEFAULTACTION" then
					predcessorword="Изучить"
				elseif action=="WALKTO" then
					predcessorword="Идти к"
				elseif action=="KILL" then
					predcessorword="Он был убит"
				else --все другие действия
					predcessorword=GLOBAL.LanguageTranslator.languages["ru"]["STRINGS.ACTIONS."..action] or ""
				end
				t.ActionsToSave[action]={} --создаём таблицу в текущем виде действий.
			end
		elseif action and line~="" and string.sub(line,1,1+#predcessorword)=="#"..predcessorword then
			local translation=string.match(line,predcessorword.." (.-)\t") 
			local original=string.match(line,"\t([^\t]+)\t") 
			local path=string.match(line,"\t([^\t]-)$")

			table.insert(t.ActionsToSave[action],{pth=path,trans=translation,orig=original})
			if t.RussianNames[original] then
				t.RussianNames[original][action]=translation
			else
				t.RussianNames[original]={}
				t.RussianNames[original]["DEFAULT"]=STRINGS.NAMES[path] --вставляем оригинальное имя из ро
				t.RussianNames[original].path=path --добавляем путь
				if action~="DEFAULTACTION" then
					t.RussianNames[original]["DEFAULTACTION"]=rebuildname(original,"DEFAULTACTION")
				end
				if action~="WALKTO" then
					t.RussianNames[original]["WALKTO"]=rebuildname(original,"WALKTO")
				end
				t.RussianNames[original][action]=translation
			end
		end
	end
	if data then
		for _,line in ipairs(data) do
			parseline(line)
		end
	else
		local f=assert(io.open(filename,"r"))
		for line in f:lines() do
			parseline(line)
		end
		f:close()
	end
end


--Делаем бекап названия версии игры
local UPDATENAME=GLOBAL.STRINGS.UI.MAINSCREEN.UPDATENAME

--Загружаем русификацию
LoadPOFile(t.StorePath..t.MainPOfilename, "ru")

--Восстанавливаем название версии игры из бекапа
GLOBAL.LanguageTranslator.languages["ru"]["STRINGS.UI.MAINSCREEN.UPDATENAME"]=UPDATENAME



--делит строку на части по символу-разделителю. Возвращает и пустые вхождения:
--split("|a|","|") вернёт таблицу из "", "а" и ""
--split("а","|") вернёт таблицу из "а"
--split("","|") вернёт таблицу из ""
--split("|","|") вернёт таблицу из "" и ""
--По идее разделителем может служить сразу несколько символов (не тестировалось)
local function split(str,sep)
       	local fields, first = {}, 1
	str=str..sep
	for i=1,#str do
		if string.sub(str,i,i+#sep-1)==sep then
			fields[#fields+1]=(i<=first) and "" or string.sub(str,first,i-1)
			first=i+#sep
		end
	end
        return fields
end


local LetterCasesHash={u2l={["А"]="а",["Б"]="б",["В"]="в",["Г"]="г",["Д"]="д",["Е"]="е",["Ё"]="ё",["Ж"]="ж",["З"]="з",
							["И"]="и",["Й"]="й",["К"]="к",["Л"]="л",["М"]="м",["Н"]="н",["О"]="о",["П"]="п",["Р"]="р",
							["С"]="с",["Т"]="т",["У"]="у",["Ф"]="ф",["Х"]="х",["Ц"]="ц",["Ч"]="ч",["Ш"]="ш",["Щ"]="щ",
							["Ъ"]="ъ",["Ы"]="ы",["Ь"]="ь",["Э"]="э",["Ю"]="ю",["Я"]="я"},
					   l2u={["а"]="А",["б"]="Б",["в"]="В",["г"]="Г",["д"]="Д",["е"]="Е",["ё"]="Ё",["ж"]="Ж",["з"]="З",
							["и"]="И",["й"]="Й",["к"]="К",["л"]="Л",["м"]="М",["н"]="Н",["о"]="О",["п"]="П",["р"]="Р",
							["с"]="С",["т"]="Т",["у"]="У",["ф"]="Ф",["х"]="Х",["ц"]="Ц",["ч"]="Ч",["ш"]="Ш",["щ"]="Щ",
							["ъ"]="Ъ",["ы"]="Ы",["ь"]="Ь",["э"]="Э",["ю"]="Ю",["я"]="Я"}}

--первый символ в нижний регистр
local function firsttolower(tmp)
	if not tmp then return end
	local firstletter=string.sub(tmp,1,1)
	firstletter = LetterCasesHash.u2l[firstletter] or firstletter
	return firstletter:lower()..string.sub(tmp,2)
end

--первый символ в верхний регистр
local function firsttoupper(tmp)
	if not tmp then return end
	local firstletter=string.sub(tmp,1,1)
	firstletter = LetterCasesHash.l2u[firstletter] or firstletter
	return firstletter:upper()..string.sub(tmp,2)
end

function isupper(letter)
	if not letter or type(letter)~="string" then return end
	return LetterCasesHash.u2l[letter] or (#letter==1 and letter>="A" and letter<="Z")
end

function islower(letter)
	if not letter or type(letter)~="string" then return end
	return LetterCasesHash.l2u[letter] or (#letter==1 and letter>="a" and letter<="z")
end

local function russianupper(tmp)
	if not tmp then return end
	local res=""
	local letter
	for i=1,string.len(tmp) do
		letter = string.sub(tmp,i,i)
		letter = LetterCasesHash.l2u[letter] or letter
		res = res..letter:upper()
	end
	return res
end

local function russianlower(tmp)
	if not tmp then return end
	local res=""
	local letter
	for i=1,string.len(tmp) do
		letter = string.sub(tmp,i,i)
		letter = LetterCasesHash.u2l[letter] or letter
		res = res..letter:lower()
	end
	return res
end


--Объявляем таблицу особых тегов, присущих персонажам.
--Порядковый номер тега определяет его приоритет.
GLOBAL.CharacterInherentTags={}
for char in pairs(GLOBAL.GetActiveCharacterList()) do
	GLOBAL.CharacterInherentTags[char]={}
end


--!!!ВРЕМЕННО, РАЗРАБОТЧИКИ ЗАБЫЛИ ДОБАВИТЬ ЭТО
if not table.contains(GLOBAL.CHARACTER_GENDERS.MALE, "warbucks") then table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "warbucks") end
if not table.contains(GLOBAL.CHARACTER_GENDERS.FEMALE, "wilba") then table.insert(GLOBAL.CHARACTER_GENDERS.FEMALE, "wilba") end
if not table.contains(GLOBAL.CHARACTER_GENDERS.MALE, "wagstaff") then table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "wagstaff") end

--Функция ищет в реплике спец-тэги, оформленные в [] и выбирает нужный, соответствующий персонажу char
--Варианты с разным переводом для разного пола оформляются в [] и разделяются символом |.
--В общем случае оформляется так: [мужчина|женщина|оно|множественное число|имя префаба персонажа=его вариант]
--При этом каждый вариант без указания имени префаба определяет свою принадлежность в такой последовательности:
--первый — мужской вариант, второй — женский, третий — средний род, четвёртый — мн. число.
--Имя префаба можно указывать в любом из вариантов (например первом). Тогда оно не берётся в расчёт при анализе
--пустых (без указания имени префаба) вариантов: [wes=он молчун|это мужчина|wolfgang=силач|это женщина|это оно]
--Если в вариантах не указан нужный для char, то берётся вариант мужского пола (кроме webber'а, которому сперва
--попытается подставить вариант множественного числа, и Wx-78, который на русском считается мужским полом),
--если нет и этого, то ничего не подставится.
--Варианты полов можно задавать явно, указывая ключевые слова "he", "she", "it" или "plural"/"they"/"pl".
--Варианты с указанными префабами (и ключевыми словами) можно объединять в группы через запятую:
--[he=мужской|willow,wendy=женский без Уиккерботтом]
--Пример: "Скажи[plural=те], [приятель|милочка|создание|приятели|wickerbottom=дамочка], почему так[ой|ая|ое|ие] грустн[ый|ая|ое|ые]?"
--Необязательный параметр talker сообщает название префаба говорящего. Сейчас нужен для корректной обработки ситуации с Веббером
function t.ParseTranslationTags(message, char, talker, optionaltags)
	if not (message and string.find(message,"[",1,true)) then return message end

	local gender="neutral"
	local function parse(str)
		local vars=split(str,"|")
		local tags={}
		local function SelectByCustomTags(CustomTags)
			if not CustomTags then return false end
			if type(CustomTags)=="string" then return tags[CustomTags] end
			for _,tag in ipairs(CustomTags) do
				if tags[tag] then return tags[tag] end
			end
			return false
		end
		local counter=0
		for i,v in pairs(vars) do
			local vars2=split(v,"=")
			if #vars2==1 then counter=counter+1 end
			local path=(#vars2==2) and vars2[1] or 
			        (((counter==1) and "he")
				or ((counter==2) and "she")
				or ((counter==3) and "it")
				or ((counter==4) and "plural")
				or ((counter==5) and "neutral")
				or ((counter>5) and nil))
			if path then
				local vars3=split(path,",")
				for _,vv in ipairs(vars3) do
					local c=vv and vv:match("^%s*(.*%S)")
					c=c and c:lower()
					if c=="they" or c=="pl" then c="plural"
					elseif c=="nog" or c=="nogender" then c="neutral"
					elseif c=="def" then c="default" end
					if c then tags[c]=(#vars2==2) and vars2[2] or v end
				end
			end
		end
		str=tags and (tags[char] --сначала ищем по имени
			or SelectByCustomTags(GLOBAL.CharacterInherentTags[char]) --потом по особым тегам персонажа
			or tags[gender] --потом пытаемся выбрать по полу персонажа
			or SelectByCustomTags(optionaltags) --потом ищем, есть ли в вариантах дополнительные теги
			or tags["default"] --или берём дефолтный тег
			or tags["neutral"] --если ничего не нашли, пытаемся выбрать нейтральный вариант
			or tags["he"] --если и его нет, то мужской пол (это уже неправильно, но лучше, чем ничего)
			or "") or "" --ладно, ничего, значит ничего
		return str
	end
	local function search(part)
		part=string.sub(part,2,-2)
		if not string.find(part,"[",1,true) then
			part=parse(part)
		else
			part=parse(part:gsub("%b[]",search))
		end
		return part
	end

	--Экранируем тег заглавной буквы
	local CaseAdoptationNeeded
	message, CaseAdoptationNeeded = message:gsub("%[adoptcase]","<adoptcase>")
	--Ищем теги-маркеры, которые нужно добавить в список optionaltags
	message=message:gsub("%[marker=(.-)]",function(marker)
		if not optionaltags then optionaltags={}
		elseif type(optionaltags)=="string" then optionaltags={optionaltags} end
		table.insert(optionaltags,marker)
		return ""
	end)

	if char then
		char=char:lower()
		if char=="generic" then char="wilson" end

		if GLOBAL.rawget(GLOBAL,"CHARACTER_GENDERS") then
			if GLOBAL.CHARACTER_GENDERS.MALE and table.contains(GLOBAL.CHARACTER_GENDERS.MALE, char) then gender="he"
			elseif GLOBAL.CHARACTER_GENDERS.FEMALE and table.contains(GLOBAL.CHARACTER_GENDERS.FEMALE, char) then gender="she"
			elseif GLOBAL.CHARACTER_GENDERS.ROBOT and table.contains(GLOBAL.CHARACTER_GENDERS.ROBOT, char) then gender="he"
			elseif GLOBAL.CHARACTER_GENDERS.IT and table.contains(GLOBAL.CHARACTER_GENDERS.IT, char) then gender="it"
			elseif GLOBAL.CHARACTER_GENDERS.NEUTRAL and table.contains(GLOBAL.CHARACTER_GENDERS.IT, char) then gender="neutral"
			elseif GLOBAL.CHARACTER_GENDERS.PLURAL and table.contains(GLOBAL.CHARACTER_GENDERS.PLURAL, char) then gender="plural" end
		end
		--Если это Веббер и он говорит сам о себе, то это множественное число
		if char=="webber" and (not talker or talker:lower()==char) then gender="plural" end
	end
	message=search("["..message.."]") or message
	if CaseAdoptationNeeded then
		message=message:gsub("([^.!? ]?)(%s*)<adoptcase>(.)",function(before, space, symbol)
			if not before or before=="" then symbol=firsttoupper(symbol) else symbol=firsttolower(symbol) end
			return((before or "")..(space or "")..(symbol or ""))
		end)
	end
	return message
end


--Функция заменяет ' и " на «»
function FixQuotes(str)
	if not str then return end
	local opened=false
	str={string.byte(str,1,#str)}
	local endsymbols={	[string.byte(".")]=1,
				[string.byte(",")]=1,
				[string.byte("!")]=1,
				[string.byte("?")]=1,
				[string.byte("-")]=1,
				[string.byte(" ")]=1}
	for i,s in ipairs(str) do
		if s==string.byte("\"") then
			if not opened then
				str[i]=string.byte("«")
			else
				str[i]=string.byte("»")
			end
			opened=not opened                      
		end                             
		if s==string.byte("'") then
			if i==1 or (str[i-1] and (str[i-1]==string.byte(" ") or str[i-1]==string.byte(":"))) then
				opened=true
				str[i]=string.byte("«")
			elseif opened and i==#str or (str[i+1] and endsymbols[str[i+1]]) then
				opened=false
				str[i]=string.byte("»")
			end
		end
	end
	return(string.char(GLOBAL.unpack(str)))
end



for i,v in pairs(GLOBAL.LanguageTranslator.languages["ru"]) do
	GLOBAL.LanguageTranslator.languages["ru"][i]=FixQuotes(GLOBAL.LanguageTranslator.languages["ru"][i])
end



--Обрабатываем все произносимые реплики, извлекая из них теги
AddClassPostConstruct("components/talker", function(self)
	if self.Say then
		self.OldSay=self.Say
		function self:Say(script, ...)
			local player=GetPlayer()
			player=player and player.prefab
			if type(script) == "string" then 
				script=(t.ParseTranslationTags(script, player, self.inst and self.inst.prefab)) or script
			else for i,v in pairs(script) do if v.message and type(v.message)=="string" then
				v.message=(t.ParseTranslationTags(v.message, player, self.inst and self.inst.prefab)) or v.message
			end end end
			self:OldSay(script, ...)
		end
	end
end)

--Сохраняем непереведённые названия пресетов
local mappresets={text={},desc={}}
for i,v in pairs(STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELS) do table.insert(mappresets.text,v) end
for i,v in pairs(STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELDESC) do table.insert(mappresets.desc,v) end

--Проверяем наличие пустых строк, которые специальным образом маркируются на Notabenoid
for i,v in pairs(GLOBAL.LanguageTranslator.languages["ru"]) do
	if v=="<пусто>" then GLOBAL.LanguageTranslator.languages["ru"][i]="" end
end




--Перегоняем перевод в STRINGS
GLOBAL.TranslateStringTable(GLOBAL.STRINGS)

t.LoadCappedNames() --Загружаем имена, которые должны оставаться заглавными

t.LoadNamesGender() --Загружаем списки имён, отсортированных по роду и числу

t.LoadFixedNames() --загружаем исключения склонений




--Функция меняет окончания прилагательного prefix в зависимости от падежа, пола и числа предмета
function FixPrefix(prefix,act,item)
	if not t.NamesGender then return prefix end
--	prefix=prefix.." "
	local soft23={["г"]=1,["к"]=1,["х"]=1}
	
	local soft45={["г"]=1,["ж"]=1,["к"]=1,["ч"]=1,["х"]=1,["ш"]=1,["щ"]=1}
	local endings={}
	--Таблица окончаний в зависимости от действия и пола
	--case2 и case3, а так же case4 и case5 — твёрдый и мягкий пары
				--  влажный    синий      скользкий  простой    большой
	--Кто? Что?
	endings["NOACTION"]={	he={case1="ый",case2="ий",case3="ий",case4="ой",case5="ой"},
				he2={case1="ый",case2="ий",case3="ий",case4="ой",case5="ой"},
				she={case1="ая",case2="ая",case3="ая",case4="ая",case5="ая"},
				it={case1="ое",case2="ее",case3="ое",case4="ое",case5="ое"},
				plural={case1="ые",case2="ие",case3="ие",case4="ые",case5="ие"},
				plural2={case1="ые",case2="ие",case3="ие",case4="ые",case5="ие"}}
	--Кого? Что?
	endings["DEFAULTACTION"]={	he={case1="ый",case2="ий",case3="ий",case4="ой",case5="ой"},
					he2={case1="ого",case2="его",case3="ого",case4="ого",case5="ого"},
					she={case1="ую",case2="ую",case3="ую",case4="ую",case5="ую"},
					it={case1="ое",case2="ее",case3="ое",case4="ое",case5="ое"},
					plural={case1="ые",case2="ие",case3="ие",case4="ые",case5="ие"},
					plural2={case1="ых",case2="их",case3="их",case4="ых",case5="их"}}
	--Кому? Чему?
	endings["WALKTO"]={	he={case1="ому",case2="ему",case3="ому",case4="ому",case5="ому"},
				he2={case1="ому",case2="ему",case3="ому",case4="ому",case5="ому"},
				she={case1="ой",case2="ей",case3="ой",case4="ой",case5="ой"},                          
				it={case1="ому",case2="ему",case3="ому",case4="ому",case5="ому"},
				plural={case1="ым",case2="им",case3="им",case4="ым",case5="им"},
				plural2={case1="ым",case2="им",case3="им",case4="ым",case5="им"}}
	--Ком? Чём?
	endings["SLEEPIN"]={	he={case1="ом",case2="ем",case3="ом",case4="ом",case5="ом"},
				he2={case1="ом",case2="ем",case3="ом",case4="ом",case5="ом"},
				she={case1="ой",case2="ей",case3="ой",case4="ой",case5="ой"},
				it={case1="ом",case2="ем",case3="ом",case4="ом",case5="ом"},
				plural={case1="ых",case2="их",case3="их",case4="ых",case5="их"},
				plural2={case1="ых",case2="их",case3="их",case4="ых",case5="их"}}
	--Определим пол
	local gender="he"	
	if t.NamesGender["he2"][item] then gender="he2"
	elseif t.NamesGender["she"][item] then gender="she"
	elseif t.NamesGender["it"][item] then gender="it"
	elseif t.NamesGender["plural"][item] then gender="plural"
	elseif t.NamesGender["plural2"][item] then gender="plural2" end

	--Особый случай. Для действия "Собрать" у меня есть три записи с заменённым текстом. Там получается множественное число.
	if act=="PICK" and t.RussianNames[STRINGS.NAMES[string.upper(item)]] and t.RussianNames[STRINGS.NAMES[string.upper(item)]][act] then gender="plural" end
	--Ищем переданное действие в таблице выше

	local found=false
	for i,v in pairs(endings) do if act==i then found=true end end
	if not found then act="DEFAULTACTION" end
	
	local words=string.split(prefix," ") --разбиваем на слова
	prefix=""
	for _,word in ipairs(words) do
		if isupper(word:sub(1,1)) and #word>3 then
			--Заменяем по всем возможным сценариям
			if string.sub(word,-2)=="ый" then
				word=string.sub(word,1,#word-2)..endings[act][gender]["case1"]
			elseif string.sub(word,-2)=="ий" then
				if soft23[string.sub(word,-3,-3)] then
					word=string.sub(word,1,#word-2)..endings[act][gender]["case3"]
				else
					word=string.sub(word,1,#word-2)..endings[act][gender]["case2"]
				end
			elseif string.sub(word,-2)=="ой" then
				if soft45[string.sub(word,-3,-3)] then
					word=string.sub(word,1,#word-2)..endings[act][gender]["case5"]
				else
					word=string.sub(word,1,#word-2)..endings[act][gender]["case4"]
				end
			end
		end
		prefix=prefix..word.." "
	end
	prefix=string.sub(prefix,1,1)..russianlower(string.sub(prefix,2,-2))
	return prefix
end



local GetAdjectiveOld=GLOBAL.EntityScript["GetAdjective"]
--Новая версия функции, выдающей качество предмета
function GetAdjectiveNew(self)
	local str=GetAdjectiveOld(self)
	if str and self.prefab then
		local player = GetPlayer()
		local act=player.components.playercontroller:GetLeftMouseAction() --Получаем текущее действие
		if act then act=act.action.id or "NOACTION" else act="NOACTION" end
		str=FixPrefix(str,act,self.prefab) --склоняем окончание префикса
		if act~="NOACTION" then --если есть действие, то нужно сделать с маленькой буквы
			str=firsttolower(str)
		end
	end
	return str
end
GLOBAL.EntityScript["GetAdjective"]=GetAdjectiveNew --подменяем функцию, выводящую качества продуктов



--Фикс для hoverer, передающий в GetDisplayName действие, если оно есть
AddClassPostConstruct("widgets/hoverer", function(self)
	if not self.OnUpdate then return end
	local OldOnUpdate=self.OnUpdate
	function self:OnUpdate(...)
		local changed = false
		local OldlmbtargetGetDisplayName
        local lmb = self.owner and self.owner.components and self.owner.components.playercontroller and self.owner.components.playercontroller:GetLeftMouseAction()
		if lmb and lmb.target and lmb.target.GetDisplayName then
			changed = true
			OldlmbtargetGetDisplayName = lmb.target.GetDisplayName
			lmb.target.GetDisplayName = function(self)
				return OldlmbtargetGetDisplayName(self, lmb)
			end
		end
		OldOnUpdate(self, ...)
		if changed then
			lmb.target.GetDisplayName = OldlmbtargetGetDisplayName
		end
	end
end)

GLOBAL.a = ""

local GetDisplayNameOld=GLOBAL.EntityScript["GetDisplayName"] --сохраняем старую функцию, выводящую название предмета
function GetDisplayNameNew(self, act) --Подмена функции, выводящей название предмета. В ней реализовано склонение в зависимости от действия (переменная аct)
	local name=GetDisplayNameOld(self)
	local player = GetPlayer()
	print("GetDisplayNameNew",name, act and act.action.id)
	GLOBAL.a = self
--	if not player then return name end --Если не удалось получить instance игрока, то возвращаем имя на англ. и выходим
	
--	local act=player.components.playercontroller:GetLeftMouseAction() --Получаем текущее действие

	if name=="Maxwell" then name = "Максвелл" end --Для Максвелла, сидящего на троне

	if self:HasTag("player") then
		if STRINGS.NAMES[self.prefab:upper()] then
			act=act and act.action.id or "DEFAULT"
			name=(t.RussianNames[name] and (t.RussianNames[name][act] or t.RussianNames[name]["DEFAULTACTION"] or t.RussianNames[name]["DEFAULT"])) or rebuildname(name,act,self.prefab) or name
		end
		return name
	end

	--Особое исключительное написание для чертежей
	local itisblueprint=false
	if name:sub(-10)==" Blueprint" then
		name=name:sub(1,-11)
		itisblueprint=true
	elseif name:sub(-7)==" Чертеж" then
		name=name:sub(1,-8)
		itisblueprint=true
	end

	--Проверим, есть ли префикс мокрости, засушенности или дымления
	local Prefix=nil
	if STRINGS.WET_PREFIX then
		for i,v in pairs(STRINGS.WET_PREFIX) do
			if type(v)=="string" and v~="" and string.sub(name,1,#v)==v then Prefix=v break end
		end 
		if string.sub(name,1,#STRINGS.WITHEREDITEM)==STRINGS.WITHEREDITEM then Prefix=STRINGS.WITHEREDITEM 
		elseif string.sub(name,1,#STRINGS.SMOLDERINGITEM)==STRINGS.SMOLDERINGITEM then Prefix=STRINGS.SMOLDERINGITEM
		elseif t.H_Installed and string.sub(name,1,#STRINGS.MYSTERIOUS)==STRINGS.MYSTERIOUS then Prefix=STRINGS.MYSTERIOUS end
		if Prefix then --Нашли префикс. Меняем его и удаляем из имени для его дальнейшей корректной обработки
			name=string.sub(name,#Prefix+2)--Убираем префикс из имени
			if act then
				Prefix=FixPrefix(Prefix,act.action.id or "NOACTION",self.prefab)
				--Если есть действие, значит нужно сделать с маленькой буквы
				Prefix=firsttolower(Prefix)
			else 
				Prefix=FixPrefix(Prefix,"NOACTION",self.prefab)
				if self:GetAdjective() then
					Prefix=firsttolower(Prefix)
				end				
			end
			print("GetDisplayNameNew", Prefix, self.prefab)
		end
	end
	if act then --Если есть действие
		act=act.action.id
		--for i,v in pairs(self.components) do print("i=",i," v=",v) end --узнаем подробности

		if act=="USEDOOR" then
			for i,v in pairs(self.components.door.inst) do
				if type(v)=="string" and v~="" then
					print("i=",i," v=",v)
				end
			end
		end
		local exit_places = {pig_shop_doormats = true, doorway_cave = true, doorway_ruins = true, palace_door = true}
		if itisblueprint then
			name="чертеж предмета \""..name.."\""
		elseif act=="USEDOOR" and self.components.door.inst.prefab == "prop_door" and exit_places[self.components.door.inst.door_data_bank] then
			local exit_place = self.components.door.inst.door_data_bank
			if exit_place == "pig_shop_doormats" then
				STRINGS.ACTIONS.USEDOOR = "Выйти"
				name = ""
			elseif exit_place == "doorway_cave" then
				STRINGS.ACTIONS.USEDOOR = "Выйти из"
				name = "пещер"
			elseif exit_place == "doorway_ruins" then
				if self.components.door.inst.baseanimname == "day_loop" then
					STRINGS.ACTIONS.USEDOOR = "Выйти из"
					name = "руин"
				else
					STRINGS.ACTIONS.USEDOOR = "Перейти в"
					name = "другой зал"
				end
			elseif exit_place == "palace_door" then
				STRINGS.ACTIONS.USEDOOR = "Выйти из"
				name = "Дворца"
			end
		elseif self.prefab=="wreck" and self.components.named then
			--Обломки с названием корабля
			name = self.components.named.nameformat
			name = t.RussianNames[name] and
				(t.RussianNames[name][act] or t.RussianNames[name]["DEFAULTACTION"] or t.RussianNames[name]["DEFAULT"])
				or rebuildname(name,act,self.prefab) or name
			name = string.format(name, self.components.named.name)
			name = t.ParseTranslationTags(name, nil, nil, act)
		 	name = firsttolower(name)
		else
			STRINGS.ACTIONS.USEDOOR = "Войти в"
			name = t.RussianNames[name] and
				(t.RussianNames[name][act] or t.RussianNames[name]["DEFAULTACTION"] or t.RussianNames[name]["DEFAULT"])
				or rebuildname(name,act,self.prefab) or name
			local animated = {pigman = true, pigguard = true, bunnyman = true, wildbore = true, wildboreguard = true, mermfisher = true}
			if not (self.prefab and animated[self.prefab])
			 and not t.ShouldBeCapped[self.prefab] and name and type(name)=="string" and #name>0 then
				--меняем первый символ названия предмета в нижний регистр
			 	name=firsttolower(name)
			end
		end

	else	--Если нет действия
	    if itisblueprint then name="Чертеж предмета \""..name.."\"" end
		if not t.ShouldBeCapped[self.prefab] and (self:GetAdjective() or Prefix) then
		 	name=firsttolower(name)
		end
	end
	if Prefix then
		name=Prefix.." "..name
	end
	if act and act=="SLEEPIN" and name then name="в "..name end --Особый случай для "спать в палатке" и "спать в навесе для сиесты"
    return name
end
GLOBAL.EntityScript["GetDisplayName"]=GetDisplayNameNew --подменяем на новую


--исправление склонения "хрюнтов" в магазинах
if t.H_Installed then
	GLOBAL.ACTIONS.SHOP.stroverridefn = function(act)
		if not act.target or not act.target.costprefab or not act.target.components.shopdispenser:GetItem() then
			return nil
		else
			local item_name = string.upper(act.target.components.shopdispenser:GetItem())
			--print("item_name",item_name)
			if item_name:sub(-10) == "_BLUEPRINT" then
				item_name = item_name:sub(1,-11)
				wantitem = "чертеж предмета «"..STRINGS.NAMES[item_name].."»"
			else
				name = STRINGS.NAMES[item_name]
				wantitem = t.RussianNames[name] and	(t.RussianNames[name]["SHOP"] or t.RussianNames[name]["DEFAULTACTION"] or t.RussianNames[name]["DEFAULT"])
				or rebuildname(name,"SHOP",item_name) or name
				if not t.ShouldBeCapped[item_name] and wantitem and type(wantitem)=="string" and #wantitem>0 then
					wantitem = firsttolower(wantitem)
			end
			end
			local payitem = STRINGS.NAMES[string.upper(act.target.costprefab)]
			local qty = ""
			if act.target.costprefab == "oinc" then		
				qty = act.target.cost		
				if qty > 1 then
					if qty < 5 then
						payitem = STRINGS.NAMES.OINC.."а"
					else
						payitem = STRINGS.NAMES.OINC.."ов"
					end
					payitem = firsttolower(payitem)
				end
			end

			if act.doer.components.shopper:IsWatching(act.target) then		
				return GLOBAL.subfmt(STRINGS.ACTIONS.SHOP_LONG, { wantitem = wantitem, qty=qty, payitem = payitem })
			else
				return GLOBAL.subfmt(STRINGS.ACTIONS.SHOP_TAKE, { wantitem = wantitem })
			end
		end
	end

	GLOBAL.ACTIONS.PICKUP.stroverridefn = function(act)
		if act.target and act.target:HasTag("cost_one_oinc") then

			if act.target.components.shelfer and not act.target.components.shelfer.shelf:HasTag("playercrafted") then

				local wantitem = nil
				if act.target.prefab == "shelf_slot" and act.target.components.shelfer:GetGift() then
					local item_name = string.upper(act.target.components.shelfer:GetGift().prefab)
					if item_name=="TRINKET_GIFTSHOP_3" then
						wantitem = "почтовую карточку Королевского дворца"
					else
						wantitem = rebuildname(STRINGS.NAMES[item_name],"SHOP",item_name)
						if not t.ShouldBeCapped[item_name] and wantitem and type(wantitem)=="string" and #wantitem>0 then
							wantitem = firsttolower(wantitem)
						end
					end
				end

				if wantitem then
					if GetPlayer().components.shopper:IsWatching(act.target) then
						local payitem = STRINGS.NAMES[string.upper("oinc")]
						payitem = firsttolower(payitem)
						local qty = "1"
						return GLOBAL.subfmt(STRINGS.ACTIONS.SHOP_LONG, { wantitem = wantitem, qty=qty, payitem = payitem })
					else								    
						return GLOBAL.subfmt(STRINGS.ACTIONS.SHOP_TAKE, { wantitem = wantitem })
					end
				end

			end
		end
	end
end


--Переопределяем функцию, выводящую "Создать ...", когда устанавливается на землю крафт-предмет типа палатки.
local OldGetHoverTextOverride
function NewGetHoverTextOverride(self)
	if self.placer_recipe then
		local name=STRINGS.NAMES[string.upper(self.placer_recipe.name)]
		local act="BUILD"
		if name then
			if t.RussianNames[name] then
				name=t.RussianNames[name][act] or t.RussianNames[name]["DEFAULTACTION"] or t.RussianNames[name]["DEFAULT"] or rebuildname(name,act) or STRINGS.UI.HUD.HERE
			else
				name=rebuildname(name,act) or STRINGS.UI.HUD.HERE
			end
		else
			name=STRINGS.UI.HUD.HERE
		end
		if not t.ShouldBeCapped[self.placer_recipe.name] and name and type(name)=="string" and #name>0 then
			--меняем первый символ названия предмета в нижний регистр
		 	name=firsttolower(name)
		end
		local string = STRINGS.UI.HUD.BUILD.. " " .. name
		if self.placer_recipe.flipable then
			string = string.. "\n" .. STRINGS.UI.HUD.FLIP
		end
		return string
	end
end

AddClassPostConstruct("components/playercontroller", function(self)
	GetHoverTextOverride=self["GetHoverTextOverride"]
	self["GetHoverTextOverride"]=NewGetHoverTextOverride
end)



--исправление склонения слова "день" в меню паузы
local oldSetPause=GLOBAL.SetPause
function newSetPause(val, reason)
	if GLOBAL.GetClock() ~= nil then
		local day_number = GLOBAL.GetClock().numcycles
		local dn = StringTime(day_number)
		STRINGS.UI.PAUSEMENU.SURVIVED_DAYS = "Вы прожили всего\n%s "..dn
	end
	oldSetPause(val, reason)
end
GLOBAL.SetPause=newSetPause



local oldSelectPortrait --Старая функция выбора портрета в меню выбора персонажа
local function newSelectPortrait(self,portrait)
	oldSelectPortrait(self,portrait) --Запускаем оригинальную функцию
	if self.heroportait and self.heroportait.texture then
		local list={
			["locked"]=1,
			["wickerbottom"]=1,
			["waxwell"]=1,
			["willow"]=1,
			["wilson"]=1,
			["woodie"]=1,
			["wes"]=1,
			["wolfgang"]=1,
			["wendy"]=1,
			["wathgrithr"]=1,
			["webber"]=1,
			["walani"]=1,
			["warly"]=1,
			["woodlegs"]=1,
			["wilbur"]=1,
			["warbucks"]=1,
			["wormwood"]=1,
			["wilba"]=1,
			["wheeler"]=1,
			["wagstaff"]=1
		}
		local name=string.sub(self.heroportait.texture,1,-5)
		if list[name] then
			self.heroportait:SetTexture("images/rus_"..name..".xml", "rus_"..name..".tex")
		end
	end
end

--Подменяем функцию показа портрета в меню выбора персонажа
AddClassPostConstruct("screens/characterselectscreen", function(self)
	oldSelectPortrait=self["SelectPortrait"]
	self["SelectPortrait"]=newSelectPortrait
	self:SelectPortrait(1) --Нужно, чтобы обновить то, что уже успело показаться
end)



STRINGS.UI.CUSTOMIZATIONSCREEN.NAMES.BRANCHING = "Дробность суши"
STRINGS.UI.CUSTOMIZATIONSCREEN.NAMES.LOOP = "Цикличность суши"
STRINGS.UI.CUSTOMIZATIONSCREEN.NAMES.SEASON = "Сезоны"
STRINGS.UI.CUSTOMIZATIONSCREEN.NAMES.LIGHTNING = "Молнии" --Молния
STRINGS.UI.CUSTOMIZATIONSCREEN.NAMES.CAVE_ENTRANCE = "Вход в пещеру"
STRINGS.UI.CUSTOMIZATIONSCREEN.NAMES.SAPLING = "Саженцы" --Саженец
STRINGS.UI.CUSTOMIZATIONSCREEN.NAMES.MARSHBUSH = "Колючие кусты"
STRINGS.UI.CUSTOMIZATIONSCREEN.NAMES.REEDS = "Камыши" --Камыш
STRINGS.UI.CUSTOMIZATIONSCREEN.NAMES.FLINT = "Кремни" --Кремень
STRINGS.UI.CUSTOMIZATIONSCREEN.NAMES.ROCKS = "Валуны" --Камни
STRINGS.UI.CUSTOMIZATIONSCREEN.NAMES.BERRYBUSH = "Ягодные кусты" --Ягодный куст
STRINGS.UI.CUSTOMIZATIONSCREEN.NAMES.CARROT = "Моркови" --Морковь
STRINGS.UI.CUSTOMIZATIONSCREEN.NAMES.RABBITS = "Кролики"
STRINGS.UI.CUSTOMIZATIONSCREEN.NAMES.BUTTERFLY = "Бабочки" --Бабочка
STRINGS.UI.CUSTOMIZATIONSCREEN.NAMES.PERD = "Индюки" --Индюк
STRINGS.UI.CUSTOMIZATIONSCREEN.NAMES.PIGS = "Свины"
STRINGS.UI.CUSTOMIZATIONSCREEN.NAMES.BEEFALOHEAT = "Сезон размножения бифало"
STRINGS.UI.CUSTOMIZATIONSCREEN.NAMES.HUNT = "Следы"
STRINGS.UI.CUSTOMIZATIONSCREEN.NAMES.PENGUINS = "Пинчайки"
STRINGS.UI.CUSTOMIZATIONSCREEN.NAMES.FROGS = "Пруды"
STRINGS.UI.CUSTOMIZATIONSCREEN.NAMES.MERM = "Мэрмы" --Мэрм
STRINGS.UI.CUSTOMIZATIONSCREEN.NAMES.TENTACLES = "Щупальца"
STRINGS.UI.CUSTOMIZATIONSCREEN.NAMES.CHESS = "Шахматные фигуры"
STRINGS.UI.CUSTOMIZATIONSCREEN.NAMES.LIEFS = "Энты"
STRINGS.UI.CUSTOMIZATIONSCREEN.NAMES.PONDS = "Пруды"
--ROG
STRINGS.UI.CUSTOMIZATIONSCREEN.NAMES.AUTUMN = "Осень"
STRINGS.UI.CUSTOMIZATIONSCREEN.NAMES.WINTER = "Зима"
STRINGS.UI.CUSTOMIZATIONSCREEN.NAMES.SPRING = "Весна"
STRINGS.UI.CUSTOMIZATIONSCREEN.NAMES.SUMMER = "Лето"
STRINGS.UI.CUSTOMIZATIONSCREEN.NAMES.FROGRAIN = "Дожди из лягушек"
STRINGS.UI.CUSTOMIZATIONSCREEN.NAMES.WILDFIRES = "Самовозгорания"
STRINGS.UI.CUSTOMIZATIONSCREEN.NAMES.TUMBLEWEED = "Перекати-поля" --Перекати-поле
STRINGS.UI.CUSTOMIZATIONSCREEN.NAMES.ROCK_ICE = "Мини-ледники" --Мини-ледник
STRINGS.UI.CUSTOMIZATIONSCREEN.NAMES.MOLES = "Кроточерви"
STRINGS.UI.CUSTOMIZATIONSCREEN.NAMES.CACTUS = "Кактусы" --Кактус
STRINGS.UI.CUSTOMIZATIONSCREEN.NAMES.DECIDUOUSMONSTER = "Лиственный энт"
STRINGS.UI.CUSTOMIZATIONSCREEN.NAMES.GOOSEMOOSE = "Лось(Гусь)"

customizationscreen_correction_strings = {"LIGHTNING","SAPLING","REEDS","FLINT","BERRYBUSH","CARROT","BUTTERFLY","PERD","MERM","TUMBLEWEED","ROCK_ICE","CACTUS"}

local oldRefreshOptions --Старая функция заполнения опций в меню настроек карты
local function newRefreshOptions(self) --Новая функция
	oldRefreshOptions(self) --Запускаем оригинальную функцию

	if not self.optionspanel then return end
	local list={	["day.tex"]=1,
			["season.tex"]=1,
			["season_start.tex"]=1,
			["world_size.tex"]=1,
			["world_branching.tex"]=1,
			["world_loop.tex"]=1,
			["winter.tex"]=1,
			["summer.tex"]=1,
			["autumn.tex"]=1,
			["spring.tex"]=1,
			["hurricane.tex"]=1,
			["dry.tex"]=1,
			["monsoon.tex"]=1,
			["mild.tex"]=1,
			["temperate.tex"]=1,
			["lush.tex"]=1,
			["humid.tex"]=1}
	for _,a in pairs({[1]=self.optionspanel:GetChildren()}) do
	for v in pairs(a) do --Перебираем ячейки
		if tostring(v)=="option" then
			for prefab in pairs(v:GetChildren()) do --Ищем картинку и спиннер в ячейке
				for j, val in ipairs(customizationscreen_correction_strings) do
					if STRINGS.NAMES[val] and STRINGS.NAMES[val]==prefab.tooltip then
						prefab.tooltip = STRINGS.UI.CUSTOMIZATIONSCREEN.NAMES[val]
					end
				end
				if prefab.name and prefab.name:upper()=="IMAGE" then
					if list[prefab.texture] then
						prefab:SetTexture(MODROOT.."images/rus_mapgen.xml", "rus_"..prefab.texture)
					end
				elseif prefab.name and prefab.name:upper()=="SPINNER" and prefab.options then
					local shouldbeupdated=false
					for _,opt in ipairs(prefab.options) do --изучаем опции
						local words=string.split(opt.text," ") --разбиваем на слова
						opt.text=words[1]
						if #words>1 then --если слов несколько
							if opt.text==STRINGS.UI.SANDBOXMENU.SLIDELONG then --Долгий день-вечер-ночь
								if words[2]==STRINGS.UI.SANDBOXMENU.DAY or words[2]==STRINGS.UI.SANDBOXMENU.DUSK then
									opt.text=opt.text:sub(1,-2).."ий"
								elseif words[2]==STRINGS.UI.SANDBOXMENU.NIGHT or words[2]==STRINGS.UI.SANDBOXMENU.WINTER then
									opt.text=opt.text:sub(1,-2).."ая"
								elseif words[2]==STRINGS.UI.SANDBOXMENU.SUMMER then
									opt.text=opt.text:sub(1,-2).."ое"
								end
							elseif opt.text==STRINGS.UI.SANDBOXMENU.SLIDENEVER then --Нет дня-вечера-ночи
								if words[2]==STRINGS.UI.SANDBOXMENU.DAY then
									words[2]="дня"
								elseif words[2]==STRINGS.UI.SANDBOXMENU.NIGHT then
									words[2]="ночи"
								elseif words[2]==STRINGS.UI.SANDBOXMENU.DUSK then
									words[2]="вечера"
								end
							end
							for i=2,#words do --все последующие с маленькой буквы
								opt.text=opt.text.." "..firsttolower(words[i])
							end
							shouldbeupdated=true
						end
					end
					if shouldbeupdated then prefab:UpdateText(prefab.options[prefab.selectedIndex].text) end
				end
			end
		end
	end end
end

--Подменяем функцию обновления в интерфейсе настройки новой карты
AddClassPostConstruct("screens/customizationscreen", function(self)
	if self["savepresetbutton"] then --Уменьшаем текст на кнопке сохранения пресета
		self.savepresetbutton.text:SetSize(30)
	end
	oldRefreshOptions=self["RefreshOptions"]
	self["RefreshOptions"]=newRefreshOptions
	self:RefreshOptions() --Нужно, чтобы обновить то, что уже успело показаться
end)



--Баг с непереводящимися словами Enabled и Disabled в настройках для официальной версии игры
AddClassPostConstruct("screens/optionsscreen", function(self) 
	for _,v in pairs(self) do
		if type(v)=="table" and v.name=="SPINNER" then
			local shouldbeupdated=false
			for _,opt in ipairs(v.options) do --изучаем опции
				if opt.text=="Enabled" then
					opt.text=STRINGS.UI.OPTIONS.ENABLED
					shouldbeupdated=true
				elseif opt.text=="Disabled" then
					opt.text=STRINGS.UI.OPTIONS.DISABLED
					shouldbeupdated=true
				end
			end
			if v.selectedIndex and v.selectedIndex>0 and v.selectedIndex<=#v.options then v:UpdateText(v.options[v.selectedIndex].text) end
		end
	end
end)



--Исправляем жёстко зашитые надписи на кнопках в казане и телепорте.
AddClassPostConstruct("widgets/containerwidget", function(self)
	self.oldOpen=self.Open
	local function newOpen(self, container, doer)
		self:oldOpen(container, doer)
		if self.button then
			if self.button:GetText()=="Cook" then self.button:SetText("Готовить") end
			if self.button:GetText()=="Activate" then self.button:SetText("Запустить") end
		end
	end
	self.Open=newOpen
end)



AddClassPostConstruct("widgets/recipepopup", function(self) --Уменьшаем шрифт описания рецепта в попапе рецептов
	if self.name and self.Refresh then --Перехватываем вывод названия, проверяем, вмещается ли оно, и если нужно, меняем его размер
		if not self.OldRefresh then
			self.OldRefresh=self.Refresh
			function self.Refresh(self,...)
				self:OldRefresh(...)
				if not self.name then return end
				local Text = require "widgets/text"
		    local tmp = self.contents:AddChild(Text(GLOBAL.UIFONT, 36))
			      tmp:SetPosition(320, 142, 0)
			      tmp:SetHAlign(GLOBAL.ANCHOR_MIDDLE)
			      tmp:Hide()
		        tmp:SetString(self.name:GetString())
			    local desiredw = self.name:GetRegionSize()
				local w = tmp:GetRegionSize()
				tmp:Kill()
				if w>desiredw then
					self.name:SetSize(36*desiredw/w)
				else
					self.name:SetSize(42)
				end
			end
		end
	end 
	if self.desc then
		self.desc:SetSize(28)
		self.desc:SetRegionSize(64*3+30,130)
	end
end)



--согласовываем слово "дней" с количеством дней в окне смерти персонажа
AddClassPostConstruct("screens/deathscreen", function(self, days_survived)
	if self.t2 and days_survived then
		self.t2:SetString(StringTime(days_survived))
	end
	if self.rewardtext then
		self.rewardtext:Nudge({x=-20,y=0,z=0})
	end
	if self.leveltext then
		self.leveltext:Nudge({x=10,y=0,z=0})
	end
end)



--Чуть-чуть раздвигаем портрет и надпись в меню загрузки игр
AddClassPostConstruct("screens/loadgamescreen", function(self)
	self.oldMakeSaveTile=self.MakeSaveTile
	local function newMakeSaveTile(self,slotnum)
		local item=self:oldMakeSaveTile(slotnum)
		item.portraitbg:SetPosition(-130 + 40, 2, 0)	
		item.portrait:SetPosition(-130 + 40, 2, 0)	
		if item.portraitbg.shown then item.text:SetPosition(50,0,0) end
		return item
	end
	self.MakeSaveTile=newMakeSaveTile
end)



--Уменьшаем размер текста в заголовке деталей записи
AddClassPostConstruct("screens/slotdetailsscreen", function(self)
	self.text:SetSize(45)
end)



--Переводим пару строк в окне логина Twitch, которые по какой-то причине не в STRINGS
AddClassPostConstruct("screens/broadcastingloginscreen", function(self)
	if self.title and self.title:GetString()=="Twitch User Name" then
		self.title:SetString("Имя пользователя в Twitch")
	end
	if self.password_title and self.password_title:GetString()=="Twitch Password" then
		self.password_title:SetString("Пароль в Twitch")
	end
end)



--Уменьшаем шрифт в заголовке морга
AddClassPostConstruct("screens/morguescreen", function(self)
	if self.obits_titles then
		for str in pairs(self.obits_titles:GetChildren()) do
			if type(str)=="table" and str.name and str.name=="Text" then
				str:SetSize(28)
			end
		end
	end
	if self.RefreshControls then
		local oldRefreshControls = self.RefreshControls
		function self.RefreshControls() -- С помощью грязного хака склоняем слова в причине смерти для двух случаев
			local Text = require "widgets/text"
			local oldTextSetString = Text.SetString
			function Text.SetString(slf, str, ...)
				if str == STRINGS.NAMES.DROWNING or str == STRINGS.NAMES.BURNT then
					local group = slf:GetParent()
					local children = group and group:GetChildren()
					if children then
						for child in pairs(children) do
							if child.name == "DECEASED" then
								local character = child.portrait.texture
								character = character and character:sub(1,-5)
								str = t.ParseTranslationTags(str, character)
								break
							end
						end
					end
				end
				oldTextSetString(slf, str, ...)
			end
			oldRefreshControls(self)
			Text.SetString = oldTextSetString
		end
		self:RefreshControls()
	end
end)



--Исправляем последовательность слов в заголовке окна настройки модов
AddClassPostConstruct("screens/modconfigurationscreen", function(self)
	for title,val in pairs(self.root.children) do
		if title.name and string.lower(title.name)=="text" then 
			local tmp=title:GetString()
			tmp=string.sub(tmp,1,#tmp-#STRINGS.UI.MODSSCREEN.CONFIGSCREENTITLESUFFIX-1)
			title:SetString(STRINGS.UI.MODSSCREEN.CONFIGSCREENTITLESUFFIX.." \""..tmp.."\"")
		end
	end
end)



--Подменяем шрифт, потому что тут уже инициализировался английский
AddClassPostConstruct("widgets/loadingwidget", function(self)
	local OldKeepAlive = self.KeepAlive
	function self:KeepAlive(...)
		local res = OldKeepAlive(self, ...)
		if self.loading_widget then
			self.loading_widget:SetFont(GLOBAL.UIFONT)
			if not self.loading_widget.RLPInitialized then
				self.loading_widget.RLPInitialized = true
				local OldSetString = self.loading_widget.SetString
				function self.loading_widget:SetString(str, ...)
					if str and type(str)=="string" then
						str = str:gsub("Loading", "Загрузка")
					end
					local res = OldSetString(self, str, ...)
					return res
				end
				self.loading_widget:SetString(self.loading_widget:GetString())
			end
		end
		return res
	end
end)



--Исправление бага с шрифтом в спиннерах
AddClassPostConstruct("widgets/spinner", function(self, options, width, height, textinfo, ...) --Выполняем подмену шрифта в спиннере из-за глупой ошибки разрабов в этом виджете
	if textinfo then return end
	self.text:SetFont(GLOBAL.BUTTONFONT)
end)



--Для тех, кто пользуется ps4 или NACL должна быть возможность сохранять не в ини файле, а в облаке.
--Для этого дорабатываем функционал стандартного класса PlayerProfile
local function SetLocalizaitonValue(self,name,value) --Метод, сохраняющий опцию с именем name и значением value
    local USE_SETTINGS_FILE = GLOBAL.PLATFORM ~= "PS4" and GLOBAL.PLATFORM ~= "NACL"
 	if USE_SETTINGS_FILE then
		GLOBAL.TheSim:SetSetting("translation", tostring(name), tostring(value))
	else
		self:SetValue(tostring(name), tostring(value))
		self.dirty = true
		self:Save() --Сохраняем сразу, поскольку у нас нет кнопки "применить"
	end
end
local function GetLocalizaitonValue(self,name) --Метод, возвращающий значение опции name
        local USE_SETTINGS_FILE = GLOBAL.PLATFORM ~= "PS4" and GLOBAL.PLATFORM ~= "NACL"
 	if USE_SETTINGS_FILE then
		return GLOBAL.TheSim:GetSetting("translation", tostring(name))
	else
		return self:GetValue(tostring(name))
	end
end



--Расширяем функционал PlayerProfile дополнительной инициализацией двух методов и заданием дефолтных значений опций нашего перевода.
AddGlobalClassPostConstruct("playerprofile", "PlayerProfile", function(self)
        local USE_SETTINGS_FILE = GLOBAL.PLATFORM ~= "PS4" and GLOBAL.PLATFORM ~= "NACL"
 	if not USE_SETTINGS_FILE then
	        self.persistdata.update_is_allowed = true --Разрешено запускать обновление по умолчанию
	        self.persistdata.update_frequency = GLOBAL.RusUpdatePeriod[3] --Раз в неделю по умолчанию
		local date=GLOBAL.os.date("*t")
		self.persistdata.last_update_date = tostring(date.day.."."..date.month.."."..date.year) --Текущая дата по умолчанию
	end
	self["SetLocalizaitonValue"]=SetLocalizaitonValue --метод задачи значения опции
	self["GetLocalizaitonValue"]=GetLocalizaitonValue --метод получения значения опции
end)



--Добавление кнопки настроек меню модов при наведении на русский мод
if GLOBAL.KnownModIndex and GLOBAL.KnownModIndex.HasModConfigurationOptions then
	local OldHasModConfigurationOptions = GLOBAL.KnownModIndex.HasModConfigurationOptions
	function GLOBAL.KnownModIndex:HasModConfigurationOptions(modname, ...)
		local res = OldHasModConfigurationOptions(self, modname, ...)
		if self:GetModInfo(modname).name==modinfo.name then res = true end
		return res
	end
end



--Переопределяем действие кнопки
AddGlobalClassPostConstruct("screens/modsscreen", "ModsScreen", function(self)
	if self.detailwarning and self.CreateDetailPanel then
		self.detailwarning:SetSize(22)
		local OldCreateDetailPanel=self.CreateDetailPanel
		function self:CreateDetailPanel(...)
			OldCreateDetailPanel(self,...)
			self.detailwarning:SetSize(22)
			print(modname, self.modnames[self.currentmod])
			if self.modlinkbutton then
--				self.modlinkbutton:Nudge({x=100,y=0,z=0})
				
				local TextButton = require "widgets/textbutton"
				self.modlinkbutton2 = self.detailpanel:AddChild(TextButton("images/ui.xml", "blank.tex","blank.tex","blank.tex","blank.tex" ))
				self.modlinkbutton2:Hide()
				self.modlinkbutton2:SetPosition(5-78, -119, 0)
				self.modlinkbutton2:SetFont(GLOBAL.BUTTONFONT)
				self.modlinkbutton2:SetTextSize(30)
				self.modlinkbutton2:SetTextColour(0.9,0.8,0.6,1)
				self.modlinkbutton2:SetTextFocusColour(1,1,1,1)
				self.modlinkbutton2:SetText("Мод в SteamWorkshop")
				self.modlinkbutton2:SetOnClick( function() GLOBAL.VisitURL(t.SteamURL) end )
			end
		end
	end
	if self.ShowModDetails and self.modlinkbutton then
		local OldShowModDetails = self.ShowModDetails
		function self:ShowModDetails(idx, ...)
			local res = OldShowModDetails(self, idx, ...)
			if idx and self.modnames[idx] then
				if modname==self.modnames[idx] then
					if self.modlinkbutton2 then self.modlinkbutton2:Show() end
					self.modlinkbutton:SetPosition(5+90, -119, 0)
					self.modlinkbutton:SetText("Мод на форуме Klei")
				else
					if self.modlinkbutton2 then self.modlinkbutton2:Hide() end
					self.modlinkbutton:SetPosition(5, -119, 0)
					self.modlinkbutton:SetText(STRINGS.UI.MODSSCREEN.MODLINK)
				end
			end
			return res
		end
	end
	local OldConfigureSelectedMod = self.ConfigureSelectedMod
	if OldConfigureSelectedMod then
		function self:ConfigureSelectedMod(...)
			local res = nil
			local modname = self.modnames[self.currentmod]
			if GLOBAL.KnownModIndex:GetModInfo(modname).name==modinfo.name then
				local LanguageOptions = require "screens/LanguageOptions"
				GLOBAL.TheFrontEnd:PushScreen(LanguageOptions())
			else
				res = OldConfigureSelectedMod(self, ...)
			end
			return res
		end
	end
end)



--Перехватываем функцию закрытия игры для записи в ини файл данных о том, что можно обновляться
local oldshutdown=GLOBAL.Shutdown
function newShutdown()
	GLOBAL.Profile:SetLocalizaitonValue("update_is_allowed", "true") --Если игра выключена с включённым модом, разрешим в следующий раз проверять обновление
	oldshutdown()
end
GLOBAL.Shutdown=newShutdown



--Пробрасываем в настройки каждого мода переменную russian для нативной русификации (при желании автора мода).
if GLOBAL.ModIndex.InitializeModInfoEnv then
    --Если PeterA услышал мольбы, то поступаем цивилизованно.
    local old_InitializeModInfoEnv = GLOBAL.ModIndex.InitializeModInfoEnv
    GLOBAL.ModIndex.InitializeModInfoEnv = function(self,...)
        local env = old_InitializeModInfoEnv(self,...)
		env.language = "ru"
		env.russian = true -- !!! Устаревшая ссылка. Через некоторое время будет удалена !!!
        return env
    end
else --Иначе извращаемся, как обычно.
    local temp_mark = false --Временная метка, означающая, что в следующий вызов RunInEnvironment надо добавить russian=true
   
    --Перехватываем "kleiloadlua", чтобы установить временную метку в случае загрузки "modinfo.lua"
    local old_kleiloadlua = GLOBAL.kleiloadlua
    GLOBAL.kleiloadlua = function(path,...)
        local fn = old_kleiloadlua(path,...)
        if fn and type(fn) ~= "string" and path:sub(-12) == "/modinfo.lua" then
			temp_mark = true
        end
        return fn
    end
   
    --Перехватываем RunInEnvironment, чтобы среагировать на метку (заодно сбросить ее)
    local old_RunInEnvironment = GLOBAL.RunInEnvironment
    GLOBAL.RunInEnvironment = function(fn, env, ...)
		if env and temp_mark then
			env.language = "ru"
			env.russian = true -- !!! Устаревшая ссылка. Через некоторое время будет удалена !!!
			temp_mark = false
		end
		return old_RunInEnvironment(fn, env, ...)
    end
end



local genders_reg={"he","he2","she","it","plural","plural2", --numbers
	he="he",he2="he2",she="she",it="it",plural="plural",plural2="plural2"};
--[[Функция регистрирует новое имя предмета со всеми данными, необходимыми для его корректного склонения.

    key - Ключ объекта. Например, MYITEM (из GLOBAL.STRINGS.NAMES.MYITEM).
    val - Русский перевод названия объекта.
    gender - Пол объекта. Варианты: he, he2, she, it, plural, plural2. Род нужен для склонения префиксов жары и влажности.
	     "he" и "he2" - это мужской род, но не одно и то же, сравните: изучить влажный курган слизнепах (he),
	     но изучить влажного паука (he2). plural2 — одушевлённое во множественном числе (если слово, например, "Чайки",
	     то есть когда объект изначально получает название во множественном числе).
    walkto - Склонение при подстановке во фразу "Идти к" (кому? чему?). Задавайте слова с большой буквы.
    defaultaction - Подставляется ко всем действиям в игре, для которых не задано особое написание. Например "Осмотреть" (кого? что?).
    capitalized - Нужно ли писать имя с большой буквы. Маленькая буква в названии не станет большой.
	          Но если не указать true, то большая станет маленькой в фразах, где есть слово перед. Например: "Осмотреть лепестки".
    killaction - Используется только в DST во всех предметах, которые способны убить персонажа. В игре они могут появляться в сообщениях
		 типа "Был убит (кем? чем?)", то есть это творительный падеж.
	Вместо строковых значений пола можно использовать их номера: 1) he, 2) he2, 3) she, 4) it, 5) plural, 6) plural2.
	Вместо walkto, defaultaction и killaction можно использовать 0 или 1.
	0 означает пропуск параметра. То же, что не указать параметр вовсе. Значение не инициализируется. Используются значения из testname.
	1 означает "то же, что и базовая форма", т.е. val. Чтобы не дублировать одни и те же строки (val) можно просто указать единичку.
	
	Например: 
	RegisterRussianName("RESEARCHLAB2","Алхимический двигатель",1,"Алхимическому двигателю",1)
	Вместо пола указана 1, что означает "he".
	Вместо defaultaction указано 1, что означает повторение val, т.е. "Алхимический двигатель".
]]
function GLOBAL.RegisterRussianName(key,val,gender,walkto,defaultaction,capitalized,killaction)
	local oldval=STRINGS.NAMES[string.upper(key)]
	STRINGS.NAMES[string.upper(key)]=val
	GLOBAL.LanguageTranslator.languages.ru["STRINGS.NAMES."..string.upper(key)] = val
	if gender and gender~=0 then 
		if (genders_reg[gender]) then
			t.NamesGender[genders_reg[gender]][string.lower(key)]=true
		--else
		--	print error............
		end
	end
	if walkto or defaultaction or killaction then
		if (walkto==1) then walkto=val end
		if (defaultaction==1) then defaultaction=val end
		if (killaction==1) then killaction=val end
		t.RussianNames[val]={}
		if walkto and walkto~=0 then t.RussianNames[val]["WALKTO"]=walkto end
		if defaultaction and defaultaction~=0 then t.RussianNames[val]["DEFAULTACTION"]=defaultaction end
		if killaction and killaction~=0 then t.RussianNames[val]["KILL"]=killaction end
	end
	if capitalized then t.ShouldBeCapped[string.lower(key)]=true end
end