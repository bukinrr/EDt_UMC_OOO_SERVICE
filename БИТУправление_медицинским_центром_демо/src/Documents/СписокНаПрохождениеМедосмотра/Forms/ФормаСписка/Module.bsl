#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	РаботаСФормамиСервер.ДокументСписокПриСозданииНаСервере(ЭтаФорма);
	// ЭЦП
	РаботаСФормамиКлиентСервер.УстановитьВидимостьЭлементаФормы(Элементы, "ФормаДокументСписокНаПрохождениеМедосмотраСписокЭМД", ЭЦП_УМЦ_Сервер.ИспользоватьЭлектронныеПодписиЭМК());
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПечатьДокументовКлиент.УстановитьЗаголовокПечатнойФормы(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти