
#Область ПрограммныйИнтерфейс

#Область ПодключениеПроверкиКМ

// Возвращает параметры, необходимые для подключения механизма проверки КМ средствами ККТ к форме объекта.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма объекта подключения механизма проверки КМ.
//
// Возвращаемое значение:
//  ВозвращаемоеЗначение - Структура - параметры, необходимые для подключения механизма проверки КМ к форме объекта.
//   * Форма - ФормаКлиентскогоПриложения - форма объекта подключения механизма проверки КМ.
//   * ДокументСсылка - ДокументСсылка - ссылка на объект, к которому подключается механизм проверки КМ.
//                                       Если объект новый - нужно указывать пустую ссылку.
//   * КонтрольВыполнятьВФормеВыборочногоКонтроляКМ - Булево - признако того, что непосредственное выполнение контроля КМ выполняется в отдельной форме,
//                                                    а не в текущей, и необходимо только подготовить данные к проверке, а не выполнять ее, например, при сканировании КМ.
//
Функция ПараметрыПодключенияПроверкиКМ(Форма = Неопределено) Экспорт
	
	Если Форма <> Неопределено
	   И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "Объект")
	   И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма.Объект, "Ссылка") Тогда
		ДокументСсылка = Форма.Объект.Ссылка;
	Иначе
		ДокументСсылка = Неопределено;
	КонецЕсли;
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("Форма"         , Форма);
	ВозвращаемоеЗначение.Вставить("ДокументСсылка", ДокументСсылка);
	ВозвращаемоеЗначение.Вставить("КонтрольВыполнятьВФормеВыборочногоКонтроляКМ", Истина);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Проверяет возможность подключения проверки КМ средствами ККТ.
//
// Параметры:
//  Параметры - Структура - см. ПараметрыПодключенияПроверкиКМ.
//
// Возвращаемое значение:
//  ВозвращаемоеЗначение - Структура - Результат проверки возможности подключения проверки КМ.
//   * РазрешеноПодключение   - Булево - Истина, если РазрешеноИспользование.
//   * РазрешеноИспользование - Булево - Истина, если насройками включено использование контроля КМ для типа документа
//                              (см. РазрешеноИспользованиеНастройкиКонтроляКМ).
//
Функция ПроверитьВозможностьПодключенияПроверкиКМ(Параметры) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура("РазрешеноПодключение, РазрешеноИспользование", Ложь, Ложь);
	
	ГруппыНастроекКонтроляКМ = КонтрольКодовМаркировкиМДЛПКлиентСервер.ГруппыНастроекКонтроляКМ();
	КлючГруппыНастроекКонтроляКМ = ГруппыНастроекКонтроляКМ.ПараметрыКонтроляСредствамиККТ;
	Операция = Параметры.ДокументСсылка.Метаданные().ПолноеИмя();
	ВключенКонтрольКМДляОперации = КонтрольКодовМаркировкиМДЛП.ВключенКонтрольКМДляОперации(КлючГруппыНастроекКонтроляКМ, Операция);
	Если Не ВключенКонтрольКМДляОперации Тогда
		Возврат ВозвращаемоеЗначение;
	КонецЕсли;
	
	ВключенКонтрольКМДляДокумента = ВключенКонтрольКМДляДокумента(Параметры.ДокументСсылка);
	Если Не ВключенКонтрольКМДляДокумента Тогда
		Возврат ВозвращаемоеЗначение;
	КонецЕсли;
	
	РезультатПроверкиРазрешений = РазрешеноИспользованиеНастройкиКонтроляКМ();
	
	ВозвращаемоеЗначение.РазрешеноПодключение   = РезультатПроверкиРазрешений.Успех;
	ВозвращаемоеЗначение.РазрешеноИспользование = РезультатПроверкиРазрешений.Успех;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Выполняет подключение механизма проверки КМ средствами ККТ к форме объекта.
// Создает на форме объекта необходимые для работы механизма реквизиты и заполняет их по умолчанию.
//
// Параметры:
//  Параметры - Структура - см. ПараметрыПодключенияПроверкиКМ.
//  РезультатПроверкиРазрешений - Структура - см. ПроверитьВозможностьПодключенияПроверкиКМ.
//
Процедура ПодключитьМеханизмПроверкиКМ(Параметры, РезультатПроверкиРазрешений) Экспорт
	
	СоздатьРеквизитыИЭлементыКонтроляКМ(Параметры.Форма);
	ЗаполнитьРеквизитыПоУмолчаниюКонтроляКМ(Параметры.Форма, Параметры, РезультатПроверкиРазрешений);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВключенКонтрольКМДляДокумента(ДокументСсылка)
	
	СтандартнаяОбработка = Истина;
	
	Результат = КонтрольКодовМаркировкиМДЛППереопределяемый.ВключенКонтрольКМСредствамиККТДляДокумента(ДокументСсылка, СтандартнаяОбработка);
	Если Не ЗначениеЗаполнено(Результат) Тогда
		Результат = Истина;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция РазрешеноИспользованиеНастройкиКонтроляКМ() Экспорт
	
	СтандартнаяОбработка = Истина;
	
	Результат = КонтрольКодовМаркировкиМДЛППереопределяемый.РазрешеноИспользованиеНастройкиКонтроляКМСредствамиККТ(СтандартнаяОбработка);
	Если Не ЗначениеЗаполнено(Результат) Тогда
		Результат = КонтрольКодовМаркировкиМДЛП.НовыйРезультатПроверкиНастроекКонтроляКМ(Истина);
	КонецЕсли;
	
	Если Результат.Успех И СтандартнаяОбработка Тогда
		
		ПодсистемаСуществует = ОбщегоНазначения.ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование");
		Если Не ПодсистемаСуществует Тогда
			Результат.Успех = Ложь;
			Результат.Причина = НСтр("ru = 'Не подключена подсистема Подключаемое оборудование.'");
			Возврат Результат;
		КонецЕсли;
		
		МодульМенеджерОборудованияВызовСервера = ОбщегоНазначения.ОбщийМодуль("МенеджерОборудованияВызовСервера");
		Если Не МодульМенеджерОборудованияВызовСервера.ИспользуетсяЧекопечатающиеУстройства() Тогда
			Результат.Успех = Ложь;
			Результат.Причина = НСтр("ru = 'Не подключена подсистема фискальных устройств подключаемого оборудования.'");
			Возврат Результат;
		КонецЕсли;
		
		ВерсияБиблиотекиБПО = МодульМенеджерОборудованияВызовСервера.ВерсияБиблиотеки();
		Если СтрНачинаетсяС(ВерсияБиблиотекиБПО, "3") И ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ВерсияБиблиотекиБПО, "3.1.1.18") < 0
		 Или СтрНачинаетсяС(ВерсияБиблиотекиБПО, "2") И ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ВерсияБиблиотекиБПО, "2.1.6.18") < 0 Тогда
			Результат.Успех = Ложь;
			Результат.Причина = НСтр("ru = 'Версия БПО ниже версии, в которой поддержан механизм контроля КМ средствами ККТ.'");
			Возврат Результат;
		КонецЕсли;
		
		МодульОборудованиеЧекопечатающиеУстройстваВызовСервера = ОбщегоНазначения.ОбщийМодуль("ОборудованиеЧекопечатающиеУстройстваВызовСервера");
		
		ФискальноеУстройствоПоддерживаетПроверкуКМ = Ложь;
		Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	ПодключаемоеОборудование.Ссылка КАК ИдентификаторУстройства
		|ИЗ
		|	Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|ГДЕ
		|	НЕ ПодключаемоеОборудование.ПометкаУдаления
		|	И ПодключаемоеОборудование.УстройствоИспользуется");
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			Если МодульОборудованиеЧекопечатающиеУстройстваВызовСервера.ФискальноеУстройствоПоддерживаетПроверкуКодовМаркировки(Выборка.ИдентификаторУстройства) Тогда
				ФискальноеУстройствоПоддерживаетПроверкуКМ = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если Не ФискальноеУстройствоПоддерживаетПроверкуКМ Тогда
			Результат.Успех = Ложь;
			Результат.Причина = НСтр("ru = 'Нет подключенных фискальных устройств, которые поддерживают механизм контроля КМ.'");
			Возврат Результат;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура СоздатьРеквизитыИЭлементыКонтроляКМ(Форма)
	
	// Добавление реквизитов и команд
	
	ДобавляемыеРеквизиты = Новый Массив;
	
	ГруппыНастроекКонтроляКМ = КонтрольКодовМаркировкиМДЛПКлиентСервер.ГруппыНастроекКонтроляКМ();
	ПодключаемыеСвойства = КонтрольКодовМаркировкиМДЛПКлиентСервер.ПодключаемыеСвойстваФормыДляКонтроляКМ(ГруппыНастроекКонтроляКМ.ПараметрыКонтроляСредствамиККТ);
	ПодключаемыеРеквизиты = ПодключаемыеСвойства.Реквизиты;
	
	Для Каждого КлючИЗначение Из ПодключаемыеРеквизиты Цикл
		
		ОписаниеРеквизита = КлючИЗначение.Значение;
		
		Если Не ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, ОписаниеРеквизита.Имя) Тогда
			ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы(
				ОписаниеРеквизита.Имя,
				ОписаниеРеквизита.ОписаниеТипа,,
				ОписаниеРеквизита.Заголовок));
		КонецЕсли;
		
	КонецЦикла;
	
	Если ДобавляемыеРеквизиты.Количество() > 0 Тогда
		Форма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьРеквизитыПоУмолчаниюКонтроляКМ(Форма, ПараметрыПодключенияПроверкиКМ, РезультатПроверкиРазрешений)
	
	ГруппыНастроекКонтроляКМ = КонтрольКодовМаркировкиМДЛПКлиентСервер.ГруппыНастроекКонтроляКМ();
	ПодключаемыеСвойства = КонтрольКодовМаркировкиМДЛПКлиентСервер.ПодключаемыеСвойстваФормыДляКонтроляКМ(ГруппыНастроекКонтроляКМ.ПараметрыКонтроляСредствамиККТ);
	ПодключаемыеРеквизиты = ПодключаемыеСвойства.Реквизиты;
	
	Форма[ПодключаемыеРеквизиты.МеханизмПроверкиКМПодключен.Имя]    = Истина;
	Форма[ПодключаемыеРеквизиты.МеханизмПроверкиКМИспользуется.Имя] = РезультатПроверкиРазрешений.РазрешеноИспользование;
	Форма[ПодключаемыеРеквизиты.КлючГруппыНастроекКонтроляКМ.Имя]   = ГруппыНастроекКонтроляКМ.ПараметрыКонтроляСредствамиККТ;
	Форма[ПодключаемыеРеквизиты.КонтрольВыполнятьВФормеВыборочногоКонтроляКМ.Имя] = ПараметрыПодключенияПроверкиКМ.КонтрольВыполнятьВФормеВыборочногоКонтроляКМ;
	
КонецПроцедуры

#КонецОбласти
