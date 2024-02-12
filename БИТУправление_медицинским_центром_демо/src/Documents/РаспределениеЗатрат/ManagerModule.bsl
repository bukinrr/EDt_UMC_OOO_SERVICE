#Область ПрограммныйИнтерфейс

// Заполняет список затрат и распределяет их.
//
// Параметры:
//  ДокументОбъект	 - ДокументОбъект.РаспределениеЗатрат - Заполняемый документ.
//
Процедура ПерезаполнениеРаспределенияЗатрат(ДокументОбъект) Экспорт 
	
	ЗаполнитьЗатратыДокумента(ДокументОбъект);
	РаспределитьЗатратыДокумента(ДокументОбъект);
	
КонецПроцедуры

// Заполняет список затрат документа.
//
// Параметры:
//  ДокументОбъект	 - ДокументОбъект.РаспределениеЗатрат - Заполняемый документ.
//
Процедура ЗаполнитьЗатратыДокумента(ДокументОбъект) Экспорт
	
	Если Ложь Тогда ДокументОбъект = Документы.РаспределениеЗатрат.СоздатьДокумент() КонецЕсли;
	
	Если ДокументОбъект.Проведен Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Необходимо отменить проведение документа перед заполнением затрат.'"));
		Возврат;
	ИначеЕсли Не ЗначениеЗаполнено(ДокументОбъект.ВидОперации) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не указан вид операции документа распределения затрат.'"));
		Возврат;
	КонецЕсли;
	
	ДокументОбъект.Затраты.Очистить();
	ДокументОбъект.Распределение.Очистить();
	
	// Получение затрат
	Затраты = ПолучитьЗатратыКРаспределению(ДокументОбъект.Дата, ДокументОбъект.ВидОперации);
	
	Если Затраты <> Неопределено Тогда
		ДокументОбъект.Затраты.Загрузить(Затраты);
	КонецЕсли;
	
КонецПроцедуры

// Распределяет затраты документа.
//
// Параметры:
//  ДокументОбъект	 - ДокументОбъект.РаспределениеЗатрат - Заполняемый документ.
//
Процедура РаспределитьЗатратыДокумента(ДокументОбъект) Экспорт
	
	Если Ложь Тогда ДокументОбъект = Документы.РаспределениеЗатрат.СоздатьДокумент() КонецЕсли;
	
	ДокументОбъект.Распределение.Очистить();
	
	// Очистка колонки ОшибкаРаспределения
	Затраты = ДокументОбъект.Затраты.Выгрузить();
	Затраты.ЗаполнитьЗначения("", "ОшибкаРаспределения");
	ДокументОбъект.Затраты.Загрузить(Затраты);
	
	// Распрелеление затрат
	Распределение = РаспределитьЗатраты(ДокументОбъект);
	
	Если Распределение <> Неопределено Тогда
		ДокументОбъект.Распределение.Загрузить(Распределение);
		
		Если Затраты.Количество() <> Затраты.НайтиСтроки(Новый Структура("ОшибкаРаспределения","")).Количество() Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьОбОшибке(НСтр("ru='Не все затраты были распределены.'"));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Формирует отчет ошибок распределения.
//
// Параметры:
//  ДокументОбъект	 - ДокументСсылка.РаспределениеЗатрат	 - проверяемый документ.
// 
// Возвращаемое значение:
//  ТабличныйДокумент.
//
Функция ПолучитьОтчетОшибкиРаспределения(ДокументОбъект) Экспорт
	
	ТаблицаЗатраты = ДокументОбъект.Затраты.Выгрузить().СкопироватьКолонки();
	
	ВидОперации = ДокументОбъект.ВидОперации;
	
	Если ВидОперации = Перечисления.ВидыОперацийРаспределениеЗатрат.РаспределениеЗатратФилиаловНаСпециализации Тогда
		СуффикОбласти = "Филиалы";
	Иначе
		СуффикОбласти = "Направления";
	КонецЕсли;
	
	Для Каждого СтрокаЗатраты Из ДокументОбъект.Затраты Цикл
		ЗаполнитьЗначенияСвойств(ТаблицаЗатраты.Добавить(), СтрокаЗатраты);
	КонецЦикла;
	
	ТаблицаОшибки = ТаблицаЗатраты.Скопировать(,"ОшибкаРаспределения");
	ТаблицаОшибки.Свернуть("ОшибкаРаспределения","");
	Отбор = Новый Структура("ОшибкаРаспределения");
	
	ТабДок = Новый ТабличныйДокумент;
	Макет = Документы.РаспределениеЗатрат.ПолучитьМакет("ОшибкиРаспределения");
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы" + СуффикОбласти);
	ОбластьОшибка		= Макет.ПолучитьОбласть("Ошибка" + СуффикОбласти);
	ОбластьСтрока		= Макет.ПолучитьОбласть("Строка" + СуффикОбласти);
	
	ОбластьШапка.Параметры.Документ = ДокументОбъект.Ссылка;
	ТабДок.Вывести(ОбластьШапка);
	ТабДок.Вывести(ОбластьШапкаТаблицы);
	
	ТабДок.НачатьАвтогруппировкуСтрок();
	Для Каждого СтрокаОшибки Из ТаблицаОшибки Цикл
		
		Если ПустаяСтрока(СтрокаОшибки.ОшибкаРаспределения) Тогда
			Продолжить;
		КонецЕсли;
		
		ОбластьОшибка.Параметры.ОшибкаРаспределения = СтрокаОшибки.ОшибкаРаспределения;
		ТабДок.Вывести(ОбластьОшибка,1);
		
		Отбор.ОшибкаРаспределения = СтрокаОшибки.ОшибкаРаспределения;
		СтрокиЗатрат = ТаблицаЗатраты.НайтиСтроки(Отбор);
		Для Каждого СтрокаЗатраты Из СтрокиЗатрат Цикл
			ОбластьСтрока.Параметры.Заполнить(СтрокаЗатраты);
			ТабДок.Вывести(ОбластьСтрока,2);
		КонецЦикла;
	КонецЦикла;
	ТабДок.ЗакончитьАвтогруппировкуСтрок();
	
	Возврат ТабДок;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьЗатратыКРаспределению(Дата, ВидОперации)
	
	Если ВидОперации = Перечисления.ВидыОперацийРаспределениеЗатрат.РаспределениеЗатратФилиаловНаСпециализации Тогда
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ЗатратыОбороты.СтатьяЗатрат КАК СтатьяЗатрат,
		|	ЗатратыОбороты.Филиал КАК Филиал,
		|	ЗатратыОбороты.СуммаОборот КАК Сумма,
		|	ЗНАЧЕНИЕ(Перечисление.ИсточникиЗаполненияЗатрат.ПрочиеЗатраты) КАК ИсточникЗаполненияЗатрат
		|ИЗ
		|	РегистрНакопления.Затраты.Обороты(&ДатаНачала, &ДатаОкончания, , КатегорияВыработки = &ПустоеНаправление И НоменклатураПолучатель = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)) КАК ЗатратыОбороты
		|
		|УПОРЯДОЧИТЬ ПО
		|	СтатьяЗатрат,
		|	Филиал"
		;
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийРаспределениеЗатрат.РаспределениеЗатратСпециализацийНаНоменклатуру Тогда
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ЗатратыОбороты.СтатьяЗатрат КАК СтатьяЗатрат,
		|	ЗатратыОбороты.Филиал КАК Филиал,
		|	ЗатратыОбороты.КатегорияВыработки КАК Специализация,
		|	ЗатратыОбороты.СуммаОборот КАК Сумма,
		|	ЗНАЧЕНИЕ(Перечисление.ИсточникиЗаполненияЗатрат.ПрочиеЗатраты) КАК ИсточникЗаполненияЗатрат
		|ИЗ
		|	РегистрНакопления.Затраты.Обороты(&ДатаНачала, &ДатаОкончания, , КатегорияВыработки <> &ПустоеНаправление И НоменклатураПолучатель = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)) КАК ЗатратыОбороты
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	РаспределениеЗатратОбороты.СтатьяЗатрат,
		|	РаспределениеЗатратОбороты.Филиал,
		|	РаспределениеЗатратОбороты.Специализация,
		|	РаспределениеЗатратОбороты.СуммаОборот,
		|	ЗНАЧЕНИЕ(Перечисление.ИсточникиЗаполненияЗатрат.РаспределенныеЗатраты) КАК ИсточникЗаполненияЗатрат
		|ИЗ
		|	РегистрНакопления.РаспределениеЗатрат.Обороты(&ДатаНачала, &ДатаОкончания, , Номенклатура = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)) КАК РаспределениеЗатратОбороты
		|
		|УПОРЯДОЧИТЬ ПО
		|	СтатьяЗатрат,
		|	Филиал,
		|	Специализация,
		|	ИсточникЗаполненияЗатрат"
		;
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("ПустоеНаправление", Справочники.КатегорииВыработки.ПустаяСсылка());
	Запрос.УстановитьПараметр("ДатаНачала", НачалоМесяца(Дата));
	Запрос.УстановитьПараметр("ДатаОкончания", КонецМесяца(Дата));
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция РаспределитьЗатраты(ДокументОбъект)
	
	Распределение = ДокументОбъект.Распределение.Выгрузить().СкопироватьКолонки();
	
	ПравилаРаспределения = ЗакрытиеМесяца.ПолучитьПравилаРаспределенияЗатрат(ДокументОбъект.Дата);
	Если ПравилаРаспределения = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='На период документа не заданы правила распределения затрат!'"));
		Возврат Распределение;
	КонецЕсли;
	
	ВидОперации = ДокументОбъект.ВидОперации;
	
	// Кеш данных, актуальных в качестве базы распределения для затрат. Тип: Запрос с установленным менеджером таблиц.
	ДанныеБазРаспределения = ПолучитьДанныеБазРаспределения(ДокументОбъект.Дата, ВидОперации);
	
	// Распределение каждой отдельной строки затраты.
	Для Каждого СтрокаЗатраты Из ДокументОбъект.Затраты Цикл
		
		// Поиск правила распределения
		ПравилоРаспределения = ПолучитьПравилоРаспределенияЗатраты(СтрокаЗатраты, ПравилаРаспределения, ВидОперации);
		Если Не ЗначениеЗаполнено(ПравилоРаспределения) Тогда
			СтрокаЗатраты.ОшибкаРаспределения = НСтр("ru='Правило распределения зататы не установлено'");
			Продолжить;
		КонецЕсли;
		
		// Определение таблицы базы распределения для строки затраты
		БазаРаспределения = ПолучитьБазуРаспределения(СтрокаЗатраты, ПравилоРаспределения, ВидОперации, ДанныеБазРаспределения, ДокументОбъект.Дата);
		
		РаспределитьЗатратуПоБазе(Распределение, СтрокаЗатраты, БазаРаспределения);
		
	КонецЦикла;
	
	Возврат Распределение;
	
КонецФункции

Функция ПолучитьДанныеБазРаспределения(Дата, ВидОперации)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ДатаНачала", НачалоМесяца(Дата));
	Запрос.УстановитьПараметр("ДатаОкончания", КонецМесяца(Дата));
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПродажиОбороты.Филиал КАК Филиал,
	|	ПродажиОбороты.Номенклатура.КатегорияВыработки КАК Специализация,
	|	ВЫБОР
	|		КОГДА ПродажиОбороты.Номенклатура ССЫЛКА Справочник.Номенклатура
	|			ТОГДА ПродажиОбороты.Номенклатура
	|		КОГДА ПродажиОбороты.Номенклатура ССЫЛКА Справочник.ВидыСертификатов
	|			ТОГДА ПродажиОбороты.Номенклатура.Номенклатура
	|	КОНЕЦ КАК Номенклатура,
	|	ПродажиОбороты.СуммаОборот КАК Сумма,
	|	ВЫБОР
	|		КОГДА ПродажиОбороты.Номенклатура.ВидНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ВидыНоменклатуры.Услуга)
	|			ТОГДА ПродажиОбороты.КоличествоОборот
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК КоличествоУслуг,
	|	ПродажиОбороты.СуммаБезСкидокОборот КАК СуммаБезСкидок
	|ПОМЕСТИТЬ ОборотыПродаж
	|ИЗ
	|	РегистрНакопления.Продажи.Обороты(&ДатаНачала, &ДатаОкончания, , ) КАК ПродажиОбороты"
	;
	Запрос.Выполнить();
	
	Возврат Запрос;	
	
КонецФункции

Функция ПолучитьПравилоРаспределенияЗатраты(СтрокаЗатраты, ПравилаРаспределения, ВидОперации)
	
	ПравилоРаспределения = Неопределено;
	
	Если ВидОперации = Перечисления.ВидыОперацийРаспределениеЗатрат.РаспределениеЗатратФилиаловНаСпециализации Тогда
		
		ИмяТЧ = "РаспределениеЗатратФилиаловНаСпециализации";
		ИмяРеквизитаПравила = "ПравилоРаспределения";
		ИмяРазреза = "Филиал";
		ПустоеЗначениеРазреза = Справочники.Филиалы.ПустаяСсылка();
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийРаспределениеЗатрат.РаспределениеЗатратСпециализацийНаНоменклатуру Тогда
		
		ИмяТЧ = "РаспределениеЗатратСпециализацийНаНоменклатуру";
		ИмяРеквизитаПравила = "СпособРаспределения";
		ИмяРазреза = "Специализация";
		ПустоеЗначениеРазреза = Справочники.КатегорииВыработки.ПустаяСсылка();
		
	КонецЕсли;
	
	// Поиск правила в порядке приоритета:
	// 1. Для этой статьи затрат и значения второго поля
	// 2. Для этой статьи затрат и пустого значения второго поля
	// 3. Для пустой статьи затрат и значения второго поля
	// 4. Для пустой статьи затрат и пустого значения второго поля
	
	ПустаяСтатья = Справочники.СтатьиЗатрат.ПустаяСсылка();
	ЗначениеРазреза = СтрокаЗатраты[ИмяРазреза];
	
	Отборы = Новый Массив;
	Отборы.Добавить(Новый Структура("СтатьяЗатрат, " + ИмяРазреза, СтрокаЗатраты.СтатьяЗатрат, ЗначениеРазреза));
	Отборы.Добавить(Новый Структура("СтатьяЗатрат, " + ИмяРазреза, СтрокаЗатраты.СтатьяЗатрат, ПустоеЗначениеРазреза));
	Отборы.Добавить(Новый Структура("СтатьяЗатрат, " + ИмяРазреза, ПустаяСтатья, ЗначениеРазреза));
	Отборы.Добавить(Новый Структура("СтатьяЗатрат, " + ИмяРазреза, ПустаяСтатья, ПустоеЗначениеРазреза));
	
	Для Каждого Отбор Из Отборы Цикл
		
		СтрокиПравил = ПравилаРаспределения[ИмяТЧ].НайтиСтроки(Отбор);
		Если СтрокиПравил.Количество() <> 0 Тогда
			ПравилоРаспределения = СтрокиПравил[0][ИмяРеквизитаПравила];
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ПравилоРаспределения) Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
		
	Возврат ПравилоРаспределения;
	
КонецФункции

Функция ПолучитьБазуРаспределения(СтрокаЗатраты, ПравилоРаспределения, ВидОперации, ДанныеБазРаспределения, Дата)
	
	БазаРаспределения = Новый ТаблицаЗначений;
	БазаРаспределения.Колонки.Добавить("Коэффициент", Новый ОписаниеТипов("Число"));
	
	ОтборБазы = Новый Структура("Филиал", СтрокаЗатраты.Филиал);
	
	Если ВидОперации = Перечисления.ВидыОперацийРаспределениеЗатрат.РаспределениеЗатратФилиаловНаСпециализации Тогда
		
		БазаРаспределения.Колонки.Добавить("Специализация", Новый ОписаниеТипов("СправочникСсылка.КатегорииВыработки"));
		ЗаполнитьБазуРаспределенияНаНаправленияПоПравилу(БазаРаспределения, СтрокаЗатраты, "Специализация", ПравилоРаспределения, ДанныеБазРаспределения, Дата);
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийРаспределениеЗатрат.РаспределениеЗатратСпециализацийНаНоменклатуру Тогда
		
		БазаРаспределения.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
		ОтборБазы = Новый Структура("Филиал, Специализация", СтрокаЗатраты.Филиал, СтрокаЗатраты.Специализация);
		ЗаполнитьБазуРаспределенияПоПродажам(БазаРаспределения, ПравилоРаспределения, ДанныеБазРаспределения, ОтборБазы);
		
	КонецЕсли;
	
	Возврат БазаРаспределения;
	
КонецФункции

// Распределение по способам распределения "По сумме", "По количеству услуг".
Процедура ЗаполнитьБазуРаспределенияПоПродажам(БазаРаспределения, СпособРаспределения, ДанныеБазРаспределения, Отбор, ОтборПолучателей = Неопределено)
	
	ИмяПоказателя = ИмяПоказателяПоСпособуРаспределения(СпособРаспределения);
	
	Запрос = ДанныеБазРаспределения;
	Запрос.Текст = "ВЫБРАТЬ
	               |	СУММА(ОборотыПродаж.Сумма) КАК Сумма,
	               |	СУММА(ОборотыПродаж.КоличествоУслуг) КАК КоличествоУслуг,
	               |	СУММА(ОборотыПродаж.СуммаБезСкидок) КАК СуммаБезСкидок,
	               |	ОборотыПродаж.Номенклатура КАК Номенклатура,
	               |	ОборотыПродаж.Специализация КАК Специализация
	               |ИЗ
	               |	ОборотыПродаж КАК ОборотыПродаж
	               |
	               |//%УсловиеГДЕ
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ОборотыПродаж.Специализация,
	               |	ОборотыПродаж.Номенклатура";
	
	ТекстУсловиеГДЕ = "";
	
	Для Каждого КлючЗначение Из Отбор Цикл
		ОбщегоНазначенияКлиентСервер.КонкатенацияСтрок(ТекстУсловиеГДЕ, КлючЗначение.Ключ + " = &" + КлючЗначение.Ключ, Символы.ПС + "И ");
		Запрос.УстановитьПараметр(КлючЗначение.Ключ, КлючЗначение.Значение);
	КонецЦикла;
	
	ТекстУсловиеГДЕ = "ГДЕ" + Символы.ПС + ТекстУсловиеГДЕ;
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "//%УсловиеГДЕ", ТекстУсловиеГДЕ);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Выборка[ИмяПоказателя] > 0 Тогда
			СтрокаБазы = БазаРаспределения.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаБазы, Выборка);
			СтрокаБазы.Коэффициент = Выборка[ИмяПоказателя];
		КонецЕсли;
	КонецЦикла;
	
	ОбщегоНазначения.СвернутьТаблицуЗначений(БазаРаспределения, "Коэффициент");
	
КонецПроцедуры

Процедура ЗаполнитьБазуРаспределенияНаНаправленияПоПравилу(БазаРаспределения, СтрокаЗатраты, ИмяПолучателя, ПравилоРаспределения, ДанныеБазРаспределения, Дата)
	
	Если Ложь Тогда ПравилоРаспределения = Справочники.ПравилаРаспределенияЗатрат.ПустаяСсылка() КонецЕсли;
	
	Если ПравилоРаспределения.СпособРаспределения = Перечисления.СпособРаспределенияЗатрат.ПоФиксированнойБазе Тогда
		
		Для Каждого СтрокаПолучателя Из ПравилоРаспределения.ПолучателиЗатрат Цикл
			СтрокаБазы = БазаРаспределения.Добавить();
			СтрокаБазы[ИмяПолучателя] = СтрокаПолучателя.Получатель;
			СтрокаБазы.Коэффициент	 = СтрокаПолучателя.Коэффициент;
		КонецЦикла;
		
	Иначе
		Если ПравилоРаспределения.ПолучателиЗатрат.Количество() = 0 Тогда
			ОтборПолучателей = Неопределено;
		Иначе
			ОтборПолучателей = Новый Структура(ИмяПолучателя, ПравилоРаспределения.ПолучателиЗатрат.ВыгрузитьКолонку("Получатель"));
		КонецЕсли;
		
		ОтборБазы = Новый Структура("Филиал", СтрокаЗатраты.Филиал);
		ЗаполнитьБазуРаспределенияПоПродажам(БазаРаспределения, ПравилоРаспределения.СпособРаспределения, ДанныеБазРаспределения, ОтборБазы, ОтборПолучателей);
	КонецЕсли;
	
КонецПроцедуры

Функция ИмяПоказателяПоСпособуРаспределения(СпособРаспределения)
	
	Если СпособРаспределения = Перечисления.СпособРаспределенияЗатрат.ПоСуммеПродаж Тогда
		Возврат "Сумма";
	ИначеЕсли СпособРаспределения = Перечисления.СпособРаспределенияЗатрат.ПоКоличествуУслуг Тогда
		Возврат "КоличествоУслуг";
	КонецЕсли;
	
КонецФункции

Процедура РаспределитьЗатратуПоБазе(Распределение, СтрокаЗатраты, БазаРаспределения)
	
	Перем СтрокаРаспределения;
	
	ОбщийКоэффициент = БазаРаспределения.Итог("Коэффициент");
	
	Если БазаРаспределения.Количество() = 0
		Или ОбщийКоэффициент = 0
	Тогда
		СтрокаЗатраты.ОшибкаРаспределения = НСтр("ru='Нет базы для распределения затраты'");
		Возврат;
	КонецЕсли;
	
	СуммаРаспределена = 0;
	ОбщийКоэффициент = БазаРаспределения.Итог("Коэффициент");
	
	Для Каждого СтрокаБазы Из БазаРаспределения Цикл
		
		Если СтрокаБазы.Коэффициент <> 0 Тогда
		
			СтрокаРаспределения = Распределение.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаРаспределения, СтрокаЗатраты);
			ЗаполнитьЗначенияСвойств(СтрокаРаспределения, СтрокаБазы);
			
			СтрокаРаспределения.Сумма = СтрокаЗатраты.Сумма * (СтрокаБазы.Коэффициент / ОбщийКоэффициент);
			
			СуммаРаспределена = СуммаРаспределена + СтрокаРаспределения.Сумма;
			
		КонецЕсли;
	КонецЦикла;
	
	// Учет погрешности округления.
	Если СуммаРаспределена <> СтрокаЗатраты.Сумма
		И СтрокаРаспределения <> Неопределено
	Тогда
		СтрокаРаспределения.Сумма = СтрокаРаспределения.Сумма + (СтрокаЗатраты.Сумма - СуммаРаспределена);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти