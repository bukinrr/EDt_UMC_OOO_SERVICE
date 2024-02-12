#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнтеграцияМДЛППереопределяемый.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	СостояниеПодтверждения = Метаданные().Реквизиты.СостояниеПодтверждения.ЗначениеЗаполнения;
	ДатаНачала = Неопределено;
	ДатаОкончания = Неопределено;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	Если СостояниеПодтверждения <> Перечисления.СостоянияПодтвержденияМДЛП.Завершено Тогда
		НепроверяемыеРеквизиты.Добавить("ДатаОкончания");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДатаОкончания) И ДатаНачала > ДатаОкончания Тогда
		ТекстОшибки = НСтр("ru = 'Дата начала больше даты окончания.'");
		ТекстОшибки = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, "Корректность", НСтр("ru = 'Дата начала'"),,, ТекстОшибки);
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, Ссылка, "ДатаНачала", "Объект", Отказ);
	КонецЕсли;
	
	ИнтеграцияМДЛППереопределяемый.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	
	ИсключаемыеРеквизиты = Новый Массив;
	ИсключаемыеРеквизиты.Добавить("ДатаОкончания");
	
	ИнтеграцияМДЛП.ПроверитьВозможностьЗаписиУведомления(ЭтотОбъект, РежимЗаписи, ИсключаемыеРеквизиты);
	
	ПроверитьНаличиеПересекающихсяДокументов(Отказ);
	
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
	
	Если СостояниеПодтверждения = Перечисления.СостоянияПодтвержденияМДЛП.Завершено Тогда
		РегистрыСведений.ИнвентаризированныеУпаковкиМДЛП.УдалитьЗаписиИнвентаризационнойОписи(Ссылка);
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

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьНаличиеПересекающихсяДокументов(Отказ)
	
	СостояниеПодтвержденияЗавершено = Перечисления.СостоянияПодтвержденияМДЛП.Завершено;
	Если СостояниеПодтверждения = СостояниеПодтвержденияЗавершено Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	СуществующиеДокументы.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ИнвентаризационнаяОписьМДЛП КАК СуществующиеДокументы
	|ГДЕ
	|	НЕ &ПометкаУдаления
	|	И НЕ СуществующиеДокументы.ПометкаУдаления
	|	И СуществующиеДокументы.Ссылка <> &Ссылка
	|	И СуществующиеДокументы.Организация = &Организация
	|	И СуществующиеДокументы.МестоДеятельности = &МестоДеятельности
	|	И СуществующиеДокументы.СостояниеПодтверждения <> &СостояниеПодтвержденияЗавершено
	|");
	
	Запрос.УстановитьПараметр("ПометкаУдаления", ПометкаУдаления);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("МестоДеятельности", МестоДеятельности);
	Запрос.УстановитьПараметр("СостояниеПодтвержденияЗавершено", СостояниеПодтвержденияЗавершено);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ТекстОшибки = НСтр("ru = 'Документ с пересекающимися реквизитами уже существует: %1'");
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, Выборка.Ссылка);
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, Выборка.Ссылка,,, Отказ);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли