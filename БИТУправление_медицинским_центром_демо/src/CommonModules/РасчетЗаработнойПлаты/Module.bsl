#Область ПрограммныйИнтерфейс

// Возвращает количество параметров расчета вида начисления
//
// Параметры:
//  ВидНачисления	 - ПланыВидовРасчетаСсылка.ВидыНачислений	 - вид начисления.
// 
// Возвращаемое значение:
//  Число. 
//
Функция ПолучитьЧислоПараметровВидаНачисления(ВидНачисления) Экспорт
	
	ФормулаРасчета = ВидНачисления.ФормулаРасчета;
	Если	Не ЗначениеЗаполнено(ФормулаРасчета) Тогда
		ЧислоПараметров = 0;
	ИначеЕсли	ФормулаРасчета = Перечисления.ФормулыРасчетаЗаработнойПлаты.ФиксированнаяСумма
		    ИЛИ ФормулаРасчета = Перечисления.ФормулыРасчетаЗаработнойПлаты.МинимальныйОклад Тогда
		ЧислоПараметров = 1;
	ИначеЕсли	ФормулаРасчета = Перечисления.ФормулыРасчетаЗаработнойПлаты.Процент
			ИЛИ ФормулаРасчета = Перечисления.ФормулыРасчетаЗаработнойПлаты.Произведение
			ИЛИ ФормулаРасчета = Перечисления.ФормулыРасчетаЗаработнойПлаты.Разность
			ИЛИ ФормулаРасчета = Перечисления.ФормулыРасчетаЗаработнойПлаты.Деление
	Тогда
		ЧислоПараметров = 2;
	Иначе
		ЧислоПараметров = 3;
	КонецЕсли;
	
	Возврат ЧислоПараметров;
	
КонецФункции

// Оценивает значение по шкале. В составе шкалы ищется первая строка, включающая оцениваемое значение
//  и возвращается соответсвующее ей значение.
//
// Параметры:
//  ОцениваемоеЗначение	 - Число			 - значение, проверяемое по условиям состава шкалы
//  Шкала				 - СправочникСсылка.ШкалыРасчета - ссылка на шкалу оценки.
// 
// Возвращаемое значение:
//   Число.
//
Функция ОценитьЗначениеПоШкале(ОцениваемоеЗначение, Шкала) Экспорт
	
	Результат = 0;
	
	Если ТипЗнч(Шкала) = Тип("СправочникСсылка.ШкалыРасчета")
		И ТипЗнч(ОцениваемоеЗначение) = Тип("Число")
	Тогда
		// Перебор строк шкалы в поисках первой подходящей.
		Для Каждого СтрокаШкалы Из Шкала.СоставШкалы Цикл
			Если ОцениваемоеЗначение >= СтрокаШкалы.ЗначениеС 
			   И (ОцениваемоеЗначение <= СтрокаШкалы.ЗначениеПо Или СтрокаШкалы.ЗначениеПо = 0)
			Тогда
				Результат = СтрокаШкалы.Размер;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Формирует таблицу данных табеля сотрудинка за период.
//
// Параметры:
//  ДатаНачала		 - Дата - дата начала периода
//  ДатаОкончания	 - Дата - дата конца периода
//  Сотрудники		 - СправочникСсылка.Сотрудники	 - сотрудник.
//  Филиал			 - СправочникСсылка.Филиалы		 - филиал расчета.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - .
//
Функция ПолучитьДанныеТабеляСотрудинков(ДатаНачала, ДатаОкончания, Сотрудники, Филиал = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТабельУчетаРабочегоВремени.Сотрудник КАК Сотрудник,
	|	ТабельУчетаРабочегоВремени.День КАК День,
	|	ВЫРАЗИТЬ(ТабельУчетаРабочегоВремени.Часы КАК ЧИСЛО) КАК КоличествоЧасовПоТабелю,
	|	ТабельУчетаРабочегоВремени.Дней КАК КоличествоДнейПоТабелю
	|ИЗ
	|	РегистрСведений.ТабельУчетаРабочегоВремени КАК ТабельУчетаРабочегоВремени
	|ГДЕ
	|	ТабельУчетаРабочегоВремени.День >= &ДатаНачала
	|	И ТабельУчетаРабочегоВремени.День <= &ДатаОкончания
	|	И ТабельУчетаРабочегоВремени.Сотрудник В ИЕРАРХИИ(&Сотрудники)
	|	И (&Филиал = НЕОПРЕДЕЛЕНО
	|			ИЛИ ТабельУчетаРабочегоВремени.Филиал = &ПустойФилиал
	|			ИЛИ ТабельУчетаРабочегоВремени.Филиал = &Филиал)";
	
	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", КонецДня(ДатаОкончания));
	Запрос.УстановитьПараметр("Сотрудники", Сотрудники);
	Запрос.УстановитьПараметр("Филиал", Филиал);
	Запрос.УстановитьПараметр("ПустойФилиал", Справочники.Филиалы.ПустаяСсылка());
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Возврат Результат;
	
КонецФункции	

// Возвращает значние дополнительного параметра з/п по переданной структуре параметров для расчета базы начисления з/п.
//
// Параметры:
//  ПараметрыВычисления - Структура - структура параметров для расчета/поиска значения дополнительного параметра.
// 
// Возвращаемое значение:
//   Число.
//
Функция ПолучитьЗначениеДополнительногоПараметра(ПараметрыВычисления) Экспорт
	
	ПараметрРасчета = ПараметрыВычисления.ПараметрРасчета;
	
	Если ПараметрРасчета.ТипПараметра = Перечисления.ТипыПараметровРасчетаЗарплаты.ПроизвольныйАлгоритм Тогда
		
		Возврат Справочники.ПараметрыРасчетаЗП.ВыполнитьРасчетАлгоритмаПараметраРасчета(ПараметрРасчета, ПараметрыВычисления);
		
	ИначеЕсли ПараметрРасчета.ТипПараметра = Перечисления.ТипыПараметровРасчетаЗарплаты.РучноеЗаполнение Тогда
		Возврат ПолучитьЗначениеПараметраРасчетаВводимогоВручную(ПараметрРасчета, ПараметрыВычисления.Сотрудник, НачалоМесяца(ПараметрыВычисления.НачалоПериода));
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьЗначениеПараметраРасчетаВводимогоВручную(ПараметрРасчета, Сотрудник, Месяц)
	
	Запись = РегистрыСведений.ЗначенияПараметровНачислений.СоздатьМенеджерЗаписи();
	Запись.Месяц = НачалоМесяца(Месяц);
	Запись.ПараметрРасчета = ПараметрРасчета;
	Запись.Сотрудник = Сотрудник;
	Запись.Прочитать();
	Если Запись.Выбран() Тогда
		Возврат Запись.Значение;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

#КонецОбласти