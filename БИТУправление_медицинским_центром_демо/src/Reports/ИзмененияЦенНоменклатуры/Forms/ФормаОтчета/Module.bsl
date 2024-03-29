#Область ОбработчикиСобытийФормы
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЗаполнитьПустойПараметрПрейскуранта();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
&НаСервере
Процедура ПриЗагрузкеВариантаНаСервере(Настройки)
	ЗаполнитьПустойПараметрПрейскуранта();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьПустойПараметрПрейскуранта()
	
	Попытка
		ПараметрДанных = Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы[0];
		Если Не ЗначениеЗаполнено(ПараметрДанных.Значение) Тогда
			Для Каждого ЭлементНастройки Из Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
				Если ЭлементНастройки.ИдентификаторПользовательскойНастройки = ПараметрДанных.ИдентификаторПользовательскойНастройки Тогда
					Если Не ЗначениеЗаполнено(ЭлементНастройки.Значение) Тогда
						ЭлементНастройки.Значение = УправлениеНастройками.ПолучитьПрейскурантФилиала();
					КонецЕсли;
					ПараметрДанных.Значение = ЭлементНастройки.Значение;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			ПользовательскиеНастройкиМодифицированы = Ложь;
			ВариантМодифицирован = Ложь;
		КонецЕсли;
		СкомпоноватьРезультат();
	Исключение
	КонецПопытки;
	
КонецПроцедуры
#КонецОбласти

