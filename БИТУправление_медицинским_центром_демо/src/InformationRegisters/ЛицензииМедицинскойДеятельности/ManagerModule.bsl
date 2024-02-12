#Область ПрограммныйИнтерфейс

// Структура данных лицензии по филиалу на дату.
//
// Параметры:
//  Филиал		 - СправочникСсылка.Филиалы	 - филиал
//  ДатаЛицензии - дата						 - дата лицензии.
// 
// Возвращаемое значение:
//  Структура - структура данных лицензии.
//
Функция ПолучитьСтруктуруДанныхЛицензии(Филиал, ДатаЛицензии) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Попытка
		ПоследниеЛицензии = РегистрыСведений.ЛицензииМедицинскойДеятельности.СрезПоследних(ДатаЛицензии, Новый Структура("Филиал", Филиал));
		
		Если ПоследниеЛицензии.Количество() = 0 Тогда
			Возврат Неопределено;
		КонецЕсли;
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	
	Возврат ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ПоследниеЛицензии[0]);
	
КонецФункции

#КонецОбласти