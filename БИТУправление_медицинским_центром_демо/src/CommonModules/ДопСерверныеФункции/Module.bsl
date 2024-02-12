#Область ПрограммныйИнтерфейс

// Действия,выполняемые перед началом работы системы
Процедура ПередНачаломРаботыСистемы() Экспорт
	
	// Идентификаторы метаданных расширений
	УстановитьПривилегированныйРежим(Истина);
	
	ИменаПараметровСеанса = Новый Массив;
	ИменаПараметровСеанса.Добавить("УстановленныеРасширения");
	ИменаПараметровСеанса.Добавить("ПодключенныеРасширения");
	ИменаПараметровСеанса.Добавить("ВерсияРасширений");
	
	УстановленныеПараметры = Новый Массив;
	Справочники.ВерсииРасширений.УстановкаПараметровСеанса(ИменаПараметровСеанса,УстановленныеПараметры);	

	Если Не Справочники.ИдентификаторыОбъектовРасширений.ИдентификаторыОбъектовТекущейВерсииРасширенийЗаполнены() Тогда
		Если Не ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ() Тогда
			ВариантыОтчетов.ОперативноеОбновлениеОбщихДанных("ОбщиеДанныеРасширений", Неопределено);
			Справочники.ИдентификаторыОбъектовРасширений.ОбновитьДанныеСправочника();
		Иначе
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Идентификаторы объектов у текущей версии расширений не заполнены");
		КонецЕсли;
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
	// Идентификаторы метаданных расширений (конец)
	
КонецПроцедуры

// Получает реквизит/атрибут/свойство по имени на сервере.
// Используется для получения через точку значений ссылочных типов.
// Не применяет произвольный запрос к таблице как ОбщегоНазначения.ЗначениеРеквизитаОбъекта().
//
// Параметры:
//  Ссылка		 - ЛюбаяСсылка, Произвольный - Ссылка или значение, имеющее атрибуты (свойства).
//  ИмяРеквизита - Строка - Имя реквизита.
// 
// Возвращаемое значение:
//   Произвольный, Неопределено.
//
Функция ПолучитьРеквизит(Ссылка, ИмяРеквизита) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Попытка
		ЗаполненоЗначение = ЗначениеЗаполнено(Ссылка);
	Исключение
		ЗаполненоЗначение = Истина;
	КонецПопытки;
	
	Если ЗаполненоЗначение Тогда
		Возврат Ссылка[ИмяРеквизита];
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции	

// Возвращает Истина, если передана ссылка на документ.
//
// Параметры:
//  Переменная	 - Произвольный - проверяемое значение.
// 
// Возвращаемое значение:
//   Булево.
//
Функция ЭтоДокументСсылка(Переменная) Экспорт
	Возврат Документы.ТипВсеСсылки().СодержитТип(ТипЗнч(Переменная));
КонецФункции	

// Возвращает Истина, если передана ссылка на документ или имя метаданных документа.
//
// Параметры:
//  Переменная	 - Строка, ДокументСсылка - проверяемое значение.
// 
// Возвращаемое значение:
//   Булево.
//
Функция ЭтоДокумент(Переменная) Экспорт
	
	Если ТипЗнч(Переменная) = Тип("Строка") Тогда
		Если Метаданные.Документы.Найти(Переменная) <> Неопределено Тогда
			Возврат Истина;
		Иначе
			Возврат Ложь;
		КонецЕсли;	
	ИначеЕсли ЭтоДокументСсылка(Переменная) Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Возвращает Истина, если передана ссылка на справочник или имя метаданных справочника.
//
// Параметры:
//  Переменная	 - Произвольный - проверяемое значение.
// 
// Возвращаемое значение:
//   Булево.
//
Функция ЭтоСправочник(Имя) Экспорт
	Если Метаданные.Справочники.Найти(Имя) <> Неопределено Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;	
КонецФункции

// Пустая ссылка по имени документа.
//
// Параметры:
//  Имя	 - Строка - Имя документа.
// 
// Возвращаемое значение:
//   ДокументСсылка. 
//
Функция ПустаяСсылкаПоТипуДокумента(Имя) Экспорт
	Возврат Документы[Имя].ПустаяСсылка();
КонецФункции

// Пустая ссылка по имени справочника.
//
// Параметры:
//  Имя	 - Строка - Имя справочника.
// 
// Возвращаемое значение:
//   СправочникСсылка. 
//
Функция ПустаяСсылкаПоТипуСправочника(Имя) Экспорт
	Возврат Справочники[Имя].ПустаяСсылка();
КонецФункции

// Вызывает на сервере функцию РольДоступна() платформы.
//
// Параметры:
//  ИмяРоли	 - Строка - Имя роли.
// 
// Возвращаемое значение:
//   Булево.
//
Функция РольДоступнаСервер(ИмяРоли) Экспорт 
	Возврат РольДоступна(ИмяРоли);
КонецФункции	

// Номер релиза конфигурации.
// 
// Возвращаемое значение:
//   Строка.
//
Функция ПолучитьНомерВерсииКонфигурации() Экспорт 
	Возврат Константы.НомерВерсииКонфигурации.Получить();
КонецФункции

// Возвращает ссылку на общий модуль по имени.
//	Отличается от функции из БСП наличием параметра ИсключениеЕслиНеНайден для работы с отсутствующими модулями.
//
// Параметры:
//  Имя          - Строка - имя общего модуля, например:
//                 "ОбщегоНазначения",
//                 "ОбщегоНазначенияКлиент".
//	ИсключениеЕслиНеНайден - Булево - вызывать исключение, если модуля в конфигурации нет (добавлен БИТ для возможности не вызывать исключение).
//
// Возвращаемое значение:
//  ОбщийМодуль - общий модуль.
//
Функция ОбщийМодуль(Имя, ИсключениеЕслиНеНайден = Ложь) Экспорт
	
	Если ИсключениеЕслиНеНайден Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль(Имя);
	Иначе
		Попытка
			Модуль = ОбщегоНазначения.ОбщийМодуль(Имя);
		Исключение
			Модуль = Неопределено;
		КонецПопытки;
	КонецЕсли;
	
	Возврат Модуль;
	
КонецФункции

// Возвращает полное имя ссылочного типа, например, "Документ.Прием".
//	Для не ссылочных типов возвращает пустую строку.
//
// Параметры:
//  Ссылка	 - Произвольный	 - ссылка или иное значение.
// 
// Возвращаемое значение:
//  Строка - Полное имя метаданных ссылки.
//
Функция ИмяСсылочногоТипа(Ссылка) Экспорт
	
	Попытка 
		ОбъектМД = Метаданные.НайтиПоТипу(ТипЗнч(Ссылка));
			
		// Проверку выполняем только для ссылочных типов.
		Если ОбъектМД <> Неопределено
			И ОбщегоНазначения.ЭтоОбъектСсылочногоТипа(ОбъектМД) Тогда
			
			Возврат ОбъектМД.ПолноеИмя();
			
		КонецЕсли;
	Исключение КонецПопытки;
	
	Возврат "";
	
КонецФункции

Функция ПредставленияМассиваСсылок(МассивСсылок) Экспорт
	
	Результат = Новый СписокЗначений;
	
	Если МассивСсылок.Количество() <> 0 Тогда
		
		ИмяТипа = МассивСсылок[0].Метаданные().ПолноеИмя();
		
		ТекстЗапроса = СтрШаблон("ВЫБРАТЬ Ссылка, Представление ИЗ %1 ГДЕ Ссылка В (&Ссылки)", ИмяТипа);
		Запрос = Новый Запрос(ТекстЗапроса);
		Запрос.УстановитьПараметр("Ссылки", МассивСсылок);
		Выборка = Запрос.Выполнить().Выбрать();
		Отбор = Новый Структура("Ссылка");
		Для Каждого Ссылка Из МассивСсылок Цикл
			Отбор.Ссылка = Ссылка;
			Выборка.Сбросить();
			Если Выборка.НайтиСледующий(Отбор) Тогда
				Результат.Добавить(Ссылка, Выборка.Представление);
			Иначе
				Результат.Добавить(Ссылка, Строка(Ссылка)); // Битая ссылка.
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#Область СистемнаяИнформация

// Получает имя клиентского приложения из текущего сеанса пользователя.
// 
// Возвращаемое значение:
//  Строка - имя клиентского приложения.
//
Функция ИмяКлиентскогоПриложения() Экспорт
	
	Возврат ПолучитьТекущийСеансИнформационнойБазы().ИмяПриложения;
	
КонецФункции

// Возвращает Истина, если клиентское приложение - это Толстый клиент.
// 
// Возвращаемое значение:
//  Булево - Истина, если это толстый клиент.
//
Функция ЭтоТолстыйКлиент() Экспорт 
	
	Возврат ИмяКлиентскогоПриложения() = "1CV8";
	
КонецФункции

#КонецОбласти

#КонецОбласти
