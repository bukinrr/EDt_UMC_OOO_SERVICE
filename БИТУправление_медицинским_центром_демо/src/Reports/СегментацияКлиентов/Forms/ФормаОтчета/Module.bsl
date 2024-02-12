#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура")
		И ВыбранноеЗначение.Свойство("ВидыСегментацииКолонок")
		И ВыбранноеЗначение.Свойство("ВидыСегментацииСтрок")
	Тогда
		ПолучитьПрименитьНовыеНастройки(ВыбранноеЗначение.ВидыСегментацииКолонок, ВыбранноеЗначение.ВидыСегментацииСтрок)
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КонструкторСтруктуры(Команда)
	ОткрытьФорму("Отчет.СегментацияКлиентов.Форма.ФормаНастройкиСтруктуры",,ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПолучитьПрименитьНовыеНастройки(Знач ВидыСегментацииКолонок, Знач ВидыСегментацииСтрок)
	
	СхемаКомпоновкиДанных = Отчеты.СегментацияКлиентов.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	
	НастройкиКомпоновки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	
	ОтчетОбъект = РеквизитФормыВЗначение("Отчет");
	КомпоновщикНастроек = ОтчетОбъект.КомпоновщикНастроек;
	
	КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиКомпоновки);
	КомпоновщикНастроек.Настройки.Структура.Очистить();
	
	ЭлементСтруктурыНастроек = КомпоновщикНастроек.Настройки.Структура.Добавить(Тип("ТаблицаКомпоновкиДанных"));
	ЭлементСтруктурыНастроек.Использование = Истина;
	
	СтруктураНастроекТаблицы = КомпоновщикНастроек.Настройки.Структура[0];
	
	Если ВидыСегментацииКолонок.Количество() > 0 Тогда
		
		ГруппировкаПоВиду = СтруктураНастроекТаблицы.Колонки.Добавить();
		ГруппировкаПоВиду.Имя = "ВидСегментации";
		ГруппировкаПоВиду.Использование = Истина;
		
		Для Каждого ЭлементНастройки Из КомпоновщикНастроек.Настройки.Выбор.Элементы Цикл
			ЭлементНовойНастройки = ГруппировкаПоВиду.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
			ЭлементНовойНастройки.Использование = Истина;
		КонецЦикла;
		
		Для Каждого Элемент Из ВидыСегментацииКолонок Цикл
			Если Элемент.Используется Тогда
				ПолеГруппировкиСклад = ГруппировкаПоВиду.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));       
				ПолеГруппировкиСклад.Использование      = Истина;
				ПолеГруппировкиСклад.Поле               = Новый ПолеКомпоновкиДанных("Клиент." + Элемент.Ссылка.Наименование);
				ПолеГруппировкиСклад.ТипГруппировки 	= ТипГруппировкиКомпоновкиДанных.Элементы;
				ПолеГруппировкиСклад.ТипДополнения      = ТипДополненияПериодаКомпоновкиДанных.БезДополнения;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если ВидыСегментацииСтрок.Количество() > 0 Тогда
		
		ГруппировкаПоВиду = СтруктураНастроекТаблицы.Строки.Добавить();
		ГруппировкаПоВиду.Имя = "ВидСегментации";
		ГруппировкаПоВиду.Использование = Истина;
		
		Для Каждого ЭлементНастройки Из КомпоновщикНастроек.Настройки.Выбор.Элементы Цикл
			ЭлементНовойНастройки = ГруппировкаПоВиду.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
			ЭлементНовойНастройки.Использование = Истина;
		КонецЦикла;

		Для Каждого Элемент Из ВидыСегментацииСтрок Цикл
			Если Элемент.Используется Тогда
				ПолеГруппировкиСклад = ГруппировкаПоВиду.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));       
				ПолеГруппировкиСклад.Использование      = Истина;
				ПолеГруппировкиСклад.Поле               = Новый ПолеКомпоновкиДанных("Клиент." + Элемент.Ссылка.Наименование);
				ПолеГруппировкиСклад.ТипГруппировки 	= ТипГруппировкиКомпоновкиДанных.Элементы;
				ПолеГруппировкиСклад.ТипДополнения      = ТипДополненияПериодаКомпоновкиДанных.БезДополнения;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных);
	КомпоновщикНастроек.Инициализировать(ИсточникНастроек);
	
	ЗначениеВРеквизитФормы(ОтчетОбъект, "Отчет");
	
КонецПроцедуры

#КонецОбласти
