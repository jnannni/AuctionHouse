﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	//{{__КОНСТРУКТОР_ВВОД_НА_ОСНОВАНИИ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Лоты") Тогда
		// Заполнение шапки
		Аукцион = ДанныеЗаполнения.Владелец;
		Лот = ДанныеЗаполнения.Наименование;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Пользователи") Тогда
		// Заполнение шапки
		Ответственный = ДанныеЗаполнения.Наименование;
		Плательщик = ДанныеЗаполнения.Наименование;
	КонецЕсли;
	//}}__КОНСТРУКТОР_ВВОД_НА_ОСНОВАНИИ
КонецПроцедуры
