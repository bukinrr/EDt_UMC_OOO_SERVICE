
#Область СлужебныйПрограммныйИнтерфейс

// Выполняет действия перед началом работы системы.
//
Процедура ПередНачаломРаботыСистемы(Отказ) Экспорт
	
	ПараметрыРаботыКлиентаПриЗапуске = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	ТекстСообщения = "";
	Если Не ПараметрыРаботыКлиентаПриЗапуске.Свойство("СеансыОбластиДанныхЗаблокированы", ТекстСообщения) Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = ПараметрыРаботыКлиентаПриЗапуске.ПредложениеСнятьБлокировку;
	Если Не ПустаяСтрока(ТекстВопроса) Тогда
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена, 15,, 
			НСтр("ru = 'Блокировка работы пользователей'"), КодВозвратаДиалога.Отмена);
		Если Ответ = КодВозвратаДиалога.Да Тогда // входим в заблокированное приложение
			Возврат;
		ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда // снимаем блокировку и входим в приложение
			СоединенияИБ.УстановитьБлокировкуСеансовОбластиДанных(Новый Структура("Установлена", Ложь));
			Возврат;
		Иначе	// пока не входим
			ЗавершитьРаботуСистемы(Ложь, Истина);	
		КонецЕсли;	
	Иначе	
		Предупреждение(ТекстСообщения, 15);
		ЗавершитьРаботуСистемы(Ложь, Истина);	
	КонецЕсли;
	
	Отказ = Истина;
	
КонецПроцедуры

// Выполняет действия при начале работы системы.
//
Процедура ПриНачалеРаботыСистемы() Экспорт
	
	Если НЕ ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	Если ПолучитьСкоростьКлиентскогоСоединения() <> СкоростьКлиентскогоСоединения.Обычная Тогда
		Возврат;	
	КонецЕсли;
	
	РежимБлокировки = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ПараметрыБлокировкиСеансов;
	ТекущееВремя = РежимБлокировки.ТекущаяДатаСеанса;
	Если РежимБлокировки.Установлена 
		 И (НЕ ЗначениеЗаполнено(РежимБлокировки.Начало) ИЛИ ТекущееВремя >= РежимБлокировки.Начало) 
		 И (НЕ ЗначениеЗаполнено(РежимБлокировки.Конец) ИЛИ ТекущееВремя <= РежимБлокировки.Конец) Тогда
		// Если пользователь зашел в базу, в которой установлена режим блокировки, значит использовался ключ /UC.
		// Завершать работу такого пользователя не следует
		Возврат;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("КонтрольРежимаЗавершенияРаботыПользователей", 60);	
	
КонецПроцедуры

// Устанавливает значение переменной ЗавершитьВсеСеансыКромеТекущего в значение Значение.
//
// Параметры:
//   Значение - Булево - устанавливаемое значение.
//
Процедура УстановитьПризнакЗавершитьВсеСеансыКромеТекущего(Значение) Экспорт
	
	ИмяПараметра = "СтандартныеПодсистемы.ПараметрыЗавершенияРаботыПользователей";
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПараметра, Новый Структура);
	КонецЕсли;
	
	ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыЗавершенияРаботыПользователей"].Вставить("ЗавершитьВсеСеансыКромеТекущего", Значение);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Подключить обработчик ожидания КонтрольРежимаЗавершенияРаботыПользователей или
// ЗавершитьРаботуПользователей в зависимости от параметра УстановитьБлокировкуСоединений.
//
Процедура УстановитьОбработчикиОжиданияЗавершенияРаботыПользователей(Знач УстановитьБлокировкуСоединений) Экспорт
	
	РаботаПользователейЗавершается = УстановитьБлокировкуСоединений;
	Если УстановитьБлокировкуСоединений Тогда
		// поскольку блокировка еще не установлена, то при входе в систему
		// для данного пользователя был подключен обработчик ожидания завершения работы.
		// Отключаем его. Так как для этого пользователя подключается специализированный обработчик ожидания
		// "ЗавершитьРаботуПользователей", который ориентирован на то, что данный пользователь
		// должен быть отключен последним.
		
		ОтключитьОбработчикОжидания("КонтрольРежимаЗавершенияРаботыПользователей");
		ПодключитьОбработчикОжидания("ЗавершитьРаботуПользователей", 60);
		ЗавершитьРаботуПользователей();
	Иначе
		ОтключитьОбработчикОжидания("ЗавершитьРаботуПользователей");
		ПодключитьОбработчикОжидания("КонтрольРежимаЗавершенияРаботыПользователей", 60);
	КонецЕсли;
	
КонецПроцедуры

Процедура СохранитьПараметрыАдминистрирования(Значение) Экспорт
	
	ИмяПараметра = "СтандартныеПодсистемы.ПараметрыЗавершенияРаботыПользователей";
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПараметра, Новый Структура);
	КонецЕсли;
	
	ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыЗавершенияРаботыПользователей"].Вставить("ПараметрыАдминистрирования", Значение);

КонецПроцедуры

// Показывает предупреждение о завершении работы пользователей.
//
// Параметры:
//  ТекстСообщения	 - Строка - сообщение для пользователей. 
//
Процедура ПоказатьПредупреждениеПриЗавершенииРаботы(ТекстСообщения) Экспорт
	
	ПоказатьПредупреждение(, ТекстСообщения, 30);
	
КонецПроцедуры

// Задает вопрос пользователям о завершении работы в информационной базе.
//
// Параметры:
//  ТекстСообщения	 - Строка - сообщение для пользователей. 
//
Процедура ЗадатьВопросПриЗавершенииРаботы(ТекстСообщения) Экспорт
	
	ТекстВопроса = НСтр("ru = '%1
		|Завершить работу?'");
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстВопроса, ТекстСообщения);
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗадатьВопросПриЗавершенииРаботыЗавершение", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 30, КодВозвратаДиалога.Да);
	
КонецПроцедуры

// Завершает работу системы при положительном ответе пользователя на вопрос о завершении работы.
//
// Параметры:
//  Ответ					 - КодВозвратаДиалога - код ответа пользователя. 
//  ДополнительныеПараметры	 - Произвольный - содержит дополнительные параметры. 
//
Процедура ЗадатьВопросПриЗавершенииРаботыЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ЗавершитьРаботуСистемы(Истина, Ложь);
	КонецЕсли;
	
КонецПроцедуры

// Обработать параметры запуска, связанные с завершение и разрешение соединений ИБ.
//
// Параметры
//  ЗначениеПараметраЗапуска  – Строка – главный параметр запуска
//  ПараметрыЗапуска          – Массив – дополнительные параметры запуска, разделенные
//                                       символом ";".
//
// Возвращаемое значение:
//   Булево   – Истина, если требуется прекратить выполнение запуска системы.
//
Функция ОбработатьПараметрыЗапуска(Знач ЗначениеПараметраЗапуска, Знач ПараметрыЗапуска) Экспорт

	Если НЕ ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Обработка параметров запуска программы - 
	// ЗапретитьРаботуПользователей и РазрешитьРаботуПользователей
	Если ЗначениеПараметраЗапуска = Врег("РазрешитьРаботуПользователей") Тогда
		
		Если НЕ СоединенияИБ.РазрешитьРаботуПользователей() Тогда
			ТекстСообщения = НСтр("ru = 'Параметр запуска РазрешитьРаботуПользователей не отработан. Нет прав на администрирование информационной базы.'");
			Предупреждение(ТекстСообщения);
			Возврат Ложь;
		КонецЕсли;
		
		ЗавершитьРаботуСистемы(Ложь);
		Возврат Истина;
		
	// Параметр может содержать две дополнительные части, разделенные символом ";" - 
	// имя и пароль администратора ИБ, от имени которого происходит подключение к кластеру серверов
	// в клиент-серверном варианте развертывания системы. Их необходимо передавать в случае, 
	// если текущий пользователь не является администратором ИБ.
	// См. использование в процедуре ЗавершитьРаботуПользователей().
	ИначеЕсли ЗначениеПараметраЗапуска = Врег("ЗавершитьРаботуПользователей") Тогда
		
		// поскольку блокировка еще не установлена, то при входе в систему
		// для данного пользователя был подключен обработчик ожидания завершения работы.
		// Отключаем его. Так как для этого пользователя подключается специализированный обработчики ожидания
		// "ЗавершитьРаботуПользователей", который ориентирован на то, что данный пользователь
		// должен быть отключен последним.
		ОтключитьОбработчикОжидания("КонтрольРежимаЗавершенияРаботыПользователей");
		
		Если НЕ СоединенияИБ.УстановитьБлокировкуСоединений() Тогда
			ТекстСообщения = НСтр("ru = 'Параметр запуска ЗавершитьРаботуПользователей не отработан. Нет прав на администрирование информационной базы.'");
			Предупреждение(ТекстСообщения);
			Возврат Ложь;
		КонецЕсли;
		
		ПодключитьОбработчикОжидания("ЗавершитьРаботуПользователей", 60);
		ЗавершитьРаботуПользователей();
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти
