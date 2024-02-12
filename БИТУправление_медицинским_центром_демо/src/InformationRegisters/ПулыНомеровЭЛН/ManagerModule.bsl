#Область ПрограммныйИнтерфейс

// Получить текущий номер из пула ЭЛН.
//
// Параметры:
//  ОГРН			 - Строка	 - ОГРН
//  РабочийКонтур	 - Булево	 - рабочий контур или тестовый.
// 
// Возвращаемое значение:
//  Число - текущий номер.
//
Функция ПолучитьТекущийНомер(ОГРН, РабочийКонтур) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	ПулыНомеровЭЛН.ТекущийНомер КАК ТекущийНомер,
	               |	ПулыНомеровЭЛН.НачалоДиапазона КАК НачалоДиапазона,
	               |	ПулыНомеровЭЛН.ОкончаниеДиапазона КАК ОкончаниеДиапазона
	               |ИЗ
	               |	РегистрСведений.ПулыНомеровЭЛН КАК ПулыНомеровЭЛН
	               |ГДЕ
	               |	НЕ ПулыНомеровЭЛН.Закрыт
	               |	И ПулыНомеровЭЛН.ОГРН = &ОГРН
	               |	И ПулыНомеровЭЛН.РабочийКонтур = &РабочийКонтур";
	Запрос.УстановитьПараметр("РабочийКонтур", РабочийКонтур);	
	Запрос.УстановитьПараметр("ОГРН", ОГРН);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Номер = Выборка.ТекущийНомер;
	Иначе
		Возврат Неопределено;	
	КонецЕсли; 
	
	Возврат Номер;
	
КонецФункции

// Зафиксировать в пуле новый текущий номер.
//
// Параметры:
//  Номер	 - Число - номер.
//
Процедура ЗафиксироватьНомерВПуле(Номер) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийНомер",Номер);
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	ПулыНомеровЭЛН.ТекущийНомер КАК ТекущийНомер,
	               |	ПулыНомеровЭЛН.НачалоДиапазона КАК НачалоДиапазона,
	               |	ПулыНомеровЭЛН.ОкончаниеДиапазона КАК ОкончаниеДиапазона
	               |ИЗ
	               |	РегистрСведений.ПулыНомеровЭЛН КАК ПулыНомеровЭЛН
	               |ГДЕ
	               |	НЕ ПулыНомеровЭЛН.Закрыт
	               |	И ПулыНомеровЭЛН.ТекущийНомер = &ТекущийНомер";
	Выборка = Запрос.Выполнить().Выбрать();	
	
	Если Выборка.Следующий() Тогда
		Запись = СоздатьМенеджерЗаписи();
		Запись.НачалоДиапазона = Выборка.НачалоДиапазона;
		Запись.ОкончаниеДиапазона = Выборка.ОкончаниеДиапазона;
		Запись.Прочитать();
		Если Выборка.ОкончаниеДиапазона = Номер Тогда
			Запись.Закрыт = Истина;
		Иначе
			Запись.ТекущийНомер = Номер + 1; 	
		КонецЕсли; 
		Запись.Записать();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти