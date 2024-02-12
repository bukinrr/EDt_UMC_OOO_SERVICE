#Область ПрограммныйИнтерфейс

// Процедура осуществляет печать документа. Можно направить печать на
//  экран или принтер, а также распечатать необходмое количество копий.
//  
//  Название макета печати передается в качестве параметра,
//  по переданному названию находим имя макета в соответствии.
//
// Параметры:
//  СсылкаНаОбъект			 - ЛюбаяСсылка	 - ссылка на объект, печать окторого требуется выполнить.
//  ИмяМакета				 - Строка		 - название макета.
//  КоличествоЭкземпляров	 - Число		 - экземпляров.
//  НаПринтер				 - Булево		 - печатать ли сразу на принтер без просмотра.
//
Процедура Печать(СсылкаНаОбъект, ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт
		
	// Общий случай
	#Если Клиент Тогда
	ФормаТиповыхПечатныхФорм = СсылкаНаОбъект.ПолучитьФорму("ТиповыеПечатныеФормы");
	
	// Получить экземпляр документа на печать.
	ТабДокумент = ФормаТиповыхПечатныхФорм.Печать(СсылкаНаОбъект, ИмяМакета);
	
	УниверсальныеМеханизмыСервер.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ОбщегоНазначения.СформироватьЗаголовокДокумента(СсылкаНаОбъект, СсылкаНаОбъект.Метаданные().Представление()), СсылкаНаОбъект);
	#КонецЕсли	
	
КонецПроцедуры

// Возвращает доступные варианты печати документа.
//
// Параметры:
//  МенеджерТипа - ДокументМенеджер	 - менеджер объекта конфигурации.
// 
// Возвращаемое значение:
//  Структура - Струткура, каждая строка которой соответствует одному из вариантов печати.
//
Функция ПолучитьСтруктуруПечатныхФорм(МенеджерТипа) Экспорт
	
	#Если Клиент Тогда
	ФормаТиповыхПечатныхФорм = МенеджерТипа.ПолучитьФорму("ТиповыеПечатныеФормы");
	СтруктураПечатныхФорм = ФормаТиповыхПечатныхФорм.ПолучитьСтруктуруПечатныхФорм();
	
	Возврат СтруктураПечатныхФорм;
	#Иначе
	Возврат Новый Структура();
	#КонецЕсли	

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

// Формирует описание характеристик ТМЦ для печати.
//
// Параметры:
//  Выборка  – ВыборкаИзРезультатаЗапроса – Исходные данные
//
// Возвращаемое значение:
//   Строка - Описание серий и характеристик ТМЦ.
//
Функция ПредставлениеХарактеристик(Выборка) Экспорт

	Результат = "(";

	Если ЗначениеЗаполнено(Выборка.Характеристика) Тогда
		Результат = Результат + СокрЛП(Выборка.Характеристика);
	КонецЕсли;

	Результат = Результат + ")";

	Возврат ?(Результат = "()", "", " " + Результат)

КонецФункции

#КонецОбласти