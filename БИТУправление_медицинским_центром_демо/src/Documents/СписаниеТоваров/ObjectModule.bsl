#Область ПрограммныйИнтерфейс

// Заполнить документ по инвентаризации
//
Процедура ЗаполнитьПоИнвентаризации() Экспорт
	
	Если Не ЗначениеЗаполнено(Основание) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Документ инвентаризации не выбран. Заполнение невозможно.'"));
		Возврат;	
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	%ДокументОснование%Товары.Номенклатура,
	|	%ДокументОснование%Товары.ХарактеристикаНоменклатуры,
	|	%ДокументОснование%Товары.ЕдиницаИзмерения,
	|	%ДокументОснование%Товары.ЕдиницаИзмерения.Коэффициент КАК Коэффициент,
	|	%ДокументОснование%Товары.СерияНоменклатуры,
	|	%Количество%
	|	%СкладПеремещениеМатериалов%
	|ИЗ
	|	Документ.%ДокументОснование%.Товары КАК %ДокументОснование%Товары
	|ГДЕ
	|	%ДокументОснование%Товары.Ссылка = &Ссылка
	|	%ИнвентаризацияТоваровУсловие%";
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ИнвентаризацияТоваров") Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"%Количество%","- %ДокументОснование%Товары.Количество + %ДокументОснование%Товары.КоличествоУчет КАК Количество");
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"%ИнвентаризацияТоваровУсловие%","И %ДокументОснование%Товары.Количество < %ДокументОснование%Товары.КоличествоУчет");	
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"%СкладПеремещениеМатериалов%","");
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"%Количество%","%ДокументОснование%Товары.Количество КАК Количество");
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"%ИнвентаризацияТоваровУсловие%","");
		Если ТипЗнч(Основание) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
			Запрос.Текст = СтрЗаменить(Запрос.Текст,"%СкладПеремещениеМатериалов%","");
		ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ПеремещениеМатериалов") Тогда
			Запрос.Текст = СтрЗаменить(Запрос.Текст,"%СкладПеремещениеМатериалов%",",ПеремещениеМатериаловТовары.СкладПолучатель КАК Склад");	
		КонецЕсли;
	КонецЕсли;	
	Запрос.Текст = СтрЗаменить(Запрос.Текст,"%ДокументОснование%",Строка(Основание.Метаданные().Имя));
	
	Запрос.УстановитьПараметр("Ссылка", Основание) ;
	
	// Определяем источник данных для склада
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ИнвентаризацияТоваров") Или ТипЗнч(Основание) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
		Склад = Основание.Склад;	
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ПеремещениеМатериалов") Тогда
		Склад = Основание.СкладПолучатель;
	КонецЕсли;
	// Заполняем строки таблицы
	ВыбТовары = Запрос.Выполнить().Выбрать();
	Товары.Очистить();
	Пока ВыбТовары.Следующий() Цикл	
		СтрТовары = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрТовары,ВыбТовары);
		Если ТипЗнч(Основание) = Тип("ДокументСсылка.ПеремещениеМатериалов")Тогда
			Если ЗначениеЗаполнено(ВыбТовары.Склад) Тогда
				СтрТовары.Склад = ВыбТовары.Склад;
			КонецЕсли;
		КонецЕсли;
		СтрТовары.Коэффициент = ДопСерверныеФункции.ПолучитьРеквизит(СтрТовары.ЕдиницаИзмерения,"Коэффициент");
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента, ТаблицаПоТоварам)
	
	// Получим необходимые данные для проведения и проверки заполенения данных по табличной части "Товары".
	СтруктураПолей = Новый Структура();
	СтруктураПолей.Вставить("Номенклатура"                       , "Номенклатура");
	СтруктураПолей.Вставить("ХарактеристикаНоменклатуры"         , "ХарактеристикаНоменклатуры");
	СтруктураПолей.Вставить("СерияНоменклатуры"         		 , "СерияНоменклатуры");
	СтруктураПолей.Вставить("ЕдиницаИзмерения"                   , "ЕдиницаИзмерения");
	СтруктураПолей.Вставить("ВидНоменклатуры"                    , "Номенклатура.ВидНоменклатуры");
	СтруктураПолей.Вставить("Количество"                         , "Количество * Коэффициент/Номенклатура.ЕдиницаХраненияОстатков.Коэффициент");
	СтруктураПолей.Вставить("Склад"                              , "Склад");
	СтруктураПолей.Вставить("НомерСтроки"                        , "НомерСтроки");
	
	РезультатЗапросаПоТоварам = ПроведениеДокументов.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "Товары", СтруктураПолей);
	// Подготовим таблицу товаров для проведения.
	ТаблицаПоТоварам = РезультатЗапросаПоТоварам.Выгрузить();
	
	Для Каждого СтрокаТовар Из ТаблицаПоТоварам Цикл
		Если Не ЗначениеЗаполнено(СтрокаТовар.Склад) Тогда
			СтрокаТовар.Склад = СтруктураШапкиДокумента.Склад;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры // ПодготовитьТаблицыДокумента()

Процедура ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок)
	
	ДвиженияПоРегиструСписанныеТовары(СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок); 
	ПартионныйУчет.пуДвижениеПартийТоваров(Ссылка, Движения.СписанныеТовары.Выгрузить(), Отказ);
	
	Если ОтнесеноНаЗатраты Тогда
		ДвиженияПоРегиструЗатраты(СтруктураШапкиДокумента, Отказ, Заголовок);
	КонецЕсли;

КонецПроцедуры // ДвиженияПоРегистрам()

Процедура ПроверитьЗаполнениеТабличнойЧастиТоварыНаСкладах(ТаблицаПоТоварам, СтруктураШапкиДокумента, Отказ, Заголовок)
	ИмяТабличнойЧасти = "Товары";
	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("Номенклатура, ХарактеристикаНоменклатуры, Количество, ЕдиницаИзмерения");
	
	// Теперь позовем общую процедуру проверки.
	ПроведениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Товары", СтруктураОбязательныхПолей, Отказ, Заголовок);
	
	// Проверка на наличие услуг в т.ч. товаров
	РаботаСДокументамиСервер.ПроверитьЧтоНетУслуг(ЭтотОбъект, "Товары", ТаблицаПоТоварам, Отказ, Заголовок);
КонецПроцедуры // ПроверитьЗаполнениеТабличнойЧастиТовары()

Процедура ДвиженияПоРегиструСписанныеТовары(СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок)
	// ТОВАРЫ ПО РЕГИСТРУ СписанныеТовары.
	НаборДвижений = Движения.СписанныеТовары;
	// Получим таблицу значений, совпадающую со струкутрой набора записей регистра.
	ТаблицаДвижений = НаборДвижений.Выгрузить();
	ТаблицаДвижений.Очистить();
	// Заполним таблицу движений.
	ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТаблицаПоТоварам, ТаблицаДвижений);
	// Недостающие поля.
	Инд = 0;
	Для каждого Строка Из ТаблицаДвижений Цикл
		Инд = Инд+1;
		Строка.НомерСтрокиДокумента = Инд;
	КонецЦикла;
	ТаблицаДвижений.ЗаполнитьЗначения(Дата,   "Период");
	ТаблицаДвижений.ЗаполнитьЗначения(Ссылка, "Регистратор");
	ТаблицаДвижений.ЗаполнитьЗначения(Истина, "Активность");
	НаборДвижений.мПериод          = Дата;
	НаборДвижений.мТаблицаДвижений = ТаблицаДвижений;
	Если Не Отказ Тогда
		Движения.СписанныеТовары.ВыполнитьДвижения();
	КонецЕсли;
КонецПроцедуры // ДвиженияПоРегистрамУпр()

Процедура ДвиженияПоРегиструЗатраты(СтруктураШапкиДокумента, Отказ, Заголовок)
	
	// Формирование движений по регистру "Затраты"
	
	// Получение стоимости списания товаров
	Движения.ПартииТоваровНаСкладах.Прочитать();
	ТаблицаСебестоимостиСписания = Движения.ПартииТоваровНаСкладах.Выгрузить();
	ТаблицаСебестоимостиСписания.Свернуть("Номенклатура,ХарактеристикаНоменклатуры","Сумма");
	
	// Получение таблицы затрат
	ТаблицаЗатрат = Товары.Выгрузить();
	ТаблицаЗатрат.Свернуть("Номенклатура, ХарактеристикаНоменклатуры, ЕдиницаИзмерения, СтатьяЗатрат, КатегорияВыработки, НоменклатураПолучатель","Количество");
	
	Для Каждого СтрокаЗатрат Из ТаблицаЗатрат Цикл
			
		ЕХОНоменклатуры = СтрокаЗатрат.Номенклатура.ЕдиницаХраненияОстатков;
		СтрокаЗатрат.Количество = СтрокаЗатрат.Количество *	?(ЕХОНоменклатуры.Коэффициент = 0, 
															1,
															СтрокаЗатрат.ЕдиницаИзмерения.Коэффициент/ЕХОНоменклатуры.Коэффициент);
	КонецЦикла;
	
	ТаблицаКоличестваЗатрат = ТаблицаЗатрат.Скопировать();
	ТаблицаКоличестваЗатрат.Свернуть("Номенклатура,ХарактеристикаНоменклатуры","Количество");
	
	ТаблицаЗатрат.Колонки.Добавить("Сумма",Новый ОписаниеТипов("Число"));
	
	ТаблицаЗатрат.Колонки.Добавить("Филиал");
	Если ЭтотОбъект.Метаданные().Реквизиты.Найти("Филиал") <> Неопределено Тогда
		ТаблицаЗатрат.ЗаполнитьЗначения(ЭтотОбъект["Филиал"],"Филиал");
	КонецЕсли;
	
	// Распределение стоимости списания между затратами
	ОтборСтрок = Новый Структура("Номенклатура,ХарактеристикаНоменклатуры");
	Для Каждого СтрокаЗатрат Из ТаблицаЗатрат Цикл

		ЗаполнитьЗначенияСвойств(ОтборСтрок,СтрокаЗатрат);
		мсСтрокСебестоимости = ТаблицаСебестоимостиСписания.НайтиСтроки(ОтборСтрок);
		Если мсСтрокСебестоимости.Количество() > 0 Тогда
			
			СтрокаСебестоимости = мсСтрокСебестоимости[0];
			
			мсСтрокиКоличестваЗатрат = ТаблицаКоличестваЗатрат.НайтиСтроки(ОтборСтрок);
			СтрокаКоличестваЗатрат = мсСтрокиКоличестваЗатрат[0];
			
			СтрокаЗатрат.Сумма = СтрокаСебестоимости.Сумма * СтрокаЗатрат.Количество / СтрокаКоличестваЗатрат.Количество;														
			
		КонецЕсли;
	КонецЦикла;

	УправлениеЗатратами.ДвиженияПоПрочимЗатратам(ЭтотОбъект, ТаблицаЗатрат);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	// Заполнение неуказанных статей затрат	значением по-умолчанию.
	Если ОтнесеноНаЗатраты Тогда
		// Получение статьи затрат по-умолчанию.
		УчетнаяПолитика = УправлениеНастройками.ПолучитьУчетнуюПолитику();     
		СтатьяЗатратПоУмолчанию = УчетнаяПолитика.ОсновнаяСтатьяЗатратСписанияТоваров;
		Если Не ЗначениеЗаполнено(СтатьяЗатратПоУмолчанию) Тогда
			СтатьяЗатратПоУмолчанию = Справочники.СтатьиЗатрат.НедостачиИПотериОтПорчиЦенностей;
		КонецЕсли;
		
		// Простановка статьи затрат по-умолчанию в строках с незаполненной статьей.
		Для Каждого СтрокаТовары Из Товары Цикл
			Если Не ЗначениеЗаполнено(СтрокаТовары.СтатьяЗатрат) Тогда
				СтрокаТовары.СтатьяЗатрат = СтатьяЗатратПоУмолчанию;
			КонецЕсли;
		КонецЦикла;
	Иначе
		// Если не отнесено на затраты, тогда заполнение статьи затрат, категории выработки (специализации), номенклатуры-получателя пустыми ссылками.
		Для Каждого СтрокаТовары Из Товары Цикл
			Если ЗначениеЗаполнено(СтрокаТовары.СтатьяЗатрат) Тогда 
				СтрокаТовары.СтатьяЗатрат = Справочники.СтатьиЗатрат.ПустаяСсылка();	
			КонецЕсли;
			Если ЗначениеЗаполнено(СтрокаТовары.КатегорияВыработки) Тогда 
				СтрокаТовары.КатегорияВыработки = Справочники.КатегорииВыработки.ПустаяСсылка();	
			КонецЕсли;
			Если ЗначениеЗаполнено(СтрокаТовары.НоменклатураПолучатель) Тогда 
				СтрокаТовары.НоменклатураПолучатель = Справочники.Номенклатура.ПустаяСсылка();	
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Перем Заголовок, СтруктураШапкиДокумента, ТаблицаПоТоварам;
	
	ПроведениеДокументов.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Заголовок для сообщений об ошибках проведения.
	ТекстЗаголовка = НСтр("ru='Проведение документа ""%1"": '");
	ТекстЗаголовка= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовка, СокрЛП(Ссылка)); 
	Заголовок = ТекстЗаголовка;
	
	Если Отказ Тогда Возврат КонецЕсли;
	
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	
	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура;
	
	Если Товары.Количество() > 0 Тогда     
		СтруктураОбязательныхПолей.Вставить("Склад");
		СтруктураОбязательныхПолей.Вставить("Ответственный");
		ПроведениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);
	КонецЕсли;
	
	// Проверить заполнение ТЧ .
	ПроверитьЗаполнениеТабличнойЧастиТоварыНаСкладах(ТаблицаПоТоварам, СтруктураШапкиДокумента, Отказ, Заголовок);
	
	ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента, ТаблицаПоТоварам);
	
	// Движения по документу
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения)

	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ИнвентаризацияТоваров") Тогда
		Основание = ДанныеЗаполнения;
		ЗаполнитьПоИнвентаризации();	
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПеремещениеМатериалов")
		Или ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг")
	Тогда
		Основание = ДанныеЗаполнения;
		ЗаполнитьПоИнвентаризации();
		ОтнесеноНаЗатраты = Истина;
	ИначеЕсли ДанныеЗаполнения <> Неопределено Тогда
		РаботаСДокументамиСервер.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти