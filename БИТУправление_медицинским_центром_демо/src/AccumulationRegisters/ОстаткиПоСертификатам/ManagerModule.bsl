#Область ПрограммныйИнтерфейс

// Выполняет приходные документа движения по регистру накопления "Сертификаты".
//
// Параметры:
//  ДокументОбъект						 - ДокументОбъект	 - объект документа, по которому выполняются движения
//  СтруктураШапкиДокумента				 - Структура		 - структура шапки документа, откуда вызвана процедура
//  ТаблицаПоСертификатам				 - ТаблицаЗначений	 - таблица с данными по продаваемым сертификатам для формирования движений
//  ТаблицаПоДопроданнымНоменклатурам	 - ТаблицаЗначений	 - пополнение сертификатов.
//  ЭтоПродажа							 - Булево			 - продажа ли это.
//  ЭтоВозвратСВозвратомРасхода			 - Булево			 - возвращается ли расход сертификатов этим документом.
//
Процедура ВыполнитьДвиженияПоРегиструОстаткиПоСертификатамПриход(ДокументОбъект, СтруктураШапкиДокумента, ТаблицаПоСертификатам, ТаблицаПоДопроданнымНоменклатурам = Неопределено, ЭтоПродажа=Истина, ЭтоВозвратСВозвратомРасхода = Ложь) Экспорт
	
	НаборДвижений = ДокументОбъект.Движения.ОстаткиПоСертификатам;
	ТаблицаДвижений = НаборДвижений.Выгрузить();
	ТаблицаДвижений.Очистить();
	
	ДатаНачалаРаботыСАбонементамиПоСхемеАБ_4_20_13041 = Константы.ДатаНачалаРаботыСАбонементамиПоСхемеАБ_4_20_13041.Получить();
	
	Для Каждого стрПродажаСертификата Из ТаблицаПоСертификатам Цикл
		ВидСертификата = стрПродажаСертификата.Сертификат.ВидСертификата;
		Если ЭтоПродажа Тогда
			ДатаАнализаОстатков = ДокументОбъект.МоментВремени().Дата;	
		Иначе
			ДатаАнализаОстатков = ?(стрПродажаСертификата.ДатаНачалаДействия > ДокументОбъект.МоментВремени().Дата, стрПродажаСертификата.ДатаНачалаДействия + 1, ДокументОбъект.МоментВремени().Дата + 1);	
		КонецЕсли;
		Если ВидСертификата.ТипСертификата = Перечисления.ТипыСертификатов.НаУслуги
			И ВидСертификата.КомплексныйСертификат 
		Тогда // Комплексный сертификат на услуги.
		
			Если ЭтоПродажа Тогда
				УслугиСертификата = ВидСертификата.Услуги;
				
				СуммарныйНоминалУслуг = ВидСертификата.Услуги.Итог("Количество");
				ОстатокСуммыПродажи = стрПродажаСертификата.Сумма;
			Иначе
				УслугиСертификата = СертификатыКлиентов.ОстаткиКомплексногоСертификата(стрПродажаСертификата.Сертификат, ДатаАнализаОстатков);
			КонецЕсли;
			
			Для Каждого СтрокаУслуги Из УслугиСертификата Цикл
				
				Если ЭтоПродажа Тогда
					Если СуммарныйНоминалУслуг <> 0 Тогда
						СуммаПокупки = стрПродажаСертификата.Сумма * СтрокаУслуги.Количество / СуммарныйНоминалУслуг;
					Иначе
						СуммаПокупки = стрПродажаСертификата.Сумма / ВидСертификата.Услуги.Количество();
					КонецЕсли;
					
					Если СуммаПокупки = 0 И СтрокаУслуги.Количество = 0 Тогда
						Продолжить; // Не делаем движение по остаткам, если прирост остатка и сумма покупки нулевые.
					КонецЕсли;
				КонецЕсли;
				
				СтрокаДвижения	= ТаблицаДвижений.Добавить();
				Если ЭтоПродажа Тогда
					СтрокаДвижения.Период	= стрПродажаСертификата.ДатаНачалаДействия; 
				Иначе
					СтрокаДвижения.Период	= ?(стрПродажаСертификата.ДатаНачалаДействия > СтруктураШапкиДокумента.Дата, стрПродажаСертификата.ДатаНачалаДействия + 1, СтруктураШапкиДокумента.Дата); 		
				КонецЕсли;
				СтрокаДвижения.Сертификат 	= стрПродажаСертификата.Сертификат;
				
				Если ЭтоПродажа Тогда
					СтрокаДвижения.Номенклатура	= СтрокаУслуги.Фильтр;
					СтрокаДвижения.Сумма	= СтрокаУслуги.Количество; // Номинал.
					СтрокаДвижения.СуммаПокупки	= СуммаПокупки;
					
					ОстатокСуммыПродажи = ОстатокСуммыПродажи - СтрокаДвижения.СуммаПокупки;
				Иначе
					СтрокаДвижения.Номенклатура	= СтрокаУслуги.Номенклатура;
					СтрокаДвижения.Сумма 	= СтрокаУслуги.Остаток;
					СтрокаДвижения.СуммаПокупки	= СтрокаУслуги.СуммаПокупки;
				КонецЕсли;
				
				СтрокаДвижения.СуммаПокупки	= СуммаПокупки;
				
			КонецЦикла;
			
			Если ЭтоПродажа Тогда
				Если ОстатокСуммыПродажи <> 0 
					И ТаблицаДвижений.Количество() > 0
				Тогда
					ТаблицаДвижений[0].СуммаПокупки = ТаблицаДвижений[0].СуммаПокупки + ОстатокСуммыПродажи;
				КонецЕсли;
			КонецЕсли;
			
		Иначе // Сертификат на оплату или на услуги, но не комплексный.
				
			Движение = ТаблицаДвижений.Добавить();
			Движение.Сертификат  = стрПродажаСертификата.Сертификат;
			Если ЭтоПродажа Тогда
				Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
				Движение.Сумма	= ?(стрПродажаСертификата.Сертификат.ВидСертификата.НоминалРавенСтоимости,стрПродажаСертификата.Сумма,стрПродажаСертификата.Номинал);
			Иначе
				Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
				Движение.Сумма 	= СертификатыКлиентов.ПолучитьОстатокПоСертификату(Движение.Сертификат, ДатаАнализаОстатков);
			КонецЕсли;
			Если ЭтоПродажа Тогда
				Движение.Период	= стрПродажаСертификата.ДатаНачалаДействия; 
			Иначе
				Движение.Период	= ?(стрПродажаСертификата.ДатаНачалаДействия > СтруктураШапкиДокумента.Дата, стрПродажаСертификата.ДатаНачалаДействия + 1, СтруктураШапкиДокумента.Дата); 		
			КонецЕсли;
			Если РаботаСТорговымОборудованием.ПолучитьДатуПервойПродажиСертификата(Движение.Сертификат, ДокументОбъект.Ссылка) > ДатаНачалаРаботыСАбонементамиПоСхемеАБ_4_20_13041 Тогда
				Движение.СуммаПокупки = стрПродажаСертификата.Сумма;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	// Допроданные услуги или суммы
	Для Каждого стрДопродажи Из ТаблицаПоДопроданнымНоменклатурам Цикл
		Движение = ТаблицаДвижений.Добавить();
		Если ЭтоПродажа Тогда
			Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Иначе
			Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		КонецЕсли;
		
		Если стрДопродажи.Сертификат.ВидСертификата.КомплексныйСертификат Тогда
			Движение.Номенклатура = стрДопродажи.Номенклатура;
		КонецЕсли;
		Движение.Сертификат   = стрДопродажи.Сертификат;
		Движение.Сумма        = ?(стрДопродажи.Сертификат.ВидСертификата.ТипСертификата = Перечисления.ТипыСертификатов.НаУслуги,
									 стрДопродажи.Количество,
									 стрДопродажи.Сумма);
		Движение.СуммаПокупки = стрДопродажи.Сумма;
		Движение.Период		 = СтруктураШапкиДокумента.Дата;
	КонецЦикла;
	
	НаборДвижений.мПериод            = СтруктураШапкиДокумента.Дата;
	НаборДвижений.мТаблицаДвижений   = ТаблицаДвижений;
	Если ЭтоПродажа Тогда
		НаборДвижений.ВыполнитьПриход();
	Иначе
		НаборДвижений.ВыполнитьРасход();
	КонецЕсли;
	
КонецПроцедуры

// Выполняет расходные документа движения по регистру накопления "Сертификаты".
//
// Параметры:
//  ДокументОбъект			 - ДокументОбъект	 - объект документа, по которому выполняются движения
//  СтруктураШапкиДокумента	 - Структура		 - структура шапки документа, откуда вызвана процедура
//  ТаблицаПоОплате			 - ТаблицаЗначений	 - таблица с данными для формирования движений
//  ТаблицаПоРаботам		 - ТаблицаЗначений	 - таблица с данными по услугам для формирования движений
//  Отказ					 - Булево			 - признак отмены проведения документа.
//  ЭтоПродажа				 - Булево			 - продажа ли это.
//  ЭтоРасходСПродажей		 - Булево			 - является ли документ возвратом с возвратом расхода.
//
Процедура ВыполнитьДвиженияПоРегиструОстаткиПоСертификатамРасход(ДокументОбъект, СтруктураШапкиДокумента, ТаблицаПоОплате, ТаблицаПоРаботам, Отказ, ЭтоПродажа=Истина, ЭтоРасходСПродажей = Ложь) Экспорт
	
	НаборДвижений = ДокументОбъект.Движения.ОстаткиПоСертификатам;
	ТаблицаДвижений = НаборДвижений.Выгрузить();
	ТаблицаДвижений.Очистить();
	
	// Шаг 1. Сертификаты на оплату по ТЧ "Оплата"
	мсСтрокПоСертификатам = ТаблицаПоОплате.НайтиСтроки(Новый Структура("ВидОплаты",Перечисления.ВидыОплаты.Сертификатом));
	Если мсСтрокПоСертификатам.Количество()<>0 Тогда
		Для Каждого стрОплата Из мсСтрокПоСертификатам Цикл
			Движение	= ТаблицаДвижений.Добавить();
			Если ЭтоПродажа Тогда
				Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
			Иначе
				Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
			КонецЕсли;
			Движение.Сертификат  = стрОплата.Сертификат;
			Движение.Сумма       = стрОплата.Сумма;
		КонецЦикла;
	КонецЕсли;
	
	// Шаг 2. Сертификаты на услуги по ТЧ "Работы"
	СписокСертификатовНаРаботы = ТаблицаПоРаботам.ВыгрузитьКолонку("Сертификат");
	
	ДатаАнализаОстатков = ?(ЭтоРасходСПродажей, ДокументОбъект.Дата + 1, ДокументОбъект.МоментВремени());
	ТаблицаОстатковПоСертификатам = СертификатыКлиентов.ПолучитьТаблицуОстатковСертификатов(СписокСертификатовНаРаботы, ДатаАнализаОстатков);
	ДатаНачалаРаботыСАбонементамиПоСхемеАБ_4_20_13041 = Константы.ДатаНачалаРаботыСАбонементамиПоСхемеАБ_4_20_13041.Получить();
	
	Для Каждого стрРаботы Из ТаблицаПоРаботам Цикл
		Если ЗначениеЗаполнено(стрРаботы.Сертификат) Тогда
			Если стрРаботы.Сертификат.ВидСертификата.ТипСертификата = Перечисления.ТипыСертификатов.НаУслуги
				И стрРаботы.Сертификат.ВидСертификата.КомплексныйСертификат
			Тогда
				мсСтр = ТаблицаОстатковПоСертификатам.НайтиСтроки(Новый Структура("Сертификат, Номенклатура", стрРаботы.Сертификат, стрРаботы.Номенклатура));
				Если мсСтр.Количество() <> 0 Тогда
					стрРаботы.СертификатСумма = мсСтр[0].Сумма;
					стрРаботы.СертификатСуммаПокупки = мсСтр[0].СуммаПокупки;
				КонецЕсли;

				стрРаботы.СертификатСуммаПокупкиСписание = ?(стрРаботы.СертификатСумма = 0, 0, (стрРаботы.Количество / стрРаботы.СертификатСумма) * стрРаботы.СертификатСуммаПокупки);

				Движение = ТаблицаДвижений.Добавить();
				Если ЭтоПродажа Тогда
					Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
				Иначе
					Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
					Если стрРаботы.СертификатСуммаПокупкиСписание = 0 И Не ЭтоПродажа Тогда
						ОстаткиПоСертификату = ПолучитьСписанияПродажи(ДокументОбъект, стрРаботы.Сертификат, стрРаботы.Номенклатура);
						стрРаботы.СертификатСуммаПокупкиСписание = Окр(ОстаткиПоСертификату.СуммаПокупки / ОстаткиПоСертификату.Сумма * стрРаботы.Количество , 2);		
					КонецЕсли;
				КонецЕсли;
				
				Движение.Номенклатура = стрРаботы.Номенклатура;
				Движение.Сертификат  = стрРаботы.Сертификат;
				Движение.Сумма       = стрРаботы.Количество;
                Движение.СуммаПокупки = стрРаботы.СертификатСуммаПокупкиСписание;
				
			Иначе
				мсСтр = ТаблицаОстатковПоСертификатам.НайтиСтроки(Новый Структура("Сертификат", стрРаботы.Сертификат));
				Если мсСтр.Количество() > 0 Тогда
					ОстаткиПоСертификату = мсСтр[0];		
				КонецЕсли;
				Движение = ТаблицаДвижений.Добавить();
				Если ЭтоПродажа Тогда
					Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
				Иначе
					Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
				КонецЕсли;
				Движение.Сертификат  	= стрРаботы.Сертификат;
				Движение.Сумма       	= стрРаботы.Количество;
				// Для расчета не комплексных сертификатов "симулируем" проведение каждой строки, чтобы сумма была с точностью до копейки
				Если РаботаСТорговымОборудованием.ПолучитьДатуПервойПродажиСертификата(Движение.Сертификат, ДокументОбъект.Ссылка) > ДатаНачалаРаботыСАбонементамиПоСхемеАБ_4_20_13041 Тогда
					Если ОстаткиПоСертификату = Неопределено И Не ЭтоПродажа Тогда
						ОстаткиПоСертификату = ПолучитьСписанияПродажи(ДокументОбъект, стрРаботы.Сертификат);	
					КонецЕсли;
					ИтогПоДокументуНакопленный = ПолучитьИтогПредыдущихДвиженийСертификата(Движение.Сертификат, ТаблицаДвижений);
					Движение.СуммаПокупки = (ОстаткиПоСертификату.СуммаПокупки - ИтогПоДокументуНакопленный.СуммаПокупки) / (ОстаткиПоСертификату.Сумма - ИтогПоДокументуНакопленный.Сумма + Движение.Сумма) * Движение.Сумма;
				КонецЕсли;		
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Если ТаблицаДвижений.Количество() <> 0 Тогда
		НаборДвижений.мПериод            = СтруктураШапкиДокумента.Дата;
		НаборДвижений.мТаблицаДвижений   = ТаблицаДвижений;
		Если Не Отказ Тогда
			Если Не ЭтоПродажа Тогда
				НаборДвижений.ВыполнитьПриход();
			Иначе
				НаборДвижений.ВыполнитьРасход();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ПолучитьИтогПредыдущихДвиженийСертификата(Сертификат, ТаблицаДвижений)

	Итоги = Новый Структура("СуммаПокупки, Сумма", 0, 0);
	
	СтрокиСертификата = ТаблицаДвижений.НайтиСтроки(Новый Структура("Сертификат", Сертификат));
	
	Для Каждого СтрокаСертификата Из СтрокиСертификата Цикл
		
		Итоги.СуммаПокупки = Итоги.СуммаПокупки	 + СтрокаСертификата.СуммаПокупки;
		Итоги.Сумма		   = Итоги.Сумма		 + СтрокаСертификата.Сумма;
		
	КонецЦикла;
	
	Возврат Итоги;
	
КонецФункции

Функция ПолучитьСписанияПродажи(ДокументОбъект, Сертификат, Номенклатура = Неопределено)
	
	Номенклатура = ?(Номенклатура = Неопределено, Справочники.Номенклатура.ПустаяСсылка(), Номенклатура);
	
	ДокументПродажи = ДокументОбъект.ДокументОснование.ПолучитьОбъект();
	
	ДвиженияОстатковПродажи = ДокументПродажи.Движения.ОстаткиПоСертификатам;
	ДвиженияОстатковПродажи.Прочитать();
	
	Сумма = 0;
	СуммаПокупки = 0;
	
	Для Каждого Движение Из ДвиженияОстатковПродажи Цикл
		Если Движение.Сертификат = Сертификат
			И Движение.Номенклатура = Номенклатура
		Тогда
			СуммаПокупки = СуммаПокупки + Движение.СуммаПокупки;
			Сумма = Сумма + Движение.Сумма;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Новый Структура("СуммаПокупки, Сумма", СуммаПокупки, Сумма);
	
КонецФункции

#КонецОбласти
