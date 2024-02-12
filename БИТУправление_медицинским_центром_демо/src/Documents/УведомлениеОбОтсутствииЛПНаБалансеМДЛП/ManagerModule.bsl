
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	ИнтеграцияМДЛПВызовСервера.ПриПолученииФормыДокумента(
		ПустаяСсылка(), ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДействияПриОбмене

Функция ОбновитьСтатусПослеПодготовкиКПередачеДанных(ДокументСсылка, Операция) Экспорт
	
	Возврат ИнтеграцияМДЛП.ОбновитьСтатусПослеПодготовкиКПередачеДанных(ДокументСсылка, Операция);
	
КонецФункции

Функция ОбновитьСтатусПослеПередачиДанных(ДокументСсылка, Операция, СтатусОбработки) Экспорт
	
	Возврат ИнтеграцияМДЛП.ОбновитьСтатусПослеПередачиДанных(ДокументСсылка, Операция, СтатусОбработки);
	
КонецФункции

Функция ОбновитьСтатусПослеПолученияДанных(ДокументСсылка, Операция, ДополнительныеПараметры = Неопределено) Экспорт
	
	Возврат ИнтеграцияМДЛП.ОбновитьСтатусПослеПолученияДанных(ДокументСсылка, Операция, ДополнительныеПараметры);
	
КонецФункции

Процедура ОбновитьСостояниеПодтверждения(ДокументОбъект, Операция, Сообщение, СтатусОбработки, ОтклоненныеНомера = Неопределено) Экспорт
	
	ПараметрыОбновления = ИнтеграцияМДЛП.СостояниеПодтверждения(Операция, Сообщение, СтатусОбработки);
	
	Если ПараметрыОбновления = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДокументОбъект.СостояниеПодтверждения = ПараметрыОбновления.Состояние;
	Если ДокументОбъект.СостояниеПодтверждения <> Перечисления.СостоянияПодтвержденияМДЛП.ОтклоненоГИСМ И ЗначениеЗаполнено(ОтклоненныеНомера) Тогда
		
		Для Каждого Номер Из ОтклоненныеНомера Цикл
			НомерУпаковки = Номер.Ключ;
			Строка = ДокументОбъект.НомераУпаковок.Найти(НомерУпаковки, "НомерКиЗ");
			Строка.Отклонено = Истина;
			Строка.ПричинаОтказа = ИнтеграцияМДЛП.ПредставлениеПричиныОтклонения(Номер.Значение);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// Определить необходимость перерасчета статуса оформления документов.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - Документ, по которому требуется рассчитать статус оформления.
//  ПредыдущийСтатус - ПеречислениеСсылка.СтатусыОбработки - Предыдущий статус.
//  НовыйСтатус - ПеречислениеСсылка.СтатусыОбработки - Новый статус.
// 
// Возвращаемое значение:
//  Булево - Необходимость перерасчета статуса оформления.
//
Функция РассчитатьСтатусОформления(ДокументСсылка, ПредыдущийСтатус, НовыйСтатус) Экспорт
	
	Основание = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументСсылка, "Основание");
	Если ЗначениеЗаполнено(Основание) Тогда
		ИнтеграцияМДЛППереопределяемый.РассчитатьСтатусОформленияУведомленияОбОтсутствииЛПНаБалансе(Основание);
	КонецЕсли;
	
КонецФункции

// Получить последовательность операций в течении жизненного цикла документа.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - см. функцию ИнтеграцияМДЛП.ПустаяТаблицаПоследовательностьОпераций().
//
Функция ПоследовательностьОпераций(ДокументСсылка) Экспорт
	
	Таблица = ИнтеграцияМДЛП.ПустаяТаблицаПоследовательностьОпераций();
	
	Исходящее = Перечисления.ТипыСообщенийМДЛП.Исходящее;
	
	ИнтеграцияМДЛП.ДобавитьОперациюВПоследовательность(Таблица, 0, Исходящее, Перечисления.ОперацииОбменаМДЛП.ПередачаДанных_ОтсутствиеЛПНаБалансеМДЛП);
	
	Возврат Таблица;
	
КонецФункции

#КонецОбласти

#Область Статусы

// Возвращает статус информирования по умолчанию.
// 
// Возвращаемое значение:
//  Перечисления.СтатусыИнформированияМДЛП - Статус по-умолчанию.
//
Функция СтатусИнформированияПоУмолчанию() Экспорт
	
	Возврат Перечисления.СтатусыИнформированияМДЛП.Черновик;
	
КонецФункции

// Возвращает дальнейшее действие по умолчанию.
// 
// Возвращаемое значение:
//  Перечисления.ДальнейшиеДействияПоВзаимодействиюМДЛП - Дальнейшее действие по-умолчанию.
//
Функция ДальнейшееДействиеПоУмолчанию() Экспорт
	
	Возврат Перечисления.ДальнейшиеДействияПоВзаимодействиюМДЛП.ПередайтеДанные;
	
КонецФункции

// Возвращает запрос для получения статуса оформления.
//
// Параметры:
//  ДокументОснование - ДокументСсылка - Документ основание.
// 
// Возвращаемое значение:
//  Запрос - Запрос для получения статуса оформления.
//
Функция ЗапросСтатусаОформления(ДокументОснование) Экспорт
	
	Запрос = ИнтеграцияМДЛППереопределяемый.ЗапросСтатусаОформленияУведомленияОбОтсутствииЛПНаБалансе(ДокументОснование);
	
	Возврат Запрос;
	
КонецФункции

#КонецОбласти

#Область ПанельМаркировкиМДЛП

Функция ВсеТребующиеДействия(Все = Ложь) Экспорт
	
	Действия = Новый Массив;
	Действия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюМДЛП.ПередайтеДанные);
	Если Все Или Не ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическуюОтправкуПолучениеДанныхМДЛП") Тогда
		Действия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюМДЛП.ВыполнитеОбмен);
	КонецЕсли;
	Действия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюМДЛП.ПолучитеКвитанциюОФиксации);
	Действия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюМДЛП.Закройте);
	
	Возврат Действия;
	
КонецФункции

Функция ВсеТребующиеОжидания(Все = Ложь) Экспорт
	
	Действия = Новый Массив;
	Действия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюМДЛП.ОжидайтеПолучениеКвитанцииОФиксации);
	Если Все Или ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическуюОтправкуПолучениеДанныхМДЛП") Тогда
		Действия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюМДЛП.ОжидайтеПередачуДанныхРегламентнымЗаданием);
	КонецЕсли;
	
	Возврат Действия;
	
КонецФункции

Процедура ПриЗаполненииДокументовПанелиМаркировкиМДЛП(ТаблицаДокументы) Экспорт
	
	Описание = ИнтеграцияМДЛП.ДобавитьДокументНаПанельМаркировки(
		ТаблицаДокументы,
		Метаданные.Документы.УведомлениеОбОтсутствииЛПНаБалансеМДЛП,
		НСтр("ru = 'Отсутствие на балансе'"),
		ИнтеграцияМДЛПКлиентСервер.ПанельМаркировкаРазделЗакупки());
	
	Описание.Оформите    = Истина;
	Описание.Отработайте = Истина;
	Описание.Ожидайте    = Истина;
	
	Описание.Порядок = 110;
	
КонецПроцедуры

// Возвращает текст запроса для получения количества документов для оформления
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ПанельМаркировкиМДЛПТекстЗапросаОформите() Экспорт
	
	Возврат ИнтеграцияМДЛППереопределяемый.УведомлениеОбОтсутствииЛПНаБалансеТекстЗапросаОформите();
	
КонецФункции

// Возвращает текст запроса для получения количества документов для отработки
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ПанельМаркировкиМДЛПТекстЗапросаОтработайте() Экспорт
	
	Возврат Обработки.ПанельМаркировкиМДЛП.ТекстЗапросаОтработайте(Метаданные.Документы.УведомлениеОбОтсутствииЛПНаБалансеМДЛП);
	
КонецФункции

// Возвращает текст запроса для получения количества документов, находящихся в состоянии ожидания
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ПанельМаркировкиМДЛПТекстЗапросаОжидайте() Экспорт
	
	Возврат Обработки.ПанельМаркировкиМДЛП.ТекстЗапросаОжидайте(Метаданные.Документы.УведомлениеОбОтсутствииЛПНаБалансеМДЛП);
	
КонецФункции

// Возвращает текст запроса для формирования данных динамического списка формы списка и формы выбора документов.
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ПанельМаркировкиМДЛПТекстЗапросаДинамическогоСписока() Экспорт
	
	Возврат Обработки.ПанельМаркировкиМДЛП.ТекстЗапросаДинамическогоСпискаФормДокументов(Метаданные.Документы.УведомлениеОбОтсутствииЛПНаБалансеМДЛП);
	
КонецФункции

// Возвращает текст запроса для формирования данных динамического Списка к оформлению формы списка и формы выбора документов.
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ПанельМаркировкиМДЛПТекстЗапросаДинамическогоСпискаКОформлению() Экспорт
	
	ТекстЗапроса = ИнтеграцияМДЛППереопределяемый.УведомлениеОбОтсутствииЛПНаБалансеТекстЗапросаДинамическогоСпискаКОформлению();
	Если Не ЗначениеЗаполнено(ТекстЗапроса) Тогда
		ТекстЗапроса = Обработки.ПанельМаркировкиМДЛП.ТекстЗапросаДинамическогоСпискаКОформлениюФормДокументов();
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область СообщениеМДЛП

Функция СообщениеКПередаче(ДокументСсылка, ДальнейшееДействие, ДополнительныеПараметры = Неопределено) Экспорт
	
	Возврат УведомлениеОбОтсутствииЛПНаБалансе(ДокументСсылка, ДальнейшееДействие);
	
КонецФункции

#КонецОбласти

// Возвращает данные для заполнения представления документа.
//
// Возвращаемое значение:
//  Структура - Структура со свойствами:
//  * КомандаСоздать - Строка - Представление документа, если документ требуется создать.
//  * ИмяКомандыСоздать - Строка - Имя команды "Создать".
//  * ИмяКомандыОткрыть - Строка - Имя команды "Открыть".
//  * ДокументОтсутствуетНетПравНаСоздание - Строка - Представление документа, если документ не создан.
//  * Представление - Строка - Представление документа.
//  * НесколькоДокументовПредставление - Строка - Представление документа, если их несколько.
//
Функция ПредставлениеДокумента() Экспорт
	
	ВозвращаемоеЗначение = ИнтеграцияМДЛП.ПустоеПредставлениеДокумента();
	ВозвращаемоеЗначение.КомандаСоздать                       = НСтр("ru = 'Создать уведомление об отсутствии ЛП на балансе МДЛП'");
	ВозвращаемоеЗначение.ИмяКомандыСоздать                    = "СоздатьУведомлениеОбОтсутствииЛПНаБалансеМДЛП";
	ВозвращаемоеЗначение.КомандаСвязать                       = НСтр("ru = 'Связать с уведомлением об отсутствии ЛП на балансе МДЛП (%1)'");
	ВозвращаемоеЗначение.ИмяКомандыСвязать                    = "СвязатьУведомлениеОбОтсутствииЛПНаБалансеМДЛП";
	ВозвращаемоеЗначение.ИмяКомандыОткрыть                    = "ОткрытьУведомлениеОбОтсутствииЛПНаБалансеМДЛП";
	ВозвращаемоеЗначение.ДокументОтсутствуетНетПравНаСоздание = НСтр("ru = 'Уведомление об отсутствии ЛП на балансе МДЛП не создано'");
	ВозвращаемоеЗначение.Представление                        = НСтр("ru = 'Уведомление об отсутствии ЛП на балансе МДЛП: %1'");
	ВозвращаемоеЗначение.НесколькоДокументовПредставление     = НСтр("ru = 'Уведомление об отсутствии ЛП на балансе МДЛП (%1)'");
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ПоддерживаетЗагрузкуУведомлений() Экспорт
	Возврат Ложь;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьИменаРеквизитовПоФлагуОтстутсвияСерий(ПередачаСведенийОбОтсутствииСерий, ВсеРеквизиты, РеквизитыОперации) Экспорт
	
	ВсеРеквизиты = Новый Массив;
	ВсеРеквизиты.Добавить("НомераУпаковок");
	ВсеРеквизиты.Добавить("Товары.КоличествоУпаковок");
	ВсеРеквизиты.Добавить("Товары.Количество");
	
	РеквизитыОперации = Новый Массив;
	Если Не ПередачаСведенийОбОтсутствииСерий Тогда
		РеквизитыОперации.Добавить("НомераУпаковок");
		РеквизитыОперации.Добавить("Товары.КоличествоУпаковок");
		РеквизитыОперации.Добавить("Товары.Количество");
	КонецЕсли;
	
КонецПроцедуры

#Область ОбработкаСообщенийМДЛП

Функция УведомлениеОбОтсутствииЛПНаБалансе(ДокументСсылка, ДальнейшееДействие)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Сообщения = Новый Массив;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Шапка.Организация.ВерсияСхемОбмена                           КАК ВерсияСхемОбмена,
	|	Шапка.Ссылка                                                 КАК Ссылка,
	|	Шапка.Дата                                                   КАК Дата,
	|	Шапка.Основание                                              КАК Основание,
	|	Шапка.Организация.РегистрационныйНомерУчастника              КАК ИдентификаторОрганизации,
	|	Шапка.МестоДеятельности.Идентификатор                        КАК ИдентификаторМестаДеятельности
	|ИЗ
	|	Документ.УведомлениеОбОтсутствииЛПНаБалансеМДЛП КАК Шапка
	|ГДЕ
	|	Шапка.Ссылка = &Ссылка
	|	И Шапка.СостояниеПодтверждения = ЗНАЧЕНИЕ(Перечисление.СостоянияПодтвержденияМДЛП.КПередаче)
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НомераУпаковок.НомерКиЗ  КАК НомерКиЗ
	|ИЗ
	|	Документ.УведомлениеОбОтсутствииЛПНаБалансеМДЛП.Товары КАК Товары
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.УведомлениеОбОтсутствииЛПНаБалансеМДЛП.НомераУпаковок КАК НомераУпаковок
	|	ПО
	|		НомераУпаковок.Ссылка = Товары.Ссылка
	|		И НомераУпаковок.ИдентификаторСтроки = Товары.ИдентификаторСтроки
	|ГДЕ
	|	Товары.Ссылка = &Ссылка
	|	И НЕ Товары.Ссылка.ПередачаСведенийОбОтсутствииСерий
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.GTIN              КАК GTIN,
	|	Товары.НомерСерии        КАК НомерСерии
	|ИЗ
	|	Документ.УведомлениеОбОтсутствииЛПНаБалансеМДЛП.Товары КАК Товары
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Документ.УведомлениеОбОтсутствииЛПНаБалансеМДЛП.НомераУпаковок КАК НомераУпаковок
	|	ПО
	|		НомераУпаковок.Ссылка = Товары.Ссылка
	|		И НомераУпаковок.ИдентификаторСтроки = Товары.ИдентификаторСтроки
	|ГДЕ
	|	Товары.Ссылка = &Ссылка
	|	И Товары.Ссылка.ПередачаСведенийОбОтсутствииСерий
	|СГРУППИРОВАТЬ ПО
	|	Товары.GTIN,
	|	Товары.НомерСерии
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(НомераУпаковок.НомерКиЗ) = 0
	|");
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Результат = Запрос.ВыполнитьПакет();
	Шапка    = Результат[0].Выбрать();
	Упаковки = Результат[1].Выгрузить();
	Товары   = Результат[2].Выгрузить();
	
	Если Не Шапка.Следующий() Или Упаковки.Количество() = 0 И Товары.Количество() = 0 Тогда
		
		СообщениеКПередаче = ИнтеграцияМДЛП.СтруктураСообщенияКПередаче();
		СообщениеКПередаче.Документ = ДокументСсылка;
		СообщениеКПередаче.Операция = Перечисления.ОперацииОбменаМДЛП.ПередачаДанных_ОтсутствиеЛПНаБалансеМДЛП;
		
		ИнтеграцияМДЛПКлиентСервер.ДобавитьТекстОшибки(СообщениеКПередаче, НСтр("ru = 'Нет данных для выгрузки.'"));
		Сообщения.Добавить(СообщениеКПередаче);
		Возврат Сообщения;
		
	КонецЕсли;
	
	Если Упаковки.Количество() > 0 Тогда
		СообщениеКПередаче = УведомлениеОбОтсутствииЛПНаБалансе_НомераКИЗ(ДокументСсылка, Шапка, Упаковки);
		Сообщения.Добавить(СообщениеКПередаче);
	КонецЕсли;
	
	Если Товары.Количество() > 0 Тогда
		Для Каждого Строка Из Товары Цикл
			СообщениеКПередаче = УведомлениеОбОтсутствииЛПНаБалансе_СведенияОСерии(ДокументСсылка, Шапка, Строка);
			Сообщения.Добавить(СообщениеКПередаче);
		КонецЦикла;
	КонецЕсли;
	
	Возврат Сообщения;
	
КонецФункции

Функция УведомлениеОбОтсутствииЛПНаБалансе_НомераКИЗ(ДокументСсылка, Шапка, Упаковки)
	
	СообщениеКПередаче = ИнтеграцияМДЛП.СтруктураСообщенияКПередаче();
	СообщениеКПередаче.Документ = ДокументСсылка;
	СообщениеКПередаче.Операция = Перечисления.ОперацииОбменаМДЛП.ПередачаДанных_ОтсутствиеЛПНаБалансеМДЛП;
	
	ПространствоИмен = ИнтеграцияМДЛП.ПространствоИмен(Шапка.ВерсияСхемОбмена);
	
	УстановленныеДаты = Новый Соответствие;
	
	ИмяТипа   = "documents";
	ПередачаДанных = ИнтеграцияМДЛП.ОбъектXDTOПоИмениСвойства(Неопределено, ИмяТипа, ПространствоИмен);
	ИнтеграцияМДЛП.УстановитьВерсиюСхемОбменаПакета(ПередачаДанных);
	
	СообщениеКПередаче.Операция = Перечисления.ОперацииОбменаМДЛП.ПередачаДанных_ОтсутствиеЛПНаБалансеМДЛП;
	ИмяПакета = "not_on_balance";
	
	Уведомление = ИнтеграцияМДЛП.ОбъектXDTOПоИмениСвойства(ПередачаДанных, ИмяПакета);
	ПередачаДанных[ИмяПакета] = Уведомление;
	
	Уведомление.action_id = Уведомление.action_id;
	
	ИнтеграцияМДЛП.ЗаполнитьСвойствоXDTO(Уведомление, "subject_id", Шапка.ИдентификаторМестаДеятельности, СообщениеКПередаче);
	ИнтеграцияМДЛП.УстановитьДатуСЧасовымПоясом(Уведомление, "operation_date", Шапка.Дата, УстановленныеДаты);
	
	Уведомление.order_details = ИнтеграцияМДЛП.ОбъектXDTOПоИмениСвойства(Уведомление, "order_details");
	
	Для Каждого Строка Из Упаковки Цикл
		ИнтеграцияМДЛП.ЗаполнитьСвойствоXDTO(Уведомление.order_details, "sgtin", Строка.НомерКиЗ, СообщениеКПередаче);
	КонецЦикла;
	
	ИнтеграцияМДЛП.ПроверитьОбъектXDTO(ПередачаДанных, СообщениеКПередаче);
	
	ТекстСообщения = ИнтеграцияМДЛП.ОбъектXDTOВXML(ПередачаДанных, ИмяТипа, ПространствоИмен);
	ТекстСообщения = ИнтеграцияМДЛП.ПреобразоватьВременныеДаты(УстановленныеДаты, ТекстСообщения);
	
	СообщениеКПередаче.ТекстСообщения = ТекстСообщения;
	СообщениеКПередаче.ИдентификаторСубъектаОбращения = Шапка.ИдентификаторМестаДеятельности;
	СообщениеКПередаче.Основание      = Шапка.Основание;
	СообщениеКПередаче.ТипСообщения   = Перечисления.ТипыСообщенийМДЛП.Исходящее;
	СообщениеКПередаче.ОбновитьСостояниеПодтверждения = Истина;
	
	Возврат СообщениеКПередаче;
	
КонецФункции

Функция УведомлениеОбОтсутствииЛПНаБалансе_СведенияОСерии(ДокументСсылка, Шапка, ДанныеСерии)
	
	СообщениеКПередаче = ИнтеграцияМДЛП.СтруктураСообщенияКПередаче();
	СообщениеКПередаче.Документ = ДокументСсылка;
	СообщениеКПередаче.Операция = Перечисления.ОперацииОбменаМДЛП.ПередачаДанных_ОтсутствиеЛПНаБалансеМДЛП;
	
	ПространствоИмен = ИнтеграцияМДЛП.ПространствоИмен(Шапка.ВерсияСхемОбмена);
	
	УстановленныеДаты = Новый Соответствие;
	
	ИмяТипа   = "documents";
	ПередачаДанных = ИнтеграцияМДЛП.ОбъектXDTOПоИмениСвойства(Неопределено, ИмяТипа, ПространствоИмен);
	ИнтеграцияМДЛП.УстановитьВерсиюСхемОбменаПакета(ПередачаДанных);
	
	СообщениеКПередаче.Операция = Перечисления.ОперацииОбменаМДЛП.ПередачаДанных_ОтсутствиеЛПНаБалансеМДЛП;
	ИмяПакета = "not_on_balance";
	
	Уведомление = ИнтеграцияМДЛП.ОбъектXDTOПоИмениСвойства(ПередачаДанных, ИмяПакета);
	ПередачаДанных[ИмяПакета] = Уведомление;
	
	Уведомление.action_id = Уведомление.action_id;
	
	ИнтеграцияМДЛП.ЗаполнитьСвойствоXDTO(Уведомление, "subject_id", Шапка.ИдентификаторМестаДеятельности, СообщениеКПередаче);
	ИнтеграцияМДЛП.УстановитьДатуСЧасовымПоясом(Уведомление, "operation_date", Шапка.Дата, УстановленныеДаты);
	
	Уведомление.order_details = ИнтеграцияМДЛП.ОбъектXDTOПоИмениСвойства(Уведомление, "order_details");
	
	НоваяСтрока = ИнтеграцияМДЛП.ОбъектXDTOПоИмениСвойства(Уведомление.order_details, "series_details");
	ИнтеграцияМДЛП.ЗаполнитьСвойствоXDTO(НоваяСтрока, "series_number", ДанныеСерии.НомерСерии, СообщениеКПередаче);
	ИнтеграцияМДЛП.ЗаполнитьСвойствоXDTO(НоваяСтрока, "gtin"         , ДанныеСерии.gtin, СообщениеКПередаче);
	Уведомление.order_details.series_details = НоваяСтрока;
	
	ИнтеграцияМДЛП.ПроверитьОбъектXDTO(ПередачаДанных, СообщениеКПередаче);
	
	ТекстСообщения = ИнтеграцияМДЛП.ОбъектXDTOВXML(ПередачаДанных, ИмяТипа, ПространствоИмен);
	ТекстСообщения = ИнтеграцияМДЛП.ПреобразоватьВременныеДаты(УстановленныеДаты, ТекстСообщения);
	
	СообщениеКПередаче.ТекстСообщения = ТекстСообщения;
	СообщениеКПередаче.ИдентификаторСубъектаОбращения = Шапка.ИдентификаторМестаДеятельности;
	СообщениеКПередаче.Основание      = Шапка.Основание;
	СообщениеКПередаче.ТипСообщения   = Перечисления.ТипыСообщенийМДЛП.Исходящее;
	СообщениеКПередаче.ОбновитьСостояниеПодтверждения = Истина;
	
	Возврат СообщениеКПередаче;
	
КонецФункции

#КонецОбласти

#Область Серии

// Имена реквизитов, от значений которых зависят параметры указания серий
//
// Возвращаемое значение:
//  Строка - имена реквизитов, перечисленные через запятую
//
Функция ИменаРеквизитовДляЗаполненияПараметровУказанияСерий() Экспорт
	
	Возврат ГосударственныеИнформационныеСистемыПереопределяемый.ИменаРеквизитовДляЗаполненияПараметровУказанияСерий(ПустаяСсылка().Метаданные());
	
КонецФункции

// Возвращает параметры указания серий для товаров, указанных в документе.
//
// Параметры:
//  Объект - Структура - структура значений реквизитов объекта, необходимых для заполнения параметров указания серий.
// 
// Возвращаемое значение:
//  Структура
//
Функция ПараметрыУказанияСерий(Объект) Экспорт
	
	Возврат ГосударственныеИнформационныеСистемыПереопределяемый.ПараметрыУказанияСерий(ПустаяСсылка().Метаданные(), Объект);
	
КонецФункции

// Возвращает текст запроса для расчета статусов указания серий
//
// Параметры:
//  ПараметрыУказанияСерий - Структура
//
// Возвращаемое значение:
//  Строка - текст запроса
//
Функция ТекстЗапросаЗаполненияСтатусовУказанияСерий(ПараметрыУказанияСерий) Экспорт
	
	Возврат ГосударственныеИнформационныеСистемыПереопределяемый.ТекстЗапросаЗаполненияСтатусовУказанияСерий(ПустаяСсылка().Метаданные(), ПараметрыУказанияСерий);
	
КонецФункции

#КонецОбласти

#Область Отчеты

// Заполняет список команд отчетов.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции Подключаемые.СоздатьКоллекциюКомандОтчетов
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, НастройкиФормы) Экспорт
	
	ГосударственныеИнформационныеСистемыПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
	
КонецПроцедуры

// Сформировать печатные формы объектов.
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую.
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать.
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати.
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы.
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#Область ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
//
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
