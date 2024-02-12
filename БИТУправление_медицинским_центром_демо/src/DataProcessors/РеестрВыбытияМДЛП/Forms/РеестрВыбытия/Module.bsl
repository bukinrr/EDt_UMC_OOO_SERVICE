
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Организация       = Параметры.Организация;
	МестоДеятельности = Параметры.МестоДеятельности;
	
	Для Каждого КлючИЗначение Из ДальнейшиеДействия() Цикл
		Элементы.ДальнейшееДействиеОтбор.СписокВыбора.Добавить(КлючИЗначение.Ключ, КлючИЗначение.Значение.Представление);
	КонецЦикла;
	
	СобытияФормМДЛППереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Если ЗначениеЗаполнено(Организация) Тогда
		Настройки.Удалить("Организация");
		Настройки.Удалить("МестоДеятельности");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОбработатьИзменениеОтбораДальнейшегоДействия();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СобытияФормМДЛПКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерезаполнитьРеестрВыбытия(Команда)
	
	ЗапуститьЗаполнениеРеестраВыбытия();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометку(Команда)
	
	ИзменитьПометку(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьПометку(Команда)
	
	ИзменитьПометку(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПолучениеИнформацииОбУпаковках(Команда)
	
	ВыполнитьПолучениеИнформацииОбУпаковкахРеестраВыбытия();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОтменуПолученияИнформацииОбУпаковках(Команда)
	
	ОтменитьПолучениеИнформациюОбУпаковках();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьВыбытие(Команда)
	
	ВыполнитьВыбытиеРеестраВыбытия();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормМДЛПКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ДальнейшееДействиеОтборПриИзменении(Элемент)
	
	ОбработатьИзменениеОтбораДальнейшегоДействия();
	
КонецПроцедуры

&НаКлиенте
Процедура РеестрВыбытияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура РеестрВыбытияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.РеестрВыбытияДокументРезерва Тогда
		ТекущиеДанные = Элементы.РеестрВыбытия.ТекущиеДанные;
		Если ЗначениеЗаполнено(ТекущиеДанные.ДокументРезерва) Тогда
			СтандартнаяОбработка = Ложь;
			ПоказатьЗначение(, ТекущиеДанные.ДокументРезерва);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовФормы

#Область СлужебныеПроцедурыИФункции

#Область ЗаполнениеРеестраВыбытия

&НаКлиенте
Процедура ЗапуститьЗаполнениеРеестраВыбытия()
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ЗапуститьЗаполнениеРеестраВыбытияНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗапуститьЗаполнениеРеестраВыбытияНаСервере()
	
	ЗаполнитьТаблицуРеестраВыбытияНаСервере();
	УстановитьОтборДальнейшегоДействия();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуРеестраВыбытияНаСервере()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	РеестрВыбытия.НомерУпаковки      КАК НомерУпаковки,
	|	РеестрВыбытия.КлючУпаковки       КАК КлючУпаковки,
	|	РеестрВыбытия.МестоДеятельности  КАК МестоДеятельности,
	|	РеестрВыбытия.ДокументРезерва    КАК ДокументРезерва,
	|	РеестрВыбытия.СтатусВыбытия      КАК СтатусВыбытия,
	|	РеестрВыбытия.ДатаСтатуса        КАК ДатаСтатуса,
	|	РеестрВыбытия.ДоляУпаковки       КАК ДоляУпаковки,
	|	ВЫБОР
	
	|		КОГДА РеестрВыбытия.СтатусВыбытия В (ЗНАЧЕНИЕ(Перечисление.СтатусыВыбытияУпаковокМДЛП.ПодтвержденВыводИзОборота), ЗНАЧЕНИЕ(Перечисление.СтатусыВыбытияУпаковокМДЛП.ПодтвержденСОшибкойВыводИзОборота))
	|			ТОГДА &ВыполнитьВыбытие
	
	|		КОГДА РеестрВыбытия.СтатусВыбытия = ЗНАЧЕНИЕ(Перечисление.СтатусыВыбытияУпаковокМДЛП.ОжидаетВыводаИзОборота)
	|			ТОГДА &ПолучитьКвитанциюОФиксацииВывода
	
	|		КОГДА ТекущиеСтатусы.Статус ЕСТЬ NULL
	|			ТОГДА &ВыполнитьПоступление
	
	|		КОГДА НЕ ТекущиеСтатусы.Статус В (&СтатусыЗафиксированногоСостоянияУпаковок)
	|			ТОГДА &ПолучитьКвитанциюОФиксацииОборота
	
	|		КОГДА ТекущиеСтатусы.МестоДеятельности <> РеестрВыбытия.МестоДеятельности И ТекущиеСтатусы.Статус В (&СтатусыПозволяющиеПеремещениеУпаковки)
	|			ТОГДА &ВыполнитьПеремещение
	
	|		КОГДА ТекущиеСтатусы.Статус В (&СтатусыПозволяющиеИзъятиеУпаковки)
	|			ТОГДА &ВыполнитьИзъятие
	
	|		ИНАЧЕ &ОжидайтеИзмененияСостояния
	
	|	КОНЕЦ                            КАК ДальнейшееДействие
	|ИЗ
	|	РегистрСведений.РеестрВыбытияУпаковокМДЛП КАК РеестрВыбытия
	|		ЛЕВОЕ СОЕДИНЕНИЕ
	|			РегистрСведений.УпаковкиМДЛП КАК ТекущиеСтатусы
	|		ПО
	|			РеестрВыбытия.СтатусВыбытия В (ЗНАЧЕНИЕ(Перечисление.СтатусыВыбытияУпаковокМДЛП.ПринятВыводИзОборота))
	|			И ТекущиеСтатусы.МестоДеятельности.Организация = &Организация
	|			И ТекущиеСтатусы.НомерУпаковки = РеестрВыбытия.НомерУпаковки
	|			И ТекущиеСтатусы.КлючУпаковки = РеестрВыбытия.КлючУпаковки
	|ГДЕ
	|	РеестрВыбытия.МестоДеятельности.Организация = &Организация
	|");
	
	Запрос.УстановитьПараметр("Организация"                             , Организация);
	Запрос.УстановитьПараметр("СтатусыЗафиксированногоСостоянияУпаковок", СтатусыЗафиксированногоСостоянияУпаковок());
	Запрос.УстановитьПараметр("СтатусыПозволяющиеПеремещениеУпаковки"   , СтатусыПозволяющиеПеремещениеУпаковки());
	Запрос.УстановитьПараметр("СтатусыПозволяющиеИзъятиеУпаковки"       , СтатусыПозволяющиеИзъятиеУпаковки());
	Запрос.УстановитьПараметр("СтатусыПозволяющиеВыбытиеУпаковки"       , СтатусыПозволяющиеВыбытиеУпаковки());
	
	ДальнейшиеДействия = ДальнейшиеДействия();
	
	Для Каждого ДальнейшееДействие Из ДальнейшиеДействия Цикл
		Запрос.УстановитьПараметр(ДальнейшееДействие.Ключ, ДальнейшееДействие.Ключ);
	КонецЦикла;
	
	СхемаЗапроса = Новый СхемаЗапроса;
	СхемаЗапроса.УстановитьТекстЗапроса(Запрос.Текст);
	Отбор = СхемаЗапроса.ПакетЗапросов[0].Операторы[0].Отбор;
	Если ЗначениеЗаполнено(МестоДеятельности) Тогда
		Отбор.Добавить("РеестрВыбытия.МестоДеятельности = &МестоДеятельности");
		Запрос.УстановитьПараметр("МестоДеятельности", МестоДеятельности);
	КонецЕсли;
	Если ЗначениеЗаполнено(Период) Тогда
		Отбор.Добавить("РеестрВыбытия.ДатаСтатуса МЕЖДУ &ДатаНачала И &ДатаОкончания");
		Запрос.УстановитьПараметр("ДатаНачала"   , Период.ДатаНачала);
		Запрос.УстановитьПараметр("ДатаОкончания", Период.ДатаОкончания);
	КонецЕсли;
	Запрос.Текст = СхемаЗапроса.ПолучитьТекстЗапроса();
	
	ТаблицаРеестраВыбытия = Запрос.Выполнить().Выгрузить();
	
	Объект.РеестрВыбытия.Очистить();
	Для Каждого СтрокаТаблицыРеестра Из ТаблицаРеестраВыбытия Цикл
		
		СтрокаРеестра = Объект.РеестрВыбытия.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаРеестра, СтрокаТаблицыРеестра);
		
		ДальнейшееДействие = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДальнейшиеДействия, СтрокаРеестра.ДальнейшееДействие);
		Если ДальнейшееДействие <> Неопределено Тогда
			СтрокаРеестра.ДальнейшееДействиеПредставление = ДальнейшееДействие.Представление;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти // ЗаполнениеРеестраВыбытия

#Область ПолучениеИнформацииОбУпаковках

&НаКлиенте
Процедура ВыполнитьПолучениеИнформацииОбУпаковкахРеестраВыбытия()
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	НомераУпаковок = ДанныеДляПолученияИнформацииОбУпаковках();
	Если Не ЗначениеЗаполнено(НомераУпаковок) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Нет данных для обработки.'"));
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(МестоДеятельности) Тогда
		ПараметрыПодключения = ТранспортМДЛПАПИВызовСервера.ПараметрыПодключения(Организация, МестоДеятельности);
	Иначе
		ПараметрыПодключения = ТранспортМДЛПАПИВызовСервера.ПараметрыПодключения(Организация);
	КонецЕсли;
	
	ОтменитьПолучениеИнформациюОбУпаковках();
	
	ОтобразитьВыполнениеПолученияИнформацииОбУпаковках("Начало");
	
	ПараметрыМетода = ТранспортМДЛПАПИКлиентСервер.ПараметрыПолученияИнформацииОПотребительскихУпаковках(Строка(УникальныйИдентификатор));
	ПараметрыМетода.НомераУпаковок = НомераУпаковок;
	ПараметрыМетода.ТипИсточникаИнформацииОбУпаковках = ПредопределенноеЗначение("Перечисление.ТипыИсточниковИнформацииОбУпаковкахМДЛП.Публичный");
	
	ПараметрыЗапуска = ТранспортМДЛПАПИКлиент.ПараметрыЗапускаМетодовАПИВДлительнойОперации(ЭтотОбъект);
	ПараметрыЗапуска.ОповещениеПередОжиданиемДлительнойОперации = Новый ОписаниеОповещения("ПередОжиданиемПолученияИнформацииОбУпаковках", ЭтотОбъект);
	
	Оповещение = Новый ОписаниеОповещения("ОбработатьПолучениеИнформацииОбУпаковках", ЭтотОбъект);
	ТранспортМДЛПАПИКлиент.НачатьПолучениеИнформацииОКИЗ(ПараметрыПодключения, Оповещение, ПараметрыМетода, ПараметрыЗапуска);
	
