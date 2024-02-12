#Область ПечатныеФормы

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает доступные варианты печати документа.
//  Результатом является Струткура, каждая строка которой соответствует одному из вариантов печати.
// 
// Возвращаемое значение:
//  Структура.
//
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура("Ведомость","Инвентаризация товаров на складе");

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

// Процедура формирует печатную форму документа
//  Название макета печати передается в качестве параметра,
//  по переданному имени макета определяется соответствующая функция печати.
//
// Параметры:
//  СсылкаНаОбъект	 - ДокументСсылка	 - ссылка на распечатываемый документ.
//  ИмяМакета		 - Строка			 - имя макета из структуры печатных форм.
// 
// Возвращаемое значение:
//  ТабличныйДокумент.
//
Функция Печать(СсылкаНаОбъект, ИмяМакета) Экспорт
	
	Перем ТабДокумент;
	
	// Получить экземпляр документа на печать
	Если ИмяМакета = "Ведомость" Тогда

		ТабДокумент = ПечатьДокумента(СсылкаНаОбъект);
		
	КонецЕсли;
	
	Возврат ТабДокумент;
	
КонецФункции

#КонецОбласти

Функция ПолучитьДанныеДляПечатиДокумента(Ссылка)
	
	ПараметрыПечати = Новый Структура;
	
	ПараметрыПечати.Вставить("ВыводитьКоды", Истина);
	ПараметрыПечати.Вставить("ИмяКолонкиКодов", "Код");
	ТекстКодАртикул = "Артикул";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент", Ссылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Номер,
	|	Дата,
	|	Склад.Представление КАК ПредставлениеСклада,
	|	Склад,
	|	Товары.(
	|		Номенклатура,
	|		Номенклатура.Артикул            КАК КодАртикул,
	|		Номенклатура.НаименованиеПолное КАК Товар,
	|		Количество                      КАК Количество,
	|		КоличествоУчет                  КАК КоличествоПоУчету,
	|		ЕдиницаИзмерения.Представление  КАК ЕдиницаИзмерения,
	|		ХарактеристикаНоменклатуры      КАК Характеристика,
	|		СерияНоменклатуры      			КАК Серия,
	|       Цена                            КАК Цена,
	|	    Сумма                           КАК Сумма,
	|	    СуммаУчет                       КАК СуммаПоУчету
	|		
	|	)
	|ИЗ
	|	Документ.ИнвентаризацияТоваров КАК ИнвентаризацияТоваров
	|
	|ГДЕ
	|	ИнвентаризацияТоваров.Ссылка = &ТекущийДокумент
	|УПОРЯДОЧИТЬ ПО
	|	Товары.НомерСтроки";
	
	Шапка = Запрос.Выполнить().Выбрать();
	Шапка.Следующий();
	ВыборкаСтрокТовары = Шапка.Товары.Выбрать();
	
	// Выводим шапку накладной
	ТекстЗаголовка = НСтр("ru='Инвентаризация товаров на складе'"); 
	ПараметрыПечати.Вставить("ТекстЗаголовка", ОбщегоНазначения.СформироватьЗаголовокДокумента(Шапка, ТекстЗаголовка));
	
	// Выводим данные о складе
	ПараметрыПечати.Вставить("ПредставлениеСклада", Шапка.ПредставлениеСклада);
	
	// Данные о валюте
	КраткоеНаименованиеВалюты = ОбщегоНазначения.ПолучитьКраткоеНаименованиеОсновнойВалюты();
	ТекстВалюта = НСтр("ru='Валюта: %1'");
	ТекстВалюта = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстВалюта, КраткоеНаименованиеВалюты); 
	ПараметрыПечати.Вставить("ВалютаНадпись", ТекстВалюта);
	
	Позиции = Новый Массив;
	
	ИтогСуммы        = 0;
	ИтогСуммыПоУчету = 0;
	Ном = 0;
	
	Пока ВыборкаСтрокТовары.Следующий() Цикл
		
		ПараметрыПозиции = Новый Структура;
		ПараметрыПозиции.Вставить("Номенклатура", ВыборкаСтрокТовары.Номенклатура);
		Ном = Ном +1;
		ПараметрыПозиции.Вставить("НомерСтроки", Ном);

		//Если Не ВыборкаСтрокТовары.Характеристика.Наименование = "" Тогда
		//	ПараметрыПозиции.Вставить("Товар", ВыборкаСтрокТовары.Товар + Символы.ПС +"(" +ВыборкаСтрокТовары.Характеристика.Наименование + ")" );
		//Иначе
		//	ПараметрыПозиции.Вставить("Товар", ВыборкаСтрокТовары.Товар)

		СтрокаХарактеристикаСерия = "";
		Если Не ПустаяСтрока(ВыборкаСтрокТовары.Характеристика.Наименование) Тогда 
			СтрокаХарактеристикаСерия = СтрокаХарактеристикаСерия + "(" + ВыборкаСтрокТовары.Характеристика.Наименование; 
		КонецЕсли;
		Если Не ПустаяСтрока(ВыборкаСтрокТовары.Серия.Наименование) Тогда 
			СтрокаХарактеристикаСерия = СтрокаХарактеристикаСерия + ?(ПустаяСтрока(СтрокаХарактеристикаСерия), "(", ", ")
										+ ВыборкаСтрокТовары.Серия.Наименование; 
		КонецЕсли;
		Если Не ПустаяСтрока(СтрокаХарактеристикаСерия) Тогда 							
			СтрокаХарактеристикаСерия = СтрокаХарактеристикаСерия + ")"; 
		КонецЕсли;
		ПараметрыПозиции.Вставить("Товар", ?(ПустаяСтрока(СтрокаХарактеристикаСерия), ВыборкаСтрокТовары.Товар, ВыборкаСтрокТовары.Товар + Символы.ПС + СтрокаХарактеристикаСерия));
		ПараметрыПозиции.Вставить("Количество",			ВыборкаСтрокТовары.Количество);
		ПараметрыПозиции.Вставить("КоличествоПоУчету",	ВыборкаСтрокТовары.КоличествоПоУчету);
		ПараметрыПозиции.Вставить("ЕдиницаИзмерения",	ВыборкаСтрокТовары.ЕдиницаИзмерения);
		ПараметрыПозиции.Вставить("Цена",				ВыборкаСтрокТовары.Цена);
		ПараметрыПозиции.Вставить("Сумма",				ВыборкаСтрокТовары.Сумма);
		ПараметрыПозиции.Вставить("СуммаПоУчету",		ВыборкаСтрокТовары.СуммаПоУчету);
		
		Если ПараметрыПечати.ВыводитьКоды Тогда
			ПараметрыПозиции.Вставить("КодАртикул",		ВыборкаСтрокТовары.КодАртикул);
		КонецЕсли;
		
		ИтогСуммы        = ИтогСуммы        + ВыборкаСтрокТовары.Сумма;
		ИтогСуммыПоУчету = ИтогСуммыПоУчету + ВыборкаСтрокТовары.СуммаПоУчету;
		
		Позиции.Добавить(ПараметрыПозиции);
		
	КонецЦикла;
	
	ПараметрыПечати.Вставить("Позиции", Позиции);
	
	// Вывести Итого
	ВалютаУчета = УправлениеНастройками.ПолучитьПараметрУчетнойПолитики("ВалютаУчета");
	ПараметрыПечати.Вставить("Всего",		ОбщегоНазначенияКлиентСервер.ФорматСумм(ИтогСуммы));
	ПараметрыПечати.Вставить("ВсегоПоУчету",ОбщегоНазначенияКлиентСервер.ФорматСумм(ИтогСуммыПоУчету));
	ТекстИтого = НСтр("ru=' Итого (%1):'");
	ТекстИтого = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстИтого, КраткоеНаименованиеВалюты); 
	ПараметрыПечати.Вставить("ИтогоНадпись", ТекстИтого);
	
	Возврат ПараметрыПечати;
	
КонецФункции 	

Функция ПечатьДокумента(СсылкаНаОбъект)

	ПараметрыПечати = ПолучитьДанныеДляПечатиДокумента(СсылкаНаОбъект);
	
	Если ПараметрыПечати.ВыводитьКоды Тогда
		ОбластьШапки  = "ШапкаСКодом";
		ОбластьСтроки = "СтрокаСКодом";
	Иначе
		ОбластьШапки  = "ШапкаТаблицы";
		ОбластьСтроки = "Строка";
	Конецесли;

	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ИнвентаризацияТоваровНаСкладе_ИнвентаризацияТоваровНаСкладе";

	Макет = ПолучитьМакет("ИнвентаризацияТоваровНаСкладе");

	// Выводим шапку накладной
	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
	ОбластьМакета.Параметры.Заполнить(ПараметрыПечати);
	ТабДокумент.Вывести(ОбластьМакета);

	// Выводим данные об организации и складе
	ОбластьМакета = Макет.ПолучитьОбласть("Поставщик");
	ОбластьМакета.Параметры.Заполнить(ПараметрыПечати);
	ТабДокумент.Вывести(ОбластьМакета);

	// Выводим шапку таблицы
	ОбластьМакета = Макет.ПолучитьОбласть(ОбластьШапки);
	Если ПараметрыПечати.ВыводитьКоды Тогда
		ОбластьМакета.Параметры.Колонка = ПараметрыПечати.ИмяКолонкиКодов;
	КонецЕсли;

	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть(ОбластьСтроки);

	Для каждого ПараметрыПозиции Из ПараметрыПечати.Позиции Цикл	

		Если НЕ ЗначениеЗаполнено(ПараметрыПозиции.Номенклатура) Тогда
			ТекстСообщения = НСтр("ru='В одной из строк не заполнено значение номенклатуры - строка при печати пропущена.'"); 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Продолжить;
		КонецЕсли;

		ОбластьМакета.Параметры.Заполнить(ПараметрыПозиции);

		ТабДокумент.Вывести(ОбластьМакета);

	КонецЦикла;

	// Вывести Итого
	ОбластьМакета = Макет.ПолучитьОбласть("Итого");
	ОбластьМакета.Параметры.Заполнить(ПараметрыПечати);
	ТабДокумент.Вывести(ОбластьМакета);

	// Выводим подписи к документу
	ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
	ТабДокумент.Вывести(ОбластьМакета);

	Возврат ТабДокумент;

КонецФункции // ПечатьДокумента()

#КонецОбласти

#Область ЗаполнениеДокумента

#Область ПрограммныйИнтерфейс

// Заполнить табличную часть "Товары" по остаткам на складе
//
// Параметры:
//  ДокументОбъект	 - ДокументОбъект.ИнвентаризацияТоваров	 - документ.
//  НастройкиОтбора	 - НастройкиКомпоновкиДанных	 - отбор товаров.
//
Процедура ЗаполнитьТоварыПоОстаткамНаСкладе(ДокументОбъект, НастройкиОтбора = Неопределено) Экспорт
	
	Если НастройкиОтбора <> Неопределено Тогда
		МассивНоменклатуры = ПолучитьМассивНоменклатуры(НастройкиОтбора);	
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТоварыНаСкладахОстатки.Номенклатура,
	|	ТоварыНаСкладахОстатки.ХарактеристикаНоменклатуры,
	|	ТоварыНаСкладахОстатки.СерияНоменклатуры,
	|	ТоварыНаСкладахОстатки.КоличествоОстаток КАК КоличествоУчет,
	|	ТоварыНаСкладахОстатки.СуммаОстаток КАК СуммаУчет,
	|	ТоварыНаСкладахОстатки.Номенклатура.ЕдиницаХраненияОстатков КАК ЕдиницаИзмерения,
	|	ТоварыНаСкладахОстатки.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент КАК Коэффициент
	|ИЗ
	|	РегистрНакопления.ПартииТоваровНаСкладах.Остатки(&ДатаДок, Склад = &Склад) КАК ТоварыНаСкладахОстатки"
	;
	
	Запрос.УстановитьПараметр( "ДатаДок", ?(ЗначениеЗаполнено(ДокументОбъект.Ссылка), Новый МоментВремени(ДокументОбъект.Дата, ДокументОбъект.Ссылка), ДокументОбъект.Дата));
	Запрос.УстановитьПараметр( "Склад", ДокументОбъект.Склад) ;
	
	ВыбТовары = Запрос.Выполнить().Выбрать();
	ДокументОбъект.Товары.Очистить();
	Пока ВыбТовары.Следующий() Цикл
		
		Если НастройкиОтбора <> Неопределено И МассивНоменклатуры.Найти(ВыбТовары.Номенклатура) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		СтрТовары = ДокументОбъект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрТовары,ВыбТовары);
		СтрТовары.Количество = 0;
		СтрТовары.Сумма = 0;
		СтрТовары.Цена = ?(СтрТовары.КоличествоУчет=0,0,СтрТовары.СуммаУчет / СтрТовары.КоличествоУчет);
	КонецЦикла;
	
КонецПроцедуры

// Дополнить табличную часть "Товары" по остаткам на складе
//
// Параметры:
//  ДокументОбъект	 - ДокументОбъект.ИнвентаризацияТоваров	 - документ.
//  НастройкиОтбора	 - НастройкиКомпоновкиДанных			 - отбор товаров.
//
Процедура ДополнитьТоварыПоОстаткамНаСкладе(ДокументОбъект, НастройкиОтбора = Неопределено) Экспорт
	
	Если НастройкиОтбора <> Неопределено Тогда
		МассивНоменклатуры = ПолучитьМассивНоменклатуры(НастройкиОтбора);	
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ТаблицаВведенныхТоваров = ДокументОбъект.Товары.Выгрузить(,"Номенклатура,ХарактеристикаНоменклатуры,СерияНоменклатуры");
	Запрос.Текст = "ВЫБРАТЬ Номенклатура,ХарактеристикаНоменклатуры,СерияНоменклатуры ПОМЕСТИТЬ ТоварыДок ИЗ &Таб КАК Таблица";
	Запрос.УстановитьПараметр("Таб",ТаблицаВведенныхТоваров);
	Запрос.Выполнить();
	                                                                              
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТоварыНаСкладахОстатки.Номенклатура,
	|	ТоварыНаСкладахОстатки.ХарактеристикаНоменклатуры,
	|	ТоварыНаСкладахОстатки.СерияНоменклатуры,
	|	ТоварыНаСкладахОстатки.КоличествоОстаток КАК КоличествоУчет,
	|	ТоварыНаСкладахОстатки.СуммаОстаток КАК СуммаУчет,
	|	ТоварыНаСкладахОстатки.Номенклатура.ЕдиницаХраненияОстатков КАК ЕдиницаИзмерения,
	|	ТоварыНаСкладахОстатки.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент КАК Коэффициент
	|ИЗ
	|	РегистрНакопления.ПартииТоваровНаСкладах.Остатки(&ДатаДок, Склад = &Склад) КАК ТоварыНаСкладахОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТоварыДок КАК ТоварыДок
	|		ПО ТоварыНаСкладахОстатки.Номенклатура = ТоварыДок.Номенклатура
	|			И ТоварыНаСкладахОстатки.ХарактеристикаНоменклатуры = ТоварыДок.ХарактеристикаНоменклатуры
	|			И ТоварыНаСкладахОстатки.СерияНоменклатуры = ТоварыДок.СерияНоменклатуры
	|ГДЕ
	|	ТоварыДок.Номенклатура ЕСТЬ NULL "
	;
	
	Запрос.УстановитьПараметр( "ДатаДок", ?(ЗначениеЗаполнено(ДокументОбъект.Ссылка), Новый МоментВремени(ДокументОбъект.Дата, ДокументОбъект.Ссылка), ДокументОбъект.Дата)) ;
	Запрос.УстановитьПараметр( "Склад",   ДокументОбъект.Склад) ;
	
	ВыбТовары = Запрос.Выполнить().Выбрать();
	Пока ВыбТовары.Следующий() Цикл
		
		Если НастройкиОтбора <> Неопределено И МассивНоменклатуры.Найти(ВыбТовары.Номенклатура) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		СтрТовары = ДокументОбъект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрТовары,ВыбТовары);
		СтрТовары.Цена = ?(СтрТовары.КоличествоУчет=0,0,СтрТовары.СуммаУчет / СтрТовары.КоличествоУчет);
		
	КонецЦикла;
	
КонецПроцедуры

// Перезаполнение учетных количеств в табличной части "Товары".
//
// Параметры:
//  ДокументОбъект	 - ДокументОбъект.ИнвентаризацияТоваров	 - документ.
//
Процедура ПерезаполнитьУчетныеКоличества(ДокументОбъект) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ	
	|	ИнвентаризацияТоваровТовары.Номенклатура,
	|	ИнвентаризацияТоваровТовары.ХарактеристикаНоменклатуры,
	|	ИнвентаризацияТоваровТовары.СерияНоменклатуры,
	|	ИнвентаризацияТоваровТовары.ЕдиницаИзмерения,
	|	ИнвентаризацияТоваровТовары.Коэффициент,
	|	&Склад КАК Склад
	|ПОМЕСТИТЬ ТоварыДокумента
	|ИЗ
	|	&ТаблицаТоваров КАК ИнвентаризацияТоваровТовары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТоварыДокумента.Номенклатура,
	|	ТоварыДокумента.ХарактеристикаНоменклатуры,
	|	ТоварыДокумента.СерияНоменклатуры,
	|	ВЫБОР
	|		КОГДА ТоварыДокумента.ЕдиницаИзмерения = ТоварыДокумента.Номенклатура.ЕдиницаХраненияОстатков
	|			ТОГДА ТоварыНаСкладахОстатки.КоличествоОстаток
	|		ИНАЧЕ ТоварыНаСкладахОстатки.КоличествоОстаток * (ТоварыДокумента.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / ТоварыДокумента.ЕдиницаИзмерения.Коэффициент)
	|	КОНЕЦ КАК КоличествоУчет,
	|	ТоварыНаСкладахОстатки.СуммаОстаток КАК СуммаУчет,
	|	ТоварыДокумента.ЕдиницаИзмерения.Коэффициент КАК Коэффициент
	|ИЗ
	|	ТоварыДокумента КАК ТоварыДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ПартииТоваровНаСкладах.Остатки(&ДатаДок, Номенклатура В (&Номенклатура)) КАК ТоварыНаСкладахОстатки
	|		ПО ТоварыДокумента.Номенклатура = ТоварыНаСкладахОстатки.Номенклатура
	|			И ТоварыДокумента.ХарактеристикаНоменклатуры = ТоварыНаСкладахОстатки.ХарактеристикаНоменклатуры
	|			И ТоварыДокумента.СерияНоменклатуры = ТоварыНаСкладахОстатки.СерияНоменклатуры
	|			И ТоварыДокумента.Склад = ТоварыНаСкладахОстатки.Склад"
	;
	ТаблицаТоваров = ДокументОбъект.Товары.Выгрузить();
	ТаблицаТоваров.Свернуть("Номенклатура,ХарактеристикаНоменклатуры,СерияНоменклатуры,ЕдиницаИзмерения,Коэффициент");
	Запрос.УстановитьПараметр("Склад", ДокументОбъект.Склад);
	Запрос.УстановитьПараметр("ТаблицаТоваров", ТаблицаТоваров);
	Запрос.УстановитьПараметр("ДатаДок", ?(ЗначениеЗаполнено(ДокументОбъект.Ссылка), Новый МоментВремени(ДокументОбъект.Дата, ДокументОбъект.Ссылка), ДокументОбъект.Дата));
	Запрос.УстановитьПараметр("Номенклатура", ДокументОбъект.Товары.Выгрузить().ВыгрузитьКолонку("Номенклатура")) ;
	
	ПрейскурантОценки = УправлениеНастройками.ПолучитьПараметрУчетнойПолитики("ПрейскурантРасчетаСтоимостиМатериалов");
	Если Не ЗначениеЗаполнено(ПрейскурантОценки) Тогда
		ПрейскурантОценки = УправлениеНастройками.ПолучитьПрейскурантФилиала(ДокументОбъект.Филиал);
	КонецЕсли;
	  
	ВыбТовары = Запрос.Выполнить().Выбрать();                                	
	Отбор     = Новый Структура("Номенклатура,ХарактеристикаНоменклатуры,СерияНоменклатуры");  
	
	Для Каждого СтрТовары Из ДокументОбъект.Товары Цикл
		ЗаполнитьЗначенияСвойств(Отбор,СтрТовары);
		ВыбТовары.Сбросить();
		Если ВыбТовары.НайтиСледующий(Отбор) Тогда
			СтрТовары.КоличествоУчет = ВыбТовары.КоличествоУчет;
			СтрТовары.СуммаУчет      = ВыбТовары.СуммаУчет;
			// Расчитаем сумму по текущему количеству и цену
			Если ВыбТовары.КоличествоУчет <> 0 Тогда
				СтрТовары.Цена = Окр(ВыбТовары.СуммаУчет / ВыбТовары.КоличествоУчет, 2);
				СтрТовары.Сумма = СтрТовары.Количество * Окр(ВыбТовары.СуммаУчет / ВыбТовары.КоличествоУчет, 2);
			ИначеЕсли СтрТовары.Количество <> 0 Тогда
				СтрТовары.Цена = Окр(ВыбТовары.СуммаУчет / СтрТовары.Количество, 2);
			Иначе
				СтрТовары.Цена = 0;
			КонецЕсли; 
		Иначе
			СтрТовары.КоличествоУчет = 0;
			СтрТовары.СуммаУчет      = 0;
			СтрТовары.Цена = Ценообразование.ПолучитьЦену(ПрейскурантОценки, СтрТовары.Номенклатура,
															ДокументОбъект.Дата,СтрТовары.ХарактеристикаНоменклатуры, СтрТовары.ЕдиницаИзмерения).Цена;
			Если СтрТовары.Цена = 0 Тогда
				СтрТовары.Цена = Ценообразование.ПолучитьЦену(ПрейскурантОценки, СтрТовары.Номенклатура,
																ТекущаяДата(),СтрТовары.ХарактеристикаНоменклатуры, СтрТовары.ЕдиницаИзмерения).Цена;
			КонецЕсли;
			Если СтрТовары.Цена <> 0 Тогда												
				СтрТовары.Сумма = СтрТовары.Количество * СтрТовары.Цена;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Свернуть таблицу товаров
//
// Параметры:
//  ДокументОбъект	 - ДокументОбъект.ИнвентаризацияТоваров	 - документ.
//
Процедура СвернутьТаблицуТоваров(ДокументОбъект) Экспорт
	
	Товары = ДокументОбъект.Товары.Выгрузить();
	Товары.Свернуть("Номенклатура, ХарактеристикаНоменклатуры, СерияНоменклатуры, ЕдиницаИзмерения, Коэффициент","Количество, КоличествоУчет, Цена, Сумма, СуммаУчет");
	ДокументОбъект.Товары.Загрузить(Товары);
	                                                         
	ПерезаполнитьУчетныеКоличества(ДокументОбъект);
	                                                         
КонецПроцедуры

#КонецОбласти

Функция ПолучитьМассивНоменклатуры(НастройкиОтбора)
	
	СхемаКомпоновкиДанных = ПолучитьМакет("МакетСКДОтборНоменклатуры");
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных)));
	
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	
	Если ЗначениеЗаполнено(НастройкиОтбора) Тогда
		КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиОтбора);
	КонецЕсли;
	
	МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных,
	КомпоновщикНастроек.Настройки, , ,
	Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	
	ТаблицаНоменклатуры = ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	Возврат ТаблицаНоменклатуры.ВыгрузитьКолонку("Номенклатура");
	
КонецФункции

#КонецОбласти
