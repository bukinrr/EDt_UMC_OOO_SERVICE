#Область ПрограммныйИнтерфейс

// Данные локализации, автоматически определяемые по стране для заполнения по умочланию настроек учета.
//
// Параметры:
//  ОсновнаяСтрана - СправочникСсылка.СтраныМира - страна базы.
//
// Возвращаемое значение:
//  Структура.
//
Функция ПолучитьДанныеЛокализации(ОсновнаяСтрана) Экспорт
	
	Пресеты = ЗаполнитьПресеты();
	
	ДанныеЛокализации = Новый Структура;
	ДанныеЛокализации.Вставить("ОсновнаяВалюта",Справочники.Валюты.ПустаяСсылка());
	ДанныеЛокализации.Вставить("ОсновнойДУЛ",Справочники.ДокументыУдостоверяющиеЛичность.ПустаяСсылка());
	
	ДанныеПоСтране = Пресеты.Найти(ОсновнаяСтрана.Наименование, "НаименованиеСтраны");	
	
	// Валюта
	Если Не Справочники.Валюты.НайтиПоКоду(ОсновнаяСтрана.Код).Пустая() Тогда
		
		ДанныеЛокализации.Вставить("ОсновнаяВалюта",Справочники.Валюты.НайтиПоКоду(ОсновнаяСтрана.Код));
		
	ИначеЕсли Не ДанныеПоСтране = Неопределено Тогда
		
		Если Не Справочники.Валюты.НайтиПоКоду(ДанныеПоСтране.КодВалюты).Пустая() Тогда
			ДанныеЛокализации.Вставить("ОсновнаяВалюта", Справочники.Валюты.НайтиПоКоду(ДанныеПоСтране.КодВалюты));
		Иначе
			НоваяВалюта = Справочники.Валюты.СоздатьЭлемент();
			НоваяВалюта.Код = ДанныеПоСтране.КодВалюты;
			НоваяВалюта.Наименование = ДанныеПоСтране.НаименованиеВалюты;
			НоваяВалюта.НаименованиеПолное = ДанныеПоСтране.НаименованиеВалютыПолное;
			НоваяВалюта.Записать();
			
			ДанныеЛокализации.Вставить("ОсновнаяВалюта", Справочники.Валюты.НайтиПоКоду(ДанныеПоСтране.КодВалюты));
		КонецЕсли;
		
	КонецЕсли;
	
	// Вид ДУЛ
	Если ОсновнаяСтрана = Справочники.СтраныМира.Россия Тогда
		
		ДанныеЛокализации.Вставить("ОсновнойДУЛ",Справочники.ДокументыУдостоверяющиеЛичность.ИМНС21);
		
	ИначеЕсли Не ДанныеПоСтране = Неопределено Тогда
		
		СуществующийВидДУЛ = ОсновнойДУЛПоСтране(ДанныеПоСтране.СокращенноеНаименованиеСтраны);
		
		Если СуществующийВидДУЛ = Справочники.ДокументыУдостоверяющиеЛичность.ПустаяСсылка() Тогда
			
			НовыйВидДУЛ = Справочники.ДокументыУдостоверяющиеЛичность.СоздатьЭлемент();
			НовыйВидДУЛ.Наименование = ДанныеПоСтране.ОсновнойДУЛ;
			НовыйВидДУЛ.НеИмеетСерию = ДанныеПоСтране.НеИмеетСерию;
			НовыйВидДУЛ.МаскаСерииДокумента = ДанныеПоСтране.МаскаСерииДокумента;
			НовыйВидДУЛ.МаскаНомераДокумента = ДанныеПоСтране.МаскаНомераДокумента;
			НовыйВидДУЛ.Записать();
			
			ДанныеЛокализации.Вставить("ОсновнойДУЛ", НовыйВидДУЛ.Ссылка);
			
		Иначе
			ДанныеЛокализации.Вставить("ОсновнойДУЛ", СуществующийВидДУЛ);
		КонецЕсли;
	КонецЕсли;
	
	Возврат ДанныеЛокализации;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЗаполнитьПресеты()
	
	Пресеты = Новый ТаблицаЗначений;
	Пресеты.Колонки.Добавить("НаименованиеСтраны");
	Пресеты.Колонки.Добавить("СокращенноеНаименованиеСтраны");
	Пресеты.Колонки.Добавить("КодВалюты");
	Пресеты.Колонки.Добавить("НаименованиеВалюты");
	Пресеты.Колонки.Добавить("НаименованиеВалютыПолное");
	Пресеты.Колонки.Добавить("ОсновнойДУЛ");
	Пресеты.Колонки.Добавить("НеИмеетСерию");
	Пресеты.Колонки.Добавить("МаскаСерииДокумента");
	Пресеты.Колонки.Добавить("МаскаНомераДокумента");
	Пресеты.Колонки.Добавить("СсылкаОсновнойДУЛ");
	
	НоваяСтрока = Пресеты.Добавить();
	НоваяСтрока.НаименованиеСтраны = НСтр("ru='КАЗАХСТАН'");
	НоваяСтрока.СокращенноеНаименованиеСтраны = НСтр("ru='КАЗАХ'");
	НоваяСтрока.КодВалюты = "398";
	НоваяСтрока.НаименованиеВалюты = НСтр("ru='тенге'");
	НоваяСтрока.НаименованиеВалютыПолное = НСтр("ru='Тенге'");
	НоваяСтрока.ОсновнойДУЛ = НСтр("ru='Паспорт гражданина Республики Казахстан'");
	НоваяСтрока.НеИмеетСерию = Истина;
	НоваяСтрока.МаскаСерииДокумента = "";
	НоваяСтрока.МаскаНомераДокумента = "X99999999";
	
	НоваяСтрока = Пресеты.Добавить();
	НоваяСтрока.СокращенноеНаименованиеСтраны = НСтр("ru='УКРА'");
	НоваяСтрока.НаименованиеСтраны = НСтр("ru='УКРАИНА'");
	НоваяСтрока.КодВалюты = "980";
	НоваяСтрока.НаименованиеВалюты = НСтр("ru='грн'");
	НоваяСтрока.НаименованиеВалютыПолное = НСтр("ru='Гривна'");
	НоваяСтрока.ОсновнойДУЛ = НСтр("ru='Паспорт гражданина Украины'");
	НоваяСтрока.НеИмеетСерию = Ложь;
	НоваяСтрока.МаскаСерииДокумента = "XX";
	НоваяСтрока.МаскаНомераДокумента = "999999";
	
	НоваяСтрока = Пресеты.Добавить();
	НоваяСтрока.НаименованиеСтраны = НСтр("ru='БЕЛАРУСЬ'");
	НоваяСтрока.СокращенноеНаименованиеСтраны = НСтр("ru='БЕЛАР'");
	НоваяСтрока.КодВалюты = "933";
	НоваяСтрока.НаименованиеВалюты = НСтр("ru='руб.'");
	НоваяСтрока.НаименованиеВалютыПолное = НСтр("ru='Белорусский рубль'");
	НоваяСтрока.ОсновнойДУЛ = НСтр("ru='Паспорт гражданина Республики Беларусь'");
	НоваяСтрока.НеИмеетСерию = Ложь;
	НоваяСтрока.МаскаСерииДокумента = "XX";
	НоваяСтрока.МаскаНомераДокумента = "9999999";
	
	НоваяСтрока = Пресеты.Добавить();
	НоваяСтрока.НаименованиеСтраны = НСтр("ru='АРМЕНИЯ'");
	НоваяСтрока.СокращенноеНаименованиеСтраны = НСтр("ru='АРМЕН'");
	НоваяСтрока.КодВалюты = "051";
	НоваяСтрока.НаименованиеВалюты = НСтр("ru='драм'");
	НоваяСтрока.НаименованиеВалютыПолное = НСтр("ru='Армянский драм'");
	НоваяСтрока.ОсновнойДУЛ = НСтр("ru='Паспорт гражданина Армении'");
	НоваяСтрока.НеИмеетСерию = Ложь;
	НоваяСтрока.МаскаСерииДокумента = "AX";
	НоваяСтрока.МаскаНомераДокумента = "9999999";
	
	НоваяСтрока = Пресеты.Добавить();
	НоваяСтрока.НаименованиеСтраны = НСтр("ru='ГРУЗИЯ'");
	НоваяСтрока.СокращенноеНаименованиеСтраны = НСтр("ru='ГРУЗ'");
	НоваяСтрока.КодВалюты = "981";
	НоваяСтрока.НаименованиеВалюты = НСтр("ru='лари'");
	НоваяСтрока.НаименованиеВалютыПолное = НСтр("ru='Грузинский лари'");
	НоваяСтрока.ОсновнойДУЛ = НСтр("ru='Паспорт гражданина Грузии'");
	НоваяСтрока.НеИмеетСерию = Ложь;
	НоваяСтрока.МаскаСерииДокумента = "99XX";
	НоваяСтрока.МаскаНомераДокумента = "999999";
	
	НоваяСтрока = Пресеты.Добавить();
	НоваяСтрока.НаименованиеСтраны = НСтр("ru='ОБЪЕДИНЕННЫЕ АРАБСКИЕ ЭМИРАТЫ'");
	НоваяСтрока.СокращенноеНаименованиеСтраны = НСтр("ru='АРАБ'");
	НоваяСтрока.КодВалюты = "840";
	НоваяСтрока.НаименованиеВалюты = НСтр("ru='дол.'");
	НоваяСтрока.НаименованиеВалютыПолное = НСтр("ru='Доллар США'");
	НоваяСтрока.ОсновнойДУЛ = НСтр("ru='Паспорт гражданина Объединенных Арабских Эмиратов'");
	НоваяСтрока.НеИмеетСерию = Истина;
	НоваяСтрока.МаскаСерииДокумента = "";
	НоваяСтрока.МаскаНомераДокумента = "999999";
	
	Возврат Пресеты;
	
КонецФункции

Функция ОсновнойДУЛПоСтране(СокращенноеНаименованиеСтраны)
	
	ДУЛ = Справочники.ДокументыУдостоверяющиеЛичность.Выбрать();
	
	Пока ДУЛ.Следующий() Цикл
		Если СтрНайти(ВРег(ДУЛ.Наименование), СокращенноеНаименованиеСтраны) > 0 Тогда
			Возврат ДУЛ.Ссылка;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Справочники.ДокументыУдостоверяющиеЛичность.ПустаяСсылка();
	
КонецФункции

#КонецОбласти
