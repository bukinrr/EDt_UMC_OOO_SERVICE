#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ЭтоНовый() Тогда
		ДополнительныеСвойства.Вставить("ЗаписьНового", Истина);
	КонецЕсли;
	
	// При записи ПМО по тестовому клиенту, ПМО должен тоже становиться тестовым
	Тестовый = Тестовый Или Клиент.Тестовый;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ДополнительныеСвойства.Свойство("ЗаписьНового") И
		ДополнительныеСвойства.ЗаписьНового И
		УправлениеНастройками.ПолучитьПараметрУчетнойПолитики("АвтоматическиШтрихкодироватьПрМО")
	Тогда
		РаботаСТорговымОборудованиемСервер.ЗаписатьШтрихКодВРегистр(Ссылка,Неопределено);
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ТЗДопДанныхПрохожденияМО") Тогда
		НаборЗаписей = РегистрыСведений.ДанныеПрохожденийМО.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ДокументПрохожденияМО.Установить(Ссылка);
		Если ДополнительныеСвойства.ТЗДопДанныхПрохожденияМО.Количество() > 0 Тогда
			
			Для Каждого Эл Из ДополнительныеСвойства.ТЗДопДанныхПрохожденияМО Цикл
				НоваяЗапись = НаборЗаписей.Добавить();
				НоваяЗапись.Ключ = Эл.Ключ;
				НоваяЗапись.Приказ = Эл.Приказ;
				НоваяЗапись.Значение = Эл.ТекущееЗначение;
				НоваяЗапись.ДокументПрохожденияМО = Ссылка;
			КонецЦикла
			
		КонецЕсли;
		
		НаборЗаписей.Записать(Истина);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	ДвиженияПоРегиструНазначенийПоРезультатуМедосмотра();
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	НеВыполнятьЗаполнениеВФ = Неопределено;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если Не (ДанныеЗаполнения.Свойство("НеПереопеределятьПоля") И ДанныеЗаполнения.НеПереопеределятьПоля) Тогда
			ДанныеЗаполнения.Свойство("Клиент", Клиент);
			ДанныеЗаполнения.Свойство("СписокНаПрохождениеМедосмотра", СписокНаПрохождениеМедосмотра);
			ДанныеЗаполнения.Свойство("Профессия", Профессия);
			ДанныеЗаполнения.Свойство("ФИОКлиента", ФИОКлиента);
			ДанныеЗаполнения.Свойство("ЦехУчасток", ЦехУчасток);
		КонецЕсли;	
		
		ДанныеЗаполнения.Свойство("НеВыполнятьЗаполнениеВФ", НеВыполнятьЗаполнениеВФ);
		
	КонецЕсли;
	
	Если НеВыполнятьЗаполнениеВФ = Неопределено Тогда
		НеВыполнятьЗаполнениеВФ = Ложь;
	КонецЕсли;
	
	Если ВидПрохожденияМО <> Перечисления.ВидыМедосмотров.СправкаПрочий Тогда
		
		Если Не ЗначениеЗаполнено(МедицинскаяКарта) И ЗначениеЗаполнено(СписокНаПрохождениеМедосмотра) Тогда	
			ВидМО = СписокНаПрохождениеМедосмотра.ВидМО;
			МедицинскаяКарта = МедосмотрыСервер.ПолучитьНезакрытуюМедкарту025У(Клиент,СписокНаПрохождениеМедосмотра.Филиал, Дата);
			Если Не ЗначениеЗаполнено(МедицинскаяКарта)
				И УправлениеНастройками.ПолучитьПараметрУчетнойПолитики("МедкартуДляПрофосмотраСоздаватьАвтоматически")
			Тогда
				МедицинскаяКарта = МедосмотрыСервер.СоздатьМедкартуДляМедОсмотра(Клиент,СписокНаПрохождениеМедосмотра.Филиал, Дата);
			КонецЕсли;
		КонецЕсли;
		
		Если ФакторыИУсловияРаботы.Количество() = 0 
			И ЗначениеЗаполнено(Клиент)
			И Не НеВыполнятьЗаполнениеВФ
		Тогда
			ДанныеПрофесиияМР = МедосмотрыСервер.ПрофессияМестоРаботыПоПолямПМОИСпискуМО(Профессия, МестоРаботы, СписокНаПрохождениеМедосмотра, Клиент); 
			Вредности = МедосмотрыСервер.ПолучитьВредностиКлиентаИзПредыдущегоПМО(Клиент, ВидМО, Неопределено, Истина, ДанныеПрофесиияМР.Профессия, ДанныеПрофесиияМР.МестоРаботы);
			Для Каждого Вредность Из Вредности Цикл
				ФакторыИУсловияРаботы.Добавить().Фактор = Вредность.Вредность;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДатаЗавершения = Дата(1,1,1);
	ПредседательМедКомиссии = Неопределено;
	ПараметрыПриема.Очистить();
	
	ПодписанЭП = Ложь;
	
	// РЭМД: очистим ключевые данные интеграции с сервисом ЕГИСЗ.
	РолиИПодписиЭМД.Очистить();
	ЭМД.Очистить();
	ПутьКФайлуВАрхиве = "";
	СообщениеРЭМД = Неопределено;
	ИдентификаторыПриказов.Очистить();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДвиженияПоРегиструНазначенийПоРезультатуМедосмотра()
		
	Движения.НаправленияПоРезультатамМедосмотра.Записывать = Истина;
	
	пчВидыНаправлений = Перечисления.ВидыНаправленийПоРезультатамМедосмотра;	
	ВидыНаправлений = Перечисления.ВидыНаправленийПоРезультатамМедосмотра.ПустаяСсылка().Метаданные().ЗначенияПеречисления;
	РеквизитыДокумента = Метаданные().Реквизиты;
	
	Для сч = 0 По ВидыНаправлений.Количество()-1 Цикл
		
		ВидНаправления = ВидыНаправлений[сч];
		
		Если РеквизитыДокумента.Найти(ВидНаправления.Имя) <> Неопределено
			И ЭтотОбъект[ВидНаправления.Имя] = Истина
		Тогда
			ДобавитьЗаписьНаправленияПоРезультатуМедосмотра(пчВидыНаправлений[сч]);	
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьЗаписьНаправленияПоРезультатуМедосмотра(ВидНаправления)
	
	Запись = Движения.НаправленияПоРезультатамМедосмотра.Добавить();
	Запись.Период = Дата;
	Запись.Регистратор = Ссылка;
	Запись.ВидНаправления = ВидНаправления;
	Запись.ПрохождениеМедосмотра = Ссылка;
	
КонецПроцедуры

#КонецОбласти