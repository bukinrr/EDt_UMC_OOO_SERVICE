
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
	
#КонецОбласти

