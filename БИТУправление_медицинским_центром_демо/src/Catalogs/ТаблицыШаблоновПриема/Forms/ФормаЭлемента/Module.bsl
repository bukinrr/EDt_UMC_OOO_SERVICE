#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьДоступностьПоВстроеннымОбработкам();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьДоступностьПоВстроеннымОбработкам()
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка)
		Или ОбщегоНазначенияСервер.РежимРасширенныхВозможностейРедактированияДанных()
	Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ШаблоныHTML.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ШаблоныHTML.СоответствияТаблицамШаблонов КАК ШаблоныHTMLСоответствияТаблицамШаблонов
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ШаблоныHTML КАК ШаблоныHTML
		|		ПО (ШаблоныHTML.Ссылка = ШаблоныHTMLСоответствияТаблицамШаблонов.Ссылка)
		|			И (ШаблоныHTMLСоответствияТаблицамШаблонов.ТаблицаШаблонов = &ТаблицаШаблонов)
		|			И (ШаблоныHTML.ВидШаблона = ЗНАЧЕНИЕ(Перечисление.ВидыШаблонов.Обработка))
		|ГДЕ
		|	ШаблоныHTMLСоответствияТаблицамШаблонов.ТаблицаШаблонов = &ТаблицаШаблонов";
	
	Запрос.УстановитьПараметр("ТаблицаШаблонов", Объект.Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	
	ПараметрВстроеннойОбработки = Ложь;
	Пока Выборка.Следующий() Цикл
		Если ТипЗнч(Выборка.Ссылка.Обработка.Получить()) = Тип("Строка") Тогда
			ПараметрВстроеннойОбработки = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ПараметрВстроеннойОбработки Тогда
		Для Каждого Элемент Из Элементы Цикл
			Попытка
				Если ТипЗнч(Элемент) = Тип("КнопкаФормы") Тогда
					Элемент.Доступность = Ложь;
				Иначе
					Элемент.ТолькоПросмотр = Истина;
				КонецЕсли;
			Исключение КонецПопытки;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти