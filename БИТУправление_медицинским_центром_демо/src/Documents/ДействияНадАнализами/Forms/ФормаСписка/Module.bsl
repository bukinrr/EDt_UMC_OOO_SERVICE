#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	РаботаСФормамиСервер.ДокументСписокПриСозданииНаСервере(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПечатьДокументовКлиент.УстановитьЗаголовокПечатнойФормы(ЭтаФорма);
КонецПроцедуры

#КонецОбласти