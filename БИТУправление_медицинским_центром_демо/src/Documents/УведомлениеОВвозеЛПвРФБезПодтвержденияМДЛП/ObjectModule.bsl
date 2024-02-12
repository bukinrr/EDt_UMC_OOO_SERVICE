#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнтеграцияМДЛППереопределяемый.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	СостояниеПодтверждения = Метаданные().Реквизиты.СостояниеПодтверждения.ЗначениеЗаполнения;
	НомераУпаковок.Очистить();
	ТранспортныеУпаковки.Очистить();
	СоставТранспортныхУпаковок.Очистить();
	ИерархияГрупповыхУпаковок.Очистить();
	
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
	
	ИнтеграцияМДЛП.ПроверитьЗаполнениеУпаковок(ЭтотОбъект, Отказ);
	
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
	
	ОбрабатываемыеСостояния = Новый Массив;
	ОбрабатываемыеСостояния.Добавить(Перечисления.СостоянияПодтвержденияМДЛП.КПередаче);
	ОбрабатываемыеСостояния.Добавить(Перечисления.СостоянияПодтвержденияМДЛП.ПринятоГИСМ);
	ОбрабатываемыеСостояния.Добавить(Перечисления.СостоянияПодтвержденияМДЛП.ОтклоненоГИСМ);
	
	Если ОбрабатываемыеСостояния.Найти(СостояниеПодтверждения) = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОперации = ИнтеграцияМДЛП.ПараметрыОперацииИзмененияСтатусаУпаковок();
	ПараметрыОперации.ДатаОперации    = Дата;
	ПараметрыОперации.ДокументРезерва = Ссылка;
	
	ПараметрыОперации.СтатусВРезерве    = Перечисления.СтатусыУпаковокМДЛП.ВРезерве;
	ПараметрыОперации.НовыйСтатус       = Перечисления.СтатусыУпаковокМДЛП.ВвезенНаТерриториюРФ;
	ПараметрыОперации.МестоДеятельности = Организация;
	
	ИсходныйСтатус = Новый Массив;
	ИсходныйСтатус.Добавить(Перечисления.СтатусыУпаковокМДЛП.ПустаяСсылка());
	ИсходныйСтатус.Добавить(Перечисления.СтатусыУпаковокМДЛП.ВУпаковке);
	ИсходныйСтатус.Добавить(Перечисления.СтатусыУпаковокМДЛП.ОжидаетОтгрузкиВРФ);
	ИсходныйСтатус.Добавить(Перечисления.СтатусыУпаковокМДЛП.ВвезенНаТерриториюРФ);
	ИсходныйСтатус.Добавить(Перечисления.СтатусыУпаковокМДЛП.Задекларирована);
	ИсходныйСтатус.Добавить(Перечисления.СтатусыУпаковокМДЛП.ПринятаНаСкладИзЗТК);
	
	ПараметрыОперации.ИсходныйСтатус = ИсходныйСтатус;
	
	ПараметрыОперации.ИспользуетсяЗонаТаможенногоКонтроля = Истина;
	ПараметрыОперации.НоваяЗонаТаможенногоКонтроля        = ЗонаТаможенногоКонтроля;
	
	Если СостояниеПодтверждения = Перечисления.СостоянияПодтвержденияМДЛП.ОтклоненоГИСМ Тогда
		ИнтеграцияМДЛП.ОтменитьРезерв(Ссылка);
	ИначеЕсли СостояниеПодтверждения = Перечисления.СостоянияПодтвержденияМДЛП.КПередаче Тогда
		ИнтеграцияМДЛП.ПровестиДокументПоРегиструУпаковок(Ссылка, ПараметрыОперации, Отказ);
	ИначеЕсли СостояниеПодтверждения = Перечисления.СостоянияПодтвержденияМДЛП.ПринятоГИСМ Тогда
		
		Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	НомераУпаковок.НомерСтроки  КАК НомерСтроки,
		|	НомераУпаковок.НомерКиЗ     КАК НомерУпаковки,
		|	1                           КАК ДоляУпаковки,
		|	ЛОЖЬ                        КАК ГрупповаяУпаковка,
		|	""НомераУпаковок""          КАК ИмяТабличнойЧасти,
		|	""НомерКиЗ""                КАК ИмяПоля
		|ПОМЕСТИТЬ ПодтвержденныеУпаковки
		|ИЗ
		|	Документ.УведомлениеОВвозеЛПвРФБезПодтвержденияМДЛП.НомераУпаковок КАК НомераУпаковок
		|ГДЕ
		|	НомераУпаковок.Ссылка = &Ссылка
		|	И НЕ НомераУпаковок.Отклонено
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	НомераУпаковок.НомерСтроки    КАК НомерСтроки,
		|	НомераУпаковок.НомерУпаковки  КАК НомерУпаковки,
		|	1                             КАК ДоляУпаковки,
		|	ИСТИНА                        КАК ГрупповаяУпаковка,
		|	""ТранспортныеУпаковки""      КАК ИмяТабличнойЧасти,
		|	""НомерУпаковки""             КАК ИмяПоля
		|ИЗ
		|	Документ.УведомлениеОВвозеЛПвРФБезПодтвержденияМДЛП.ТранспортныеУпаковки КАК НомераУпаковок
		|ГДЕ
		|	НомераУпаковок.Ссылка = &Ссылка
		|	И НЕ НомераУпаковок.Отклонено
		|");
		
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.УстановитьПараметр("ДокументРезерва", ПараметрыОперации.ДокументРезерва);
		Запрос.УстановитьПараметр("МестоДеятельности", ПараметрыОперации.МестоДеятельности);
		Запрос.УстановитьПараметр("ЗонаТаможенногоКонтроля", ПараметрыОперации.НоваяЗонаТаможенногоКонтроля);
		
		Запрос.УстановитьПараметр("НовыйСтатус", ПараметрыОперации.НовыйСтатус);
		Запрос.УстановитьПараметр("ДатаСтатуса", ПараметрыОперации.ДатаОперации);
		
		Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
		ИнтеграцияМДЛП.ДобавитьКлючиУпаковок(Запрос.МенеджерВременныхТаблиц, "ПодтвержденныеУпаковки");
		
		Запрос.Текст = "
		// Все зарезервированные упаковки
		|ВЫБРАТЬ
		|	ДанныеУпаковок.НомерУпаковки                   КАК НомерУпаковки,
		|	&МестоДеятельности                             КАК МестоДеятельности,
		|	&ЗонаТаможенногоКонтроля                       КАК ЗонаТаможенногоКонтроля,
		|	НЕОПРЕДЕЛЕНО                                   КАК ДокументРезерва,
		|	&НовыйСтатус                                   КАК Статус,
		|	&ДатаСтатуса                                   КАК ДатаСтатуса,
		|	ДанныеУпаковок.Владелец                        КАК Владелец,
		|	ДанныеУпаковок.НомерГрупповойУпаковки          КАК НомерГрупповойУпаковки,
		|	ДанныеУпаковок.ГрупповаяУпаковка               КАК ГрупповаяУпаковка,
		|	ДанныеУпаковок.ВложеныПотребительскиеУпаковки  КАК ВложеныПотребительскиеУпаковки
		|ИЗ
		|	ПодтвержденныеУпаковки КАК ПодтвержденныеУпаковки
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|			РегистрСведений.УпаковкиМДЛП КАК ДанныеУпаковок
		|		ПО
		|			ПодтвержденныеУпаковки.НомерУпаковки = ДанныеУпаковок.НомерУпаковки
		|			И ПодтвержденныеУпаковки.КлючУпаковки = ДанныеУпаковок.КлючУпаковки
		|			И ДанныеУпаковок.ДокументРезерва = &ДокументРезерва
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		// Потребительские упаковки, находящиеся в транспортных упаковках.
		|ВЫБРАТЬ
		|	НомераУпаковок.НомерКиЗ                               КАК НомерУпаковки,
		|	&МестоДеятельности                                    КАК МестоДеятельности,
		|	&ЗонаТаможенногоКонтроля                              КАК ЗонаТаможенногоКонтроля,
		|	ВерхнеуровневыеУпаковки.НомерУпаковки                 КАК ДокументРезерва,
		|	ЗНАЧЕНИЕ(Перечисление.СтатусыУпаковокМДЛП.ВУпаковке)  КАК Статус,
		|	&ДатаСтатуса                                          КАК ДатаСтатуса,
		|	ДанныеУпаковок.Владелец                               КАК Владелец,
		|	НомераУпаковок.НомерРодительскойУпаковки              КАК НомерГрупповойУпаковки,
		|	ЛОЖЬ                                                  КАК ГрупповаяУпаковка,
		|	НЕОПРЕДЕЛЕНО                                          КАК ВложеныПотребительскиеУпаковки
		|ИЗ
		|	Документ.УведомлениеОВвозеЛПвРФБезПодтвержденияМДЛП.ТранспортныеУпаковки КАК ТранспортныеУпаковки
		|		
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|			Документ.УведомлениеОВвозеЛПвРФБезПодтвержденияМДЛП.СоставТранспортныхУпаковок КАК СоставТранспортныхУпаковок
		|		ПО
		|			СоставТранспортныхУпаковок.Ссылка = &Ссылка
		|			И СоставТранспортныхУпаковок.ИдентификаторСтроки = ТранспортныеУпаковки.ИдентификаторСтроки
		|		
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|			Документ.УведомлениеОВвозеЛПвРФБезПодтвержденияМДЛП.НомераУпаковок КАК НомераУпаковок
		|		ПО
		|			НомераУпаковок.Ссылка = &Ссылка
		|			И НомераУпаковок.ИдентификаторСтроки = СоставТранспортныхУпаковок.ИдентификаторСтрокиУпаковки
		|		
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|			ПодтвержденныеУпаковки КАК ВерхнеуровневыеУпаковки
		|				
		|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|					РегистрСведений.УпаковкиМДЛП КАК ДанныеУпаковок
		|				ПО
		|					ВерхнеуровневыеУпаковки.НомерУпаковки = ДанныеУпаковок.НомерУпаковки
		|					И ВерхнеуровневыеУпаковки.КлючУпаковки = ДанныеУпаковок.КлючУпаковки
		|					И ДанныеУпаковок.ДокументРезерва = &ДокументРезерва
		|		ПО
		|			ВерхнеуровневыеУпаковки.НомерУпаковки = ТранспортныеУпаковки.НомерУпаковки
		|ГДЕ
		|	ТранспортныеУпаковки.Ссылка = &Ссылка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		// Групповые упаковки, находящиеся в транспортных упаковках.
		|ВЫБРАТЬ
		|	НомераУпаковок.НомерУпаковки                          КАК НомерУпаковки,
		|	&МестоДеятельности                                    КАК МестоДеятельности,
		|	&ЗонаТаможенногоКонтроля                              КАК ЗонаТаможенногоКонтроля,
		|	ВерхнеуровневыеУпаковки.НомерУпаковки                 КАК ДокументРезерва,
		|	ЗНАЧЕНИЕ(Перечисление.СтатусыУпаковокМДЛП.ВУпаковке)  КАК Статус,
		|	&ДатаСтатуса                                          КАК ДатаСтатуса,
		|	ДанныеУпаковок.Владелец                               КАК Владелец,
		|	НомераУпаковок.НомерРодительскойУпаковки              КАК НомерГрупповойУпаковки,
		|	ИСТИНА                                                КАК ГрупповаяУпаковка,
		|	НЕ ПервыйУровеньУпаковок.НомерУпаковки ЕСТЬ NULL      КАК ВложеныПотребительскиеУпаковки
		|ИЗ
		|	Документ.УведомлениеОВвозеЛПвРФБезПодтвержденияМДЛП.ТранспортныеУпаковки КАК ТранспортныеУпаковки
		|		
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|			Документ.УведомлениеОВвозеЛПвРФБезПодтвержденияМДЛП.ИерархияГрупповыхУпаковок КАК НомераУпаковок
		|		ПО
		|			НомераУпаковок.Ссылка = &Ссылка
		|			И НомераУпаковок.ИдентификаторСтроки = ТранспортныеУпаковки.ИдентификаторСтроки
		|		
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|			ПодтвержденныеУпаковки КАК ВерхнеуровневыеУпаковки
		|				
		|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|					РегистрСведений.УпаковкиМДЛП КАК ДанныеУпаковок
		|				ПО
		|					ВерхнеуровневыеУпаковки.НомерУпаковки = ДанныеУпаковок.НомерУпаковки
		|					И ВерхнеуровневыеУпаковки.КлючУпаковки = ДанныеУпаковок.КлючУпаковки
		|					И ДанныеУпаковок.ДокументРезерва = &ДокументРезерва
		|		ПО
		|			ВерхнеуровневыеУпаковки.НомерУпаковки = ТранспортныеУпаковки.НомерУпаковки
		|		
		|		ЛЕВОЕ СОЕДИНЕНИЕ
		|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|				Т.НомерРодительскойУпаковки КАК НомерУпаковки
		|			ИЗ
		|				Документ.УведомлениеОВвозеЛПвРФБезПодтвержденияМДЛП.НомераУпаковок КАК Т
		|			ГДЕ
		|				Т.Ссылка = &Ссылка) КАК ПервыйУровеньУпаковок
		|		ПО
		|			ПервыйУровеньУпаковок.НомерУпаковки = НомераУпаковок.НомерУпаковки
		|ГДЕ
		|	НомераУпаковок.Ссылка = &Ссылка
		|";
		
		ОтразитьПоступление = Запрос.Выполнить().Выбрать();
		
		// Записываем номера упаковок, по которым необходимо отразить поступление.
		Набор = РегистрыСведений.УпаковкиМДЛП.СоздатьНаборЗаписей();
		Пока ОтразитьПоступление.Следующий() Цикл
			
			ЗаполнитьЗначенияСвойств(Набор.Добавить(), ОтразитьПоступление);
			
			// Удаляем зависшие номера упаковок по предыдущим операциям других документов и других типов документов, если по этому документу удалось отразить поступление.
			УдалитьУпаковки = РегистрыСведений.УпаковкиМДЛП.СоздатьНаборЗаписей();
			УдалитьУпаковки.Отбор.НомерУпаковки.Установить(ОтразитьПоступление.НомерУпаковки);
			УдалитьУпаковки.Отбор.КлючУпаковки.Установить(ИнтеграцияМДЛПКлиентСервер.ПолучитьКлючУпаковки(ОтразитьПоступление.НомерУпаковки));
			УдалитьУпаковки.Записать();
			
		КонецЦикла;
		
		Если Набор.Количество() > 0 Тогда
			Набор.Записать(Ложь);
		КонецЕсли;
		
		// Удаляем упаковки из резерва этого документа, по которым не удалось отразить поступление.
		УдалитьУпаковки = РегистрыСведений.УпаковкиМДЛП.СоздатьНаборЗаписей();
		УдалитьУпаковки.Отбор.ДокументРезерва.Установить(ПараметрыОперации.ДокументРезерва);
		УдалитьУпаковки.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	СтандартнаяОбработка = Истина;
	ИнтеграцияМДЛППереопределяемый.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	Если Не СтандартнаяОбработка Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	""""  КАК НомерУпаковки,
	|	""""  КАК КлючУпаковки,
	|	1     КАК ДоляУпаковки
	|ПОМЕСТИТЬ ОстаткиДолейУпаковок
	|ГДЕ
	|	ЛОЖЬ
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	""""  КАК НомерУпаковки,
	|	""""  КАК КлючУпаковки,
	|	1     КАК ДоляУпаковки,
	|	ЛОЖЬ  КАК ГрупповаяУпаковка
	|ПОМЕСТИТЬ НомераУпаковок
	|ГДЕ
	|	ЛОЖЬ
	|");
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
	ПараметрыОперации = ИнтеграцияМДЛП.ПараметрыОперацииИзмененияСтатусаУпаковок();
	ПараметрыОперации.ДокументРезерва = Ссылка;
	
	ИнтеграцияМДЛП.ЗарезервироватьУпаковки(Запрос.МенеджерВременныхТаблиц, ПараметрыОперации);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли