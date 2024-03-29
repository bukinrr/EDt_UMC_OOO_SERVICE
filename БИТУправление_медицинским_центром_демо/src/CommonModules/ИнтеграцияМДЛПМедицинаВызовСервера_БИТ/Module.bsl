Функция СтруктураОтбораДляВыбораДокументаПоступления(Знач ОтборИлиЗначенияПолей, Знач ЗапрашиваемыеПоля = Неопределено) Экспорт
	
	Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(ОтборИлиЗначенияПолей)) Тогда
		Отбор = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ОтборИлиЗначенияПолей, ЗапрашиваемыеПоля);
	Иначе
		Отбор = ОтборИлиЗначенияПолей;
	КонецЕсли;
	
	Запрос = Новый Запрос(ИнтеграцияМДЛПМедицина_БИТ.ТекстЗапросаДокументовПоступленийДляУведомлений(ТипЗнч(Отбор.Ссылка)));
	
	Для Каждого КлючЗначение Из Отбор Цикл
		Запрос.УстановитьПараметр(КлючЗначение.Ключ, КлючЗначение.Значение);
	КонецЦикла;
	
	Если Не Отбор.Свойство("МестоДеятельностиГрузоотправителя") Тогда
		Запрос.УстановитьПараметр("МестоДеятельностиГрузоотправителя", Неопределено);
	КонецЕсли;
	
	НовыйОтбор = Новый Структура;
	НовыйОтбор.Вставить("Ссылка", Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
	Возврат НовыйОтбор;
	
КонецФункции

#Область ПроверкаКМСредствамиККТ


Функция РежимыКонтроляСредствамиККТ() Экспорт
	
	ВозвращаемоеЗначение = Новый Структура();
	
	ВозвращаемоеЗначение.Вставить("ПриСканировании");
	ВозвращаемоеЗначение.Вставить("ПередПробитиемЧека");
	
	ЗаполнитьЗначенияКлючами(ВозвращаемоеЗначение);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция СохранитьРезультатПроверкиСредствамиККТ(РезультатПроверки, СсылкаНаОбъект) Экспорт
	
	Если Не ЗначениеЗаполнено(СсылкаНаОбъект) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.РезультатыПроверкиКМНаККТ.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Документ.Установить(СсылкаНаОбъект);
	
	Блокировка        = Новый БлокировкаДанных();
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.РезультатыПроверкиКМНаККТ");
	ЭлементБлокировки.УстановитьЗначение(Метаданные.РегистрыСведений.РезультатыПроверкиКМНаККТ.Измерения.Документ.Имя, СсылкаНаОбъект);
	
	Для Каждого СтрокаПроверки Из РезультатПроверки.ПроверяемыеКМ Цикл
		
		РезультатПроверкиПоСтроке = РезультатПроверки.ДанныеПроверки[СтрокаПроверки.УИД];
		
		//Если Не ЗначениеЗаполнено(РезультатПроверкиПоСтроке.ТекстОшибки)
		//	Или Не ЗначениеЗаполнено(СтрокаПроверки.ШтрихкодУпаковки) Тогда
		//	Продолжить;
		//КонецЕсли;
		
		НоваяСтрока = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаПроверки);
		ЗаполнитьЗначенияСвойств(НоваяСтрока, РезультатПроверкиПоСтроке);
		
		НоваяСтрока.Штрихкод = СтрокаПроверки.ШтрихкодУпаковки;
		
		НоваяСтрока.Документ = СсылкаНаОбъект;
		
	КонецЦикла;
	
	НачатьТранзакцию();
	
	Попытка
		
		Блокировка.Заблокировать();
		УстановитьПривилегированныйРежим(Истина);
		НаборЗаписей.Записать(Истина);
		УстановитьПривилегированныйРежим(Ложь);
		
		ЗафиксироватьТранзакцию();
		
		Возврат Истина;
		
	Исключение
		
		ОтменитьТранзакцию();
		ТекстСообщения = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		
		Возврат Ложь;
		
	КонецПопытки;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьЗначенияКлючами(Данные)

	Для Каждого КлючИЗначение Из Данные Цикл
			Данные[КлючИЗначение.Ключ] = КлючИЗначение.Ключ;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

