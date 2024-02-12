#Область ПрограммныйИнтерфейс

#Область ЗагрузкаИзЕГИСЗ

// Возвращает идентификатор основного классификатора источника на сайте росминздрава.
// 
// Возвращаемое значение:
//   - Строка
//
Функция ПолучитьOIDСправочника() Экспорт
	Возврат "1.2.643.5.1.13.13.99.2.611";
КонецФункции

// Описывает соответствие между именем реквизита в классификаторе и его именем в базе 1С.
// 
// Возвращаемое значение:
//   - Соответствие.
//
Функция ПолучитьСопоставленийРеквизитовИXMLСправочникаЕГИСЗ() Экспорт
	
	Сопоставление = Новый Соответствие;
	
	//1) smnn_code, Код_узла_СМНН, Строковое, Обязательное;
	Сопоставление.Вставить("SMNN_CODE", "Код");
	//2) standard_inn, Стандартизированное_МНН, Строковое;
	Сопоставление.Вставить("STANDARD_INN", "Наименование");
	//3) standard_form, Стандартизированная_лекарственная_форма, Строковое;
	Сопоставление.Вставить("STANDARD_FORM", "Форма");
	//4) standard_doze, Стандартизированная_лекарственная_доза, Строковое;
	Сопоставление.Вставить("STANDARD_DOZE", "Доза");
	//7) okei_code, Код_ОКЕИ_(потребительская_единица_измерения), Строковое;
	Сопоставление.Вставить("OKEI_CODE", "КодОКЕИ");
	//9) essential_medicines, ЖНВЛП, Строковое;
	Сопоставление.Вставить("ESSENTIAL_MEDICINES", "ЖНВЛС");
	//10) narcotic_psychotropic, Наличие_в_ЛП_наркотических_психотропных_веществ_и_их_прекурсоров, Строковое;
	Сопоставление.Вставить("NARCOTIC_PSYCHOTROPIC", "Наркотическое");
	//11) code_atc, Код_АТХ, Строковое;
	Сопоставление.Вставить("CODE_ATC", "КодАТХ");
	//12) name_atc, Наименование_АТХ, Строковое;
	Сопоставление.Вставить("NAME_ATC", "НаименованиеАТХ");
	
	Возврат Сопоставление;

КонецФункции

// Дополнительные атрибуты классификатора для загрузки.
// 
// Возвращаемое значение:
//  Соответствие - дополнительные атрибуты.
//
Функция ПолучитьДополнительныеАтрибуты() Экспорт
	
	Поля = Новый Соответствие;
	
	//5) ktru_code, Код_КТРУ, Строковое;
	Поля.Вставить("ktru_code", "ktru_code");
	//6) name_unit, Наименование_потребительской_единицы_измерения, Строковое;
	Поля.Вставить("name_unit", "name_unit");
	//8) okpd_2_code, Код_ОКПД2, Строковое;
	Поля.Вставить("okpd_2_code", "okpd_2_code");
	//13) tn, Наименование_ФТГ, Строковое;
	Поля.Вставить("tn", "tn");
	
	Возврат Поля;
	
КонецФункции

// Возвращает массив структур, ключ которой - имя реквизита справочника, а значение - имя поля таблицы актуальных в общей форме загрузки.
// 
// Возвращаемое значение:
//   - Массив
//
Функция ПолучитьЗагружаемыеПоляЕГИСЗ() Экспорт
	
	Поля = Новый Структура;
	Поля.Вставить("Код", "Код");
	Поля.Вставить("МНН", "Наименование");
	Поля.Вставить("Форма", "Форма");
	Поля.Вставить("Доза", "Доза");
	Поля.Вставить("КодАТХ", "КодАТХ");
	Поля.Вставить("НаименованиеАТХ", "НаименованиеАТХ");
	Поля.Вставить("КодОКЕИ", "КодОКЕИ");
	Поля.Вставить("ЖНВЛС", "ЖНВЛС");
	Поля.Вставить("Наркотическое", "Наркотическое");
	
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
	ПоляПоиска.Вставить("Код", "Код");
	
	ПорядокПоиска.Добавить(ПоляПоиска);
	
	Возврат ПорядокПоиска;
	
КонецФункции

// Загрузка справочника: событие перед загрузкой элемента.
//
// Параметры:
//  СтрокаДереваКлассификатора	 - СтрокаДереваЗначений	 - строка дерева классификатора
//  Родитель					 - Ссылка				 - группа
//  ДополнительныеСвойства		 - Структура			 - дополнительные свойства
//  OID							 - Строка				 - OID
//  Отказ						 - Булево				 - Отказ
// 
// Возвращаемое значение:
//  Строка - сообщение.
//
Функция ЗагрузкаСправочникаПередЗагрузкойЭлемента(СтрокаДереваКлассификатора, Родитель, ДополнительныеСвойства, OID, Отказ) Экспорт
	
	Отказ = ЗначениеЗаполнено(ДополнительныеСвойства.СтрокиНаУдаление.Найти(СтрокаДереваКлассификатора.Код));
	
КонецФункции

// Загрузка справочника: событие перед началом загрузки классификатора.
//
// Параметры:
//  ТаблицаКлассификатора	 - ТаблицаЗначений	 - таблица классификатора
//  OID						 - Строка			 - OID
//  ДополнительныеСвойства	 - Структура		 - дополнительные свойства.
//
Процедура ЗагрузкаСправочникаПередНачаломЗагрузки(ТаблицаКлассификатора, OID, ДополнительныеСвойства) Экспорт
	
	СтрокиНаУдаление = ТаблицаКлассификатора.НайтиСтроки(Новый Структура("Доза","~"));
	МассивКодов = Новый Массив;
	Для каждого СтрокаНаУдаление Из СтрокиНаУдаление Цикл
		МассивКодов.Добавить(СтрокаНаУдаление.Код);	
	КонецЦикла; 
	ДополнительныеСвойства.Вставить("СтрокиНаУдаление",МассивКодов);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
					|	СписокКодовЕдИзм.КодОКЕИ КАК КодОКЕИ
					|ПОМЕСТИТЬ СписокКодовОКЕИ
					|ИЗ
					|	&СписокКодовЕдИзм КАК СписокКодовЕдИзм
					|;
					|
					|////////////////////////////////////////////////////////////////////////////////
					|ВЫБРАТЬ РАЗЛИЧНЫЕ
					|	СписокКодовОКЕИ.КодОКЕИ КАК КодОКЕИ
					|ИЗ
					|	СписокКодовОКЕИ КАК СписокКодовОКЕИ";
	Запрос.УстановитьПараметр("СписокКодовЕдИзм",ТаблицаКлассификатора);
	Выборка = Запрос.Выполнить().Выбрать();
	ТаблицаЕдиницИзмерения = Новый ТаблицаЗначений;
	ТаблицаЕдиницИзмерения.Колонки.Добавить("Код", Новый ОписаниеТипов("Число"));
	ТаблицаЕдиницИзмерения.Колонки.Добавить("Ссылка", Новый ОписаниеТипов("СправочникСсылка.КлассификаторЕдиницИзмерения"));
	Пока Выборка.Следующий() Цикл
		ЭлементСправочника = Справочники.КлассификаторЕдиницИзмерения.ПолучитьЕдиницуИзмерения(Число(Выборка.КодОКЕИ));	
		Если ЗначениеЗаполнено(ЭлементСправочника) Тогда
			НоваяСтрока = ТаблицаЕдиницИзмерения.Добавить();
			НоваяСтрока.Код = Выборка.КодОКЕИ;
			НоваяСтрока.Ссылка = ЭлементСправочника;
		КонецЕсли; 
	КонецЦикла; 
	
	ДополнительныеСвойства.Вставить("ТаблицаЕдиницИзмерения",ТаблицаЕдиницИзмерения);
	
КонецПроцедуры

// Загрузка справочника: событие перед записью элемента справочника.
//
// Параметры:
//  ОбъектСправочника		 - СправочникОбъект	 - объект справочника
//  ДополнительныеСвойства	 - Структура		 - дополнительные свойства
//  СтрокаКлассификатора	 - СтрокаДереваЗначений	 - строка дерева классификатора
//  СообщениеОтказа			 - Строка				 - Сообщение отказа
//
Процедура ЗагрузкаСправочникаИзЕГИСЗПередЗаписью(ОбъектСправочника, ДополнительныеСвойства, СтрокаКлассификатора, СообщениеОтказа = "") Экспорт
	
	НаименованиеЭлемента = ТРег(ОбъектСправочника.МНН + " " 
										+ ОбъектСправочника.Форма + " "
										+ ОбъектСправочника.Доза);
	ОбъектСправочника.Наименование = НаименованиеЭлемента;
	
	СтрокаЕдИзм = ДополнительныеСвойства.ТаблицаЕдиницИзмерения.Найти(Число(ОбъектСправочника.КодОКЕИ),"Код");
	ОбъектСправочника.ЕдиницаИзмерения = СтрокаЕдИзм.Ссылка;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

