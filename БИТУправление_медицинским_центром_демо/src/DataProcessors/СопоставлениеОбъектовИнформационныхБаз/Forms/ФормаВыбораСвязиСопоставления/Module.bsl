
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаВыбора.Загрузить(ПолучитьИзВременногоХранилища(Параметры.АдресВременногоХранилища));
	
	// Удаляем переданную таблицу из временного хранилища
	УдалитьИзВременногоХранилища(Параметры.АдресВременногоХранилища);
	
	// Устанавливаем видимость и заголовки полей таблицы выбора
	УстановитьВидимостьПолейТаблицы("ТаблицаВыбора", Параметры.МаксимальноеКоличествоПользовательскихПолей, Параметры.СписокИспользуемыхПолей);
	
	// Позиционируем курсор таблицы выбора
	ПозиционированиеКурсораТаблицыВыбора(Параметры.НомерПоПорядкуСтрокиНачала);
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ТекущиеДанные = Элементы.ТаблицаВыбора.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭтаФорма.Закрыть(ТекущиеДанные.НомерПоПорядку);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаВыбораВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Выбрать(Неопределено);
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////

// ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПозиционированиеКурсораТаблицыВыбора(Знач НомерПоПорядкуСтрокиНачала)
	
	ИндексСтроки = 0;
	
	Пока  (ИндексСтроки <= ТаблицаВыбора.Количество() - 1)
		И (ТаблицаВыбора[ИндексСтроки]["НомерПоПорядку"] < НомерПоПорядкуСтрокиНачала) Цикл
		
		ИндексСтроки = ИндексСтроки + 1;
		
	КонецЦикла;
	
	Если ИндексСтроки <= ТаблицаВыбора.Количество() - 1 Тогда
		
		Элементы.ТаблицаВыбора.ТекущаяСтрока = ТаблицаВыбора[ИндексСтроки].ПолучитьИдентификатор();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьПолейТаблицы(ИмяТаблицыФормы, МаксимальноеКоличествоПользовательскихПолей, СписокИспользуемыхПолей)
	
	ИмяПоляИсточника = СтрЗаменить("#ИмяТаблицыФормы#ПолеСортировкиNN","#ИмяТаблицыФормы#", ИмяТаблицыФормы);
	ИмяПоляПриемника = СтрЗаменить("#ИмяТаблицыФормы#ПолеСортировкиNN","#ИмяТаблицыФормы#", ИмяТаблицыФормы);
	
	// Снимаем видимость всех полей таблицы сопоставления
	Для НомерПоля = 1 По МаксимальноеКоличествоПользовательскихПолей Цикл
		
		ПолеИсточника = СтрЗаменить(ИмяПоляИсточника, "NN", Строка(НомерПоля));
		ПолеПриемника = СтрЗаменить(ИмяПоляПриемника, "NN", Строка(НомерПоля));
		
		ЭтаФорма.Элементы[ПолеИсточника].Видимость = Ложь;
		ЭтаФорма.Элементы[ПолеПриемника].Видимость = Ложь;
		
	КонецЦикла;
	
	// Устанавливаем видимость полей таблицы сопоставления выбранных пользователем.
	Для Каждого Элемент ИЗ СписокИспользуемыхПолей Цикл
		
		НомерПоля = СписокИспользуемыхПолей.Индекс(Элемент) + 1;
		
		ПолеИсточника = СтрЗаменить(ИмяПоляИсточника, "NN", Строка(НомерПоля));
		ПолеПриемника = СтрЗаменить(ИмяПоляПриемника, "NN", Строка(НомерПоля));
		
		// Устанавливаем видимость полей
		ЭтаФорма.Элементы[ПолеИсточника].Видимость = Элемент.Пометка;
		ЭтаФорма.Элементы[ПолеПриемника].Видимость = Элемент.Пометка;
		
		// Устанавливаем заголовки полей
		ЭтаФорма.Элементы[ПолеИсточника].Заголовок = Элемент.Значение;
		ЭтаФорма.Элементы[ПолеПриемника].Заголовок = Элемент.Значение;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

