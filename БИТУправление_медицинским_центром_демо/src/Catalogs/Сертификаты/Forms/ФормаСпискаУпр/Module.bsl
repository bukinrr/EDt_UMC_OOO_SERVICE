#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УО = Список.УсловноеОформление.Элементы;
	ЭлементУОПлюс = УО.Добавить();
	ЭлементУОПлюс.Оформление.УстановитьЗначениеПараметра("ЦветТекста",WebЦвета.ЗеленыйЛес);
	ЭлементУОПлюс.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый  Шрифт(WindowsШрифты.ШрифтДиалоговИМеню, , , Истина, , , ) );
	
	// Условие форматирования
	ЭлементУсловия  = ЭлементУОПлюс.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементУсловия.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СуммаОстаток");
	ЭлементУсловия.ВидСравнения = ВидСравненияКомпоновкиДанных.Больше;
	ЭлементУсловия.ПравоеЗначение = 0;
	
	// Оформляемое поле
	ОформлПоле = ЭлементУОПлюс.Поля.Элементы.Добавить();
	ОформлПоле.Поле = Новый ПолеКомпоновкиДанных("СуммаОстаток");
	
	ЭлементУОМинус = УО.Добавить();
	ЭлементУОМинус.Оформление.УстановитьЗначениеПараметра("ЦветТекста",WebЦвета.Кирпичный);
	ЭлементУОМинус.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый  Шрифт(WindowsШрифты.ШрифтДиалоговИМеню, , , Истина, , , ) );
	
	// Условие форматирования
	ЭлементУсловия  = ЭлементУОМинус.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементУсловия.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СуммаОстаток");
	ЭлементУсловия.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ЭлементУсловия.ПравоеЗначение = 0;
	
	// Оформляемое поле
	ОформлПоле = ЭлементУОМинус.Поля.Элементы.Добавить();
	ОформлПоле.Поле = Новый ПолеКомпоновкиДанных("СуммаОстаток");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Истина // ИспользоватьПодключаемоеОборудование Проверка на включенную ФО "Использовать ВО".
	   И МенеджерОборудованияКлиент.ОбновитьРабочееМестоКлиента() Тогда // Проверка на определенность рабочего места ВО.

		ОписаниеОшибки = "";
		
		ПоддерживаемыеТипыВО = Новый Массив();
		ПоддерживаемыеТипыВО.Добавить("СканерШтрихкода");
		ПоддерживаемыеТипыВО.Добавить("СчитывательМагнитныхКарт");
		
		ОповещенияПриПодключении = Новый ОписаниеОповещения("ПодключитьОборудованиеЗавершение", ЭтотОбъект);    
		МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПоТипу(ОповещенияПриПодключении, УникальныйИдентификатор, ПоддерживаемыеТипыВО);
	
	КонецЕсли;
	
	РаботаСДиалогамиКлиент.СкрытьПоказатьАрхивные(Элементы.ФормаСкрытьПоказатьАрхивные, Список, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	// МеханизмВнешнегоОборудования
	ПоддерживаемыеТипыВО = Новый Массив();
	ПоддерживаемыеТипыВО.Добавить("СканерШтрихкода");
	ПоддерживаемыеТипыВО.Добавить("СчитывательМагнитныхКарт");
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПоТипу(Неопределено, УникальныйИдентификатор, ПоддерживаемыеТипыВО);
	// Конец МеханизмВнешнегоОборудования
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ScanData" Тогда
		Если ВводДоступен() Тогда
			ТипШК = Неопределено;
			РаботаСТорговымОборудованиемКлиент.ОбработатьСобытиеСШКФормы(ЭтаФорма, Параметр, ТипШК);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоместитьВАрхив(Команда)

	РаботаСДиалогамиКлиент.ПоместитьВАрхив(Элементы.Список.ВыделенныеСтроки);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьПоказатьАрхивные(Команда)

	РаботаСДиалогамиКлиент.СкрытьПоказатьАрхивные(Элементы.ФормаСкрытьПоказатьАрхивные, Список);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПодключитьОборудованиеЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Если Не РезультатВыполнения.Результат Тогда
		ТекстСообщения = НСтр( "ru = 'При подключении оборудования произошла ошибка:
				|""%ОписаниеОшибки%"".'" );
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%" , РезультатВыполнения.ОписаниеОшибки);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти