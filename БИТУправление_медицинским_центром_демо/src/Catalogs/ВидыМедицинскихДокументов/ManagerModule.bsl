#Область ПрограммныйИнтерфейс

#Область ЗагрузкаИзЕГИСЗ

// Возвращает идентификатор основного классификатора источника на сайте росминздрава.
// 
// Возвращаемое значение:
//   - Строка
//
Функция ПолучитьOIDСправочника() Экспорт
	Возврат "1.2.643.5.1.13.13.11.1522";
КонецФункции

// Возвращает список альтернативных идентификаторов классификатора источника на сайте росминздрава.
// 
// Возвращаемое значение:
// 	Массив Из Строка
//
Функция ПолучитьАльтернативныеOID() Экспорт
	СписокOID = Новый Массив();
	СписокOID.Добавить("1.2.643.5.1.13.13.99.2.195");
	СписокOID.Добавить("1.2.643.5.1.13.13.11.1115");
	СписокOID.Добавить("1.2.643.5.1.13.2.1.1.646");
	Возврат СписокOID;
КонецФункции

// Описывает соответствие между именем реквизита в классификаторе и его именем в базе 1С.
// 
// Возвращаемое значение:
//   - Соответствие.
//
Функция ПолучитьСопоставленийРеквизитовИXMLСправочникаЕГИСЗ() Экспорт
	
	Сопоставление = Новый Соответствие;
	
	//1) RECID, Уникальный идентификатор , Целочисленное, Уникальный идентификатор типа электронного медицинского документа, Обязательное;
	Сопоставление.Вставить("RECID", "УИДЕГИСЗ");
	//2) PARENT_ID, Код родительской записи, Целочисленное, Код родительской записи;
	Сопоставление.Вставить("PARENT_ID", "УИДЕГИСЗРодителя");
	//3) OID, Идентификатор OID , Строковое, Уникальный идентификатор типа электронного медицинского документа в формате OID;
	Сопоставление.Вставить("OID", "OIDКлассификатораМинздрава");
	//5) Name, Название, Строковое, Название медицинского документа;
	Сопоставление.Вставить("Name", "Наименование");
	//6) Synonym, Синоним, Строковое, Альтернативные названия СЭМДов;
	Сопоставление.Вставить("Synonym", "Синоним");
	//7) NPA, НПА, Строковое, Нормативно-правовой акт;
	Сопоставление.Вставить("NPA", "НПА");
	//10) Date_NPA, Дата НПА, Строковое, Дата принятия актуального нормативно-правового акта;
	Сопоставление.Вставить("Date_NPA", "ДатаНПА");
	//11) Form, Форма, Строковое, Номер утверждённой печатной формы документа;
	Сопоставление.Вставить("Form", "Форма");
	
	Возврат Сопоставление;

КонецФункции

// Дополнительные атрибуты классификатора для загрузки.
// 
// Возвращаемое значение:
//  Соответствие - дополнительные атрибуты.
//
Функция ПолучитьДополнительныеАтрибуты() Экспорт
	
	Поля = Новый Соответствие;
	
	//4) Synonym_OID, Синоним OID, Строковое, Дополнительный (синоним) уникальный идентификатор типа электронного медицинского документа в формате OID;
	Поля.Вставить("Synonym_OID", "Synonym_OID");
	//8) EXISTENCE_NPA, Признак наличия НПА, Логическое;
	Поля.Вставить("EXISTENCE_NPA", "EXISTENCE_NPA");
	//9) EXISTENCE_SEMD, Признак наличия СЭМД, Логическое, Обеспечена возможность отказа от их ведения в бумажном виде (разработан СЭМД или набор СЭМД). При помощи данного признака может быть рассчитано количество форм медицинских документов, для которых обеспечена возможность отказа от их ведения в бумажном виде (разработан структурированный электронный медицинский документ или набор структурированных медицинских документов), накопленных итогом на конец отчетного периода (S);
	Поля.Вставить("EXISTENCE_SEMD", "EXISTENCE_SEMD");
	//12) TYPE, Тип, Строковое, Тип медицинского документа: Документ, Карта, Журнал;
	Поля.Вставить("TYPE", "TYPE");
	//13) CODE_ZAGS_NALOG, Код ЕГР ЗАГС, Строковое, Соответствует кодам типовых элементов передаваемых сведений о государственной регистрации смерти "Сведения о пометке медицинского свидетельства о смерти" из Руководства пользователя "Вида сведений в единой системе межведомственного электронного взаимодействия «Представление сведений из ЕГР ЗАГС о государственной регистрации смерти органам исполнительной власти субъектов Российской Федерации»" (https://smev3.gosuslugi.ru/portal/inquirytype_one.jsp?id=136132&zone=reg&page=1&dTest=false);
	Поля.Вставить("CODE_ZAGS_NALOG", "CODE_ZAGS_NALOG");
	//14) ACTUAL, Актуальность, Логическое, Актуальность медицинского документа;
	Поля.Вставить("ACTUAL", "ACTUAL");
	//15) POSSIBILITY_SEMD, Возможность СЭМД, Логическое, Медицинский документ, для которого возможно ведение в форме СЭМД. При помощи данного признака может быть рассчитано общее количество утвержденных форм медицинских документов, действующих на конец отчетного периода (F), для которых возможен переход к ведению в форме структурированного электронного медицинского документа;
	Поля.Вставить("POSSIBILITY_SEMD", "POSSIBILITY_SEMD");
	
	Возврат Поля;
	
КонецФункции

// Возвращает массив структур, ключ которой - имя реквизита справочника, а значение - имя поля таблицы актуальных в общей форме загрузки.
// 
// Возвращаемое значение:
//   - Массив
//
Функция ПолучитьЗагружаемыеПоляЕГИСЗ() Экспорт
	
	Поля = Новый Структура;
	Поля.Вставить("Наименование","Наименование");
	Поля.Вставить("НаименованиеПолное","Наименование");
	Поля.Вставить("Синоним", "Синоним");
	Поля.Вставить("УИДЕГИСЗ", "УИДЕГИСЗ");
	Поля.Вставить("УИДЕГИСЗРодителя", "УИДЕГИСЗРодителя");
	Поля.Вставить("ДатаНПА", "ДатаНПА");
	Поля.Вставить("НПА", "НПА");
	Поля.Вставить("Форма", "Форма");
	Поля.Вставить("OIDКлассификатораМинздрава", "OIDКлассификатораМинздрава");
	Поля.Вставить("ВидСЭМД", "ВидСЭМД");
	
	Возврат Поля;
	
КонецФункции

// Порядок поиска существующих объектов при загрузке.
// 
// Возвращаемое значение:
//  Массив - реквизиты справочника в порядке поиска по ним.
//
Функция ПолучитьПорядокПоискаСуществующихОбъектов() Экспорт
	
	ПорядокПоиска = Новый Массив;
	
	ПоляПоиска = Новый Структура;
	ПоляПоиска.Вставить("УИДЕГИСЗ", "УИДЕГИСЗ");
	ПорядокПоиска.Добавить(ПоляПоиска);
	
	ПоляПоиска = Новый Структура;
	ПоляПоиска.Вставить("НаименованиеПолное", "Наименование");
	ПорядокПоиска.Добавить(ПоляПоиска);
	
	Возврат ПорядокПоиска;
	
КонецФункции

// Загрузка справочника: событие Перед поиском элемента классификатора в базе
//
// Параметры:
//  СтрокаКлассификатора - СтрокаТаблицыЗначений - строка классификатора.
//
Процедура ПередПоискомЭлементаКлассификатораВБазе(СтрокаКлассификатора) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КлассификаторыМинЗдраваАтрибуты.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.КлассификаторыМинЗдрава.Атрибуты КАК КлассификаторыМинЗдраваАтрибуты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КлассификаторыМинЗдрава КАК КлассификаторыМинЗдрава
		|		ПО (КлассификаторыМинЗдрава.Ссылка = КлассификаторыМинЗдраваАтрибуты.Ссылка)
		|			И (КлассификаторыМинЗдраваАтрибуты.Ссылка.ВидКлассификатора = ЗНАЧЕНИЕ(Перечисление.ВидыКлассификаторовМинЗдрава.ВидыСтруктурированныхЭлектронныхМедицинскихДокументов))
		|			И (КлассификаторыМинЗдраваАтрибуты.Ключ = ""TYPE"")
		|			И (НЕ КлассификаторыМинЗдрава.Архив)
		|			И (НЕ КлассификаторыМинЗдрава.ПометкаУдаления)
		|			И ((ВЫРАЗИТЬ(КлассификаторыМинЗдраваАтрибуты.Значение КАК СТРОКА(10))) = &УИДЕГИСЗ)";
	
	Запрос.УстановитьПараметр("УИДЕГИСЗ", Строка(СтрокаКлассификатора.УИДЕГИСЗ));
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		СтрокаКлассификатора.ВидСЭМД = Выборка.Ссылка;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти