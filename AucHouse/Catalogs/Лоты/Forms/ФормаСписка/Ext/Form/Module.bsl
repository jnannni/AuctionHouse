﻿

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПодключитьОбработчикОжидания("ПолучитьЛоты", 1);
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьЛоты()
	Сообщение();
КонецПроцедуры

&НаСервере
Процедура Сообщение()
	Выборка = Справочники.Лоты.Выбрать();
КонецПроцедуры

