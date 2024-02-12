
#Область ПрограммныйИнтерфейс

Процедура АвторизоватьсяНаСайте(ТранспортныйМодуль, ОповещениеПриЗавершении) Экспорт
	
	УстановитьТекущийКлючСессии(ТранспортныйМодуль, Неопределено);
	Если ТранспортныйМодуль.ТипАутентификации = ПредопределенноеЗначение("Перечисление.ТипыАутентификацииМДЛП.ЭП") Тогда
		АвторизоватьсяЧерезПодпись(ТранспортныйМодуль, ОповещениеПриЗавершении);
	Иначе
		АвторизоватьсяСУказаниемПароля(ТранспортныйМодуль, ОповещениеПриЗавершении);
	КонецЕсли;
	
КонецПроцедуры

// Отправляет сообщение через транспортный модуль.
//
// Параметры:
//  ТранспортныйМодуль - Структура - транспортный модуль, через который нужно отправить сообщение.
//  Сообщение          - Строка - отправляемое сообщение.
//  ОповещениеПриЗавершении - ОписаниеОповещения - куда вернуть результат отправки.
//
Процедура ОтправитьСообщение(ТранспортныйМодуль, Сообщение, ОповещениеПриЗавершении) Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("Сообщение", Сообщение);
	Контекст.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	
	Оповещение = Новый ОписаниеОповещения("ОтправитьСообщение_ПослеПопыткиАвторизации", ЭтотОбъект, Контекст);
	ПолучитьТекущийКлючСессии(ТранспортныйМодуль, Оповещение);
	
КонецПроцедуры

// Получает входящие сообщения через транспортный модуль.
//
// Параметры:
//  ТранспортныйМодуль - Структура - транспортный модуль, через который нужно отправить сообщение.
//  ОповещениеПриЗавершении - ОписаниеОповещения - куда вернуть результат операции.
//  ПараметрыВыполненияОбмена - Структура - дополнительные параметры выполнения обмена
//                              (см. ИнтеграцияМДЛПКлиентСервер.ПараметрыВыполненияОбмена()).
//
Процедура ПолучитьВходящиеСообщения(ТранспортныйМодуль, ОповещениеПриЗавершении, ПараметрыВыполненияОбмена = Неопределено) Экспорт
	
	ВыполнитьАвторизованныйЗапрос(ТранспортныйМодуль, ОповещениеПриЗавершении, "ПолучитьВходящиеСообщения", ПараметрыВыполненияОбмена);
	
КонецПроцедуры

Процедура ПолучитьИнформациюОСубъектахОбращения(ТранспортныйМодуль, Отбор, ОповещениеПриЗавершении) Экспорт
	
	ВыполнитьАвторизованныйЗапрос(
		ТранспортныйМодуль,
		ОповещениеПриЗавершении,
		"ПолучитьИнформациюОСубъектахОбращения",
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Отбор));
	
КонецПроцедуры

Процедура ПолучитьИнформациюОбУчастнике(ТранспортныйМодуль, ОповещениеПриЗавершении) Экспорт
	
	ВыполнитьАвторизованныйЗапрос(ТранспортныйМодуль, ОповещениеПриЗавершении, "ПолучитьИнформациюОбУчастнике");
	
КонецПроцедуры

Процедура ПолучитьИнформациюОЗТК(ТранспортныйМодуль, Отбор, ОповещениеПриЗавершении) Экспорт
	
	ВыполнитьАвторизованныйЗапрос(
		ТранспортныйМодуль,
		ОповещениеПриЗавершении,
		"ПолучитьДанныеРеестраМестТаможенногоКонтроля",
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Отбор));
	
КонецПроцедуры

Процедура ЗакрытьСесию(ТранспортныйМодуль) Экспорт
	
	КлючСессии = ТекущийКлючСессии(ТранспортныйМодуль);
	Если КлючСессии <> Неопределено Тогда
		ТранспортныйМодуль.Вставить("КлючСессии", КлючСессии);
		ТранспортМДЛПАПИВызовСервера.ВыполнитьМетодАПИ(ТранспортныйМодуль, "ЗакрытьСессию");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолучитьТекущийКлючСессии(ТранспортныйМодуль, Оповещение) Экспорт
	
	ДанныеСертификата = СертификатСессии(ТранспортныйМодуль);
	Если ДанныеСертификата <> Неопределено Тогда
		ТранспортныйМодуль.Вставить("Сертификат", ДанныеСертификата);
	КонецЕсли;
	
	КлючСессии = ТекущийКлючСессии(ТранспортныйМодуль);
	Если КлючСессии = Неопределено Тогда
		АвторизоватьсяНаСайте(ТранспортныйМодуль, Оповещение);
	Иначе
		ТранспортныйМодуль.Вставить("КлючСессии", КлючСессии);
		Результат = Новый Структура("Статус", "Успешно");
		Результат.Вставить("КлючСессии", КлючСессии);
		Результат.Вставить("ТранспортныйМодуль", ТранспортныйМодуль);
		ВыполнитьОбработкуОповещения(Оповещение, Результат);
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьАвторизованныйЗапрос(ТранспортныйМодуль, ОповещениеПриЗавершении, ИмяМетода, Параметры = Неопределено) Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("ИмяМетода", ИмяМетода);
	Если Параметры <> Неопределено Тогда
		Контекст.Вставить("ПараметрыМетода", ?(ТипЗнч(Параметры) <> Тип("Массив"), ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Параметры), Параметры));
	КонецЕсли;
	Контекст.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	
	Оповещение = Новый ОписаниеОповещения("ВыполнитьМетодАПИ_ПослеПопыткиАвторизации", ЭтотОбъект, Контекст);
	ПолучитьТекущийКлючСессии(ТранспортныйМодуль, Оповещение);
	
КонецПроцедуры

#Область ВыполнениеВДлительнойОперации

// Возвращает параметры запуска методов АПИ в длительной операции.
// (см. ВыполнитьАвторизованныйЗапросВДлительнойОперации)
//
// Параметры:
//  Форма - форма-владелец длительной операции.
//
// Возвращаемое значение:
//  Параметры - Структура - параметры запуска методов АПИ в длительной операции:
//   * ПараметрыВыполненияВФоне - см. ТранспортМДЛПАПИВызовСервера.ПараметрыЗапускаМетодовАПИВДлительнойОперации.
//   * ПараметрыОжидания - см. ДлительныеОперацииКлиент.ПараметрыОжидания.
//   * ОповещениеПередОжиданиемДлительнойОперации - ОписаниеОповещения - оповещение, которое необходимо вызвать после запуска длительной операции,
//                                                  в результат которого будет передан результат выполнения функции ДлительныеОперации.ВыполнитьВФоне,
//                                                  из которого, например, можно получить идентификатор фонового задания.
//
Функция ПараметрыЗапускаМетодовАПИВДлительнойОперации(Форма) Экспорт
	
	Параметры = ТранспортМДЛПАПИВызовСервера.ПараметрыЗапускаМетодовАПИВДлительнойОперации(Форма.УникальныйИдентификатор);
	
	Параметры.Вставить("ПараметрыОжидания", ДлительныеОперацииКлиент.ПараметрыОжидания(Форма));
	Параметры.ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	Параметры.Вставить("ОповещениеПередОжиданиемДлительнойОперации", Неопределено);
	
	Возврат Параметры;
	
КонецФункции

Процедура ВыполнитьАвторизованныйЗапросВДлительнойОперации(ТранспортныйМодуль, ОповещениеПриЗавершении, ИмяМетода, ПараметрыМетода = Неопределено, ПараметрыЗапуска) Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("ИмяМетода", ИмяМетода);
	Если ПараметрыМетода <> Неопределено Тогда
		Контекст.Вставить("ПараметрыМетода", ?(ТипЗнч(ПараметрыМетода) <> Тип("Массив"), ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ПараметрыМетода), ПараметрыМетода));
	КонецЕсли;
	Контекст.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	Контекст.Вставить("ПараметрыЗапуска", ПараметрыЗапуска);
	
	Оповещение = Новый ОписаниеОповещения("ВыполнитьМетодАПИ_ПослеПопыткиАвторизации_ДлительнаяОперация", ЭтотОбъект, Контекст);
	ПолучитьТекущийКлючСессии(ТранспортныйМодуль, Оповещение);
	
КонецПроцедуры

#КонецОбласти

#Область ПолучениеИнформацииОбУпаковках

Процедура НачатьПолучениеИнформацииОбУпаковках(ПараметрыПодключения, ОповещениеПриЗавершении, ПараметрыМетода, ПараметрыЗапуска) Экспорт
	
	Если ПараметрыМетода.ПараметрыПолученияИнформацииОПотребительскихУпаковках.НомераУпаковок.Количество() = 0
	   И ПараметрыМетода.ПараметрыПолученияИнформацииОТранспортныхУпаковках.НомераУпаковок.Количество() = 0 Тогда
		Результат = ТранспортМДЛПКлиентСервер.РезультатВыполненияОперации();
		ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, Результат);
		Возврат;
	КонецЕсли;
	
	Контекст = Новый Структура;
	Контекст.Вставить("ПараметрыМетода"        , ПараметрыМетода);
	Контекст.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	
	Оповещение = Новый ОписаниеОповещения("ОбработатьРезультатПолученияИнформацииОбУпаковках", ЭтотОбъект, Контекст);
	ВыполнитьАвторизованныйЗапросВДлительнойОперации(
		ПараметрыПодключения,
		Оповещение,
		"ПолучитьИнформациюОПотребительскихИТранспортныхУпаковках",
		ПараметрыМетода,
		ПараметрыЗапуска);
	
КонецПроцедуры

Процедура ОбработатьРезультатПолученияИнформацииОбУпаковках(Результат, Контекст) Экспорт
	
	Если Результат.Статус <> "Успешно" Тогда
		
		// Удаляем задачи из списка ожидания асинхронных задач,
		// т.к. длительная операция могла быть прервана до того, как почистит за собой асинхронные задачи.
		РабочиеПараметрыМетода = ТранспортМДЛПАПИКлиентСервер.ПараметрыПолученияИнформацииОТранспортныхУпаковках();
		ЗаполнитьЗначенияСвойств(РабочиеПараметрыМетода, Контекст.ПараметрыМетода.ПараметрыПолученияИнформацииОТранспортныхУпаковках);
		Если РабочиеПараметрыМетода.ТипЗапросаМетодовАПИ = ПредопределенноеЗначение("Перечисление.ТипыЗапросовМетодовАПИМДЛП.Асинхронный") Тогда
			ТранспортМДЛПАПИВызовСервера.УдалитьЗадачиИзСпискаОжиданияАсинхронныхЗадач(Новый Структура("ВладелецЗадачи", РабочиеПараметрыМетода.ВладелецАсинхроннойЗадачи));
		КонецЕсли;
		
		РабочиеПараметрыМетода = ТранспортМДЛПАПИКлиентСервер.ПараметрыПолученияИнформацииОПотребительскихУпаковках();
		ЗаполнитьЗначенияСвойств(РабочиеПараметрыМетода, Контекст.ПараметрыМетода.ПараметрыПолученияИнформацииОПотребительскихУпаковках);
		Если РабочиеПараметрыМетода.ТипЗапросаМетодовАПИ = ПредопределенноеЗначение("Перечисление.ТипыЗапросовМетодовАПИМДЛП.Асинхронный") Тогда
			ТранспортМДЛПАПИВызовСервера.УдалитьЗадачиИзСпискаОжиданияАсинхронныхЗадач(Новый Структура("ВладелецЗадачи", РабочиеПараметрыМетода.ВладелецАсинхроннойЗадачи));
		КонецЕсли;
		
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Контекст.ОповещениеПриЗавершении, Результат);
	
КонецПроцедуры


