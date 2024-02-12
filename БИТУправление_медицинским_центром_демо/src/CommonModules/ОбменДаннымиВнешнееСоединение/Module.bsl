////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обмен данными"
// Модуль предназначен для работы с внешним соединением.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Выполняет выгрузку данных для узла информационной базы во временный файл
// (Только для внутреннего использования).
//
// Параметры:
//  Отказ - Булево
//  ИмяПланаОбмена - Строка
//  КодУзлаИнформационнойБазы - Строка
//  ПолноеИмяФайлаСообщенияОбмена - Строка
//  СтрокаСообщенияОбОшибке - Строка.
//
Процедура ВыполнитьВыгрузкуДляУзлаИнформационнойБазы(Отказ,
												ИмяПланаОбмена,
												КодУзлаИнформационнойБазы,
												ПолноеИмяФайлаСообщенияОбмена,
												СтрокаСообщенияОбОшибке = ""
	) Экспорт
	
	ОбменДаннымиСервер.ПроверитьИспользованиеОбменаДанными();
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		
		Попытка
			ОбменДаннымиСервер.ВыполнитьВыгрузкуДляУзлаИнформационнойБазыЧерезФайл(ИмяПланаОбмена, КодУзлаИнформационнойБазы, ПолноеИмяФайлаСообщенияОбмена);
		Исключение
			Отказ = Истина;
			СтрокаСообщенияОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		КонецПопытки;
		
	Иначе
		
		Адрес = "";
		
		Попытка
			
			ОбменДаннымиСервер.ВыполнитьВыгрузкуДляУзлаИнформационнойБазыВоВременноеХранилище(ИмяПланаОбмена, КодУзлаИнформационнойБазы, Адрес);
			
			ПолучитьИзВременногоХранилища(Адрес).Записать(ПолноеИмяФайлаСообщенияОбмена);
			
			УдалитьИзВременногоХранилища(Адрес);
			
		Исключение
			Отказ = Истина;
			СтрокаСообщенияОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

// Помещает в журнал регистрации запись о начале обмена данными
// (Только для внутреннего использования).
//
// Параметры:
//  СтруктураНастроекОбмена - Структура.
//
Процедура ЗаписьЖурналаРегистрацииНачалаОбменаДанными(СтруктураНастроекОбмена) Экспорт
	
	ОбменДаннымиСервер.ЗаписьЖурналаРегистрацииНачалаОбменаДанными(СтруктураНастроекОбмена);
	
КонецПроцедуры

// Фиксирует завершение обмена данными через внешнее соединение
// (Только для внутреннего использования).
//
// Параметры:
//  СтруктураНастроекОбменаВнешнееСоединение - Структура.
//
Процедура ЗафиксироватьЗавершениеОбмена(СтруктураНастроекОбменаВнешнееСоединение) Экспорт
	
	СтруктураНастроекОбменаВнешнееСоединение.РезультатВыполненияОбмена = Перечисления.РезультатыВыполненияОбмена[СтруктураНастроекОбменаВнешнееСоединение.РезультатВыполненияОбменаСтрокой];
	
	ОбменДаннымиСервер.ЗафиксироватьЗавершениеОбменаЧерезВнешнееСоединение(СтруктураНастроекОбменаВнешнееСоединение);
	
КонецПроцедуры

// Получает зачитанные правила конвертации объектов по имени плана обмена
//  (Только для внутреннего использования).
//
// Параметры:
//  ИмяПланаОбмена	 - 	 - Строка
// 
// Возвращаемое значение:
//  Строка - Зачитанные правила конвертации объектов.
//
Функция ПолучитьПравилаКонвертацииОбъектов(ИмяПланаОбмена) Экспорт
	
	Возврат ОбменДаннымиСервер.ПолучитьПравилаКонвертацииОбъектовЧерезВнешнееСоединение(ИмяПланаОбмена);
	
КонецФункции

// Получает структуру настроек обмена
// (Только для внутреннего использования).
//
// Параметры:
//  Структура - Неопределено
//
// Возвращаемое значение:
//  Неопределено.
//
Функция СтруктураНастроекОбмена(Структура) Экспорт
	
	Возврат ОбменДаннымиСервер.СтруктураНастроекОбменаЧерезВнешнееСоединение(ОбменДаннымиСобытия.СкопироватьСтруктуру(Структура));
	
КонецФункции

// Проверяет существование плана обмена с заданным именем
// (Только для внутреннего использования).
//
// Параметры:
//  ИмяПланаОбмена - Строка
//
// Возвращаемое значение:
//  Булево.
//
Функция ПланОбменаСуществует(ИмяПланаОбмена) Экспорт
	
	Возврат Метаданные.ПланыОбмена.Найти(ИмяПланаОбмена) <> Неопределено;
	
КонецФункции

