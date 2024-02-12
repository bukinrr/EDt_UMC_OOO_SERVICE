#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнтеграцияМДЛППереопределяемый.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	СостояниеПодтверждения = Метаданные().Реквизиты.СостояниеПодтверждения.ЗначениеЗаполнения;
	НомераУпаковок.Очистить();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	
	Если Не ИнтеграцияМДЛП.ИспользоватьХарактеристикиНоменклатуры() Тогда
		НепроверяемыеРеквизиты.Добавить("Товары.Характеристика");
		НепроверяемыеРеквизиты.Добавить("СоставТранспортныхУпаковок.Характеристика");
	КонецЕсли;
	
	Если Не ИнтеграцияМДЛП.ИспользоватьСерииНоменклатуры() Тогда
		НепроверяемыеРеквизиты.Добавить("Товары.Серия");
		НепроверяемыеРеквизиты.Добавить("СоставТранспортныхУпаковок.Серия");
	КонецЕсли;
	
	Если Не ПередачаСведенийОбОтсутствииСерий Тогда
		ИнтеграцияМДЛП.ПроверитьЗаполнениеУпаковок(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	ВсеРеквизиты = Неопределено;
	РеквизитыОперации = Неопределено;
	Документы.УведомлениеОбОтсутствииЛПНаБалансеМДЛП.ЗаполнитьИменаРеквизитовПоФлагуОтстутсвияСерий(ПередачаСведенийОбОтсутствииСерий, ВсеРеквизиты, РеквизитыОперации);
	Для Каждого Реквизит Из ВсеРеквизиты Цикл
		Если РеквизитыОперации.Найти(Реквизит) = Неопределено Тогда
			НепроверяемыеРеквизиты.Добавить(Реквизит);
		КонецЕсли;
	КонецЦикла;
	
	ИнтеграцияМДЛППереопределяемый.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	
	ИнтеграцияМДЛП.ПроверитьВозможностьЗаписиУведомления(ЭтотОбъект, РежимЗаписи);
	
	ВсеРеквизиты = Неопределено;
	РеквизитыОперации = Неопределено;
	Документы.УведомлениеОбОтсутствииЛПНаБалансеМДЛП.ЗаполнитьИменаРеквизитовПоФлагуОтстутсвияСерий(ПередачаСведенийОбОтсутствииСерий, ВсеРеквизиты, РеквизитыОперации);
	ИнтеграцияМДЛП.ОчиститьНеиспользуемыеРеквизиты(ЭтотОбъект, ВсеРеквизиты, РеквизитыОперации);
	
	ИнтеграцияМДЛППереопределяемый.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияМДЛП.ЗаписатьСтатусДокументаПоУмолчанию(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	СтандартнаяОбработка = Истина;
	ИнтеграцияМДЛППереопределяемый.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения, СтандартнаяОбработка);
	Если Не СтандартнаяОбработка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	СтандартнаяОбработка = Истина;
	ИнтеграцияМДЛППереопределяемый.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	Если Не СтандартнаяОбработка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли