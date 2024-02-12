#Область ПрограммныйИнтерфейс

// Заполняет в документе материалы по нормам
//
// Параметры:
//  ДокументОбъект	 - ДокументСсылка.КомплексныйРасчетКлиента	 - документ заказа на изготовление.
//
Процедура ЗаполнитьМатериалыПоНормам(ДокументОбъект) Экспорт
	
	Если ЗначениеЗаполнено(ДокументОбъект.Заказ) Тогда
		
		СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ДокументОбъект);
		
		ДокументОбъект.Материалы.Очистить();
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	КомплексныйРасчетКлиентаСостав.Номенклатура КАК Номенклатура,
		|	КомплексныйРасчетКлиентаСостав.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
		|	КомплексныйРасчетКлиентаСостав.Количество КАК Количество,
		|	КомплексныйРасчетКлиентаСостав.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	КомплексныйРасчетКлиентаСостав.Цена КАК Цена,
		|	КомплексныйРасчетКлиентаСостав.Сумма КАК Сумма,
		|	КомплексныйРасчетКлиентаСостав.Примечание КАК Примечание,
		|	КомплексныйРасчетКлиентаСостав.Сырье КАК Сырье,
		|	КомплексныйРасчетКлиентаСостав.Коэффициент КАК Коэффициент,
		|	КомплексныйРасчетКлиентаСостав.Номенклатура.ВидНоменклатуры КАК ВидНоменклатуры
		|ИЗ
		|	Документ.КомплексныйРасчетКлиента.Состав КАК КомплексныйРасчетКлиентаСостав
		|ГДЕ
		|	КомплексныйРасчетКлиентаСостав.Ссылка = &Основание";
		
		Запрос.УстановитьПараметр("Основание", ДокументОбъект.Заказ);
		ТаблицаРаботМатериалов = Запрос.Выполнить().Выгрузить();

		ТаблицаСырья = ДокументОбъект.Материалы.Выгрузить();
		
		ТаблицаРабот = Новый ТаблицаЗначений;
		ТаблицаРабот = ТаблицаСырья.СкопироватьКолонки("Номенклатура, ХарактеристикаНоменклатуры, Количество");		
		
		Для Каждого Строка Из ТаблицаРаботМатериалов Цикл
			Если Строка.ВидНоменклатуры = Перечисления.ВидыНоменклатуры.Услуга Тогда
				СтрокаТаблицы = ТаблицаРабот.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаТаблицы, Строка);
			ИначеЕсли Строка.Сырье
				И Строка.ВидНоменклатуры = Перечисления.ВидыНоменклатуры.Материал
			Тогда
			    СтрокаТаблицы = ТаблицаСырья.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаТаблицы, Строка);
				СтрокаТаблицы.Количество = Строка.Количество;
			КонецЕсли; 
		КонецЦикла; 
		
		ТаблицаМатериалов = ДокументОбъект.Материалы.Выгрузить();
		РаботаСДокументамиСервер.ЗаполнитьРасходМатериаловПоНормамНаРаботы(ТаблицаРабот, ТаблицаМатериалов, СтруктураШапкиДокумента, Ложь);	
		ДокументОбъект.Материалы.Загрузить(ТаблицаМатериалов);
		
		Для Каждого Строка Из ТаблицаСырья Цикл
			СтрокаМатериала = ДокументОбъект.Материалы.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаМатериала, Строка);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
