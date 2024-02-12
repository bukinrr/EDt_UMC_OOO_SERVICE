#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Возвращает имя поля из доступных полей компоновки данных.
//
// Параметры:
//  ИмяПоля - Строка.
//
// Возвращаемое значение:
//  Строка.
//
Функция ИмяПоляВШаблоне(Знач ИмяПоля) Экспорт
	
	ИмяПоля = СтрЗаменить(ИмяПоля, ".DeletionMark", ".ПометкаУдаления");
	ИмяПоля = СтрЗаменить(ИмяПоля, ".Owner", ".Владелец");
	ИмяПоля = СтрЗаменить(ИмяПоля, ".Code", ".Код");
	ИмяПоля = СтрЗаменить(ИмяПоля, ".Parent", ".Родитель");
	ИмяПоля = СтрЗаменить(ИмяПоля, ".Predefined", ".Предопределенный");
	ИмяПоля = СтрЗаменить(ИмяПоля, ".IsFolder", ".ЭтоГруппа");
	ИмяПоля = СтрЗаменить(ИмяПоля, ".Description", ".Наименование");
	Возврат ИмяПоля;
	
КонецФункции

// Получает массивы реквизитов зависимых от реквизита типа шаблона.
// Параметры:
// 	Объект - СправочникСсылка.Шаблоны - шаблоны этикеток и ценников, Элемент правочника для которого устанавливаем
//                    доступные реквизиты
// 	МассивВсехРеквизитов - Неопределено - Выходной параметр с типом Массив в который будут помещены имена всех
//                                                 реквизитов справочника
// 	МассивРеквизитов - Неопределено - Выходной параметр с типом Массив в который будут помещены имена
//                                                     реквизитов справочника
//
Процедура ЗаполнитьИменаРеквизитовПоТипуШаблона(Объект, МассивВсехРеквизитов, МассивРеквизитов) Экспорт
	
	МассивВсехРеквизитов = Новый Массив;
	МассивВсехРеквизитов.Добавить("Наименование");
	МассивВсехРеквизитов.Добавить("ТипШаблона");
	МассивВсехРеквизитов.Добавить("ОбъектМетаданных");
	
	МассивРеквизитов = Новый Массив;
	МассивРеквизитов.Добавить("Наименование");
	МассивРеквизитов.Добавить("ТипШаблона");
	
	Если Объект.ТипШаблона = Перечисления.ТипыШаблонов.ПустаяСсылка()
	Тогда
		МассивРеквизитов.Добавить("ОбъектМетаданных");
	КонецЕсли;
	
КонецПроцедуры
#КонецОбласти

#КонецЕсли

#Область СлужебныйПрограммныйИнтерфейс

Функция ПозицииПараметров(ТекстЯчейки)
	
	Массив = Новый Массив;
	
	Начало = -1;
	Конец  = -1;
	СчетчикСкобокОткрывающих = 0;
	СчетчикСкобокЗакрывающих = 0;
	
	Для Индекс = 1 По СтрДлина(ТекстЯчейки) Цикл
		Симв = Сред(ТекстЯчейки, Индекс, 1);
		Если Симв = "[" Тогда
			СчетчикСкобокОткрывающих = СчетчикСкобокОткрывающих + 1;
			Если СчетчикСкобокОткрывающих = 1 Тогда
				Начало = Индекс;
			КонецЕсли;
		ИначеЕсли Симв = "]" Тогда
			СчетчикСкобокЗакрывающих = СчетчикСкобокЗакрывающих + 1;
			Если СчетчикСкобокЗакрывающих = СчетчикСкобокОткрывающих Тогда
				Конец = Индекс;
				
				Массив.Добавить(Новый Структура("Начало, Конец", Начало, Конец));
				
				Начало = -1;
				Конец  = -1;
				СчетчикСкобокОткрывающих = 0;
				СчетчикСкобокЗакрывающих = 0;
				
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Массив;
	
КонецФункции

// Функция СтруктураМакетаШаблона
//
// Параметры:
//  ДанныеШаблона - Структура.
//
// Возвращаемое значение:
//  Структура.
//
Функция СтруктураМакетаШаблона(ДанныеШаблона) Экспорт
	
	ПолеТабличногоДокумента = ДанныеШаблона.ПолеТабличногоДокумента;
	
	СтруктураМакетаШаблона = Новый Структура;
	ПараметрыШаблона       = Новый Соответствие;
	СчетчикПараметров      = 0;
	ПрефиксИмениПараметра  = "ПараметрМакета";
	
	ОбластьМакетаЭтикетки = ПолеТабличногоДокумента.ПолучитьОбласть();
	
	// Копирование настроек табличного документа.
	ЗаполнитьЗначенияСвойств(ОбластьМакетаЭтикетки, ПолеТабличногоДокумента);
	
	Для НомерКолонки = 1 По ОбластьМакетаЭтикетки.ШиринаТаблицы Цикл
		
		Для НомерСтроки = 1 По ОбластьМакетаЭтикетки.ВысотаТаблицы Цикл
			
			Ячейка = ОбластьМакетаЭтикетки.Область(НомерСтроки, НомерКолонки);
			Если Ячейка.Заполнение = ТипЗаполненияОбластиТабличногоДокумента.Шаблон Тогда
				
				МассивПараметров = ПозицииПараметров(Ячейка.Текст);
				
				КоличествоПараметров = МассивПараметров.Количество();
				Для Индекс = 0 По КоличествоПараметров - 1 Цикл
					
					Структура = МассивПараметров[КоличествоПараметров - 1 - Индекс];
					
					ИмяПараметра = Сред(Ячейка.Текст, Структура.Начало + 1, Структура.Конец - Структура.Начало - 1);
					Если Найти(ИмяПараметра, ПрефиксИмениПараметра) = 0 Тогда
						
						ЛеваяЧасть = Лев(Ячейка.Текст, Структура.Начало);
						ПраваяЧасть = Прав(Ячейка.Текст, СтрДлина(Ячейка.Текст) - Структура.Конец+1);
						
						СохраненноеИмяПараметраМакета = ПараметрыШаблона.Получить(ИмяПараметра);
						Если СохраненноеИмяПараметраМакета = Неопределено Тогда
							СчетчикПараметров = СчетчикПараметров + 1;
							Ячейка.Текст = ЛеваяЧасть + (ПрефиксИмениПараметра + СчетчикПараметров) + ПраваяЧасть;
							ПараметрыШаблона.Вставить(ИмяПараметра, ПрефиксИмениПараметра + СчетчикПараметров);
						Иначе
							Ячейка.Текст = ЛеваяЧасть + (СохраненноеИмяПараметраМакета) + ПраваяЧасть;
						КонецЕсли;
						
					КонецЕсли;
				КонецЦикла;
				
			ИначеЕсли Ячейка.Заполнение = ТипЗаполненияОбластиТабличногоДокумента.Параметр Тогда
				
				Если Найти(Ячейка.Параметр, ПрефиксИмениПараметра) = 0 Тогда
					СохраненноеИмяПараметраМакета = ПараметрыШаблона.Получить(Ячейка.Параметр);
					Если СохраненноеИмяПараметраМакета = Неопределено Тогда
						СчетчикПараметров = СчетчикПараметров + 1;
						ПараметрыШаблона.Вставить(Ячейка.Параметр, ПрефиксИмениПараметра + СчетчикПараметров);
						Ячейка.Параметр = ПрефиксИмениПараметра + СчетчикПараметров;
					Иначе
						Ячейка.Параметр = СохраненноеИмяПараметраМакета;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	// Вставляем в параметры штрихкод.
	Если ПараметрыШаблона.Получить(ИмяПараметраШтрихкод()) = Неопределено Тогда
		Для Каждого Рисунок Из ОбластьМакетаЭтикетки.Рисунки Цикл
			Если Лев(Рисунок.Имя,8) = ИмяПараметраШтрихкод() Тогда
				ПараметрыШаблона.Вставить(ИмяПараметраШтрихкод(), ПрефиксИмениПараметра + (СчетчикПараметров+1));
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Заменяем на пустую картинку.
	Для Каждого Рисунок Из ОбластьМакетаЭтикетки.Рисунки Цикл
		Если Лев(Рисунок.Имя,8) = ИмяПараметраШтрихкод() Тогда
			Рисунок.Картинка = Новый Картинка;
		КонецЕсли;
	КонецЦикла;
	
	СтруктураМакетаШаблона.Вставить("МакетЭтикетки"              , ОбластьМакетаЭтикетки);
	СтруктураМакетаШаблона.Вставить("ИмяОбластиПечати"           , ПолеТабличногоДокумента.ОбластьПечати.Имя);
	СтруктураМакетаШаблона.Вставить("ТипКода"                    , 1);
	СтруктураМакетаШаблона.Вставить("ПараметрыШаблона"           , ПараметрыШаблона);
	СтруктураМакетаШаблона.Вставить("РедакторТабличныйДокумент"  , ПолеТабличногоДокумента);
	СтруктураМакетаШаблона.Вставить("ОтображатьТекст"            , ДанныеШаблона.ОтображатьТекст);
	СтруктураМакетаШаблона.Вставить("РазмерШрифта"               , ДанныеШаблона.РазмерШрифта);
	СтруктураМакетаШаблона.Вставить("УголПоворота"               , ДанныеШаблона.УголПоворота);
	Возврат СтруктураМакетаШаблона;
	
КонецФункции

// Функция ИмяПараметраШтрихкод
//
// Возвращаемое значение:
//  Строка.
//
Функция ИмяПараметраШтрихкод() Экспорт
	
	Возврат "Штрихкод";
	
КонецФункции

#КонецОбласти
