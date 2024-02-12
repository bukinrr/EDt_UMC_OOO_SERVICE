
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	РежимОтладки = ОбщегоНазначенияКлиентСервер.РежимОтладки();
	
	Элементы.Список.ИзменятьСоставСтрок  = РежимОтладки;
	Элементы.Список.ИзменятьПорядокСтрок = РежимОтладки;
	
КонецПроцедуры

#КонецОбласти