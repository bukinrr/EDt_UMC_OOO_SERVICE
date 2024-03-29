#Область ПрограммныйИнтерфейс

Процедура ПервоначальнаяИнициализация() Экспорт
	
	МассивИмен = Новый Массив;
	МассивИмен.Добавить("Информированное согласие");
	МассивИмен.Добавить("Договор на услуги");
	МассивИмен.Добавить("Паспорт");
	МассивИмен.Добавить("Свидетельство о рождении");
	УстановитьПривилегированныйРежим(Истина);
	Установить(Новый ХранилищеЗначения(МассивИмен, Новый СжатиеДанных(9)));
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Процедура ЗаписатьИмена(МассивИмен) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Установить(Новый ХранилищеЗначения(МассивИмен, Новый СжатиеДанных(5)));
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Функция ПолучитьСтандартныеИменаСканов() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МассивИмен = Получить().Получить();
	Если ТипЗнч(МассивИмен) = Тип("Массив") Тогда
		Возврат МассивИмен;
	Иначе
		Возврат Новый Массив;
	КонецЕсли;
	
КонецФункции

#КонецОбласти
