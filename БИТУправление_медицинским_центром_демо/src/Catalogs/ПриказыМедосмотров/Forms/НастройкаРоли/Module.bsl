#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("НастройкиРоли") Тогда
		Если Параметры.НастройкиРоли.Роль = Перечисления.РолиПодписей.МедицинскаяОрганизация Тогда
			ПодписьМедицинскойОрганизации = Истина;
			Обязательная = Параметры.НастройкиРоли.Обязательная;
		Иначе
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.НастройкиРоли);
			Если РежимНастройкиДоступности = Перечисления.РежимыНастройкиДоступностиРоли.ЗначениеПараметра Тогда
				ПараметрШаблонаТекущий = Параметры.НастройкиРоли.ПризнакДоступностиРоли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	мПараметрыШаблона = Новый Массив;
	
	СсылкаИдентификаторОбъектовМетаданныхСотрудники = ПолучитьСсылкуИдентификаторыОбъектовМетаданныхСотрудники();
	
	Для Каждого СтрокаПараметра Из ЭтотОбъект.ВладелецФормы.Объект.ДополнительныеПоля Цикл
		Если СтрокаПараметра.ТипЗначения = СсылкаИдентификаторОбъектовМетаданныхСотрудники Тогда
			мПараметрыШаблона.Добавить(СтрокаПараметра.Ключ);
		КонецЕсли;
	КонецЦикла;
	
	//СписокВыбора = Новый ФиксированныйМассив(мПараметрыШаблона);
	Элементы.ПараметрШаблона.СписокВыбора.ЗагрузитьЗначения(мПараметрыШаблона);
	Элементы.ПараметрШаблона.СписокВыбора.Добавить("умц_ДокументОбъектПредседательМедКомиссии", "Документ.ПредседательМедКомиссии");
	ПараметрШаблона = ПараметрШаблонаТекущий;
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСсылкуИдентификаторыОбъектовМетаданныхСотрудники()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИдентификаторыОбъектовМетаданных.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ИдентификаторыОбъектовМетаданных КАК ИдентификаторыОбъектовМетаданных
		|ГДЕ
		|	ИдентификаторыОбъектовМетаданных.Имя = ""Сотрудники""";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат ВыборкаДетальныеЗаписи.Ссылка;
	КонецЦикла;
	
КонецФункции

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	КлючСохраненияПоложенияОкна = ПодписьМедицинскойОрганизации;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьИЗакрыть(Команда)
	
	Если Не ПодписьМедицинскойОрганизации
		И (Не ЗначениеЗаполнено(Роль)
			Или Не ЗначениеЗаполнено(РежимНастройкиДоступности)
			Или (РежимНастройкиДоступности = ПредопределенноеЗначение("Перечисление.РежимыНастройкиДоступностиРоли.ЗначениеПараметра")
				И Не ЗначениеЗаполнено(ПараметрШаблона)))
	Тогда
		Сообщить(НСтр("ru='Не все обязательные поля заполнены!'"));
		Возврат;
	КонецЕсли;
	
	НастройкиРоли = Новый Структура("Обязательная, Роль, РежимНастройкиДоступности, ПризнакДоступностиРоли");
	Если ПодписьМедицинскойОрганизации Тогда
		НастройкиРоли.Обязательная = Обязательная;
		НастройкиРоли.Роль = ПредопределенноеЗначение("Перечисление.РолиПодписей.МедицинскаяОрганизация");
		НастройкиРоли.РежимНастройкиДоступности = ПредопределенноеЗначение("Перечисление.РежимыНастройкиДоступностиРоли.МедицинскаяОрганизация");
	Иначе
		ЗаполнитьЗначенияСвойств(НастройкиРоли, ЭтотОбъект);
		Если РежимНастройкиДоступности = ПредопределенноеЗначение("Перечисление.РежимыНастройкиДоступностиРоли.ЗначениеПараметра") Тогда
			НастройкиРоли.ПризнакДоступностиРоли = ПараметрШаблона;
		КонецЕсли;
	КонецЕсли;
	
	Закрыть(НастройкиРоли);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура РежимНастройкиДоступностиПриИзменении(Элемент)
	
	УстановитьВидимостьЭлементов();
	
	Если Не РежимНастройкиДоступности = ПредопределенноеЗначение("Перечисление.РежимыНастройкиДоступностиРоли.ЗначениеПараметра") Тогда
		ПараметрШаблона = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписьМедицинскойОрганизацииПриИзменении(Элемент)
	
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьВидимостьЭлементов()
	
	Элементы.ПоляВвода.Видимость = Не ПодписьМедицинскойОрганизации;
	Элементы.ПараметрШаблона.Видимость = РежимНастройкиДоступности = ПредопределенноеЗначение("Перечисление.РежимыНастройкиДоступностиРоли.ЗначениеПараметра");
	Элементы.ПараметрШаблона.АвтоОтметкаНезаполненного = Элементы.ПараметрШаблона.Видимость;
	
КонецПроцедуры

#КонецОбласти