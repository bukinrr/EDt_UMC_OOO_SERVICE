///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Результат = ОбновлениеИнформационнойБазы.ОбъектОбработан(
		"Справочник.НастройкиИнтеграцииСПлатежнымиСистемами");
	
	Если Не Результат.Обработан Тогда
		ЭтотОбъект.ТолькоПросмотр = Истина;
		Элементы.Список.Доступность = Ложь;
		ОбщегоНазначения.СообщитьПользователю(
			Результат.ТекстИсключения);
	КонецЕсли;
	
	Если Параметры.Свойство("СверкаВзаиморасчетов") И Параметры.СверкаВзаиморасчетов Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"Родитель.ПлатежнаяСистема",
			ИнтеграцияСПлатежнымиСистемамиСлужебный.ПлатежныеСистемыСверкиВзаиморасчетов(),
			ВидСравненияКомпоновкиДанных.ВСписке,
			НСтр("ru = 'Платежные системы'"),
			Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ЭлементОформления = Список.УсловноеОформление.Элементы.Добавить();
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	ОформлениеОтбор = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ОформлениеОтбор = ОформлениеОтбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОформлениеОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПометкаУдаления");
	ОформлениеОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОформлениеОтбор.ПравоеЗначение = Истина;
	
	ЭлементОформления = Список.УсловноеОформление.Элементы.Добавить();
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра(
		"ЦветТекста",
		Метаданные.ЭлементыСтиля.ЦветНеАктивнойСтроки.Значение);
	
	ОформлениеОтбор = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ОформлениеОтбор = ОформлениеОтбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОформлениеОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Используется");
	ОформлениеОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОформлениеОтбор.ПравоеЗначение = Ложь;
	
КонецПроцедуры

#КонецОбласти