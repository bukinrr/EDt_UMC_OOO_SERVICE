
#Область ПрограммныйИнтерфейс



#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция РазобратьОтветHl7(ОтветОтСервера) Экспорт
		XMLСтрока = ОтветОтСервера.ПолучитьТелоКакСтроку();

	XMLЧтение = Новый ЧтениеXML;
	XMLЧтение.УстановитьСтроку(XMLСтрока);
	
	ПостроительDOM = Новый ПостроительDOM;
	DOM = ПостроительDOM.Прочитать(XMLЧтение);
	
	ЭлементыОтвета	= DOM.ПолучитьЭлементыПоИмени("urn:hl7-org:v3", "MCCI_IN000002UV01");
	ДеталиОтвета	= DOM.ПолучитьЭлементыПоИмени("urn:hl7-org:v3", "acknowledgementDetail");
	
	Результат = Новый Структура("ЕстьОшибка, Детали", Ложь, Новый Массив);
	
	Если ЭлементыОтвета.Количество() > 0 Тогда
	
		Для Каждого ДетальОтвета Из ДеталиОтвета Цикл
			Если ДетальОтвета.ПолучитьАтрибут("typeCode") = "E" Тогда
				Результат.ЕстьОшибка = Истина;
			КонецЕсли;
			ТэгиCode = ДетальОтвета.ПолучитьЭлементыПоИмени("code");
			Если ТэгиCode.Количество() > 0 Тогда
				Деталь = Новый Структура("Код, Сообщение");
				Деталь.Код			= ТэгиCode[0].ПолучитьАтрибут("code");
				Деталь.Сообщение	= ТэгиCode[0].ПолучитьАтрибут("displayName");
				
				Результат.Детали.Добавить(Деталь);
			КонецЕсли;
		КонецЦикла;
		
	Иначе
		Результат.ЕстьОшибка = Истина;
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

// Отправляет HL7 пакет на веб-сервис.
Функция СформироватьИОтправитьSOAPЗапрос(Адрес, ТелоСообщения, ИдентификаторКлиента, УИДСообщения, ТипПакета = Неопределено, MSG_ID = Неопределено) Экспорт
	
	СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(Адрес);
	Хост				= СтруктураURI.Хост;
	ПутьНаСервере		= СтруктураURI.ПутьНаСервере;
	ИспользоватьHttps	= ?(СтруктураURI.Схема = "https", Истина, Ложь);
	
	ТекстЗапроса = ПоместитьСообщениеВSOAPКонверт(Адрес, ТелоСообщения, ИдентификаторКлиента, УИДСообщения, ТипПакета);
	
	Сертификат = ИнтеграцияЕГИСЗСерверПовтИсп.ПолучитьСертификатПодписанияСообщенийSOAP();
	Если ЗначениеЗаполнено(Сертификат) Тогда
		ТекстЗапроса = ИнтеграцияЕГИСЗ_ЭЦП.ПодписатьSoapСообщение(ТекстЗапроса, Сертификат);
	КонецЕсли;
	
	Возврат ОтправитьПоHTTP(Хост, ПутьНаСервере, ТекстЗапроса, ИспользоватьHttps, УИДСообщения, MSG_ID);
	
КонецФункции

// Запись в журнал регистрации HTTP запроса или ответа.
Процедура ЗаписатьОбъектВЖурналРегистрации(Объект) Экспорт
	
	// Уровень журнала регистрации по умолчанию - Примечание.
	// Но если код состояния ответа будет отличен от 200, уровень изменим на Ошибка.
	УровеньЖР = УровеньЖурналаРегистрации.Примечание;
	
	ЛокальныйURL = "";
	
	// HTTP запрос и HTTP ответ различаются строкой состояния. Обработаем их по отдельности.
	Если ТипЗнч(Объект) = Тип("HTTPСервисЗапрос") Тогда
		
		СтрокаПараметров = "";
		Разделитель = "?";
		
		Для Каждого КлючИЗначение Из Объект.ПараметрыЗапроса Цикл
			СтрокаПараметров = СтрШаблон("%1%2%3=%4", СтрокаПараметров, Разделитель, КлючИЗначение.Ключ, КлючИЗначение.Значение);
			Разделитель = "&";
		КонецЦикла;
		
		ЛокальныйURL = СтрШаблон("%2%3%4", Объект.БазовыйURL, Объект.ОтносительныйURL, СтрокаПараметров);
		
		СтрокаСостояния = СтрШаблон("%1 %2 HTTP/1.1", Объект.HTTPМетод, ЛокальныйURL);
				
	ИначеЕсли ТипЗнч(Объект) = Тип("HTTPЗапрос") Тогда
		
		ЛокальныйURL = Объект.АдресРесурса;
		
		СтрокаСостояния = СтрШаблон("POST %1 HTTP/1.1", Объект.АдресРесурса);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("HTTPСервисОтвет") Тогда
		
		СтрокаСостояния = СтрШаблон("HTTP/1.1 %1 %2", Объект.КодСостояния, Объект.КодСостояния);
		Если Объект.КодСостояния <> 200 Тогда
			УровеньЖР = УровеньЖурналаРегистрации.Ошибка;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("HTTPОтвет") Тогда
		
		СтрокаСостояния = СтрШаблон("HTTP/1.1 %1 %2", Объект.КодСостояния, Объект.КодСостояния);
		Если Объект.КодСостояния <> 200 Тогда
			УровеньЖР = УровеньЖурналаРегистрации.Ошибка;
		КонецЕсли;
	Иначе
		
		ВызватьИсключение "Ошибка при обработке Процедуры ЗаписатьВЖурналРегистрации(Объект)";
		
	КонецЕсли;
	
	// Далее сформируем строку заголовков.
	СтрокаЗаголовков = "";
	Для Каждого КлючИЗначение Из Объект.Заголовки Цикл
		СтрокаЗаголовков = СтрШаблон("%1%2%3%4: %5", СтрокаЗаголовков, Символы.ВК, Символы.ПС, КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
	// Осталось взять тело запроса или ответа.
	Если ТипЗнч(Объект) = Тип("Структура") Тогда
		// Для тестирования.
		Тело = Объект.ТелоКакСтрока;
	Иначе
		Тело = Объект.ПолучитьТелоКакСтроку();
	КонецЕсли;
	
	// Теперь сформируем комментарий для журнала регистрации.
	Комментарий = СтрШаблон("%1%2%3%4%5%6%7", СтрокаСостояния, СтрокаЗаголовков, Символы.ВК, Символы.ПС, Символы.ВК, Символы.ПС, Тело);
	
	// Определимся с именем события журнала регистрации.
	Если ТипЗнч(Объект) = Тип("HTTPСервисЗапрос") Тогда
		ИмяСобытия = "ИнтеграцияЕГИСЗ.Запрос.Входящий";
	ИначеЕсли ТипЗнч(Объект) = Тип("HTTPСервисОтвет") Тогда
		ИмяСобытия = "ИнтеграцияЕГИСЗ.Ответ.Исходящий";
	ИначеЕсли ТипЗнч(Объект) = Тип("HTTPОтвет") Тогда
		ИмяСобытия = "ИнтеграцияЕГИСЗ.Ответ.Входящий";	
	ИначеЕсли ТипЗнч(Объект) = Тип("HTTPЗапрос") Тогда
		ИмяСобытия = "ИнтеграцияЕГИСЗ.Запрос.Исходящий";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Тело) Тогда
		ТегПараметровSOAP = ОпределитьТегПараметровЗапросаSOAP(Тело);
		Если ЗначениеЗаполнено(ТегПараметровSOAP) Тогда
			ИмяСобытия = ИмяСобытия + "." + ТегПараметровSOAP;
		КонецЕсли;
		ТегПараметровSOAP = СтрШаблон("<%1/>", ТегПараметровSOAP);
	Иначе
		ТегПараметровSOAP = ЛокальныйURL;
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖР, , Тело, Комментарий);
	
КонецПроцедуры

// Запись в журнал регистрации события.
Процедура ЗаписатьСобытиеВЖурналРегистрации(Сообщение, Уровень = Неопределено, ИмяСобытия = "EMDR") Экспорт

	ЗаписьЖурналаРегистрации(
		ИмяСобытия,
		?(Уровень = Неопределено, УровеньЖурналаРегистрации.Информация, Уровень),
		,
		,
		Сообщение
	);
	
КонецПроцедуры

