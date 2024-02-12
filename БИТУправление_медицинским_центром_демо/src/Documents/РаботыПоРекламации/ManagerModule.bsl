#Область ПрограммныйИнтерфейс

// Заполняет или дополняет материалы по нормам работ
//
// Параметры:
//  Объект						 - ДокументОбъект.РаботыПоРекламации - заполняемый документ.
//  СтруктураДополняющейРаботы	 - Структура - описание добавленной работы
//
Процедура ЗаполнитьМатериалыПоНормамРабот(Объект, СтруктураДополняющейРаботы = Неопределено) Экспорт
	
	сзСписокРабот = Новый СписокЗначений;
	сзСписокХарактеристикНоменклатуры = Новый СписокЗначений;
	
	ТаблицаРабот = Объект.Работы.Выгрузить();
	
	Если СтруктураДополняющейРаботы = Неопределено Тогда
		Объект.Материалы.Очистить();	
		Если ТаблицаРабот.Количество() = 0 Тогда Возврат КонецЕсли;
		
		сзСписокРабот.ЗагрузитьЗначения(ТаблицаРабот.ВыгрузитьКолонку("Номенклатура"));
		сзСписокХарактеристикНоменклатуры.ЗагрузитьЗначения(ТаблицаРабот.ВыгрузитьКолонку("ХарактеристикаНоменклатуры"));
	Иначе
		сзСписокРабот.Добавить(СтруктураДополняющейРаботы.Номенклатура);		
		сзСписокХарактеристикНоменклатуры.Добавить(СтруктураДополняющейРаботы.ХарактеристикаНоменклатуры);
	КонецЕсли;
	
	сзСписокХарактеристикНоменклатуры.Добавить(Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка());
	
	Запрос = Новый Запрос;
	
	ТаблицаРабот.Колонки.Добавить("кНомерСтроки",Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(5,0)));
	Для Каждого СтрокаТаблицы Из ТаблицаРабот Цикл
		СтрокаТаблицы.кНомерСтроки = СтрокаТаблицы.НомерСтроки;
	КонецЦикла;
	
	Для Каждого СтрокаРаботы Из Объект.Работы Цикл
		Если ЗначениеЗаполнено(СтрокаРаботы.ХарактеристикаНоменклатуры) Тогда
			СтрокаТаблицы = ТаблицаРабот.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТаблицы,СтрокаРаботы);
			СтрокаТаблицы.ХарактеристикаНоменклатуры = Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка();
			СтрокаТаблицы.кНомерСтроки = СтрокаТаблицы.НомерСтроки;
		КонецЕсли;
	КонецЦикла;
	
	ТаблицаМатериалов = Объект.Материалы.Выгрузить();
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(Объект);
	РаботаСДокументамиСервер.ЗаполнитьРасходМатериаловПоНормамНаРаботы(ТаблицаРабот, ТаблицаМатериалов, СтруктураШапкиДокумента);	
	
	ТаблицаМатериалов.Свернуть("КлючСтрокиРаботы, Работа, Номенклатура, ХарактеристикаНоменклатуры, ЕдиницаИзмерения, Коэффициент, Цена", "Количество, Сумма");
	Объект.Материалы.Загрузить(ТаблицаМатериалов);
	
КонецПроцедуры

// Перезаполнить работы по рекламации-основанию.
//
// Параметры:
//  Объект				 - ДокументОбъект.РаботыПоРекламации - заполняемый документ.
//  ЗаполнятьМатериалы	 - Булево							 - следует ли перезаполнить табличную часть материалов.
//
Процедура ПерезаполнитьРаботыПоРекламации(Объект, ЗаполнятьМатериалы = Истина) Экспорт
	
	Объект.Работы.Очистить();
	
	Если Не ЗначениеЗаполнено(Объект.Рекламация) Тогда 
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РекламацияРаботы.Ссылка,
	|	РекламацияРаботы.НомерСтроки КАК КлючСтроки,
	|	РекламацияРаботы.Номенклатура,
	|	РекламацияРаботы.ХарактеристикаНоменклатуры,
	|	РекламацияРаботы.Количество,
	|	РекламацияРаботы.Цена,
	|	РекламацияРаботы.Сумма,
	|	РекламацияРаботы.СуммаБезСкидок
	|ИЗ
	|	Документ.Рекламация.Работы КАК РекламацияРаботы
	|ГДЕ
	|	РекламацияРаботы.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Рекламация);
	
	Объект.Работы.Загрузить(Запрос.Выполнить().Выгрузить());
	
	Если ЗаполнятьМатериалы Тогда 
		ЗаполнитьМатериалыПоНормамРабот(Объект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти