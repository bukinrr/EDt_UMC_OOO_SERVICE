
////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Функция ВсеРоли() возвращает таблицу значений имен всех ролей конфигурации.
//
// Параметры:
// 
// Возвращаемое значение:
//  ТаблицаЗначений
//      Имя         - Строка.
//
Функция ВсеРоли() Экспорт
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Имя", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(1000)));
	
	Для каждого Роль Из Метаданные.Роли Цикл
		Таблица.Добавить().Имя = Роль.Имя;
	КонецЦикла;
	
	Возврат Таблица;
	
КонецФункции

// Функция СинонимыРолей возвращает таблицу значений
// с колонками Роль и РольСиноним, которая формируется
// из метаданных
//
// Возвращаемое значение:
//  ТаблицаЗначений.
//    Роль        - Строка(150)
//    СинонимРоли - Строка(1000).
//
Функция СинонимыРолей() Экспорт
	
	СинонимыРолей = Новый ТаблицаЗначений;
	СинонимыРолей.Колонки.Добавить("Роль",        Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(150)));
	СинонимыРолей.Колонки.Добавить("РольСиноним", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(1000)));
	
	Для каждого Роль Из Метаданные.Роли Цикл
		
		ОписаниеРоли = СинонимыРолей.Добавить();
		ОписаниеРоли.Роль        = Роль.Имя;
		ОписаниеРоли.РольСиноним = Роль.Синоним;
		
	КонецЦикла;
		
	Возврат СинонимыРолей;
	
КонецФункции

// Функция ДеревоРолей возвращает дерево
// ролей с/без подсистем
//  Если роль не принадлежит ни одной подсистеме
// она добавляется "в корень"
// 
// Параметры:
//  ПоПодсистемам - Булево, если ложь, все роли добавляются в "корень"
// 
// Возвращаемое значение:
//  ДеревоЗначений
//    ЭтоРоль       - Булево
//    Имя           - Строка - имя     роли или подсистемы
//    Синоним       - Строка - синоним роли или подсистемы.
//
Функция ДеревоРолей(ПоПодсистемам = Истина) Экспорт
	
	Дерево = Новый ДеревоЗначений;
	Дерево.Колонки.Добавить("ЭтоРоль",       Новый ОписаниеТипов("Булево"));
	Дерево.Колонки.Добавить("Имя",           Новый ОписаниеТипов("Строка"));
	Дерево.Колонки.Добавить("Синоним",       Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(1000)));
	
	Если ПоПодсистемам Тогда
		ЗаполнитьПодсистемыИРоли(Дерево.Строки);
	КонецЕсли;
	
	// Добавление ненайденных ролей
	Для каждого Роль Из Метаданные.Роли Цикл
		Если Дерево.Строки.НайтиСтроки(Новый Структура("ЭтоРоль, Имя", Истина, Роль.Имя), Истина).Количество() = 0 Тогда
			СтрокаДерева = Дерево.Строки.Добавить();
			СтрокаДерева.ЭтоРоль       = Истина;
			СтрокаДерева.Имя           = Роль.Имя;
			СтрокаДерева.Синоним       = ?(ЗначениеЗаполнено(Роль.Синоним), Роль.Синоним, Роль.Имя);
		КонецЕсли;
	КонецЦикла;
	
	Дерево.Строки.Сортировать("ЭтоРоль Убыв, Синоним Возр", Истина);
	
	Возврат Дерево;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры модуля

Процедура ЗаполнитьПодсистемыИРоли(КоллекцияСтрокДерева, Подсистемы = Неопределено)
	
	Если Подсистемы = Неопределено Тогда
		Подсистемы = Метаданные.Подсистемы;
	КонецЕсли;
	
	Для каждого Подсистема Из Подсистемы Цикл
		
		ОписаниеПодсистемы = КоллекцияСтрокДерева.Добавить();
		ОписаниеПодсистемы.Имя           = Подсистема.Имя;
		ОписаниеПодсистемы.Синоним       = ?(ЗначениеЗаполнено(Подсистема.Синоним), Подсистема.Синоним, Подсистема.Имя);
		
		ЗаполнитьПодсистемыИРоли(ОписаниеПодсистемы.Строки, Подсистема.Подсистемы);
		
		Для каждого Роль Из Метаданные.Роли Цикл
			Если Подсистема.Состав.Содержит(Роль) Тогда
				ОписаниеРоли = ОписаниеПодсистемы.Строки.Добавить();
				ОписаниеРоли.ЭтоРоль       = Истина;
				ОписаниеРоли.Имя           = Роль.Имя;
				ОписаниеРоли.Синоним       = ?(ЗначениеЗаполнено(Роль.Синоним), Роль.Синоним, Роль.Имя);
			КонецЕсли;
		КонецЦикла;
		
		Если ОписаниеПодсистемы.Строки.НайтиСтроки(Новый Структура("ЭтоРоль", Истина), Истина).Количество() = 0 Тогда
			КоллекцияСтрокДерева.Удалить(ОписаниеПодсистемы);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

 // Функция ЭтоПолноправныйПользовательИБ проверяет,
// является ли полноправным текущий пользователь ИБ или
// пользователь ИБ заданного пользователя (обычного или внешнего).
//
//  Полноправными считается:
// а) пользователь ИБ при пустом списке пользователей ИБ,
//    если основная роль не задана или ПолныеПрава,
// б) пользователь ИБ с ролью ПолныеПрава.
//
//
// Параметры:
//  Пользователь - Неопределено (проверяется текущий пользователь ИБ),
//                 Справочник.Пользователи, Справочник.ВнешниеПользователи
//                 (осуществляется поиск пользователя ИБ по уникальному
//                  идентификатору, заданному в реквизите ИдентификаторПользователяИБ,
//                  если пользователь ИБ не найден, возвращается Ложь).
//
// Возвращаемое значение:
//  Булево.
//
Функция ЭтоПолноправныйПользовательИБЭЦП(Пользователь = Неопределено) Экспорт
	
	Возврат Ложь;
	
КонецФункции