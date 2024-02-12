#Область ПрограммныйИнтерфейс
// Процедура добавляет запись в регистр по переданным значениям структуры.
//
// Параметры:
//  СтруктураЗаписи - Произвольный.
//
Процедура ДобавитьЗапись(СтруктураЗаписи) Экспорт
	
	ОбменДаннымиСервер.ДобавитьЗаписьВРегистрСведений(СтруктураЗаписи, "СостоянияОбменовДанными");
	
КонецПроцедуры

// Возвращает структуру с данными последнего обмена для заданного узла информационной базы.
//
// Параметры:
//  УзелИнформационнойБазы - Произвольный.
//
// Возвращаемое значение:
//  СостоянияОбменовДанными - Произвольный - структура с данными последнего обмена для заданного узла информационной базы.
//
Функция СостоянияОбменовДаннымиДляУзлаИнформационнойБазы(Знач УзелИнформационнойБазы) Экспорт
	
	// Возвращаемое значение функции.
	СостоянияОбменовДанными = Новый Структура;
	СостоянияОбменовДанными.Вставить("УзелИнформационнойБазы");
	СостоянияОбменовДанными.Вставить("РезультатЗагрузкиДанных", "Неопределено");
	СостоянияОбменовДанными.Вставить("РезультатВыгрузкиДанных", "Неопределено");
	
	ТекстЗапроса = "
	|// {ЗАПРОС №0}
	|////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|	КОГДА СостоянияОбменовДанными.РезультатВыполненияОбмена = ЗНАЧЕНИЕ(Перечисление.РезультатыВыполненияОбмена.Выполнено)
	|	ТОГДА ""Успех""
	|	
	|	КОГДА СостоянияОбменовДанными.РезультатВыполненияОбмена = ЗНАЧЕНИЕ(Перечисление.РезультатыВыполненияОбмена.ВыполненоСПредупреждениями)
	|	ТОГДА ""ВыполненоСПредупреждениями""
	|	
	|	КОГДА СостоянияОбменовДанными.РезультатВыполненияОбмена = ЗНАЧЕНИЕ(Перечисление.РезультатыВыполненияОбмена.Предупреждение_СообщениеОбменаБылоРанееПринято)
	|	ТОГДА ""Предупреждение_СообщениеОбменаБылоРанееПринято""
	|	
	|	КОГДА СостоянияОбменовДанными.РезультатВыполненияОбмена = ЗНАЧЕНИЕ(Перечисление.РезультатыВыполненияОбмена.Ошибка_ТранспортСообщения)
	|	ТОГДА ""Ошибка_ТранспортСообщения""
	|	
	|	ИНАЧЕ ""Ошибка""
	|	
	|	КОНЕЦ КАК РезультатВыполненияОбмена
	|ИЗ
	|	РегистрСведений.СостоянияОбменовДанными КАК СостоянияОбменовДанными
	|ГДЕ
	|	  СостоянияОбменовДанными.УзелИнформационнойБазы = &УзелИнформационнойБазы
	|	И СостоянияОбменовДанными.ДействиеПриОбмене = ЗНАЧЕНИЕ(Перечисление.ДействияПриОбмене.ЗагрузкаДанных)
	|;
	|// {ЗАПРОС №1}
	|////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|	КОГДА СостоянияОбменовДанными.РезультатВыполненияОбмена = ЗНАЧЕНИЕ(Перечисление.РезультатыВыполненияОбмена.Выполнено)
	|	ТОГДА ""Успех""
	|	
	|	КОГДА СостоянияОбменовДанными.РезультатВыполненияОбмена = ЗНАЧЕНИЕ(Перечисление.РезультатыВыполненияОбмена.ВыполненоСПредупреждениями)
	|	ТОГДА ""ВыполненоСПредупреждениями""
	|	
	|	КОГДА СостоянияОбменовДанными.РезультатВыполненияОбмена = ЗНАЧЕНИЕ(Перечисление.РезультатыВыполненияОбмена.Предупреждение_СообщениеОбменаБылоРанееПринято)
	|	ТОГДА ""Предупреждение_СообщениеОбменаБылоРанееПринято""
	|	
	|	КОГДА СостоянияОбменовДанными.РезультатВыполненияОбмена = ЗНАЧЕНИЕ(Перечисление.РезультатыВыполненияОбмена.Ошибка_ТранспортСообщения)
	|	ТОГДА ""Ошибка_ТранспортСообщения""
	|	
	|	ИНАЧЕ ""Ошибка""
	|	КОНЕЦ КАК РезультатВыполненияОбмена
	|	
	|ИЗ
	|	РегистрСведений.СостоянияОбменовДанными КАК СостоянияОбменовДанными
	|ГДЕ
	|	  СостоянияОбменовДанными.УзелИнформационнойБазы = &УзелИнформационнойБазы
	|	И СостоянияОбменовДанными.ДействиеПриОбмене = ЗНАЧЕНИЕ(Перечисление.ДействияПриОбмене.ВыгрузкаДанных)
	|;
	|";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("УзелИнформационнойБазы", УзелИнформационнойБазы);
	
	МассивРезультатовЗапроса = Запрос.ВыполнитьПакет();
	
	ВыборкаРезультатовЗагрузкиДанных = МассивРезультатовЗапроса[0].Выбрать();
	ВыборкаРезультатовВыгрузкиДанных = МассивРезультатовЗапроса[1].Выбрать();
	
	Если ВыборкаРезультатовЗагрузкиДанных.Следующий() Тогда
		
		СостоянияОбменовДанными.РезультатЗагрузкиДанных = ВыборкаРезультатовЗагрузкиДанных.РезультатВыполненияОбмена;
		
	КонецЕсли;
	
	Если ВыборкаРезультатовВыгрузкиДанных.Следующий() Тогда
		
		СостоянияОбменовДанными.РезультатВыгрузкиДанных = ВыборкаРезультатовВыгрузкиДанных.РезультатВыполненияОбмена;
		
	КонецЕсли;
	
	СостоянияОбменовДанными.УзелИнформационнойБазы = УзелИнформационнойБазы;
	
	Возврат СостоянияОбменовДанными;
КонецФункции

// Возвращает структуру с данными последнего обмена для заданного узла информационной базы и действия при обмене.
//
// Параметры:
//  УзелИнформационнойБазы - Произвольный.
//  ДействиеПриОбмене - Произвольный.
//
// Возвращаемое значение:
//  СостоянияОбменовДанными - Произвольный - структура с данными последнего обмена для заданного узла информационной базы.
//
Функция СостоянияОбменовДанными(Знач УзелИнформационнойБазы, ДействиеПриОбмене) Экспорт
	
	// Возвращаемое значение функции.
	СостоянияОбменовДанными = Новый Структура;
	СостоянияОбменовДанными.Вставить("ДатаНачала",    Дата('00010101'));
	СостоянияОбменовДанными.Вставить("ДатаОкончания", Дата('00010101'));
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ДатаНачала,
	|	ДатаОкончания
	|ИЗ
	|	РегистрСведений.СостоянияОбменовДанными КАК СостоянияОбменовДанными
	|ГДЕ
	|	  СостоянияОбменовДанными.УзелИнформационнойБазы = &УзелИнформационнойБазы
	|	И СостоянияОбменовДанными.ДействиеПриОбмене      = &ДействиеПриОбмене
	|";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("УзелИнформационнойБазы", УзелИнформационнойБазы);
	Запрос.УстановитьПараметр("ДействиеПриОбмене",      ДействиеПриОбмене);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		ЗаполнитьЗначенияСвойств(СостоянияОбменовДанными, Выборка);
		
	КонецЕсли;
	
	Возврат СостоянияОбменовДанными;
	
КонецФункции

#КонецОбласти