КонецПроцедуры

&НаСервере
Функция ДанныеДляПолученияИнформацииОбУпаковках()
	
	ТаблицаРеестрВыбытия = Объект.РеестрВыбытия.Выгрузить(Новый Структура("Пометка", Истина), "НомерУпаковки, КлючУпаковки");
	ТаблицаРеестрВыбытия.Свернуть("НомерУпаковки, КлючУпаковки");
	Возврат ТаблицаРеестрВыбытия.ВыгрузитьКолонку("НомерУпаковки");
	
КонецФункции

&НаКлиенте
Процедура ОбработатьПолучениеИнформацииОбУпаковках(Результат, ДополнительныеПараметры) Экспорт
	
	ИдентификаторЗаданияПолученияИнформацииОбУпаковках = Неопределено;
	Если Не Открыта() Тогда
		Возврат;
	КонецЕсли;
	
	ОтобразитьВыполнениеПолученияИнформацииОбУпаковках("Конец");
	
	Если Результат.Статус = "Ошибка" Тогда
		ВызватьИсключение Результат.ОписаниеОшибки;
	КонецЕсли;
	
	Если Результат.Статус = "Отменено" Тогда
		Возврат;
	КонецЕсли;
	
	АдресРезультатаМетодаАПИ = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Результат, "АдресРезультатаМетодаАПИ");
	Если АдресРезультатаМетодаАПИ = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбработатьПолучениеИнформацииОбУпаковкахНаСервере(АдресРезультатаМетодаАПИ);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьПолучениеИнформацииОбУпаковкахНаСервере(Знач АдресРезультатаМетодаАПИ)
	
	РезультатУпаковки = ПолучитьИзВременногоХранилища(АдресРезультатаМетодаАПИ);
	ДанныеУпаковок = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(РезультатУпаковки, "Данные", Новый Соответствие);
	
	ТаблицаРеестрВыбытия = Объект.РеестрВыбытия.Выгрузить(Новый Массив);
	ТаблицаРеестрВыбытия.Очистить(); // Для надежности
	
	СоответствияСтатусовВыбытия = СоответствияСтатусовВыбытия();
	СтатусыКорректногоВыбытия = СтатусыКорректногоВыбытия();
	
	Для Каждого КлючИЗначение Из ДанныеУпаковок Цикл
		
		ДанныеУпаковки = КлючИЗначение.Значение;
		Если Не ЗначениеЗаполнено(ДанныеУпаковки) Тогда
			Продолжить;
		КонецЕсли;
		
		СтатусМДЛП = ДанныеУпаковки["status"];
		Если Не ЗначениеЗаполнено(СтатусМДЛП) Тогда
			Продолжить;
		КонецЕсли;
		
		Статус = СоответствияСтатусовВыбытия.Получить(СтатусМДЛП);
		Если Статус = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если СтатусыКорректногоВыбытия.Найти(Статус) <> Неопределено Тогда
			СтатусВыбытия = Перечисления.СтатусыВыбытияУпаковокМДЛП.ПодтвержденВыводИзОборота;
		Иначе
			СтатусВыбытия = Перечисления.СтатусыВыбытияУпаковокМДЛП.ПодтвержденСОшибкойВыводИзОборота;
		КонецЕсли;
		
		НомерУпаковки = КлючИЗначение.Ключ;
		КлючУпаковки  = ИнтеграцияМДЛПКлиентСервер.ПолучитьКлючУпаковки(НомерУпаковки);
		
		НайденныеСтроки = Объект.РеестрВыбытия.НайтиСтроки(Новый Структура("НомерУпаковки, КлючУпаковки", НомерУпаковки, КлючУпаковки));
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			
			Если СтатусВыбытия <> НайденнаяСтрока.СтатусВыбытия Тогда
				Строка = ТаблицаРеестрВыбытия.Добавить();
				ЗаполнитьЗначенияСвойств(Строка, НайденнаяСтрока);
				Строка.СтатусВыбытия = СтатусВыбытия;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	НачатьТранзакцию();
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.РеестрВыбытияУпаковокМДЛП");
		ЭлементБлокировки.ИсточникДанных = ТаблицаРеестрВыбытия;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("НомерУпаковки", "НомерУпаковки");
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("КлючУпаковки", "КлючУпаковки");
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("МестоДеятельности", "МестоДеятельности");
		Блокировка.Заблокировать();
		
		Для Каждого Строка Из ТаблицаРеестрВыбытия Цикл
			Запись = РегистрыСведений.РеестрВыбытияУпаковокМДЛП.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(Запись, Строка);
			Запись.Записать();
		КонецЦикла;
		
		ЗапуститьЗаполнениеРеестраВыбытияНаСервере();
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		Текст = НСтр("ru = 'Не удалось обработать получение информации об упаковках по причине:'");
		ТекстЖурналаРегистрации = Текст + Символы.ПС + ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстПользователю = Текст + Символы.ПС + ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ИмяСобытия = НСтр("ru = 'Реестр выбытия.Получение информации об упаковках'", ОбщегоНазначения.КодОсновногоЯзыка());
		
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка,,, ТекстЖурналаРегистрации);
		
		ОбщегоНазначения.СообщитьПользователю(ТекстПользователю);
		
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередОжиданиемПолученияИнформацииОбУпаковках(ДлительнаяОперация, ДополнительныеПараметры) Экспорт
	
	ИдентификаторЗаданияПолученияИнформацииОбУпаковках = ДлительнаяОперация.ИдентификаторЗадания;
	
КонецПроцедуры

&НаСервере
Процедура ОтменитьПолучениеИнформациюОбУпаковках()
	
	Если ЗначениеЗаполнено(ИдентификаторЗаданияПолученияИнформацииОбУпаковках) Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗаданияПолученияИнформацииОбУпаковках);
		ИдентификаторЗаданияПолученияИнформацииОбУпаковках = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьВыполнениеПолученияИнформацииОбУпаковках(Состояние)
	
	Если Состояние = "Начало" Тогда
		
		Элементы.ВыполнитьОтменуПолученияИнформацииОбУпаковках.Видимость = Истина;
		
		Элементы.ДальнейшееДействиеОтбор.Доступность = Ложь;
		Элементы.РеестрВыбытия.Доступность = Ложь;
		
		ТекстОповещения = НСтр("ru = 'Получение информации'");
		ПояснениеОповещения = НСтр("ru = 'Получение информации об упаковках запущено'");
		ПоказатьОповещениеПользователя(ТекстОповещения,, ПояснениеОповещения, БиблиотекаКартинок.Информация32);
		
	Иначе
		
		Элементы.ВыполнитьОтменуПолученияИнформацииОбУпаковках.Видимость = Ложь;
		
		Элементы.ДальнейшееДействиеОтбор.Доступность = Истина;
		Элементы.РеестрВыбытия.Доступность = Истина;
		
		ТекстОповещения = НСтр("ru = 'Получение информации'");
		ПояснениеОповещения = НСтр("ru = 'Получение информации об упаковках завершено'");
		ПоказатьОповещениеПользователя(ТекстОповещения,, ПояснениеОповещения, БиблиотекаКартинок.Информация32);
		
	КонецЕсли;
	
	ОбновитьИнтерфейс();
	
КонецПроцедуры

#КонецОбласти // ПолучениеИнформацииОбУпаковках

#Область Выбытие

&НаКлиенте
Процедура ВыполнитьВыбытиеРеестраВыбытия()
	
	ВыполнитьВыбытиеРеестраВыбытияНаСервере();
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Выполнено действие'"),,
		НСтр("ru = 'Выбытие выполнено'"),
		БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьВыбытиеРеестраВыбытияНаСервере()
	
	ТаблицаРеестрВыбытия = ДанныеДляВыводаУпаковокИзОборота();
	Если Не ЗначениеЗаполнено(ТаблицаРеестрВыбытия) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Нет данных для обработки.'"));
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.УпаковкиМДЛП");
		ЭлементБлокировки.ИсточникДанных = ТаблицаРеестрВыбытия;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("НомерУпаковки", "НомерУпаковки");
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("КлючУпаковки", "КлючУпаковки");
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("МестоДеятельности", "МестоДеятельности");
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.РеестрВыбытияУпаковокМДЛП");
		ЭлементБлокировки.ИсточникДанных = ТаблицаРеестрВыбытия;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("НомерУпаковки", "НомерУпаковки");
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("КлючУпаковки", "КлючУпаковки");
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("МестоДеятельности", "МестоДеятельности");
		Блокировка.Заблокировать();
		
		Запрос = Новый Запрос("
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	РеестрВыбытия.НомерУпаковки      КАК НомерУпаковки,
		|	РеестрВыбытия.КлючУпаковки       КАК КлючУпаковки,
		|	РеестрВыбытия.МестоДеятельности  КАК МестоДеятельности,
		|	РеестрВыбытия.СтатусВыбытия      КАК СтатусВыбытия
		|ПОМЕСТИТЬ РеестрВыбытия
		|ИЗ
		|	&ТаблицаРеестрВыбытия КАК РеестрВыбытия
		|ГДЕ
		|	РеестрВыбытия.СтатусВыбытия В (ЗНАЧЕНИЕ(Перечисление.СтатусыВыбытияУпаковокМДЛП.ПодтвержденВыводИзОборота), ЗНАЧЕНИЕ(Перечисление.СтатусыВыбытияУпаковокМДЛП.ПодтвержденСОшибкойВыводИзОборота))
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТекущиеСтатусы.НомерУпаковки            КАК НомерУпаковки,
		|	ТекущиеСтатусы.КлючУпаковки             КАК КлючУпаковки,
		|	ТекущиеСтатусы.МестоДеятельности        КАК МестоДеятельности,
		|	ТекущиеСтатусы.ДокументРезерва          КАК ДокументРезерва,
		|	ТекущиеСтатусы.ЗонаТаможенногоКонтроля  КАК ЗонаТаможенногоКонтроля,
		|	ВЫБОР
		|		КОГДА РеестрВыбытия.СтатусВыбытия = ЗНАЧЕНИЕ(Перечисление.СтатусыВыбытияУпаковокМДЛП.ПодтвержденВыводИзОборота)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтатусыУпаковокМДЛП.ВыбылаИзОборота)
		|		КОГДА РеестрВыбытия.СтатусВыбытия = ЗНАЧЕНИЕ(Перечисление.СтатусыВыбытияУпаковокМДЛП.ПодтвержденСОшибкойВыводИзОборота)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтатусыУпаковокМДЛП.ВыбылаИзОборотаСОшибкой)
		|	КОНЕЦ                                   КАК Статус,
		|	&ДатаСтатуса                            КАК ДатаСтатуса
		|ИЗ
		|	РегистрСведений.УпаковкиМДЛП КАК ТекущиеСтатусы
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|			РеестрВыбытия КАК РеестрВыбытия
		|		ПО
		|			РеестрВыбытия.МестоДеятельности = ТекущиеСтатусы.МестоДеятельности
		|			И РеестрВыбытия.НомерУпаковки = ТекущиеСтатусы.НомерУпаковки
		|			И РеестрВыбытия.КлючУпаковки = ТекущиеСтатусы.КлючУпаковки
		|");
		
		Запрос.УстановитьПараметр("ТаблицаРеестрВыбытия", ТаблицаРеестрВыбытия);
		Запрос.УстановитьПараметр("ДатаСтатуса"         , ТекущаяДатаСеанса());
		
		// Обновление записей Упаковок МДЛП.
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			Запись = РегистрыСведений.УпаковкиМДЛП.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(Запись, Выборка);
			Запись.Записать();
		КонецЦикла;
		
		// Удаление записей из реестра выбытия.
		Для Каждого Строка Из ТаблицаРеестрВыбытия Цикл
			Набор = РегистрыСведений.РеестрВыбытияУпаковокМДЛП.СоздатьНаборЗаписей();
			Набор.Отбор.МестоДеятельности.Установить(Строка.МестоДеятельности);
			Набор.Отбор.НомерУпаковки.Установить(Строка.НомерУпаковки);
			Набор.Отбор.КлючУпаковки.Установить(Строка.КлючУпаковки);
			Набор.Записать();
		КонецЦикла;
		
		ЗапуститьЗаполнениеРеестраВыбытияНаСервере();
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		Текст = НСтр("ru = 'Не удалось обработать выбытие упаковок по причине:'");
		ТекстЖурналаРегистрации = Текст + Символы.ПС + ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстПользователю = Текст + Символы.ПС + ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ИмяСобытия = НСтр("ru = 'Реестр выбытия.Выбытие упаковок'", ОбщегоНазначения.КодОсновногоЯзыка());
		
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка,,, ТекстЖурналаРегистрации);
		
		ОбщегоНазначения.СообщитьПользователю(ТекстПользователю);
		
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Функция ДанныеДляВыводаУпаковокИзОборота()
	
	ТаблицаРеестрВыбытия = Объект.РеестрВыбытия.Выгрузить(Новый Структура("Пометка, ДальнейшееДействие", Истина, ДальнейшееДействие_ВыполнитьВыбытие()), "НомерУпаковки, КлючУпаковки, МестоДеятельности, СтатусВыбытия");
	ТаблицаРеестрВыбытия.Свернуть("НомерУпаковки, КлючУпаковки, МестоДеятельности, СтатусВыбытия");
	
	Возврат ТаблицаРеестрВыбытия;
	
КонецФункции

#КонецОбласти // Выбытие

#Область ДальнейшиеДействия

&НаКлиентеНаСервереБезКонтекста
Функция ДальнейшиеДействия()
	
	ДальнейшиеДействия = Новый Структура;
	
	ДальнейшиеДействия.Вставить(ДальнейшееДействие_ПолучитьКвитанциюОФиксацииВывода() , ОписаниеДальнейшегоДействия(
		НСтр("ru = 'Получить квитанцию о фиксации вывода'"),
		НСтр("ru = 'Необходимо получить подтверждение о фиксации операции вывода (выбытие с использованием РВ или ККТ) лекарственного средства в ИС МДЛП.'")
		));
	
	ДальнейшиеДействия.Вставить(ДальнейшееДействие_ПолучитьКвитанциюОФиксацииОборота() , ОписаниеДальнейшегоДействия(
		НСтр("ru = 'Получить квитанцию о фиксации оборота'"),
		НСтр("ru = 'Текущий статус упаковки находится в переходящем состоянии (В резерве, К поступлению). Необходимо получить квитанцию о фиксации операции.'")
		));
	
	
	ДальнейшиеДействия.Вставить(ДальнейшееДействие_ВыполнитьПоступление(), ОписаниеДальнейшегоДействия(
		НСтр("ru = 'Выполнить поступление'"),
		НСтр("ru = 'Упаковка не обнаружена на остатках организации. Необходимо выполнить приемку лекарственного средства.'")
		));
	
	ДальнейшиеДействия.Вставить(ДальнейшееДействие_ВыполнитьПеремещение(), ОписаниеДальнейшегоДействия(
		НСтр("ru = 'Выполнить перемещение'"),
		НСтр("ru = 'Упаковка находится на другом месте деятельности. Необходимо выполнить перемещение лекарственного средства на место деятельности выбытия.'")
		));
	
	ДальнейшиеДействия.Вставить(ДальнейшееДействие_ВыполнитьИзъятие() , ОписаниеДальнейшегоДействия(
		НСтр("ru = 'Выполнить изъятие'"),
		НСтр("ru = 'Потребительская упаковка находится в транспортной упаковке. Необходимо выполнить изъятие лекарственного средства из транспортной упаковки.'")
		));
	
	ДальнейшиеДействия.Вставить(ДальнейшееДействие_ВыполнитьВыбытие() , ОписаниеДальнейшегоДействия(
		НСтр("ru = 'Выполнить выбытие'"),
		НСтр("ru = 'Вывод (выбытие с использованием РВ или ККТ) лекарственного средства в ИС МДЛП зафиксирован. Необходимо завершить выбытие лекарственного средства в информационной базе.'")
		));
	
	
	ДальнейшиеДействия.Вставить(ДальнейшееДействие_ОжидайтеИзмененияСостояния() , ОписаниеДальнейшегоДействия(
		НСтр("ru = 'Ожидайте изменения состояния в ИС МДЛП'"),
		НСтр("ru = 'Информация о выводе упаковки из оборота в ИС МДЛП не обновилась. Необходимо дождаться изменения состояния упаковки и повторить получение информации.'")
		));
	
	Возврат ДальнейшиеДействия;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеДальнейшегоДействия(Представление, Описание)
	
	ОписаниеДальнейшегоДействия = Новый Структура;
	ОписаниеДальнейшегоДействия.Вставить("Представление", Представление);
	ОписаниеДальнейшегоДействия.Вставить("Описание"     , Описание);
	
	Возврат ОписаниеДальнейшегоДействия;
	
КонецФункции

&НаСервере
Процедура ОбработатьИзменениеОтбораДальнейшегоДействия()
	
	Если ЗначениеЗаполнено(ДальнейшееДействиеОтбор) Тогда
		ДальнейшееДействие = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДальнейшиеДействия(), ДальнейшееДействиеОтбор);
		Если ДальнейшееДействие <> Неопределено Тогда
			Элементы.ДальнейшееДействиеОтбор.Подсказка = ДальнейшееДействие.Описание;
		КонецЕсли;
	Иначе
		Элементы.ДальнейшееДействиеОтбор.Подсказка = "Подсказка отображается для каждого выбранного действия.";
	КонецЕсли;
	
	УстановитьОтборДальнейшегоДействия();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборДальнейшегоДействия()
	
	Если ЗначениеЗаполнено(ДальнейшееДействиеОтбор) Тогда
		Элементы.РеестрВыбытия.ОтборСтрок = Новый ФиксированнаяСтруктура(Новый Структура("ДальнейшееДействие", ДальнейшееДействиеОтбор));
	Иначе
		Элементы.РеестрВыбытия.ОтборСтрок = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ДальнейшееДействие_ПолучитьКвитанциюОФиксацииВывода()
	
	Возврат "ПолучитьКвитанциюОФиксацииВывода";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ДальнейшееДействие_ПолучитьКвитанциюОФиксацииОборота()
	
	Возврат "ПолучитьКвитанциюОФиксацииОборота";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ДальнейшееДействие_ВыполнитьПоступление()
	
	Возврат "ВыполнитьПоступление";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ДальнейшееДействие_ВыполнитьПеремещение()
	
	Возврат "ВыполнитьПеремещение";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ДальнейшееДействие_ВыполнитьИзъятие()
	
	Возврат "ВыполнитьИзъятие";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ДальнейшееДействие_ВыполнитьВыбытие()
	
	Возврат "ВыполнитьВыбытие";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ДальнейшееДействие_ОжидайтеИзмененияСостояния()
	
	Возврат "ОжидайтеИзмененияСостояния";
	
КонецФункции

#КонецОбласти // ДальнейшиеДействия

#Область СтатусыУпаковок

&НаКлиентеНаСервереБезКонтекста
Функция СоответствияСтатусовВыбытия()
	
	Связь = Новый Соответствие;
	
	Связь.Вставить("out_of_circulation"                   , ПредопределенноеЗначение("Перечисление.СтатусыУпаковокМДЛП.ВыбылаИзОборота"));
	Связь.Вставить("in_medical_use"                       , ПредопределенноеЗначение("Перечисление.СтатусыУпаковокМДЛП.ВыбылаИзОборота"));
	
	Связь.Вставить("in_sale"                              , ПредопределенноеЗначение("Перечисление.СтатусыУпаковокМДЛП.ВыбылаИзОборота"));
	Связь.Вставить("in_discount_prescription_sale"        , ПредопределенноеЗначение("Перечисление.СтатусыУпаковокМДЛП.ВыбылаИзОборота"));
	
	Связь.Вставить("ofd_retail_error"                     , ПредопределенноеЗначение("Перечисление.СтатусыУпаковокМДЛП.ВыбылаИзОборотаСОшибкой"));
	Связь.Вставить("ofd_discount_prescription_error"      , ПредопределенноеЗначение("Перечисление.СтатусыУпаковокМДЛП.ВыбылаИзОборотаСОшибкой"));
	
	Связь.Вставить("med_care_error"                       , ПредопределенноеЗначение("Перечисление.СтатусыУпаковокМДЛП.ВыбылаИзОборотаСОшибкой"));
	Связь.Вставить("discount_prescription_error"          , ПредопределенноеЗначение("Перечисление.СтатусыУпаковокМДЛП.ВыбылаИзОборотаСОшибкой"));
	
	Возврат Связь;
	
КонецФункции

&НаСервереБезКонтекста
Функция СтатусыЗафиксированногоСостоянияУпаковок()
	
	Статусы = Новый Массив;
	Статусы.Добавить(Перечисления.СтатусыУпаковокМДЛП.ВОбороте);
	Статусы.Добавить(Перечисления.СтатусыУпаковокМДЛП.ВУпаковке);
	Статусы.Добавить(Перечисления.СтатусыУпаковокМДЛП.ВыбылаИзОборота);
	Статусы.Добавить(Перечисления.СтатусыУпаковокМДЛП.ВыбылаИзОборотаСОшибкой);
	
	Возврат Статусы;
	
КонецФункции

&НаСервереБезКонтекста
Функция СтатусыПозволяющиеПеремещениеУпаковки()
	
	Статусы = Новый Массив;
	Статусы.Добавить(Перечисления.СтатусыУпаковокМДЛП.ВОбороте);
	Статусы.Добавить(Перечисления.СтатусыУпаковокМДЛП.ВУпаковке);
	
	Возврат Статусы;
	
КонецФункции

&НаСервереБезКонтекста
Функция СтатусыПозволяющиеИзъятиеУпаковки()
	
	Статусы = Новый Массив;
	Статусы.Добавить(Перечисления.СтатусыУпаковокМДЛП.ВУпаковке);
	
	Возврат Статусы;
	
КонецФункции

&НаСервереБезКонтекста
Функция СтатусыПозволяющиеВыбытиеУпаковки()
	
	Статусы = Новый Массив;
	Статусы.Добавить(Перечисления.СтатусыУпаковокМДЛП.ВОбороте);
	Статусы.Добавить(Перечисления.СтатусыУпаковокМДЛП.ВыбылаИзОборота);
	Статусы.Добавить(Перечисления.СтатусыУпаковокМДЛП.ВыбылаИзОборотаСОшибкой);
	
	Возврат Статусы;
	
КонецФункции

&НаСервереБезКонтекста
Функция СтатусыКорректногоВыбытия()
	
	Статусы = Новый Массив;
	Статусы.Добавить(Перечисления.СтатусыУпаковокМДЛП.ВыбылаИзОборота);
	
	Возврат Статусы;
	
КонецФункции

#КонецОбласти // СтатусыУпаковок

#Область Прочее

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Элементы.РеестрВыбытияСтатусВыбытия.Имя);
	
	СтатусыВыбытия = Новый СписокЗначений;
	СтатусыВыбытия.Добавить(Перечисления.СтатусыВыбытияУпаковокМДЛП.ОтклоненВыводИзОборота);
	СтатусыВыбытия.Добавить(Перечисления.СтатусыВыбытияУпаковокМДЛП.ПодтвержденСОшибкойВыводИзОборота);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Элемент.Отбор,
		"Объект.РеестрВыбытия.СтатусВыбытия", СтатусыВыбытия);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаТребуетВниманияМДЛП);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПометку(Значение)
	
	ВыделенныеСтроки = Элементы.РеестрВыбытия.ВыделенныеСтроки;
	Если Не ЗначениеЗаполнено(ВыделенныеСтроки) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Идентификатор Из ВыделенныеСтроки Цикл
		
		ТекущиеДанные = Объект.РеестрВыбытия.НайтиПоИдентификатору(Идентификатор);
		ТекущиеДанные.Пометка = Значение;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти // Прочее

#КонецОбласти // СлужебныеПроцедурыИФункции
