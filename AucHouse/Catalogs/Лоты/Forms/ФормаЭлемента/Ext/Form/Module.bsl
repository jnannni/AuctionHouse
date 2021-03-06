
&НаКлиенте
Процедура ДобавитьВИзбранное(Команда)
	ДобавитьВИзбранноеНаСервере();
КонецПроцедуры

&НаСервере
Процедура ДобавитьВИзбранноеНаСервере()
	МЗ = РегистрыСведений.ИзбранныеЛоты.СоздатьМенеджерЗаписи();
	МЗ.Лот = Объект.Ссылка;
	МЗ.Пользователь = ПараметрыСеанса.ТекущийПользователь;
	МЗ.Записать();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПодключитьОбработчикОжидания("ПолучитьСтавку", 1);
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСтавку()
	Элементы.Продавец.ОбновлениеТекстаРедактирования = ОбновлениеТекстаРедактирования.НеИспользовать;
	Элементы.Наименование.ОбновлениеТекстаРедактирования = ОбновлениеТекстаРедактирования.НеИспользовать;
	Элементы.Владелец.ОбновлениеТекстаРедактирования = ОбновлениеТекстаРедактирования.НеИспользовать;
	Элементы.НачальнаяСтоимость.ОбновлениеТекстаРедактирования = ОбновлениеТекстаРедактирования.НеИспользовать;
	Элементы.МинимальнаяСтавка.ОбновлениеТекстаРедактирования = ОбновлениеТекстаРедактирования.НеИспользовать;
	Элементы.СтоимостьВыкупа.ОбновлениеТекстаРедактирования = ОбновлениеТекстаРедактирования.НеИспользовать;
	Элементы.СтатусЛота.ОбновлениеТекстаРедактирования = ОбновлениеТекстаРедактирования.НеИспользовать;
	Элементы.МояСтавка.ОбновлениеТекстаРедактирования = ОбновлениеТекстаРедактирования.НеИспользовать;
	ПроверитьНаличиеОбъекта();
КонецПроцедуры

&НаСервере
Процедура ПроверитьНаличиеОбъекта()
	Лот = Справочники.Лоты.НайтиПоНаименованию(Объект.Наименование); 
	Если ЗначениеЗаполнено(Лот) Тогда
		ОбработатьОжидание();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбработатьОжидание()
	Лот = Справочники.Лоты.НайтиПоНаименованию(Объект.Наименование);
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|		СтавкиНаЛотыСрезПоследних.Лот КАК Лот,
	|		СтавкиНаЛотыСрезПоследних.Пользователь,
	|       СтавкиНаЛотыСрезПоследних.Ставка
	|ИЗ
	|		РегистрСведений.СтавкиНаЛоты.СрезПоследних(&ТекущаяДата, Лот = &Лот) КАК СтавкиНаЛотыСрезПоследних";
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДата());
	Запрос.УстановитьПараметр("Лот", Лот);
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	Пар = Лот.ПолучитьОбъект();
	Пока РезультатЗапроса.Следующий() Цикл
		Пар.ТекущаяСтавка = РезультатЗапроса.Ставка;
		Пар.Записать();	
	КонецЦикла;
	
	
	//НаборЗаписей = РегистрыСведений.СтавкиНаЛоты.СоздатьНаборЗаписей();
	//НаборЗаписей.Прочитать();
	//Для Каждого Запись из НаборЗаписей Цикл
	//	Сообщить();
	//КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СделатьСтавку(Команда)
	СделатьСтавкуНаСервере();
КонецПроцедуры

