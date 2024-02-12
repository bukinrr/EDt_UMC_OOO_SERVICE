
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Параметры.НомерТелефона) Тогда
		НомерТелефона = Параметры.НомерТелефона;
		НайтиКонтрагентовНаСервере();
	КонецЕсли;
	
	//+Переопределенное
	Элементы.НайтиКонтрагентов.Заголовок = НСтр("ru='Найти клиентов'");
	Элементы.КонтрагентыКонтрагент.Заголовок = НСтр("ru='Клиент'");
	Элементы.КонтрагентыКонтактноеЛицо.Заголовок = НСтр("ru='Номер телефона'");
	ЭтотОбъект.Заголовок = НСтр("ru='Поиск клиентов по номеру телефона'");
	//-Переопределенное
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СсылкаТекущ = Неопределено;
	Если Поле.Имя = "КонтрагентыКонтрагент" Тогда
		СсылкаТекущ = Элементы.Контрагенты.ТекущиеДанные.Контрагент;
	ИначеЕсли Поле.Имя = "КонтрагентыКонтактноеЛицо" Тогда
		СсылкаТекущ = Элементы.Контрагенты.ТекущиеДанные.КонтактноеЛицо;
	КонецЕсли;
	Если ЗначениеЗаполнено(СсылкаТекущ) Тогда
		бит_ТелефонияКлиентПереопределяемый.ПоказЗначение(СсылкаТекущ);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НайтиКонтрагентов(Команда)
	НайтиКонтрагентовНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НайтиКонтрагентовНаСервере()
	стрНомер = бит_ТелефонияКлиентСервер.СократитьНомерДляПоиска(бит_ТелефонияКлиентСервер.ОчиститьНомерТолькоЦифры(НомерТелефона));
	таблКонтраг = бит_ТелефонияСерверПереопределяемый.НайтиКонтрагентовПоНомеруВКонтактах(стрНомер, Ложь);
	Контрагенты.Загрузить(таблКонтраг);
КонецПроцедуры

#КонецОбласти

