#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает текст запроса для получения количества документов для отработки
//
// Параметры:
//  МетаданныеДокумента - Метаданные
//
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ТекстЗапросаОтработайте(МетаданныеДокумента) Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Статусы.Документ) КАК КоличествоДокументов
	|ИЗ
	|	РегистрСведений.СтатусыИнформированияМДЛП КАК Статусы
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		#Уведомления КАК Уведомления
	|	ПО
	|		Статусы.Документ = Уведомления.Ссылка
	|ГДЕ
	|	НЕ Уведомления.ПометкаУдаления
	|	И Статусы.ДальнейшееДействие1 В(&ВсеТребующиеДействия)
	|	И (&Организация = НЕОПРЕДЕЛЕНО ИЛИ Уведомления.Организация = &Организация)
	|	И (&МестоДеятельности = НЕОПРЕДЕЛЕНО ИЛИ Уведомления.МестоДеятельности = &МестоДеятельности"
	//+БИТ
	//+ ?(ОбщегоНазначения.ЕстьРеквизитОбъекта("МестоДеятельностиПолучатель", МетаданныеДокумента), " ИЛИ Уведомления.МестоДеятельностиПолучатель = &МестоДеятельности", "")
	+ ?(ОбщегоНазначения.ЕстьРеквизитОбъектаОбратныйПорядок("МестоДеятельностиПолучатель", МетаданныеДокумента), " ИЛИ Уведомления.МестоДеятельностиПолучатель = &МестоДеятельности", "")
	//-БИТ
	+ ")
	|	И (&Ответственный = НЕОПРЕДЕЛЕНО ИЛИ Уведомления.Ответственный = &Ответственный)
	|";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#Уведомления", МетаданныеДокумента.ПолноеИмя());
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Возвращает текст запроса для получения количества документов, находящихся в состоянии ожидания
//
// Параметры:
//  МетаданныеДокумента - Метаданные
//
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ТекстЗапросаОжидайте(МетаданныеДокумента) Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Статусы.Документ) КАК КоличествоДокументов
	|ИЗ
	|	РегистрСведений.СтатусыИнформированияМДЛП КАК Статусы
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		#Уведомления КАК Уведомления
	|	ПО
	|		Статусы.Документ = Уведомления.Ссылка
	|ГДЕ
	|	НЕ Уведомления.ПометкаУдаления
	|	И Статусы.ДальнейшееДействие1 В(&ВсеТребующиеОжидания)
	|	И (&Организация = НЕОПРЕДЕЛЕНО ИЛИ Уведомления.Организация = &Организация)
	|	И (&МестоДеятельности = НЕОПРЕДЕЛЕНО ИЛИ Уведомления.МестоДеятельности = &МестоДеятельности"
	//+БИТ
	//+ ?(ОбщегоНазначения.ЕстьРеквизитОбъекта("МестоДеятельностиПолучатель", МетаданныеДокумента), " ИЛИ Уведомления.МестоДеятельностиПолучатель = &МестоДеятельности", "")
	+ ?(ОбщегоНазначения.ЕстьРеквизитОбъектаОбратныйПорядок("МестоДеятельностиПолучатель", МетаданныеДокумента), " ИЛИ Уведомления.МестоДеятельностиПолучатель = &МестоДеятельности", "")
	//-БИТ
	+ ")
	|	И (&Ответственный = НЕОПРЕДЕЛЕНО ИЛИ Уведомления.Ответственный = &Ответственный)
	|";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#Уведомления", МетаданныеДокумента.ПолноеИмя());
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаДинамическогоСпискаФормДокументов(МетаданныеДокумента) Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	Уведомления.Ссылка                    КАК Ссылка,
	|	Уведомления.ПометкаУдаления           КАК ПометкаУдаления,
	|	Уведомления.Номер                     КАК Номер,
	|	Уведомления.Дата                      КАК Дата,
	|	Уведомления.Проведен                  КАК Проведен,
	|	Уведомления.Основание                 КАК Основание,
	|	Уведомления.Организация               КАК Организация,
	|	Уведомления.МестоДеятельности         КАК МестоДеятельности,
	|	Уведомления.Ответственный             КАК Ответственный,
	|	Уведомления.Комментарий               КАК Комментарий,
	|	ЕСТЬNULL(Статусы.ДальнейшееДействие1, ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюМДЛП.НеТребуется)) КАК ДальнейшееДействие1,
	|	ЕСТЬNULL(Статусы.ДальнейшееДействие2, ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюМДЛП.НеТребуется)) КАК ДальнейшееДействие2,
	|	ЕСТЬNULL(Статусы.ДальнейшееДействие3, ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюМДЛП.НеТребуется)) КАК ДальнейшееДействие3,
	|	ЕСТЬNULL(Статусы.ДальнейшееДействие4, ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюМДЛП.НеТребуется)) КАК ДальнейшееДействие4,
	|	ЕСТЬNULL(Статусы.Статус, ЗНАЧЕНИЕ(Перечисление.СтатусыИнформированияМДЛП.Отсутствует)) КАК Статус
	|ИЗ
	|	#Уведомления КАК Уведомления
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.СтатусыИнформированияМДЛП КАК Статусы
	|	ПО
	|		Статусы.Документ = Уведомления.Ссылка
	|";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#Уведомления", МетаданныеДокумента.ПолноеИмя());
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаДинамическогоСпискаКОформлениюФормДокументов() Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	Таблица.Основание                       КАК Основание,
	|	Таблица.Ответственный                   КАК Ответственный,
	|	Таблица.Дата                            КАК Дата,
	|	Таблица.Номер                           КАК Номер,
	|	СвязиССубъектамиМДЛП.Организация        КАК Организация,
	|	СвязиССубъектамиМДЛП.МестоДеятельности  КАК МестоДеятельности,
	|	Таблица.СтатусОформления                КАК СтатусОформления,
	|	1                                       КАК НестандартнаяКартинка
	|ИЗ
	|	РегистрСведений.СтатусыОформленияДокументовМДЛП КАК Таблица
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.СтатусыОформленияДокументовМДЛП КАК ДругиеУведомленияПоОснованию
	|	ПО
	|		ДругиеУведомленияПоОснованию.Основание = Таблица.Основание
	|		И ДругиеУведомленияПоОснованию.Документ <> &ДокументИнформирования
	|		И ДругиеУведомленияПоОснованию.СтатусОформления = ЗНАЧЕНИЕ(Перечисление.СтатусыОформленияДокументовМДЛП.Оформлено)
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.СубъектыОбращенияМДЛП КАК СвязиССубъектамиМДЛП
	|	ПО
	|		СвязиССубъектамиМДЛП.ОрганизацияКонтрагент = Таблица.Организация
	|		И СвязиССубъектамиМДЛП.ОбъектМестаДеятельности = Таблица.МестоДеятельности
	|{ГДЕ
	|	СвязиССубъектамиМДЛП.Организация.* КАК Организация,
	|	СвязиССубъектамиМДЛП.МестоДеятельности.* КАК МестоДеятельности
	|}
	|ГДЕ
	|	Таблица.Документ = &ДокументИнформирования
	|	И Таблица.СтатусОформления В (
	|		ЗНАЧЕНИЕ(Перечисление.СтатусыОформленияДокументовМДЛП.НеОформлено),
	|		ЗНАЧЕНИЕ(Перечисление.СтатусыОформленияДокументовМДЛП.ОформленоЧастично))
	|	И ДругиеУведомленияПоОснованию.Основание ЕСТЬ NULL
	|";
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#КонецЕсли