Функция ОпределитьТегПараметровЗапросаSOAP(Тело) Экспорт
	
	Попытка
		
		ДокументDOM = РаботаСDOMКлиентСервер.DOMИзСтрокиXML(Тело);
		
		// С помощью XPath определим версию SOAP.
		soap = ИнтеграцияЕГИСЗСлужебныйСервер.ПолучитьСтрокуПоXPath(ДокументDOM, , "namespace-uri(/*)");
		
		// Определяем имя тега.
		ПространствоИмен = Новый РазыменовательПространствИменDOM("soap", soap);
		
		XPath = "local-name(/soap:Envelope/soap:Body/*)";
		ИмяТега = ИнтеграцияЕГИСЗСлужебныйСервер.ПолучитьСтрокуПоXPath(ДокументDOM, ПространствоИмен, XPath);
		
		// Успешное выполнение
		Возврат ИмяТега;
		
	Исключение
		
		ЗаписьЖурналаРегистрации("ИнтеграцияЕГИСЗ.Ошибка", УровеньЖурналаРегистрации.Ошибка, , "Ошибка при разборе XML",
			СтрШаблон("%1
			|%2",
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
			Тело));
		
	КонецПопытки;
	
	// Определить тег не удалось
	Возврат "";
	
КонецФункции

Функция ПовторитьФрагментТекста(Знач Количество, Строка) Экспорт
	
	Результат = "";
	
	Номер = 1;
	Пока Номер <= Количество Цикл
		Кусок = стрЗаменить(Строка, "%НОМЕР%", Строка(Номер));
		Результат = Результат + Кусок;
		Номер = Номер + 1;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Построение документа DOM из стоки XML
//
// Функция кешируется на время вызова, чтобы можно было ее вызывать несколько раз
// без потери времени.
//
// Параметры:
//   СтрокаXML - Строка -
//     Строка XML, по которой нужно построить DOM.
//
// Возвращаемое значение:
//   ДокументDOM - Построенный по строке XML документ DOM.
///
Функция ПостроитьDOM(СтрокаXML) Экспорт
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(СтрокаXML);
	
	ПостроительDOM = Новый ПостроительDOM;
	ДокументDOM = ПостроительDOM.Прочитать(ЧтениеXML);
	
	Возврат ДокументDOM;
	
КонецФункции

Функция ЭкранироватьЗначение(Строка) Экспорт
	
	Если Не ЗначениеЗаполнено(Строка) Тогда
		Возврат "";
	КонецЕсли;
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку();
	ЗаписьXML.ЗаписатьНачалоЭлемента("q");
	ЗаписьXML.ЗаписатьАтрибут("s", Строка(Строка));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	XML = ЗаписьXML.Закрыть();
	
	Длина = стрДлина(XML);
	Если Длина > 8 Тогда
		Результат = Сред(XML, 7, Длина - 9);
	Иначе
		Результат = "";
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

Функция ПолучитьСодержимоеЭлемента(РодительскийУзелDOM, ИмяЭлемента, Индекс = 0) Экспорт
	
	Если РодительскийУзелDOM <> Неопределено Тогда
		Результат = РодительскийУзелDOM.ПолучитьЭлементыПоИмени(ИмяЭлемента);

		Если Результат.Количество() > Индекс Тогда
			Возврат Результат[Индекс].ТекстовоеСодержимое;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция СравнитьИмяЭлемента(Знач ИмяТэга, Знач ПроверочноеИмя) Экспорт
	
	Позиция = стрНайти(ИмяТэга, ":");
	
	Если Позиция > 0 Тогда
		ИмяТэга = Сред(ИмяТэга, Позиция + 1, стрДлина(ИмяТэга) - Позиция);
	КонецЕсли;
	
	Возврат НРег(ИмяТэга) = НРег(ПроверочноеИмя);
	
КонецФункции

Функция ПолучитьЭлемент(РодительскийУзелDOM, ИмяЭлемента, Индекс = 0) Экспорт
	
	Если РодительскийУзелDOM <> Неопределено Тогда
	
		Результат = РодительскийУзелDOM.ПолучитьЭлементыПоИмени(ИмяЭлемента);

		Если Результат.Количество() > Индекс Тогда
			Возврат Результат[Индекс];
		КонецЕсли;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция ПолучитьАтрибут(РодительскийУзелDOM, ИмяАтрибута) Экспорт
	
	Если РодительскийУзелDOM <> Неопределено Тогда
		Возврат РодительскийУзелDOM.ПолучитьАтрибут(ИмяАтрибута);
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция ПолучитьДатуИзСтроки(ДатаСтрокой, ВДатеЕстьТире = Ложь) Экспорт
	
	Если ДатаСтрокой <> Неопределено Тогда
		Если стрДлина(ДатаСтрокой) >= 8 Тогда
			Если ВДатеЕстьТире = Ложь Тогда
				Возврат Дата(Число(Лев(ДатаСтрокой,4)), Число(Сред(ДатаСтрокой, 5, 2)), Число(Сред(ДатаСтрокой, 7, 2)));
			Иначе
				Возврат Дата(Число(Лев(ДатаСтрокой,4)), Число(Сред(ДатаСтрокой, 6, 2)), Число(Сред(ДатаСтрокой, 9, 2)));
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Процедура ЗаписатьВАрхивЛогов(СтруктураДляЛогов) Экспорт
	
	Если Не ЗначениеЗаполнено(СтруктураДляЛогов.УИДСообщения) Тогда
		ШаблонОшибки = НСтр("ru='Не удалось найти сообщение, лог по которому необходимо сохранить%1'");
		ТекстОшибки = СтрШаблон(ШаблонОшибки, Символы.ПС + Строка(СтруктураДляЛогов.ТекстЗапроса));
		ЗаписатьСобытиеВЖурналРегистрации(ТекстОшибки, УровеньЖурналаРегистрации.Ошибка);
		Возврат;
	КонецЕсли;
	
	ПутьКАрхивуЛогов = ИнтеграцияЕГИСЗСерверПовтИсп.ПолучитьПутьКАрхивуЛогов();
	КаталогАрхиваЛогов = Новый Файл(ПутьКАрхивуЛогов);
	
	ОперацияSOAP = ИнтеграцияЕГИСЗСлужебныйСервер.ОпределитьТегПараметровЗапросаSOAP(СтруктураДляЛогов.ТекстЗапроса);
	
	ЗаголовокФайлаСообщения = ПолучитьДатуСтрокойСМиллисекундамиДляИмениФайла() + " " + ОперацияSOAP + ".xml";
	
	Если Не КаталогАрхиваЛогов.Существует() Тогда
		ШаблонОшибки = НСтр("ru='Архив логов не доступен по указанному пути: %1'");
		ТекстОшибки = СтрШаблон(ШаблонОшибки, ПутьКАрхивуЛогов);
		ЗаписатьСобытиеВЖурналРегистрации(ТекстОшибки, УровеньЖурналаРегистрации.Ошибка);
		Возврат;
	КонецЕсли;
	
	НаименованиеАрхива = СтруктураДляЛогов.УИДСообщения + ".zip";
	ИмяФайлаАрхиваПоСообщению = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(КаталогАрхиваЛогов.ПолноеИмя, НаименованиеАрхива);
	ВременныйКаталогСообщений = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(КаталогВременныхФайлов(), Новый УникальныйИдентификатор());
	
	Попытка
		СоздатьКаталог(ВременныйКаталогСообщений);
		
		ФайлАрхиваПоСообщению = Новый Файл(ИмяФайлаАрхиваПоСообщению);
		Если ФайлАрхиваПоСообщению.Существует() Тогда
			ОбменДаннымиСервер.РаспаковатьZipФайл(ИмяФайлаАрхиваПоСообщению, ВременныйКаталогСообщений);
		КонецЕсли;
		
		ИмяФайлаСообщения = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ВременныйКаталогСообщений, ЗаголовокФайлаСообщения);
		
		XML = Новый ЗаписьТекста(ИмяФайлаСообщения, КодировкаТекста.UTF8);
		XML.ЗаписатьСтроку(ПолучитьТекстXML(СтруктураДляЛогов.ТекстЗапроса));
		XML.Закрыть();
		
		ПомещаемыеВАрхивФайлы = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ВременныйКаталогСообщений, "*.xml");
		ОбменДаннымиСервер.ЗапаковатьВZipФайл(ИмяФайлаАрхиваПоСообщению, ПомещаемыеВАрхивФайлы);
		
	Исключение
		ШаблонОшибки = НСтр("ru='Не удалось сохранить лог по сообщению %1'");
		ТекстОшибки = СтрШаблон(ШаблонОшибки, СтруктураДляЛогов.УИДСообщения);
		ЗаписатьСобытиеВЖурналРегистрации(ТекстОшибки, УровеньЖурналаРегистрации.Ошибка);
	КонецПопытки;
	
	Попытка
		УдалитьФайлы(ВременныйКаталогСообщений);
	Исключение КонецПопытки;
	
КонецПроцедуры

Функция ПолучитьУИДОтправленногоСообщения(СообщениеРЭМД) Экспорт
	
	ИдентификаторДокумента = СообщениеРЭМД.ИдентификаторДокумента;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИнтеграцияЕГИСЗСообщенияРЭМД.УИДСообщения КАК УИДСообщения
		|ИЗ
		|	РегистрСведений.ИнтеграцияЕГИСЗСообщенияРЭМД КАК ИнтеграцияЕГИСЗСообщенияРЭМД
		|ГДЕ
		|	ИнтеграцияЕГИСЗСообщенияРЭМД.ИдентификаторДокумента = &ИдентификаторДокумента";
	
	Запрос.УстановитьПараметр("ИдентификаторДокумента", ИдентификаторДокумента);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.УИДСообщения;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция ПолучитьДатуСтрокойСМиллисекундамиДляИмениФайла()
	
	ТекДата = ТекущаяУниверсальнаяДатаВМиллисекундах();
	стрДатаЗапроса = Строка(Формат(Дата(1,1,1) + Цел(ТекДата/1000), "ДФ='dd.MM.yyyy HH-mm-ss'"));
	стрДатаЗапросаМс = стрДатаЗапроса + "." + Формат(ТекДата%1000, "ЧЦ=3; ЧН=; ЧВН=") + "+00";
	Возврат стрДатаЗапросаМс;
	
КонецФункции

Процедура РезервноеКопирование(МедицинскаяОрганизация = Неопределено, ПолноеКопирование = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если МедицинскаяОрганизация = Неопределено Тогда
		Выборка = РегистрыСведений.ЕГИСЗНастройкиИнтеграции.Выбрать();
	Иначе
		Отбор = Новый Структура("МедицинскаяОрганизация", МедицинскаяОрганизация);
		Выборка = РегистрыСведений.ЕГИСЗНастройкиИнтеграции.Выбрать(Отбор);
	КонецЕсли;
	
	Пока Выборка.Следующий() Цикл
		ДатаНачалаКопирования = Дата(1,1,1);
		Если Не ПолноеКопирование Тогда
			МЗ = РегистрыСведений.ИнтеграцияЕГИСЗДатыРезервныхКопирований.СоздатьМенеджерЗаписи();
			МЗ.МедицинскаяОрганизация = Выборка.МедицинскаяОрганизация;
			МЗ.Прочитать();
			Если МЗ.Выбран() Тогда
				ДатаНачалаКопирования = МЗ.ДатаПоследнегоКопирования - 7 * 24 * 60 * 60;
			КонецЕсли;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Выборка.ПутьКАрхивуРЭМД) И
			ЗначениеЗаполнено(Выборка.ПутьКАрхивуРезервныхКопий)
		Тогда
			Попытка
				КопироватьФайлыИзКаталога(Выборка.ПутьКАрхивуРЭМД, Выборка.ПутьКАрхивуРезервныхКопий, ДатаНачалаКопирования);
			Исключение
				Возврат;
			КонецПопытки;
			
			МЗ = РегистрыСведений.ИнтеграцияЕГИСЗДатыРезервныхКопирований.СоздатьМенеджерЗаписи();
			МЗ.МедицинскаяОрганизация = Выборка.МедицинскаяОрганизация;
			МЗ.ДатаПоследнегоКопирования = НачалоДня(ТекущаяДата());
			МЗ.Записать();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура КопироватьФайлыИзКаталога(ИсходныйКаталог, ЦелевойКаталог, ДатаНачалаКопирования)
	
	Файлы = НайтиФайлы(ИсходныйКаталог, "*.*");
	Для Каждого Файл Из Файлы Цикл
		Путь = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ЦелевойКаталог) + Файл.Имя;
		Если Файл.ЭтоКаталог() Тогда
			Каталог = Новый Файл(Путь);
			Если Не Каталог.Существует() Тогда
				СоздатьКаталог(Путь);
			КонецЕсли;
			КопироватьФайлыИзКаталога(Файл.ПолноеИмя, Путь, ДатаНачалаКопирования);
		Иначе
			Если Файл.ПолучитьВремяИзменения() > ДатаНачалаКопирования Тогда
				КопироватьФайл(Файл.ПолноеИмя, Путь);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#Область Классификаторы

Процедура ЕГИСЗ_КлассификаторПередЗаписью(Источник, Отказ) Экспорт
	
	Если Не ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Источник, "УИДЕГИСЗ") Тогда
		Возврат;
	КонецЕсли;
	
	// Проверка доступности пометки на удаление элемента классификатора ЕГИСЗ.
	Причина = "";
	Если Источник.ПометкаУдаления
		И Источник.ПометкаУдаления <> Источник.Ссылка.ПометкаУдаления
		И Не Источник.ОбменДанными.Загрузка
		И Не ЕстьПравоНаИзменениеЭлементаКлассификатора(Источник, Причина)
	Тогда
		Отказ = Истина;
		ОбщегоНазначения.СообщитьПользователю(Причина);
	КонецЕсли;
	
	ТекстОшибки = "";
	Если Не Отказ
		И Не Источник.ПометкаУдаления
		И ЕстьОшибкиЗаполненностиЭлементаКлассификатора(Источник, ТекстОшибки)
	Тогда
		Отказ = Истина;
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
	КонецЕсли;
	
КонецПроцедуры

// Есть ли право на изменение элемента классификатора
//
// Параметры:
//  Элемент	 - СправочникСсылка, СправочникОбъект - ссылка на элемент классификатора ЕГИСЗ.
//  Причина	 - Строка	 - в этот параметр будет возвращено пояснение отказа.
// 
// Возвращаемое значение:
//  Булево - Истина, если право есть.
//
Функция ЕстьПравоНаИзменениеЭлементаКлассификатора(Элемент, Причина = "") Экспорт
	
	Если ИнтеграцияЕГИСЗОбщегоНазначенияПовтИсп.ДопустимоРедактированиеЭлементовЕГИСЗ() Тогда
		Возврат Истина;
	КонецЕсли;
	
	Отказ = Ложь;
	
	Ссылка = ?(ТипЗнч(Элемент) = Тип("СправочникСсылка.КлассификаторыМинЗдрава"), Элемент, Элемент.Ссылка);
	
	Если ЗначениеЗаполнено(Ссылка.УИДЕГИСЗ) Тогда
	
		Если ТипЗнч(Ссылка) = Тип("СправочникСсылка.КлассификаторыМинЗдрава") Тогда
			Причина = НСтр("ru='Элементы данного справочника не редактируются'"); 
			Возврат Ложь;	
		КонецЕсли;
		
		ЗаписьНастройки = РегистрыСведений.НастройкиОбновленияСправочниковЕГИСЗ.СоздатьМенеджерЗаписи();
		ЗаписьНастройки.Классификатор = Ссылка.OIDСправочникаИсточника;
		ЗаписьНастройки.Прочитать();
		РежимОбновления = ЗаписьНастройки.РежимОбновления;
		
		Отказ = ЗначениеЗаполнено(РежимОбновления) И РежимОбновления <> Перечисления.РежимыАвтоОбновленияСправочниковЕГИСЗ.Выключено;
		Причина = "Элементы данного справочника не редактируются, т.к. включена авто синхронизация с ФР НСИ ЕГИСЗ";
	КонецЕсли;
			
	Возврат Не Отказ;
		
КонецФункции

Процедура НастроитьДоступностьЭлементовКлассификатора(Объект, ЭлементыФормы) Экспорт
	
	Если Не ЕстьПравоНаИзменениеЭлементаКлассификатора(Объект) Тогда
		Для Каждого ЭлементФормы Из ЭлементыФормы Цикл
			ЭлементФормы.Доступность = Ложь;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Функция ЕстьОшибкиЗаполненностиЭлементаКлассификатора(Элемент, ТекстОшибки)
	
	Если ОбщегоНазначенияСервер.РежимРасширенныхВозможностейРедактированияДанных() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Попытка
		МодульМенеджера = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Элемент.Ссылка);
		Если Не МодульМенеджера.ТребуетсяПроверкаЗаполненностиЭлементаКлассификатораПередЗаписью(Элемент) Тогда
			Возврат Ложь;
		КонецЕсли;
	Исключение КонецПопытки;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Элемент, "OIDСправочникаИсточника")
		И Не ЗначениеЗаполнено(Элемент["OIDСправочникаИсточника"])
	Тогда
		ТекстОшибки = НСтр("ru='Элемент классификатора обязан содержать заполненный идентификатор классификатора (OID источника)'");
		Возврат Истина;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Элемент, "ВидКлассификатора")
		И Не ЗначениеЗаполнено(Элемент["ВидКлассификатора"])
	Тогда
		ТекстОшибки = НСтр("ru='Элемент классификатора обязан содержать заполненный вид классификатора'");
		Возврат Истина;
	КонецЕсли;
	
	//Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Элемент, "ВидСЭМД")
	//	И Не ЗначениеЗаполнено(Элемент["ВидСЭМД"])
	//Тогда
	//	ТекстОшибки = НСтр("ru='Элемент классификатора обязан содержать заполненный вид СЭМД'");
	//	Возврат Истина;
	//КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Элемент, "ВидДокумента")
		И Не ЗначениеЗаполнено(Элемент["ВидДокумента"])
	Тогда
		ТекстОшибки = НСтр("ru='Элемент классификатора обязан содержать заполненный вид документа'");
		Возврат Истина;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Элемент, "Роль")
		И Не ЗначениеЗаполнено(Элемент["Роль"])
	Тогда
		ТекстОшибки = НСтр("ru='Элемент классификатора обязан содержать заполненную роль'");
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПоместитьСообщениеВSOAPКонверт(URI, ТелоСообщения, ИдентификаторКлиента, УИДСообщения, ТипПакета)
	
	Результат = ТекстXMLSOAPКонверт(Не ЗначениеЗаполнено(ТипПакета));
	
	Результат = стрШаблон(
					Результат,
					ИдентификаторКлиента, // Идентификатор клиента
					ТипПакета,
					УИДСообщения, // Идентификатор сообщения
					URI,
					ТелоСообщения);
	
	Возврат Результат;
	
КонецФункции

// SOAP конверт.
Функция ТекстXMLSOAPКонверт(СокращенныйЗаголовок = Ложь, РежимОтладки = Ложь)
	
	ШаблонТекста =
	"<soap:Envelope
	|	xmlns:soap=""http://www.w3.org/2003/05/soap-envelope""
	|	xmlns:urn=""urn:hl7-org:v3""
	|	xmlns:a=""http://www.w3.org/2005/08/addressing"">
	|	<soap:Header>
	|		<transportHeader
	|			xmlns=""http://egisz.rosminzdrav.ru"">
	|			<authInfo>
	|				<clientEntityId>%1</clientEntityId>
	|			</authInfo>
	|		</transportHeader>
	|%2
	|%3
	|	</soap:Header>
	|	<soap:Body>
	|		%4
	|	</soap:Body>
	|</soap:Envelope>";
	
	ТекстРежимаОтладки = "";
	Если ИнтеграцияЕГИСЗСерверПовтИсп.ОтладочныйРежимРаботыЕГИСЗ() Тогда
		ТекстРежимаОтладки =
		"		<emdrTransportHeader xmlns=""http://egisz.rosminzdrav.ru/iehr/emdr/service/"">
		|			<trialMode>
		|				<option>skip_end_entity_certificate_validation</option>
		|			</trialMode>
		|		</emdrTransportHeader>";
	КонецЕсли;
	
	ТекстЗаголовка = "";
	Если Не СокращенныйЗаголовок Тогда
		ТекстЗаголовка = 
		"		<!--Тип запроса (идентификатор операции сервиса).-->
		|		<a:Action>%2</a:Action>
		|		<!--Уникальный ID сообщения. Должен быть указан в ответе на данный запрос-->
		|		<a:MessageID>urn:uuid:%3</a:MessageID>
		|		<!--При асинхронном запросе – URI сервиса обратного вызова (МИС), для отправки ответного сообщения-->
		|		<a:ReplyTo>
		|			<a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address>
		|		</a:ReplyTo>
		|		<!--Адрес конечной точки, куда отправляется данное сообщение-->
		|		<a:To>%4</a:To>"
	КонецЕсли;
	
	Возврат СтрШаблон(ШаблонТекста, "%1", ТекстРежимаОтладки, ТекстЗаголовка, "%5");

КонецФункции

Функция ОтправитьПоHTTP(Хост, АдресРесурса, ТекстЗапроса, ИспользоватьHttps, УИДСообщения, MSG_ID)
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/soap+xml;charset=UTF-8");
	Заголовки.Вставить("SOAPAction", "sendDocument");
	
	HTTPЗапрос = Новый HTTPЗапрос(АдресРесурса, Заголовки);
	HTTPЗапрос.УстановитьТелоИзСтроки(ТекстЗапроса, "UTF-8");
	
	Протокол = ?(ИспользоватьHttps, "HTTPS", "HTTP"); 
	ИнтернетПрокси = ПолучениеФайловИзИнтернетаКлиентСервер.ПолучитьПрокси(Протокол);
	
	Если ИспользоватьHttps Тогда
		HTTPСоединение = Новый HTTPСоединение(Хост,,,,ИнтернетПрокси,, Новый ЗащищенноеСоединениеOpenSSL);
	Иначе
		HTTPСоединение = Новый HTTPСоединение(Хост,,,,ИнтернетПрокси);
	КонецЕсли;
	
	Если MSG_ID <> Неопределено Тогда
		ЗаписатьВАрхивЛогов(Новый Структура("УИДСообщения, ТекстЗапроса", MSG_ID, HTTPЗапрос.ПолучитьТелоКакСтроку()));
	ИначеЕсли ИнтеграцияЕГИСЗСерверПовтИсп.СохранятьЛогСинхронныхСообщенийЕГИСЗ() Тогда
		ЗаписатьОбъектВЖурналРегистрации(HTTPЗапрос);
	КонецЕсли;
	
	HTTPОтвет = HTTPСоединение.ОтправитьДляОбработки(HTTPЗапрос);
	
	Если MSG_ID <> Неопределено Тогда
		ЗаписатьВАрхивЛогов(Новый Структура("УИДСообщения, ТекстЗапроса", MSG_ID, HTTPОтвет.ПолучитьТелоКакСтроку()));
	ИначеЕсли ИнтеграцияЕГИСЗСерверПовтИсп.СохранятьЛогСинхронныхСообщенийЕГИСЗ() Тогда
		ЗаписатьОбъектВЖурналРегистрации(HTTPОтвет);
	КонецЕсли;
	
	Возврат HTTPОтвет;
	
КонецФункции

Функция ПолучитьСтрокуПоXPath(ДокументDOM, Знач Разыменователь = Неопределено, XPath) Экспорт
	
	Если Неопределено = Разыменователь Тогда
		Разыменователь = ДокументDOM.СоздатьРазыменовательПИ();
	КонецЕсли;
	
	ТипРезультата = ТипРезультатаDOMXPath.Строка;
	
	РезультатXPath = ДокументDOM.ВычислитьВыражениеXPath(XPath, ДокументDOM, Разыменователь, ТипРезультата);
	
	Возврат РезультатXPath.СтроковоеЗначение;
	
КонецФункции

// Удаление из строки всех символов, не входящих в множество допустимых
//
// Параметры:
//   Строка - Строка -
//     Строка, из которой нужно удалить все символы, кроме заданных
//   МножествоДопустимыхСимволов - Строка -
//     Строка символов, которые не должны быть удалены из исходной строки.
//
// Возвращаемое значение:
//   Строка, из которой удалены все символы, не являющиеся допустимыи.
///
Функция УдалитьСимволыКроме(Знач Строка, МножествоДопустимыхСимволов) Экспорт
	
	ПодстрокиНедопустимыхСимволов = СтрРазделить(Строка, МножествоДопустимыхСимволов, Ложь);
	НедопустимыеСимволы = СтрСоединить(ПодстрокиНедопустимыхСимволов, "");
	
	КолВоПодстрок = ПодстрокиНедопустимыхСимволов.Количество();
	
	Если КолВоПодстрок < 13 И КолВоПодстрок * 4 < СтрДлина(НедопустимыеСимволы) Тогда
		// Выбираем алгоритм, в котром будем заменять недопустимые подстроки на пустые строки.
		
		Для Каждого Подстрока Из ПодстрокиНедопустимыхСимволов Цикл
			Строка = СтрЗаменить(Строка, Подстрока, "");
		КонецЦикла;
		
	Иначе
		// Выбираем алгоритм, в котором будем удалять недопустимые символы по одному.
		
		Пока СтрДлина(НедопустимыеСимволы) > 0 Цикл
			Символ = Сред(НедопустимыеСимволы, 1, 1);
			Строка = СтрЗаменить(Строка, Символ, "");
			НедопустимыеСимволы = СтрЗаменить(НедопустимыеСимволы, Символ, "");
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Строка;
	
КонецФункции

Функция ПолучитьТекстXML(Текст)
	
	Если Не ЗначениеЗаполнено(Текст) Тогда
		Возврат "";
	КонецЕсли;
	
	Попытка
		Парсер = Новый ЧтениеXML;
		Парсер.УстановитьСтроку(Текст);
		Построитель = Новый ПостроительDOM;
		XML = Построитель.Прочитать(Парсер);
		ЗаписьXML = Новый ЗаписьXML();
		ЗаписьXML.УстановитьСтроку();
		ЗаписьDOM = Новый ЗаписьDOM();
		ЗаписьDOM.Записать(XML, ЗаписьXML);
		Возврат ЗаписьXML.Закрыть();
	Исключение
		Возврат Текст;
	КонецПопытки;
	
КонецФункции

#КонецОбласти