
Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отбор.КлючУпаковки.Использование Тогда
		Для Каждого Запись Из ЭтотОбъект Цикл
			Если Не ЗначениеЗаполнено(Запись.КлючУпаковки) Тогда
				Запись.КлючУпаковки = ИнтеграцияМДЛПКлиентСервер.ПолучитьКлючУпаковки(Запись.НомерУпаковки);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры
