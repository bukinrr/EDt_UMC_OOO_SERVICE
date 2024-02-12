
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
	
	Статусы = РегистрыСведений.СтатусыИнформированияМДЛП.СтатусыОбработки();
	Статусы.Принят = Перечисления.СтатусыИнформированияМДЛП.Передано;
	Статусы.ПринятДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюМДЛП.ОжидайтеПолучениеИнформации);
	
	Статусы.Ошибка = Перечисления.СтатусыИнформированияМДЛП.ОшибкаПередачи;
	Если Операция = Перечисления.ОперацииОбменаМДЛП.ПередачаДанных_ЗапросСоставаУпаковки Тогда
		Статусы.ОшибкаДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюМДЛП.ПередайтеДанные);
	ИначеЕсли Операция = Перечисления.ОперацииОбменаМДЛП.ПередачаДанных_ЗапросИнформацииОКиЗ Тогда
		Статусы.ОшибкаДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюМДЛП.ЗапроситеИнформациюОКиЗ);
	КонецЕсли;
	
	ПараметрыОбновления = РегистрыСведений.СтатусыИнформированияМДЛП.РассчитатьСтатусы(ДокументСсылка, СтатусОбработки, Статусы);
	
	Если ПараметрыОбновления = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НовыйСтатус = РегистрыСведений.СтатусыИнформированияМДЛП.ОбновитьСтатус(
		ДокументСсылка,
		ПараметрыОбновления);
	
	Возврат НовыйСтатус;
	
КонецФункции

Функция ОбновитьСтатусПослеПолученияДанных(ДокументСсылка, Операция, ДополнительныеПараметры = Неопределено) Экспорт
	
	СтатусОбработки = ДополнительныеПараметры.СтатусОбработки;
	Статусы = РегистрыСведений.СтатусыИнформированияМДЛП.СтатусыОбработки();
	
	Статусы.Принят = Перечисления.СтатусыИнформированияМДЛП.ПринятоИзМДЛП;
	
	Если Операция = Перечисления.ОперацииОбменаМДЛП.Получение_КвитанцияОФиксации Тогда
		
		Статусы.Отклонен = Перечисления.СтатусыИнформированияМДЛП.Отклонено;
		
		Если ДополнительныеПараметры.ОперацияКвитанции = Перечисления.ОперацииОбменаМДЛП.ПередачаДанных_ЗапросСоставаУпаковки Тогда
			Статусы.ОтклоненДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюМДЛП.ПередайтеДанные);
		ИначеЕсли ДополнительныеПараметры.ОперацияКвитанции = Перечисления.ОперацииОбменаМДЛП.ПередачаДанных_ЗапросИнформацииОКиЗ Тогда
			Статусы.ОтклоненДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюМДЛП.ЗапроситеИнформациюОКиЗ);
		КонецЕсли;
		
		Статусы.ОтклоненДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюМДЛП.Закройте);
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаМДЛП.Получение_СоставУпаковки Тогда
		
		Запрос = Новый Запрос("
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	1 КАК НуженЗапросИнформацииОКиЗ
		|ИЗ
		|	Документ.УдалитьЗапросСоставаУпаковкиМДЛП.НомераУпаковок НомераУпаковок
		|ГДЕ
		|	НомераУпаковок.Ссылка = &Ссылка
		|	И НомераУпаковок.СостояниеПолученияИнформации = ЗНАЧЕНИЕ(Перечисление.СостоянияПодтвержденияМДЛП.ПустаяСсылка)
		|");
		Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
		Если Не Запрос.Выполнить().Пустой() Тогда
			Статусы.ПринятДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюМДЛП.ЗапроситеИнформациюОКиЗ);
		КонецЕсли;
		
		Статусы.Отклонен = Перечисления.СтатусыИнформированияМДЛП.Отсутствует;
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаМДЛП.Получение_ИнформацияОКиЗ Тогда
		
		Статусы.Отклонен = Перечисления.СтатусыИнформированияМДЛП.ПринятоИзМДЛП;
		Статусы.Ошибка = Перечисления.СтатусыИнформированияМДЛП.ПринятоИзМДЛП;
		
	КонецЕсли;
	
	ПараметрыОбновления = РегистрыСведений.СтатусыИнформированияМДЛП.РассчитатьСтатусы(
		ДокументСсылка, СтатусОбработки, Статусы);
	
	Если ПараметрыОбновления = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НовыйСтатус = РегистрыСведений.СтатусыИнформированияМДЛП.ОбновитьСтатус(
		ДокументСсылка, ПараметрыОбновления);
	
	Возврат НовыйСтатус;
	
КонецФункции

Процедура ОбновитьСостояниеПодтверждения(ДокументОбъект, Операция, Сообщение, СтатусОбработки, ОтклоненныеНомера = Неопределено) Экспорт
	
	НовоеСостояние = Неопределено;
	Если Операция = Перечисления.ОперацииОбменаМДЛП.ПередачаДанных_ЗапросСоставаУпаковки
	 Или Операция = Перечисления.ОперацииОбменаМДЛП.ПередачаДанных_ЗапросИнформацииОКиЗ Тогда
		
		Если СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийМДЛП.КПередаче Тогда
			НовоеСостояние = Перечисления.СостоянияПодтвержденияМДЛП.ПодготовленоКПередаче;
		ИначеЕсли СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийМДЛП.Передано Тогда
			НовоеСостояние = Перечисления.СостоянияПодтвержденияМДЛП.Передано;
		ИначеЕсли СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийМДЛП.Отклонено Тогда
			НовоеСостояние = Перечисления.СостоянияПодтвержденияМДЛП.ПустаяСсылка();
		КонецЕсли;
		
	КонецЕсли;
	
	Если НовоеСостояние = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекстСообщения = ИнтеграцияМДЛПВызовСервера.ТекстСообщенияИзПротокола(Сообщение);
	ОбъектXDTO = ИнтеграцияМДЛП.ОбъектXDTOПоТекстуСообщенияXML(ТекстСообщения, "documents", ИнтеграцияМДЛП.ПространствоИмен());
	
	Если Операция = Перечисления.ОперацииОбменаМДЛП.ПередачаДанных_ЗапросИнформацииОКиЗ Тогда
		
		ДокументОбъект.СостояниеПолученияИнформации = НовоеСостояние;
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаМДЛП.ПередачаДанных_ЗапросИнформацииОКиЗ Тогда
		
		НомерУпаковки = ОбъектXDTO.query_kiz_info.sgtin;
		Строка = ДокументОбъект.НомераУпаковок.Найти(НомерУпаковки, "НомерКиЗ");
		Если Строка <> Неопределено Тогда
			Строка.СостояниеПолученияИнформации = НовоеСостояние;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Получить последовательность операций в течении жизненного цикла документа.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - см. функцию ИнтеграцияМДЛП.ПустаяТаблицаПоследовательностьОпераций().
//
Функция ПоследовательностьОпераций(ДокументСсылка) Экспорт
	
	Таблица = ИнтеграцияМДЛП.ПустаяТаблицаПоследовательностьОпераций();
	
	Исходящее = Перечисления.ТипыСообщенийМДЛП.Исходящее;
	
	Операция = ИнтеграцияМДЛП.ДобавитьОперациюВПоследовательность(Таблица, 0, Исходящее, Перечисления.ОперацииОбменаМДЛП.ПередачаДанных_ЗапросСоставаУпаковки);
	
	Операция = ИнтеграцияМДЛП.ДобавитьОперациюВПоследовательность(Таблица, 1, Исходящее, Перечисления.ОперацииОбменаМДЛП.ПередачаДанных_ЗапросИнформацииОКиЗ);
	
	Возврат Таблица;
	
КонецФункции

// Расчет статуса оформления при смене статуса информирования.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.УведомлениеОРозничнойПродажеМДЛП - Документ, по которому требуется рассчитать статус оформления.
//  ПредыдущийСтатус - ПеречислениеСсылка.СтатусыИнформирования - Предыдущий статус.
//  НовыйСтатус - ПеречислениеСсылка.СтатусыИнформирования - Новый статус.
//
Процедура РассчитатьСтатусОформления(ДокументСсылка, ПредыдущийСтатус, НовыйСтатус) Экспорт
	
КонецПроцедуры

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
	
	Запрос = ИнтеграцияМДЛППереопределяемый.ЗапросСтатусаОформленияУведомленияОРозничныхПродажах(ДокументОснование);
	
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
	
	Возврат Действия;
	
КонецФункции

Функция ВсеТребующиеОжидания(Все = Ложь) Экспорт
	
	Действия = Новый Массив;
	Действия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюМДЛП.ОжидайтеПолучениеИнформации);
	Если Все Или ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическуюОтправкуПолучениеДанныхМДЛП") Тогда
		Действия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюМДЛП.ОжидайтеПередачуДанныхРегламентнымЗаданием);
	КонецЕсли;
	
	Возврат Действия;
	
КонецФункции

Процедура ПриЗаполненииДокументовПанелиМаркировкиМДЛП(ТаблицаДокументы) Экспорт
	
	Возврат;
	
	Описание = ИнтеграцияМДЛП.ДобавитьДокументНаПанельМаркировки(
		ТаблицаДокументы,
		Метаданные.Документы.УдалитьЗапросСоставаУпаковкиМДЛП,
		НСтр("ru = 'Запросы состава транспортных упаковок'"),
		ИнтеграцияМДЛПКлиентСервер.ПанельМаркировкаРазделСклад());
	
	Описание.Отработайте = Истина;
	Описание.Ожидайте    = Истина;
	
	Описание.Порядок = 99;
	
КонецПроцедуры

// Возвращает текст запроса для получения количества документов для отработки
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ПанельМаркировкиМДЛПТекстЗапросаОтработайте() Экспорт
	
	Возврат Обработки.ПанельМаркировкиМДЛП.ТекстЗапросаОтработайте(Метаданные.Документы.УдалитьЗапросСоставаУпаковкиМДЛП);
	
КонецФункции

// Возвращает текст запроса для получения количества документов, находящихся в состоянии ожидания
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ПанельМаркировкиМДЛПТекстЗапросаОжидайте() Экспорт
	
	Возврат Обработки.ПанельМаркировкиМДЛП.ТекстЗапросаОжидайте(Метаданные.Документы.УдалитьЗапросСоставаУпаковкиМДЛП);
	
КонецФункции

// Возвращает текст запроса для формирования данных динамического списка формы списка и формы выбора документов.
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ПанельМаркировкиМДЛПТекстЗапросаДинамическогоСписока() Экспорт
	
	Возврат Обработки.ПанельМаркировкиМДЛП.ТекстЗапросаДинамическогоСпискаФормДокументов(ПустаяСсылка().Метаданные());
	
КонецФункции

// Возвращает текст запроса для формирования данных динамического Списка к оформлению формы списка и формы выбора документов.
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ПанельМаркировкиМДЛПТекстЗапросаДинамическогоСпискаКОформлению() Экспорт
	
	ТекстЗапроса = ИнтеграцияМДЛППереопределяемый.УдалитьЗапросСоставаУпаковкиТекстЗапросаДинамическогоСпискаКОформлению();
	Если Не ЗначениеЗаполнено(ТекстЗапроса) Тогда
		ТекстЗапроса = Обработки.ПанельМаркировкиМДЛП.ТекстЗапросаДинамическогоСпискаКОформлениюФормДокументов();
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область СообщенияМДЛП

Функция СообщениеКПередаче(ДокументСсылка, ДальнейшееДействие, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюМДЛП.ПередайтеДанные Тогда
		Возврат ЗапросСоставаТранспортнойУпаковки(ДокументСсылка);
	ИначеЕсли ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюМДЛП.ЗапроситеИнформациюОКиЗ Тогда
		Возврат ЗапросИнформацииОКиЗ(ДокументСсылка)
	КонецЕсли;
	
КонецФункции

Процедура ЗагрузитьВходящееСообщение(ДанныеДокумента, Операция, ДокументСсылка) Экспорт
	
	Если Операция = Перечисления.ОперацииОбменаМДЛП.Получение_СоставУпаковки Тогда
		ЗагрузитьСоставУпаковки(ДанныеДокумента, ДокументСсылка);
	ИначеЕсли Операция = Перечисления.ОперацииОбменаМДЛП.Получение_ИнформацияОКиЗ Тогда
		ЗагрузитьИнформациюОКиЗ(ДанныеДокумента, ДокументСсылка);
	Иначе
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не известная операция %1'"), Операция);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
КонецПроцедуры

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
	ВозвращаемоеЗначение.КомандаСоздать                       = НСтр("ru = 'Создать запрос состава упаковки МДЛП'");
	ВозвращаемоеЗначение.ИмяКомандыСоздать                    = "СоздатьЗапросСоставаУпаковкиМДЛП";
	ВозвращаемоеЗначение.ИмяКомандыОткрыть                    = "ОткрытьЗапросСоставаУпаковкиМДЛП";
	ВозвращаемоеЗначение.ДокументОтсутствуетНетПравНаСоздание = НСтр("ru = 'Запрос состава упаковки МДЛП не создан'");
	ВозвращаемоеЗначение.Представление                        = НСтр("ru = 'Запрос состава упаковки МДЛП: %1'");
	ВозвращаемоеЗначение.НесколькоДокументовПредставление     = НСтр("ru = 'Запрос состава упаковки МДЛП (%1)'");
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ПоддерживаетЗагрузкуУведомлений() Экспорт
	Возврат Ложь;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЗапросСоставаТранспортнойУпаковки(ДокументСсылка)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Сообщения = Новый Массив;
	
	СообщениеКПередаче = ИнтеграцияМДЛП.СтруктураСообщенияКПередаче();
	СообщениеКПередаче.Документ = ДокументСсылка;
	СообщениеКПередаче.Операция = Перечисления.ОперацииОбменаМДЛП.ПередачаДанных_ЗапросСоставаУпаковки;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Шапка.Организация.ВерсияСхемОбмена  КАК ВерсияСхемОбмена,
	|	Шапка.Ссылка                        КАК Ссылка,
	|	Шапка.Основание                     КАК Основание,
	|	Шапка.Дата                          КАК Дата,
	|	ЕСТЬNULL(Шапка.МестоДеятельности.Идентификатор, Шапка.Организация.РегистрационныйНомерУчастника)  КАК ИдентификаторОрганизации,
	|	Шапка.НомерУпаковки                 КАК НомерУпаковки
	|ИЗ
	|	Документ.УдалитьЗапросСоставаУпаковкиМДЛП КАК Шапка
	|ГДЕ
	|	Шапка.Ссылка = &Ссылка
	|	И Шапка.СостояниеПолученияИнформации = ЗНАЧЕНИЕ(Перечисление.СостоянияПодтвержденияМДЛП.ПустаяСсылка)
	|");
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Шапка = Запрос.Выполнить().Выбрать();
	Если Не Шапка.Следующий() Тогда
		
		ИнтеграцияМДЛПКлиентСервер.ДобавитьТекстОшибки(СообщениеКПередаче, НСтр("ru = 'Нет данных для выгрузки.'"));
		Сообщения.Добавить(СообщениеКПередаче);
		Возврат Сообщения;
		
	КонецЕсли;
	
	ПространствоИмен = ИнтеграцияМДЛП.ПространствоИмен(Шапка.ВерсияСхемОбмена);
	
	ИмяТипа   = "documents";
	ИмяПакета = "query_kiz_info";
	
	ПередачаДанных = ИнтеграцияМДЛП.ОбъектXDTOПоИмениСвойства(Неопределено, ИмяТипа, ПространствоИмен);
	ИнтеграцияМДЛП.УстановитьВерсиюСхемОбменаПакета(ПередачаДанных);
	
	Уведомление = ИнтеграцияМДЛП.ОбъектXDTOПоИмениСвойства(ПередачаДанных, ИмяПакета);
	ПередачаДанных[ИмяПакета] = Уведомление;
	
	Уведомление.action_id = Уведомление.action_id;
	
	ИнтеграцияМДЛП.ЗаполнитьСвойствоXDTO(Уведомление, "subject_id", Шапка.ИдентификаторОрганизации, СообщениеКПередаче);
	ИнтеграцияМДЛП.ЗаполнитьСвойствоXDTO(Уведомление, "sscc_down" , Шапка.НомерУпаковки, СообщениеКПередаче);
	
	ИнтеграцияМДЛП.ПроверитьОбъектXDTO(ПередачаДанных, СообщениеКПередаче);
	
	ТекстСообщения = ИнтеграцияМДЛП.ОбъектXDTOВXML(ПередачаДанных, ИмяТипа, ПространствоИмен);
	
	СообщениеКПередаче.ТекстСообщения = ТекстСообщения;
	СообщениеКПередаче.ИдентификаторСубъектаОбращения = Шапка.ИдентификаторОрганизации;
	СообщениеКПередаче.Основание      = Шапка.Основание;
	СообщениеКПередаче.ТипСообщения   = Перечисления.ТипыСообщенийМДЛП.Исходящее;
	СообщениеКПередаче.ОбновитьСостояниеПодтверждения = Истина;
	
	Сообщения.Добавить(СообщениеКПередаче);
	Возврат Сообщения;
	
КонецФункции

Функция ЗапросИнформацииОКиЗ(ДокументСсылка)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Сообщения = Новый Массив;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Шапка.Организация.ВерсияСхемОбмена  КАК ВерсияСхемОбмена,
	|	Шапка.Ссылка                        КАК Ссылка,
	|	Шапка.Основание                     КАК Основание,
	|	Шапка.Дата                          КАК Дата,
	|	ЕСТЬNULL(Шапка.МестоДеятельности.Идентификатор, Шапка.Организация.РегистрационныйНомерУчастника)  КАК ИдентификаторОрганизации
	|ИЗ
	|	Документ.УдалитьЗапросСоставаУпаковкиМДЛП КАК Шапка
	|ГДЕ
	|	Шапка.Ссылка = &Ссылка
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НомераУпаковок.НомерКиЗ  КАК НомерУпаковки
	|ИЗ
	|	Документ.УдалитьЗапросСоставаУпаковкиМДЛП.НомераУпаковок КАК НомераУпаковок
	|ГДЕ
	|	НомераУпаковок.Ссылка = &Ссылка
	|	И НомераУпаковок.СостояниеПолученияИнформации = ЗНАЧЕНИЕ(Перечисление.СостоянияПодтвержденияМДЛП.ПустаяСсылка)
	|");
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	Шапка  = РезультатЗапроса[0].Выбрать();
	Товары = РезультатЗапроса[1].Выгрузить();
	
	Если Не Шапка.Следующий() Или Товары.Количество() = 0 Тогда
		
		СообщениеКПередаче = ИнтеграцияМДЛП.СтруктураСообщенияКПередаче();
		СообщениеКПередаче.Документ = ДокументСсылка;
		СообщениеКПередаче.Операция = Перечисления.ОперацииОбменаМДЛП.ПередачаДанных_ЗапросИнформацииОКиЗ;
		
		ИнтеграцияМДЛПКлиентСервер.ДобавитьТекстОшибки(СообщениеКПередаче, НСтр("ru = 'Нет данных для выгрузки.'"));
		Сообщения.Добавить(СообщениеКПередаче);
		Возврат Сообщения;
		
	КонецЕсли;
	
	ПространствоИмен = ИнтеграцияМДЛП.ПространствоИмен(Шапка.ВерсияСхемОбмена);
	
	ИмяТипа   = "documents";
	ИмяПакета = "query_kiz_info";
	
	Для Каждого ТекущаяСтрока Из Товары Цикл
		
		СообщениеКПередаче = ИнтеграцияМДЛП.СтруктураСообщенияКПередаче();
		СообщениеКПередаче.Документ = ДокументСсылка;
		СообщениеКПередаче.Операция = Перечисления.ОперацииОбменаМДЛП.ПередачаДанных_ЗапросИнформацииОКиЗ;
		
		ПередачаДанных = ИнтеграцияМДЛП.ОбъектXDTOПоИмениСвойства(Неопределено, ИмяТипа, ПространствоИмен);
		ИнтеграцияМДЛП.УстановитьВерсиюСхемОбменаПакета(ПередачаДанных);
		
		Уведомление = ИнтеграцияМДЛП.ОбъектXDTOПоИмениСвойства(ПередачаДанных, ИмяПакета);
		ПередачаДанных[ИмяПакета] = Уведомление;
		
		Уведомление.action_id = Уведомление.action_id;
		
		ИнтеграцияМДЛП.ЗаполнитьСвойствоXDTO(Уведомление, "subject_id", Шапка.ИдентификаторОрганизации, СообщениеКПередаче);
		ИнтеграцияМДЛП.ЗаполнитьСвойствоXDTO(Уведомление, "sgtin"     , ТекущаяСтрока.НомерУпаковки, СообщениеКПередаче);
		
		ИнтеграцияМДЛП.ПроверитьОбъектXDTO(ПередачаДанных, СообщениеКПередаче);
		
		ТекстСообщения = ИнтеграцияМДЛП.ОбъектXDTOВXML(ПередачаДанных, ИмяТипа, ПространствоИмен);
		
		СообщениеКПередаче.ТекстСообщения = ТекстСообщения;
		СообщениеКПередаче.ИдентификаторСубъектаОбращения = Шапка.ИдентификаторОрганизации;
		СообщениеКПередаче.Основание      = Шапка.Основание;
		СообщениеКПередаче.ТипСообщения   = Перечисления.ТипыСообщенийМДЛП.Исходящее;
		СообщениеКПередаче.ОбновитьСостояниеПодтверждения = Истина;
		
		Сообщения.Добавить(СообщениеКПередаче);
		
	КонецЦикла;
	
	Возврат Сообщения;
	
КонецФункции

Процедура ЗагрузитьСоставУпаковки(ДанныеДокумента, ДокументСсылка)
	
	Документ = ДокументСсылка.ПолучитьОбъект();
	Документ.Заблокировать();
	
	Документ.СостояниеПолученияИнформации = Перечисления.СостоянияПодтвержденияМДЛП.Подтверждено;
	Документ.Статус = ДанныеДокумента.Статус;
	
	Документ.Товары.Очистить();
	Документ.НомераУпаковок.Очистить();
	Документ.ТранспортныеУпаковки.Очистить();
	
	Состав = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДанныеДокумента.ДанныеУпаковки, "tree", Новый Массив);
	Для Каждого ЭлементСостава Из Состав Цикл
		ИнформацияОКиЗ = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ЭлементСостава, "sgtin");
		НомерУпаковки  = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ЭлементСостава, "sscc");
		Если ИнформацияОКиЗ <> Неопределено Тогда
			ЕстьДанныеКиЗ = (ТипЗнч(ИнформацияОКиЗ) = Тип("Структура"));
			Если ЕстьДанныеКиЗ Тогда
				Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ИнформацияОКиЗ, "info_sgtin") Тогда
					ИнформацияОКиЗ = ИнформацияОКиЗ.info_sgtin;
				КонецЕсли;
				НомерКиЗ = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ИнформацияОКиЗ, "sgtin");
			Иначе
				НомерКиЗ = ИнформацияОКиЗ;
			КонецЕсли;
			
			Отбор = Новый Структура;
			Если ЕстьДанныеКиЗ Тогда
				Отбор.Вставить("GTIN"      , ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ИнформацияОКиЗ, "GTIN"));
				Отбор.Вставить("НомерСерии", ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ИнформацияОКиЗ, "series_number"));
				Отбор.Вставить("ГоденДо"   , СтроковыеФункцииКлиентСервер.СтрокаВДату(ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ИнформацияОКиЗ, "expiration_date")));
			Иначе
				GTIN = Лев(НомерКиЗ, 14);
				Отбор.Вставить("GTIN", GTIN);
			КонецЕсли;
			
			НайденныеСтроки = Документ.Товары.НайтиСтроки(Отбор);
			Если НайденныеСтроки.Количество() > 0 Тогда
				СтрокаТовара = НайденныеСтроки[0];
			Иначе
				СтрокаТовара = Документ.Товары.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаТовара, Отбор);
				СтрокаТовара.ИдентификаторСтроки = Строка(Новый УникальныйИдентификатор);
			КонецЕсли;
			
			СтрокаТовара.Количество = СтрокаТовара.Количество + 1;
			
			НоваяСтрока = Документ.НомераУпаковок.Добавить();
			НоваяСтрока.ИдентификаторСтроки = СтрокаТовара.ИдентификаторСтроки;
			НоваяСтрока.НомерКИЗ = НомерКиЗ;
			Если ЕстьДанныеКиЗ Тогда
				СтрокаТовара.КодТНВЭД = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ИнформацияОКиЗ, "tnved_code");
				НоваяСтрока.Статус    = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ИнформацияОКиЗ, "status");
				НоваяСтрока.СостояниеПолученияИнформации = Перечисления.СостоянияПодтвержденияМДЛП.Подтверждено;
			КонецЕсли;
		Иначе
			НоваяСтрока = Документ.ТранспортныеУпаковки.Добавить();
			НоваяСтрока.НомерУпаковки = НомерУпаковки;
		КонецЕсли;
		НоваяСтрока.НомерРодительскойУпаковки = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ЭлементСостава, "parent_sscc");
	КонецЦикла;
	
	ИнтеграцияМДЛППереопределяемый.ПриЗагрузкеДанныхОСоставеУпаковки(Документ);
	
	ИнтеграцияМДЛП.ЗаписатьДокумент(Документ);
	Документ.Разблокировать();
	
КонецПроцедуры

Процедура ЗагрузитьИнформациюОКиЗ(ДанныеДокумента, ДокументСсылка)
	
	Документ = ДокументСсылка.ПолучитьОбъект();
	Документ.Заблокировать();
	
	Строка = Документ.НомераУпаковок.Найти(ДанныеДокумента.sgtin, "НомерКиЗ");
	Если Строка <> Неопределено Тогда
		Строка.СостояниеПолученияИнформации = Перечисления.СостоянияПодтвержденияМДЛП.Подтверждено;
		Если ДанныеДокумента.ЕстьИнформация Тогда
			ДанныеУпаковки = ДанныеДокумента.ДанныеУпаковки;
			Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДанныеУпаковки, "info_sgtin") Тогда
				ДанныеУпаковки = ДанныеУпаковки.info_sgtin;
			КонецЕсли;
			
			Строка.Статус = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДанныеУпаковки, "status");
			
			ПараметрыЗаполнения = ИнтеграцияМДЛПКлиентСервер.ПараметрыЗаполненияТабличнойЧасти();
			ПараметрыЗаполнения.ПересчитатьКоличествоУпаковок = Истина;
			
			Отбор = Новый Структура;
			Отбор.Вставить("GTIN"      , ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДанныеУпаковки, "GTIN"));
			Отбор.Вставить("НомерСерии", ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДанныеУпаковки, "series_number"));
			Отбор.Вставить("ГоденДо"   , СтроковыеФункцииКлиентСервер.СтрокаВДату(ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДанныеУпаковки, "expiration_date")));
			НайденныеСтроки = Документ.Товары.НайтиСтроки(Отбор);
			Если НайденныеСтроки.Количество() > 0 Тогда
				
				СтрокаТовараСтарая = Документ.Товары.Найти(Строка.ИдентификаторСтроки, "ИдентификаторСтроки");
				СтрокаТовараСтарая.Количество = СтрокаТовараСтарая.Количество - 1;
				Если СтрокаТовараСтарая.Количество = 0 Тогда
					Документ.Товары.Удалить(СтрокаТовараСтарая);
				Иначе
					ИнтеграцияМДЛППереопределяемый.ПриИзмененииКоличества(Документ, СтрокаТовараСтарая, ПараметрыЗаполнения);
				КонецЕсли;
				
				НоваяСтрокаТовара = НайденныеСтроки[0];
				Строка.ИдентификаторСтроки = НоваяСтрокаТовара.ИдентификаторСтроки;
				НоваяСтрокаТовара.Количество = НоваяСтрокаТовара.Количество + 1;
				ИнтеграцияМДЛППереопределяемый.ПриИзмененииКоличества(Документ, НоваяСтрокаТовара, ПараметрыЗаполнения);
				
			Иначе
				
				ОтборПоИдентификатору = Новый Структура("ИдентификаторСтроки", Строка.ИдентификаторСтроки);
				НайденныеСтроки = Документ.НомераУпаковок.НайтиСтроки(ОтборПоИдентификатору);
				Если НайденныеСтроки.Количество() > 1 Тогда
					СтрокаТовараСтарая = Документ.Товары.Найти(Строка.ИдентификаторСтроки, "ИдентификаторСтроки");
					СтрокаТовараСтарая.Количество = СтрокаТовараСтарая.Количество - 1;
					ИнтеграцияМДЛППереопределяемый.ПриИзмененииКоличества(Документ, СтрокаТовараСтарая, ПараметрыЗаполнения);
					
					НоваяСтрокаТовара = Документ.Товары.Вставить(СтрокаТовараСтарая.НомерСтроки);
					ЗаполнитьЗначенияСвойств(НоваяСтрокаТовара, СтрокаТовараСтарая,, "Серия, Количество, КоличествоУпаковок, ИдентификаторСтроки");
				Иначе
					НоваяСтрокаТовара = Документ.Товары.Найти(Строка.ИдентификаторСтроки, "ИдентификаторСтроки");
				КонецЕсли;
				
				ЗаполнитьЗначенияСвойств(НоваяСтрокаТовара, Отбор);
				НоваяСтрокаТовара.КодТНВЭД = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДанныеУпаковки, "tnved_code");
				НоваяСтрокаТовара.Количество = 1;
				НоваяСтрокаТовара.ИдентификаторСтроки = Строка(Новый УникальныйИдентификатор);
				Строка.ИдентификаторСтроки = НоваяСтрокаТовара.ИдентификаторСтроки;
				
				ИнтеграцияМДЛППереопределяемый.ПриИзмененииКоличества(Документ, НоваяСтрокаТовара, ПараметрыЗаполнения);
				
			КонецЕсли;
			
		Иначе
			Строка.Статус = ДанныеДокумента.Статус;
		КонецЕсли;
	КонецЕсли;
	
	ИнтеграцияМДЛП.ЗаписатьДокумент(Документ);
	Документ.Разблокировать();
	
КонецПроцедуры

#Область Проведение

Функция ТекстЗапросаСостоянияУведомления(ИмяВременнойТаблицы = "") Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	НомераУпаковок.НомерСтроки                         КАК НомерСтроки,
	|	НомераУпаковок.Ссылка.ИдентификаторОрганизации     КАК ИдентификаторОрганизации,
	|	""""                                               КАК ИдентификаторПолучателя,
	|	СоставТретичнойУпаковки.НомерКиЗ                   КАК НомерУпаковки,
	|	НомераУпаковок.СостояниеПодтверждения              КАК СостояниеПодтверждения,
	|	ЛОЖЬ                                               КАК ГрупповаяУпаковка,
	|	СоставТретичнойУпаковки.НомерРодительскойУпаковки  КАК КодТретичнойУпаковки
	|//ПОМЕСТИТЬ
	|ИЗ
	|	Документ.УведомлениеОПриемкеМДЛП.ТранспортныеУпаковки КАК НомераУпаковок
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.УдалитьЗапросСоставаУпаковкиМДЛП.НомераУпаковок КАК СоставТретичнойУпаковки
	|	ПО
	|		СоставТретичнойУпаковки.Ссылка = НомераУпаковок.СоставУпаковки
	|ГДЕ
	|	СоставТретичнойУпаковки.Ссылка = &Ссылка
	|	И НомераУпаковок.Ссылка.Проведен
	|	И НЕ НомераУпаковок.СостояниеПодтверждения В (&ИсключаемыеСостояния)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НомераУпаковок.НомерСтроки                         КАК НомерСтроки,
	|	НомераУпаковок.Ссылка.ИдентификаторОрганизации     КАК ИдентификаторОрганизации,
	|	""""                                               КАК ИдентификаторПолучателя,
	|	СоставТретичнойУпаковки.НомерУпаковки              КАК НомерУпаковки,
	|	НомераУпаковок.СостояниеПодтверждения              КАК СостояниеПодтверждения,
	|	ИСТИНА                                             КАК ГрупповаяУпаковка,
	|	СоставТретичнойУпаковки.НомерРодительскойУпаковки  КАК КодТретичнойУпаковки
	|ИЗ
	|	Документ.УведомлениеОПриемкеМДЛП.ТранспортныеУпаковки КАК НомераУпаковок
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.УдалитьЗапросСоставаУпаковкиМДЛП.ТранспортныеУпаковки КАК СоставТретичнойУпаковки
	|	ПО
	|		СоставТретичнойУпаковки.Ссылка = НомераУпаковок.СоставУпаковки
	|ГДЕ
	|	СоставТретичнойУпаковки.Ссылка = &Ссылка
	|	И НомераУпаковок.Ссылка.Проведен
	|	И НЕ НомераУпаковок.СостояниеПодтверждения В (&ИсключаемыеСостояния)
	|";
	
	Если Не ПустаяСтрока(ИмяВременнойТаблицы) Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//ПОМЕСТИТЬ", "ПОМЕСТИТЬ " + ИмяВременнойТаблицы);
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
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

#Область ОбновлениеИнформационнойБазы

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ОбновлениеИнформационнойБазыМДЛП.ЗарегистрироватьДокументыДляЗаполненияМестДеятельности(ПустаяСсылка().Метаданные().ПолноеИмя(), Параметры);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ОбновлениеИнформационнойБазыМДЛП.ЗаполнитьМестаДеятельностиВДокументах(ПустаяСсылка().Метаданные().ПолноеИмя(), Параметры);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
