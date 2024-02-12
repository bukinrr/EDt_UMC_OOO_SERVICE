#Область ПрограммныйИнтерфейс

#Область ЗагрузкаИзЕГИСЗ

// Возвращает идентификатор основного классификатора источника на сайте росминздрава.
// 
// Возвращаемое значение:
//   - Строка
//
Функция ПолучитьOIDСправочника() Экспорт
	Возврат "1.2.643.5.1.13.13.99.2.368";
КонецФункции

// Возвращает список альтернативных идентификаторов классификатора источника на сайте росминздрава.
// 
// Возвращаемое значение:
// 	Массив Из Строка
//
Функция ПолучитьАльтернативныеOID() Экспорт
	СписокOID = Новый Массив();
	СписокOID.Добавить("1.2.643.5.1.13.2.1.1.734");
	Возврат СписокOID;
КонецФункции

// Описывает соответствие между именем реквизита в классификаторе и его именем в базе 1С.
// 
// Возвращаемое значение:
//   - Соответствие.
//
Функция ПолучитьСопоставленийРеквизитовИXMLСправочникаЕГИСЗ() Экспорт
	
	Сопоставление = Новый Соответствие;
	
	//1) ID, Уникальный идентификатор, Целочисленное, Уникальный идентификатор (УИ), Обязательное;
	Сопоставление.Вставить("ID", "УИДЕГИСЗ");
	//2) CODE_ROLE, Код, Строковое, Код роли;
	Сопоставление.Вставить("CODE_ROLE", "Код");
	//3) NAME_ROLE, Наименование, Строковое, Наименование роли;
	Сопоставление.Вставить("NAME_ROLE", "Наименование");
	//4) SYNONYM, Синоним, Строковое, Альтернативное названия роли;
	Сопоставление.Вставить("SYNONYM", "Синоним");
	
	Возврат Сопоставление;

КонецФункции

// Возвращает массив структур, ключ которой - имя реквизита справочника, а значение - имя поля таблицы актуальных в общей форме загрузки.
// 
// Возвращаемое значение:
//   - Массив
//
Функция ПолучитьЗагружаемыеПоляЕГИСЗ() Экспорт
	
	Поля = Новый Структура;
	
	Поля.Вставить("Наименование","Наименование");
	Поля.Вставить("УИДЕГИСЗ", "УИДЕГИСЗ");
	Поля.Вставить("Код", "Код");
	Поля.Вставить("Синоним", "Синоним");
	
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

// Возвращает имя реквизита для дальнейшего заполнения в шаблоне параметра Code по нему
// 
// Возвращаемое значение:
//  Строка - имя реквизита код диагноза
//
Функция ПолучитьИмяРеквизитаDisplayNameИCode() Экспорт
	
	СтруктураВозвращаемогоЗначения = Новый Структура;
	СтруктураВозвращаемогоЗначения.Вставить("Code", "Код");
	Возврат СтруктураВозвращаемогоЗначения;
	
КонецФункции

#КонецОбласти