#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.СправочникСписок.РежимВыбора = ОбщегоНазначенияКлиентСервер.СвойствоОбъекта(Параметры, "РежимВыбора", Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПечатьДокументовКлиент.УстановитьЗаголовокПечатнойФормы(ЭтаФорма);

	РаботаСФормамиКлиент.УстановитьОтборСписка("Объект", ПредопределенноеЗначение("Справочник.Клиенты.ПустаяСсылка"), ТабличноеПолеКИ);
	
	Если Истина // ИспользоватьПодключаемоеОборудование Проверка на включенную ФО "Использовать ВО".
	   И МенеджерОборудованияКлиент.ОбновитьРабочееМестоКлиента() Тогда // Проверка на определенность рабочего места ВО.

		ОписаниеОшибки = "";
		
		ПоддерживаемыеТипыВО = Новый Массив();
		ПоддерживаемыеТипыВО.Добавить("СканерШтрихкода");
		ПоддерживаемыеТипыВО.Добавить("СчитывательМагнитныхКарт");
		
		ОповещенияПриПодключении = Новый ОписаниеОповещения("ПодключитьОборудованиеЗавершение", ЭтотОбъект);    
		МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПоТипу(ОповещенияПриПодключении, УникальныйИдентификатор, ПоддерживаемыеТипыВО);

	КонецЕсли;
	
	РаботаСДиалогамиКлиент.СкрытьПоказатьАрхивные(Элементы.ФормаСкрытьПоказатьАрхивные, СправочникСписок, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	// МеханизмВнешнегоОборудования
	ПоддерживаемыеТипыВО = Новый Массив();
	ПоддерживаемыеТипыВО.Добавить("СканерШтрихкода");
	ПоддерживаемыеТипыВО.Добавить("СчитывательМагнитныхКарт");
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПоТипу(Неопределено, УникальныйИдентификатор, ПоддерживаемыеТипыВО);
	// Конец МеханизмВнешнегоОборудования
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Клиенты") Тогда
		
		Если Элементы.СправочникСписок.РежимВыбора Тогда
			ОповеститьОВыборе(ВыбранноеЗначение);
		Иначе
			Элементы.СправочникСписок.ТекущаяСтрока = ВыбранноеЗначение;
			Состояние(НСтр("ru='Открытие'"));
			ПоказатьЗначение(, ВыбранноеЗначение);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ScanData" Тогда
		Если ВводДоступен() Тогда
			ТипШК = Неопределено;
			РаботаСТорговымОборудованиемКлиент.ОбработатьСобытиеСШКФормы(ЭтаФорма, Параметр, ТипШК);
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "TracksData" Тогда
		Если ВводДоступен() Тогда
			КодКарты = Неопределено;
			СМК = Неопределено;
			РаботаСТорговымОборудованиемКлиент.ОбработатьСобытиеСМК(ЭтаФорма,  Параметр[0], СМК, Неопределено, Неопределено);
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "ОтказЗаписиКлиентаДубль" Тогда
		Элементы.СправочникСписок.ТекущаяСтрока = Параметр;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.СправочникСписок.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		РаботаСФормамиКлиент.УстановитьОтборСписка("Объект", ТекущиеДанные.Ссылка, ТабличноеПолеКИ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТабличноеПолеКИПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция осуществляет обработку считывания штрих-кода клиенты
//
// Параметры:
//  Клиент   - <СправочникСсылка.Клиенты>
//                 - клиент, штрих-код которой был отсканирован.
//
//  СШК            - <Строка>
//                 - Идентификатор сканера штрих-кода, с которым связано данное
//                   событие.
//
// Возвращаемое значение:
//  <Булево>       - Данная ситуация обработана.
//
&НаКлиенте
Функция СШККлиент(Клиент, СШК) Экспорт

	Элементы.СправочникСписок.ТекущаяСтрока = Клиент;	
	
	Возврат Истина;
	
КонецФункции

// Функция осуществляет обработку считывания штрихового кода, который не был
// зарегистрирован.
//
// Параметры:
//  Штрихкод - <Строка>
//           - Считанный код.
//
//  ТипКода  - <ПланыВидовХарактеристикСсылка.ТипыШтрихкодов>
//           - Тип штрихкода. Пустая ссылка в случае, если тип определить не
//             представляется возможным.
//
//  СШК      - <Строка>
//           - Идентификатор сканера штрих-кода, с которым связано данное
//             событие.
//
// Возвращаемое значение:
//  <Булево> - Данная ситуация обработана.
//
&НаКлиенте
Функция СШКНеизвестныйКод(Штрихкод, ТипКода, СШК) Экспорт
	
	ПоказатьПредупреждение(,НСтр("ru = 'Клиента с указанным штрихкодом не существует!'"));
	Возврат Истина;
	
КонецФункции // СШКНеизвестныйКод()

&НаКлиенте
Функция СМКНеизвестныйКод(Код, СМК) Экспорт

	Результат = Ложь;

КонецФункции // СМКНеизвестныйКод()

&НаКлиенте
Процедура ПодключитьОборудованиеЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Если Не РезультатВыполнения.Результат Тогда
		ТекстСообщения = НСтр( "ru = 'При подключении оборудования произошла ошибка:
				|""%ОписаниеОшибки%"".'" );
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%" , РезультатВыполнения.ОписаниеОшибки);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоместитьВАрхив(Команда)

	РаботаСДиалогамиКлиент.ПоместитьВАрхив(Элементы.СправочникСписок.ВыделенныеСтроки);
	
	Элементы.СправочникСписок.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьПоказатьАрхивные(Команда)

	РаботаСДиалогамиКлиент.СкрытьПоказатьАрхивные(Элементы.ФормаСкрытьПоказатьАрхивные, СправочникСписок);
	
КонецПроцедуры

#КонецОбласти