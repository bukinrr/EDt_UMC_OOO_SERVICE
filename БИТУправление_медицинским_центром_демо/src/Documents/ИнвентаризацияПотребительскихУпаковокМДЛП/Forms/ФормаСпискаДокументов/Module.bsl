
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Уведомление = Неопределено Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	МетаданныеОбъекта = Параметры.Уведомление.Метаданные();
	ПолноеИмяУведомления = МетаданныеОбъекта.ПолноеИмя();
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмяУведомления);
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	СвойстваСписка.ТекстЗапроса = МенеджерОбъекта.ПанельМаркировкиМДЛПТекстЗапросаДинамическогоСписока();
	СвойстваСписка.ОсновнаяТаблица = ПолноеИмяУведомления;
	СвойстваСписка.ДинамическоеСчитываниеДанных = Истина;
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, СвойстваСписка);
	
	СвойстваСпискаКОформлению = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	СвойстваСпискаКОформлению.ТекстЗапроса = МенеджерОбъекта.ПанельМаркировкиМДЛПТекстЗапросаДинамическогоСпискаКОформлению();
	СвойстваСпискаКОформлению.ОсновнаяТаблица = Метаданные.РегистрыСведений.СтатусыОформленияДокументовМДЛП.ПолноеИмя();
	СвойстваСпискаКОформлению.ДинамическоеСчитываниеДанных = Истина;
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.СписокКОформлению, СвойстваСпискаКОформлению);
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокКОформлению, "ДокументИнформирования", МенеджерОбъекта.ПустаяСсылка());
	
	КлючНазначенияИспользования = МетаданныеОбъекта.Имя;
	
	Если Не ПустаяСтрока(МетаданныеОбъекта.ПредставлениеСписка) Тогда
		Заголовок = МетаданныеОбъекта.ПредставлениеСписка;
	ИначеЕсли Не ПустаяСтрока(МетаданныеОбъекта.РасширенноеПредставлениеСписка) Тогда
		Заголовок = МетаданныеОбъекта.РасширенноеПредставлениеСписка;
	Иначе
		Заголовок = МетаданныеОбъекта.Представление();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКоманды = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКоманды");
		ПараметрыРазмещения = МодульПодключаемыеКоманды.ПараметрыРазмещения();
		ПараметрыРазмещения.Источники = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(МетаданныеОбъекта);
		ПараметрыРазмещения.КоманднаяПанель = Элементы.Список.КоманднаяПанель;
		МодульПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
		// Аналог функции ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
		// Функцию подсистемы ВерсионированиеОбъектов не используем, т.к. форма списка и форма выбора документов Уведомлений общие
		// и хранятся в обработке ПанельМаркировкиМДЛП.
		ТипВерсионируемогоОбъекта = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ПолноеИмяУведомления);
		УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("ТипВерсионируемогоОбъекта", ТипВерсионируемогоОбъекта));
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ЗаполнитьСписокВыбораСтатуса(МенеджерОбъекта);
	
	ИнтеграцияМДЛП.ЗаполнитьСписокВыбораДальнейшееДействие(
		Элементы.ДальнейшееДействиеОтбор.СписокВыбора,
		МенеджерОбъекта.ВсеТребующиеДействия(),
		МенеджерОбъекта.ВсеТребующиеОжидания());
	
	СтруктураБыстрогоОтбора = Параметры.СтруктураБыстрогоОтбора;
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		Если СтруктураБыстрогоОтбора.Свойство("Статус", Статус) Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				Список, "Статус", Статус,,, ЗначениеЗаполнено(Статус));
		КонецЕсли;
		Если СтруктураБыстрогоОтбора.Свойство("Организация", Организация) Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				Список, "Организация", Организация,,, ЗначениеЗаполнено(Организация));
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				СписокКОформлению, "Организация", Организация,,, ЗначениеЗаполнено(Организация));
		КонецЕсли;
		Если СтруктураБыстрогоОтбора.Свойство("МестоДеятельности", МестоДеятельности) Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				Список, "МестоДеятельности", МестоДеятельности,,, ЗначениеЗаполнено(МестоДеятельности));
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				СписокКОформлению, "МестоДеятельности", МестоДеятельности,,, ЗначениеЗаполнено(МестоДеятельности));
		КонецЕсли;
		Если СтруктураБыстрогоОтбора.Свойство("Ответственный", Ответственный) Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				Список, "Ответственный", Ответственный,,, ЗначениеЗаполнено(Ответственный));
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				СписокКОформлению, "Ответственный", Ответственный,,, ЗначениеЗаполнено(Ответственный));
		КонецЕсли;
		Если СтруктураБыстрогоОтбора.Свойство("ДальнейшееДействие", ДальнейшееДействие) Тогда
			Если Элементы.ДальнейшееДействиеОтбор.СписокВыбора.Количество() > 0
				И Элементы.ДальнейшееДействиеОтбор.СписокВыбора.НайтиПоЗначению(ДальнейшееДействие) = Неопределено Тогда
				ДальнейшееДействие = Элементы.ДальнейшееДействиеОтбор.СписокВыбора[0].Значение;
			КонецЕсли;
			УстановитьОтборПоДальнейшемуДействию();
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.ОткрытьРаспоряжения Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаКОформлению;
	КонецЕсли;
	
	СобытияФормМДЛППереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораСтатуса(МенеджерОбъекта)
	
	СписокСтатусов = Элементы.СтатусОтбор.СписокВыбора;
	СписокСтатусов.Очистить();
	
	СписокСтатусов.Добавить(Перечисления.СтатусыИнформированияМДЛП.Черновик);
	СписокСтатусов.Добавить(Перечисления.СтатусыИнформированияМДЛП.КОформлению);
	СписокСтатусов.Добавить(Перечисления.СтатусыИнформированияМДЛП.Закрыто);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаСправочникМДЛППрисоединенныеФайлыПротоколОбмена", "Видимость", Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		Настройки.Очистить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если СтруктураБыстрогоОтбора = Неопределено Тогда
		УстановитьОтборПоДальнейшемуДействию();
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Статус", Статус,,, ЗначениеЗаполнено(Статус));
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Организация", Организация,,, ЗначениеЗаполнено(Организация));
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			СписокКОформлению, "Организация", Организация,,, ЗначениеЗаполнено(Организация));
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "МестоДеятельности", МестоДеятельности,,, ЗначениеЗаполнено(МестоДеятельности));
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			СписокКОформлению, "МестоДеятельности", МестоДеятельности,,, ЗначениеЗаполнено(МестоДеятельности));
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Ответственный", Ответственный,,, ЗначениеЗаполнено(Ответственный));
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			СписокКОформлению, "Ответственный", Ответственный,,, ЗначениеЗаполнено(Ответственный));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеСостоянияМДЛП"
	   И ТипЗнч(Параметр.Ссылка) = ТипЗнч(Параметры.Уведомление) Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
	Если ИмяСобытия = "ЗаписьУведомленияИнвентаризацииМДЛП"
	   И ТипЗнч(Параметр.ДокументИнвентаризации) = ТипЗнч(Параметры.Уведомление) Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
	Если ИмяСобытия = "ВыполненОбменМДЛП" Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
	СобытияФормМДЛПКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтветственныйОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Ответственный", Ответственный,,, ЗначениеЗаполнено(Ответственный));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокКОформлению, "Ответственный", Ответственный,,, ЗначениеЗаполнено(Ответственный));
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Организация", Организация,,, ЗначениеЗаполнено(Организация));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокКОформлению, "Организация", Организация,,, ЗначениеЗаполнено(Организация));
	
	УстановитьОтборПоМестуДеятельности();
	
КонецПроцедуры

&НаКлиенте
Процедура МестоДеятельностиОтборПриИзменении(Элемент)
	
	УстановитьОтборПоМестуДеятельности();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Статус", Статус,,, ЗначениеЗаполнено(Статус));
	
КонецПроцедуры

&НаКлиенте
Процедура ДальнейшееДействиеОтборПриИзменении(Элемент)
	
	УстановитьОтборПоДальнейшемуДействию();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокКОформлению

&НаКлиенте
Процедура СписокКОформлениюВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.СписокКОформлению.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьЗначение(, ТекущиеДанные.Основание);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОформитьУведомление(Команда)
	
	ТекущаяСтрока = Элементы.СписокКОформлению.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Или ТипЗнч(ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("Основание", Элементы.СписокКОформлению.ТекущиеДанные.Основание);
	ОткрытьФорму(ПолноеИмяУведомления + ".ФормаОбъекта", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормМДЛПКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект);
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "СписокКОформлению.Дата");
	
	СписокУсловноеОформление = Список.КомпоновщикНастроек.Настройки.УсловноеОформление;
	ИнтеграцияМДЛП.УстановитьУсловноеОформлениеСтатусДальнейшееДействие(
		СписокУсловноеОформление,
		Элементы.Статус.Имя,
		Элементы.ДальнейшееДействие.Имя,
		"Статус",
		"ДальнейшееДействие1");
		
	ИнтеграцияМДЛП.УстановитьУсловноеОформлениеСтатусИнформирования(
		СписокУсловноеОформление,
		Элементы.Статус.Имя,
		"Статус");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоДальнейшемуДействию()
	
	ИнтеграцияМДЛП.УстановитьОтборПоДальнейшемуДействию(
		Список,
		ДальнейшееДействие,
		ИнтеграцияМДЛП.ВсеТребующиеДействияСтатусыИнформирования(),
		ИнтеграцияМДЛП.ВсеТребующиеОжиданияСтатусыИнформирования());
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПоМестуДеятельности()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "МестоДеятельности", МестоДеятельности,,, ЗначениеЗаполнено(МестоДеятельности));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокКОформлению, "МестоДеятельности", МестоДеятельности,,, ЗначениеЗаполнено(МестоДеятельности));
	
КонецПроцедуры

#КонецОбласти

#Область СтандартныеПодсистемы

// СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
	МодульПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	МодульПодключаемыеКоманды = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКоманды");
	МодульПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	МодульПодключаемыеКомандыКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиентСервер");
	МодульПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
