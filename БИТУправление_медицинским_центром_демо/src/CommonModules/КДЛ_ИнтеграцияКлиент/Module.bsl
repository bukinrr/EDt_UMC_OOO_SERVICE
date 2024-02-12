
#Область ПрограммныйИнтерфейс

// Получает массив правил забора для номенклатуры анализа лаборатории Ситилаб.
//
// Параметры:
//  Номенклатура - СправочникСсылка.Номенклатура - номенклатура анализа, для которой получаем правила забора.
//  Лаборатория	 - СправочникСсылка.Лаборатории	 - лаборатория, для которой получаем правила забора.
// 
// Возвращаемое значение:
//   - Массив из Структура:
//  	* Биоматериал 					- Строка
//  	* ВыборНесколькихПравилЗабора 	- Булево
//  	* ИДБиоматериала 				- Строка
//  	* ИДКонтейнера 					- Строка
//  	* ИдПравила 					- УникальныйИдентификатор
//  	* Контейнер 					- Строка
//  	* Обязательное 					- Булево
//  	* Пометка 						- Булево
//  	* Представление 				- Неопределено
//
Функция ПолучитьПравилаЗабораАнализа(Номенклатура, Лаборатория) Экспорт

	Перем ДанныеКешаНоменклатуры;
	
	ПравилаАнализа = Новый Массив;
			
	Если Не глКешНСИЛаборатории.Свойство("КДЛ") Тогда
		Возврат ПравилаАнализа;
	КонецЕсли;
	
	ПараметрыОтбора = Новый Структура;
	
	Для Каждого Анализ Из глКешНСИЛаборатории.КДЛ.НоменклатураАнализов Цикл
		Если Анализ.Номенклатура = Номенклатура И Анализ.Лаборатория = Лаборатория Тогда
			ДанныеКешаНоменклатуры = Анализ;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ДанныеКешаНоменклатуры) Тогда
		Возврат ПравилаАнализа;
	КонецЕсли;
	
	ПравилаТекущегоАнализа = ПолучитьПравилаАнализаИзКешаПоАнализу(ДанныеКешаНоменклатуры.ИД, Лаборатория);
	
	Если Не ЗначениеЗаполнено(ПравилаТекущегоАнализа) Тогда
		Возврат ПравилаАнализа;
	КонецЕсли;
	
	КоличествоПравилТекущегоАнализа = ПравилаТекущегоАнализа.Количество();
	
	Для Каждого ПравилоАнализа Из ПравилаТекущегоАнализа Цикл
		ДанныеПравила = Новый Структура("ИдПравила, Представление, Пометка, Обязательное, Биоматериал, Контейнер,
			|ИДКонтейнера, ИДБиоматериала, ВыборНесколькихПравилЗабора");
		ЗаполнитьЗначенияСвойств(ДанныеПравила, ПравилоАнализа);
		ДанныеПравила.Вставить("ИдПравила", Новый УникальныйИдентификатор);
		
		// По-умолчанию всегда есть возможность выбора нескольких правил забора, если правил для анализа больше одного.
		Если КоличествоПравилТекущегоАнализа > 1 Тогда
			ДанныеПравила.Вставить("ВыборНесколькихПравилЗабора", Истина);
		Иначе
			ДанныеПравила.Вставить("ВыборНесколькихПравилЗабора", Ложь);
		КонецЕсли;

		Если ПравилоАнализа.Обязательность Тогда
			ДанныеПравила.Вставить("Пометка", Истина);
			ДанныеПравила.Вставить("Обязательное", Истина);
		Иначе
			ДанныеПравила.Вставить("Пометка", Ложь);
			ДанныеПравила.Вставить("Обязательное", Ложь);
		КонецЕсли;
		
		ПравилаАнализа.Добавить(ДанныеПравила);
	КонецЦикла;
	
	Возврат ПравилаАнализа;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьПравилаАнализаИзКешаПоАнализу(ИдАнализа, Лаборатория)
	
	мсПравилаАнализа = Новый Массив;
	
	Если глКешНСИЛаборатории.КДЛ.КДЛ_ПравилаАнализов <> Неопределено
		И глКешНСИЛаборатории.КДЛ.КДЛ_ПравилаАнализов.Количество() > 0
	Тогда
		
		Для Каждого ПравилоАнализа Из глКешНСИЛаборатории.КДЛ.КДЛ_ПравилаАнализов Цикл
			Если ПравилоАнализа.ИдАнализа = ИдАнализа И ПравилоАнализа.Лаборатория = Лаборатория Тогда
				мсПравилаАнализа.Добавить(ПравилоАнализа);
			КонецЕсли;
		КонецЦикла;
	
	КонецЕсли;
	
	Возврат мсПравилаАнализа;
	
КонецФункции

#КонецОбласти
