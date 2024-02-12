
#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИнтеграцияМДЛППереопределяемый.НастроитьПодключаемоеОборудование(ЭтотОбъект);
	
	Организация       = Параметры.Организация;
	МестоДеятельности = Параметры.МестоДеятельности;
	
	ЗаполнитьТоварыИзПараметровФормы(Параметры.Товары);
	
	ПараметрыУказанияСерий = ГосударственныеИнформационныеСистемыПереопределяемый.ПараметрыУказанияСерийФормыОбъекта(ЭтотОбъект, Обработки.РеестрРешенийОВводеЛПВГражданскийОборот);
	
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьПараметрыВыбораНоменклатуры(ЭтотОбъект);
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект, Элементы.ТоварыСерия.Имя);
	
	ЗапуститьПолучениеДанныхРеестраПриОткрытии = Товары.Количество() > 0;
	
	Элементы.ТоварыСерия.Видимость = ИнтеграцияМДЛП.ИспользоватьСерииНоменклатуры();
	
	СобытияФормМДЛППереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ПодключаемоеОборудование.СканерыШтрихкода
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование.УстройстваВвода") Тогда
		ПоддерживаемыеТипыПодключаемогоОборудования = "СканерШтрихкода";
		МодульМенеджерОборудованияКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("МенеджерОборудованияКлиент");
		МодульМенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, ПоддерживаемыеТипыПодключаемогоОборудования);
	КонецЕсли;
	// Конец ПодключаемоеОборудование.СканерыШтрихкода
	
	Элементы.ТоварыОтображатьВсеРешения.Пометка = Не ПоказыватьВсеРешения;
	
	Если ЗапуститьПолучениеДанныхРеестраПриОткрытии Тогда
		ПолучитьРеестрРешенийВводаЛПВОборот();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() И Не ТолькоПросмотр Тогда
		Если ИмяСобытия = "ScanData" Тогда
			
			ОбработатьШтрихкоды(ИнтеграцияМДЛПКлиент.ПреобразоватьДанныеСоСканераВМассив(Параметр));
			
		КонецЕсли;
	КонецЕсли;
	
	СобытияФормМДЛПКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	// ПодключаемоеОборудование
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование") Тогда
		МодульМенеджерОборудованияКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("МенеджерОборудованияКлиент");
		МодульМенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаПолучитьРеестрРешенийВводаЛПВОборот(Команда)
	
	ПолучитьРеестрРешенийВводаЛПВОборот();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтменитьПолучениеРеестраРешенийВводаЛПВОборот(Команда)
	
	ОтменитьПолучениеРеестраРешенийОВводеЛПВОборот();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьВсеРешения(Команда)
	
	ПоказыватьВсеРешения = Не ПоказыватьВсеРешения;
	Элементы.ТоварыОтображатьВсеРешения.Пометка = Не ПоказыватьВсеРешения;
	
	УстановитьОтборРешений(ИдентификаторТекущейСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанныеИзТСД(Команда)
	
	ОчиститьСообщения();
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование.ТерминалыСбораДанных") Тогда
		МодульОборудованиеТерминалыСбораДанныхКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОборудованиеТерминалыСбораДанныхКлиент");
		МодульОборудованиеТерминалыСбораДанныхКлиент.НачатьЗагрузкуДанныеИзТСД(
			Новый ОписаниеОповещения("ЗагрузитьИзТСДЗавершение", ЭтотОбъект),
			УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомендаОтменитьПолучениеИнформацииОбУпаковках(Команда)
	
	ОтменитьПолучениеИнформациюОбУпаковках();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормМДЛПКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ТоварыПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	УстановитьОтборРешений(?(ТекущиеДанные <> Неопределено, ТекущиеДанные.ИдентификаторСтроки, "ВсеСкрыть"));
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		ТекущиеДанные = Элемент.ТекущиеДанные;
		ТекущиеДанные.ИдентификаторСтроки = Строка(Новый УникальныйИдентификатор);
		УстановитьОтборРешений(ТекущиеДанные.ИдентификаторСтроки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПередУдалением(Элемент, Отказ)
	
	Для Каждого ВыделеннаяСтрока Из Элемент.ВыделенныеСтроки Цикл
		
		ТекущаяСтрока = Товары.НайтиПоИдентификатору(ВыделеннаяСтрока);
		Отбор = Новый Структура("ИдентификаторСтроки", ТекущаяСтрока.ИдентификаторСтроки);
		
		НайденныеСтроки = РеестрРешенийВводаЛПВОборот.НайтиСтроки(Отбор);
		Для Каждого СтрокаТЧ Из НайденныеСтроки Цикл
			РеестрРешенийВводаЛПВОборот.Удалить(СтрокаТЧ);
		КонецЦикла;
		Товары.Удалить(ТекущаяСтрока);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	СобытияФормМДЛПКлиентПереопределяемый.НачалоВыбораНоменклатуры(ЭтотОбъект, ТекущаяСтрока, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ПараметрыЗаполнения = ИнтеграцияМДЛПКлиентСервер.ПараметрыЗаполненияТабличнойЧасти();
	ПараметрыЗаполнения.ОбработатьУпаковки = Ложь;
	ПараметрыЗаполнения.ПроверитьСериюРассчитатьСтатус = Истина;
	ПараметрыЗаполнения.ПараметрыУказанияСерий = ПараметрыУказанияСерий;
	
	СобытияФормМДЛПКлиентПереопределяемый.ПриИзмененииНоменклатуры(ЭтотОбъект, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСерияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	СобытияФормМДЛПКлиентПереопределяемый.НачалоВыбораСерии(ЭтотОбъект, ТекущаяСтрока, ПараметрыУказанияСерий, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСерияПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ПараметрыЗаполнения = ИнтеграцияМДЛПКлиентСервер.ПараметрыЗаполненияТабличнойЧасти();
	ПараметрыЗаполнения.ОбработатьУпаковки = Ложь;
	ПараметрыЗаполнения.ПараметрыУказанияСерий = ПараметрыУказанияСерий;
	
	СобытияФормМДЛПКлиентПереопределяемый.ПриИзмененииСерии(ЭтотОбъект, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовФормы

#Область СлужебныеПроцедурыИФункции

#Область ЗаполнениеРеестраРешенийВводаЛПВОборот

&НаКлиенте
Процедура ПолучитьРеестрРешенийВводаЛПВОборот()
	
	ОчиститьСообщения();
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СписокФильтров = Новый Массив;
	Для Каждого ТекущиеДанные Из Товары Цикл
		
		Если Не ЗначениеЗаполнено(ТекущиеДанные.GTIN) Или Не ЗначениеЗаполнено(ТекущиеДанные.НомерСерии) Тогда
			ТекстСообщения = НСтр("ru = 'В выделенных строках не заполнен GTIN или Номер серии.'");
			ПоказатьПредупреждение(, ТекстСообщения);
			Возврат;
		КонецЕсли;
		
		СписокФильтров.Добавить(Новый Структура("gtin, НомерСерии", ТекущиеДанные.GTIN, ТекущиеДанные.НомерСерии));
		
	КонецЦикла;
	
	Если СписокФильтров.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Нет данных для получения информации из реестра решений.'");
		ПоказатьПредупреждение(, ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(МестоДеятельности) Тогда
		ПараметрыПодключения = ТранспортМДЛПАПИВызовСервера.ПараметрыПодключения(Организация, МестоДеятельности);
	Иначе
		ПараметрыПодключения = ТранспортМДЛПАПИВызовСервера.ПараметрыПодключения(Организация);
	КонецЕсли;
	
	ОтменитьПолучениеРеестраРешенийОВводеЛПВОборот();
	
	ОтобразитьВыполнениеПолученияРеестраРешенийОВводеЛПВОборот("Начало");
	
	ПараметрыМетода = ТранспортМДЛПАПИКлиентСервер.ПараметрыПолученияРешенийОВводеЛПВГражданскийОборотПоСпискуЛП();
	ПараметрыМетода.СписокФильтров = СписокФильтров;
	
	ПараметрыЗапуска = ТранспортМДЛПАПИКлиент.ПараметрыЗапускаМетодовАПИВДлительнойОперации(ЭтотОбъект);
	ПараметрыЗапуска.ОповещениеПередОжиданиемДлительнойОперации = Новый ОписаниеОповещения("ПередОжиданиемПолученияРеестраРешенийОВводеЛПВОборот", ЭтотОбъект);
	
	Оповещение = Новый ОписаниеОповещения("ОбработатьРезультатПолученияРеестраРешенийОВводеЛПВОборот", ЭтотОбъект);
	ТранспортМДЛПАПИКлиент.ВыполнитьАвторизованныйЗапросВДлительнойОперации(
		ПараметрыПодключения,
		Оповещение,
		"ПолучитьРешенияОВводеЛПВГражданскийОборотПоСпискуЛП",
		ПараметрыМетода,
		ПараметрыЗапуска);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьРезультатПолученияРеестраРешенийОВводеЛПВОборот(Результат, Контекст) Экспорт
	
	ИдентификаторЗаданияПолученияРеестраРешений = Неопределено;
	Если Не Открыта() Тогда
		Возврат;
	КонецЕсли;
	
	ОтобразитьВыполнениеПолученияРеестраРешенийОВводеЛПВОборот("Конец");
	
	АдресРезультатаМетодаАПИ = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Результат, "АдресРезультатаМетодаАПИ");
	Если АдресРезультатаМетодаАПИ <> Неопределено Тогда
		ОбработатьРезультатПолученияРеестраРешенийОВводеЛПВОборотНаСервере(АдресРезультатаМетодаАПИ);
		УстановитьОтборРешений(?(Элементы.Товары.ТекущиеДанные <> Неопределено, Элементы.Товары.ТекущиеДанные.ИдентификаторСтроки, Неопределено));
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		ВызватьИсключение Результат.ОписаниеОшибки;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьРезультатПолученияРеестраРешенийОВводеЛПВОборотНаСервере(Знач АдресРезультата)
	
	Результат = ПолучитьИзВременногоХранилища(АдресРезультата);
	Данные = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Результат, "Данные");
	Если ЗначениеЗаполнено(Данные) Тогда
		ЗаполнитьРеестрРешенийВводаЛПВОборот(Данные);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеестрРешенийВводаЛПВОборот(Данные)
	
	СоответствиеПолей = Новый Структура;
	СоответствиеПолей.Вставить("GTIN"                          , Новый Структура("Имя", "gtin"));
	СоответствиеПолей.Вставить("НомерСерии"                    , Новый Структура("Имя", "batch"));
	СоответствиеПолей.Вставить("РазмерСерии"                   , Новый Структура("Имя", "batch_capacity"));
	СоответствиеПолей.Вставить("ИдентификаторЗаписиРЗН"        , Новый Структура("Имя", "rzn_reg_num"));
	СоответствиеПолей.Вставить("НомерРазрешенияНаВводВОборот"  , Новый Структура("Имя", "decision_num"));
	СоответствиеПолей.Вставить("ДатаЗаписиАИСРЗН"              , Новый Структура("Имя", "date"));
	СоответствиеПолей.Вставить("ДатаРегистрацииВМДЛП"          , Новый Структура("Имя", "op_exec_date"));
	СоответствиеПолей.Вставить("КоличествоВведенныхSGTINВСерии", Новый Структура("Имя", "in_circulation_count"));
	СоответствиеПолей.Вставить("СтатусРешения"                 , Новый Структура("Имя", "status"));
	СоответствиеПолей.Вставить("ИНН"                           , Новый Структура("Имя", "inn"));
	
	РеестрРешенийВводаЛПВОборот.Очистить();
	
	Для Каждого ДанныеПоGTIN Из Данные Цикл
		Для Каждого ДанныеПоНомеруСерии Из ДанныеПоGTIN.Значение Цикл
			
			НайденныеСтроки = Товары.НайтиСтроки(Новый Структура("GTIN, НомерСерии", ДанныеПоGTIN.Ключ, ДанныеПоНомеруСерии.Ключ));
			Если НайденныеСтроки.Количество() = 0 Тогда
				Продолжить;
			КонецЕсли;
			
			ИдентификаторСтроки = НайденныеСтроки[0].ИдентификаторСтроки;
			Если Не ЗначениеЗаполнено(ИдентификаторСтроки) Тогда
				ИдентификаторСтроки = Строка(Новый УникальныйИдентификатор);
				НайденныеСтроки[0].ИдентификаторСтроки = ИдентификаторСтроки;
			КонецЕсли;
			
			Для Каждого ДетальныеДанные Из ДанныеПоНомеруСерии.Значение Цикл
				НоваяСтрока = РеестрРешенийВводаЛПВОборот.Добавить();
				НоваяСтрока.ИдентификаторСтроки = ИдентификаторСтроки;
				Для Каждого КлючЗначение Из СоответствиеПолей Цикл
					НоваяСтрока[КлючЗначение.Ключ] = ДетальныеДанные[КлючЗначение.Значение.Имя];
				КонецЦикла;
			КонецЦикла;
			
		КонецЦикла;
	КонецЦикла;
	
	РеестрРешенийВводаЛПВОборот.Сортировать("ДатаЗаписиАИСРЗН");
	
КонецПроцедуры

&НаКлиенте
Процедура ПередОжиданиемПолученияРеестраРешенийОВводеЛПВОборот(ДлительнаяОперация, ДополнительныеПараметры) Экспорт
	
	ИдентификаторЗаданияПолученияРеестраРешений = ДлительнаяОперация.ИдентификаторЗадания;
	
КонецПроцедуры

&НаСервере
Процедура ОтменитьПолучениеРеестраРешенийОВводеЛПВОборот()
	
	Если ЗначениеЗаполнено(ИдентификаторЗаданияПолученияРеестраРешений) Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗаданияПолученияРеестраРешений);
		ИдентификаторЗаданияПолученияРеестраРешений = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьВыполнениеПолученияРеестраРешенийОВводеЛПВОборот(Состояние)
	
	Если Состояние = "Начало" Тогда
		
		Элементы.КомандаОтменитьПолучениеРеестраРешенийВводаЛПВОборот.Видимость = Истина;
		
		Элементы.Товары.Доступность = Ложь;
		
		ТекстОповещения = НСтр("ru = 'Получение информации'");
		ПояснениеОповещения = НСтр("ru = 'Начало получения реестра решений о вводе ЛП в гражданский оборот'");
		ПоказатьОповещениеПользователя(ТекстОповещения,, ПояснениеОповещения, БиблиотекаКартинок.Информация32);
		
	Иначе
		
		Элементы.КомандаОтменитьПолучениеРеестраРешенийВводаЛПВОборот.Видимость = Ложь;
		
		Элементы.Товары.Доступность = Истина;
		
		ТекстОповещения = НСтр("ru = 'Получение информации'");
		ПояснениеОповещения = НСтр("ru = 'Получение реестра решений о вводе ЛП в гражданский оборот завершено'");
		ПоказатьОповещениеПользователя(ТекстОповещения,, ПояснениеОповещения, БиблиотекаКартинок.Информация32);
		
	КонецЕсли;
	
	ОбновитьИнтерфейс();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработкаШтрихкодов

&НаКлиенте
Процедура ЗагрузитьИзТСДЗавершение(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыполнения.Результат Тогда
		ОбработатьШтрихкоды(РезультатВыполнения.ТаблицаТоваров);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьШтрихкоды(ДанныеШтрихкодов)
	
	ОчиститьСообщения();
	
	ШтрихкодыПоТипам = ИнтеграцияМДЛПКлиентСервер.РазобратьШтрихкодыПоТипам(ДанныеШтрихкодов);
	
	Для Каждого ДанныеУпаковки Из ШтрихкодыПоТипам.НомераТранспортныхУпаковок Цикл
		Текст = НСтр("ru = 'Групповая упаковка %1 не может быть обработана. Отсканируйте штрихкод потребительской упаковки.'");
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Текст, ДанныеУпаковки.SSCC);
		ОбщегоНазначенияКлиент.СообщитьПользователю(Текст);
	КонецЦикла;
	
	Для Каждого ДанныеУпаковки Из ШтрихкодыПоТипам.НеизвестныеШтрихкоды Цикл
		Текст = НСтр("ru = 'Неизвестный штрихкод %1 не может быть обработан. Отсканируйте штрихкод потребительской упаковки.'");
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Текст, ДанныеУпаковки.Штрихкод);
		ОбщегоНазначенияКлиент.СообщитьПользователю(Текст);
	КонецЦикла;
	
	НомераУпаковок = Новый Массив;
	Для Каждого ДанныеУпаковки Из ШтрихкодыПоТипам.НомераКиЗ Цикл
		НомераУпаковок.Добавить(ДанныеУпаковки.SGTIN);
	КонецЦикла;
	
	ЗапроситьИнформациюОбУпаковках(НомераУпаковок);
	
КонецПроцедуры

#КонецОбласти

#Область ЗапросИнформацииОбУпаковках

&НаКлиенте
Процедура ЗапроситьИнформациюОбУпаковках(НомераУпаковок)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Если НомераУпаковок.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Нет данных для получения информации об упаковках.'");
		ПоказатьПредупреждение(, ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(МестоДеятельности) Тогда
		ПараметрыПодключения = ТранспортМДЛПАПИВызовСервера.ПараметрыПодключения(Организация, МестоДеятельности);
	Иначе
		ПараметрыПодключения = ТранспортМДЛПАПИВызовСервера.ПараметрыПодключения(Организация);
	КонецЕсли;
	
	ОтменитьПолучениеИнформациюОбУпаковках();
	
	ОтобразитьВыполнениеПолученияИнформацииОбУпаковках("Начало");
	
	ПараметрыМетода = ТранспортМДЛПАПИКлиентСервер.ПараметрыПолученияИнформацииОПотребительскихУпаковках(Строка(УникальныйИдентификатор));
	ПараметрыМетода.НомераУпаковок = НомераУпаковок;
	ПараметрыМетода.ТипИсточникаИнформацииОбУпаковках = ПредопределенноеЗначение("Перечисление.ТипыИсточниковИнформацииОбУпаковкахМДЛП.Публичный");
	
	ПараметрыЗапуска = ТранспортМДЛПАПИКлиент.ПараметрыЗапускаМетодовАПИВДлительнойОперации(ЭтотОбъект);
	ПараметрыЗапуска.ОповещениеПередОжиданиемДлительнойОперации = Новый ОписаниеОповещения("ПередОжиданиемПолученияИнформацииОбУпаковках", ЭтотОбъект);
	
	Оповещение = Новый ОписаниеОповещения("ОбработатьПолучениеПотребительскихУпаковок", ЭтотОбъект);
	ТранспортМДЛПАПИКлиент.НачатьПолучениеИнформацииОКИЗ(ПараметрыПодключения, Оповещение, ПараметрыМетода, ПараметрыЗапуска);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьПолучениеПотребительскихУпаковок(Результат, Контекст) Экспорт
	
	ИдентификаторЗаданияПолученияИнформацииОбУпаковках = Неопределено;
	Если Не Открыта() Тогда
		Возврат;
	КонецЕсли;
	
	ОтобразитьВыполнениеПолученияИнформацииОбУпаковках("Конец");
	
	АдресРезультатаМетодаАПИ = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Результат, "АдресРезультатаМетодаАПИ");
	Если АдресРезультатаМетодаАПИ <> Неопределено Тогда
		ОбработатьПолучениеПотребительскихУпаковокНаСервере(АдресРезультатаМетодаАПИ);
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		ВызватьИсключение Результат.ОписаниеОшибки;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьПолучениеПотребительскихУпаковокНаСервере(Знач АдресРезультата)
	
	Результат = ПолучитьИзВременногоХранилища(АдресРезультата);
	Данные = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Результат, "Данные");
	Если ЗначениеЗаполнено(Данные) Тогда
		
		ЗаполнитьДанныеОПотребительскихУпаковках(Данные);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеОПотребительскихУпаковках(Данные)
	
	Для Каждого КлючЗначение Из Данные Цикл
		
		ДанныеУпаковки = КлючЗначение.Значение;
		ЕстьИнформация = ДанныеУпаковки["error_code"] = Неопределено;
		Если ЕстьИнформация Тогда
			
			Если ДанныеУпаковки["gtin"] = Неопределено Тогда
				GTIN = Лев(14, КлючЗначение.Ключ);
			Иначе
				GTIN = ДанныеУпаковки["gtin"];
			КонецЕсли;
			
			Отбор = Новый Структура;
			Отбор.Вставить("GTIN"      , GTIN);
			Отбор.Вставить("НомерСерии", Строка(ДанныеУпаковки["batch"]));
			Отбор.Вставить("ГоденДо"   , ТранспортМДЛПАПИКлиентСервер.СтрокаВДату(ДанныеУпаковки["expiration_date"]));
			
			НайденныеСтроки = Товары.НайтиСтроки(Отбор);
			Если НайденныеСтроки.Количество() = 0 Тогда
				
				СтрокаТовара = Товары.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаТовара, Отбор);
				
				ПараметрыЗаполнения = ИнтеграцияМДЛПКлиентСервер.ПараметрыЗаполненияТабличнойЧасти();
				ПараметрыЗаполнения.ОбработатьУпаковки = Ложь;
				ПараметрыЗаполнения.ПроверитьСериюРассчитатьСтатус = Истина;
				ПараметрыЗаполнения.ПараметрыУказанияСерий = ПараметрыУказанияСерий;
				ИнтеграцияМДЛППереопределяемый.ПриИзмененииПараметровНоменклатуры(ЭтотОбъект, СтрокаТовара, ПараметрыЗаполнения);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередОжиданиемПолученияИнформацииОбУпаковках(ДлительнаяОперация, ДополнительныеПараметры) Экспорт
	
	ИдентификаторЗаданияПолученияИнформацииОбУпаковках = ДлительнаяОперация.ИдентификаторЗадания;
	
КонецПроцедуры

&НаСервере
Процедура ОтменитьПолучениеИнформациюОбУпаковках()
	
	Если ЗначениеЗаполнено(ИдентификаторЗаданияПолученияИнформацииОбУпаковках) Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗаданияПолученияИнформацииОбУпаковках);
		ИдентификаторЗаданияПолученияИнформацииОбУпаковках = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьВыполнениеПолученияИнформацииОбУпаковках(Состояние)
	
	Если Состояние = "Начало" Тогда
		
		Элементы.КомендаОтменитьПолучениеИнформацииОбУпаковках.Видимость = Истина;
		
		Элементы.КомандаПолучитьРеестрРешенийВводаЛПВОборот.Доступность = Ложь;
		Элементы.Товары.Доступность = Ложь;
		
		ТекстОповещения = НСтр("ru = 'Получение информации'");
		ПояснениеОповещения = НСтр("ru = 'Получение информации об упаковках запущено'");
		ПоказатьОповещениеПользователя(ТекстОповещения,, ПояснениеОповещения, БиблиотекаКартинок.Информация32);
		
	Иначе
		
		Элементы.КомендаОтменитьПолучениеИнформацииОбУпаковках.Видимость = Ложь;
		
		Элементы.КомандаПолучитьРеестрРешенийВводаЛПВОборот.Доступность = Истина;
		Элементы.Товары.Доступность = Истина;
		
		ТекстОповещения = НСтр("ru = 'Получение информации'");
		ПояснениеОповещения = НСтр("ru = 'Получение информации об упаковках завершено'");
		ПоказатьОповещениеПользователя(ТекстОповещения,, ПояснениеОповещения, БиблиотекаКартинок.Информация32);
		
	КонецЕсли;
	
	ОбновитьИнтерфейс();
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьУсловноеОформлениеСерийНоменклатуры(ЭтотОбъект,
		Элементы.ТоварыСерия.Имя, "Товары.СтатусУказанияСерий", "Товары.ТипНоменклатуры");
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Элементы.РеестрРешенийВводаЛПВОборот.Имя);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Элемент.Отбор,
		"РеестрРешенийВводаЛПВОборот.ИдентификаторСтроки", Новый ПолеКомпоновкиДанных("ИдентификаторТекущейСтроки"), ВидСравненияКомпоновкиДанных.НеРавно);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияМДЛП);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборРешений(ИдентификаторСтроки)
	
	Если ИдентификаторТекущейСтроки <> ИдентификаторСтроки Тогда
		ИдентификаторТекущейСтроки = ИдентификаторСтроки;
	КонецЕсли;
	
	Если Не ПоказыватьВсеРешения Тогда
		ИнтеграцияМДЛПКлиент.УстановитьОтборСтрок(
			Элементы.РеестрРешенийВводаЛПВОборот.ОтборСтрок,
			Новый Структура("ИдентификаторСтроки", ИдентификаторТекущейСтроки));
	Иначе
		ИнтеграцияМДЛПКлиент.СнятьОтборСтрок(Элементы.РеестрРешенийВводаЛПВОборот.ОтборСтрок, "ИдентификаторСтроки");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТоварыИзПараметровФормы(ПараметрыТовары)
	
	Если ТипЗнч(ПараметрыТовары) <> Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
	
	Товары.Очистить();
	Для Каждого Элемент Из ПараметрыТовары Цикл
		Строка = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(Строка, Элемент);
		Строка.ИдентификаторСтроки = Строка(Новый УникальныйИдентификатор);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции
