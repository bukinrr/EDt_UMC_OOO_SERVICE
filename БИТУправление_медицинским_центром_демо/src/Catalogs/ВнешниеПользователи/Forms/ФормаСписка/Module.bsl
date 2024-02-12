#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПоказыватьНедействительныхПользователей = Ложь;
	
	Если Не Параметры.РежимВыбора Тогда
		
		// Только если не режим выбора, делаем фильтрацию.
		Если ПоказыватьНедействительныхПользователей Тогда
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(ВнешниеПользователиСписок.Отбор, "Недействителен");
		Иначе	
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
				ВнешниеПользователиСписок.Отбор,
				"Недействителен",
				Ложь);
		КонецЕсли;
			
	КонецЕсли;
	
	ИспользоватьГруппы = ПолучитьФункциональнуюОпцию("ИспользоватьГруппыПользователей");
	
	Если ТипЗнч(Параметры.ТекущаяСтрока) = Тип("СправочникСсылка.ГруппыВнешнихПользователей") Тогда
		Если ИспользоватьГруппы Тогда
			Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока = Параметры.ТекущаяСтрока;
		Иначе
			Параметры.ТекущаяСтрока = Неопределено;
		КонецЕсли;
	Иначе
		ТекущийЭлемент = Элементы.ВнешниеПользователиСписок;
		Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока = Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи;
		ОбновитьЗначениеПараметраКомпоновкиДанных(ВнешниеПользователиСписок, "ГруппаВнешнихПользователей", Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи);
		ОбновитьЗначениеПараметраКомпоновкиДанных(ВнешниеПользователиСписок, "ВыбиратьИерархически", Истина);
	КонецЕсли;
	
	Если НЕ ИспользоватьГруппы Тогда
		Параметры.ВыборГруппВнешнихПользователей = Ложь;
		Элементы.ГруппаПоказыватьВнешнихПользователейДочернихГрупп.Видимость = Ложь;
		Элементы.СоздатьГруппуВнешнихПользователей.Видимость = Ложь;
	КонецЕсли;
	
	Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("ОбъектАвторизации") Тогда
		ОтборОбъектАвторизации = Параметры.Отбор.ОбъектАвторизации;
	КонецЕсли;
	
	// Настройка постоянных данных для списка пользователей.
	ОбновитьЗначениеПараметраКомпоновкиДанных(ВнешниеПользователиСписок, "ПустойУникальныйИдентификатор", Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
	ГруппаВнешнихПользователейВсеПользователи = Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи;
	
	// Подготовка представлений типов объектов авторизации.
	Для каждого ТекущийТипОбъектовАвторизации Из Метаданные.Справочники.ВнешниеПользователи.Реквизиты.ОбъектАвторизации.Тип.Типы() Цикл
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(ТекущийТипОбъектовАвторизации);
		ОписаниеТипа = Новый ОписаниеТипов(МассивТипов);
		ПредставлениеТиповОбъектовАвторизации.Добавить(ОписаниеТипа.ПривестиЗначение(Неопределено), Метаданные.НайтиПоТипу(ТекущийТипОбъектовАвторизации).Синоним);
	КонецЦикла;
	
	Если НЕ ПравоДоступа("Добавление", Метаданные.Справочники.ГруппыВнешнихПользователей) Тогда
		Элементы.СоздатьГруппуВнешнихПользователей.Видимость = Ложь;
	КонецЕсли;
	Если НЕ ПравоДоступа("Добавление", Метаданные.Справочники.ВнешниеПользователи) Тогда
		Элементы.СоздатьВнешнегоПользователя.Видимость = Ложь;
	КонецЕсли;
	
	Если Параметры.РежимВыбора Тогда
		
		Если Элементы.Найти("ПользователиИБ") <> Неопределено Тогда
			Элементы.ПользователиИБ.Видимость = Ложь;
		КонецЕсли;
		
		Параметры.Свойство("ТипОбъектовАвторизации", ТипОбъектовАвторизации);
		
		// Отбор не помеченных на удаление.
		ВнешниеПользователиСписок.Отбор.Элементы[0].Использование = Истина;
		
		Элементы.ВнешниеПользователиСписок.РежимВыбора         = Истина;
		Элементы.ВыбратьГруппуВнешнихПользователей.Видимость   =    Параметры.ВыборГруппВнешнихПользователей;
		Элементы.ГруппыВнешнихПользователей.РежимВыбора        =    Параметры.ВыборГруппВнешнихПользователей;
		Элементы.ВыбратьВнешнегоПользователя.КнопкаПоУмолчанию = НЕ Параметры.ВыборГруппВнешнихПользователей;
		
		Если Параметры.ЗакрыватьПриВыборе = Ложь Тогда
			// Режим подбора
			Элементы.ВнешниеПользователиСписок.МножественныйВыбор = Истина;
			
			Если Параметры.ВыборГруппВнешнихПользователей Тогда
				Заголовок                                              = НСтр("ru = 'Подбор внешних пользователей и групп'");
				Элементы.ВыбратьВнешнегоПользователя.Заголовок         = НСтр("ru = 'Выбрать внешних пользователей'");
				Элементы.ВыбратьГруппуВнешнихПользователей.Заголовок   = НСтр("ru = 'Выбрать группы'");
				
				Элементы.ГруппыВнешнихПользователей.МножественныйВыбор = Истина;
				Элементы.ГруппыВнешнихПользователей.РежимВыделения     = РежимВыделенияТаблицы.Множественный;
			Иначе
				Заголовок                                              = НСтр("ru = 'Подбор внешних пользователей'");
			КонецЕсли;
		Иначе
			// Режим выбора
			Если Параметры.ВыборГруппВнешнихПользователей Тогда
				Заголовок                                              = НСтр("ru = 'Выбор внешнего пользователя или группы'");
				Элементы.ВыбратьВнешнегоПользователя.Заголовок         = НСтр("ru = 'Выбрать внешнего пользователя'");
			Иначе
				Заголовок                                              = НСтр("ru = 'Выбор внешнего пользователя'");
			КонецЕсли;
		КонецЕсли;
	Иначе
		Элементы.ВыбратьВнешнегоПользователя.Видимость       = Ложь;
		Элементы.ВыбратьГруппуВнешнихПользователей.Видимость = Ложь;
	КонецЕсли;
	
	ОбновитьЗначениеПараметраКомпоновкиДанных(ГруппыВнешнихПользователей, "ЛюбойТипОбъектовАвторизации", ТипОбъектовАвторизации = Неопределено);
	ОбновитьЗначениеПараметраКомпоновкиДанных(ГруппыВнешнихПользователей, "ТипОбъектовАвторизации",      ТипЗнч(ТипОбъектовАвторизации));
	
	ОбновитьЗначениеПараметраКомпоновкиДанных(ВнешниеПользователиСписок, "ЛюбойТипОбъектовАвторизации", ТипОбъектовАвторизации = Неопределено);
	ОбновитьЗначениеПараметраКомпоновкиДанных(ВнешниеПользователиСписок, "ТипОбъектовАвторизации",      ТипЗнч(ТипОбъектовАвторизации));
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьСодержимоеФормыПриИзмененииГруппы(Элементы.ГруппыВнешнихПользователей.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененаГруппаВнешнихПользователей" Тогда
		
		Если Параметр = Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока Тогда
			Элементы.ГруппыВнешнихПользователей.Обновить();
			Элементы.ВнешниеПользователиСписок.Обновить();
			ОбновитьСодержимоеФормыПриИзмененииГруппы(Элементы.ГруппыВнешнихПользователей.ТекущиеДанные);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если Настройки[ВыбиратьИерархически] = Неопределено Тогда
		ВыбиратьИерархически = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
&НаКлиенте
Процедура ГруппыВнешнихПользователейПриАктивизацииСтроки(Элемент)
	
	ОбновитьСодержимоеФормыПриИзмененииГруппы(Элементы.ГруппыВнешнихПользователей.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыВнешнихПользователейВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОповеститьОВыборе(Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыВнешнихПользователейПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если НЕ Копирование Тогда
		Отказ = Истина;
		ПараметрыФормы = Новый Структура;
		
		Если ЗначениеЗаполнено(Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока) Тогда
			
			ПараметрыФормы.Вставить("ЗначенияЗаполнения", Новый Структура("Родитель", Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока));
		КонецЕсли;
		
		ОткрытьФорму("Справочник.ГруппыВнешнихПользователей.ФормаОбъекта", ПараметрыФормы, Элементы.ГруппыВнешнихПользователей);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешниеПользователиСписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОповеститьОВыборе(Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешниеПользователиСписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	ПараметрыФормы = Новый Структура("ГруппаНовогоВнешнегоПользователя", Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока);
	
	Если ОтборОбъектАвторизации <> Неопределено Тогда
		ПараметрыФормы.Вставить("ОбъектАвторизацииНовогоВнешнегоПользователя", ОтборОбъектАвторизации);
	КонецЕсли;
	
	Если Копирование И Элемент.ТекущиеДанные <> Неопределено Тогда
		ПараметрыФормы.Вставить("ЗначениеКопирования", Элемент.ТекущаяСтрока);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.ВнешниеПользователи.ФормаОбъекта", ПараметрыФормы, Элементы.ВнешниеПользователиСписок);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбиратьИерархическиПриИзменении(Элемент)
	
	ОбновитьСодержимоеФормыПриИзмененииГруппы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура СоздатьГруппуВнешнихПользователей(Команда)
	
	Элементы.ГруппыВнешнихПользователей.ДобавитьСтроку();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьНедействительныхПользователей(Команда)
	
	ПоказыватьНедействительныхПользователей = Не ПоказыватьНедействительныхПользователей;
	
	Элементы.ФормаПоказыватьНедействительныхПользователей.Пометка = ПоказыватьНедействительныхПользователей;
	
	Если ПоказыватьНедействительныхПользователей Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(ВнешниеПользователиСписок.Отбор, "Недействителен");
	Иначе	
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			ВнешниеПользователиСписок.Отбор,
			"Недействителен",
			Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаКлиенте
Процедура ОбновитьСодержимоеФормыПриИзмененииГруппы(Знач ТекущиеДанные = Неопределено)
	
	Если НЕ ИспользоватьГруппы
	 ИЛИ Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока = ГруппаВнешнихПользователейВсеПользователи Тогда
		
		ОписаниеОтображаемыхВнешнихПользователей = НСтр("ru = 'Все внешние пользователи'");
		
		Элементы.ГруппаПоказыватьВнешнихПользователейДочернихГрупп.ТекущаяСтраница = Элементы.ГруппаНельзяУстановитьСвойство;
		ОбновитьЗначениеПараметраКомпоновкиДанных(ВнешниеПользователиСписок, "ВыбиратьИерархически", Истина);
		
		ОбновитьЗначениеПараметраКомпоновкиДанных(ВнешниеПользователиСписок, "ГруппаВнешнихПользователей", ГруппаВнешнихПользователейВсеПользователи);
	Иначе
		Если Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока <> Неопределено И
		     ТекущиеДанные <> Неопределено И
		     ТекущиеДанные.ВсеОбъектыАвторизации Тогда
			//
			ЭлементПредставленияТипаОбъектаАвторизации = ПредставлениеТиповОбъектовАвторизации.НайтиПоЗначению(ТекущиеДанные.ТипОбъектовАвторизации);
			ОписаниеОтображаемыхВнешнихПользователей = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'Все %1'"),
							НРег(?(ЭлементПредставленияТипаОбъектаАвторизации = Неопределено, НСтр("ru = '<Недопустимый тип>'"), ЭлементПредставленияТипаОбъектаАвторизации.Представление)) );
			//
			Элементы.ГруппаПоказыватьВнешнихПользователейДочернихГрупп.ТекущаяСтраница = Элементы.ГруппаНельзяУстановитьСвойство;
			ОбновитьЗначениеПараметраКомпоновкиДанных(ВнешниеПользователиСписок, "ВыбиратьИерархически", Истина);
		Иначе
			Элементы.ГруппаПоказыватьВнешнихПользователейДочернихГрупп.ТекущаяСтраница = Элементы.ГруппаУстановитьСвойство;
			ОбновитьЗначениеПараметраКомпоновкиДанных(ВнешниеПользователиСписок, "ВыбиратьИерархически", ВыбиратьИерархически);
		КонецЕсли;
		ОбновитьЗначениеПараметраКомпоновкиДанных(ВнешниеПользователиСписок, "ГруппаВнешнихПользователей", Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьЗначениеПараметраКомпоновкиДанных(Знач ВладелецПараметров, Знач ИмяПараметра, Знач ЗначениеПараметра)
	
	Для каждого Параметр Из ВладелецПараметров.Параметры.Элементы Цикл
		Если Строка(Параметр.Параметр) = ИмяПараметра Тогда
			Если Параметр.Использование И Параметр.Значение = ЗначениеПараметра Тогда
				Возврат;
			КонецЕсли;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ВладелецПараметров.Параметры.УстановитьЗначениеПараметра(ИмяПараметра, ЗначениеПараметра);
	
КонецПроцедуры

#КонецОбласти
