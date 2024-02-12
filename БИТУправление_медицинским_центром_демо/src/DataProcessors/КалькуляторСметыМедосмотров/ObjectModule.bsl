#Область ПрограммныйИнтерфейс

// Формирует печатную форму сметы.
//
// Параметры:
//  Объект				 - ОбработкаОбъект.КалькуляторСметыМедосмотров - объект обработки.
//  ПредполагаемыеУслуги - Массив	 - номенклатура услуг.
//  СуммаСметы			 - Число	 - сумма сметы.
// 
// Возвращаемое значение:
//  ТабличныйДокумент - табличный документ на печать.
//
Функция Печать(Объект, ПредполагаемыеУслуги, СуммаСметы, ВыводитьДействияМедосмотра = Ложь, ПоказыватьУслугиСНулевойЦеной = Истина) Экспорт
	
	ТабДок = Новый ТабличныйДокумент;
	
	Макет = ПолучитьМакет("СметаПоУслугам");
	Область = Макет.ПолучитьОбласть("ОбластьШапка");
	ТабДок.Вывести(Область);
	Область = Макет.ПолучитьОбласть("ОбластьИтог");

	спрВалютаДокумента = УправлениеНастройками.ПолучитьПараметрУчетнойПолитики("ВалютаУчета");
	Если Не ЗначениеЗаполнено(спрВалютаДокумента) Тогда
		спрВалютаДокумента = Справочники.Валюты.Рубль;		
	КонецЕсли;
	Область.Параметры.ИтогоСуммаПоУслугам = ОбщегоНазначения.ФорматСумм(СуммаСметы,,"0") + " " + спрВалютаДокумента;
	ТабДок.Вывести(Область);
	
	Область = Макет.ПолучитьОбласть("ОбластьШапкаТаблицы");
	ТабДок.Вывести(Область);
	
	Для Каждого Шапка Из Объект.Смета Цикл
		Область = Макет.ПолучитьОбласть("ОбластьИтогПоФактору");
		Область.Параметры.Контингент = Шапка.Контингент;
		Область.Параметры.Фактор = СформироватьСтрокуФредныхФакторов(Шапка.ВредныйФактор);
		Область.Параметры.Количество = Шапка.Численность;
		Область.Параметры.Цена = ПредставлениеСуммы(Шапка.ЦенаЗаСотрудника);
		Область.Параметры.Стоимость = ПредставлениеСуммы(Шапка.Сумма);
		Если Не ТабДок.ПроверитьВывод(Область) Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ТабДок.Вывести(Область);
				
		СписокУслуг = НайтиУслугиПоКлиенту(ПредполагаемыеУслуги, Шапка.Клиент); 
		
		Номер = 1;
		Пока СписокУслуг.Следующий() Цикл
			Если (ВыводитьДействияМедосмотра Или ЗначениеЗаполнено(СписокУслуг.Номенклатура))
				И Не (Не ПоказыватьУслугиСНулевойЦеной И СписокУслуг.Цена = 0)	
			Тогда
				Область = Макет.ПолучитьОбласть("ОбластьНоменклатура");
				
				Область.Параметры.Номенклатура = ПредставлениеУслугиСметы(СписокУслуг.Номенклатура, СписокУслуг.ДействиеМедосмотра, ВыводитьДействияМедосмотра);
				Область.Параметры.Количество = Шапка.Численность;
				Область.Параметры.Цена = ПредставлениеСуммы(СписокУслуг.Цена);
				Область.Параметры.Стоимость = ПредставлениеСуммы(СписокУслуг.Цена * Шапка.Численность);
				Область.Параметры.Номер = Номер;
				Номер = Номер + 1;
				Если Не ТабДок.ПроверитьВывод(Область) Тогда
					ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
				КонецЕсли;
				ТабДок.Вывести(Область);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
		
	Возврат ТабДок;
	
КонецФункции

Функция НайтиУслугиПоКлиенту(Услуги, Клиент)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Услуги.Номенклатура КАК Номенклатура,
	|	Услуги.Действие КАК ДействиеМедосмотра,
	|	Услуги.Цена КАК Цена,
	|	Услуги.Клиент КАК Клиент
	|ПОМЕСТИТЬ Услуги
	|ИЗ
	|	&Услуги КАК Услуги
	|;
	|
	|/////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Услуги.Номенклатура КАК Номенклатура,
	|   Услуги.ДействиеМедосмотра КАК ДействиеМедосмотра,
	|	Услуги.Цена КАК Цена
	|ИЗ
	|	Услуги КАК Услуги
	|ГДЕ
	|	Услуги.Клиент = &Клиент";
	
	Запрос.УстановитьПараметр("Услуги", Услуги);
	Запрос.УстановитьПараметр("Клиент", Клиент);
	
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

Функция СформироватьСтрокуФредныхФакторов(СтрокаВредностей)
	
	МассивФакторов = СтрРазделить(СтрЗаменить(СтрЗаменить(СтрокаВредностей, ";", ","), " ", ""), ",", Ложь);
	
	СтрокаИтог = "";
	Для Каждого Фактор Из МассивФакторов Цикл	
		СтрокаИтог = СтрокаИтог + Фактор + " " + Строка(Справочники.ПереченьВредныхФакторовИРабот.НайтиПоРеквизиту("НомерПП", Фактор)) + "," + Символы.ПС;
	КонецЦикла;
	
	Возврат Лев(СтрокаИтог, СтрДлина(СтрокаИтог) - 2);
	
КонецФункции

Функция ПредставлениеСуммы(Сумма)
	
	Если Цел(Сумма) = (Сумма) Тогда
		Возврат Строка(Сумма);
	Иначе
		Возврат ОбщегоНазначения.ФорматСумм(Сумма);
	КонецЕсли;
	
КонецФункции

Функция ПредставлениеУслугиСметы(Номенклатура, ДействиеМедосмотра, ВыводитьДействияМедосмотра)
	
	Представление = "";
	
	Если ВыводитьДействияМедосмотра Тогда
		Представление = ОбщегоНазначенияБИТКлиентСервер.ЗаполненноеЗначение(ДействиеМедосмотра.НаименованиеДляПечати, ДействиеМедосмотра.Наименование);
	Иначе
		Представление = ОбщегоНазначенияБИТКлиентСервер.ЗаполненноеЗначение(Номенклатура.НаименованиеПолное, Номенклатура.Наименование);
	КонецЕсли;
	
	Возврат Представление
	
КонецФункции

#КонецОбласти