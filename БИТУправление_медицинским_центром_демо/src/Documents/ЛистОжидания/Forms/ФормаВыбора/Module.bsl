#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПечатьДокументовКлиент.УстановитьЗаголовокПечатнойФормы(ЭтаФорма);
	
	Если ЗначениеЗаполнено(Параметры.ДатаНачала) Тогда 
		РаботаСФормамиКлиент.УстановитьОтборСписка("ДатаОкончанияПлан", Параметры.ДатаНачала, Список, ВидСравненияКомпоновкиДанных.БольшеИлиРавно);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти