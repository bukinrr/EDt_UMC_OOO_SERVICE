#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Документ = Параметры.ПараметрКоманды[0].Ссылка;
	
	// Формирование таблицы незаполненных товаров из Документа
	Для Каждого Товар ИЗ Документ.Товары Цикл
		ЗаполнитьСтрокуТаблицыТоварыНезаполненные(Товар, Товар.ИдентификаторСтроки);
	КонецЦикла;
	
	// Формирование таблицы незаполненных транспортных упаковок из Документа
	Для Каждого ТранспУп Из Документ.СоставТранспортныхУпаковок Цикл
		ЗаполнитьСтрокуТаблицыТоварыНезаполненные(ТранспУп, ТранспУп.ИдентификаторСтрокиУпаковки);
	КонецЦикла;
	
	// Поиск по справочнику УпаковкиМаркируемогоТовара и заполнение уже имеющихся данных в базе
	ЗаполнитьПоGTINПередОткрытием();
	
	Элементы.ИнформацияЧЗ.Видимость = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьНоменклатуру(Команда)
	Если Элементы.ТоварыНезаполненныеСписокНоменклатур.ТекущиеДанные <> Неопределено
		И Элементы.ТоварыНезаполненныеСписокНоменклатур.ТекущиеДанные.Номенклатура <> Неопределено Тогда
		ПоказатьЗначение(,Элементы.ТоварыНезаполненныеСписокНоменклатур.ТекущиеДанные.Номенклатура);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрыть(Команда)
	
	Объект = ЭтаФорма.ВладелецФормы.Объект;
	// Внесение изменений в форму родитель по выбранным позициям
	Для Каждого Эл Из ТоварыНезаполненные Цикл
		РезультатыПоиска = Объект.Товары.НайтиСтроки(Новый Структура("GTIN", Эл.GTIN));
		Для Каждого Рез Из РезультатыПоиска Цикл
			Рез.Номенклатура = Эл.Номенклатура;	
		КонецЦикла;
		
		РезультатыПоиска = Объект.СоставТранспортныхУпаковок.НайтиСтроки(Новый Структура("GTIN", Эл.GTIN)); 
		Для Каждого Рез Из РезультатыПоиска Цикл
			Рез.Номенклатура = Эл.Номенклатура;	
		КонецЦикла;	
	КонецЦикла;
	ЭтаФорма.ВладелецФормы.Модифицированность = Истина;
	Закрыть();

КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоЕСКЛП(Команда)
	
	Если Не Элементы.ИнформацияЧЗ.Видимость Тогда
		ОбщегоНазначения.СообщитьПользователю("Перед созданием номенклатуры необходимо запросить информацию из ""Честного Знака""");	
		Возврат;	
	КонецЕсли;
	
	// Формирование массива который уйдет в длительную операцию
	МассивДляЗапросаИзЕГИСЗ = Новый Массив;	
	Для Каждого Элемент Из ТоварыНезаполненные Цикл
		Если Элемент.Выбран И Элемент.ОписаниеНоменклатурыЧЗ <> Неопределено Тогда
			Структура = Новый Структура("SGTIN, DrugCode", Элемент.SGTIN, Элемент.ОписаниеНоменклатурыЧЗ.drug_code);
			МассивДляЗапросаИзЕГИСЗ.Добавить(Структура);										
		КонецЕсли;
	КонецЦикла;
	
	// Создаем длительную операцию по созданию номенклатуры
	Если МассивДляЗапросаИзЕГИСЗ.Количество() <> 0 Тогда
		Если Не ЗначениеЗаполнено(СпециализацияНоменклатуры) Тогда 
			ОбщегоНазначения.СообщитьПользователю("Не выбрана специализация для новой номенклатуры");
			Возврат;	
		КонецЕсли;
		ДлительнаяОперация = СоздатьНоменклатуруНаСервере(МассивДляЗапросаИзЕГИСЗ, СпециализацияНоменклатуры, УникальныйИдентификатор);
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ВыводитьОкноОжидания = Истина;
		
		ПараметрыОжидания.ТекстСообщения = "Получение и создание номенклатуры...";
		ОповещениеОЗавершении = Новый ОписаниеОповещения("СоздатьНоменклатуруЗавершение", ЭтотОбъект);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
		
	Иначе
		ОбщегоНазначения.СообщитьПользователю("Не выбрана номенклатура для создания.");
		Возврат;
	КонецЕсли;  
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиПоДаннымЧЗ(Команда)
	
	мТоварыНезаполненные = Новый Массив;
	Для Каждого Товар Из ТоварыНезаполненные Цикл
		мТоварыНезаполненные.Добавить(Товар.SGTIN);		
	КонецЦикла;
	
	Если мТоварыНезаполненные.Количество() <> 0 Тогда
		ЗапроситьИнформациюОНоменклатуреЧЗ(мТоварыНезаполненные);
	Иначе
		ОбщегоНазначения.СообщитьПользователю("Не выбран ни один GTIN для поиска в ГИС ""Честный знак""");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ТоварыНезаполненныеПриАктивизацииСтроки(Элемент)
	Если Элементы.ИнформацияЧЗ.Видимость Тогда
		ОписаниеНоменклатурыЧЗ = Элементы.ТоварыНезаполненные.ТекущиеДанные.ОписаниеНоменклатурыЧЗ;
		Если ОписаниеНоменклатурыЧЗ <> Неопределено Тогда
			Элементы.ИнформацияНеНайдена.Видимость = Ложь;
			Элементы.ДанныеЧЗ.Видимость = Истина;
			ФлагЗаполненныхПолей = Ложь;
			Для Каждого Эл Из Элементы.ДанныеЧЗ.ПодчиненныеЭлементы Цикл
				Эл.Видимость = Ложь;	
			КонецЦикла;
			Если ОписаниеНоменклатурыЧЗ.Свойство("sell_name") Тогда
				МННаименование = ОписаниеНоменклатурыЧЗ.sell_name;
				ФлагЗаполненныхПолей = Истина;
				Элементы.Наименование.Видимость = Истина;	
			КонецЕсли;
			Если ОписаниеНоменклатурыЧЗ.Свойство("prod_name") Тогда
				ТорговоеНаименование = ОписаниеНоменклатурыЧЗ.prod_name;
				ФлагЗаполненныхПолей = Истина;
				Элементы.ТорговоеНаименование.Видимость = Истина;	
			КонецЕсли;
			Если ОписаниеНоменклатурыЧЗ.Свойство("reg_holder") Тогда
				НаименованиеОргРУ =  ОписаниеНоменклатурыЧЗ.reg_holder;
				ФлагЗаполненныхПолей = Истина;
				Элементы.НаименованиеОргРУ.Видимость = Истина;	
			КонецЕсли;
			Если ОписаниеНоменклатурыЧЗ.Свойство("prod_d_name") Тогда
				Дозировка = ОписаниеНоменклатурыЧЗ.prod_d_name;
				ФлагЗаполненныхПолей = Истина;
				Элементы.Дозировка.Видимость = Истина;	
			КонецЕсли;
			Если ОписаниеНоменклатурыЧЗ.Свойство("prod_form_name") Тогда
				ЛекарственнаяФорма = ОписаниеНоменклатурыЧЗ.prod_form_name;
				ФлагЗаполненныхПолей = Истина;
				Элементы.ЛекарственнаяФорма.Видимость = Истина;	
			КонецЕсли;
			Если ОписаниеНоменклатурыЧЗ.Свойство("drug_code") Тогда
				КодЕСКЛП = ОписаниеНоменклатурыЧЗ.drug_code;
				ФлагЗаполненныхПолей = Истина;
				Элементы.КодЕСКЛП.Видимость = Истина;	
			КонецЕсли;
			
			Если НЕ ФлагЗаполненныхПолей Тогда 
				Элементы.ИнформацияНеНайдена.Видимость = Истина;
			КонецЕсли;
		Иначе
			Элементы.ИнформацияНеНайдена.Видимость = Истина;
			Элементы.ДанныеЧЗ.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНезаполненныеСписокНоменклатурВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВыбраннаяНоменклатура = Элементы.ТоварыНезаполненныеСписокНоменклатур.ТекущиеДанные.Номенклатура;
	Элементы.ТоварыНезаполненные.ТекущиеДанные.Номенклатура = ВыбраннаяНоменклатура; 
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Поиск по справочнику УпаковкиМаркируемогоТовара и заполнение уже имеющихся данных в базе
&НаСервере
Процедура ЗаполнитьПоGTINПередОткрытием()
	
	РезультатПоиска = НайтиСопоставленияПоGTINМаркировкеВБазе(ТоварыНезаполненные);
	Если РезультатПоиска.Количество() <> 0 Тогда
		Для Каждого Товар Из ТоварыНезаполненные Цикл
			НоменклатураИзСотвествия = РезультатПоиска.Получить(Товар.GTIN);
			Если НоменклатураИзСотвествия <> Неопределено Тогда
				Товар.Номенклатура = НоменклатураИзСотвествия;
				НоваяСтрока = Товар.СписокНоменклатур.Добавить();
				НоваяСтрока.Номенклатура = НоменклатураИзСотвествия;
				НоваяСтрока.УровеньДостоверности = 1;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция НайтиСопоставленияПоGTINМаркировкеВБазе(ТоварыНезаполненные)
	
	// Ищем по GTIN номеру упаковки в справочнике, если что находим возвращаем результат
	мGTIN = Новый Массив;
	Для Каждого Элемент ИЗ ТоварыНезаполненные Цикл
		мGTIN.Добавить(Элемент.GTIN);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	УпаковкиМаркируемогоТовара.Номенклатура КАК Номенклатура,
		|	ВЫРАЗИТЬ(УпаковкиМаркируемогоТовара.НомерУпаковки КАК СТРОКА(14)) КАК GTIN
		|ИЗ
		|	Справочник.УпаковкиМаркируемогоТовара КАК УпаковкиМаркируемогоТовара
		|ГДЕ
		|	ВЫРАЗИТЬ(УпаковкиМаркируемогоТовара.НомерУпаковки КАК СТРОКА(14)) В (&СписокGTIN)";
	
	Запрос.УстановитьПараметр("СписокGTIN", мGTIN);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	СоответствиеGTINиНом = Новый Соответствие;
	Пока Выборка.Следующий() Цикл
		СоответствиеGTINиНом.Вставить(Выборка.GTIN, Выборка.Номенклатура);		
	КонецЦикла;
	
	Возврат СоответствиеGTINиНом;
		
КонецФункции

&НаСервере
Процедура ЗаполнитьСтрокуТаблицыТоварыНезаполненные(Товар, ИдентификаторСтрокиУпаковки)
	Если НЕ ЗначениеЗаполнено(Товар.Номенклатура) Тогда
		РезПоискаGTIN = ТоварыНезаполненные.НайтиСтроки(Новый Структура("GTIN", Товар.GTIN));
		Если РезПоискаGTIN.Количество() = 0 Тогда
			РезультатПоискаКИЗ = Документ.НомераУпаковок.Найти(ИдентификаторСтрокиУпаковки, "ИдентификаторСтроки");
			Если РезультатПоискаКИЗ <> Неопределено Тогда
				НоваяСтрока = ТоварыНезаполненные.Добавить();
				НоваяСтрока.GTIN = Товар.GTIN;
				НоваяСтрока.SGTIN = РезультатПоискаКИЗ.НомерКИЗ;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ЗапроситьИнформациюОНоменклатуреЧЗ(мSGTIN)
	
	// Что-то взятое из типовой библиотеки МДЛП
	РеквизитыДокумента = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(Документ, "Организация, МестоДеятельности");
	Отбор = Новый Массив;
	Отбор.Добавить(Новый Структура("Поле, Значение", "Организация", РеквизитыДокумента.Организация));
	Если ЗначениеЗаполнено(РеквизитыДокумента.МестоДеятельности) Тогда
		Отбор.Добавить(Новый Структура("Поле, Значение", "МестоДеятельности", РеквизитыДокумента.МестоДеятельности));
	КонецЕсли;
	
	ДоступныйТранспорт = ТранспортМДЛПВызовСервера.ДоступныеТранспортныеМодули(Отбор);
	Если ДоступныйТранспорт.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ЗапроситьИнформациюОНоменклатуреЧЗ_ПослеПопыткиАвторизации", ЭтотОбъект, мSGTIN);
	ТранспортМДЛПАПИКлиент.ПолучитьТекущийКлючСессии(ДоступныйТранспорт[0].ПараметрыПодключения, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапроситьИнформациюОНоменклатуреЧЗ_ПослеПопыткиАвторизации(РезультатАвторизации, мSGTIN) Экспорт
	
	Если РезультатАвторизации.Статус = "Ошибка" Тогда
		ПоказатьПредупреждение(, РезультатАвторизации.ОписаниеОшибки);
		Возврат;
	КонецЕсли;
	
	// Создаем длительную операцию по запросу на сервер Честного Знака
	ДлительнаяОперация = ЗапросВЧЗНаСервере(СобратьJSONТекстЗапроса(мSGTIN), РезультатАвторизации, УникальныйИдентификатор);
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Истина;
	ПараметрыОжидания.ТекстСообщения = "Запрос в ГИС Честный Знак...";
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ЗапроситьИнформациюОНоменклатуреЧЗ_ПослеЗапроса", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапроситьИнформациюОНоменклатуреЧЗ_ПослеЗапроса(Результат, ДопПараметры) Экспорт
		
	Если Результат <> Неопределено Тогда
		
		Если Результат.Статус = "Ошибка" Тогда
			ПоказатьПредупреждение(, Результат.КраткоеПредставлениеОшибки);
			Возврат;
		КонецЕсли;

		РезультатДлительнойОперации = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		
		Если ТипЗнч(РезультатДлительнойОперации) = Тип("Строка") Тогда
			ОбщегоНазначения.СообщитьПользователю(РезультатДлительнойОперации);
			Возврат;
		КонецЕсли;
		
		Если РезультатДлительнойОперации.Свойство("entries") Тогда
					
			мРезультатов = РезультатДлительнойОперации.entries;
			
			// Сохраняем информацию полученную из ЧЗ, 1-для вывода в данных, 2 - для хранения КЛП
			Для Каждого Элемент Из мРезультатов Цикл
				Результат = ТоварыНезаполненные.НайтиСтроки(Новый Структура("SGTIN", Элемент.sgtin));
				Если Результат.Количество() <> 0 Тогда
					Результат[0].ОписаниеНоменклатурыЧЗ = Элемент; 	
				КонецЕсли;	
			КонецЦикла;
			
			// Создаем длитльную операцию поиска номенклатуры 1-пытаемся найти по КЛП, 2-ищем по имени
			ДлительнаяОперация = ПоискНоменклатурыНаСервере(мРезультатов, УникальныйИдентификатор);
			ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
			ПараметрыОжидания.ВыводитьОкноОжидания = Истина;
			ПараметрыОжидания.ТекстСообщения = "Поиск номенклатуры...";
			ОповещениеОЗавершении = Новый ОписаниеОповещения("ЗапроситьИнформациюОНоменклатуре_Завершение", ЭтотОбъект);
			ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
			
		Иначе
			Если РезультатДлительнойОперации.Свойство("status") 
				И РезультатДлительнойОперации.Свойство("error")
			Тогда
				ПоказатьПредупреждение(,"Произошла ошибка " + РезультатДлительнойОперации.status + " " + РезультатДлительнойОперации.error);
			Иначе
				ПоказатьПредупреждение(,"Произошла неизвестная ошибка");
			КонецЕсли;
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапроситьИнформациюОНоменклатуре_Завершение(Результат, ДопПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		
		Если Результат.Статус = "Ошибка" Тогда
			ПоказатьПредупреждение(,Результат.КраткоеПредставлениеОшибки);
			Возврат;
		КонецЕсли;

		мНайденнаяНоменклатура = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		
		// Перебираем найденную номенклатуру, проверяем имется ли уже такая в таблице, если нет то добавляем
		Для Каждого Элемент Из мНайденнаяНоменклатура Цикл
			СтрокиТоваров = ТоварыНезаполненные.НайтиСтроки(Новый Структура("SGTIN", Элемент.Получить("sgtin")));
			Если СтрокиТоваров.Количество() <> 0 Тогда
				РабочаяСтрока = СтрокиТоваров[0];
				Номенклатура = Элемент.Получить("Номенклатура");
				Если НЕ ЗначениеЗаполнено(РабочаяСтрока.Номенклатура) Тогда
					РабочаяСтрока.Номенклатура = Номенклатура;
				КонецЕсли;
				
				//Если РабочаяСтрока.Номенклатура = Номенклатура Тогда
				//	Продолжить;
				//КонецЕсли;
				
				Если РабочаяСтрока.СписокНоменклатур.НайтиСтроки(Новый Структура("Номенклатура", Номенклатура)).Количество() <> 0 Тогда
					Продолжить;			
				КонецЕсли;
				
				НоваяСтрокаТаблицыНоменклатур = РабочаяСтрока.СписокНоменклатур.Добавить();
				НоваяСтрокаТаблицыНоменклатур.Номенклатура = Номенклатура;
				НоваяСтрокаТаблицыНоменклатур.УровеньДостоверности = Элемент.Получить("Уровень");
			КонецЕсли;
		КонецЦикла;
		
		Элементы.ИнформацияЧЗ.Видимость = Истина;
		// Вызываем при активизации строки, по каким-то причинам после длит. операции через раз срабатывает
		// Поэтому вызываем в ручную
		ТоварыНезаполненныеПриАктивизацииСтроки("");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция СобратьJSONТекстЗапроса(мSGTIN)
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ПараметрыЗаписи = Новый ПараметрыЗаписиJSON;
	ЗаписьJSON.УстановитьСтроку(ПараметрыЗаписи);
	ЗаписьJSON.ЗаписатьНачалоОбъекта();
	ЗаписьJSON.ЗаписатьИмяСвойства("filter");
	ЗаписьJSON.ЗаписатьНачалоОбъекта();
	ЗаписьJSON.ЗаписатьИмяСвойства("sgtins");
	ЗаписьJSON.ЗаписатьНачалоМассива();
	Для Каждого SGTIN ИЗ мSGTIN Цикл
		ЗаписьJSON.ЗаписатьЗначение(SGTIN);
	КонецЦикла;
	ЗаписьJSON.ЗаписатьКонецМассива();
	ЗаписьJSON.ЗаписатьКонецОбъекта();
	ЗаписьJSON.ЗаписатьКонецОбъекта();
	СтрокаJSON = ЗаписьJSON.Закрыть();
	Возврат СтрокаJSON;
	
КонецФункции

&НаКлиенте
Процедура СоздатьНоменклатуруЗавершение(Результат, ДопПараметры) Экспорт
		
	Если Результат <> Неопределено Тогда
		
		Если Результат.Статус = "Ошибка" Тогда
			ПоказатьПредупреждение(,Результат.КраткоеПредставлениеОшибки);
			Возврат;
		КонецЕсли;
		
		РезультатДлительнойОперации = ПолучитьИзВременногоХранилища(Результат.АдресРезультата); 
		Если Тип(РезультатДлительнойОперации) = Тип("Строка") Тогда
			ОбщегоНазначения.СообщитьПользователю(РезультатДлительнойОперации);
			Возврат;
		КонецЕсли;
		// Добавляем созданную номенклатуру в таблицу по позициям
		Если РезультатДлительнойОперации <> Неопределено Тогда
			Для Каждого Элемент Из РезультатДлительнойОперации Цикл
				РезультатПоиска = ТоварыНезаполненные.НайтиСтроки(Новый Структура("SGTIN", Элемент.SGTIN));
				Если РезультатПоиска.Количество() <> 0 Тогда
					Для Каждого Рез Из РезультатПоиска Цикл
						Рез.Номенклатура = Элемент.Номенклатура;
						НоваяВСписке = Рез.СписокНоменклатур.Добавить();
						НоваяВСписке.Номенклатура = Элемент.Номенклатура;
						НоваяВСписке.УровеньДостоверности = 4;
					КонецЦикла;
				КонецЕсли;
			КонецЦикла;	
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПоискНоменклатурыНаСервере(мОписаниеНоменклатур, УникальныйИдентификаторФормы)
	НаименованиеЗадания = НСтр("ru = 'ПоискНоменклатуры'");
	ВыполняемыйМетод = "Обработки.ЗаполнениеНоменклатурыМДЛП.ПоискНоменклатуры";
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("мОписаниеНоменклатур", мОписаниеНоменклатур);	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификаторФормы);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	Возврат ДлительныеОперации.ВыполнитьВФоне(ВыполняемыйМетод, СтруктураПараметров, ПараметрыВыполнения);
КонецФункции

&НаСервереБезКонтекста
Функция СоздатьНоменклатуруНаСервере(МассивДляЗапросаИзЕГИСЗ, Специализация, УникальныйИдентификаторФормы)
	НаименованиеЗадания = НСтр("ru = 'Получение и создание номенклатуры'");
	ВыполняемыйМетод = "Обработки.ЗаполнениеНоменклатурыМДЛП.СозданиеНоменклатуры";
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("МассивДляЗапросаИзЕГИСЗ", МассивДляЗапросаИзЕГИСЗ);
	СтруктураПараметров.Вставить("Специализация", Специализация);	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификаторФормы);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	Возврат ДлительныеОперации.ВыполнитьВФоне(ВыполняемыйМетод, СтруктураПараметров, ПараметрыВыполнения);
КонецФункции

&НаСервереБезКонтекста
Функция ЗапросВЧЗНаСервере(JSONСтрока, РезультатАвторизации, УникальныйИдентификаторФормы)
	НаименованиеЗадания = НСтр("ru = 'Запрос в Честный Знак'");
	ВыполняемыйМетод = "Обработки.ЗаполнениеНоменклатурыМДЛП.ЗапросВЧЗ";
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("JSONСтрока", JSONСтрока);
	СтруктураПараметров.Вставить("РезультатАвторизации", РезультатАвторизации);
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификаторФормы);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	Возврат ДлительныеОперации.ВыполнитьВФоне(ВыполняемыйМетод, СтруктураПараметров, ПараметрыВыполнения);
КонецФункции

#КонецОбласти