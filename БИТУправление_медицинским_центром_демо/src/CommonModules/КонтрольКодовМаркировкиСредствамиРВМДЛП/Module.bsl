
#Область ПрограммныйИнтерфейс

#Область ПодключениеПроверкиКМ

// Возвращает параметры, необходимые для подключения механизма проверки КМ средствами РВ к форме объекта.
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

// Проверяет возможность подключения проверки КМ средствами РВ.
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
	КлючГруппыНастроекКонтроляКМ = ГруппыНастроекКонтроляКМ.ПараметрыКонтроляСредствамиРВ;
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

// Выполняет подключение механизма проверки КМ средствами РВ к форме объекта.
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
	
	Результат = КонтрольКодовМаркировкиМДЛППереопределяемый.ВключенКонтрольКМСредствамиРВДляДокумента(ДокументСсылка, СтандартнаяОбработка);
	Если Не ЗначениеЗаполнено(Результат) Тогда
		Результат = Истина;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция РазрешеноИспользованиеНастройкиКонтроляКМ() Экспорт
	
	СтандартнаяОбработка = Истина;
	
	Результат = КонтрольКодовМаркировкиМДЛППереопределяемый.РазрешеноИспользованиеНастройкиКонтроляКМСредствамиРВ(СтандартнаяОбработка);
	Если Не ЗначениеЗаполнено(Результат) Тогда
		Результат = КонтрольКодовМаркировкиМДЛП.НовыйРезультатПроверкиНастроекКонтроляКМ(Истина);
	КонецЕсли;
	
	Если Результат.Успех И СтандартнаяОбработка Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		
		Запрос = Новый Запрос("
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИСТИНА
		|ИЗ
		|	Справочник.РегистраторыМДЛП КАК Регистраторы
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|		Справочник.МестаДеятельностиМДЛП КАК МестаДеятельностиМДЛП
		|	ПО
		|		МестаДеятельностиМДЛП.Ссылка = Регистраторы.Владелец
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|		Справочник.ОрганизацииМДЛП КАК ОрганизацииМДЛП
		|	ПО
		|		ОрганизацииМДЛП.Ссылка = МестаДеятельностиМДЛП.Организация
		|	
		|ГДЕ
		|	ОрганизацииМДЛП.СобственнаяОрганизация
		|	И НЕ ОрганизацииМДЛП.ПометкаУдаления
		|	И МестаДеятельностиМДЛП.ВестиУчетВЭтойИБ
		|	И Не Регистраторы.ПометкаУдаления
		|	И Регистраторы.Активно
		|");
		
		Результат.Успех = Не Запрос.Выполнить().Пустой();
		
		Если Не Результат.Успех Тогда
			Результат.Причина = НСтр("ru = 'Нет доступных регистраторов выбытия для выполнения проверки кодов маркировки.'");
		КонецЕсли;
	
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура СоздатьРеквизитыИЭлементыКонтроляКМ(Форма)
	
	// Добавление реквизитов и команд
	
	ДобавляемыеРеквизиты = Новый Массив;
	
	ГруппыНастроекКонтроляКМ = КонтрольКодовМаркировкиМДЛПКлиентСервер.ГруппыНастроекКонтроляКМ();
	ПодключаемыеСвойства = КонтрольКодовМаркировкиМДЛПКлиентСервер.ПодключаемыеСвойстваФормыДляКонтроляКМ(ГруппыНастроекКонтроляКМ.ПараметрыКонтроляСредствамиРВ);
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
	ПодключаемыеСвойства = КонтрольКодовМаркировкиМДЛПКлиентСервер.ПодключаемыеСвойстваФормыДляКонтроляКМ(ГруппыНастроекКонтроляКМ.ПараметрыКонтроляСредствамиРВ);
	ПодключаемыеРеквизиты = ПодключаемыеСвойства.Реквизиты;
	
	Форма[ПодключаемыеРеквизиты.МеханизмПроверкиКМПодключен.Имя]    = Истина;
	Форма[ПодключаемыеРеквизиты.МеханизмПроверкиКМИспользуется.Имя] = РезультатПроверкиРазрешений.РазрешеноИспользование;
	Форма[ПодключаемыеРеквизиты.КлючГруппыНастроекКонтроляКМ.Имя]   = ГруппыНастроекКонтроляКМ.ПараметрыКонтроляСредствамиРВ;
	Форма[ПодключаемыеРеквизиты.КонтрольВыполнятьВФормеВыборочногоКонтроляКМ.Имя] = ПараметрыПодключенияПроверкиКМ.КонтрольВыполнятьВФормеВыборочногоКонтроляКМ;
	
КонецПроцедуры

#КонецОбласти
