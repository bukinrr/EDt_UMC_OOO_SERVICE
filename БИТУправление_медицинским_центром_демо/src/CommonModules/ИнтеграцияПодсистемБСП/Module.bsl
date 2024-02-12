///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ГрупповоеИзменениеОбъектов

// См. ГрупповоеИзменениеОбъектовПереопределяемый.ПриОпределенииОбъектовСРедактируемымиРеквизитами.
Процедура ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты) Экспорт
	
	СтандартныеПодсистемыСервер.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	ПользователиСлужебный.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	
	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Анкетирование") Тогда
	//	МодульАнкетирование = ОбщегоНазначения.ОбщийМодуль("Анкетирование");
	//	МодульАнкетирование.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	//КонецЕсли;
	//
	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Банки") Тогда
	//	МодульРаботаСБанками = ОбщегоНазначения.ОбщийМодуль("РаботаСБанками");
	//	МодульРаботаСБанками.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	//КонецЕсли;
	//
	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.БизнесПроцессыИЗадачи") Тогда
	//	МодульБизнесПроцессыИЗадачиСервер = ОбщегоНазначения.ОбщийМодуль("БизнесПроцессыИЗадачиСервер");
	//	МодульБизнесПроцессыИЗадачиСервер.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	//КонецЕсли;
	//
	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Взаимодействия") Тогда
	//	МодульВзаимодействия = ОбщегоНазначения.ОбщийМодуль("Взаимодействия");
	//	МодульВзаимодействия.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	//КонецЕсли;
	//
	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Валюты") Тогда
	//	МодульРаботаСКурсамиВалют = ОбщегоНазначения.ОбщийМодуль("РаботаСКурсамиВалют");
	//	МодульРаботаСКурсамиВалют.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	//КонецЕсли;
	//
	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов") Тогда
	//	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	//	МодульВариантыОтчетов.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	//КонецЕсли;
	//
	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВнешниеКомпоненты") Тогда
	//	МодульВнешниеКомпонентыСлужебный = ОбщегоНазначения.ОбщийМодуль("ВнешниеКомпонентыСлужебный");
	//	МодульВнешниеКомпонентыСлужебный.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	//КонецЕсли;
	//
	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ВнешниеКомпонентыВМоделиСервиса") Тогда
	//	МодульВнешниеКомпонентыВМоделиСервисаСлужебный = ОбщегоНазначения.ОбщийМодуль("ВнешниеКомпонентыВМоделиСервисаСлужебный");
	//	МодульВнешниеКомпонентыВМоделиСервисаСлужебный.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	//КонецЕсли;
	//
	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки") Тогда
	//	МодульДополнительныеОтчетыИОбработки = ОбщегоНазначения.ОбщийМодуль("ДополнительныеОтчетыИОбработки");
	//	МодульДополнительныеОтчетыИОбработки.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	//КонецЕсли;
	//
	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЗаметкиПользователя") Тогда
	//	МодульЗаметкиПользователяСлужебный = ОбщегоНазначения.ОбщийМодуль("ЗаметкиПользователяСлужебный");
	//	МодульЗаметкиПользователяСлужебный.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	//КонецЕсли;
	//
	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
	//	МодульУправлениеКонтактнойИнформациейСлужебный = ОбщегоНазначения.ОбщийМодуль("УправлениеКонтактнойИнформациейСлужебный");
	//	МодульУправлениеКонтактнойИнформациейСлужебный.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	//КонецЕсли;
	
	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОбменДанными") Тогда
	//	МодульОбменДаннымиСервер = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиСервер");
	//	МодульОбменДаннымиСервер.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	//КонецЕсли;
	//
	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
	//	МодульРаботаСФайламиСлужебный = ОбщегоНазначения.ОбщийМодуль("РаботаСФайламиСлужебный");
	//	МодульРаботаСФайламиСлужебный.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	//КонецЕсли;
	//
	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РассылкаОтчетов") Тогда
	//	МодульРассылкаОтчетов = ОбщегоНазначения.ОбщийМодуль("РассылкаОтчетов");
	//	МодульРассылкаОтчетов.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	//КонецЕсли;
	//
	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
	//	МодульРаботаСПочтовымиСообщениямиСлужебный = ОбщегоНазначения.ОбщийМодуль("РаботаСПочтовымиСообщениямиСлужебный");
	//	МодульРаботаСПочтовымиСообщениямиСлужебный.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	//КонецЕсли;
	//
	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
	//	МодульУправлениеСвойствамиСлужебный = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствамиСлужебный");
	//	МодульУправлениеСвойствамиСлужебный.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	//КонецЕсли;
	//
	//Если ИнтеграцияПодсистемБСППовтИсп.ПодпискиБТС().ПриОпределенииОбъектовСРедактируемымиРеквизитами Тогда
	//	МодульИнтеграцияПодсистемБТС = ОбщегоНазначения.ОбщийМодуль("ИнтеграцияПодсистемБТС");
	//	МодульИнтеграцияПодсистемБТС.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	//КонецЕсли;
	//
	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
	//	МодульУправлениеДоступомСлужебный = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступомСлужебный");
	//	МодульУправлениеДоступомСлужебный.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	//КонецЕсли;
	//
	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЭлектроннаяПодпись") Тогда
	//	МодульЭлектроннаяПодписьСлужебный = ОбщегоНазначения.ОбщийМодуль("ЭлектроннаяПодписьСлужебный");
	//	МодульЭлектроннаяПодписьСлужебный.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	//КонецЕсли;
	//
	//Если ИнтеграцияПодсистемБСППовтИсп.ПодпискиБИП().ПриОпределенииОбъектовСРедактируемымиРеквизитами Тогда
	//	МодульИнтеграцияПодсистемБИП = ОбщегоНазначения.ОбщийМодуль("ИнтеграцияПодсистемБИП");
	//	МодульИнтеграцияПодсистемБИП.ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты);
	//КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ЗагрузкаДанныхИзФайла

// См. ЗагрузкаДанныхИзФайлаПереопределяемый.ПриОпределенииСправочниковДляЗагрузкиДанных.
Процедура ПриОпределенииСправочниковДляЗагрузкиДанных(ЗагружаемыеСправочники) Экспорт
	
	СтандартныеПодсистемыСервер.ПриОпределенииСправочниковДляЗагрузкиДанных(ЗагружаемыеСправочники);
	ПользователиСлужебный.ПриОпределенииСправочниковДляЗагрузкиДанных(ЗагружаемыеСправочники);
	
	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
	//	МодульУправлениеКонтактнойИнформациейСлужебный = ОбщегоНазначения.ОбщийМодуль("УправлениеКонтактнойИнформациейСлужебный");
	//	МодульУправлениеКонтактнойИнформациейСлужебный.ПриОпределенииСправочниковДляЗагрузкиДанных(ЗагружаемыеСправочники);
	//КонецЕсли;
	//
	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Валюты") Тогда
	//	МодульРаботаСКурсамиВалют = ОбщегоНазначения.ОбщийМодуль("РаботаСКурсамиВалют");
	//	МодульРаботаСКурсамиВалют.ПриОпределенииСправочниковДляЗагрузкиДанных(ЗагружаемыеСправочники);
	//КонецЕсли;
	//
	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.БизнесПроцессыИЗадачи") Тогда
	//	МодульБизнесПроцессыИЗадачиСервер = ОбщегоНазначения.ОбщийМодуль("БизнесПроцессыИЗадачиСервер");
	//	МодульБизнесПроцессыИЗадачиСервер.ПриОпределенииСправочниковДляЗагрузкиДанных(ЗагружаемыеСправочники);
	//КонецЕсли;
	//
	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Банки") Тогда
	//	МодульРаботаСБанками = ОбщегоНазначения.ОбщийМодуль("РаботаСБанками");
	//	МодульРаботаСБанками.ПриОпределенииСправочниковДляЗагрузкиДанных(ЗагружаемыеСправочники);
	//КонецЕсли;
	//
	//Если ИнтеграцияПодсистемБСППовтИсп.ПодпискиБТС().ПриОпределенииСправочниковДляЗагрузкиДанных Тогда
	//	МодульИнтеграцияПодсистемБТС = ОбщегоНазначения.ОбщийМодуль("ИнтеграцияПодсистемБТС");
	//	МодульИнтеграцияПодсистемБТС.ПриОпределенииСправочниковДляЗагрузкиДанных(ЗагружаемыеСправочники);
	//КонецЕсли;
	//
	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов") Тогда
	//	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	//	МодульВариантыОтчетов.ПриОпределенииСправочниковДляЗагрузкиДанных(ЗагружаемыеСправочники);
	//КонецЕсли;
	//
	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЭлектроннаяПодпись") Тогда
	//	МодульЭлектроннаяПодписьСлужебный = ОбщегоНазначения.ОбщийМодуль("ЭлектроннаяПодписьСлужебный");
	//	МодульЭлектроннаяПодписьСлужебный.ПриОпределенииСправочниковДляЗагрузкиДанных(ЗагружаемыеСправочники);
	//КонецЕсли;

	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Взаимодействия") Тогда
	//	МодульВзаимодействия = ОбщегоНазначения.ОбщийМодуль("Взаимодействия");
	//	МодульВзаимодействия.ПриОпределенииСправочниковДляЗагрузкиДанных(ЗагружаемыеСправочники);
	//КонецЕсли;
	//
	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
	//	МодульРаботаСФайламиСлужебный = ОбщегоНазначения.ОбщийМодуль("РаботаСФайламиСлужебный");
	//	МодульРаботаСФайламиСлужебный.ПриОпределенииСправочниковДляЗагрузкиДанных(ЗагружаемыеСправочники);
	//КонецЕсли;
	//
	//Если ИнтеграцияПодсистемБСППовтИсп.ПодпискиБИП().ПриОпределенииСправочниковДляЗагрузкиДанных Тогда
	//	МодульИнтеграцияПодсистемБИП = ОбщегоНазначения.ОбщийМодуль("ИнтеграцияПодсистемБИП");
	//	МодульИнтеграцияПодсистемБИП.ПриОпределенииСправочниковДляЗагрузкиДанных(ЗагружаемыеСправочники);
	//КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийБИП
// Обработка программных событий, возникающих в подсистемах ИПП.
// Только для вызовов из библиотеки ИПП в БСП.

// Определяет события, на которые подписана эта библиотека.
//
// Параметры:
//  Подписки - Структура - ключами свойств структуры являются имена событий, на которые
//           подписана эта библиотека.
//
Процедура ПриОпределенииПодписокНаСобытияБИП(Подписки) Экспорт
	
	// БазоваяФункциональность
	Подписки.ПриИзмененииДанныхАутентификацииИнтернетПоддержки = Истина;
	
	// РаботаСКлассификаторами
	Подписки.ПриДобавленииКлассификаторов = Истина;
	Подписки.ПриЗагрузкеКлассификатора = Истина;
	Подписки.ПриОбработкеОбластиДанных = Истина;

КонецПроцедуры

#Область БазоваяФункциональность

// См. ИнтернетПоддержкаПользователейПереопределяемый.ПриИзмененииДанныхАутентификацииИнтернетПоддержки.
Процедура ПриИзмененииДанныхАутентификацииИнтернетПоддержки(ДанныеПользователя) Экспорт

	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Валюты") Тогда
		МодульРаботаСКурсамиВалют = ОбщегоНазначения.ОбщийМодуль("РаботаСКурсамиВалют");
		МодульРаботаСКурсамиВалют.ПриИзмененииДанныхАутентификацииИнтернетПоддержки(ДанныеПользователя);
	КонецЕсли;

КонецПроцедуры

// См. ОбщегоНазначенияПереопределяемый.ПриДобавленииПереименованийОбъектовМетаданных.
Процедура ПриДобавленииПереименованийОбъектовМетаданных(Итог) Экспорт
	
	//+бит
	//СтандартныеПодсистемыСервер.ПриДобавленииПереименованийОбъектовМетаданных(Итог);

	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.АнализЖурналаРегистрации") Тогда
	//	МодульАнализЖурналаРегистрацииСлужебный = ОбщегоНазначения.ОбщийМодуль("АнализЖурналаРегистрацииСлужебный");
	//	МодульАнализЖурналаРегистрацииСлужебный.ПриДобавленииПереименованийОбъектовМетаданных(Итог);
	//КонецЕсли;

	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов") Тогда
	//	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	//	МодульВариантыОтчетов.ПриДобавленииПереименованийОбъектовМетаданных(Итог);
	//КонецЕсли;

	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки") Тогда
	//	МодульДополнительныеОтчетыИОбработки = ОбщегоНазначения.ОбщийМодуль("ДополнительныеОтчетыИОбработки");
	//	МодульДополнительныеОтчетыИОбработки.ПриДобавленииПереименованийОбъектовМетаданных(Итог);
	//КонецЕсли;

	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЗаметкиПользователя") Тогда
	//	МодульЗаметкиПользователяСлужебный = ОбщегоНазначения.ОбщийМодуль("ЗаметкиПользователяСлужебный");
	//	МодульЗаметкиПользователяСлужебный.ПриДобавленииПереименованийОбъектовМетаданных(Итог);
	//КонецЕсли;

	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.НапоминанияПользователя") Тогда
	//	МодульНапоминанияПользователяСлужебный = ОбщегоНазначения.ОбщийМодуль("НапоминанияПользователяСлужебный");
	//	МодульНапоминанияПользователяСлужебный.ПриДобавленииПереименованийОбъектовМетаданных(Итог);
	//КонецЕсли;

	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.НастройкиПрограммы") Тогда
	//	МодульПанельАдминистрированияБСП = ОбщегоНазначения.ОбщийМодуль("Обработки.ПанельАдминистрированияБСП");
	//	МодульПанельАдминистрированияБСП.ПриДобавленииПереименованийОбъектовМетаданных(Итог);
	//КонецЕсли;

	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОбменДанными") Тогда
	//	МодульОбменДаннымиСервер = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиСервер");
	//	МодульОбменДаннымиСервер.ПриДобавленииПереименованийОбъектовМетаданных(Итог);
	//КонецЕсли;

	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
	//	МодульРаботаСПочтовымиСообщениямиСлужебный = ОбщегоНазначения.ОбщийМодуль(
	//		"РаботаСПочтовымиСообщениямиСлужебный");
	//	МодульРаботаСПочтовымиСообщениямиСлужебный.ПриДобавленииПереименованийОбъектовМетаданных(Итог);
	//КонецЕсли;

	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
	//	МодульРаботаСФайламиСлужебный = ОбщегоНазначения.ОбщийМодуль("РаботаСФайламиСлужебный");
	//	МодульРаботаСФайламиСлужебный.ПриДобавленииПереименованийОбъектовМетаданных(Итог);
	//КонецЕсли;

	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.СтруктураПодчиненности") Тогда
	//	МодульСтруктураПодчиненностиСлужебный = ОбщегоНазначения.ОбщийМодуль("СтруктураПодчиненностиСлужебный");
	//	МодульСтруктураПодчиненностиСлужебный.ПриДобавленииПереименованийОбъектовМетаданных(Итог);
	//КонецЕсли;

	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ТекущиеДела") Тогда
	//	МодульТекущиеДелаСлужебный = ОбщегоНазначения.ОбщийМодуль("ТекущиеДелаСлужебный");
	//	МодульТекущиеДелаСлужебный.ПриДобавленииПереименованийОбъектовМетаданных(Итог);
	//КонецЕсли;

	//Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЭлектроннаяПодпись") Тогда
	//	МодульЭлектроннаяПодписьСлужебный = ОбщегоНазначения.ОбщийМодуль("ЭлектроннаяПодписьСлужебный");
	//	МодульЭлектроннаяПодписьСлужебный.ПриДобавленииПереименованийОбъектовМетаданных(Итог);
	//КонецЕсли;

	//Если ИнтеграцияПодсистемБСППовтИсп.ПодпискиБТС().ПриДобавленииПереименованийОбъектовМетаданных Тогда
	//	МодульИнтеграцияПодсистемБТС = ОбщегоНазначения.ОбщийМодуль("ИнтеграцияПодсистемБТС");
	//	МодульИнтеграцияПодсистемБТС.ПриДобавленииПереименованийОбъектовМетаданных(Итог);
	//КонецЕсли;

	//Если ИнтеграцияПодсистемБСППовтИсп.ПодпискиБИП().ПриДобавленииПереименованийОбъектовМетаданных Тогда
	//	МодульИнтеграцияПодсистемБИП = ОбщегоНазначения.ОбщийМодуль("ИнтеграцияПодсистемБИП");
	//	МодульИнтеграцияПодсистемБИП.ПриДобавленииПереименованийОбъектовМетаданных(Итог);
	//КонецЕсли; 
	//-бит

КонецПроцедуры

#КонецОбласти

#Область РаботаСКлассификаторами

// См. РаботаСКлассификаторамиПереопределяемый.ПриДобавленииКлассификаторов.
Процедура ПриДобавленииКлассификаторов(Классификаторы) Экспорт

	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Банки") И Метаданные.Обработки.Найти(
		"ЗагрузкаКлассификатораБанков") <> Неопределено Тогда
		МодульЗагрузкаКлассификатораБанков = ОбщегоНазначения.ОбщийМодуль("Обработки.ЗагрузкаКлассификатораБанков");
		МодульЗагрузкаКлассификатораБанков.ПриДобавленииКлассификаторов(Классификаторы);
	КонецЕсли;

	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Валюты") И Метаданные.Обработки.Найти(
		"ЗагрузкаКурсовВалют") <> Неопределено Тогда
		МодульЗагрузкаКурсовВалют = ОбщегоНазначения.ОбщийМодуль("Обработки.ЗагрузкаКурсовВалют");
		МодульЗагрузкаКурсовВалют.ПриДобавленииКлассификаторов(Классификаторы);
	КонецЕсли;

	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КалендарныеГрафики") Тогда
		МодульКалендарныеГрафики = ОбщегоНазначения.ОбщийМодуль("КалендарныеГрафики");
		МодульКалендарныеГрафики.ПриДобавленииКлассификаторов(Классификаторы);
	КонецЕсли;

	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация")
		И Метаданные.ОбщиеМодули.Найти("РаботаСАдресами") <> Неопределено Тогда
		МодульРаботаСАдресами = ОбщегоНазначения.ОбщийМодуль("РаботаСАдресами");
		МодульРаботаСАдресами.ПриДобавленииКлассификаторов(Классификаторы);
	КонецЕсли;

КонецПроцедуры

// См. РаботаСКлассификаторамиПереопределяемый.ПриЗагрузкеКлассификатора.
Процедура ПриЗагрузкеКлассификатора(Идентификатор, Версия, Адрес, Обработан, ДополнительныеПараметры) Экспорт

	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Банки") Тогда
		МодульЗагрузкаКлассификатораБанков = ОбщегоНазначения.ОбщийМодуль("Обработки.ЗагрузкаКлассификатораБанков");
		МодульЗагрузкаКлассификатораБанков.ПриЗагрузкеКлассификатора(Идентификатор, Версия, Адрес, Обработан,
			ДополнительныеПараметры);
	КонецЕсли;

	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Валюты") Тогда
		МодульЗагрузкаКурсовВалют = ОбщегоНазначения.ОбщийМодуль("Обработки.ЗагрузкаКурсовВалют");
		МодульЗагрузкаКурсовВалют.ПриЗагрузкеКлассификатора(Идентификатор, Версия, Адрес, Обработан,
			ДополнительныеПараметры);
	КонецЕсли;

	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КалендарныеГрафики") Тогда
		МодульКалендарныеГрафики = ОбщегоНазначения.ОбщийМодуль("КалендарныеГрафики");
		МодульКалендарныеГрафики.ПриЗагрузкеКлассификатора(Идентификатор, Версия, Адрес, Обработан,
			ДополнительныеПараметры);
	КонецЕсли;

	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация")
		И Метаданные.ОбщиеМодули.Найти("РаботаСАдресами") <> Неопределено Тогда
		МодульРаботаСАдресами = ОбщегоНазначения.ОбщийМодуль("РаботаСАдресами");
		МодульРаботаСАдресами.ПриЗагрузкеКлассификатора(Идентификатор, Версия, Адрес, Обработан,
			ДополнительныеПараметры);
	КонецЕсли;

КонецПроцедуры

// См. РаботаСКлассификаторамиВМоделиСервисаПереопределяемый.ПриОбработкеОбластиДанных.
Процедура ПриОбработкеОбластиДанных(Идентификатор, Версия, ДополнительныеПараметры) Экспорт

	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КалендарныеГрафики") Тогда
		Возврат;
	КонецЕсли;

	МодульКалендарныеГрафики = ОбщегоНазначения.ОбщийМодуль("КалендарныеГрафики");
	Если Идентификатор <> МодульКалендарныеГрафики.ИдентификаторКлассификатора() Тогда
		Возврат;
	КонецЕсли;

	Если Не ДополнительныеПараметры.Свойство(Идентификатор) Тогда
		Возврат;
	КонецЕсли;

	ПараметрыОбновления = ДополнительныеПараметры[Идентификатор];

	МодульКалендарныеГрафики.ЗаполнитьДанныеЗависимыеОтПроизводственныхКалендарей(ПараметрыОбновления.ТаблицаИзменений);

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти