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
				ПараметрШаблона = Параметры.НастройкиРоли.ПризнакДоступностиРоли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	мПараметрыШаблона = Новый Массив;
	Для Каждого СтрокаПараметра Из ЭтотОбъект.ВладелецФормы.ТаблицаПараметров Цикл
		Если СтрокаПараметра.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Сотрудники") Тогда
			мПараметрыШаблона.Добавить(СтрокаПараметра.Параметр);
		КонецЕсли;
	КонецЦикла;
	
	НовыйМассив = Новый Массив();
	НовыйМассив.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", мПараметрыШаблона));
	НовыеПараметры = Новый ФиксированныйМассив(НовыйМассив);
	Элементы.ПараметрШаблона.ПараметрыВыбора = НовыеПараметры;
	
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры

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