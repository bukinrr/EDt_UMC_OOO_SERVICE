
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Логин = Параметры.Логин;
	Регистратор = Параметры.Регистратор;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Логин", Логин);
	Результат.Вставить("Пароль", Пароль);
	Результат.Вставить("ЗапомнитьПароль", ЗапомнитьПароль);
	
	Закрыть(Результат);
	
КонецПроцедуры
