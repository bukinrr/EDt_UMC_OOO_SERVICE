#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		ВызватьИсключение НСтр("ru = 'Настройка параметров серверной ИБ доступна только в клиент-серверном режиме работы.'");
		Возврат;
	КонецЕсли;
		
	ПараметрыАдминистрирования = СоединенияИБ.ПолучитьПараметрыАдминистрированияИБ();
	
	ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(
		ПараметрыАдминистрирования.ИмяАдминистратораИБ);
	Если ПользовательИБ <> Неопределено Тогда
		ИдентификаторАдминистратораИБ = ПользовательИБ.УникальныйИдентификатор;
	КонецЕсли;
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		НеразделенныйАдминистраторИБ = Строка(ИдентификаторАдминистратораИБ);
		СписокВыбора = Элементы.НеразделенныйАдминистраторИБ.СписокВыбора;
		СписокВыбора.Очистить();
		
	Иначе
		АдминистраторИБ	= Справочники.Пользователи.НайтиПоРеквизиту("ИдентификаторПользователяИБ", ИдентификаторАдминистратораИБ);
	КонецЕсли;
	ПарольАдминистратораИБ		  = ПараметрыАдминистрирования.ПарольАдминистратораИБ;
	
	ИмяАдминистратораКластера	  = ПараметрыАдминистрирования.ИмяАдминистратораКластера;
	ПарольАдминистратораКластера  = ПараметрыАдминистрирования.ПарольАдминистратораКластера;
	ПортАгентаСервера			  = ПараметрыАдминистрирования.ПортАгентаСервера;
	ПортКластераСерверов		  = ПараметрыАдминистрирования.ПортКластераСерверов;
	
	НестандартныеПорты			  = ПортКластераСерверов <> 0 ИЛИ ПортАгентаСервера <> 0;
	КластерТребуетАвторизации	  = НЕ ПустаяСтрока(ИмяАдминистратораКластера);
		
	Элементы.ГруппаПорты.Доступность = НестандартныеПорты;
	Элементы.ГруппаАвторизацияКластера.Доступность = КластерТребуетАвторизации;
	
КонецПроцедуры

Функция ПолучитьАдминистратораИБ()
	Возврат Неопределено;
КонецФункции

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Если ПустаяСтрока(НеразделенныйАдминистраторИБ) Тогда
			Возврат;
		КонецЕсли;
		ИмяПоля = "НеразделенныйАдминистраторИБ";
	Иначе
		Если Не ЗначениеЗаполнено(АдминистраторИБ) Тогда
			Возврат;
		КонецЕсли;
		ИмяПоля = "АдминистраторИБ";
	КонецЕсли;
	ПользовательИБ = ПолучитьАдминистратораИБ();
	Если ПользовательИБ = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Указанный пользователь не имеет доступа к информационной базе.'"),,
			ИмяПоля,,Отказ);
		Возврат;
	КонецЕсли;
	Если Не Пользователи.ЭтоПолноправныйПользователь(ПользовательИБ, Истина) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'У пользователя нет административных прав.'"),,
			ИмяПоля,,Отказ);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура Записать(Команда)
	
	ОчиститьСообщения();
	Если Не СохранитьПараметрыПодключения() Тогда
		Возврат;
	КонецЕсли;							
	
	Оповестить("Запись_ПараметрыАдминистрированияИБ");
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КластерТребуетАвторизацииПриИзменении(Элемент)
	
	УстановитьСостояниеПолей()
	
КонецПроцедуры

&НаКлиенте
Процедура НестандартныеПортыПриИзменении(Элемент)
	
	УстановитьСостояниеПолей();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьСостояниеПолей()
	
	Элементы.ГруппаПорты.Доступность = НестандартныеПорты;
	Элементы.ГруппаАвторизацияКластера.Доступность = КластерТребуетАвторизации;
	
КонецПроцедуры

&НаСервере
Функция СохранитьПараметрыПодключения()
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат Ложь;	
	КонецЕсли;
		
	ПараметрыАдминистрирования = СоединенияИБ.ПолучитьПараметрыАдминистрированияИБ();
		
	ПользовательИБ = ПолучитьАдминистратораИБ();
	Если ПользовательИБ <> Неопределено Тогда
		ИмяАдминистратораИБ = ПользовательИБ.Имя;
	Иначе	
		ИмяАдминистратораИБ = "";
	КонецЕсли;
	ПараметрыАдминистрирования.ИмяАдминистратораИБ = ИмяАдминистратораИБ;
	ПараметрыАдминистрирования.ПарольАдминистратораИБ = ПарольАдминистратораИБ;
	
	Если КластерТребуетАвторизации Тогда
		ПараметрыАдминистрирования.ИмяАдминистратораКластера = ИмяАдминистратораКластера;
		ПараметрыАдминистрирования.ПарольАдминистратораКластера = ПарольАдминистратораКластера;
	Иначе	
		ПараметрыАдминистрирования.ИмяАдминистратораКластера = "";
		ПараметрыАдминистрирования.ПарольАдминистратораКластера = "";
	КонецЕсли;
	
	Если НестандартныеПорты Тогда
		ПараметрыАдминистрирования.ПортКластераСерверов = ПортКластераСерверов;
		ПараметрыАдминистрирования.ПортАгентаСервера = ПортАгентаСервера;
	Иначе	
		ПараметрыАдминистрирования.ПортКластераСерверов = 0;
		ПараметрыАдминистрирования.ПортАгентаСервера = 0;
	КонецЕсли;	
	
	СоединенияИБ.ЗаписатьПараметрыАдминистрированияИБ(ПараметрыАдминистрирования);
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

