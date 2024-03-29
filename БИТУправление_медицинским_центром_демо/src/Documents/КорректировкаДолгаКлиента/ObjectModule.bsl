#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Проверка заполнения
	ТекстШаблонОшибкиНачало = НСтр("ru='В качестве расчета'");
	ТекстШаблонОшибкиПродолжение = НСтр("ru='указан документ с видом, по которому не используется обособленный учет взаиморасчетов!'");
	ШаблонОшибкиСделка = ТекстШаблонОшибкиНачало + "-%тип% " + ТекстШаблонОшибкиПродолжение;
	Если ЗначениеЗаполнено(СделкаПриемник)
		И Не КомплексныеРасчетыКлиентов.РасчетСОбособленнымУчетомВзаиморасчетов(СделкаПриемник)
	Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрЗаменить(ШаблонОшибкиСделка,"%тип%", НСтр("ru='приемника'")), Отказ);
	КонецЕсли;
	Если ЗначениеЗаполнено(СделкаИсточник)
		И Не КомплексныеРасчетыКлиентов.РасчетСОбособленнымУчетомВзаиморасчетов(СделкаИсточник)
	Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрЗаменить(ШаблонОшибкиСделка,"%тип%", НСтр("ru='источника'")), Отказ);
	КонецЕсли;
	
	// Формирование движений
	ВидДвиженияПриемник = ?(Сумма <= 0, ВидДвиженияНакопления.Приход, ВидДвиженияНакопления.Расход);
	ВидДвиженияИсточник = ?(Сумма <= 0, ВидДвиженияНакопления.Расход, ВидДвиженияНакопления.Приход);
	СуммаОперации = Макс(Сумма, -Сумма);

	Движение = Движения.ВзаиморасчетыСКлиентами.Добавить();
	Движение.ВидДвижения	= ВидДвиженияПриемник;
	Движение.Период			= Дата;
	Движение.Клиент			= КлиентПриемник;
	Движение.Сделка			= СделкаПриемник;
	Движение.Сумма			= СуммаОперации;

	Если ЭтотОбъект.ВидОперации = Перечисления.ВидыОперацийКорректировкиДолга.Передача Тогда 
		Движение = Движения.ВзаиморасчетыСКлиентами.Добавить();
		Движение.ВидДвижения	= ВидДвиженияИсточник;
		Движение.Период			= Дата;
		Движение.Клиент			= КлиентИсточник;
		Движение.Сделка			= СделкаИсточник;
		Движение.Сумма			= СуммаОперации;
	КонецЕсли;

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если (ВидОперации = Перечисления.ВидыОперацийКорректировкиДолга.Корректировка)
		И ЗначениеЗаполнено(КлиентИсточник)
	Тогда
		КлиентИсточник = Справочники.Клиенты.ПустаяСсылка()
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	Если ВидОперации = Перечисления.ВидыОперацийКорректировкиДолга.Передача Тогда
		ПроверяемыеРеквизиты.Добавить("КлиентИсточник");	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти