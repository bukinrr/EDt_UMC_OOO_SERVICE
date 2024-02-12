#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	РаботаСДиалогамиКлиент.СкрытьПоказатьАрхивные(Элементы.СписокСкрытьПоказатьАрхивные, Список, Ложь);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьСправочник(Команда)
	
	ИнтеграцияЕГИСЗКлиент.ОткрытьФормуОбновленияСправочника("ЛабораторныеТесты",Элементы.Список,ЭтаФорма); 
	Элементы.Список.Обновить();
		
КонецПроцедуры

&НаКлиенте
Процедура ПоместитьВАрхив(Команда)

	РаботаСДиалогамиКлиент.ПоместитьВАрхив(Элементы.Список.ВыделенныеСтроки);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьПоказатьАрхивные(Команда)

	РаботаСДиалогамиКлиент.СкрытьПоказатьАрхивные(Элементы.СписокСкрытьПоказатьАрхивные, Список);
	
КонецПроцедуры

#КонецОбласти