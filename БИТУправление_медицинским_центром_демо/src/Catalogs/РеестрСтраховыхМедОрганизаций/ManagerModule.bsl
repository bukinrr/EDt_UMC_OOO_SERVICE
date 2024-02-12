#Область ПрограммныйИнтерфейс

#Область ЗагрузкаИзЕГИСЗ

// Возвращает идентификатор основного классификатора источника на сайте росминздрава.
// 
// Возвращаемое значение:
//   - Строка
//
Функция ПолучитьOIDСправочника() Экспорт
	Возврат "1.2.643.5.1.13.13.99.2.183";
КонецФункции

// Возвращает список альтернативных идентификаторов классификатора источника на сайте росминздрава.
// 
// Возвращаемое значение:
// 	Массив Из Строка
//
Функция ПолучитьАльтернативныеOID() Экспорт
	СписокOID = Новый Массив();
	СписокOID.Добавить("1.2.643.5.1.13.2.1.1.635");
	Возврат СписокOID;
КонецФункции

// Описывает соответствие между именем реквизита в классификаторе и его именем в базе 1С.
// 
// Возвращаемое значение:
//   - Соответствие.
//
Функция ПолучитьСопоставленийРеквизитовИXMLСправочникаЕГИСЗ() Экспорт
	
	Сопоставление = Новый Соответствие;
	
	//1) ID, ID, Целочисленное, Идентификатор, Обязательное;
	Сопоставление.Вставить("ID", "УИДЕГИСЗ");
	//3) OGRN, ОГРН, Строковое;
	Сопоставление.Вставить("OGRN", "ОГРН");
	//4) KPP, КПП, Строковое;
	Сопоставление.Вставить("KPP", "КПП");
	//5) NAM_SMOP, Полное наименование СМО, Строковое;
	Сопоставление.Вставить("NAM_SMOP", "ПолноеНаименование");
	//6) NAM_SMOK, Краткое наименование СМО, Строковое;
	Сопоставление.Вставить("NAM_SMOK", "Наименование");
	
	Возврат Сопоставление;
	
КонецФункции

// Дополнительные атрибуты классификатора для загрузки.
// 
// Возвращаемое значение:
//  Соответствие - дополнительные атрибуты.
//
Функция ПолучитьДополнительныеАтрибуты() Экспорт
	
	Поля = Новый Соответствие;
	
	//2) SMOCOD, Код СМО в едином реестре ОМС, Строковое;
	Поля.Вставить("SMOCOD", "SMOCOD");
	//7) ADDR_F, Фактический адрес, заданный в строку, Строковое;
	Поля.Вставить("ADDR_F", "ADDR_F");
	//8) FAM_RUK, Фамилия руководителя, Строковое;
	Поля.Вставить("FAM_RUK", "FAM_RUK");
	//9) IM_RUK, Имя руководителя, Строковое;
	Поля.Вставить("IM_RUK", "IM_RUK");
	//10) OT_RUK, Отчество руководителя, Строковое;
	Поля.Вставить("OT_RUK", "OT_RUK");
	//11) PHONE, Телефон (с кодом города), Строковое;
	Поля.Вставить("PHONE", "PHONE");
	//12) FAX, Факс (с кодом города), Строковое;
	Поля.Вставить("FAX", "FAX");
	//13) HOT_LINE, Телефон «горячей линии» СМО, Строковое;
	Поля.Вставить("HOT_LINE", "HOT_LINE");
	//14) E_MAIL, Адрес электронной почты, Строковое;
	Поля.Вставить("E_MAIL", "E_MAIL");
	//15) N_DOC, Номер лицензии СМО, Строковое;
	Поля.Вставить("N_DOC", "N_DOC");
	//16) D_START, Дата выдачи лицензии СМО, Дата;
	Поля.Вставить("D_START", "D_START");
	//17) DATE_E, Дата окончания действия лицензии СМО, Дата;
	Поля.Вставить("DATE_E", "DATE_E");
	//18) D_BEGIN, Дата включения в реестр СМО, Дата;
	Поля.Вставить("D_BEGIN", "D_BEGIN");
	//19) D_END, Дата исключения из реестра СМО, Дата;
	Поля.Вставить("D_END", "D_END");
	
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
	Поля.Вставить("ПолноеНаименование","ПолноеНаименование");
	Поля.Вставить("УИДЕГИСЗ", "УИДЕГИСЗ");
	Поля.Вставить("ОГРН", "ОГРН");
	Поля.Вставить("КПП", "КПП");
	
	Возврат Поля;
	
КонецФункции

// Формирует массив структур, ключи которых - поля для поиска существующих элементов при загрузки из ФР НСИ ЕГИСЗ,
//  а порядок в массиве - приоритет использования способов поиска.
// 
// Возвращаемое значение:
//  Массив - наборы ключей поиска.
//
Функция ПолучитьПорядокПоискаСуществующихОбъектов() Экспорт
	
	ПорядокПоиска = Новый Массив;
	
	ПоляПоиска = Новый Структура;
	ПоляПоиска.Вставить("УИДЕГИСЗ", "УИДЕГИСЗ");
	
	ПорядокПоиска.Добавить(ПоляПоиска);
	
	Возврат ПорядокПоиска;
	
КонецФункции

#КонецОбласти

// Возвращает имя реквизита для дальнейшего заполнения в шаблоне параметра DisplayName по нему
// 
// Возвращаемое значение:
//  Строка - имя реквизита полное наименование
//
Функция ПолучитьИмяРеквизитаDisplayNameИCode() Экспорт
	
	СтруктураВозвращаемогоЗначения = Новый Структура;
	СтруктураВозвращаемогоЗначения.Вставить("Name", "ПолноеНаименование");
	Возврат СтруктураВозвращаемогоЗначения;
	
КонецФункции

#КонецОбласти
