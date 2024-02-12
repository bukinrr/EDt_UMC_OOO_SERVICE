#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Добавить запись в протокол обмена.
//
// Параметры:
//  ТекстСообщенияXML - Строка - Текст сообщения XML.
//  Реквизиты - Структура - Значения реквизитов сообщения.
//  ПроверятьХешБезСсылки - Булево - Признак проверки хеша без ссылки.
// 
// Возвращаемое значение:
//  Структура - Структура со свойствами:
//   * НовоеСообщение - Булево - Это новое сообщение.
//   * Ссылка - СправочникСсылка.ГИСМПрисоединенныеФайлы - Ссылка на присоединенный файл.
//
Функция ДобавитьЗаписьВПротоколОбмена(ТекстСообщения, Реквизиты) Экспорт
	
	СообщениеОснование = Справочники.МДЛППрисоединенныеФайлы.ПустаяСсылка();
	Если Реквизиты.Свойство("СообщениеОснование") И ЗначениеЗаполнено(Реквизиты.СообщениеОснование) Тогда
		СообщениеОснование = Реквизиты.СообщениеОснование;
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	Сообщение.Ссылка  КАК Ссылка,
	|	Сообщение.Размер  КАК Размер
	|ИЗ
	|	Справочник.МДЛППрисоединенныеФайлы КАК Сообщение
	|ГДЕ
	|	&ПоискПоДокументу
	|	И Сообщение.ВладелецФайла = &ВладелецФайла
	|	И Сообщение.ХешСумма = &ХешСумма
	|	И Сообщение.СообщениеОснование = &СообщениеОснование
	|	И Сообщение.ИдентификаторЗапроса = """"
	|	И НЕ (Сообщение.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыСообщенийМДЛП.Исходящее)
	|		И Сообщение.СтатусОбработки = ЗНАЧЕНИЕ(Перечисление.СтатусыОбработкиСообщенийМДЛП.Ошибка))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	Сообщение.Ссылка  КАК Ссылка,
	|	Сообщение.Размер  КАК Размер
	|ИЗ
	|	Справочник.МДЛППрисоединенныеФайлы КАК Сообщение
	|ГДЕ
	|	НЕ &ПоискПоДокументу
	|	И ТИПЗНАЧЕНИЯ(Сообщение.ВладелецФайла) = &ТипДокумента
	|	И Сообщение.ХешСумма = &ХешСумма
	|	И Сообщение.СообщениеОснование = &СообщениеОснование
	|");
	
	Запрос.УстановитьПараметр("ПоискПоДокументу"  , ОбщегоНазначения.СсылкаСуществует(Реквизиты.Документ));
	ХешСумма = ИнтеграцияМДЛП.ХешСуммаСтрокой(ТекстСообщения);
	Запрос.УстановитьПараметр("ХешСумма"          , ХешСумма);
	Запрос.УстановитьПараметр("ВладелецФайла"     , Реквизиты.Документ);
	Запрос.УстановитьПараметр("ТипДокумента"      , ТипЗнч(Реквизиты.Документ));
	Запрос.УстановитьПараметр("СообщениеОснование", СообщениеОснование);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		
		НовоеСообщение = Ложь;
		
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Сообщение = Выборка.Ссылка;
		Размер    = Выборка.Размер;
		
	Иначе
		
		НовоеСообщение = Истина;
		
		ДвоичныеДанные = ПолучитьДвоичныеДанныеИзСтроки(ТекстСообщения);
		АдресФайлаВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
		
		ПараметрыФайла = РаботаСФайлами.ПараметрыДобавленияФайла();
		ПараметрыФайла.Автор              = Пользователи.АвторизованныйПользователь();
		ПараметрыФайла.ВладелецФайлов     = Реквизиты.Документ;
		ПараметрыФайла.ИмяБезРасширения   = Строка(Новый УникальныйИдентификатор);
		ПараметрыФайла.РасширениеБезТочки = "xml";
		
		Сообщение = РаботаСФайлами.ДобавитьФайл(
			ПараметрыФайла,
			АдресФайлаВоВременномХранилище,
			,
			,
			Справочники.МДЛППрисоединенныеФайлы.ПолучитьСсылку());
		
		СообщениеОбъект = Сообщение.ПолучитьОбъект();
		СообщениеОбъект.ХешСумма = ХешСумма;
		ЗаполнитьЗначенияСвойств(СообщениеОбъект, Реквизиты);
		Если СообщениеОбъект.ТипСообщения = Перечисления.ТипыСообщенийМДЛП.Исходящее Тогда
			СообщениеОбъект.Версия = ПоследняяВерсия(СообщениеОбъект.ВладелецФайла, СообщениеОбъект.Операция) + 1;
		КонецЕсли;
		
		Размер = СообщениеОбъект.Размер;
		
		СообщениеОбъект.Записать();
		
	КонецЕсли;
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("НовоеСообщение", НовоеСообщение);
	ВозвращаемоеЗначение.Вставить("Ссылка"        , Сообщение);
	ВозвращаемоеЗначение.Вставить("ХешСумма"      , ХешСумма);
	ВозвращаемоеЗначение.Вставить("Размер"        , Размер);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ОбновитьЗаписьПротоколаОбмена(Запись, Реквизиты) Экспорт
	
	УстановитьПривилегированныйРежим(ИСтина);
	Объект = Запись.ПолучитьОбъект();
	ЗаполнитьЗначенияСвойств(Объект, Реквизиты);
	Объект.Записать();
	
КонецФункции

Функция СообщениеКПередаче(Сообщение, ДальнейшееДействие, ПричинаОтзыва = Неопределено) Экспорт
	
	Если ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюМДЛП.ОтзовитеОперацию Тогда
		Возврат УведомлениеОбОтзывеОперации(Сообщение, ПричинаОтзыва);
	Иначе
		ВызватьИсключение ИнтеграцияМДЛП.ТекстОшибкиОбработкиДальнейшегоДействия(Сообщение, ДальнейшееДействие);
	КонецЕсли;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	Возврат РаботаСФайлами.РеквизитыРедактируемыеВГрупповойОбработке();
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПоследняяВерсия(ВладелецФайла, Операция)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ЕСТЬNULL(КОЛИЧЕСТВО(Сообщения.Ссылка), 0) КАК ПоследняяВерсия
	|ИЗ
	|	Справочник.МДЛППрисоединенныеФайлы КАК Сообщения
	|ГДЕ
	|	Сообщения.ВладелецФайла = &ВладелецФайла
	|	И Сообщения.СообщениеОснование = ЗНАЧЕНИЕ(Справочник.МДЛППрисоединенныеФайлы.ПустаяСсылка)
	|	И Сообщения.Операция = &Операция
	|	И Сообщения.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыСообщенийМДЛП.Исходящее)
	|");
	Запрос.УстановитьПараметр("ВладелецФайла", ВладелецФайла);
	Запрос.УстановитьПараметр("Операция", Операция);
	
	ПоследняяВерсия = 0;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ПоследняяВерсия = Выборка.ПоследняяВерсия;
	КонецЕсли;
	
	Возврат ПоследняяВерсия;
	
КонецФункции

Функция УведомлениеОбОтзывеОперации(ОтменяемоеСообщение, ПричинаОтзыва)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Сообщения = Новый Массив;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Шапка.ВладелецФайла.Организация.ВерсияСхемОбмена  КАК ВерсияСхемОбмена,
	|	Шапка.Ссылка                          КАК Ссылка,
	|	Шапка.ВладелецФайла                   КАК Документ,
	|	Шапка.ВладелецФайла.Основание         КАК Основание,
	|	Шапка.Операция                        КАК Операция,
	|	Шапка.ИдентификаторКвитанции          КАК ИдентификаторКвитанции,
	|	Шапка.ИдентификаторСубъектаОбращения  КАК ИдентификаторСубъектаОбращения
	|ИЗ
	|	Справочник.МДЛППрисоединенныеФайлы КАК Шапка
	|ГДЕ
	|	Шапка.Ссылка = &Ссылка
	|");
	Запрос.УстановитьПараметр("Ссылка", ОтменяемоеСообщение);
	
	СообщениеКПередаче = ИнтеграцияМДЛП.СтруктураСообщенияКПередаче();
	
	Шапка  = Запрос.Выполнить().Выбрать();
	Если Не Шапка.Следующий() Тогда
		
		ИнтеграцияМДЛПКлиентСервер.ДобавитьТекстОшибки(СообщениеКПередаче, НСтр("ru = 'Нет данных для выгрузки.'"));
		Сообщения.Добавить(СообщениеКПередаче);
		Возврат Сообщения;
		
	КонецЕсли;
	
	Если Не Перечисления.ОперацииОбменаМДЛП.ВозможнаОтменаОперации(Шапка.Операция, Шапка.ВерсияСхемОбмена) Тогда
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не поддерживается отмена операции %1.'"), Шапка.Операция);
		ИнтеграцияМДЛПКлиентСервер.ДобавитьТекстОшибки(СообщениеКПередаче, ТекстОшибки);
		Сообщения.Добавить(СообщениеКПередаче);
		Возврат Сообщения;
	КонецЕсли;
	
	Попытка
		ДокументОбъект = Шапка.Документ.ПолучитьОбъект();
		ДокументОбъект.СостояниеПодтверждения = Перечисления.СостоянияПодтвержденияМДЛП.Отозвать;
		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
	Исключение
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка резерва товара для отмены операции %1.
						|%2'"),
			Шапка.Операция,
			ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ИнтеграцияМДЛПКлиентСервер.ДобавитьТекстОшибки(СообщениеКПередаче, ТекстОшибки);
		Сообщения.Добавить(СообщениеКПередаче);
		Возврат Сообщения;
	КонецПопытки;
	
	ПространствоИмен = ИнтеграцияМДЛП.ПространствоИмен(Шапка.ВерсияСхемОбмена);
	
	УстановленныеДаты = Новый Соответствие;
	
	ИмяТипа   = "documents";
	ИмяПакета = "recall";
	
	ПередачаДанных = ИнтеграцияМДЛП.ОбъектXDTOПоИмениСвойства(Неопределено, ИмяТипа, ПространствоИмен);
	ИнтеграцияМДЛП.УстановитьВерсиюСхемОбменаПакета(ПередачаДанных);
	
	Уведомление = ИнтеграцияМДЛП.ОбъектXDTOПоИмениСвойства(ПередачаДанных, ИмяПакета);
	ПередачаДанных[ИмяПакета] = Уведомление;
	
	Уведомление.action_id = Уведомление.action_id;
	
	ИнтеграцияМДЛП.ЗаполнитьСвойствоXDTO(Уведомление, "subject_id", Шапка.ИдентификаторСубъектаОбращения, СообщениеКПередаче);
	ИнтеграцияМДЛП.УстановитьДатуСЧасовымПоясом(Уведомление, "operation_date", ТекущаяДатаСеанса(), УстановленныеДаты, СообщениеКПередаче);
	
	ИнтеграцияМДЛП.ЗаполнитьСвойствоXDTO(Уведомление, "session_ui", Шапка.ИдентификаторКвитанции, СообщениеКПередаче);
	ИнтеграцияМДЛП.ЗаполнитьСвойствоXDTO(Уведомление, "operation_id", Шапка.ИдентификаторКвитанции, СообщениеКПередаче);
	
	ОтменяемаяОперация = Перечисления.ОперацииОбменаМДЛП.КодОперации(Шапка.Операция);
	ИнтеграцияМДЛП.ЗаполнитьСвойствоXDTO(Уведомление, "recall_action_id", ОтменяемаяОперация, СообщениеКПередаче);
	
	ИнтеграцияМДЛП.ЗаполнитьСвойствоXDTO(Уведомление, "reason", ПричинаОтзыва, СообщениеКПередаче);
	
	ИнтеграцияМДЛП.ПроверитьОбъектXDTO(ПередачаДанных, СообщениеКПередаче);
	
	ТекстСообщения = ИнтеграцияМДЛП.ОбъектXDTOВXML(ПередачаДанных, ИмяТипа, ПространствоИмен);
	ТекстСообщения = ИнтеграцияМДЛП.ПреобразоватьВременныеДаты(УстановленныеДаты, ТекстСообщения);
	
	СообщениеКПередаче.ТекстСообщения = ТекстСообщения;
	СообщениеКПередаче.ИдентификаторСубъектаОбращения = Шапка.ИдентификаторСубъектаОбращения;
	СообщениеКПередаче.Операция           = Перечисления.ОперацииОбменаМДЛП.ПередачаДанных_ОтказОтРанееСовершеннойОперации;
	СообщениеКПередаче.Документ           = Шапка.Документ;
	СообщениеКПередаче.Основание          = Шапка.Основание;
	СообщениеКПередаче.ТипСообщения       = Перечисления.ТипыСообщенийМДЛП.Исходящее;
	СообщениеКПередаче.СообщениеОснование = Шапка.Ссылка;
	СообщениеКПередаче.ОбновитьСостояниеПодтверждения = Истина;
	
	Сообщения.Добавить(СообщениеКПередаче);
	Возврат Сообщения;
	
КонецФункции

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Сообщение.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.МДЛППрисоединенныеФайлы КАК Сообщение
	|ГДЕ
	|	Сообщение.СтатусИзвлеченияТекста = ЗНАЧЕНИЕ(Перечисление.СтатусыИзвлеченияТекстаФайлов.Извлечен)
	|	И Сообщение.ВладелецФайла <> &ПустойВладелецФайла
	|");
	
	Запрос.УстановитьПараметр("ПустойВладелецФайла", Метаданные.ОпределяемыеТипы.ДокументИнформированияМДЛП.Тип.ПривестиЗначение());
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	СтатусИзвлечен = Перечисления.СтатусыИзвлеченияТекстаФайлов.Извлечен;
	
	ПолноеИмяОбъекта = "Справочник.МДЛППрисоединенныеФайлы";
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта);
	//+бит
	// В УМЦ стоит заглушка, которая возвращает пустой запрос поэтому этот участок кода не работает
	//Пока Выборка.Следующий() Цикл
	//	
	//	НачатьТранзакцию();
	//	Попытка
	//		Блокировка = Новый БлокировкаДанных;
	//		ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
	//		ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
	//		Блокировка.Заблокировать();
	//	Исключение
	//		ОтменитьТранзакцию();
	//		ТекстСообщения = НСтр("ru = 'Не удалось заблокировать объект: %Объект% по причине: %Причина%'");
	//		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Объект%", Выборка.Ссылка);
	//		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	//		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
	//								УровеньЖурналаРегистрации.Предупреждение,
	//								Выборка.Ссылка.Метаданные(),
	//								Выборка.Ссылка,
	//								ТекстСообщения);
	//		Продолжить;
	//	КонецПопытки;
	//	
	//	Объект = Выборка.Ссылка.ПолучитьОбъект();
	//	Если Объект = Неопределено
	//	 Или Не ЗначениеЗаполнено(Объект.ВладелецФайла)
	//	 Или Объект.СтатусИзвлеченияТекста <> СтатусИзвлечен И Не ЗначениеЗаполнено(Объект.ТекстХранилище.Получить()) Тогда
	//		ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
	//		ЗафиксироватьТранзакцию();
	//		Продолжить;
	//	КонецЕсли;
	//	
	//	Попытка
	//		
	//		РаботаСФайламиСлужебный.ОбновитьТекстВФайле(Выборка.Ссылка, "");
	//		
	//		ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
	//		
	//		ЗафиксироватьТранзакцию();
	//		
	//	Исключение
	//		ОтменитьТранзакцию();
	//		ТекстСообщения = НСтр("ru = 'Не удалось обработать: %Объект% по причине: %Причина%'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	//		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Объект%", Выборка.Ссылка);
	//		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	//		ЗаписьЖурналаРегистрации(
	//			ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
	//			УровеньЖурналаРегистрации.Предупреждение,
	//			Выборка.Ссылка.Метаданные(),
	//			Выборка.Ссылка,
	//			ТекстСообщения);
	//	КонецПопытки;
	//	
	//КонецЦикла;
	//-бит
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
