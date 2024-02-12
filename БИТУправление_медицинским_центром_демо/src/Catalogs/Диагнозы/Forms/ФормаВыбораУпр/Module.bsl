
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.Сотрудник) Тогда
		Сотрудник = Параметры.Сотрудник;
	Иначе
		Сотрудник = ПараметрыСеанса.ТекущийПользователь.Сотрудник;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Сотрудник) Тогда
		
		Если ЗначениеЗаполнено(Сотрудник.Специализация) Тогда
			
			Специализация = Сотрудник.Специализация;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ОтборКодовДиагнозов) Тогда
		ОтборКодовДиагнозов = Параметры.ОтборКодовДиагнозов;
	ИначеЕсли Параметры.ВидНозологическойЕдиницы = Перечисления.КлассификацииДиагнозов.ВнешняяПричина Тогда
		// Отбор по кодам внешней причины.
		ОтборКодовДиагнозов = "S-Z"; // S00-Y99.
	Иначе
		// Просто отображение списка часто используемых (если есть).
		ВидГруппировки = Перечисления.ВидыГруппировкиДиагнозов.ЧастоИспользуемый;
	КонецЕсли;
	
	ЕстьОтборПоГруппамДиагнозов = ТипЗнч(Параметры.ГруппыДиагнозов) = Тип("Массив") И Параметры.ГруппыДиагнозов.Количество() <> 0;
	
	УстановитьОтборСписка(ЕстьОтборПоГруппамДиагнозов);
	
	УстановитьПерманентныйОтборПоКодаДиагнозов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЕстьОтборПоГруппамДиагнозов Тогда
		НастроитьФормуДляГруппДиагнозов(Параметры.ГруппыДиагнозов);		
	КонецЕсли;
	
	НастроитьДоступностьЭлементов();
	РаботаСДиалогамиКлиент.СкрытьПоказатьАрхивные(Элементы.ФормаСкрытьПоказатьАрхивные, Список, Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоместитьВАрхив(Команда)

	РаботаСДиалогамиКлиент.ПоместитьВАрхив(Элементы.Список.ВыделенныеСтроки);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьПоказатьАрхивные(Команда)

	РаботаСДиалогамиКлиент.СкрытьПоказатьАрхивные(Элементы.ФормаСкрытьПоказатьАрхивные, Список);
	
КонецПроцедуры
 
#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОбновлениеСостояния(Элемент)
	
	НастроитьДоступностьЭлементов();
	
	УстановитьОтборСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	Если ЗначениеЗаполнено(ВыбраннаяСтрока)
		И ТипЗнч(ВыбраннаяСтрока) <> Тип("Массив")
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВыбраннаяСтрока, "ЭтоГруппа")
	Тогда
		СтандартнаяОбработка = Ложь;
		Если Элемент.Развернут(ВыбраннаяСтрока) Тогда
			Элемент.Свернуть(ВыбраннаяСтрока);
		Иначе
			Элемент.Развернуть(ВыбраннаяСтрока);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура НастроитьДоступностьЭлементов()
	
	Элементы.ВидГруппировки.Доступность = ЗначениеЗаполнено(Специализация);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборСписка(ЕстьОтборПоГруппамДиагнозов = Ложь)
	
	Если ЗначениеЗаполнено(Специализация)
		И ЗначениеЗаполнено(ВидГруппировки)
		И Не ЕстьОтборПоГруппамДиагнозов
	Тогда
		
		Запрос = Новый Запрос;
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ГруппыДиагнозов.Диагноз
		|ИЗ
		|	РегистрСведений.ГруппыДиагнозов КАК ГруппыДиагнозов
		|ГДЕ
		|	ГруппыДиагнозов.Специализация = &Специализация
		|	И ГруппыДиагнозов.ВидГруппировкиДиагнозов = &ВидГруппировки";
		
		Запрос.УстановитьПараметр("Специализация", Специализация);
		
		Запрос.УстановитьПараметр("ВидГруппировки", ВидГруппировки);
		
		Выгрузка = Запрос.Выполнить().Выгрузить();
		
		Если Выгрузка.Количество() > 0 Тогда
			
			СписокЗначений = Новый СписокЗначений;
			
			Для Каждого Строка Из Выгрузка Цикл
				
				СписокЗначений.Добавить(Строка.Диагноз);	
				
			КонецЦикла;
			
			РаботаСФормамиСервер.УстановитьОтборСписка("Ссылка", СписокЗначений, Список);
			
			Если Элементы.Список.Отображение = ОтображениеТаблицы.Дерево Тогда
				Элементы.Список.Отображение = ОтображениеТаблицы.Список;
			КонецЕсли;
			
		Иначе
			ОтобразитьОбщийСписокДиагнозов();
		КонецЕсли;
	Иначе
		ОтобразитьОбщийСписокДиагнозов();
		Элементы.Список.ТекущаяСтрока = Неопределено;
	КонецЕсли;
		
КонецПроцедуры 

&НаСервере
Процедура ОтобразитьОбщийСписокДиагнозов()
	
	РаботаСФормамиСервер.ОтключитьВсеОтборыСписка(Список);
	Если Элементы.Список.Отображение = ОтображениеТаблицы.Список Тогда
		Элементы.Список.Отображение = ОтображениеТаблицы.Дерево;
	КонецЕсли;
	
КонецПроцедуры

// Однократно при открытии формы.
&НаСервере
Процедура УстановитьПерманентныйОтборПоКодаДиагнозов()
	
	Если Не ПустаяСтрока(ОтборКодовДиагнозов) Тогда
		
		ИмяГруппыОтбораБазовое = "ОтборКодыДиагнозов";
		Сч = 0;
		
		ЭлементУОФ = Список.УсловноеОформление.Элементы.Добавить();
		ЭлементУОФ.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
		ЭлементУОФ.Использование = Истина;
		ОтборЭлемента = ЭлементУОФ.Отбор;
		
		ОтборыПары = СтрРазделить(ОтборКодовДиагнозов, ";", Ложь);
		Для Каждого ОтборПара Из ОтборыПары Цикл
			
			ИмяГруппыОтбора = ИмяГруппыОтбораБазовое + Формат(Сч, "ЧГ=");
			
			Отборы = СтрРазделить(ОтборПара, "-", Ложь);
			Если Отборы.Количество() = 2 Тогда
				
				ГруппаОтбора = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(ЭлементУОФ.Отбор.Элементы, ИмяГруппыОтбора, ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаНе);
				
				ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(ГруппаОтбора);
				ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаОтбора, "КодДиагноза", ВидСравненияКомпоновкиДанных.БольшеИлиРавно, СокрЛП(Отборы[0]), "Код диагноза от", Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный); 
				ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаОтбора, "КодДиагноза", ВидСравненияКомпоновкиДанных.МеньшеИлиРавно, СокрЛП(Отборы[1]), "Код диагноза до", Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный); 
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьФормуДляГруппДиагнозов(ГруппыДиагнозов)
	
	Элементы.ГруппаВидГруппировки.Доступность = Ложь; 
	Специализация = Неопределено;
					
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Родитель", ГруппыДиагнозов, ВидСравненияКомпоновкиДанных.ВИерархии);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ЭтоГруппа", Ложь, ВидСравненияКомпоновкиДанных.Равно);
	
	Элементы.Список.Отображение = ОтображениеТаблицы.Список;
	
КонецПроцедуры

#КонецОбласти