#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписокПериодичностейУчета = Элементы.Интервал.СписокВыбора;
	СписокПериодичностейУчета.Добавить(Дата(1,1,1,0,5,0));
	СписокПериодичностейУчета.Добавить(Дата(1,1,1,0,10,0));
	СписокПериодичностейУчета.Добавить(Дата(1,1,1,0,15,0));
	СписокПериодичностейУчета.Добавить(Дата(1,1,1,0,20,0));
	СписокПериодичностейУчета.Добавить(Дата(1,1,1,0,30,0));
	СписокПериодичностейУчета.Добавить(Дата(1,1,1,1,0,0));
	Для Каждого ЭлементСписка Из СписокПериодичностейУчета Цикл
		ЭлементСписка.Представление = (ЭлементСписка.Значение-Дата(1,1,1))/60;
	КонецЦикла;
	
	ЗаполнитьСписокСпециализаций(Объект.Специализации, "", СписокСпециализаций);
	ЗаполнитьСписокСотрудников(Объект.Сотрудники, "", СписокСотрудников);
	ЗаполнитьСписокКабинетов(Объект.Кабинеты, "", СписокКабинетов);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("МодельРасписанияЗапись", Объект.Ссылка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
&НаКлиенте
Процедура ПоискСпециализацииАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	ЗаполнитьСписокСпециализаций(Объект.Специализации, Текст, СписокСпециализаций);	
КонецПроцедуры

&НаКлиенте
Процедура ПоискСпециализацииОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ЗаполнитьСписокСпециализаций(Объект.Специализации, Текст, СписокСпециализаций);	
КонецПроцедуры

&НаКлиенте
Процедура ПоискСпециализацииОчистка(Элемент, СтандартнаяОбработка)
	ЗаполнитьСписокСпециализаций(Объект.Специализации, "", СписокСпециализаций);	
КонецПроцедуры

&НаКлиенте
Процедура ПолеПоискСотрудникиАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	ЗаполнитьСписокСотрудников(Объект.Сотрудники, Текст, СписокСотрудников);	
КонецПроцедуры

&НаКлиенте
Процедура ПолеПоискСотрудникиОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ЗаполнитьСписокСотрудников(Объект.Сотрудники, Текст, СписокСотрудников);	
КонецПроцедуры

&НаКлиенте
Процедура ПолеПоискСотрудникиОчистка(Элемент, СтандартнаяОбработка)
	ЗаполнитьСписокСотрудников(Объект.Сотрудники, "", СписокСотрудников);	
КонецПроцедуры

&НаКлиенте
Процедура ПоискКабинетыАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	ЗаполнитьСписокКабинетов(Объект.Кабинеты, Текст, СписокКабинетов);	
КонецПроцедуры

&НаКлиенте
Процедура ПоискКабинетыОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ЗаполнитьСписокКабинетов(Объект.Кабинеты, Текст, СписокКабинетов);	
КонецПроцедуры

&НаКлиенте
Процедура ПоискКабинетыОчистка(Элемент, СтандартнаяОбработка)
	ЗаполнитьСписокКабинетов(Объект.Кабинеты, "", СписокКабинетов);	
КонецПроцедуры

&НаКлиенте
Процедура СписокСпециализацийПриИзменении(Элемент)
	
	СписокУчастниковМоделиПриИзменении(СписокСпециализаций, Объект.Специализации, "Специализация");
	
	Элементы.СписокСпециализацийКнопкаВверх.Доступность = Элемент.ТекущиеДанные.Пометка;
	Элементы.СписокСпециализацийКнопкаВниз.Доступность = Элемент.ТекущиеДанные.Пометка;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСпециализацийПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		Элементы.СписокСпециализацийКнопкаВверх.Доступность = Элемент.ТекущиеДанные.Пометка;
		Элементы.СписокСпециализацийКнопкаВниз.Доступность = Элемент.ТекущиеДанные.Пометка;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СписокСотрудниковПриИзменении(Элемент)

	СписокУчастниковМоделиПриИзменении(СписокСотрудников, Объект.Сотрудники, "Сотрудник");

	Элементы.СписокСотрудниковКнопкаВверх.Доступность = Элемент.ТекущиеДанные.Пометка;
	Элементы.СписокСотрудниковКнопкаВниз.Доступность = Элемент.ТекущиеДанные.Пометка;

КонецПроцедуры

&НаКлиенте
Процедура СписокСотрудниковПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		Элементы.СписокСотрудниковКнопкаВверх.Доступность = Элемент.ТекущиеДанные.Пометка;
		Элементы.СписокСотрудниковКнопкаВниз.Доступность = Элемент.ТекущиеДанные.Пометка;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СписокКабинетовПриИзменении(Элемент)

	СписокУчастниковМоделиПриИзменении(СписокКабинетов, Объект.Кабинеты, "Кабинет");

	Элементы.СписокКабинетовКнопкаВверх.Доступность	= Элемент.ТекущиеДанные.Пометка;
	Элементы.СписокКабинетовКнопкаВниз.Доступность	= Элемент.ТекущиеДанные.Пометка;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокКабинетовПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		Элементы.СписокКабинетовКнопкаВверх.Доступность	= Элемент.ТекущиеДанные.Пометка;
		Элементы.СписокКабинетовКнопкаВниз.Доступность	= Элемент.ТекущиеДанные.Пометка;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СписокУчастниковМоделиПриИзменении(Список, ТабЧасть, ИмяКолонкиУчастника)
	
	Для Каждого ЭлементСписка Из Список Цикл
		
		мсСтр = ТабЧасть.НайтиСтроки(Новый Структура(ИмяКолонкиУчастника,ЭлементСписка.Значение));
		Если мсСтр.Количество() = 0 Тогда
			СтрокаТабЧасти = Неопределено;
		Иначе
			СтрокаТабЧасти = мсСтр[0];
		КонецЕсли;
		
		Если ЭлементСписка.Пометка И СтрокаТабЧасти = Неопределено Тогда
			
			ТабЧасть.Добавить()[ИмяКолонкиУчастника] = ЭлементСписка.Значение;
			
		ИначеЕсли Не ЭлементСписка.Пометка И СтрокаТабЧасти <> Неопределено Тогда
			
			ТабЧасть.Удалить(СтрокаТабЧасти);
			
		КонецЕсли;
		
	КонецЦикла;
	
	ОбновитьСортировкуСпискаУчастников(Список, ТабЧасть, ИмяКолонкиУчастника);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВверх(ЭлементСписка, Список, ТабЧасть, ИмяКолонкиУчастника)
	
	РезультатПоиска = ТабЧасть.НайтиСтроки(Новый Структура(ИмяКолонкиУчастника, ЭлементСписка.ТекущиеДанные.Значение));
	Если РезультатПоиска.Количество() = 0 Тогда
		Возврат;
	Иначе
		Участник = РезультатПоиска[0];
	КонецЕсли;
	
	Если Участник.НомерСтроки = 1 Тогда
		Возврат;
	КонецЕсли;
	
	// Сдвигаем
	НомерУчастника = Участник.НомерСтроки - 1;
	ТабЧасть.Сдвинуть(НомерУчастника, -1);
	Список.Сдвинуть(НомерУчастника, -1);
	
	ЭтаФорма.Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВниз(ЭлементСписка, Список, ТабЧасть, ИмяКолонкиУчастника)
	
	РезультатПоиска = ТабЧасть.НайтиСтроки(Новый Структура(ИмяКолонкиУчастника, ЭлементСписка.ТекущиеДанные.Значение));
	Если РезультатПоиска.Количество() = 0 Тогда
		Возврат;
	Иначе
		Участник = РезультатПоиска[0];
	КонецЕсли;
	
	Если Участник.НомерСтроки = ТабЧасть.Количество() Тогда // Если ниже некуда, ничего не делаем.
		Возврат;
	КонецЕсли;
	
	// Сдвигаем
	НомерУчастника = Участник.НомерСтроки;
	ТабЧасть.Сдвинуть(НомерУчастника - 1, 1);
	Список.Сдвинуть(НомерУчастника - 1, 1);
	
	ЭтаФорма.Модифицированность = Истина;

КонецПроцедуры

&НаКлиенте
Процедура СписокЗначениеНачалоВыбораОтказ(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавленияОтказ(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура ПереместитьВверхСпециализации(Команда)
	
	ПереместитьВверх(Элементы.СписокСпециализаций, СписокСпециализаций, Объект.Специализации, "Специализация");
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВнизСпециализации(Команда)
	
	ПереместитьВниз(Элементы.СписокСпециализаций, СписокСпециализаций, Объект.Специализации, "Специализация");
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВверхСотрудники(Команда)
	
	ПереместитьВверх(Элементы.СписокСотрудников, СписокСотрудников, Объект.Сотрудники, "Сотрудник");
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВнизСотрудники(Команда)
	
	ПереместитьВниз(Элементы.СписокСотрудников, СписокСотрудников, Объект.Сотрудники, "Сотрудник");
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВверхКабинеты(Команда)
	
	ПереместитьВверх(Элементы.СписокКабинетов, СписокКабинетов, Объект.Кабинеты, "Кабинет");
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВнизКабинеты(Команда)
	
	ПереместитьВниз(Элементы.СписокКабинетов, СписокКабинетов, Объект.Кабинеты, "Кабинет");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервереБезКонтекста
Процедура ЗаполнитьСписокСпециализаций(Знач ТабЧастьСпециализации, ЗначениеПоиска, СписокСпециализаций)

	СписокСпециализаций.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ЗначениеПоиска", "%"+ЗначениеПоиска+"%");
	Запрос.УстановитьПараметр("ТабЧастьСпециализации", ТабЧастьСпециализации.Выгрузить()); 
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТабЧастьСпециализации.Специализация КАК Специализация,
	|	ТабЧастьСпециализации.НомерСтроки
	|ПОМЕСТИТЬ ОбъектРаботы
	|ИЗ
	|	&ТабЧастьСпециализации КАК ТабЧастьСпециализации
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(Специализации.НомерСтроки) КАК НомерСтроки,
	|	МАКСИМУМ(Специализации.Пометка) КАК Пометка,
	|	Специализации.Специализация КАК Ссылка,
	|	Специализации.Специализация.Представление КАК Представление
	|ИЗ
	|	(ВЫБРАТЬ
	|		ОбъектРаботы.НомерСтроки КАК НомерСтроки,
	|		ИСТИНА КАК Пометка,
	|		ОбъектРаботы.Специализация КАК Специализация
	|	ИЗ
	|		ОбъектРаботы КАК ОбъектРаботы
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		0,
	|		ЛОЖЬ,
	|		Специализации.Ссылка
	|	ИЗ
	|		Справочник.КатегорииВыработки КАК Специализации
	|	ГДЕ
	|		НЕ Специализации.ЭтоГруппа
	|		И Специализации.Наименование ПОДОБНО &ЗначениеПоиска
	|		И НЕ Специализации.ПометкаУдаления) КАК Специализации
	|
	|СГРУППИРОВАТЬ ПО
	|	Специализации.Специализация,
	|	Специализации.Специализация.Представление
	|
	|УПОРЯДОЧИТЬ ПО
	|	Пометка УБЫВ,
	|	НомерСтроки,
	|	Специализации.Специализация.Наименование";
	Выб = Запрос.Выполнить().Выбрать();
	Пока Выб.Следующий() Цикл
		ЭлементСписка = СписокСпециализаций.Добавить(Выб.Ссылка, Выб.Представление,Выб.Пометка);
	КонецЦикла;

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьСписокСотрудников(Знач ТабЧастьСотрудники, ЗначениеПоиска, СписокСотрудников)

	СписокСотрудников.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ЗначениеПоиска", "%"+ЗначениеПоиска+"%");
	Запрос.УстановитьПараметр("ТабЧастьСотрудники", ТабЧастьСотрудники.Выгрузить()); 
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТабЧастьСотрудники.Сотрудник,
	|	ТабЧастьСотрудники.НомерСтроки
	|ПОМЕСТИТЬ ОбъектРаботы
	|ИЗ
	|	&ТабЧастьСотрудники КАК ТабЧастьСотрудники
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(Сотрудники.НомерСтроки) КАК НомерСтроки,
	|	МАКСИМУМ(Сотрудники.ВЭлементе) КАК ВЭлементе,
	|	Сотрудники.Сотрудник КАК Сотрудник,
	|	Сотрудники.Сотрудник.Представление КАК Представление
	|ИЗ
	|	(ВЫБРАТЬ
	|		ОбъектРаботы.НомерСтроки КАК НомерСтроки,
	|		ИСТИНА КАК ВЭлементе,
	|		ОбъектРаботы.Сотрудник КАК Сотрудник
	|	ИЗ
	|		ОбъектРаботы КАК ОбъектРаботы
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		0,
	|		ЛОЖЬ,
	|		Сотрудники.Ссылка
	|	ИЗ
	|		Справочник.Сотрудники КАК Сотрудники
	|	ГДЕ
	|		НЕ Сотрудники.ЭтоГруппа
	|		И Сотрудники.Наименование ПОДОБНО &ЗначениеПоиска
	|		И НЕ Сотрудники.ПометкаУдаления
	|		И НЕ Сотрудники.Архив) КАК Сотрудники
	|
	|СГРУППИРОВАТЬ ПО
	|	Сотрудники.Сотрудник,
	|	Сотрудники.Сотрудник.Представление
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВЭлементе УБЫВ,
	|	НомерСтроки,
	|	Сотрудники.Сотрудник.Наименование";
	ВыбСотрудники = Запрос.Выполнить().Выбрать();
	Пока ВыбСотрудники.Следующий() Цикл
		
		ЭлементСписка = СписокСотрудников.Добавить(ВыбСотрудники.Сотрудник, ВыбСотрудники.Представление);
		ЭлементСписка.Пометка = ВыбСотрудники.ВЭлементе;
		
	КонецЦикла;

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьСписокКабинетов(Знач ТабЧастьКабинеты, ЗначениеПоиска, СписокКабинетов)

	СписокКабинетов.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ЗначениеПоиска", "%"+ЗначениеПоиска+"%");
	Запрос.УстановитьПараметр("ТабЧастьКабинеты", ТабЧастьКабинеты.Выгрузить()); 
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТабЧастьКабинеты.Кабинет,
	|	ТабЧастьКабинеты.НомерСтроки
	|ПОМЕСТИТЬ ОбъектРаботы
	|ИЗ
	|	&ТабЧастьКабинеты КАК ТабЧастьКабинеты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(Кабинеты.НомерСтроки) КАК НомерСтроки,
	|	МАКСИМУМ(Кабинеты.ВЭлементе) КАК ВЭлементе,
	|	Кабинеты.Кабинет КАК Кабинет,
	|	Кабинеты.Кабинет.Представление КАК Представление
	|ИЗ
	|	(ВЫБРАТЬ
	|		ОбъектРаботы.НомерСтроки КАК НомерСтроки,
	|		ИСТИНА КАК ВЭлементе,
	|		ОбъектРаботы.Кабинет КАК Кабинет
	|	ИЗ
	|		ОбъектРаботы КАК ОбъектРаботы
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		0,
	|		ЛОЖЬ,
	|		Кабинеты.Ссылка
	|	ИЗ
	|		Справочник.Оборудование КАК Кабинеты
	|	ГДЕ
	|		НЕ Кабинеты.ЭтоГруппа
	|		И Кабинеты.Наименование ПОДОБНО &ЗначениеПоиска
	|		И НЕ Кабинеты.ПометкаУдаления) КАК Кабинеты
	|
	|СГРУППИРОВАТЬ ПО
	|	Кабинеты.Кабинет
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВЭлементе УБЫВ,
	|	НомерСтроки,
	|	Кабинеты.Кабинет.Наименование";
	ВыбКабинеты = Запрос.Выполнить().Выбрать();
	Пока ВыбКабинеты.Следующий() Цикл
		
		ЭлементСписка = СписокКабинетов.Добавить(ВыбКабинеты.Кабинет, ВыбКабинеты.Представление);
		ЭлементСписка.Пометка = ВыбКабинеты.ВЭлементе;
		
	КонецЦикла;

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОбновитьСортировкуСпискаУчастников(СписокУчастников, Знач ТабЧасть, ИмяКолонкиУчастника)
	
	ТаблицаУчастников = Новый ТаблицаЗначений;
	ТаблицаУчастников.Колонки.Добавить("Значение");
	ТаблицаУчастников.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	ТаблицаУчастников.Колонки.Добавить("Пометка", Новый ОписаниеТипов("Булево"));
	ТаблицаУчастников.Колонки.Добавить("НомерСтроки", Новый ОписаниеТипов("Число"));
	
	Для Каждого ЭлементСписка Из СписокУчастников Цикл
		
		СтрокаТаблицы = ТаблицаУчастников.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ЭлементСписка);
		
		мсСтрокиаТабЧасти = ТабЧасть.НайтиСтроки(Новый Структура(ИмяКолонкиУчастника, ЭлементСписка.Значение));
		Если мсСтрокиаТабЧасти.Количество() <> 0 Тогда
			СтрокаТаблицы.НомерСтроки = мсСтрокиаТабЧасти[0].НомерСтроки;
		КонецЕсли;
	КонецЦикла;
	
	ТаблицаУчастников.Сортировать("Пометка УБЫВ, НомерСтроки, Представление");
	
	СписокУчастников.Очистить();
	Для Каждого СтрокаТаблицы Из ТаблицаУчастников Цикл
		СписокУчастников.Добавить(СтрокаТаблицы.Значение, СтрокаТаблицы.Представление, СтрокаТаблицы.Пометка);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти



