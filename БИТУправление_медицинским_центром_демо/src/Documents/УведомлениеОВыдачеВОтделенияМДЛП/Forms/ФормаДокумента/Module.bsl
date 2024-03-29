
#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения;

&НаКлиенте
Перем ОчередьОбработкиШтрихкодов;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
		МодульВерсионированиеОбъектов = ОбщегоНазначения.ОбщийМодуль("ВерсионированиеОбъектов");
		МодульВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКоманды = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКоманды");
		МодульПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияМДЛП.Инвентаризация
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтеграцияМДЛП.Инвентаризация") Тогда
		МодульИнвентаризацияМДЛП = ОбщегоНазначения.ОбщийМодуль("ИнвентаризацияМДЛП");
		МодульИнвентаризацияМДЛП.ДобавитьЭлементФормыДокументИнвентаризации(ЭтотОбъект, "ГруппаОсновное", "ОснованиеСвязать");
	КонецЕсли;
	// Конец ИнтеграцияМДЛП.Инвентаризация
	
	КонтрольКодовМаркировкиМДЛП.ПриСозданииНаСервере(ЭтотОбъект, Отказ);
	
	ИнтеграцияМДЛППереопределяемый.НастроитьПодключаемоеОборудование(ЭтотОбъект);
	
	Если Объект.Ссылка.Пустая() Тогда
		УстановитьИспользованиеРегистратораВыбытия();
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьПараметрыВыбораНоменклатуры(ЭтотОбъект);
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект, Элементы.ТоварыХарактеристика.Имя);
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект, Элементы.ТоварыСерия.Имя);
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект, Элементы.ТоварыУпаковка.Имя);
	
	ИспользоватьХарактеристики = ИнтеграцияМДЛП.ИспользоватьХарактеристикиНоменклатуры();
	Элементы.ТоварыХарактеристика.Видимость = ИспользоватьХарактеристики;
	Элементы.ТоварыСерия.Видимость          = ИнтеграцияМДЛП.ИспользоватьСерииНоменклатуры();
	Элементы.ТоварыУпаковка.Видимость       = ИнтеграцияМДЛП.ИспользоватьУпаковкиНоменклатуры();
	
	СобытияФормМДЛППереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиентСервер = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКомандыКлиентСервер");
		МодульПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	КонтрольКодовМаркировкиМДЛП.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	СобытияФормМДЛППереопределяемый.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Элементы.ТоварыОтображатьВсеНомераУпаковок.Пометка = Не ПоказыватьВсеНомераУпаковок;
	
	// ПодключаемоеОборудование.СканерыШтрихкода
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ПоддержкаОборудования.ПодключаемоеОборудование.УстройстваВвода") Тогда
		ПоддерживаемыеТипыПодключаемогоОборудования = "СканерШтрихкода";
		МодульМенеджерОборудованияКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("МенеджерОборудованияКлиент");
		МодульМенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, ПоддерживаемыеТипыПодключаемогоОборудования);
	КонецЕсли;
	// Конец ПодключаемоеОборудование.СканерыШтрихкода
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ОчередьОбработкиШтрихкодов = Новый Массив;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеСостоянияМДЛП"
	   И Параметр.Ссылка = Объект.Ссылка Тогда
		
		Прочитать();
		
		// ИнтеграцияМДЛП.Инвентаризация
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтеграцияМДЛП.Инвентаризация") Тогда
			МодульИнвентаризацияМДЛПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнвентаризацияМДЛПКлиент");
			МодульИнвентаризацияМДЛПКлиент.ОповеститьОбИзмененииУведомленияИнвентаризации(Объект);
		КонецЕсли;
		// Конец ИнтеграцияМДЛП.Инвентаризация
		
	КонецЕсли;
	
	Если ИмяСобытия = "ВыполненОбменМДЛП" Тогда
		
		ОбновитьСтатусУведомления();
		
	КонецЕсли;
	
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() И Не ТолькоПросмотр Тогда
		Если ИмяСобытия = "ScanData" Тогда
			
			// Штрихкоды помещаются в очередь, т.к. может использоваться сканер с памятью.
			ОчередьОбработкиШтрихкодов.Добавить(ИнтеграцияМДЛПКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
			ПодключитьОбработчикОжидания("ОбработатьШтрихкодыОтложенно", 0.1, Истина);
			
		КонецЕсли;
	КонецЕсли;
	
	Если ИмяСобытия = "СохранениеРезультатовВыборочногоКонтроляМДЛП" И Параметр = Объект.Ссылка Тогда
		Прочитать();
	КонецЕсли;
	
	СобытияФормМДЛПКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ОценкаПроизводительности") Тогда
			МодульОценкаПроизводительностиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОценкаПроизводительностиКлиент");
			МодульОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "Документ.УведомлениеОВыдачеВОтделенияМДЛП.Форма.ФормаДокумента.Провести");
		КонецЕсли;
	КонецЕсли;
	
	СобытияФормМДЛПКлиентПереопределяемый.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	КонтрольКодовМаркировкиМДЛП.ПриЗаписиНаСервере(ЭтотОбъект, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ГосударственныеИнформационныеСистемыПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтотОбъект, Объект.Товары);
	
	ОбновитьСтатусУведомления();
	ОбновитьСтатусыЗаполненияНомеровУпаковок(Объект);
	
	КонтрольКодовМаркировкиМДЛП.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	
	СобытияФормМДЛППереопределяемый.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("Основание", Объект.Основание);
	Оповестить("Запись_УведомлениеОВыдачеВОтделенияМДЛП", ПараметрыЗаписи, Объект.Ссылка);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияМДЛП.Инвентаризация
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтеграцияМДЛП.Инвентаризация") Тогда
		МодульИнвентаризацияМДЛПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнвентаризацияМДЛПКлиент");
		МодульИнвентаризацияМДЛПКлиент.ОповеститьОбИзмененииУведомленияИнвентаризации(Объект);
	КонецЕсли;
	// Конец ИнтеграцияМДЛП.Инвентаризация
	
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

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтатусПредставлениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ОчиститьСообщения();
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ПередатьДанные"
	   И (Объект.СостояниеПодтверждения = ПредопределенноеЗначение("Перечисление.СостоянияПодтвержденияМДЛП.ОтклоненоГИСМ")
		Или Объект.СостояниеПодтверждения = ПредопределенноеЗначение("Перечисление.СостоянияПодтвержденияМДЛП.ПринятоЧастично")) Тогда
		СтандартнаяОбработка = Ложь;
		ЗадатьВопросПередПовторнойПередачейДанных(НавигационнаяСсылкаФорматированнойСтроки);
	Иначе
		ИнтеграцияМДЛПКлиент.ОбработатьНавигационнуюСсылкуСтатуса(ЭтотОбъект, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОснованиеСвязатьНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьДокументВыбытия();
	
КонецПроцедуры

&НаКлиенте
Процедура МестоДеятельностиПриИзменении(Элемент)
	
	ПередачаСведенийЧерезСКЗКМДоИзменения = Объект.ПередачаСведенийЧерезСКЗКМ;
	
	ОбработатьИзменениеМестаДеятельности();
	ОбработатьИзменениеПризнакаПередачаСведенийЧерезСКЗКМ(ПередачаСведенийЧерезСКЗКМДоИзменения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередачаСведенийЧерезСКЗКМПриИзменении(Элемент)
	
	ОбработатьИзменениеПризнакаПередачаСведенийЧерезСКЗКМ(Не Объект.ПередачаСведенийЧерезСКЗКМ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТабличнойЧастиТовары

&НаКлиенте
Процедура ТоварыПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		УстановитьОтборНомеровУпаковок(ТекущиеДанные.ИдентификаторСтроки);
		СобытияФормМДЛПКлиентСервер.ОбновитьЗаголовокКоличествоНомеровУпаковок(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		ТекущиеДанные = Элемент.ТекущиеДанные;
		ТекущиеДанные.ИдентификаторСтроки = Строка(Новый УникальныйИдентификатор);
		УстановитьОтборНомеровУпаковок(ТекущиеДанные.ИдентификаторСтроки);
		СобытияФормМДЛПКлиентСервер.ОбновитьЗаголовокКоличествоНомеровУпаковок(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПередУдалением(Элемент, Отказ)
	
	СобытияФормМДЛПКлиент.ТоварыПередУдалением(ЭтотОбъект, Элемент, Отказ);
	
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
	ПараметрыЗаполнения.ПересчитатьКоличествоЕдиниц  = Истина;
	ПараметрыЗаполнения.ПроверитьСериюРассчитатьСтатус = Истина;
	ПараметрыЗаполнения.ПараметрыУказанияСерий = ПараметрыУказанияСерий;
	
	СобытияФормМДЛПКлиентПереопределяемый.ПриИзмененииНоменклатуры(ЭтотОбъект, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения);
	
	ОбновитьСтатусЗаполненияУпаковокВСтроке(ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	СобытияФормМДЛПКлиентПереопределяемый.НачалоВыбораХарактеристики(ЭтотОбъект, ТекущаяСтрока, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ПараметрыЗаполнения = ИнтеграцияМДЛПКлиентСервер.ПараметрыЗаполненияТабличнойЧасти();
	ПараметрыЗаполнения.ПересчитатьКоличествоЕдиниц  = Истина;
	
	СобытияФормМДЛПКлиентПереопределяемый.ПриИзмененииХарактеристики(ЭтотОбъект, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения);
	
	ОбновитьСтатусЗаполненияУпаковокВСтроке(ТекущаяСтрока);
	
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
	ПараметрыЗаполнения.ПараметрыУказанияСерий = ПараметрыУказанияСерий;
	
	СобытияФормМДЛПКлиентПереопределяемый.ПриИзмененииСерии(ЭтотОбъект, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУпаковкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	СобытияФормМДЛПКлиентПереопределяемый.НачалоВыбораУпаковки(ЭтотОбъект, ТекущаяСтрока, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУпаковкаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ПараметрыЗаполнения = ИнтеграцияМДЛПКлиентСервер.ПараметрыЗаполненияТабличнойЧасти();
	ПараметрыЗаполнения.ПересчитатьКоличествоЕдиниц  = Истина;
	
	СобытияФормМДЛПКлиентПереопределяемый.ПриИзмененииУпаковки(ЭтотОбъект, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения);
	
	ОбновитьСтатусЗаполненияУпаковокВСтроке(ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоУпаковокПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ПараметрыЗаполнения = ИнтеграцияМДЛПКлиентСервер.ПараметрыЗаполненияТабличнойЧасти();
	ПараметрыЗаполнения.ПересчитатьКоличествоЕдиниц  = Истина;
	
	СобытияФормМДЛПКлиентПереопределяемый.ПриИзмененииКоличестваУпаковок(ЭтотОбъект, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения);
	
	ОбновитьСтатусЗаполненияУпаковокВСтроке(ТекущаяСтрока);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТабличнойЧастиНомераУпаковок

&НаКлиенте
Процедура НомераУпаковокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Объект.ПередачаСведенийЧерезСКЗКМ Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Данные передаются через регистратор выбытия.
			|Для добавления упаковок в документ, отсканируйте идентификационный знак с упаковки.'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не выбрана строка с товаром.'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ПараметрыОтбора = Новый Структура("ИдентификаторСтроки", ТекущиеДанные.ИдентификаторСтроки);
	СтрокиУпаковок = Объект.НомераУпаковок.НайтиСтроки(ПараметрыОтбора);
	КоличествоУпаковок = 0;
	Для Каждого Строка Из СтрокиУпаковок Цикл
		КоличествоУпаковок = КоличествоУпаковок + ?(Строка.ДоляОтВторичнойУпаковки = 0, 1, Строка.ДоляОтВторичнойУпаковки);
	КонецЦикла;
	
	Если ТекущиеДанные.Количество <= КоличествоУпаковок Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НомераУпаковокПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		ТекущиеДанные = Элемент.ТекущиеДанные;
		Если Копирование Тогда
			ТекущиеДанные.НомерКиЗ = "";
		Иначе
			ТекущиеДанные.ИдентификаторСтроки = Элементы.Товары.ТекущиеДанные.ИдентификаторСтроки;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НомераУпаковокПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если НоваяСтрока И Не ОтменаРедактирования Тогда
		ОбновитьСтатусЗаполненияУпаковокВСтроке(Элементы.Товары.ТекущиеДанные);
		СобытияФормМДЛПКлиентСервер.ОбновитьЗаголовокКоличествоНомеровУпаковок(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НомераУпаковокПослеУдаления(Элемент)
	
	СобытияФормМДЛПКлиентСервер.ОбновитьЗаголовокКоличествоНомеровУпаковок(ЭтотОбъект);
	ПодключитьОбработчикОжидания("ОбновитьСтатусыЗаполненияНомеровУпаковокОтложено", 0.2, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтображатьВсеНомераУпаковок(Команда)
	
	ПоказыватьВсеНомераУпаковок = Не ПоказыватьВсеНомераУпаковок;
	Элементы.ТоварыОтображатьВсеНомераУпаковок.Пометка = Не ПоказыватьВсеНомераУпаковок;
	
	УстановитьОтборНомеровУпаковок(ИдентификаторТекущейСтроки);
	СобытияФормМДЛПКлиентСервер.ОбновитьЗаголовокКоличествоНомеровУпаковок(ЭтотОбъект);
	
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
Процедура ВыборочныйКонтрольМДЛП(Команда)
	
	КонтрольКодовМаркировкиМДЛПКлиент.ОткрытьФормуВыборочногоКонтроляКМИзФормыВладельца(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормМДЛПКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ГосударственныеИнформационныеСистемыПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтотОбъект, Объект.Товары);
	
	ПараметрыУказанияСерий = ГосударственныеИнформационныеСистемыПереопределяемый.ПараметрыУказанияСерийФормыОбъекта(Объект, ОбщегоНазначения.МенеджерОбъектаПоСсылке(Объект.Ссылка));
	
	ОбновитьСтатусУведомления();
	ОбновитьСтатусыЗаполненияНомеровУпаковок(Объект);
	
	НастроитьФорму();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтотОбъект);
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтотОбъект);
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьУсловноеОформлениеСерийНоменклатуры(ЭтотОбъект);
	
	ИнтеграцияМДЛП.УстановитьУсловноеОформлениеСостоянияПодтверждения(ЭтотОбъект);
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Элементы.НомераУпаковок.Имя);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Элемент.Отбор,
		"Объект.НомераУпаковок.ИдентификаторСтроки", Новый ПолеКомпоновкиДанных("ИдентификаторТекущейСтроки"), ВидСравненияКомпоновкиДанных.НеРавно);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияМДЛП);
	
	ИнтеграцияМДЛП.УстановитьУсловноеОформлениеОтклоненнойСтроки(ЭтотОбъект);
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Элементы.НомераУпаковокНомерУпаковки.Имя);
	
	ГруппаИли = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(Элемент.Отбор.Элементы, НСтр("ru = 'Только просмотр Номера КИЗ'"), ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаИли,
		"Объект.ПередачаСведенийЧерезСКЗКМ", Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаИли,
		"Объект.НомераУпаковок.ШтрихкодBase64", "", ВидСравненияКомпоновкиДанных.НеРавно);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФорму()
	
	ЭтоВходящийДокумент = Объект.ДанныеПолученыИзМДЛП;
	ДоступноОснование = ИнтеграцияМДЛП.ДоступноОснованиеУведомления(Объект.Ссылка);
	Элементы.ОснованиеСвязать.Видимость = ДоступноОснование И ЭтоВходящийДокумент;
	Элементы.Основание.Видимость = ДоступноОснование И Не ЭтоВходящийДокумент;
	
	Если ЭтоВходящийДокумент Тогда
		Элементы.Номер.ТолькоПросмотр = Истина;
		Элементы.Дата.ТолькоПросмотр = Истина;
		Элементы.Организация.ТолькоПросмотр = Истина;
		Элементы.МестоДеятельности.ТолькоПросмотр = Истина;
		Элементы.ПередачаСведенийЧерезСКЗКМ.ТолькоПросмотр = Истина;
		Элементы.НомерДокумента.ТолькоПросмотр = Истина;
		Элементы.ДатаДокумента.ТолькоПросмотр = Истина;
		Элементы.Товары.ИзменятьСоставСтрок = Ложь;
		Элементы.ТоварыУпаковка.ТолькоПросмотр = Ложь;
		Элементы.ТоварыGTIN.ТолькоПросмотр = Ложь;
		Элементы.ТоварыКоличествоУпаковок.ТолькоПросмотр = Ложь;
		Элементы.ТоварыКоличествоПервичныхУпаковокВоВторичной.ТолькоПросмотр = Ложь;
		Элементы.НомераУпаковок.ТолькоПросмотр = Истина;
		
		Элементы.ТоварыЗагрузитьДанныеИзТСД.Видимость = Ложь;
	КонецЕсли;
	
	// ИнтеграцияМДЛП.Инвентаризация
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтеграцияМДЛП.Инвентаризация") Тогда
		МодульИнвентаризацияМДЛПКлиентСервер = ОбщегоНазначения.ОбщийМодуль("ИнвентаризацияМДЛПКлиентСервер");
		Если МодульИнвентаризацияМДЛПКлиентСервер.УведомлениеСозданоНаОснованииИнвентаризации(Объект) Тогда
			
			Элементы.Организация.ТолькоПросмотр = Истина;
			Элементы.МестоДеятельности.ТолькоПросмотр = Истина;
			Элементы.ПередачаСведенийЧерезСКЗКМ.ТолькоПросмотр = Истина;
			
		КонецЕсли;
	КонецЕсли;
	// Конец ИнтеграцияМДЛП.Инвентаризация
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСтатусУведомления()
	
	ТекущийСтатус = ИнтеграцияМДЛП.ТекущийСтатусУведомления(Объект.Ссылка);
	СтатусПредставление = ИнтеграцияМДЛП.ПредставлениеСтатусаУведомления(ТекущийСтатус);
	
	РежимОтладки = ОбщегоНазначенияКлиентСервер.РежимОтладки();
	
	Если ЗначениеЗаполнено(ТекущийСтатус.ДальнейшееДействие)
	   И ТекущийСтатус.ДальнейшееДействие.Найти(ОбщегоНазначения.МенеджерОбъектаПоСсылке(Объект.Ссылка).ДальнейшееДействиеПоУмолчанию()) <> Неопределено Тогда
		РедактированиеФормыНедоступно = Ложь;
	ИначеЕсли Объект.ДанныеПолученыИзМДЛП Тогда
		РедактированиеФормыНедоступно = Ложь;
	Иначе
		РедактированиеФормыНедоступно = Не РежимОтладки;
	КонецЕсли;
	
	ТолькоПросмотр = РедактированиеФормыНедоступно;
	
	Элементы.ПередачаСведенийЧерезСКЗКМ.ТолькоПросмотр = Объект.Проведен И Не РежимОтладки;
	
	// ИнтеграцияМДЛП.Инвентаризация
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтеграцияМДЛП.Инвентаризация") Тогда
		МодульИнвентаризацияМДЛПКлиентСервер = ОбщегоНазначения.ОбщийМодуль("ИнвентаризацияМДЛПКлиентСервер");
		Если МодульИнвентаризацияМДЛПКлиентСервер.УведомлениеСозданоНаОснованииИнвентаризации(Объект) Тогда
			
			Элементы.ПередачаСведенийЧерезСКЗКМ.ТолькоПросмотр = Не РежимОтладки;
			
		КонецЕсли;
	КонецЕсли;
	// Конец ИнтеграцияМДЛП.Инвентаризация
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтатусыЗаполненияНомеровУпаковокОтложено()
	
	ОбновитьСтатусыЗаполненияНомеровУпаковок(Объект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьСтатусыЗаполненияНомеровУпаковок(Объект)
	
	Для Каждого СтрокаТЧ Из Объект.Товары Цикл
		
		ПараметрыОтбора = Новый Структура("ИдентификаторСтроки", СтрокаТЧ.ИдентификаторСтроки);
		СтрокиНомеров = Объект.НомераУпаковок.НайтиСтроки(ПараметрыОтбора);
		
		Если СтрокиНомеров.Количество() = СтрокаТЧ.Количество Тогда
			СтрокаТЧ.СтатусЗаполненияУпаковок = 1;
		Иначе
			СтрокаТЧ.СтатусЗаполненияУпаковок = 0;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтатусЗаполненияУпаковокВСтроке(ТекущиеДанные)
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОтбора = Новый Структура("ИдентификаторСтроки", ТекущиеДанные.ИдентификаторСтроки);
	СтрокиНомеров = Объект.НомераУпаковок.НайтиСтроки(ПараметрыОтбора);
	
	Если СтрокиНомеров.Количество() = ТекущиеДанные.Количество Тогда
		ТекущиеДанные.СтатусЗаполненияУпаковок = 1;
	Иначе
		ТекущиеДанные.СтатусЗаполненияУпаковок = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборНомеровУпаковок(ИдентификаторСтроки)
	
	Если ИдентификаторТекущейСтроки <> ИдентификаторСтроки Тогда
		ИдентификаторТекущейСтроки = ИдентификаторСтроки;
	КонецЕсли;
	
	Если Не ПоказыватьВсеНомераУпаковок Тогда
		ИнтеграцияМДЛПКлиент.УстановитьОтборСтрок(
			Элементы.НомераУпаковок.ОтборСтрок,
			Новый Структура("ИдентификаторСтроки", ИдентификаторТекущейСтроки));
	Иначе
		ИнтеграцияМДЛПКлиент.СнятьОтборСтрок(Элементы.НомераУпаковок.ОтборСтрок, "ИдентификаторСтроки");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеМестаДеятельности()
	
	УстановитьИспользованиеРегистратораВыбытия();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьИспользованиеРегистратораВыбытия()
	
	// ИнтеграцияМДЛП.Инвентаризация
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтеграцияМДЛП.Инвентаризация") Тогда
		МодульИнвентаризацияМДЛПКлиентСервер = ОбщегоНазначения.ОбщийМодуль("ИнвентаризацияМДЛПКлиентСервер");
		Если МодульИнвентаризацияМДЛПКлиентСервер.УведомлениеСозданоНаОснованииИнвентаризации(Объект) Тогда
			Объект.ПередачаСведенийЧерезСКЗКМ = Ложь;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	// Конец ИнтеграцияМДЛП.Инвентаризация
	
	Объект.ПередачаСведенийЧерезСКЗКМ =
		ЗначениеЗаполнено(Объект.МестоДеятельности)
		И ИнтеграцияМДЛП.ЕстьРегистраторВыбытия(Объект.МестоДеятельности);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеПризнакаПередачаСведенийЧерезСКЗКМ(ПередачаСведенийЧерезСКЗКМДоИзменения)
	
	Если Объект.ПередачаСведенийЧерезСКЗКМ <> ПередачаСведенийЧерезСКЗКМДоИзменения Тогда
		
		Если Объект.ПередачаСведенийЧерезСКЗКМ Тогда
			
			ЕстьСтрокиСНеЗаполненнымШтрихкодомBase64 = Ложь;
			Для Каждого Строка Из Объект.НомераУпаковок Цикл
				Если Не ЗначениеЗаполнено(Строка.ШтрихкодBase64) Тогда
					ЕстьСтрокиСНеЗаполненнымШтрихкодомBase64 = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			Если ЕстьСтрокиСНеЗаполненнымШтрихкодомBase64 Тогда
				
				// ИнтеграцияМДЛП.Инвентаризация
				Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтеграцияМДЛП.Инвентаризация") Тогда
					МодульИнвентаризацияМДЛПКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнвентаризацияМДЛПКлиентСервер");
					Если МодульИнвентаризацияМДЛПКлиентСервер.УведомлениеСозданоНаОснованииИнвентаризации(Объект) Тогда
						Объект.ПередачаСведенийЧерезСКЗКМ = Ложь;
						ПоказатьПредупреждение(, НСтр("ru = 'Уведомление создано на основании документа инвентаризации.
							|Изменение признака Использовать РВ недоступно: требуется наличие полного кода маркировки.'"));
						Возврат;
					КонецЕсли;
				КонецЕсли;
				// Конец ИнтеграцияМДЛП.Инвентаризация
				
				ПоказатьПредупреждение(, НСтр("ru = 'Данные передаются через регистратор выбытия.
					|Для добавления упаковок в документ, отсканируйте идентификационный знак с упаковки.'"));
				Объект.НомераУпаковок.Очистить();
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#Область ОбработкаШтрихкодов

&НаКлиенте
Процедура ЗагрузитьИзТСДЗавершение(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыполнения.Результат Тогда
		ОбработатьШтрихкоды(РезультатВыполнения.ТаблицаТоваров, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьШтрихкодыОтложенно()
	
	ОтключитьОбработчикОжидания("ОбработатьШтрихкодыОтложенно");
	
	// Обрабатывать штрихкоды из очереди будем по одному.
	Если ОчередьОбработкиШтрихкодов.Количество() > 0 Тогда
		ДанныеШтрихкода = ОчередьОбработкиШтрихкодов[0];
		ОчередьОбработкиШтрихкодов.Удалить(0);
		ОбработатьШтрихкоды(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДанныеШтрихкода));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьШтрихкоды(ДанныеШтрихкодов, ЗагрузкаИзТСД = Ложь)
	
	Если РедактированиеФормыНедоступно Или Объект.ДанныеПолученыИзМДЛП Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеШтрихкодовПоТипам = ИнтеграцияМДЛПКлиентСервер.РазобратьШтрихкодыПоТипам(ДанныеШтрихкодов);
	
	Доступность = Ложь;
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ПродолжитьОбработкуШтрихкодов", ЭтотОбъект, ДанныеШтрихкодовПоТипам);
	КонтрольКодовМаркировкиМДЛПКлиент.НачатьПроверкуКМНаФорме(ЭтотОбъект, Объект, ДанныеШтрихкодовПоТипам, ОповещениеОЗавершении, ЗагрузкаИзТСД);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьОбработкуШтрихкодов(Результат, ДанныеШтрихкодовПоТипам) Экспорт
	
	Доступность = Истина;
	
	ЗаполнитьДокументПоПолученнымШтрихкодам(ДанныеШтрихкодовПоТипам);
	
	// Когда была обработана очередная порция данных, можно обрабатывать следующую.
	ПодключитьОбработчикОжидания("ОбработатьШтрихкодыОтложенно", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДокументПоПолученнымШтрихкодам(ДанныеШтрихкодовПоТипам)
	
	ПараметрыЗаполнения = ИнтеграцияМДЛПКлиентСервер.ПараметрыЗаполненияТабличнойЧасти();
	ПараметрыЗаполнения.ПересчитатьКоличествоЕдиниц = Истина;
	ПараметрыЗаполнения.ПроверитьСериюРассчитатьСтатус = Истина;
	ПараметрыЗаполнения.ПараметрыУказанияСерий = ПараметрыУказанияСерий;
	
	ДанныеДляОбработки = СобытияФормМДЛПКлиентПереопределяемый.ПодготовитьДанныеДляОбработкиШтрихкодов(
		ЭтотОбъект, ДанныеШтрихкодовПоТипам, КэшированныеЗначения, ПараметрыЗаполнения);
	
	ИнтеграцияМДЛПСлужебныйКлиент.ЗаполнитьДокументПоШтрихкодам(ЭтотОбъект, Объект, КэшированныеЗначения, ДанныеШтрихкодовПоТипам.НомераКиЗ);
	
	ОбработатьПолученныеШтрихкодыСервер(ДанныеДляОбработки, КэшированныеЗначения);
	
	СобытияФормМДЛПКлиентСервер.ОбновитьЗаголовокКоличествоНомеровУпаковок(ЭтотОбъект);
	
	СобытияФормМДЛПКлиентПереопределяемый.ПослеОбработкиШтрихкодов(
		ЭтотОбъект,
		ДанныеДляОбработки,
		КэшированныеЗначения);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьПолученныеШтрихкодыСервер(ДанныеДляОбработки, КэшированныеЗначения)
	
	СобытияФормМДЛППереопределяемый.ОбработатьШтрихкоды(ЭтотОбъект, ДанныеДляОбработки, КэшированныеЗначения);
	
	ОбновитьСтатусыЗаполненияНомеровУпаковок(Объект);
	
	ГосударственныеИнформационныеСистемыПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтотОбъект, Объект.Товары);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ВыбратьДокументВыбытия()
	
	СобытияФормМДЛПКлиентПереопределяемый.ОткрытьФормуВыбораДокументаВыбытияТоваров(
		ЭтотОбъект, Объект, Новый ОписаниеОповещения("ПослеВыбораДокументаВыбытия", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораДокументаВыбытия(ВыбранныйДокумент, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(ВыбранныйДокумент) Тогда
		
		Если ИнтеграцияМДЛПВызовСервера.ЕстьРасхожденияМеждуУведомлениемИОснованием(Объект.Ссылка, ВыбранныйДокумент) Тогда
			
			ДополнительныеПараметрыВопроса = Новый Структура;
			ДополнительныеПараметрыВопроса.Вставить("Документ", ВыбранныйДокумент);
			
			Обработчик = Новый ОписаниеОповещения("ОбработатьОтветОРасхождениях", ЭтотОбъект, ДополнительныеПараметрыВопроса);
			ТекстВопроса = НСтр("ru='В уведомлении есть товары которых нет в выбранном документе. Продолжить выбор?'");
			ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			
		Иначе
			
			ОбработатьВыборДокументаВыбытия(ВыбранныйДокумент);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьОтветОРасхождениях(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ОбработатьВыборДокументаВыбытия(ДополнительныеПараметры.Документ);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборДокументаВыбытия(Документ)
	
	Если ЗначениеЗаполнено(Документ) Тогда
		
		Объект.Основание = Документ;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадатьВопросПередПовторнойПередачейДанных(НавигационнаяСсылкаФорматированнойСтроки)
	
	ТекстВопроса = НСтр("ru = 'Перед повторной передачей данных необходимо удостовериться, что ИС МДЛП и регистратор выбытия обработали все номера упаковок этого документа.
	|В случае некоторых ошибок РВ упаковки могут быть отправлены в ИС МДЛП отложенно.
	|Вы уверены, что хотите передать данные повторно?'");
	
	Контекст = Новый Структура;
	Контекст.Вставить("НавигационнаяСсылка", НавигационнаяСсылкаФорматированнойСтроки);
	
	Обработчик = Новый ОписаниеОповещения("ОбработатьНавигационнуюСсылкуСтатуса_ПослеОтветаПользователя", ЭтотОбъект, Контекст);
	ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьНавигационнуюСсылкуСтатуса_ПослеОтветаПользователя(Ответ, Контекст) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияМДЛПКлиент.ОбработатьНавигационнуюСсылкуСтатуса(ЭтотОбъект, Контекст.НавигационнаяСсылка, Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СтандартныеПодсистемы

// СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
	МодульПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	МодульПодключаемыеКоманды = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКоманды");
	МодульПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	МодульПодключаемыеКомандыКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиентСервер");
	МодульПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
