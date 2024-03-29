#Область ОбработчикиКомандФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВыбиратьВсе = (Параметры.ВыбиратьВсеЕслиВыбранныхНет И Параметры.ВыбранныеЭлементыСписка.Количество() = 0);
	Для Каждого ЭлементСписка Из Параметры.СписокЗначений Цикл
		
		ПолеВыбрано = (ВыбиратьВсе Или Параметры.ВыбранныеЭлементыСписка.НайтиПоЗначению(ЭлементСписка.Значение) <> Неопределено);
		СписокЗначений.Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление, ПолеВыбрано, ЭлементСписка.Картинка);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	СписокВыбранныхЗначений = Новый СписокЗначений;
	Для Каждого ЭлементСписка Из СписокЗначений Цикл 
		Если ЭлементСписка.Пометка Тогда 
			СписокВыбранныхЗначений.Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление, ЭлементСписка.Пометка, ЭлементСписка.Картинка);
		КонецЕсли;
	КонецЦикла;
	
	Закрыть(СписокВыбранныхЗначений);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти
