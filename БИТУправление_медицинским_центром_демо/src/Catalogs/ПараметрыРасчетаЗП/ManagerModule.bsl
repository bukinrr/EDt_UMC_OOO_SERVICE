#Область ПрограммныйИнтерфейс

// Выполнияет расчет алгоритма параметра расчета.
//
// Параметры:
//  ПараметрРасчета		 - Стурктура - параметры расчета.
//  ПарамерыВычисления	 - Стурктура - значения параметров контекста алгоритма.
//  ПроизошлаОшибка		 - Булево	 - признак ошибки
// 
// Возвращаемое значение:
//  Число.
//
Функция ВыполнитьРасчетАлгоритмаПараметраРасчета(ПараметрРасчета, ПарамерыВычисления, ПроизошлаОшибка = Ложь) Экспорт
	
	Перем Сотрудник, НачалоПериода, КонецПериода, Документ;
	
	ПарамерыВычисления.Свойство("Сотрудник",	Сотрудник);
	ПарамерыВычисления.Свойство("НачалоПериода",НачалоПериода);
	ПарамерыВычисления.Свойство("КонецПериода",	КонецПериода);
	ПарамерыВычисления.Свойство("Документ",		Документ);
	
	Результат = 0;
	
	Попытка
		Выполнить(ПараметрРасчета.АлгоритмРасчета);
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
		ПроизошлаОшибка = Истина;
	КонецПопытки;
	
	Возврат Результат
	
КонецФункции
#КонецОбласти