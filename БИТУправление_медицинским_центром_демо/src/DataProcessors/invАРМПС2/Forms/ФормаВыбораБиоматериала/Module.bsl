#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	СТД = Элементы.Биоматериалы.ТекущиеДанные;
	Если СТД <> Неопределено Тогда
		ОповеститьОВыборе(СТД.Значение);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Для Каждого Стр Из Параметры.СписокБиоматериалов Цикл
		Биоматериалы.Добавить(Стр);	
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

