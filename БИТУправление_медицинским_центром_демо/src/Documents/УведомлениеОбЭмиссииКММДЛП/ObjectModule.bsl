#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнтеграцияМДЛППереопределяемый.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ВызватьИсключение НСтр("ru = 'Уведомления об эмиссии кодов маркировки поддерживает только загрузку информации из СУЗ. Создание нового документа недоступно.'");
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	
	ИнтеграцияМДЛП.ПроверитьЗаполнениеУпаковок(ЭтотОбъект, Отказ, 150000);
	
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
	
	ПараметрыОперации = ИнтеграцияМДЛП.ПараметрыОперацииИзмененияСтатусаУпаковок();
	ПараметрыОперации.ИсходныйСтатус    = Перечисления.СтатусыУпаковокМДЛП.ПустаяСсылка();
	ПараметрыОперации.НовыйСтатус       = Перечисления.СтатусыУпаковокМДЛП.Эмитирована;
	ПараметрыОперации.МестоДеятельности = Организация;
	ИнтеграцияМДЛП.ПровестиДокументПоРегиструУпаковок(Ссылка, ПараметрыОперации, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	СтандартнаяОбработка = Истина;
	ИнтеграцияМДЛППереопределяемый.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	Если Не СтандартнаяОбработка Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияМДЛП.ОтменитьРезерв(Ссылка);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли