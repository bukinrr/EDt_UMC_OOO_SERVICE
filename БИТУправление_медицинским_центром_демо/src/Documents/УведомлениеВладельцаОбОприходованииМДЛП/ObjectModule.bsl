#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнтеграцияМДЛППереопределяемый.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ВызватьИсключение НСтр("ru = 'Уведомление владельца об оприходовании поддерживает только загрузку. Создание нового документа недоступно.'");
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	
	Если Не ИнтеграцияМДЛП.ИспользоватьХарактеристикиНоменклатуры() Тогда
		НепроверяемыеРеквизиты.Добавить("Товары.Характеристика");
	КонецЕсли;
	
	Если Не ИнтеграцияМДЛП.ИспользоватьСерииНоменклатуры() Тогда
		НепроверяемыеРеквизиты.Добавить("Товары.Серия");
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
	
	ИнтеграцияМДЛП.ПроверитьВозможностьЗаписиУведомления(ЭтотОбъект, РежимЗаписи);
	
	ИнтеграцияМДЛП.УбратьНезначащиеСимволы(ЭтотОбъект, "НомерДокумента");
	
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
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	НомераУпаковок.НомерКиЗ     КАК НомерУпаковки,
	|	ЛОЖЬ                        КАК ГрупповаяУпаковка,
	|	НомераУпаковок.НомерСтроки  КАК НомерСтроки,
	|	""НомераУпаковок""          КАК ИмяТабличнойЧасти,
	|	""НомерКиЗ""                КАК ИмяПоля
	|ПОМЕСТИТЬ ПодтвержденныеУпаковки
	|ИЗ
	|	Документ.УведомлениеВладельцаОбОприходованииМДЛП.НомераУпаковок КАК НомераУпаковок
	|ГДЕ
	|	НомераУпаковок.Ссылка = &Ссылка
	|	И НомераУпаковок.СостояниеПодтверждения В (
	|		ЗНАЧЕНИЕ(Перечисление.СостоянияПодтвержденияМДЛП.ОприходованоНовымВладельцем))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НомераУпаковок.НомерУпаковки  КАК НомерУпаковки,
	|	ИСТИНА                        КАК ГрупповаяУпаковка,
	|	НомераУпаковок.НомерСтроки    КАК НомерСтроки,
	|	""ТранспортныеУпаковки""      КАК ИмяТабличнойЧасти,
	|	""НомерУпаковки""             КАК ИмяПоля
	|ИЗ
	|	Документ.УведомлениеВладельцаОбОприходованииМДЛП.ТранспортныеУпаковки КАК НомераУпаковок
	|ГДЕ
	|	НомераУпаковок.Ссылка = &Ссылка
	|	И НомераУпаковок.СостояниеПодтверждения В (
	|		ЗНАЧЕНИЕ(Перечисление.СостоянияПодтвержденияМДЛП.ОприходованоНовымВладельцем))
	|");
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("МестоДеятельности", МестоДеятельности);
	Запрос.УстановитьПараметр("ПустаяГрупповаяУпаковка", Метаданные.ОпределяемыеТипы.SSCC.Тип.ПривестиЗначение());
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
	ИнтеграцияМДЛП.ДобавитьКлючиУпаковок(Запрос.МенеджерВременныхТаблиц, "ПодтвержденныеУпаковки");
	
	// ИнтеграцияМДЛП.Инвентаризация
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтеграцияМДЛП.Инвентаризация") Тогда
		
		ПараметрыОперации = ИнтеграцияМДЛП.ПараметрыОперацииИзмененияСтатусаУпаковок();
		ПараметрыОперации.МестоДеятельности = МестоДеятельности;
		ПараметрыОперации.ДокументРезерва = Ссылка;
		
		МодульИнвентаризацияМДЛП = ОбщегоНазначения.ОбщийМодуль("ИнвентаризацияМДЛП");
		МодульИнвентаризацияМДЛП.ПоместитьДанныеВТаблицуНомераУпаковок(Запрос.МенеджерВременныхТаблиц, "ПодтвержденныеУпаковки");
		ПроверкаПройдена = МодульИнвентаризацияМДЛП.ПроверитьДоступностьУпаковок(Запрос.МенеджерВременныхТаблиц, ПараметрыОперации, Отказ);
		Если Не ПроверкаПройдена Тогда
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	// Конец ИнтеграцияМДЛП.Инвентаризация
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ДанныеУпаковок.НомерУпаковки           КАК НомерУпаковки,
	|	ДанныеУпаковок.КлючУпаковки            КАК КлючУпаковки,
	|	ДанныеУпаковок.МестоДеятельности       КАК МестоДеятельности,
	|	ДанныеУпаковок.НомерГрупповойУпаковки  КАК НомерГрупповойУпаковки,
	|	ДанныеУпаковок.ДокументРезерва         КАК ДокументРезерва,
	|	ДанныеУпаковок.ГрупповаяУпаковка       КАК ГрупповаяУпаковка
	|ПОМЕСТИТЬ ДанныеУпаковок
	|ИЗ
	|	РегистрСведений.УпаковкиМДЛП КАК ДанныеУпаковок
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|			ПодтвержденныеУпаковки КАК ПодтвержденныеУпаковки
	|		ПО
	|			ПодтвержденныеУпаковки.НомерУпаковки = ДанныеУпаковок.НомерУпаковки
	|			И ПодтвержденныеУпаковки.КлючУпаковки = ДанныеУпаковок.КлючУпаковки
	|			И ДанныеУпаковок.МестоДеятельности = &МестоДеятельности
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	// Родительские упаковки самого верхнего уровня. Необходимы в случае если в 702 было использовано автоизъятие.
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РодительскиеУпаковкиСамогоВерхнегоУровня.НомерУпаковки      КАК НомерУпаковки,
	|	РодительскиеУпаковкиСамогоВерхнегоУровня.КлючУпаковки       КАК КлючУпаковки,
	|	РодительскиеУпаковкиСамогоВерхнегоУровня.МестоДеятельности  КАК МестоДеятельности
	|ПОМЕСТИТЬ РодительскиеУпаковкиСамогоВерхнегоУровня
	|ИЗ
	|	ДанныеУпаковок КАК ДанныеУпаковок
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|			РегистрСведений.УпаковкиМДЛП КАК РодительскиеУпаковкиСамогоВерхнегоУровня
	|		ПО
	|			РодительскиеУпаковкиСамогоВерхнегоУровня.НомерУпаковки = ДанныеУпаковок.ДокументРезерва
	|			И РодительскиеУпаковкиСамогоВерхнегоУровня.МестоДеятельности = &МестоДеятельности
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	// Родительские упаковки самого верхнего уровня.
	|ВЫБРАТЬ
	|	РодительскиеУпаковкиСамогоВерхнегоУровня.НомерУпаковки      КАК НомерУпаковки,
	|	РодительскиеУпаковкиСамогоВерхнегоУровня.КлючУпаковки       КАК КлючУпаковки,
	|	РодительскиеУпаковкиСамогоВерхнегоУровня.МестоДеятельности  КАК МестоДеятельности,
	|	ЛОЖЬ                                                        КАК КСписанию
	|ИЗ
	|	РодительскиеУпаковкиСамогоВерхнегоУровня КАК РодительскиеУпаковкиСамогоВерхнегоУровня
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	// Вложенные упаковки.
	|ВЫБРАТЬ
	|	ВложенныеУпаковки.НомерУпаковки            КАК НомерУпаковки,
	|	ВложенныеУпаковки.КлючУпаковки             КАК КлючУпаковки,
	|	ВложенныеУпаковки.МестоДеятельности        КАК МестоДеятельности,
	|	ВложенныеУпаковки.НомерГрупповойУпаковки   КАК НомерГрупповойУпаковки,
	|	ВложенныеУпаковки.ДокументРезерва          КАК ДокументРезерва,
	|	ВложенныеУпаковки.ГрупповаяУпаковка        КАК ГрупповаяУпаковка,
	|	НЕ ДанныеУпаковок.НомерУпаковки ЕСТЬ NULL  КАК КСписанию
	|ИЗ
	|	РодительскиеУпаковкиСамогоВерхнегоУровня КАК РодительскиеУпаковкиСамогоВерхнегоУровня
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|			РегистрСведений.УпаковкиМДЛП КАК ВложенныеУпаковки
	|				ЛЕВОЕ СОЕДИНЕНИЕ
	|					ДанныеУпаковок КАК ДанныеУпаковок
	|				ПО
	|					ДанныеУпаковок.НомерУпаковки = ВложенныеУпаковки.НомерУпаковки
	|					И ДанныеУпаковок.КлючУпаковки = ВложенныеУпаковки.КлючУпаковки
	|		ПО
	|			ВложенныеУпаковки.ДокументРезерва = РодительскиеУпаковкиСамогоВерхнегоУровня.НомерУпаковки
	|			И ВложенныеУпаковки.МестоДеятельности = &МестоДеятельности
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	// Упаковки без родителей: потребительские упаковки или групповые упаковки самого верхнего уровня, у которых все вложенные упаковки можно списать без проверки.
	|ВЫБРАТЬ
	|	ДанныеУпаковок.НомерУпаковки      КАК НомерУпаковки,
	|	ДанныеУпаковок.КлючУпаковки       КАК КлючУпаковки,
	|	ДанныеУпаковок.МестоДеятельности  КАК МестоДеятельности,
	|	ДанныеУпаковок.ГрупповаяУпаковка  КАК ГрупповаяУпаковка
	|ИЗ
	|	ДанныеУпаковок КАК ДанныеУпаковок
	|ГДЕ
	|	ДанныеУпаковок.НомерГрупповойУпаковки = &ПустаяГрупповаяУпаковка
	|";
	
	Результат = Запрос.ВыполнитьПакет();
	
	ОтразитьСписание = Результат[Результат.ВГраница()].Выбрать();
	Пока ОтразитьСписание.Следующий() Цикл
		Если ОтразитьСписание.ГрупповаяУпаковка Тогда
			УдалитьУпаковки = РегистрыСведений.УпаковкиМДЛП.СоздатьНаборЗаписей();
			УдалитьУпаковки.Отбор.ДокументРезерва.Установить(ОтразитьСписание.НомерУпаковки);
			УдалитьУпаковки.Отбор.МестоДеятельности.Установить(ОтразитьСписание.МестоДеятельности);
			УдалитьУпаковки.Записать();
		КонецЕсли;
		ОтразитьСписание(ОтразитьСписание);
	КонецЦикла;
	
	ДанныеРодителей = Результат[Результат.ВГраница() - 2].Выгрузить();
	ДанныеВложенных = Результат[Результат.ВГраница() - 1].Выгрузить();
	
	Для Каждого СтрокаРодителя Из ДанныеРодителей Цикл
		ОтразитьСписаниеРекурсивно(СтрокаРодителя, ДанныеВложенных);
		Если СтрокаРодителя.КСписанию Тогда
			ОтразитьСписание(СтрокаРодителя);
		КонецЕсли;
	КонецЦикла;
	
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

#Область СлужебныеПроцедурыИФункции

Процедура ОтразитьСписаниеРекурсивно(СтрокаРодителя, ДанныеВложенных)
	
	КСписанию = Истина;
	
	НайденныеВложенные = ДанныеВложенных.НайтиСтроки(Новый Структура("НомерГрупповойУпаковки", СтрокаРодителя.НомерУпаковки));
	Для Каждого СтрокаВложенного Из НайденныеВложенные Цикл
		
		Если СтрокаРодителя.КСписанию Тогда
			СтрокаВложенного.КСписанию = Истина;
		КонецЕсли;
		
		Если СтрокаВложенного.ГрупповаяУпаковка Тогда
			ОтразитьСписаниеРекурсивно(СтрокаВложенного, ДанныеВложенных);
			Если СтрокаВложенного.КСписанию Тогда
				ОтразитьСписание(СтрокаВложенного);
			КонецЕсли;
		Иначе
			Если СтрокаВложенного.КСписанию Тогда
				ОтразитьСписание(СтрокаВложенного);
			КонецЕсли;
		КонецЕсли;
		
		КСписанию = КСписанию И СтрокаВложенного.КСписанию;
		
	КонецЦикла;
	
	СтрокаРодителя.КСписанию = КСписанию;
	
КонецПроцедуры

Процедура ОтразитьСписание(Данные)
	
	УдалитьУпаковки = РегистрыСведений.УпаковкиМДЛП.СоздатьНаборЗаписей();
	УдалитьУпаковки.Отбор.НомерУпаковки.Установить(Данные.НомерУпаковки);
	УдалитьУпаковки.Отбор.КлючУпаковки.Установить(Данные.КлючУпаковки);
	УдалитьУпаковки.Отбор.МестоДеятельности.Установить(Данные.МестоДеятельности);
	УдалитьУпаковки.Записать();
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции

#КонецЕсли