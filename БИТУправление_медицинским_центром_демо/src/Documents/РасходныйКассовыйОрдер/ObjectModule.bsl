#Область ПрограммныйИнтерфейс

// Расчет суммы документа.
// 
// Возвращаемое значение:
//	Число. 
//
Функция РассчитатьСуммуВсего()Экспорт
	Возврат СуммаДокумента;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьСовпадениеФилиалаИФилиалаКассы(Отказ)
	
	Если Не ОбменДанными.Загрузка Тогда
		СообщениеПользователю = ОграничениеДоступаНаУровнеЗаписей.ТребуетсяПредупреждениеНесоответствияКассыФилиала(Касса, Филиал);
		Если ЗначениеЗаполнено(СообщениеПользователю) Тогда
			Отказ = Истина;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеПользователю);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ВидОперацииРКОизОперацииПКО(ВидОперации)
	
	пчВОПКО = Перечисления.ВидыОперацийПКО;
	пчВОРКО = Перечисления.ВидыОперацийРКО;
	
	Если ВидОперации = пчВОПКО.ОплатаОтКлиента Тогда
		Возврат пчВОРКО.РасчетыСКлиентами;
		
	ИначеЕсли ВидОперации = пчВОПКО.ПолучениеДенежныхСредствОтСотрудника Тогда
		Возврат пчВОРКО.ВыдачаДенежныхСредствСотруднику;
		
	ИначеЕсли ВидОперации = пчВОПКО.ПолучениеНаличныхВБанке Тогда
		Возврат пчВОРКО.ВзносНаличнымиВБанк;
		
	ИначеЕсли ВидОперации = пчВОПКО.ПриходДенежныхСредствОтКонтрагента Тогда
		Возврат пчВОРКО.РасчетыСКонтрагентами;
		
	ИначеЕсли ВидОперации = пчВОПКО.ПрочееПоступлениеДенежныхСредств Тогда
		Возврат пчВОРКО.ПрочийРасходДенежныхСредств;
	Иначе
		Возврат пчВОРКО.РасчетыСКлиентами;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(Основание)
	
	РаботаСДокументамиСервер.ОбработкаЗаполнения(ЭтотОбъект, Основание);
	
	// Производится заполнение реквизитов документа в зависимости от типа документа основания.
	Если Основание=Неопределено Тогда Возврат; КонецЕсли;
	
	ДокументОснование = Основание;
	Если ТипЗнч(ДокументОснование)=Тип("ДокументСсылка.ПоступлениеТоваровУслуг")
		И ЗначениеЗаполнено(ДокументОснование)
	Тогда
		ВидОперации = Перечисления.ВидыОперацийРКО.РасчетыСКонтрагентами;
		Контрагент  = Основание.Контрагент;
		ДокументОснование = Основание;
		СуммаДокумента = Основание.СуммаДокумента;
		
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ОказаниеУслуг") Тогда
	
		СуммаДокумента	= Основание.ПолученоНаличными;
		ВидОперации = Перечисления.ВидыОперацийРКО.РасчетыСКлиентами;
		
		Контрагент = Основание.Клиент;
		СтатьяДвиженияДенежныхСредств = Основание.СтатьяДвиженияДенежныхСредств;
		
		Если ОбщегоНазначения.ЕстьРеквизитДокумента("Сделка", Метаданные()) Тогда
			Сделка = Основание.КомплексныйРасчет;
		КонецЕсли;
		
		НастройкаПечатиЧеков = МенеджерОборудованияВызовСервераПереопределяемый.ПолучитьНастройкуПечатиЧековФилиала(Филиал, Истина);	
		РаботаСДокументамиСервер.ДокументОплатыЗаполнитьРасчетыПоДолгуПоОказаниюУслуг(ДокументОснование, НастройкаПечатиЧеков, КредитныеДанные, СуммаДокумента, СпособРасчетаЧекаККМ);
		
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ПриходныйКассовыйОрдер") Тогда
		
		ВидОперации = ВидОперацииРКОизОперацииПКО(Основание.ВидОперации);
		Контрагент = Основание.Клиент;
		
		КопируемыеРеквизиты = "СуммаДокумента, Сделка, СтатьяДвиженияДенежныхСредств"
							+ ", СпособРасчетаЧекаККМ, ТелефонЧек, АдресEmailЧек, ПерсональныеДанныеПокупателя";
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Основание, КопируемыеРеквизиты);
		
		КредитныеДанные.Загрузить(Основание.КредитныеДанные.Выгрузить());
		
	ИначеЕсли ДопСерверныеФункции.ИмяСсылочногоТипа(Основание) = "Документ.КомплексныйРасчетКлиента" Тогда
		
		ВидОперации = Перечисления.ВидыОперацийРКО.РасчетыСКлиентами;
		Контрагент  = Основание.Клиент;
		Сделка = Основание;
		
		Если ТипЗнч(Контрагент) = Тип("СправочникСсылка.Клиенты") Тогда
			СуммаДокумента = Макс(0, РаботаСКлиентамиПереопределяемый.ПолучитьВзаиморасчетыСКлиентом(Контрагент, ТекущаяДата(), Сделка));
		Иначе
			// Не будем изменять сумму документа	
		КонецЕсли;
		
		НастройкаПечатиЧеков = МенеджерОборудованияВызовСервераПереопределяемый.ПолучитьНастройкуПечатиЧековФилиала(Филиал, Истина);	
		РаботаСДокументамиСервер.ДокументОплатыЗаполнитьРасчетыПоДолгуПоКомплексномуРасчетуСервер(Сделка, НастройкаПечатиЧеков, КредитныеДанные, СуммаДокумента);
		
	ИначеЕсли ТипЗнч(Основание) = Тип("Структура") 
		И Основание.Свойство("Коррекция")
		И Основание.Коррекция 
	Тогда
		РаботаСДокументамиСервер.ЗаполнитьДанныеДокументаКоррекцииПоОснованию(ЭтотОбъект, Основание);
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.АвансовыйОтчет") Тогда
		ВидОперации = Перечисления.ВидыОперацийРКО.ВыдачаДенежныхСредствСотруднику;
		Контрагент = Основание.Сотрудник;
		ДокументОснование = Основание;
		
		СуммаДокумента = Основание.СуммаДокумента + Основание.ВыданныеАвансы.Итог("СуммаИзрасходовано") - Основание.ВыданныеАвансы.Итог("СуммаАванса");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Контрагент) Тогда
		РаботаСДокументамиСервер.ЗаполнитьУчастникаИИННДенежнойОперации(Контрагент, Выдать, ВыдатьИНН, ВыдатьАдрес);
	КонецЕсли;
	
	НомерЧекаККМ = "";
	НомерЧекаЭТ = "";
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	
	СпЗнач = Новый СписокЗначений;
	Если ВидОперации <> Перечисления.ВидыОперацийРКО.ПрочийРасходДенежныхСредств И 
		 ВидОперации <> Перечисления.ВидыОперацийРКО.ВзносНаличнымиВБанк		 И 
		 Не ЗначениеЗаполнено(ЭтотОбъект["Контрагент"])
	Тогда 
		Если ВидОперации = Перечисления.ВидыОперацийРКО.ПеремещениеВКассу Тогда
			СпЗнач.Добавить(НСтр("ru='Не указана касса-получатель денежных средств'"));
		Иначе
			СпЗнач.Добавить(НСтр("ru='Не указан получатель денежных средств'"));
		КонецЕсли;
	КонецЕсли;
	
	Если СпЗнач.Количество() > 0 Тогда
		ОбщегоНазначения.СообщитьСписок(СпЗнач);	
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ПроверитьСовпадениеФилиалаИФилиалаКассы(Отказ);
	
	ПроведениеДокументов.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	Движение = Движения.ДенежныеСредства.Добавить();
	Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
	Движение.Период = Дата;
	Движение.Касса  = Касса;
	Движение.Сумма  = СуммаДокумента;
                                                                                                                 
	РегистрыНакопления.ДвиженияДенежныхСредств.СформироватьДвиженияПоШапкеДокумента(Новый Структура("Дата, Касса, СуммаДокумента, СтатьяДвиженияДенежныхСредств",Дата,Касса,СуммаДокумента,СтатьяДвиженияДенежныхСредств),Движения.ДвиженияДенежныхСредств, Ложь, Отказ);

	Если ВидОперации = Перечисления.ВидыОперацийРКО.РасчетыСКонтрагентами Тогда
		Движение = Движения.ВзаиморасчетыСКонтрагентами.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период      = Дата;
		Движение.Контрагент  = Контрагент;
		Движение.Сумма 		 = СуммаДокумента;
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийРКО.ВыдачаДенежныхСредствСотруднику Тогда
		Движение = Движения.ВзаиморасчетыССотрудниками.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период      = Дата;
		Движение.Сотрудник   = Контрагент;
		Движение.Сумма 		 = СуммаДокумента;
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийРКО.РасчетыСКлиентами Тогда
		Движение = Движения.ВзаиморасчетыСКлиентами.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период 	 = Дата;
		Движение.Клиент	     = Контрагент;
		Движение.Сумма		 = -СуммаДокумента;
		
		// Комплексные расчеты в взиморасчетах с клиентами.
		Если ЗначениеЗаполнено(Сделка) 
			И ТипЗнч(Сделка) = Тип("ДокументСсылка.КомплексныйРасчетКлиента")
			И ОбщегоНазначения.ОбщийМодуль("КомплексныеРасчетыКлиентов").РасчетСОбособленнымУчетомВзаиморасчетов(ЭтотОбъект.Сделка)
		Тогда
			Движение.Сделка = ЭтотОбъект.Сделка;
		КонецЕсли;
		
		// Регистр "Оплаты".
		РаботаСДокументамиСервер.ДобавитьДвижениеПоРегиструОплаты(Движения.Оплаты, Дата, Контрагент, Перечисления.ВидыОплаты.Наличными, -СуммаДокумента);
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийРКО.ПеремещениеВКассу Тогда
		РегистрыНакопления.ДвиженияДенежныхСредств.СформироватьДвиженияПоШапкеДокумента(Новый Структура("Дата, Касса, СуммаДокумента, СтатьяДвиженияДенежныхСредств",Дата,Контрагент,СуммаДокумента,СтатьяДвиженияДенежныхСредств),Движения.ДвиженияДенежныхСредств, Истина, Отказ);
		
		Движение = Движения.ДенежныеСредства.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Касса  = Контрагент;
		Движение.Сумма  = СуммаДокумента;
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийРКО.ПрочийРасходДенежныхСредств И
			  ЗначениеЗаполнено(Контрагент) 
	Тогда
		Движение = Движения.Затраты.Добавить();
		Движение.Регистратор  = Ссылка;
		Движение.Период		  = Дата;
		Движение.СтатьяЗатрат = Контрагент;
		Движение.Филиал		  = Филиал;
		Движение.Сумма		  = СуммаДокумента;
		Движение.КатегорияВыработки = СпециализацияЗатрат;
	КонецЕсли;
	
	// Документ коррекции дополнительно сторнирует движения если это требуется
	Если Коррекция Тогда	
		РаботаСДокументамиСервер.СторнироватьДвиженияПоРегистрамУПР(ЭтотОбъект, Отказ);	
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("Контрагент"));
	
	Если Не ЗначениеЗаполнено(Контрагент)
		И ВидОперации <> Перечисления.ВидыОперацийРКО.ПрочийРасходДенежныхСредств
		И ВидОперации <> Перечисления.ВидыОперацийРКО.ВзносНаличнымиВБанк
	Тогда
		Если ВидОперации = Перечисления.ВидыОперацийРКО.ПеремещениеВКассу Тогда
			НазваниеПлательщика = НСтр("ru='Касса-получатель'");
		ИначеЕсли ВидОперации = Перечисления.ВидыОперацийРКО.РасчетыСКлиентами Тогда
			НазваниеПлательщика = НСтр("ru='Клиент'");
		ИначеЕсли ВидОперации = Перечисления.ВидыОперацийРКО.ВыдачаДенежныхСредствСотруднику Тогда
			НазваниеПлательщика = НСтр("ru='Сотрудник'");
		ИначеЕсли ВидОперации = Перечисления.ВидыОперацийРКО.РасчетыСКонтрагентами Тогда
			НазваниеПлательщика = НСтр("ru='Контрагент'");
		Иначе
			НазваниеПлательщика = НСтр("ru='Получатель'");
		КонецЕсли;
		
		ШаблонОшибки = НСтр("ru='Поле %1 не заполнено'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрШаблон(ШаблонОшибки, НазваниеПлательщика), ЭтотОбъект, "Контрагент",, Отказ);
	КонецЕсли;
    
КонецПроцедуры 

Процедура ПриКопировании(ОбъектКопирования)
	
	РаботаСДокументамиСервер.ОчиститьРеквизитыККМДокумента(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	РаботаСДокументамиСервер.ДокументОплатыПроверитьСуммыКредитаККМПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи);
	РаботаСДокументамиСервер.ПроверитьДанныеКоррекции(ЭтотОбъект, Отказ, РежимЗаписи);
	
КонецПроцедуры

#КонецОбласти
