#Область ПрограммныйИнтерфейс

// Дополняет структуру учетной политики при её вычислении.
//
// Параметры:
//  УчетнаяПолитика	 - Структура - учетная политика.
//
Процедура ПриПолученииУчетнойПолитики(УчетнаяПолитика) Экспорт

	#Область Стоматология // Учетная политика функционала стоматологии.
	Попытка
		ЕстьПодсистемаСтоматологии = ПроцедурыСпециализацииПоставки.ЕстьПодсистемаСтоматологии();
	Исключение
		ЕстьПодсистемаСтоматологии = Ложь;
	КонецПопытки;
	
	Если ЕстьПодсистемаСтоматологии Тогда
		ИмяРегистраНастроек = "стомУчетнаяПолитика";
		стомНастройки = РегистрыСведений[ИмяРегистраНастроек].ПолучитьНастройки();		
		Для Каждого кзНастройка Из стомНастройки Цикл
			УчетнаяПолитика.Вставить(кзНастройка.Ключ, кзНастройка.Значение);
		КонецЦикла;
	КонецЕсли;
	#КонецОбласти
	
КонецПроцедуры

// Создает запись настроек учета в регистре, если еще нет. Используется для первоначальной инициации базы.
//
Процедура СоздатьЗаписьНастроекУчета() Экспорт
	
	нзУП = РегистрыСведений.НастройкиМедицинскогоУчета.СоздатьНаборЗаписей();
	нзУП.Прочитать();
	Если нзУП.Количество() = 0 Тогда
		Запись = нзУП.Добавить();
		Для Каждого Ресурс Из Метаданные.РегистрыСведений.НастройкиМедицинскогоУчета.Ресурсы Цикл
			Запись[Ресурс.Имя] = ПолучитьЗначениеПараметраУчетнойПолитикиПоУмолчанию(Ресурс.Имя);
		КонецЦикла;
		нзУП.Записать();
	КонецЕсли;
	
КонецПроцедуры

// Возвращает значение параметра учетной политики.
//
// Параметры:
//  ИмяПараметра - Строка	 - имя параметра.
//
// Возвращаемое значение:
//  Произвольный - определяется типом значения параметра.
//
Функция ПолучитьПараметрУчета(ИмяПараметра) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	нзУП = РегистрыСведений.НастройкиМедицинскогоУчета.СоздатьНаборЗаписей();
	нзУП.Прочитать();
	Если нзУП.Количество() > 0 Тогда
		Возврат	ОбщегоНазначенияКлиентСервер.СвойствоОбъекта(нзУП[0], ИмяПараметра);
	Иначе
		МетаданныеРесурса = нзУП.Метаданные().Ресурсы.Найти(ИмяПараметра);
		Если МетаданныеРесурса = Неопределено Тогда
			Возврат Неопределено;
		Иначе
			Возврат МетаданныеРесурса.Тип.ПривестиЗначение(Неопределено);
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

// Сохраняет новое значение параметра учетной политики.
//
// Параметры:
//  ИмяПараметра - Строка	 - имя параметра.
//  Значение	 - Произвольный	 - определяется типом значения параметра.
//
Процедура УстановитьПараметрУчета(ИмяПараметра, Значение) Экспорт
	
	нзУП = РегистрыСведений.НастройкиМедицинскогоУчета.СоздатьНаборЗаписей();
	нзУП.Прочитать();
	Если нзУП.Количество() = 0 Тогда
		СоздатьЗаписьНастроекУчета();
		нзУП.Прочитать();
	КонецЕсли;
	
	нзУП[0][ИмяПараметра] = Значение;
	нзУП.Записать();
	
КонецПроцедуры

// Возвращает значение параметра учетной политики по умолчанию.
//
// Параметры:
//  ИмяПараметра - Строка	 - имя параметра.
//
// Возвращаемое значение:
//  Произвольный - определяется типом значения параметра.
//
Функция ПолучитьЗначениеПараметраУчетнойПолитикиПоУмолчанию(ИмяПараметра) Экспорт
	                                            
	Если ИмяПараметра = "ИспользоватьЛабораторныеИсследования" Тогда
		Возврат Истина;		
	Иначе
		Возврат Метаданные.РегистрыСведений.НастройкиМедицинскогоУчета.Ресурсы[ИмяПараметра].Тип.ПривестиЗначение(Неопределено);
	КонецЕсли;	
	
КонецФункции

#КонецОбласти