Процедура НачатьПолучениеИнформацииОКИЗ(ПараметрыПодключения, ОповещениеПриЗавершении, ПараметрыМетода, ПараметрыЗапуска) Экспорт
	
	Если ПараметрыМетода.НомераУпаковок.Количество() = 0 Тогда
		Результат = ТранспортМДЛПКлиентСервер.РезультатВыполненияОперации();
		ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, Результат);
		Возврат;
	КонецЕсли;
	
	Контекст = Новый Структура;
	Контекст.Вставить("ПараметрыМетода"        , ПараметрыМетода);
	Контекст.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	
	Оповещение = Новый ОписаниеОповещения("ОбработатьРезультатПолученияИнформацииОКИЗ", ЭтотОбъект, Контекст);
	ВыполнитьАвторизованныйЗапросВДлительнойОперации(
		ПараметрыПодключения,
		Оповещение,
		"ПолучитьИнформациюОПотребительскихУпаковках",
		ПараметрыМетода,
		ПараметрыЗапуска);
	
КонецПроцедуры

Процедура ОбработатьРезультатПолученияИнформацииОКИЗ(Результат, Контекст) Экспорт
	
	Если Результат.Статус <> "Успешно" Тогда
		
		// Удаляем задачи из списка ожидания асинхронных задач,
		// т.к. длительная операция могла быть прервана до того, как почистит за собой асинхронные задачи.
		РабочиеПараметрыМетода = ТранспортМДЛПАПИКлиентСервер.ПараметрыПолученияИнформацииОПотребительскихУпаковках();
		ЗаполнитьЗначенияСвойств(РабочиеПараметрыМетода, Контекст.ПараметрыМетода);
		Если РабочиеПараметрыМетода.ТипЗапросаМетодовАПИ = ПредопределенноеЗначение("Перечисление.ТипыЗапросовМетодовАПИМДЛП.Асинхронный") Тогда
			ТранспортМДЛПАПИВызовСервера.УдалитьЗадачиИзСпискаОжиданияАсинхронныхЗадач(Новый Структура("ВладелецЗадачи", РабочиеПараметрыМетода.ВладелецАсинхроннойЗадачи));
		КонецЕсли;
		
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Контекст.ОповещениеПриЗавершении, Результат);
	
КонецПроцедуры


Процедура НачатьПолучениеСпискаПотребительскихУпаковокПоОтбору(ПараметрыПодключения, ОповещениеПриЗавершении, ПараметрыМетода, ПараметрыЗапуска) Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("ПараметрыМетода"        , ПараметрыМетода);
	Контекст.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	
	Оповещение = Новый ОписаниеОповещения("ОбработатьРезультатПолученияСпискаПотребительскихУпаковокПоОтбору", ЭтотОбъект, Контекст);
	ВыполнитьАвторизованныйЗапросВДлительнойОперации(
		ПараметрыПодключения,
		Оповещение,
		"ПолучитьСписокПотребительскихУпаковокПоОтбору",
		ПараметрыМетода,
		ПараметрыЗапуска);
	
КонецПроцедуры

Процедура ОбработатьРезультатПолученияСпискаПотребительскихУпаковокПоОтбору(Результат, Контекст) Экспорт
	
	ВыполнитьОбработкуОповещения(Контекст.ОповещениеПриЗавершении, Результат);
	
КонецПроцедуры


Процедура НачатьПолучениеИнформацииОТранспортныхУпаковках(ПараметрыПодключения, ОповещениеПриЗавершении, ПараметрыМетода, ПараметрыЗапуска) Экспорт
	
	Если ПараметрыМетода.НомераУпаковок.Количество() = 0 Тогда
		Результат = ТранспортМДЛПКлиентСервер.РезультатВыполненияОперации();
		ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, Результат);
		Возврат;
	КонецЕсли;
	
	Контекст = Новый Структура;
	Контекст.Вставить("ПараметрыМетода"        , ПараметрыМетода);
	Контекст.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	
	Оповещение = Новый ОписаниеОповещения("ОбработатьРезультатПолученияИнформацииОТранспортныхУпаковках", ЭтотОбъект, Контекст);
	ВыполнитьАвторизованныйЗапросВДлительнойОперации(
		ПараметрыПодключения,
		Оповещение,
		"ПолучитьИнформациюОТранспортныхУпаковках",
		ПараметрыМетода,
		ПараметрыЗапуска);
	
КонецПроцедуры

Процедура ОбработатьРезультатПолученияИнформацииОТранспортныхУпаковках(Результат, Контекст) Экспорт
	
	Если Результат.Статус <> "Успешно" Тогда
		
		// Удаляем задачи из списка ожидания асинхронных задач,
		// т.к. длительная операция могла быть прервана до того, как почистит за собой асинхронные задачи.
		РабочиеПараметрыМетода = ТранспортМДЛПАПИКлиентСервер.ПараметрыПолученияИнформацииОТранспортныхУпаковках();
		ЗаполнитьЗначенияСвойств(РабочиеПараметрыМетода, Контекст.ПараметрыМетода);
		Если РабочиеПараметрыМетода.ТипЗапросаМетодовАПИ = ПредопределенноеЗначение("Перечисление.ТипыЗапросовМетодовАПИМДЛП.Асинхронный") Тогда
			ТранспортМДЛПАПИВызовСервера.УдалитьЗадачиИзСпискаОжиданияАсинхронныхЗадач(Новый Структура("ВладелецЗадачи", РабочиеПараметрыМетода.ВладелецАсинхроннойЗадачи));
		КонецЕсли;
		
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Контекст.ОповещениеПриЗавершении, Результат);
	
КонецПроцедуры

#КонецОбласти

#Область ПолучениеОстатковИОборотовЛП

Процедура НачатьПолучениеОстатковЛекарственногоПрепарата(ПараметрыПодключения, ОповещениеПриЗавершении, ПараметрыМетода, ПараметрыЗапуска) Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("ПараметрыМетода"        , ПараметрыМетода);
	Контекст.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	
	Оповещение = Новый ОписаниеОповещения("ОбработатьРезультатПолученияОстатковЛекарственногоПрепарата", ЭтотОбъект, Контекст);
	ВыполнитьАвторизованныйЗапросВДлительнойОперации(
		ПараметрыПодключения,
		Оповещение,
		"ПолучитьОстаткиЛекарственногоПрепарата",
		ПараметрыМетода,
		ПараметрыЗапуска);
	
КонецПроцедуры

Процедура ОбработатьРезультатПолученияОстатковЛекарственногоПрепарата(Результат, Контекст) Экспорт
	
	Если Результат.Статус <> "Успешно" Тогда
		
		// Удаляем задачи из списка ожидания асинхронных задач,
		// т.к. длительная операция могла быть прервана до того, как почистит за собой асинхронные задачи.
		РабочиеПараметрыМетода = ТранспортМДЛПАПИКлиентСервер.ПараметрыПолученияОстатковЛекарственногоПрепарата(Неопределено);
		ЗаполнитьЗначенияСвойств(РабочиеПараметрыМетода, Контекст.ПараметрыМетода);
		ТранспортМДЛПАПИВызовСервера.УдалитьЗадачиИзСпискаОжиданияАсинхронныхЗадач(Новый Структура("ВладелецЗадачи", РабочиеПараметрыМетода.ВладелецАсинхроннойЗадачи));
		
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Контекст.ОповещениеПриЗавершении, Результат);
	
КонецПроцедуры

Процедура НачатьПолучениеОстатковЛекарственногоПрепаратаНаМД(ПараметрыПодключения, ОповещениеПриЗавершении, ПараметрыМетода, ПараметрыЗапуска) Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("ПараметрыМетода"        , ПараметрыМетода);
	Контекст.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	
	Оповещение = Новый ОписаниеОповещения("ОбработатьРезультатПолученияОстатковЛекарственногоПрепаратаНаМД", ЭтотОбъект, Контекст);
	ВыполнитьАвторизованныйЗапросВДлительнойОперации(
		ПараметрыПодключения,
		Оповещение,
		"ПолучитьОстаткиЛекарственногоПрепаратаНаМД",
		ПараметрыМетода,
		ПараметрыЗапуска);
	
КонецПроцедуры

Процедура ОбработатьРезультатПолученияОстатковЛекарственногоПрепаратаНаМД(Результат, Контекст) Экспорт
	
	Если Результат.Статус <> "Успешно" Тогда
		
		// Удаляем задачи из списка ожидания асинхронных задач,
		// т.к. длительная операция могла быть прервана до того, как почистит за собой асинхронные задачи.
		РабочиеПараметрыМетода = ТранспортМДЛПАПИКлиентСервер.ПараметрыПолученияОстатковЛекарственногоПрепаратаНаМД();
		ЗаполнитьЗначенияСвойств(РабочиеПараметрыМетода, Контекст.ПараметрыМетода);
		ТранспортМДЛПАПИВызовСервера.УдалитьЗадачиИзСпискаОжиданияАсинхронныхЗадач(Новый Структура("ВладелецЗадачи", РабочиеПараметрыМетода.ВладелецАсинхроннойЗадачи));
		
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Контекст.ОповещениеПриЗавершении, Результат);
	
КонецПроцедуры

Процедура НачатьПолучениеВыбытияЛекарственногоПрепарата(ПараметрыПодключения, ОповещениеПриЗавершении, ПараметрыМетода, ПараметрыЗапуска) Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("ПараметрыМетода"        , ПараметрыМетода);
	Контекст.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	
	Оповещение = Новый ОписаниеОповещения("ОбработатьРезультатПолученияВыбытияЛекарственногоПрепарата", ЭтотОбъект, Контекст);
	ВыполнитьАвторизованныйЗапросВДлительнойОперации(
		ПараметрыПодключения,
		Оповещение,
		"ПолучитьВыбытияЛекарственногоПрепарата",
		ПараметрыМетода,
		ПараметрыЗапуска);
	
КонецПроцедуры

Процедура ОбработатьРезультатПолученияВыбытияЛекарственногоПрепарата(Результат, Контекст) Экспорт
	
	Если Результат.Статус <> "Успешно" Тогда
		
		// Удаляем задачи из списка ожидания асинхронных задач,
		// т.к. длительная операция могла быть прервана до того, как почистит за собой асинхронные задачи.
		РабочиеПараметрыМетода = ТранспортМДЛПАПИКлиентСервер.ПараметрыПолученияВыбытияЛекарственногоПрепарата(Неопределено);
		ЗаполнитьЗначенияСвойств(РабочиеПараметрыМетода, Контекст.ПараметрыМетода);
		ТранспортМДЛПАПИВызовСервера.УдалитьЗадачиИзСпискаОжиданияАсинхронныхЗадач(Новый Структура("ВладелецЗадачи", РабочиеПараметрыМетода.ВладелецАсинхроннойЗадачи));
		
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Контекст.ОповещениеПриЗавершении, Результат);
	
КонецПроцедуры

#КонецОбласти

#Область ЗагрузкаОстатковИОборотов

Процедура НачатьЗагрузкуОстатковПотребительскихУпаковок(ПараметрыПодключения, ОповещениеПриЗавершении, ПараметрыМетода, ПараметрыЗапуска) Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("ПараметрыМетода"        , ПараметрыМетода);
	Контекст.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	
	Оповещение = Новый ОписаниеОповещения("ОбработатьРезультатЗагрузкиОстатковПотребительскихУпаковок", ЭтотОбъект, Контекст);
	ВыполнитьАвторизованныйЗапросВДлительнойОперации(
		ПараметрыПодключения,
		Оповещение,
		"ЗагрузитьОстаткиПотребительскихУпаковок",
		ПараметрыМетода,
		ПараметрыЗапуска);
	
КонецПроцедуры

Процедура ОбработатьРезультатЗагрузкиОстатковПотребительскихУпаковок(Результат, Контекст) Экспорт
	
	Если Результат.Статус <> "Успешно" Тогда
		
		// Удаляем задачи из списка ожидания асинхронных задач,
		// т.к. длительная операция могла быть прервана до того, как почистит за собой асинхронные задачи.
		РабочиеПараметрыМетода = ТранспортМДЛПАПИКлиентСервер.ПараметрыЗагрузкиОстатковПотребительскихУпаковок(Неопределено);
		ЗаполнитьЗначенияСвойств(РабочиеПараметрыМетода, Контекст.ПараметрыМетода);
		ТранспортМДЛПАПИВызовСервера.УдалитьЗадачиИзСпискаОжиданияАсинхронныхЗадач(Новый Структура("ВладелецЗадачи", РабочиеПараметрыМетода.ВладелецАсинхроннойЗадачи));
		
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Контекст.ОповещениеПриЗавершении, Результат);
	
КонецПроцедуры

Процедура НачатьЗагрузкуОстатковГрупповыхУпаковок(ПараметрыПодключения, ОповещениеПриЗавершении, ПараметрыМетода, ПараметрыЗапуска) Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("ПараметрыМетода"        , ПараметрыМетода);
	Контекст.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	
	Оповещение = Новый ОписаниеОповещения("ОбработатьРезультатЗагрузкиОстатковГрупповыхУпаковок", ЭтотОбъект, Контекст);
	ВыполнитьАвторизованныйЗапросВДлительнойОперации(
		ПараметрыПодключения,
		Оповещение,
		"ЗагрузитьОстаткиГрупповыхУпаковок",
		ПараметрыМетода,
		ПараметрыЗапуска);
	
КонецПроцедуры

Процедура ОбработатьРезультатЗагрузкиОстатковГрупповыхУпаковок(Результат, Контекст) Экспорт
	
	ВыполнитьОбработкуОповещения(Контекст.ОповещениеПриЗавершении, Результат);
	
КонецПроцедуры

#КонецОбласти

#Область УстаревшиеПроцедурыИФункции

Процедура ПолучитьДетальнуюИнформациюОКИЗ(ТранспортныйМодуль, КИЗ, ОповещениеПриЗавершении) Экспорт
	
	ВыполнитьАвторизованныйЗапрос(
		ТранспортныйМодуль,
		ОповещениеПриЗавершении,
		"ПолучитьДетальнуюИнформациюОКИЗ",
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(КИЗ));
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОтправитьСообщение_ПослеПопыткиАвторизации(РезультатАвторизации, Контекст) Экспорт
	
	Если РезультатАвторизации.Статус = "Ошибка" Тогда
		ОповеститьОРезультатеОтправкиСообщения(РезультатАвторизации, Контекст);
		Возврат;
	КонецЕсли;
	
	ТранспортныйМодуль = РезультатАвторизации.ТранспортныйМодуль;
	Контекст.Вставить("ТранспортныйМодуль", ТранспортныйМодуль);
	Если ТранспортныйМодуль.ТипАутентификации = ПредопределенноеЗначение("Перечисление.ТипыАутентификацииМДЛП.ЭП")
	   И Не ЗначениеЗаполнено(Контекст.Сообщение.Подпись) Тогда
		ОписаниеДанных = Новый Структура;
		ОписаниеДанных.Вставить("Операция", НСтр("ru = 'Подписание сообщения для отправки в ""ИС ""Маркировка.""МДЛП""'"));
		ОписаниеДанных.Вставить("ЗаголовокДанных", Строка(Контекст.Сообщение.Операция));
		Если ТранспортныйМодуль.Свойство("Сертификат") Тогда
			ОписаниеДанных.Вставить("ОтборСертификатов", ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТранспортныйМодуль.Сертификат.Ссылка));
		ИначеЕсли ТранспортныйМодуль.Свойство("Организация") И ЗначениеЗаполнено(ТранспортныйМодуль.Организация) И ТипЗнч(ТранспортныйМодуль.Организация) <> Тип("Строка") Тогда
			ОписаниеДанных.Вставить("ОтборСертификатов", Новый Структура("Организация", ТранспортныйМодуль.Организация));
		КонецЕсли;
		ОписаниеДанных.Вставить("ПоказатьКомментарий", Ложь);
		ОписаниеДанных.Вставить("БезПодтверждения", Истина);
		
		ОписаниеДанных.Вставить("Данные", ПолучитьДвоичныеДанныеИзСтроки(Контекст.Сообщение.ТекстСообщения));
		ОписаниеДанных.Вставить("Представление", Контекст.Сообщение.Документ);
		
		Оповестить = Новый ОписаниеОповещения("ОтправитьСообщение_ПослеПодписания", ЭтотОбъект, Контекст);
		ЭлектроннаяПодписьКлиент.Подписать(ОписаниеДанных,, Оповестить);
	Иначе
		ОтправитьПодписанноеСообщение(Контекст);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОтправитьСообщение_ПослеПодписания(РезультатПодписания, Контекст) Экспорт
	
	Если Не РезультатПодписания.Успех Тогда
		Результат = Новый Структура;
		Результат.Вставить("Статус", "Ошибка");
		Результат.Вставить("ОписаниеОшибки", НСтр("ru = 'Ошибка подписания сообщения.'"));
		ОповеститьОРезультатеОтправкиСообщения(Результат, Контекст);
	Иначе
		Контекст.Сообщение.Вставить("Подпись", Base64Строка(ПолучитьСвойстваПодписи(РезультатПодписания).Подпись));
		ОтправитьПодписанноеСообщение(Контекст);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОтправитьПодписанноеСообщение(Контекст)
	
	ТранспортныйМодуль = Контекст.ТранспортныйМодуль;
	
	ПолучитьТекущееОграничениеРазмераНебольшихДокументов(ТранспортныйМодуль);
	
	Результат = ТранспортМДЛПАПИВызовСервера.ВыполнитьМетодАПИ(
		ТранспортныйМодуль, "ОтправитьСообщение", ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Контекст.Сообщение));
	Если Результат.Статус = "Ошибка" Тогда
		Если Результат.ТребуетсяАвторизация Тогда
			Оповещение = Новый ОписаниеОповещения("ОтправитьСообщение_ПослеПопыткиАвторизации", ЭтотОбъект, Контекст);
			АвторизоватьсяНаСайте(ТранспортныйМодуль, Оповещение);
			Возврат;
		КонецЕсли;
	Иначе
		Результат.Вставить("Подпись", Контекст.Сообщение.Подпись);
	КонецЕсли;
	
	ОповеститьОРезультатеОтправкиСообщения(Результат, Контекст);
	
КонецПроцедуры

Процедура ОповеститьОРезультатеОтправкиСообщения(Результат, Контекст)
	
	ВыполнитьОбработкуОповещения(Контекст.ОповещениеПриЗавершении, Результат);
	
КонецПроцедуры


Процедура ВыполнитьМетодАПИ_ПослеПопыткиАвторизации(РезультатАвторизации, Контекст) Экспорт
	
	Если РезультатАвторизации.Статус = "Ошибка" Тогда
		ВыполнитьОбработкуОповещения(Контекст.ОповещениеПриЗавершении, РезультатАвторизации);
		Возврат;
	КонецЕсли;
	
	ТранспортныйМодуль = РезультатАвторизации.ТранспортныйМодуль;
	ПараметрыМетода = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Контекст, "ПараметрыМетода");
	Результат = ТранспортМДЛПАПИВызовСервера.ВыполнитьМетодАПИ(ТранспортныйМодуль, Контекст.ИмяМетода, ПараметрыМетода);
	Если Результат.Статус = "Ошибка" Тогда
		Если Результат.ТребуетсяАвторизация Тогда
			НовыеПараметрыМетода = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Результат, "ПараметрыМетода");
			Если НовыеПараметрыМетода <> Неопределено Тогда
				Контекст.Вставить("ПараметрыМетода", НовыеПараметрыМетода);
			КонецЕсли;
			Оповещение = Новый ОписаниеОповещения("ВыполнитьМетодАПИ_ПослеПопыткиАвторизации", ЭтотОбъект, Контекст);
			АвторизоватьсяНаСайте(ТранспортныйМодуль, Оповещение);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Контекст.ОповещениеПриЗавершении, Результат);
	
КонецПроцедуры


Процедура АвторизоватьсяЧерезПодпись(ТранспортныйМодуль, ОповещениеПриЗавершении)
	
	ОписаниеДанных = Новый Структура;
	ОписаниеДанных.Вставить("Операция", НСтр("ru = 'Авторизация в ""ИС ""Маркировка.""МДЛП""'"));
	ОписаниеДанных.Вставить("ЗаголовокДанных", "");
	Если ТранспортныйМодуль.Свойство("Сертификат") Тогда
		ОписаниеДанных.Вставить("ОтборСертификатов", ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТранспортныйМодуль.Сертификат.Ссылка));
	КонецЕсли;
	ОписаниеДанных.Вставить("ПоказатьКомментарий", Ложь);
	ОписаниеДанных.Вставить("БезПодтверждения", Истина);
	
	ОписаниеДанных.Вставить("Данные", Новый ОписаниеОповещения("АвторизоватьсяЧерезПодпись_ПолучитьКодАутентификации", ЭтотОбъект, ТранспортныйМодуль));
	Если ТранспортныйМодуль.Свойство("Организация") И ЗначениеЗаполнено(ТранспортныйМодуль.Организация) Тогда
		Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Организация: %1'"), ТранспортныйМодуль.Организация);
	Иначе
		Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Идентификатор организации: %1'"), ТранспортныйМодуль.ИдентификаторОрганизации);
	КонецЕсли;
	ОписаниеДанных.Вставить("Представление", Представление);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ТранспортныйМодуль", ТранспортныйМодуль);
	ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	Оповестить = Новый ОписаниеОповещения("АвторизоватьсяЧерезПодпись_ПослеПодписания", ЭтотОбъект, ДополнительныеПараметры);
	ЭлектроннаяПодписьКлиент.Подписать(ОписаниеДанных,, Оповестить);
	
КонецПроцедуры

Процедура АвторизоватьсяЧерезПодпись_ПолучитьКодАутентификации(Параметры, ТранспортныйМодуль) Экспорт
	
	РезультатОперации = Новый Структура;
	РезультатОперации.Вставить("Данные");
	
	ТранспортныйМодуль.Вставить("Сертификат", Параметры.ОписаниеДанных.ВыбранныйСертификат);
	Результат = ТранспортМДЛПАПИВызовСервера.ВыполнитьМетодАПИ(ТранспортныйМодуль, "ПолучитьКодАутентификации");
	ТранспортныйМодуль.Удалить("Сертификат");
	Если Результат.Статус = "Ошибка" Тогда
		РезультатОперации.Вставить("ОписаниеОшибки", Результат.ОписаниеОшибки);
	Иначе
		РезультатОперации.Вставить("Данные", ПолучитьДвоичныеДанныеИзСтроки(Результат.КодАутентификации));
		Параметры.ОписаниеДанных.Вставить("КодАутентификации", Результат.КодАутентификации);
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Параметры.Оповещение, РезультатОперации);
	
КонецПроцедуры

Процедура АвторизоватьсяЧерезПодпись_ПослеПодписания(РезультатПодписания, Контекст) Экспорт
	
	Если Не РезультатПодписания.Успех Тогда
		Результат = Новый Структура;
		Результат.Вставить("Статус", "Ошибка");
		Результат.Вставить("ОписаниеОшибки", НСтр("ru = 'Ошибка авторизации.'"));
	Иначе
		Подпись = ПолучитьСвойстваПодписи(РезультатПодписания).Подпись;
		ПараметрыМетода = Новый Массив;
		ПараметрыМетода.Добавить(РезультатПодписания.КодАутентификации);
		ПараметрыМетода.Добавить(Подпись);
		Результат = ТранспортМДЛПАПИВызовСервера.ВыполнитьМетодАПИ(Контекст.ТранспортныйМодуль, "ПолучитьКлючСессии", ПараметрыМетода);
	КонецЕсли;
	
	ТранспортныйМодуль = Контекст.ТранспортныйМодуль;
	Если Результат.Статус <> "Ошибка" Тогда
		ТранспортныйМодуль.Вставить("Сертификат", РезультатПодписания.ВыбранныйСертификат);
		ТранспортныйМодуль.Вставить("КлючСессии", Результат.КлючСессии);
		УстановитьТекущийКлючСессии(ТранспортныйМодуль, Результат.КлючСессии, Результат.ВремяЖизни);
		УстановитьСертификатСессии(ТранспортныйМодуль, РезультатПодписания.ВыбранныйСертификат);
		Результат.Вставить("ТранспортныйМодуль", ТранспортныйМодуль);
	Иначе
		УстановитьСертификатСессии(ТранспортныйМодуль, Неопределено);
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Контекст.ОповещениеПриЗавершении, Результат);
	
КонецПроцедуры

Процедура АвторизоватьсяСУказаниемПароля(ТранспортныйМодуль, ОповещениеПриЗавершении)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИдентификаторОрганизации", ТранспортныйМодуль.ИдентификаторОрганизации);
	ПараметрыФормы.Вставить("ПараметрыПодключения"    , ТранспортныйМодуль);
	ПараметрыФормы.Вставить("ЗапомнитьПароль"         , Истина);
	
	Контекст = Новый Структура;
	Контекст.Вставить("ТранспортныйМодуль"     , ТранспортныйМодуль);
	Контекст.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	Обработчик = Новый ОписаниеОповещения("АвторизоватьсяСУказаниемПароля_ПослеАвторизации", ЭтотОбъект, Контекст);
	ОткрытьФорму("ОбщаяФорма.АвторизацияАПИМДЛП", ПараметрыФормы,,,,, Обработчик);
	
КонецПроцедуры

Процедура АвторизоватьсяСУказаниемПароля_ПослеАвторизации(Результат, Контекст) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Результат = Новый Структура;
		Результат.Вставить("Статус", "Ошибка");
		Результат.Вставить("ОписаниеОшибки", НСтр("ru = 'Ошибка авторизации.'"));
	Иначе
		ТранспортныйМодуль = Контекст.ТранспортныйМодуль;
		ТранспортныйМодуль.Вставить("КлючСессии", Результат.КлючСессии);
		УстановитьТекущийКлючСессии(ТранспортныйМодуль, Результат.КлючСессии, Результат.ВремяЖизни);
		Результат.Вставить("ТранспортныйМодуль", ТранспортныйМодуль);
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Контекст.ОповещениеПриЗавершении, Результат);
	
КонецПроцедуры

Функция ТекущийКлючСессии(ТранспортныйМодуль)
	
	ТребуетсяАвторизация = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ТранспортныйМодуль, "ТребуетсяАвторизация", Ложь);
	Если ТребуетсяАвторизация Тогда
		ТранспортныйМодуль.Удалить("ТребуетсяАвторизация");
	КонецЕсли;
	
	ИмяПараметра = "ИнтеграцияМДЛП.КлючСессии";
	
	КлючиСессий = ПараметрыПриложения[ИмяПараметра];
	Если КлючиСессий = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПараметрыКлючаСессии = КлючиСессий[ТранспортныйМодуль.ИдентификаторОрганизации];
	Если ПараметрыКлючаСессии = Неопределено Или ПараметрыКлючаСессии.ДатаИстеченияСрока < ТекущаяДата() Тогда
		Возврат Неопределено;
	Иначе
		
		Если ТребуетсяАвторизация Тогда
			УстаревшийКлючСессии = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ТранспортныйМодуль, "КлючСессии");
			Если УстаревшийКлючСессии = ПараметрыКлючаСессии.КлючСессии Тогда
				Возврат Неопределено;
			КонецЕсли;
		КонецЕсли;
		
		Возврат ПараметрыКлючаСессии.КлючСессии;
		
	КонецЕсли;
	
КонецФункции

Процедура УстановитьТекущийКлючСессии(ТранспортныйМодуль, КлючСессии, ВремяЖизни = Неопределено)
	
	ИмяПараметра = "ИнтеграцияМДЛП.КлючСессии";
	
	КлючиСессий = ПараметрыПриложения[ИмяПараметра];
	Если КлючиСессий = Неопределено Тогда
		КлючиСессий = Новый Соответствие;
		ПараметрыПриложения.Вставить(ИмяПараметра, КлючиСессий);
	КонецЕсли;
	
	Если КлючСессии = Неопределено Тогда
		КлючиСессий.Вставить(ТранспортныйМодуль.ИдентификаторОрганизации, Неопределено);
	Иначе
		КлючиСессий.Вставить(
			ТранспортныйМодуль.ИдентификаторОрганизации,
			Новый Структура(
				"КлючСессии, ДатаИстеченияСрока",
				КлючСессии,
				ТекущаяДата() + ВремяЖизни * 60));
	КонецЕсли;
	
КонецПроцедуры

Функция СертификатСессии(ТранспортныйМодуль)
	
	ИмяПараметра = "ИнтеграцияМДЛП.СертификатСессии";
	
	Сертификаты = ПараметрыПриложения[ИмяПараметра];
	Если Сертификаты = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Сертификаты[ТранспортныйМодуль.ИдентификаторОрганизации];
	
КонецФункции

Процедура УстановитьСертификатСессии(ТранспортныйМодуль, Сертификат)
	
	ИмяПараметра = "ИнтеграцияМДЛП.СертификатСессии";
	
	Сертификаты = ПараметрыПриложения[ИмяПараметра];
	
	Если Сертификат = Неопределено И Сертификаты = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Сертификаты = Неопределено Тогда
		Сертификаты = Новый Соответствие;
		ПараметрыПриложения.Вставить(ИмяПараметра, Сертификаты);
	КонецЕсли;
	
	Если Сертификат <> Неопределено Тогда
		Сертификаты.Вставить(ТранспортныйМодуль.ИдентификаторОрганизации, Сертификат);
	ИначеЕсли Сертификаты[ТранспортныйМодуль.ИдентификаторОрганизации] <> Неопределено Тогда
		Сертификаты.Удалить(ТранспортныйМодуль.ИдентификаторОрганизации);
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьСвойстваПодписи(РезультатПодписания)
	
	Если ЭтоАдресВременногоХранилища(РезультатПодписания.СвойстваПодписи) Тогда
		СвойстваПодписи = ПолучитьИзВременногоХранилища(РезультатПодписания.СвойстваПодписи);
	Иначе
		СвойстваПодписи = РезультатПодписания.СвойстваПодписи;
	КонецЕсли;
	
	Возврат СвойстваПодписи;
	
КонецФункции