&НаСервере
Процедура СделатьСтавкуНаСервере()      
	Если МояСтавка > Объект.МинимальнаяСтавка и Объект.Продавец<>ПараметрыСеанса.ТекущийПользователь Тогда
		Ставка = РегистрыСведений.СтавкиНаЛоты.СоздатьМенеджерЗаписи();
		Ставка.Период = ТекущаяДата();
		Ставка.Лот = Объект.Ссылка;
		Ставка.Ставка = МояСтавка + Объект.ТекущаяСтавка;
		Ставка.Пользователь = ПараметрыСеанса.ТекущийПользователь;
		Ставка.Записать();
	Иначе
		Сообщить("Некорректная ставка");
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ 
	| Наименование,
	| Ссылка
	|ИЗ
	| Справочник.Лоты КАК Лоты";
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Выборка.Наименование = "" Тогда
			Удаление = Выборка.Ссылка.ПолучитьОбъект();
			Удаление.Удалить();
		КонецЕсли;
	КонецЦикла;
	
	Если Объект.ТекущаяСтавка = 0 Тогда
		Объект.ТекущаяСтавка = Объект.НачальнаяСтоимость;
	КонецЕсли;
	
	СсылкаНаКартинку = ПолучитьНавигационнуюСсылку(Объект.Ссылка,"Картинка");
	АукционЗавершен = Объект.Владелец.ДатаКонца < ТекущаяДата();
	ЭтаФорма.ТолькоПросмотр = АукционЗавершен;
	АукционСтратовал = Объект.Владелец.ДатаНачала < ТекущаяДата() и не АукционЗавершен;
	Если Объект.СтатусЛота = Перечисления.СтатусыЛота.Выкуплен Тогда
		Элементы.Группа1.Доступность = ложь;
		Элементы.Группа2.Доступность = ложь;
		Элементы.Группа3.Доступность = ложь;
	КонецЕсли;
	Если Объект.СтатусЛота = Перечисления.СтатусыЛота.Добавлен и АукционСтратовал Тогда
		Элементы.СделатьСтавку.Доступность = истина;
		Элементы.Выкупить.Доступность = истина;
	Иначе 
		Элементы.СделатьСтавку.Доступность = ложь;
		Элементы.Выкупить.Доступность = ложь;
	КонецЕсли;
	Если ПараметрыСеанса.ТекущийПользователь.ТипПользователя = Перечисления.ТипПользователя.Покупатель и 
		Объект.СтоимостьВыкупа = 0 Тогда
		Элементы.Группа2.Видимость = ложь;
	КонецЕсли;
	Если ПараметрыСеанса.ТекущийПользователь.ТипПользователя = Перечисления.ТипПользователя.Продавец Тогда
		Объект.Продавец = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
	Если Объект.СтатусЛота = Перечисления.СтатусыЛота.Добавлен и Объект.Продавец = ПараметрыСеанса.ТекущийПользователь Тогда
		Элементы.Группа3.Доступность = ложь;
		Элементы.Группа2.Доступность = ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СсылкаНаКартинкуНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь; 
	Режим = РежимДиалогаВыбораФайла.Открытие; 
	ДиалогОткрытия = Новый ДиалогВыбораФайла(Режим); 
	ДиалогОткрытия.ПолноеИмяФайла = ""; 
	Фильтр = "Файл Jpg (*.jpg)|*.jpg"; 
	ДиалогОткрытия.Фильтр = Фильтр; 
	ДиалогОткрытия.МножественныйВыбор = Ложь; 
	ДиалогОткрытия.Заголовок = "Выберете файл для загрузки"; 
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеЗагрузкиФайла",ЭтаФорма); 
	ДиалогОткрытия.Показать(ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте 
Процедура ПослеЗагрузкиФайла(ВыбранныйФайл,ДопПараметр) Экспорт 
	Если ВыбранныйФайл = Неопределено Тогда 
		Возврат; 
	КонецЕсли; 
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеПомещенияФайла", ЭтаФорма); 
	НачатьПомещениеФайла(ОписаниеОповещения,, ВыбранныйФайл[0], Ложь, УникальныйИдентификатор); 
КонецПроцедуры

&НаКлиенте 
Процедура ПослеПомещенияФайла(Результат, Адрес, ВыбранноеИмяФайла,ДопПараметры) Экспорт 
	Если Не Результат Тогда 
		Возврат; 
	КонецЕсли; 
	СсылкаНаКартинку = Адрес; 
	Модифицированность = Истина; 
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если ЭтоАдресВременногоХранилища(СсылкаНаКартинку)  Тогда 
		ФайлКартинки = ПолучитьИзВременногоХранилища(СсылкаНаКартинку); 
		ТекущийОбъект.Картинка = Новый ХранилищеЗначения(ФайлКартинки); 
		УдалитьИзВременногоХранилища(СсылкаНаКартинку); 
		СсылкаНаКартинку = ПолучитьНавигационнуюСсылку(Объект.Ссылка,"Картинка"); 
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Выкупить(Команда)
	ВыкупитьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ВыкупитьНаСервере()
	Ставка = РегистрыСведений.СтавкиНаЛоты.СоздатьМенеджерЗаписи();
	Ставка.Период = ТекущаяДата();
	Ставка.Лот = Объект.Ссылка;
	Ставка.Ставка = Объект.СтоимостьВыкупа;
	Ставка.Пользователь = ПараметрыСеанса.ТекущийПользователь;
	Ставка.Записать();
	Элементы.Группа1.Доступность = ложь;
	Элементы.Выкупить.Доступность = ложь;
	Лот = Справочники.Лоты.НайтиПоНаименованию(Объект.Наименование);
	Пар = Лот.ПолучитьОбъект();
	Пар.СтатусЛота = Перечисления.СтатусыЛота.Выкуплен;
	Пар.Записать();
КонецПроцедуры






