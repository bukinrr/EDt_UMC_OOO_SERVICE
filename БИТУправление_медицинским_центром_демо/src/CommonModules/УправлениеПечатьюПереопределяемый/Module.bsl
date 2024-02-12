///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет объекты конфигурации, в модулях менеджеров которых размещена процедура ДобавитьКомандыПечати,
// формирующая список команд печати, предоставляемых этим объектом.
// Синтаксис процедуры ДобавитьКомандыПечати см. в документации к подсистеме.
//
// Параметры:
//  СписокОбъектов - Массив - менеджеры объектов с процедурой ДобавитьКомандыПечати.
//
Процедура ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов) Экспорт
	
	СписокОбъектов.Добавить(Документы.ОказаниеУслуг);
	
КонецПроцедуры

Процедура ПриПолученииКомандПечатиОбъекта(КомандыПечати, СведенияОбОбъекте, ДобавлятьДополнительные) Экспорт
	мсИмяФормы	= СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СведенияОбОбъекте.ПолноеИмя,".");
	ТипОбъекта = мсИмяФормы[0];
	ИмяОбъекта	= мсИмяФормы[1];
	ЭтоДокумент = ТипОбъекта = "Документ";
	Если ЭтоДокумент Тогда
		ПустаяСсылка = Документы[ИмяОбъекта].ПустаяСсылка();
	ИначеЕсли ТипОбъекта = "Справочник" Тогда
		ПустаяСсылка = Справочники[ИмяОбъекта].ПустаяСсылка();
	КонецЕсли; 
	
	ДеревоМакетов = УниверсальныеМеханизмыСервер.ПолучитьДеревоМакетовПечати(ПустаяСсылка, ПечатьДокументовСервер.ПолучитьСтруктуруПечатныхФормСервер(ПустаяСсылка.Метаданные().Имя, ТипОбъекта),,,Ложь);
	Для каждого Строка из ДеревоМакетов.Строки Цикл
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Представление = Строка.Текст;
		Если ЗначениеЗаполнено(Строка.СсылкаНаВнешнююОбработку) Тогда
			КомандаПечати.Идентификатор = Строка.СсылкаНаВнешнююОбработку;
		Иначе
			КомандаПечати.Идентификатор = Строка.Имя;
			КонецЕсли;
		КомандаПечати.ПроверкаПроведенияПередПечатью = ЭтоДокумент;
	КонецЦикла;	
	
	//СведенияОбОбъекте.Менеджер.ДобавитьКомандыПечати(КомандыПечати);
	//Если ДобавлятьДополнительные И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки") Тогда
	//	МодульДополнительныеОтчетыИОбработки = ОбщегоНазначения.ОбщийМодуль("ДополнительныеОтчетыИОбработки");
	//	МодульДополнительныеОтчетыИОбработки.ПриПолученииКомандПечати(КомандыПечати, СведенияОбОбъекте.ПолноеИмя);
	//КонецЕсли;
	ДобавленныеКоманды = КомандыПечати.НайтиСтроки(Новый Структура("Обработана", Ложь));
	Для Каждого Команда Из ДобавленныеКоманды Цикл
		Если Не ЗначениеЗаполнено(Команда.МенеджерПечати) Тогда
			Команда.МенеджерПечати = СведенияОбОбъекте.ПолноеИмя;
		КонецЕсли;
		Если Команда.ТипыОбъектовПечати.Количество() = 0 Тогда
			Если ТипЗнч(СведенияОбОбъекте.ТипСсылкиДанных) = Тип("ОписаниеТипов") Тогда
				Команда.ТипыОбъектовПечати = СведенияОбОбъекте.ТипСсылкиДанных.Типы();
			ИначеЕсли ТипЗнч(СведенияОбОбъекте.ТипСсылкиДанных) = Тип("Тип") Тогда
				Команда.ТипыОбъектовПечати.Добавить(СведенияОбОбъекте.ТипСсылкиДанных);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

// Дополнительные настройки списка команд печати в журналах документов.
//
// Параметры:
//  НастройкиСписка - Структура - модификаторы списка команд печати.
//   * МенеджерКомандПечати     - МенеджерОбъекта - менеджер объекта, в котором формируется список команд печати;
//   * АвтоматическоеЗаполнение - Булево - заполнять команды печати из объектов, входящих в состав журнала.
//                                         Если установлено значение Ложь, то список команд печати журнала будет
//                                         заполнен вызовом метода ДобавитьКомандыПечати из модуля менеджера журнала.
//                                         Значение по умолчанию: Истина - метод ДобавитьКомандыПечати будет вызван из
//                                         модулей менеджеров документов, входящих в состав журнала.
Процедура ПриПолученииНастроекСпискаКомандПечати(НастройкиСписка) Экспорт
	
КонецПроцедуры

// Вызывается после завершения вызова процедуры Печать менеджера печати объекта, имеет те же параметры.
// Может использоваться для постобработки всех печатных форм при их формировании.
// Например, можно вставить в колонтитул дату формирования печатной формы.
//
// Параметры:
//  МассивОбъектов - Массив - список объектов, для которых была выполнена процедура Печать;
//  ПараметрыПечати - Структура - произвольные параметры, переданные при вызове команды печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - содержит табличные документы и дополнительную информацию;
//  ОбъектыПечати - СписокЗначений - соответствие между объектами и именами областей в табличных документах, где
//                                   значение - Объект, представление - имя области с объектом в табличных документах;
//  ПараметрыВывода - Структура - параметры, связанные с выводом табличных документов:
//   * ПараметрыОтправки - Структура - информация для заполнения письма при отправке печатной формы по электронной почте.
//                                     Содержит следующие поля (описание см. в общем модуле конфигурации
//                                     РаботаСПочтовымиСообщениямиКлиент в процедуре СоздатьНовоеПисьмо):
//    ** Получатель;
//    ** Тема,
//    ** Текст.
Процедура ПриПечати(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	
	
КонецПроцедуры

// Переопределяет параметры отправки печатных форм при подготовке письма.
// Может использоваться, например, для подготовки текста письма.
//
// Параметры:
//  ПараметрыОтправки - Структура - коллекция параметров:
//   * Получатель - Массив - коллекция имен получателей;
//   * Тема - Строка - тема письма;
//   * Текст - Строка - текст письма;
//   * Вложения - Структура - коллекция вложений:
//    ** АдресВоВременномХранилище - Строка - адрес вложения во временном хранилище;
//    ** Представление - Строка - имя файла вложения.
//  ОбъектыПечати - Массив - коллекция объектов, по которым сформированы печатные формы.
//  ПараметрыВывода - Структура - параметр ПараметрыВывода в вызове процедуры Печать.
//  ПечатныеФормы - ТаблицаЗначений - коллекция табличных документов:
//   * Название - Строка - название печатной формы;
//   * ТабличныйДокумент - ТабличныйДокумент - печатая форма.
Процедура ПередОтправкойПоПочте(ПараметрыОтправки, ПараметрыВывода, ОбъектыПечати, ПечатныеФормы) Экспорт
	
КонецПроцедуры

#КонецОбласти