Процедура ПолучитьТекущееОграничениеРазмераНебольшихДокументов(ТранспортныйМодуль)
	
	ОграничениеРазмераНебольшихДокументов = ОграничениеРазмераНебольшихДокументов(ТранспортныйМодуль);
	Если ОграничениеРазмераНебольшихДокументов <> Неопределено Тогда
		ТранспортныйМодуль.Вставить("ОграничениеРазмераНебольшихДокументов", ОграничениеРазмераНебольшихДокументов);
	Иначе
		Результат = ТранспортМДЛПАПИВызовСервера.ВыполнитьМетодАПИ(ТранспортныйМодуль, "ПолучитьОграничениеРазмераНебольшихДокументов");
		Если Результат.Статус <> "Ошибка" Тогда
			ТранспортныйМодуль.Вставить("ОграничениеРазмераНебольшихДокументов", Результат.ОграничениеРазмераНебольшихДокументов);
			УстановитьОграничениеРазмераНебольшихДокументов(ТранспортныйМодуль, Результат.ОграничениеРазмераНебольшихДокументов);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ОграничениеРазмераНебольшихДокументов(ТранспортныйМодуль)
	
	ИмяПараметра = "ИнтеграцияМДЛП.ОграничениеРазмераНебольшихДокументов";
	
	ОграниченияРазмераНебольшихДокументов = ПараметрыПриложения[ИмяПараметра];
	Если ОграниченияРазмераНебольшихДокументов = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ОграниченияРазмераНебольшихДокументов[ТранспортныйМодуль.ИдентификаторОрганизации];
	
КонецФункции

Процедура УстановитьОграничениеРазмераНебольшихДокументов(ТранспортныйМодуль, ОграничениеРазмераНебольшихДокументов)
	
	ИмяПараметра = "ИнтеграцияМДЛП.ОграничениеРазмераНебольшихДокументов";
	
	ОграниченияРазмераНебольшихДокументов = ПараметрыПриложения[ИмяПараметра];
	
	Если ОграничениеРазмераНебольшихДокументов = Неопределено И ОграниченияРазмераНебольшихДокументов = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ОграниченияРазмераНебольшихДокументов = Неопределено Тогда
		ОграниченияРазмераНебольшихДокументов = Новый Соответствие;
		ПараметрыПриложения.Вставить(ИмяПараметра, ОграниченияРазмераНебольшихДокументов);
	КонецЕсли;
	
	Если ОграничениеРазмераНебольшихДокументов <> Неопределено Тогда
		ОграниченияРазмераНебольшихДокументов.Вставить(ТранспортныйМодуль.ИдентификаторОрганизации, ОграничениеРазмераНебольшихДокументов);
	ИначеЕсли ОграниченияРазмераНебольшихДокументов[ТранспортныйМодуль.ИдентификаторОрганизации] <> Неопределено Тогда
		ОграниченияРазмераНебольшихДокументов.Удалить(ТранспортныйМодуль.ИдентификаторОрганизации);
	КонецЕсли;
	
КонецПроцедуры

#Область ВыполнениеВДлительнойОперацииСлужебный

Процедура ВыполнитьМетодАПИ_ПослеПопыткиАвторизации_ДлительнаяОперация(РезультатАвторизации, Контекст) Экспорт
	
	Если РезультатАвторизации.Статус = "Ошибка" Тогда
		ВыполнитьОбработкуОповещения(Контекст.ОповещениеПриЗавершении, РезультатАвторизации);
		Возврат;
	КонецЕсли;
	
	ТранспортныйМодуль = РезультатАвторизации.ТранспортныйМодуль;
	Контекст.Вставить("ТранспортныйМодуль", ТранспортныйМодуль);
	
	ПараметрыМетода = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Контекст, "ПараметрыМетода");
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Неопределено);
	ЗаполнитьЗначенияСвойств(ПараметрыОжидания, ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Контекст.ПараметрыЗапуска, "ПараметрыОжидания", Новый Структура));
	
	ПараметрыВыполненияВФоне = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Контекст.ПараметрыЗапуска, "ПараметрыВыполненияВФоне", Новый Структура);
	
	ДлительнаяОперация = ТранспортМДЛПАПИВызовСервера.ВыполнитьМетодАПИ_ДлительнаяОперация(ТранспортныйМодуль, Контекст.ИмяМетода, ПараметрыМетода, ПараметрыВыполненияВФоне);
	
	ОповещениеПередОжиданием = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Контекст.ПараметрыЗапуска, "ОповещениеПередОжиданиемДлительнойОперации");
	Если ОповещениеПередОжиданием <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ОповещениеПередОжиданием, ДлительнаяОперация);
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ВыполнитьМетодАПИ_ОбработатьРезультат_ДлительнаяОперация", ЭтотОбъект, Контекст);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Оповещение, ПараметрыОжидания);
	
КонецПроцедуры

Процедура ВыполнитьМетодАПИ_ОбработатьРезультат_ДлительнаяОперация(РезультатДлительнойОперации, Контекст) Экспорт
	
	Если РезультатДлительнойОперации = Неопределено Тогда
		
		Результат = ТранспортМДЛПКлиентСервер.РезультатВыполненияОперации();
		Результат.Статус = "Отменено";
		ВыполнитьОбработкуОповещения(Контекст.ОповещениеПриЗавершении, Результат);
		Возврат;
		
	КонецЕсли;
	
	Если РезультатДлительнойОперации.Статус = "Ошибка" Тогда
		
		Результат = ТранспортМДЛПКлиентСервер.РезультатВыполненияОперации();
		Результат.Статус = "Ошибка";
		Результат.ОписаниеОшибки = РезультатДлительнойОперации.КраткоеПредставлениеОшибки;
		ВыполнитьОбработкуОповещения(Контекст.ОповещениеПриЗавершении, Результат);
		Возврат;
		
	КонецЕсли;
	
	Результат = ТранспортМДЛПАПИВызовСервера.ВыполнитьМетодАПИ_ОбработатьРезультат_ДлительнаяОперация(РезультатДлительнойОперации.АдресРезультата);
	Если Результат.Статус = "Ошибка" Тогда
		Если Результат.ТребуетсяАвторизация Тогда
			
			Оповещение = Новый ОписаниеОповещения("ВыполнитьМетодАПИ_ПослеПопыткиАвторизации_ДлительнаяОперация", ЭтотОбъект, Контекст);
			Контекст.ТранспортныйМодуль.Вставить("ТребуетсяАвторизация", Результат.ТребуетсяАвторизация);
			ПолучитьТекущийКлючСессии(Контекст.ТранспортныйМодуль, Оповещение);
			Возврат;
			
		КонецЕсли;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Контекст.ОповещениеПриЗавершении, Результат);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
