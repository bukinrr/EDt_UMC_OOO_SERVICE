#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	РаботаСФормамиСервер.ДокументСписокПриСозданииНаСервере(ЭтаФорма);
	РаботаСДокументамиСервер.УстановитьУсловноеОформлениеДокументовКоррекции(Список);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПечатьДокументовКлиент.УстановитьЗаголовокПечатнойФормы(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "УспешноеПробитиеЧека" И ТипЗнч(Параметр) = Тип("ДокументСсылка.ПриходныйКассовыйОрдер") Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
