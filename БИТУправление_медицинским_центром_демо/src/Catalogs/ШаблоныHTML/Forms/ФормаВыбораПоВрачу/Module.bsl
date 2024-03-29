#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Врач = Параметры.Врач;
	УстановитьОтборСервер();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ВрачПриИзменении(Элемент)
	УстановитьОтборСервер();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОтборСервер()
		
	ИерархическийПросмотр = Истина;
	
	Если ЗначениеЗаполнено(Врач) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	СпециализацииШаблоновОсмотра.ШаблонОсмотра КАК ШаблонОсмотра,
		|	СпециализацииШаблоновОсмотра.ШаблонОсмотра.Родитель КАК ШаблонОсмотраРодитель
		|ИЗ
		|	Справочник.Сотрудники.Специализации КАК СотрудникиСпециализации
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СпециализацииШаблоновОсмотра КАК СпециализацииШаблоновОсмотра
		|		ПО (СотрудникиСпециализации.Ссылка = &Сотрудник)
		|			И СотрудникиСпециализации.Специализация = СпециализацииШаблоновОсмотра.Специализация
		|ГДЕ
		|	НЕ СпециализацииШаблоновОсмотра.ШаблонОсмотра.ЭтоГруппа
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	СпециализацииШаблоновОсмотра.ШаблонОсмотра,
		|	СпециализацииШаблоновОсмотра.ШаблонОсмотра.Родитель
		|ИЗ
		|	Справочник.Сотрудники.СпециализацииФРМР КАК СотрудникиСпециализацииФРМР
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СпециализацииШаблоновОсмотра КАК СпециализацииШаблоновОсмотра
		|		ПО (СотрудникиСпециализацииФРМР.Ссылка = &Сотрудник)
		|			И СотрудникиСпециализацииФРМР.Специализация = СпециализацииШаблоновОсмотра.Специализация
		|ГДЕ
		|	НЕ СпециализацииШаблоновОсмотра.ШаблонОсмотра.ЭтоГруппа"
		;
		Запрос.УстановитьПараметр("Сотрудник", Врач);
		Рез = Запрос.Выполнить();
		Если Рез.Пустой() Тогда
			РаботаСФормамиСервер.СнятьОтборСписка("Ссылка", Список);
		Иначе
			ТаблицаРезультата = Рез.Выгрузить();
			СписокСпециализаций = Новый СписокЗначений;
			СписокСпециализаций.ЗагрузитьЗначения(ТаблицаРезультата.ВыгрузитьКолонку("ШаблонОсмотра"));
			РаботаСФормамиСервер.УстановитьОтборСписка("Ссылка", СписокСпециализаций, Список);
			
			// Определение, нужен ли иерархический просмотр
			ТаблицаГрупп = ТаблицаРезультата.Скопировать(,"ШаблонОсмотраРодитель");
			ТаблицаГрупп.Свернуть("ШаблонОсмотраРодитель");
			Если ТаблицаГрупп.Количество() < 2 Тогда
				ИерархическийПросмотр = Ложь;
			КонецЕсли;
		КонецЕсли;
	Иначе
		РаботаСФормамиСервер.СнятьОтборСписка("Ссылка", Список);
	КонецЕсли;
	
	Элементы.Список.Отображение = ?(ИерархическийПросмотр, ОтображениеТаблицы.ИерархическийСписок, ОтображениеТаблицы.Список);
	
КонецПроцедуры

#КонецОбласти
