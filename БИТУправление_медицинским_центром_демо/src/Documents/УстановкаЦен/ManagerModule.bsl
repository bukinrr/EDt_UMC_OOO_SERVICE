#Область ПрограммныйИнтерфейс

// Перезаполняет цены в объекте по указанному прейскуранту
//
// Параметры:
//  Объект		 - ДокументОбъект.УстановкаЦен - объект документа для изменения операцией.
//  Прейскурант	 - СправочникСсылка.Прейскуранты - прайс для заполнения цен.
//
Процедура ПерезаполнитьПоПрейскуранту(Объект, Прейскурант) Экспорт
	
	МассивНоменклатуры = Новый Массив;
	МассивХарактеристик = Новый Массив;
	Для Каждого СтрокаТЧ Из Объект.Номенклатура Цикл
		МассивНоменклатуры.Добавить(СтрокаТЧ.Номенклатура);
		МассивХарактеристик.Добавить(СтрокаТЧ.ХарактеристикаНоменклатуры);
	КонецЦикла;
	Для Каждого СтрокаТЧ Из Объект.Сертификаты Цикл
		МассивНоменклатуры.Добавить(СтрокаТЧ.ВидСертификата); 
	КонецЦикла;
	МассивХарактеристик.Добавить(Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка());
	
	Запрос = Новый Запрос;	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Цены.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	Цены.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	Цены.Номенклатура КАК Номенклатура,
	|	Цены.Цена КАК Цена
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
	|			&Дата,
	|			Прейскурант = &Прейскурант
	|				И (Номенклатура В (&МассивНоменклатуры)
	|					И ХарактеристикаНоменклатуры В (&МассивХарактеристик))) КАК Цены"
	;
	
	Запрос.УстановитьПараметр("Дата",Объект.Дата);
	Запрос.УстановитьПараметр("Прейскурант",Прейскурант);
	Запрос.УстановитьПараметр("МассивНоменклатуры",МассивНоменклатуры);
	Запрос.УстановитьПараметр("МассивХарактеристик",МассивХарактеристик);
	
	ТЗ = Запрос.Выполнить().Выгрузить();
	Если ТЗ.Количество() = 0 Тогда
		Возврат;  
	КонецЕсли;
	
	Для Каждого СтрокаТЧ Из Объект.Номенклатура Цикл
		ЦенаПрейскуранта = 0;
		ПараметрыОтбора = Новый Структура;		
		ПараметрыОтбора.Вставить("Номенклатура", СтрокаТЧ.Номенклатура);
		ПараметрыОтбора.Вставить("ХарактеристикаНоменклатуры", СтрокаТЧ.ХарактеристикаНоменклатуры);
		РезультатОтбора = ТЗ.НайтиСтроки(ПараметрыОтбора);
		Если РезультатОтбора.Количество() <> 0 Тогда
			Для Каждого НайденнаяСтрока Из РезультатОтбора Цикл
				Если СтрокаТЧ.ЕдиницаИзмерения = НайденнаяСтрока.ЕдиницаИзмерения Тогда
					ЦенаПрейскуранта = НайденнаяСтрока.Цена;
				КонецЕсли; 	
			КонецЦикла;
			
			Если ЦенаПрейскуранта = 0 Тогда
				ЦенаВрем = ?(РезультатОтбора[0].ЕдиницаИзмерения.Коэффициент = 0, 0, РезультатОтбора[0].Цена / РезультатОтбора[0].ЕдиницаИзмерения.Коэффициент); 
				ЦенаПрейскуранта = ЦенаВрем * СтрокаТЧ.ЕдиницаИзмерения.Коэффициент;	
			КонецЕсли;
		КонецЕсли;
		Если СтрокаТЧ.Цена <> ЦенаПрейскуранта Тогда
			СтрокаТЧ.Цена = ЦенаПрейскуранта;
		КонецЕсли;
	КонецЦикла;	
	
	Для Каждого СтрокаТЧ Из Объект.Сертификаты Цикл
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Номенклатура", СтрокаТЧ.ВидСертификата);
		РезультатОтбора = ТЗ.НайтиСтроки(ПараметрыОтбора);
		Если РезультатОтбора.Количество() <> 0 Тогда
			ЦенаПрейскуранта = РезультатОтбора[0].Цена;
			Если СтрокаТЧ.Цена <> ЦенаПрейскуранта Тогда
				СтрокаТЧ.Цена = ЦенаПрейскуранта;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Дополняет строки в объекте ценами из указанного прейскуранта
//
// Параметры:
//  Объект		 - ДокументОбъект.УстановкаЦен	 - объект документа для изменения операцией.
//  Прейскурант	 - СправочникСсылка.Прейскуранты - прайс для заполнения цен.
//  Очистить	 - Булево						 - очистить ли текущие строки документа перед дополнением.
//
Процедура ДополнитьИзПрейскуранта(Объект, Прейскурант, Очистить = Ложь) Экспорт
	
	Отбор = Новый Структура("Прейскурант", Прейскурант);
	Цены = РегистрыСведений.ЦеныНоменклатуры.СрезПоследних(Объект.Дата, Отбор);
	Если Цены.Количество() = 0 Тогда
		Возврат;	
	КонецЕсли;
	
	Отбор = Новый Структура;
	МассивНайденного = Новый Массив;
	
	Если Очистить Тогда
		Объект.Номенклатура.Очистить();
		Объект.Сертификаты.Очистить();
	КонецЕсли;
	
	Для Каждого СтрокаТЧ Из Цены Цикл		
		Если Не Очистить Тогда
			Отбор.Очистить();
			МассивНайденного.Очистить();
			Если ТипЗнч(СтрокаТЧ.Номенклатура) = Тип("СправочникСсылка.Номенклатура") Тогда
				Отбор.Вставить("Номенклатура",               СтрокаТЧ.Номенклатура);
				Отбор.Вставить("ХарактеристикаНоменклатуры", СтрокаТЧ.ХарактеристикаНоменклатуры);
				Отбор.Вставить("ЕдиницаИзмерения",           СтрокаТЧ.ЕдиницаИзмерения);
				МассивНайденного = Объект.Номенклатура.НайтиСтроки(Отбор);
			ИначеЕсли ТипЗнч(СтрокаТЧ.Номенклатура) = Тип("СправочникСсылка.ВидыСертификатов") Тогда
				Отбор.Вставить("ВидСертификата", СтрокаТЧ.Номенклатура);
				МассивНайденного = Объект.Сертификаты.НайтиСтроки(Отбор);
			КонецЕсли;
			Если МассивНайденного.Количество() > 0 Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		Если СтрокаТЧ.Номенклатура.ПометкаУдаления
			Или (ТипЗнч(СтрокаТЧ.Номенклатура) = Тип("СправочникСсылка.Номенклатура") И СтрокаТЧ.Номенклатура.Архив)
		Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТипЗнч(СтрокаТЧ.Номенклатура) = Тип("СправочникСсылка.Номенклатура") Тогда
			НоваяСтрока = Объект.Номенклатура.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЧ);
		ИначеЕсли ТипЗнч(СтрокаТЧ.Номенклатура) = Тип("СправочникСсылка.ВидыСертификатов") Тогда
			НоваяСтрока = Объект.Сертификаты.Добавить();
			НоваяСтрока.ВидСертификата = СтрокаТЧ.Номенклатура;
			НоваяСтрока.Цена           = СтрокаТЧ.Цена;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Дополняет строки товарами поступлений со срезом цен последних поступлений.
//
// Параметры:
//  Объект		 - ДокументОбъект.УстановкаЦен	 - объект документа для изменения операцией.
//  Очистить	 - Булево						 - очистить ли текущие строки документа перед дополнением.
//
Процедура ДополнитьИзДокументовПоступления(Объект,Очистить = Ложь) Экспорт
	
	ЦеныПоступления = ПолучитьЦеныПоступления(Объект);
	Если ЦеныПоступления = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Очистить Тогда
		Объект.Номенклатура.Очистить();
	КонецЕсли;
	
	Для Каждого СтрокаТЧ Из ЦеныПоступления Цикл		
		Отбор = Новый Структура;
		Отбор.Вставить("Номенклатура",               СтрокаТЧ.Номенклатура);
		Отбор.Вставить("ХарактеристикаНоменклатуры", СтрокаТЧ.ХарактеристикаНоменклатуры);
		Отбор.Вставить("ЕдиницаИзмерения",           СтрокаТЧ.ЕдиницаИзмерения);
		
		Если Не Очистить Тогда
			РезПоиска = Новый Массив;
			РезПоиска = Объект.Номенклатура.НайтиСтроки(Отбор);
			Если РезПоиска.Количество() > 0 Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли; 	
		
		НоваяСтрока = Объект.Номенклатура.Добавить();		
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЧ);		
	КонецЦикла;
КонецПроцедуры

// Дополняет строки в объекте остатками на указанном складе
//
// Параметры:
//  Объект - ДокументОбъект.УстановкаЦен - объект документа для изменения операцией.
//  Склад  - СправочникСсылка.Склады - склад, чьи остатки смотрим.
//
Процедура ДополнитьПоОстаткамНаСкладе(Объект, Склад) Экспорт
	
	ЗапросОстатки = Новый Запрос;
	ЗапросЦены = Новый Запрос;
	
	ЗапросОстатки.Текст = 
	"ВЫБРАТЬ
	|	ПартииОстатки.Номенклатура КАК Номенклатура,
	|	ПартииОстатки.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры
	|ИЗ
	|	РегистрНакопления.ПартииТоваровНаСкладах.Остатки(&Дата, Склад = &Склад) КАК ПартииОстатки
	|ГДЕ
	|	ПартииОстатки.КоличествоОстаток > 0";
	
	ЗапросЦены.Текст = 
	"ВЫБРАТЬ
	|	Цены.Номенклатура КАК Номенклатура,
	|	Цены.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	Цены.Цена КАК Цена,
	|	Цены.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&Дата, Прейскурант = &Прейскурант) КАК Цены";
	
	ЗапросОстатки.УстановитьПараметр("Дата",Объект.Дата);
	ЗапросОстатки.УстановитьПараметр("Склад",Склад);	
	ВыбОстатки = ЗапросОстатки.Выполнить().Выбрать();
	
	ЗапросЦены.УстановитьПараметр("Дата",Объект.Дата);
	ЗапросЦены.УстановитьПараметр("Прейскурант",Объект.Прейскурант);
	ВыбЦены = ЗапросЦены.Выполнить().Выбрать();
	
	Пока ВыбОстатки.Следующий() Цикл
		
		Строка = Новый Структура ("Номенклатура, ХарактеристикаНоменклатуры, ЕдиницаИзмерения, Цена");
		Строка.Номенклатура = ВыбОстатки.Номенклатура;
		Строка.ХарактеристикаНоменклатуры = ВыбОстатки.ХарактеристикаНоменклатуры;
		
		СтуктураПоиска = Новый Структура("Номенклатура, ХарактеристикаНоменклатуры");
		СтуктураПоиска.Номенклатура = ВыбОстатки.Номенклатура;
		СтуктураПоиска.ХарактеристикаНоменклатуры = ВыбОстатки.ХарактеристикаНоменклатуры;
		
		ЦенаНайдена = Ложь;
		ВыбЦены.Сбросить();
		Пока ВыбЦены.НайтиСледующий(СтуктураПоиска) Цикл
			Строка.ЕдиницаИзмерения = ВыбЦены.ЕдиницаИзмерения;
			Строка.Цена = ВыбЦены.Цена;
			ДобавитьУникальнуюСтрокуВУстановкуЦен(Объект, Строка);
			ЦенаНайдена = Истина;
		КонецЦикла;		
		
		Если ЦенаНайдена = Ложь Тогда
			Если ЗначениеЗаполнено(ВыбОстатки.Номенклатура.ЕдиницаТоваров) Тогда
				Строка.ЕдиницаИзмерения = ВыбОстатки.Номенклатура.ЕдиницаТоваров;
			Иначе
				Строка.ЕдиницаИзмерения = ВыбОстатки.Номенклатура.ЕдиницаХраненияОстатков;
			КонецЕсли;
			СтуктураПоиска = Новый Структура("Номенклатура, ЕдиницаИзмерения");
			СтуктураПоиска.Номенклатура = ВыбОстатки.Номенклатура;
			СтуктураПоиска.ЕдиницаИзмерения = Строка.ЕдиницаИзмерения;
			ВыбЦены.Сбросить();
			Если ЗначениеЗаполнено(ВыбОстатки.ХарактеристикаНоменклатуры) И ВыбЦены.НайтиСледующий(СтуктураПоиска) Тогда
				Строка.Цена = ВыбЦены.Цена;
			КонецЕсли;
			ДобавитьУникальнуюСтрокуВУстановкуЦен(Объект, Строка);
		КонецЕсли;			
	КонецЦикла;
	
КонецПроцедуры

