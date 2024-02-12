#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	ТекущиеНастройкиКонтроляКМ = КонтрольКодовМаркировкиМДЛП.НастройкиКонтроляКМ();
	
	КлючГруппыНастроекКонтроляКМ = Параметры.КлючГруппыНастроекКонтроляКМ;
	
	ЗаполнитьТаблицуИсключений();
	ЗаполнитьИтоговыеПредставления();
	
	СобытияФормМДЛППереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ВладелецФормы = Неопределено Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Открытие формы без владельца не предусмотренно'"),,,, Отказ);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	СохранитьНастройкиИсключений();
	Закрыть(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Отметить(Команда)
	
	УстановитьСнятьОтметку();
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьОтметку(Команда)
	
	УстановитьСнятьОтметку(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ТаблицаИсключенийПриИзменении(Элемент)
	
	ПриИзмененииТаблицыИсключений();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаИсключенийОтметка.Имя);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Элемент.Отбор,
		"ТаблицаИсключений.ОграничитьОтключение", Истина);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуИсключений()
	
	ТаблицаИсключений.Очистить();
	
	Если Не ЗначениеЗаполнено(КлючГруппыНастроекКонтроляКМ) Тогда
		Возврат;
	КонецЕсли;
	
	ГруппаНастроек = КонтрольКодовМаркировкиМДЛПКлиентСервер.ЗначениеГруппыНастроекКонтроляКМ(ТекущиеНастройкиКонтроляКМ, КлючГруппыНастроекКонтроляКМ);
	
	ДопустимыеОперации = КонтрольКодовМаркировкиМДЛП.ДопустимыеОперацииКонтроляКМ(КлючГруппыНастроекКонтроляКМ);
	
	Для Каждого КлючИЗначение Из ДопустимыеОперации Цикл
		
		Операция         = КлючИЗначение.Ключ;
		СвойстваОперации = КлючИЗначение.Значение;
		
		НоваяСтрока                         = ТаблицаИсключений.Добавить();
		НоваяСтрока.Исключение              = Операция;
		НоваяСтрока.ПредставлениеИсключения = СвойстваОперации.Представление;
		НоваяСтрока.ОграничитьОтключение    = СвойстваОперации.ОграничитьОтключение;
		Если Не НоваяСтрока.ОграничитьОтключение Тогда
			НоваяСтрока.Отметка = ГруппаНастроек.Исключения.Получить(НоваяСтрока.Исключение) <> Неопределено;
		КонецЕсли;
		
	КонецЦикла;
	
	ТаблицаИсключений.Сортировать("ПредставлениеИсключения");
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСнятьОтметку(Отметка = Истина)
	
	Если Элементы.ТаблицаИсключений.ВыделенныеСтроки.Количество() > 1 Тогда
		Для Каждого ВыделеннаяСтрока Из Элементы.ТаблицаИсключений.ВыделенныеСтроки Цикл
			СтрокаТаблицы = ТаблицаИсключений.НайтиПоИдентификатору(ВыделеннаяСтрока);
			Если Не Отметка И СтрокаТаблицы.ОграничитьОтключение Тогда
				Продолжить;
			КонецЕсли;
			СтрокаТаблицы.Отметка = Отметка;
		КонецЦикла;
	Иначе
		Для Каждого СтрокаТаблицы Из ТаблицаИсключений Цикл
			Если Не Отметка И СтрокаТаблицы.ОграничитьОтключение Тогда
				Продолжить;
			КонецЕсли;
			СтрокаТаблицы.Отметка = Отметка;
		КонецЦикла;
	КонецЕсли;
	
	ПриИзмененииТаблицыИсключений();
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииТаблицыИсключений()
	
	ЗаполнитьИсключенияТекущихНастроек();
	ЗаполнитьИтоговыеПредставления();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИсключенияТекущихНастроек()
	
	ГруппаНастроек = КонтрольКодовМаркировкиМДЛПКлиентСервер.ЗначениеГруппыНастроекКонтроляКМ(ТекущиеНастройкиКонтроляКМ, КлючГруппыНастроекКонтроляКМ);
	
	ГруппаНастроек.Исключения = Новый Соответствие;
	
	Для Каждого СтрокаТаблицы Из ТаблицаИсключений Цикл
		
		Если СтрокаТаблицы.ОграничитьОтключение Или Не СтрокаТаблицы.Отметка Тогда
			Продолжить;
		КонецЕсли;
		
		КонтрольКодовМаркировкиМДЛП.ДобавитьОперациюВИсключенияГруппыНастроекКонтроляКМ(ГруппаНастроек, СтрокаТаблицы.Исключение);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИтоговыеПредставления()
	
	ГруппаНастроек = КонтрольКодовМаркировкиМДЛПКлиентСервер.ЗначениеГруппыНастроекКонтроляКМ(ТекущиеНастройкиКонтроляКМ, КлючГруппыНастроекКонтроляКМ);
	
	ПредставлениеИсключений = КонтрольКодовМаркировкиМДЛП.ПредставлениеИсключенийГруппыНастроекКонтроляКМ(ГруппаНастроек);
	
	Если ЗначениеЗаполнено(ПредставлениеИсключений) Тогда
		Элементы.ГруппаТаблицаИсключений.РасширеннаяПодсказка.Заголовок = ПредставлениеИсключений;
		Элементы.ГруппаТаблицаИсключений.ОтображениеПодсказки           = ОтображениеПодсказки.ОтображатьСнизу;
	Иначе
		Элементы.ГруппаТаблицаИсключений.РасширеннаяПодсказка.Заголовок = "";
		Элементы.ГруппаТаблицаИсключений.ОтображениеПодсказки           = ОтображениеПодсказки.Нет;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиИсключений()
	
	Константы.НастройкиКонтроляКодовМаркировкиМДЛП.Установить(Новый ХранилищеЗначения(ТекущиеНастройкиКонтроляКМ));
	
КонецПроцедуры

#КонецОбласти
