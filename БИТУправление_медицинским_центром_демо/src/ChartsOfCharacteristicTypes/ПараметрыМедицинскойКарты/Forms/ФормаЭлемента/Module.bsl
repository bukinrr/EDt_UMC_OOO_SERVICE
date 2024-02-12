
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	ЗагрузитьПринадлежностьМедкарт();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	НастроитьВидимостьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ВыгрузитьПринадлежностьМедкарт();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПараметрШаблонаОсмотраПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.ПараметрШаблонаОсмотра) Тогда
		Объект.ТипЗначения = Новый ОписаниеТипов("Строка");
	КонецЕсли;
	
	НастроитьВидимостьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	ВведенноеНаименование = Объект.Наименование;
	Если ЗначениеЗаполнено(ВведенноеНаименование) Тогда 
		Объект.Наименование = ОбщегоНазначенияКлиентСервер.ПривестиИмяПараметраКДопустимому(ВведенноеНаименование);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Заголовок) И ЗначениеЗаполнено(ВведенноеНаименование) Тогда
		Объект.Заголовок = ВведенноеНаименование;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура НастроитьВидимостьДоступность()
	
	Если Объект.Предопределенный Тогда 
		Элементы.Наименование.ТолькоПросмотр = Истина;
		Элементы.ГруппаТипВычисляемое.ТолькоПросмотр = Истина;
		Элементы.ГруппаПараметрШаблона.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Элементы.ИспользуетсяПервоеЗначениеПараметраШаблона.Видимость = 
		ЗначениеЗаполнено(Объект.ПараметрШаблонаОсмотра);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПринадлежностьМедкарт()
	
	ТипыМедкарт.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПараметрыМедицинскойКартыТипыМедкарт.ТипКарты
	|ПОМЕСТИТЬ УстановленныеВиды
	|ИЗ
	|	ПланВидовХарактеристик.ПараметрыМедицинскойКарты.ТипыМедкарт КАК ПараметрыМедицинскойКартыТипыМедкарт
	|ГДЕ
	|	ПараметрыМедицинскойКартыТипыМедкарт.Ссылка = &Параметр
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТипыМедицинскихКарт.Ссылка КАК ТипМедицинскойКарты,
	|	ВЫБОР
	|		КОГДА УстановленныеВиды.ТипКарты ЕСТЬ NULL
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК Пометка
	|ИЗ
	|	Перечисление.ТипыМедицинскихКарт КАК ТипыМедицинскихКарт
	|		ЛЕВОЕ СОЕДИНЕНИЕ УстановленныеВиды КАК УстановленныеВиды
	|		ПО ТипыМедицинскихКарт.Ссылка = УстановленныеВиды.ТипКарты";
	Запрос.УстановитьПараметр("Параметр", Объект.Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ТипыМедкарт.Добавить(Выборка.ТипМедицинскойКарты, , Выборка.Пометка);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьПринадлежностьМедкарт()
	
	Объект.ТипыМедкарт.Очистить();
	Для Каждого ЭлементВид Из ТипыМедкарт Цикл
		Если ЭлементВид.Пометка Тогда 
			Объект.ТипыМедкарт.Добавить().ТипКарты = ЭлементВид.Значение;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
