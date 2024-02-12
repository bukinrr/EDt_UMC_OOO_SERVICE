#Область ПрограммныйИнтерфейс

// Рассчитать ячейку произвольного алгоритма без контекста модуля объекта Календаря планирования.
//
// Параметры:
//  ТаблицаРезультат - ТаблицаЗначений - таблица значений для каждого объекта календаря
//  ЯчейкаКалендаря	 - СправочникСсылка.ЯчейкиКалендаря	 - рассчитываемая ячейка.
//  ОбъектыКалендаря - Массив - СправочникСсылка.Клиенты или ДокументСсылка.Заяака.
//	СообщениеОбОшибке - Строка - сообщение об ошибке.
//
Процедура РассчитатьЯчейкуПроизвольногоАлгоритма(ТаблицаРезультат, Знач ЯчейкаКалендаря, Знач ОбъектыКалендаря, СообщениеОбОшибке = Неопределено) Экспорт
	
	Если ТипЗнч(ЯчейкаКалендаря) <> Тип("СправочникСсылка.ЯчейкиКалендаря") Тогда
		ВызватьИсключение "Нецелевое использование расчета";
	КонецЕсли;
	
	Если СообщениеОбОшибке = Неопределено Тогда
		РежимТестирования = Ложь;
	Иначе
		РежимТестирования = Истина;
	КонецЕсли;
	
	ТаблицаРезультатЯчейки = ТаблицаРезультат.СкопироватьКолонки();
	
	ПередФормированием	 = ЯчейкаКалендаря.ПередФормированием;
	АлгоритмРасчета		 = ЯчейкаКалендаря.УсловиеПрименения;
	
	// Ожидаемый тип
	ОжидаемыеТипы = Новый Массив;
	Если ЯчейкаКалендаря.ТипПризнака = 1 Тогда
		ОжидаемыеТипы.Добавить(Тип("Цвет"));
	ИначеЕсли ЯчейкаКалендаря.ТипПризнака = 2 Тогда
		ОжидаемыеТипы.Добавить(Тип("ДвоичныеДанные"));
		ОжидаемыеТипы.Добавить(Тип("Картинка"));
	КонецЕсли;
	
	Параметры = Новый Структура;
	Параметры.Вставить("ЯчейкаКалендаря", ЯчейкаКалендаря);
	Параметры.Вставить("ОбъектыКалендаря", ОбъектыКалендаря);
	Параметры.Вставить("ТаблицаРезультат", ТаблицаРезультатЯчейки.Скопировать());
	Параметры.Вставить("ОжидаемыеТипы", ОжидаемыеТипы);
	
	// Не используется.
	// УстановитьБезопасныйРежим(Истина);
	
	// Перед формированием
	Если Не ПустаяСтрока(ПередФормированием) Тогда
		
		ВыполнитьОбработчикЯчейкиПроизвольногоАлгоритма(ПередФормированием, Параметры, СообщениеОбОшибке);
		
		Если РежимТестирования И ЗначениеЗаполнено(СообщениеОбОшибке) Тогда
			Возврат;
		КонецЕсли;
		
		// Перенос в таблицу результата того, что в "Перед формированием" было для неё добавлено.
		Попытка
			ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(Параметры.ТаблицаРезультат, ТаблицаРезультатЯчейки);
		Исключение
			// Сломали таблицу результата. Игнорируем её.
		КонецПопытки;
	КонецЕсли;
	
	// Обход алгоритма расчета для каждого объекта календаря.
	Для Каждого Объект Из ОбъектыКалендаря Цикл
		
		Значение = ВычислитьПризнакПоПроизвольномуКоду(АлгоритмРасчета, Объект, Параметры, СообщениеОбОшибке);
		
		Если Значение <> Неопределено
			И (ОжидаемыеТипы.Количество() = 0 
				Или ОжидаемыеТипы.Найти(ТипЗнч(Значение)) <> Неопределено)
		Тогда
			СтрокаТаблицы = ТаблицаРезультатЯчейки.Найти(Объект, "Объект");
			Если СтрокаТаблицы = Неопределено Тогда
				СтрокаТаблицы = ТаблицаРезультатЯчейки.Добавить();
				СтрокаТаблицы.Объект = Объект;
			КонецЕсли;
			
			Если ОжидаемыеТипы.Количество() = 0 Тогда
				СтрокаТаблицы.Значение = Строка(Значение);
			Иначе
				СтрокаТаблицы.ЗначениеХранилище = Новый ХранилищеЗначения(Значение);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ТаблицаРезультатЯчейки.ЗаполнитьЗначения(ЯчейкаКалендаря, "ЯчейкаКалендаря");
	
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ТаблицаРезультатЯчейки, ТаблицаРезультат);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Приватный метод выполнения обработчика ячейки произвольного алгоритма без контекста.
//
// Параметры:
//  Обработчик	 - Строка - алгоритм.
//  Параметры	 - Структура - произвольная структура.
//
Процедура ВыполнитьОбработчикЯчейкиПроизвольногоАлгоритма(Обработчик, Параметры, СообщениеОбОшибке = "")
	
	УстановитьБезопасныйРежим(Истина);
	Попытка
		Выполнить(Обработчик);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		
		Если СообщениеОбОшибке <> Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.КонкатенацияСтрок(СообщениеОбОшибке, ОписаниеОшибкиАлгоритма(ИнформацияОбОшибке, "Перед формированием"), Символы.ПС);
		КонецЕсли;
	КонецПопытки;
	
КонецПроцедуры

// Приватный метод, позволяющий вычислить признак объекта для журнала записи по произвольному коду
//
// Параметры:
//  ИсполняемыйКод	 - Строка - Код на языке 1С.
//  КлючевойОбъект	 - СправочникСсылка.Клиенты, ДокументСсылка.Заявка - Контекст расчета.
// 
// Возвращаемое значение:
//   Строка, Цвет, Картинка.
//
Функция ВычислитьПризнакПоПроизвольномуКоду(ИсполняемыйКод, Знач КлючевойОбъект, Параметры = Неопределено, СообщениеОбОшибке = "")
	
	Результат = Неопределено;
	Объект = КлючевойОбъект;
	
	Попытка	
		Выполнить(ИсполняемыйКод);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		
		Если СообщениеОбОшибке <> Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.КонкатенацияСтрок(СообщениеОбОшибке, ОписаниеОшибкиАлгоритма(ИнформацияОбОшибке, "Алгоритм расчета"), Символы.ПС);
		КонецЕсли;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

Функция ОписаниеОшибкиАлгоритма(ИнформацияОбОшибке, Заголовок)
	
	ТекстОшибки = Заголовок + ": " + ИнформацияОбОшибке.Описание;
	
	Если ПустаяСтрока(ИнформацияОбОшибке.ИмяМодуля) Тогда
		ТекстОшибки = ТекстОшибки + Символы.ПС + Символы.Таб + ИнформацияОбОшибке.ИсходнаяСтрока;
	КонецЕсли;
	
	Если ИнформацияОбОшибке.Причина <> Неопределено Тогда
		ТекстОшибки = ТекстОшибки + " " + ИнформацияОбОшибке.Причина.Описание;
	КонецЕсли;
	
	Возврат ТекстОшибки;
	
КонецФункции

#КонецОбласти
