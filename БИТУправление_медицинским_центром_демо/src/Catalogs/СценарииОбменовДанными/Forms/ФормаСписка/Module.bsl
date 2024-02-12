
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВключитьОтключитьРегламентноеЗадание(Команда)
	
	ВыделенныеСтроки = Элементы.Список.ВыделенныеСтроки;
	
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	ВключитьОтключитьРегламентноеЗаданиеНаСервере(ВыделенныеСтроки, Не ТекущиеДанные.ИспользоватьРегламентноеЗадание);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ВключитьОтключитьРегламентноеЗаданиеНаСервере(ВыделенныеСтроки, ИспользоватьРегламентноеЗадание)
	
	Для Каждого ДанныеСтроки Из ВыделенныеСтроки Цикл
		
		Если ДанныеСтроки.ПометкаУдаления Тогда
			Продолжить;
		КонецЕсли;
		
		НастройкаОбъект = ДанныеСтроки.Ссылка.ПолучитьОбъект();
		НастройкаОбъект.ИспользоватьРегламентноеЗадание = ИспользоватьРегламентноеЗадание;
		НастройкаОбъект.Записать();
		
	КонецЦикла;
	
	// Обновляем данные списка
	Элементы.Список.Обновить();
	
КонецПроцедуры

#КонецОбласти
