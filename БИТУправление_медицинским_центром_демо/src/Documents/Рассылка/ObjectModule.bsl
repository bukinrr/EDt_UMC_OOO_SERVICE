#Область ПрограммныйИнтерфейс

// Отправляет неотправленные сообщения из числа переданных.
//
// Параметры:
//  НаборЗаписейСообщения - РегистрыСведенийНаборЗаписей.СообщенияSMS - сообщения документа.
//
// Возвращаемое значение:
//  Структура.
//
Функция ОтправитьНеотправленныеСообщения(НаборЗаписейСообщения = Неопределено) Экспорт
	
	РезультатОтправки = СМС_ФормированиеСообщений.ОтправитьНеотправленныеСообщения(Ссылка, НаборЗаписейСообщения);
	
	Возврат РезультатОтправки;
	
КонецФункции

// Обновляет статусы сообщений документа по состоянию отправки.
//
Процедура УстановитьСтатусСообщенийПоДокументу() Экспорт
	
	НаборЗаписейСообщения = РегистрыСведений.СообщенияSMS.СоздатьНаборЗаписей();
	НаборЗаписейСообщения.Отбор.Рассылка.Установить(Ссылка);
	НаборЗаписейСообщения.Прочитать();
	Для Каждого Запись Из НаборЗаписейСообщения Цикл
		Если Проведен И Запись.СтатусОтправки = Перечисления.СтатусыОтправкиСообщений.ПустаяСсылка() Тогда
			Запись.СтатусОтправки = Перечисления.СтатусыОтправкиСообщений.НеОтправлено;
		ИначеЕсли Не Проведен И Запись.СтатусОтправки = Перечисления.СтатусыОтправкиСообщений.НеОтправлено Тогда
			Запись.СтатусОтправки = Перечисления.СтатусыОтправкиСообщений.ПустаяСсылка();
		КонецЕсли;
		Запись.ДатаОтправки = ДатаОтправки;
	КонецЦикла;
	НаборЗаписейСообщения.Записать(Истина);
	
КонецПроцедуры

// Перезаполнляет текст сообщений по виду сообщения рассылки.
//
// Параметры:
//  ТабСообщения - ТаблицаЗначений	 - сообщения.
//
Процедура ЗаполнитьТекстПоВидамСообщений(ТабСообщения) Экспорт
	
	ТабВидыСообщений = ТабСообщения.Скопировать();
	ТабВидыСообщений.Свернуть("ВидСообщения");
	
	ДанныеВидовСообщений = СМС_ФормированиеСообщений.ПолучитьДанныеВидовСообщений(ТабВидыСообщений.ВыгрузитьКолонку("ВидСообщения"));
	
	Для Каждого СтрокаВидСообщения Из ТабВидыСообщений Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаВидСообщения.ВидСообщения) Тогда
			Продолжить
		КонецЕсли;
		
		Если ДанныеВидовСообщений.НайтиСледующий(Новый Структура("ВидСообщения",СтрокаВидСообщения.ВидСообщения)) Тогда
			
			мсСтрокиСообщения = ТабСообщения.НайтиСтроки(Новый Структура("ВидСообщения",СтрокаВидСообщения.ВидСообщения));
			Для Каждого СтрокаСообщения Из мсСтрокиСообщения Цикл
				
				СтрокаСообщения.Текст = СМС_ФормированиеСообщений.ВычислитьТекстСообщения(ДанныеВидовСообщений, СтрокаСообщения);	
				
			КонецЦикла;
			
		КонецЕсли;		
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если Не Проведен
		И Не ДополнительныеСвойства.Свойство("ЗаписьБезОбработки")
	Тогда
		УстановитьСтатусСообщенийПоДокументу();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
