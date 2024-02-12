#Область ПрограммныйИнтерфейс

// Заполнить документ по инвентаризации
//
Процедура ЗаполнитьПоИнвентаризации() Экспорт
	
	Если НЕ ЗначениеЗаполнено(Инвентаризация) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Документ инвентаризации не выбран. Заполнение невозможно.'"));
		Возврат;	
	КонецЕсли;	
	
    Склад = Инвентаризация.Склад;

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИнвентаризацияТоваровТовары.Номенклатура,
	|	ИнвентаризацияТоваровТовары.ХарактеристикаНоменклатуры,
	|	ИнвентаризацияТоваровТовары.ЕдиницаИзмерения,
	|	ИнвентаризацияТоваровТовары.ЕдиницаИзмерения.Коэффициент КАК Коэффициент,
	|	ИнвентаризацияТоваровТовары.Количество - ИнвентаризацияТоваровТовары.КоличествоУчет КАК Количество,
	|	ИнвентаризацияТоваровТовары.Цена,
	|	ИнвентаризацияТоваровТовары.Сумма - ИнвентаризацияТоваровТовары.СуммаУчет КАК Сумма,
	|	ИнвентаризацияТоваровТовары.СерияНоменклатуры
	|ИЗ
	|	Документ.ИнвентаризацияТоваров.Товары КАК ИнвентаризацияТоваровТовары
	|ГДЕ
	|	ИнвентаризацияТоваровТовары.Ссылка = &Ссылка
	|	И ИнвентаризацияТоваровТовары.Количество > ИнвентаризацияТоваровТовары.КоличествоУчет"
	;
	
	Запрос.УстановитьПараметр("Ссылка", Инвентаризация) ;
	
	ВыбТовары = запрос.Выполнить().Выбрать();
	Товары.Очистить();
	Пока ВыбТовары.Следующий() Цикл
		
		СтрТовары = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрТовары,ВыбТовары);
		СтрТовары.Склад = Склад;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента, ТаблицаПоТоварам) 

	// Получим необходимые данные для проведения и проверки заполенения данных по табличной части "Товары".
	ПроведениеДокументов.ПодготовитьТаблицуТоварыДокумента(ЭтотОбъект,ТаблицаПоТоварам);
	
КонецПроцедуры // ПодготовитьТаблицыДокумента()

Процедура ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок)
	
	ПартионныйУчет.пуОприходованиеПартийТоваров(СтруктураШапкиДокумента, ТаблицаПоТоварам, ЭтотОбъект.Движения.ПартииТоваровНаСкладах);
	
КонецПроцедуры // ДвиженияПоРегистрам()

Процедура ПроверитьЗаполнениеТабличнойЧастиТоварыНаСкладах(ТаблицаПоТоварам, СтруктураШапкиДокумента, Отказ, Заголовок)
	ИмяТабличнойЧасти = "Товары";
	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("Номенклатура, ХарактеристикаНоменклатуры, Количество, ЕдиницаИзмерения");
	
	// Теперь позовем общую процедуру проверки.
	ПроведениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Товары", СтруктураОбязательныхПолей, Отказ, Заголовок);

	// Проверка на наличие услуг в т.ч. товаров
	РаботаСДокументамиСервер.ПроверитьЧтоНетУслуг(ЭтотОбъект, "Товары", ТаблицаПоТоварам, Отказ, Заголовок);
КонецПроцедуры 

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Перем Заголовок, СтруктураШапкиДокумента, ТаблицаПоТоварам;
	// Заголовок для сообщений об ошибках проведения.
	ТекстЗаголовка = НСтр("ru='Проведение документа'"); 
	Заголовок = ТекстЗаголовка + " """ + СокрЛП(Ссылка) + """: ";

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

	// Теперь позовем общую процедуру проверки.
	ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента, ТаблицаПоТоварам);
	
	// Движения по документу
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(Основание)
	
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ИнвентаризацияТоваров") Тогда
		Инвентаризация = Основание;
		ЗаполнитьПоИнвентаризации();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти