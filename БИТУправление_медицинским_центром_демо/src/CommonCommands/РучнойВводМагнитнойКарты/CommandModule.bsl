#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Заголовок = НСтр("ru = 'Введите код магнитной карты'");
	
	ДополнительныеПараметры = Новый Структура(
		"Источник",
		ПараметрыВыполненияКоманды.Источник);
	Оповещение = Новый ОписаниеОповещения(
		"ПоказатьВводМагнитнойКартыЗавершение",
		ЭтотОбъект,
		ДополнительныеПараметры);
	ПоказатьВводЗначения(Оповещение, "", Заголовок);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПоказатьВводМагнитнойКартыЗавершение(КодКарты, ДополнительныеПараметры)
	
	ВыходныеПараметры = Новый Массив;
	ВыходныеПараметры.Добавить("TracksData");
	ВыходныеПараметры.Добавить(Новый Массив());
	ВыходныеПараметры[1].Добавить(КодКарты);
	
	// Оповещаем 
	Оповестить(ВыходныеПараметры[0], ВыходныеПараметры[1], "ПодключаемоеОборудование");
	
КонецПроцедуры

#КонецОбласти
