#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Клиент", Клиент) Тогда
		
		Параметры.Свойство("Дата", Дата);
		Параметры.Свойство("Филиал", Филиал);
		
		Если Не ЗначениеЗаполнено(Клиент) Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		ПерезаполнитьЗаявкиПоПродажеНаСервере(Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерезаполнитьЗаявкиПоПродаже(Команда)
	Заявки.Очистить();
	ПерезаполнитьЗаявкиПоПродажеНаСервере();		
КонецПроцедуры
	
&НаКлиенте
Процедура ОК(Команда)
	
	ВыбранныеЗаявки = Новый Массив;
	Для Каждого СтрокаЗаявки Из Заявки Цикл
		Если СтрокаЗаявки.Пометка Тогда
			ВыбранныеЗаявки.Добавить(СтрокаЗаявки.Заявка);
		КонецЕсли;
	КонецЦикла;
	
	Закрыть(ВыбранныеЗаявки);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьОтметки(Команда)
	УстановитьОтметкиСпискаЗаявок(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтметки(Команда)
	УстановитьОтметкиСпискаЗаявок(Истина);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ЗаявкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.Заявки.ТекущийЭлемент <> Элементы.ЗаявкиПометка
		И Элементы.Заявки.ТекущиеДанные <> Неопределено
	Тогда
		ОткрытьЗначение(Элементы.Заявки.ТекущиеДанные.Заявка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПерезаполнитьЗаявкиПоПродажеНаСервере(ПриОткрытии = Ложь)
	
	Перем ЗаявкиДокументаПродажи;
	
	Параметры.Свойство("ЗаявкиДокументаПродажи", ЗаявкиДокументаПродажи);
	
	Если ПриОткрытии И Параметры.Заявки <> Неопределено Тогда
		ЗаявкиКлиента = Параметры.Заявки;
	Иначе
		ЗаявкиКлиента = УправлениеЗаявками.ПолучитьЗаявкиКлиентаЗаДеньСостояниеДоПродажи(Клиент, Дата, Филиал);
	КонецЕсли;
	
	Для Каждого Заявка Из ЗаявкиКлиента Цикл
		СтрокаЗаявки = Заявки.Добавить();
		СтрокаЗаявки.Пометка = ЗаявкиДокументаПродажи <> Неопределено И ЗаявкиДокументаПродажи.Найти(Заявка) <> Неопределено;
		СтрокаЗаявки.Заявка = Заявка;
	КонецЦикла;
	
	Если ЗаявкиДокументаПродажи <> Неопределено Тогда
		Для Каждого Заявка Из ЗаявкиДокументаПродажи Цикл
			Если Заявки.НайтиСтроки(Новый Структура("Заявка", Заявка)).Количество() = 0 Тогда
				СтрокаЗаявки = Заявки.Добавить();
				СтрокаЗаявки.Пометка = Истина;
				СтрокаЗаявки.Заявка = Заявка;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Заполнение описания сотрудников и работ
	УправлениеЗаявками.ЗаполнитьСотрудниковНоменклатуруТаблицыЗаявок(Заявки);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтметкиСпискаЗаявок(Пометка)
	
	Для Каждого СтрокаЗаявки Из Заявки Цикл
		СтрокаЗаявки.Пометка = Пометка;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
