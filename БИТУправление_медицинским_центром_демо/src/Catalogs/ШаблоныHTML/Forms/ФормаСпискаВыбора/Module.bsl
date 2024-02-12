#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметр = Параметры.Параметр;
	ВидКлассификатора = Параметр.ВидКлассификатора;
	
	Элементы.СписокВыбораЗначение.ОграничениеТипа = Параметр.ТипЗначения;
	Элементы.СписокВыбораЗначение.ВыбиратьТип = Ложь;
	Элементы.ФормаЗаполнитьЗначенияВыбора.Видимость = Параметр.ТипЗначения.СодержитТип(Тип("СправочникСсылка.ДополнительныеЗначенияХарактеристик"));
	
	Если Параметры.Свойство("ЭлементыСпискаВыбора") Тогда
		Для Каждого ЭлементСпискаВыбора Из РаботаСШаблонамиHTML.ПреобразоватьЗначенияИзСтрокиВнутр(Параметры.ЭлементыСпискаВыбора) Цикл
			НовыйЭлементСпискаВыбора = СписокВыбора.Добавить();
			Попытка
				НовыйЭлементСпискаВыбора.Значение = ЭлементСпискаВыбора;
			Исключение КонецПопытки;
			НовыйЭлементСпискаВыбора.Представление = НовыйЭлементСпискаВыбора.Значение;
			Если Параметры.НомерСтрокиПоУмолчанию <> Неопределено И СписокВыбора.Индекс(НовыйЭлементСпискаВыбора) = Параметры.НомерСтрокиПоУмолчанию Тогда
				НовыйЭлементСпискаВыбора.ПоУмолчанию = Истина;
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли Параметр.ТипЗначения.СодержитТип(Тип("СправочникСсылка.ДополнительныеЗначенияХарактеристик")) Тогда
		ЗаполнитьТаблицуЗначенийДопХарактеристик(Параметр);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокВыбора

&НаКлиенте
Процедура СписокВыбораПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Элементы.СписокВыбора.ТекущиеДанные.Значение = Элементы.СписокВыбора.ПодчиненныеЭлементы.СписокВыбораЗначение.ОграничениеТипа.ПривестиЗначение(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбораЗначениеПриИзменении(Элемент)
	
	Элементы.СписокВыбора.ТекущиеДанные.Представление = Строка(Элементы.СписокВыбора.ТекущиеДанные.Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбораПоУмолчаниюПриИзменении(Элемент)
	
	Для Каждого Строка Из СписокВыбора Цикл
		Если Строка.Значение <> Элементы.СписокВыбора.ТекущиеДанные.Значение Тогда
			Строка.ПоУмолчанию = Ложь;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбораЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если Элементы.СписокВыбора.ПодчиненныеЭлементы.СписокВыбораЗначение.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.ДополнительныеЗначенияХарактеристик") Тогда
		
		СтандартнаяОбработка = Ложь;
		ПараметрыФормыВыбора = Новый Структура("ВладелецПараметра", Параметр);
		ФормаВыбораЗначенияПараметра = ПолучитьФорму("Справочник.ДополнительныеЗначенияХарактеристик.ФормаВыбора", ПараметрыФормыВыбора);
		
		Элементы.СписокВыбора.ТекущиеДанные.Значение = ФормаВыбораЗначенияПараметра.ОткрытьМодально();
		Элементы.СписокВыбора.ТекущиеДанные.Представление = Строка(Элементы.СписокВыбора.ТекущиеДанные.Значение);
		
	ИначеЕсли Элементы.СписокВыбора.ПодчиненныеЭлементы.СписокВыбораЗначение.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.КлассификаторыМинЗдрава") Тогда
		
		НовыйМассив = Новый Массив();
		НовыйМассив.Добавить(Новый ПараметрВыбора("Отбор.ВидКлассификатора", ВидКлассификатора));
		
		НовыеПараметры = Новый ФиксированныйМассив(НовыйМассив);
		Элемент.ПараметрыВыбора = НовыеПараметры;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаСохранить(Команда)
	
	Если СписокВыбора.Количество() > 0 Тогда
		
		Массив = Новый Массив;
		Для Каждого Строка Из СписокВыбора Цикл
			Структура = Новый Структура("Значение, Представление, ПоУмолчанию", Строка.Значение, Строка.Представление, Строка.ПоУмолчанию);
			Массив.Добавить(Структура);
		КонецЦикла;
		ЭтаФорма.Закрыть(Массив);
	Иначе
		ЭтаФорма.Закрыть(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	
	ЗаполнитьТаблицуЗначенийДопХарактеристик(Параметр);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункциий

&НаСервере
Процедура ЗаполнитьТаблицуЗначенийДопХарактеристик(Ссылка)
	
	Запрос = Новый Запрос();
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ДополнительныеЗначенияХарактеристик.Ссылка КАК Значение,
		|	ДополнительныеЗначенияХарактеристик.Представление КАК Представление,
		|	ДополнительныеЗначенияХарактеристик.Владелец.ЗначениеПоУмолчанию = ДополнительныеЗначенияХарактеристик.Ссылка КАК ПоУмолчанию
		|ИЗ
		|	Справочник.ДополнительныеЗначенияХарактеристик КАК ДополнительныеЗначенияХарактеристик
		|ГДЕ
		|	ДополнительныеЗначенияХарактеристик.Владелец = &Владелец
		|	И НЕ ДополнительныеЗначенияХарактеристик.ПометкаУдаления
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПоУмолчанию УБЫВ,
		|	Представление";
	
	Запрос.УстановитьПараметр("Владелец",Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	СписокВыбора.Очистить();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = СписокВыбора.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,Выборка);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти