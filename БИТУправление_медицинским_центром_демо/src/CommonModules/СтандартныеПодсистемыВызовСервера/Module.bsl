/////////////////////////////////////////////////////////////////////////////////
// Внутренние процедуры и функции подсистемы "Базовая функциональность",
// предназначенные для вызова из клиентского кода
//
#Область ПрограммныйИнтерфейс

// Записать настройку подтверждения завершения работы программы
// для текущего пользователя.
// 
// Параметры:
//   Значение - Булево   - значение настройки.
// 
Процедура СохранитьНастройкуПодтвержденияПриЗавершенииПрограммы(Значение) Экспорт
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ОбщиеНастройкиПользователя", "ЗапрашиватьПодтверждениеПриЗавершенииПрограммы", Значение);
	
КонецПроцедуры

// Возвращает настройку подтверждения завершения работы программы
// для текущего пользователя.
// 
Функция ЗагрузитьНастройкуПодтвержденияПриЗавершенииПрограммы() Экспорт
	
	Результат = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(,"ЗапрашиватьПодтверждениеПриЗакрытии");
	
	Возврат Результат;
	
КонецФункции

// Возвращает структуру параметров, необходимых для работы клиентского кода
// при запуске конфигурации, т.е. в обработчиках событий
// - ПередНачаломРаботыСистемы,
// - ПриНачалеРаботыСистемы
//
Функция ПараметрыРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	Если Параметры.ПервыйЗапросПараметров Тогда
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
	ПривилегированныйРежимУстановленПриЗапуске = ПривилегированныйРежим();
	
	УстановитьПривилегированныйРежим(Истина);
	Если ПараметрыСеанса.ПараметрыКлиентаНаСервере.Количество() = 0 Тогда
		ПараметрыКлиента = Новый Соответствие;
		ПараметрыКлиента.Вставить("ПараметрЗапуска", Параметры.ПараметрЗапуска);
		ПараметрыКлиента.Вставить("СтрокаСоединенияИнформационнойБазы", Параметры.СтрокаСоединенияИнформационнойБазы);
		ПараметрыКлиента.Вставить("ПривилегированныйРежимУстановленПриЗапуске", ПривилегированныйРежимУстановленПриЗапуске);
		ПараметрыКлиента.Вставить("ЭтоВебКлиент",    Параметры.ЭтоВебКлиент);
		ПараметрыКлиента.Вставить("ЭтоLinuxКлиент", Параметры.ЭтоLinuxКлиент);
		ПараметрыСеанса.ПараметрыКлиентаНаСервере = Новый ФиксированноеСоответствие(ПараметрыКлиента);
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	Если НЕ СтандартныеПодсистемыСервер.ДобавитьПараметрыРаботыКлиентаПриЗапуске(Параметры) Тогда
		Возврат ОбщегоНазначения.ФиксированныеДанные(Параметры);
	КонецЕсли;
	
	Возврат ОбщегоНазначения.ФиксированныеДанные(Параметры);
	
КонецФункции

// Возвращает имя объекта метаданных по типу.
//
// Параметры:
//  Источник - Тип - объект.
// 
// Возвращаемое значение:
//   Строка.
Функция ИмяОбъектаМетаданных(Тип) Экспорт
	ОбъектМетаданных = Метаданные.НайтиПоТипу(Тип);
	Если ОбъектМетаданных = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	Возврат ОбъектМетаданных.Имя;
КонецФункции

#КонецОбласти   

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Для справочника ИдентификаторыОбъектовМетаданных.

// См. Справочники.ИдентификаторыОбъектовМетаданных.ПредставлениеИдентификатора
Функция ПредставлениеИдентификатораОбъектаМетаданных(Ссылка) Экспорт
	
	Возврат Справочники.ИдентификаторыОбъектовМетаданных.ПредставлениеИдентификатора(Ссылка);
	
КонецФункции

#КонецОбласти