// Дополняет строки в объекте остатками на указанном складе
//
// Параметры:
//  Объект - ДокументОбъект.УстановкаЦен - объект документа для изменения операцией.
//  Склад  - СправочникСсылка.Склады - склад, чьи остатки смотрим.
//
Процедура ДополнитьПоОстаткамНаСкладеВУчетныхЦенах(Объект, Склад) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПартииОстатки.Номенклатура КАК Номенклатура,
	|	ПартииОстатки.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ПартииОстатки.Номенклатура.ЕдиницаХраненияОстатков КАК ЕдиницаИзмерения,
	|	ПартииОстатки.СуммаОстаток КАК Сумма,
	|	ПартииОстатки.КоличествоОстаток КАК Количество
	|ИЗ
	|	РегистрНакопления.ПартииТоваровНаСкладах.Остатки(&Дата, Склад = &Склад) КАК ПартииОстатки
	|ГДЕ
	|	ПартииОстатки.КоличествоОстаток > 0";
	
	Запрос.УстановитьПараметр("Дата",Объект.Дата);
	Запрос.УстановитьПараметр("Склад",Склад);	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ДобавитьУникальнуюСтрокуВУстановкуЦен(Объект, Выборка);
	КонецЦикла;
	
КонецПроцедуры

// Перезаполняет цены в объекте срезом цен последних поступлений.
//
// Параметры:
//  Объект		 - ДокументОбъект.УстановкаЦен	 - объект документа для изменения операцией.
//
Процедура ПерезаполнитьПоЦенамПоступления(Объект) Экспорт
	
	ЦеныПоступления = ПолучитьЦеныПоступления(Объект);	
	Если ЦеныПоступления = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Отбор = Новый Структура;
	Для Каждого СтрокаТЧ Из Объект.Номенклатура Цикл
		Отбор.Очистить();
		Отбор.Вставить("Номенклатура",               СтрокаТЧ.Номенклатура);
		Отбор.Вставить("ХарактеристикаНоменклатуры", СтрокаТЧ.ХарактеристикаНоменклатуры);
		ТЗ = ЦеныПоступления.НайтиСтроки(Отбор);
		Если ТЗ.Количество() = 0 Тогда
			Продолжить;	
		КонецЕсли;
		
		Цена = 0;
		Для Каждого НайденнаяСтрока Из ТЗ Цикл
			Если НайденнаяСтрока.ЕдиницаИзмерения = СтрокаТЧ.ЕдиницаИзмерения Тогда
				Цена = НайденнаяСтрока.Цена;	
			КонецЕсли; 	
		КонецЦикла;
		
		Если Цена = 0 Тогда
			ЦенаВрем = ?(ТЗ[0].ЕдиницаИзмерения.Коэффициент = 0, 0, ТЗ[0].Цена / ТЗ[0].ЕдиницаИзмерения.Коэффициент); 
			Цена = ЦенаВрем * СтрокаТЧ.ЕдиницаИзмерения.Коэффициент;	
		КонецЕсли;
		
		Если СтрокаТЧ.Цена <> Цена Тогда
			СтрокаТЧ.Цена = Цена;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Дополняет строки в объекте из указанной группы номенклатуры
//
// Параметры:
//  Объект	 - ДокументОбъект.УстановкаЦен	 - объект документа для изменения операцией.
//  Группа	 - СправочникСсылка.Номенклатура - прайс для заполнения цен.
//
Процедура ДобавитьНоменклатуруВДокументПоГруппе(Объект, Группа) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СправочникНоменклатура.Ссылка КАК Номенклатура,
	|	СправочникНоменклатура.ЕдиницаХраненияОстатков КАК ЕдиницаИзмерения,
	|	ЕСТЬNULL(Цены.Цена, 0) КАК Цена,
	|	ЕСТЬNULL(Цены.ХарактеристикаНоменклатуры, ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)) КАК ХарактеристикаНоменклатуры
	|ИЗ
	|	Справочник.Номенклатура КАК СправочникНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&Дата, Прейскурант = &Прейскурант) КАК Цены
	|		ПО (Цены.Номенклатура = СправочникНоменклатура.Ссылка)
	|			И (Цены.ЕдиницаИзмерения = СправочникНоменклатура.ЕдиницаХраненияОстатков)
	|ГДЕ
	|	СправочникНоменклатура.Ссылка В ИЕРАРХИИ(&Группа)
	|	И НЕ СправочникНоменклатура.ЭтоГруппа
	|	И НЕ СправочникНоменклатура.ПометкаУдаления
	|	И НЕ СправочникНоменклатура.Архив"
	;
	
	Запрос.УстановитьПараметр("Дата",Объект.Дата);
	Запрос.УстановитьПараметр("Ссылка",Объект.Ссылка);
	Запрос.УстановитьПараметр("Группа",Группа);
	Запрос.УстановитьПараметр("Прейскурант",Объект.Прейскурант);
	Выб = Запрос.Выполнить().Выбрать();
	
	Отбор   = Новый Структура("Номенклатура,ХарактеристикаНоменклатуры,ЕдиницаИзмерения");
	ОтборБХ = Новый Структура("Номенклатура,ЕдиницаИзмерения");
	Пока Выб.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(Отбор,Выб);
		Если Объект.Номенклатура.НайтиСтроки(Отбор).Количество() = 0 Тогда
			ЗаполнитьЗначенияСвойств(ОтборБХ,Отбор);
			Если Не (Выб.ХарактеристикаНоменклатуры.Пустая()
				И Не Объект.Номенклатура.НайтиСтроки(ОтборБХ).Количество() = 0)
			Тогда
				ЗаполнитьЗначенияСвойств(Объект.Номенклатура.Добавить(),Выб);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Перезаполняет в документе кононку цены сравнения из заданного прайса
//
// Параметры:
//  Объект				 - ДокументОбъект.УстановкаЦен	 - объект документа для изменения операцией.
//  ПрейскурантСравнения - СправочникСсылка.Прейскуранты - прайс для заполнения цен.
//  ДатаСравнения		 - Дата							 - дата, на которую берём цены из прайса для сравнения.
//
Процедура ПерезаполнитьЦеныСравнения(Объект, ПрейскурантСравнения, ДатаСравнения) Экспорт
	
	ОчиститьЦеныСравнения(Объект);
	Если ВидСравнения = "Прейскурант" И ЗначениеЗаполнено(ПрейскурантСравнения) Тогда
		ПерезаполнитьЦеныСравненияПоПрейскурантуНаДату(Объект, ПрейскурантСравнения, ДатаСравнения);		
	ИначеЕсли ВидСравнения = "Поступление" Тогда
		ПерезаполнитьЦеныСравненияПоПоследнемуПоступлению(Объект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьУникальнуюСтрокуВУстановкуЦен(Объект, Строка)
	
	Отбор = Новый Структура;
	Отбор.Вставить("Номенклатура",               Строка.Номенклатура);
	Отбор.Вставить("ХарактеристикаНоменклатуры", Строка.ХарактеристикаНоменклатуры);
	Отбор.Вставить("ЕдиницаИзмерения", 			 Строка.ЕдиницаИзмерения);
	РезПоиска = Объект.Номенклатура.НайтиСтроки(Отбор);
	Если РезПоиска.Количество() = 0 Тогда
		НоваяСтрока = Объект.Номенклатура.Добавить();		
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьЦеныПоступления(Объект)
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ДатыПоследнихПоступлений.Номенклатура,
	|	ДатыПоследнихПоступлений.ХарактеристикаНоменклатуры,
	|	ДатыПоследнихПоступлений.ЕдиницаИзмерения,
	|	Товары.Цена
	|ИЗ
	|	(ВЫБРАТЬ
	|		Товары.Номенклатура КАК Номенклатура,
	|		МАКСИМУМ(Товары.Ссылка.Дата) КАК Дата,
	|		Товары.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|		Товары.ЕдиницаИзмерения КАК ЕдиницаИзмерения
	|	ИЗ
	|		Документ.%Док%.Товары КАК Товары
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СпрНом
	|			ПО Товары.Номенклатура = СпрНом.Ссылка
	|	ГДЕ
	|		Товары.Ссылка.Дата <= &Дата
	|		И Товары.Ссылка.Проведен
	|		И НЕ Товары.Номенклатура.ПометкаУдаления
	|		И НЕ Товары.Номенклатура.Архив
	|	
	|	СГРУППИРОВАТЬ ПО
	|		Товары.Номенклатура,
	|		Товары.ХарактеристикаНоменклатуры,
	|		Товары.ЕдиницаИзмерения) КАК ДатыПоследнихПоступлений
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.%Док%.Товары КАК Товары
	|		ПО ДатыПоследнихПоступлений.Дата = Товары.Ссылка.Дата
	|			И ДатыПоследнихПоступлений.Номенклатура = Товары.Номенклатура
	|			И ДатыПоследнихПоступлений.ХарактеристикаНоменклатуры = Товары.ХарактеристикаНоменклатуры
	|			И ДатыПоследнихПоступлений.ЕдиницаИзмерения = Товары.ЕдиницаИзмерения";	
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Дата", Объект.Дата);
	Запрос.Текст = СтрЗаменить(ТекстЗапроса, "%Док%", "ПоступлениеТоваровУслуг");
	РезПоступления = Запрос.Выполнить();
	
	Если РезПоступления.Пустой() Тогда
		Запрос.Текст = СтрЗаменить(ТекстЗапроса, "%Док%", "ОприходованиеТоваров");
		РезОприходования = Запрос.Выполнить();
		
		Если РезОприходования.Пустой() Тогда
			Возврат Неопределено;
		Иначе
			ТЗ = РезОприходования.Выгрузить();
		КонецЕсли;
	Иначе
		ТЗ = РезПоступления.Выгрузить();
	КонецЕсли;
	
	Возврат ТЗ;	
КонецФункции

Процедура ОчиститьЦеныСравнения(Объект)
	
	Для Каждого СтрокаТЧ Из Объект.Номенклатура Цикл
		СтрокаТЧ.СравниваемаяЦена = 0;
		СтрокаТЧ.Разница          = 0;
		СтрокаТЧ.Отношение        = 0;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПерезаполнитьЦеныСравненияПоПрейскурантуНаДату(Объект, Прейскурант, Дата)
	
	Для Каждого СтрокаТЧ Из Объект.Номенклатура Цикл
		
		Отбор = Новый Структура;
		Отбор.Вставить("Прейскурант",                Прейскурант);
		Отбор.Вставить("Номенклатура",               СтрокаТЧ.Номенклатура);
		Отбор.Вставить("ХарактеристикаНоменклатуры", СтрокаТЧ.ХарактеристикаНоменклатуры);
		Отбор.Вставить("ЕдиницаИзмерения",           СтрокаТЧ.ЕдиницаИзмерения);	
		Цены  = РегистрыСведений.ЦеныНоменклатуры.СрезПоследних(?(Дата = '00010101', Объект.Дата, Дата), Отбор);
		
		Если Цены.Количество() = 0 Тогда
			СтрокаТЧ.СравниваемаяЦена = 0;
			СтрокаТЧ.Разница          = 0;
			СтрокаТЧ.Отношение        = 0;
			Продолжить;	
		КонецЕсли;
		
		ЦенаПрейскуранта = Цены[0].Цена;
		Если СтрокаТЧ.СравниваемаяЦена <> ЦенаПрейскуранта Тогда
			СтрокаТЧ.СравниваемаяЦена = ЦенаПрейскуранта;
			СтрокаТЧ.Разница          = СтрокаТЧ.Цена - СтрокаТЧ.СравниваемаяЦена;
			СтрокаТЧ.Отношение        = ?(СтрокаТЧ.СравниваемаяЦена = 0, 0, СтрокаТЧ.Цена/СтрокаТЧ.СравниваемаяЦена*100);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПерезаполнитьЦеныСравненияПоПоследнемуПоступлению(Объект)
	
	ЦеныПоступления = ПолучитьЦеныПоступления(Объект);
	Для Каждого СтрокаТЧ Из Объект.Номенклатура Цикл
		Отбор = Новый Структура;
		Отбор.Вставить("Номенклатура",               СтрокаТЧ.Номенклатура);
		Отбор.Вставить("ХарактеристикаНоменклатуры", СтрокаТЧ.ХарактеристикаНоменклатуры);
		Отбор.Вставить("ЕдиницаИзмерения",           СтрокаТЧ.ЕдиницаИзмерения);
		
		ТЗ = ЦеныПоступления.НайтиСтроки(Отбор);
		Если ТЗ.Количество() = 0 Тогда
			СтрокаТЧ.СравниваемаяЦена = 0;
			СтрокаТЧ.Разница          = 0;
			СтрокаТЧ.Отношение        = 0;
			Продолжить;	
		КонецЕсли;
		
		Цена = ТЗ[0].Цена;
		Если СтрокаТЧ.СравниваемаяЦена <> Цена Тогда
			СтрокаТЧ.СравниваемаяЦена = Цена;
			СтрокаТЧ.Разница          = СтрокаТЧ.Цена - СтрокаТЧ.СравниваемаяЦена;
			СтрокаТЧ.Отношение        = ?(СтрокаТЧ.СравниваемаяЦена = 0, 0, СтрокаТЧ.Цена/СтрокаТЧ.СравниваемаяЦена*100);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти