#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.РежимВыбора Тогда
		
		Элементы.Список.РежимВыбора = Истина;
		// Отбор не помеченных на удаление.
		Список.Отбор.Элементы[0].Использование = Истина;
		Список.Отбор.Элементы[1].Использование = Параметры.Свойство("ВыборРодителя");
		
		Если Параметры.ЗакрыватьПриВыборе = Ложь Тогда
			// Режим подбора
			Заголовок = НСтр("ru = 'Подбор групп внешних пользователей'");
			Элементы.Список.МножественныйВыбор = Истина;
			Элементы.Список.РежимВыделения = РежимВыделенияТаблицы.Множественный;
		Иначе
			Заголовок = НСтр("ru = 'Выбор группы внешних пользователей'");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти