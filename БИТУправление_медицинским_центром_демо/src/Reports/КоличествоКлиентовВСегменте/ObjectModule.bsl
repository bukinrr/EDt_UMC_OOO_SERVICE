#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПараметрПериод = Неопределено;
	ВидСегментации = Неопределено;
	Для Каждого Параметр Из КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы Цикл
		
		Если Параметр.Параметр = Новый ПараметрКомпоновкиДанных("ВидСегментации") Тогда
			Если ЗначениеЗаполнено(Параметр.ИдентификаторПользовательскойНастройки) Тогда
				ПараметрПН = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(Параметр.ИдентификаторПользовательскойНастройки);
				ВидСегментации = ПараметрПН.Значение;
			Иначе
				ВидСегментации = Параметр.Значение;
			КонецЕсли;
		КонецЕсли;
		
		Если Параметр.Параметр = Новый ПараметрКомпоновкиДанных("СтандартныйПериод") Тогда
			Если ЗначениеЗаполнено(Параметр.ИдентификаторПользовательскойНастройки) Тогда
				ПараметрПН = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(Параметр.ИдентификаторПользовательскойНастройки);
				ПараметрПериод = ПараметрПН.Значение;
			Иначе
				ПараметрПериод = Параметр.Значение;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ВидСегментации)
		И Не ВидСегментации.ХранитьИсториюСегментов
	Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьОбОшибке(НСтр("ru='Отчет не предназначен для анализа видов сегментации с выключенной функцией хранения истории. Воспользуйтесь отчетом'")+" "+Метаданные.Отчеты.СегментацияКлиентов.Синоним, Отказ);
	Иначе
		ДатаНачала = ПараметрПериод.ДатаНачала;
		ДатаОкончания = ПараметрПериод.ДатаОкончания;
		
		Если Не ЗначениеЗаполнено(ДатаНачала) Или Не ЗначениеЗаполнено(ДатаОкончания) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьОбОшибке(НСтр("ru='Следует указать даты начала и окончания периода формирования отчета'"), Отказ);
		КонецЕсли;
	КонецЕсли;
	
	
КонецПроцедуры

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	УниверсальныеМеханизмыСервер.ОтчетПриКомпоновкеРезультата(ЭтотОбъект, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти
