#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Наименование = СокрЛП(ЭтотОбъект.ВидПолиса.Наименование);
	Если ЗначениеЗаполнено(Номер) Или ЗначениеЗаполнено(Серия) Тогда
		НомерСерия = СокрЛП(СокрЛП(Номер)+ ?(ЗначениеЗаполнено(Серия)," серия " + СокрЛП(Серия),""));
		Если Не ПустаяСтрока(НомерСерия) Тогда
			Наименование = Наименование + " " + НомерСерия;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
#КонецОбласти
