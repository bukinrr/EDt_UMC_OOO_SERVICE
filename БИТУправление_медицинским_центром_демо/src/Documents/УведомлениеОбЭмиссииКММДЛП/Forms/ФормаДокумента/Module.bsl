
#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		ВызватьИсключение НСтр("ru = 'Уведомления об эмиссии кодов маркировки поддерживает только загрузку информации из СУЗ. Создание нового документа недоступно.'");
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
		МодульВерсионированиеОбъектов = ОбщегоНазначения.ОбщийМодуль("ВерсионированиеОбъектов");
		МодульВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКоманды = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКоманды");
		МодульПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ИнтеграцияМДЛППереопределяемый.НастроитьПодключаемоеОборудование(ЭтотОбъект);
	
	Если Объект.Ссылка.Пустая() Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	СобытияФормМДЛППереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиентСервер = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКомандыКлиентСервер");
		МодульПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СобытияФормМДЛППереопределяемый.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ПодключаемоеОборудование.СканерыШтрихкода
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование.УстройстваВвода") Тогда
		ПоддерживаемыеТипыПодключаемогоОборудования = "СканерШтрихкода";
		МодульМенеджерОборудованияКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("МенеджерОборудованияКлиент");
		МодульМенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, ПоддерживаемыеТипыПодключаемогоОборудования);
	КонецЕсли;
	// Конец ПодключаемоеОборудование.СканерыШтрихкода
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеСостоянияМДЛП"
	   И Параметр.Ссылка = Объект.Ссылка Тогда
		
		Прочитать();
		
	КонецЕсли;
	
	Если ИмяСобытия = "ВыполненОбменМДЛП" Тогда
		
		ОбновитьСтатусУведомления();
		
	КонецЕсли;
	
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() И Не ТолькоПросмотр Тогда
		Если ИмяСобытия = "ScanData" Тогда
			
			ОбработатьШтрихкоды(ИнтеграцияМДЛПКлиент.ПреобразоватьДанныеСоСканераВМассив(Параметр));
			
		КонецЕсли;
	КонецЕсли;
	
	СобытияФормМДЛПКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ОценкаПроизводительности") Тогда
			МодульОценкаПроизводительностиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОценкаПроизводительностиКлиент");
			МодульОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "Документ.УведомлениеОбЭмиссииКММДЛП.Форма.ФормаДокумента.Провести");
		КонецЕсли;
	КонецЕсли;
	
	СобытияФормМДЛПКлиентПереопределяемый.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ОбновитьСтатусУведомления();
	
	СобытияФормМДЛППереопределяемый.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("Основание", Объект.Основание);
	Оповестить("Запись_УведомлениеОбЭмиссииКММДЛП", ПараметрыЗаписи, Объект.Ссылка);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	// ПодключаемоеОборудование
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование") Тогда
		МодульМенеджерОборудованияКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("МенеджерОборудованияКлиент");
		МодульМенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтатусПредставлениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ИнтеграцияМДЛПКлиент.ОбработатьНавигационнуюСсылкуСтатуса(ЭтотОбъект, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТабличнойЧастиНомераУпаковок

&НаКлиенте
Процедура НомераУпаковокПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		ТекущиеДанные = Элемент.ТекущиеДанные;
		Если Копирование Тогда
			ТекущиеДанные.НомерКиЗ = "";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьДанныеИзТСД(Команда)
	
	ОчиститьСообщения();
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование.ТерминалыСбораДанных") Тогда
		МодульОборудованиеТерминалыСбораДанныхКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОборудованиеТерминалыСбораДанныхКлиент");
		МодульОборудованиеТерминалыСбораДанныхКлиент.НачатьЗагрузкуДанныеИзТСД(
			Новый ОписаниеОповещения("ЗагрузитьИзТСДЗавершение", ЭтотОбъект),
			УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормМДЛПКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ОбновитьСтатусУведомления();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ИнтеграцияМДЛП.УстановитьУсловноеОформлениеОтклоненнойСтроки(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСтатусУведомления()
	
	ТекущийСтатус = ИнтеграцияМДЛП.ТекущийСтатусУведомления(Объект.Ссылка);
	СтатусПредставление = ИнтеграцияМДЛП.ПредставлениеСтатусаУведомления(ТекущийСтатус);
	
	ТолькоПросмотр = Истина;
	
КонецПроцедуры

#Область ОбработкаШтрихкодов

&НаКлиенте
Процедура ЗагрузитьИзТСДЗавершение(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыполнения.Результат Тогда
		ОбработатьШтрихкоды(РезультатВыполнения.ТаблицаТоваров);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьШтрихкоды(ДанныеШтрихкодов)
	
	Если РедактированиеФормыНедоступно Или Элементы.НомераУпаковок.ТолькоПросмотр Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеШтрихкодовПоТипам = ИнтеграцияМДЛПКлиентСервер.РазобратьШтрихкодыПоТипам(ДанныеШтрихкодов);
	
	ПараметрыЗаполнения = ИнтеграцияМДЛПКлиентСервер.ПараметрыЗаполненияТабличнойЧасти();
	
	ДанныеДляОбработки = СобытияФормМДЛПКлиентПереопределяемый.ПодготовитьДанныеДляОбработкиШтрихкодов(
		ЭтотОбъект, ДанныеШтрихкодовПоТипам, КэшированныеЗначения, ПараметрыЗаполнения);
	
	GTINЗаполнен = ЗначениеЗаполнено(Объект.GTIN);
	Для Каждого Данные Из ДанныеШтрихкодовПоТипам.НомераКиЗ Цикл
		
		Если GTINЗаполнен Тогда
			Если Данные.GTIN <> Объект.GTIN Тогда
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Сканируемый GTIN %1 не соответствует введенному'"), Данные.GTIN);
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "Объект.GTIN");
				Продолжить;
			КонецЕсли;
		Иначе
			Объект.GTIN = Данные.GTIN;
			GTINЗаполнен = ЗначениеЗаполнено(Объект.GTIN);
			Если Не GTINЗаполнен Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		НайденныеСтроки = Объект.НомераУпаковок.НайтиСтроки(Новый Структура("НомерКиЗ", Данные.sgtin));
		Если НайденныеСтроки. Количество() > 0 Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Номер упаковки %1 уже присутствует в документе'"), Данные.sgtin);
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Объект.НомераУпаковок", НайденныеСтроки[0].НомерСтроки, "НомерКиЗ");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, Поле);
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = Объект.НомераУпаковок.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Данные);
		НоваяСтрока.НомерКиЗ = Данные.sgtin;
		
		Модифицированность = Истина;
		
	КонецЦикла;
	
	Если ДанныеШтрихкодовПоТипам.НомераТранспортныхУпаковок <> Неопределено Тогда
		Для Каждого Данные Из ДанныеШтрихкодовПоТипам.НомераТранспортныхУпаковок Цикл
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'SSCC %1. Транспортные упаковки в документе не используются'"), Данные.SSCC);
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		КонецЦикла;
	КонецЕсли;
	
	СобытияФормМДЛПКлиентПереопределяемый.ПослеОбработкиШтрихкодов(
		ЭтотОбъект,
		ДанныеДляОбработки,
		КэшированныеЗначения);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СтандартныеПодсистемы

// СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
	МодульПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	МодульПодключаемыеКоманды = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКоманды");
	МодульПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	МодульПодключаемыеКомандыКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиентСервер");
	МодульПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