// Получает префикс информационной базы по умолчанию через внешнее соединение.
// Обертка одноименной функции в переопределяемом модуле.
// (Только для внутреннего использования).
//
// Возвращаемое значение:
//  Строка.
//
Функция ПрефиксИнформационнойБазыПоУмолчанию() Экспорт
	
	ПрефиксИнформационнойБазы = Неопределено;
	ПрефиксИнформационнойБазы = ОбменДаннымиПереопределяемый.ПрефиксИнформационнойБазыПоУмолчанию();
	
	Возврат ПрефиксИнформационнойБазы;
	
КонецФункции

// Возвращает признак доступности роли ПолныеПрава
// (Только для внутреннего использования).
//
// Возвращаемое значение:
//  Неопределено.
//
Функция РольДоступнаПолныеПрава() Экспорт
	
	Возврат РольДоступна(Метаданные.Роли.ПолныеПрава);
	
КонецФункции

// Возвращает таблицу списка объектов заданного объекта метаданных
// (Только для внутреннего использования).
// 
// Параметры:
//  ПолноеИмяТаблицы - Строка
//
// Возвращаемое значение:
//  Массив.
//
Функция ПолучитьОбъектыТаблицы(ПолноеИмяТаблицы) Экспорт
	
	Возврат ЗначениеВСтрокуВнутр(ОбщегоНазначения.ЗначениеИзСтрокиXML(ОбменДаннымиСервер.ПолучитьОбъектыТаблицы(ПолноеИмяТаблицы)));
	
КонецФункции

// Возвращает таблицу списка объектов заданного объекта метаданных
// (Только для внутреннего использования).
// 
// Параметры:
//  ПолноеИмяТаблицы - Строка
//
// Возвращаемое значение:
//  Массив.
//
Функция ПолучитьОбъектыТаблицы_2_0_1_6(ПолноеИмяТаблицы) Экспорт
	
	Возврат ОбменДаннымиСервер.ПолучитьОбъектыТаблицы(ПолноеИмяТаблицы);
	
КонецФункции

// Получает заданные свойства (Синоним, Иерархический) объекта метаданных
// (Только для внутреннего использования).
//
// Параметры:
//  ПолноеИмяТаблицы - Строка
//
// Возвращаемое значение:
//  Массив.
//
Функция СвойстваОбъектаМетаданных(ПолноеИмяТаблицы) Экспорт
	
	Возврат ОбменДаннымиСервер.СвойстваОбъектаМетаданных(ПолноеИмяТаблицы);
	
КонецФункции

// Возвращает название предопределенного узла плана обмена
// (Только для внутреннего использования).
//
// Параметры:
//  ИмяПланаОбмена - Строка
//
// Возвращаемое значение:
//  Строка.
//
Функция НаименованиеПредопределенногоУзлаПланаОбмена(ИмяПланаОбмена) Экспорт
	
	Возврат ОбменДаннымиСервер.НаименованиеПредопределенногоУзлаПланаОбмена(ИмяПланаОбмена);
	
КонецФункции

// Для внутреннего использования.
//
// Параметры:
//  Знач ИмяПланаОбмена - Строка
//
// Возвращаемое значение:
//  Строка.
//
Функция ПолучитьОбщиеДанныеУзлов(Знач ИмяПланаОбмена) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ЗначениеВСтрокуВнутр(ОбменДаннымиСервер.ДанныеДляТабличныхЧастейУзловЭтойИнформационнойБазы(ИмяПланаОбмена));
	
КонецФункции

// Для внутреннего использования.
//
// Параметры:
//  Знач ИмяПланаОбмена - Строка
//
// Возвращаемое значение:
//  Строка.
//
Функция ПолучитьОбщиеДанныеУзлов_2_0_1_6(Знач ИмяПланаОбмена) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ОбщегоНазначения.ЗначениеВСтрокуXML(ОбменДаннымиСервер.ДанныеДляТабличныхЧастейУзловЭтойИнформационнойБазы(ИмяПланаОбмена));
	
КонецФункции

// Для внутреннего использования.
//
// Параметры:
//  Знач ИмяПланаОбмена - Строка
//  Знач КодУзла - Неопределено
//  СообщениеОбОшибке - Неопределено
//
// Возвращаемое значение:
//  Структура.
//
Функция ПолучитьПараметрыИнформационнойБазы(Знач ИмяПланаОбмена, Знач КодУзла, СообщениеОбОшибке) Экспорт
	
	Возврат ОбменДаннымиСервер.ПолучитьПараметрыИнформационнойБазы(ИмяПланаОбмена, КодУзла, СообщениеОбОшибке);
	
КонецФункции

// Для внутреннего использования.
//
// Параметры:
//  Знач ИмяПланаОбмена - Строка
//  Знач КодУзла - Строка
//  СообщениеОбОшибке - Строка.
//
// Возвращаемое значение:
//  Структура.
//
Функция ПолучитьПараметрыИнформационнойБазы_2_0_1_6(Знач ИмяПланаОбмена, Знач КодУзла, СообщениеОбОшибке) Экспорт
	
	Возврат ОбменДаннымиСервер.ПолучитьПараметрыИнформационнойБазы_2_0_1_6(ИмяПланаОбмена, КодУзла, СообщениеОбОшибке);
	
КонецФункции

#КонецОбласти
