
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Для Каждого ЭлементСписка Из Параметры.СписокДействий Цикл
		Строка = СписокДействий.Добавить();
		Строка.Действие = ЭлементСписка.Значение;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьЗначение(Команда)
	
	ВыполнитьВыборЗначения();
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокДействийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.СписокДействийДействие Тогда
		
		ВыполнитьВыборЗначения();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовФормы

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыполнитьВыборЗначения()
	
	ТекущиеДанные = Элементы.СписокДействий.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Или Не ЗначениеЗаполнено(ТекущиеДанные.Действие) Тогда
		Возврат;
	КонецЕсли;
	
	Закрыть(Новый Структура("Значение", ТекущиеДанные.Действие));
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции

