
#Область ПрограммныйИнтерфейс

// Возвращает транспортные модули по отбору.
//
// Параметры:
//  Отбор - Структура - отбор.
// 
// Возвращаемое значение:
//  Массив - транспортные модули.
//
Функция ДоступныеТранспортныеМодули(Отбор = Неопределено) Экспорт
	
	ДоступныйТранспорт = ТранспортМДЛПАПИВызовСервера.ДоступныеТранспортныеМодули(Отбор);
	Возврат ДоступныйТранспорт;
	
КонецФункции

// Отправляет сообщение через транспортный модуль.
//
// Параметры:
//  ТранспортныйМодуль - Структура - транспортный модуль, через который нужно отправить сообщение.
//  Сообщение          - Строка - отправляемое сообщение.
// 
// Возвращаемое значение:
//  Структура - результат отправки сообщения.
//
Функция ОтправитьСообщение(ТранспортныйМодуль, Сообщение) Экспорт
	
	МенеджерОбмена = ОбщегоНазначения.ОбщийМодуль(ТранспортныйМодуль.МенеджерОбменаНаСервере);
	Возврат МенеджерОбмена.ОтправитьСообщение(ТранспортныйМодуль.ПараметрыПодключения, Сообщение);
	
КонецФункции

// Получает входящие сообщения через транспортный модуль.
//
// Параметры:
//  ТранспортныйМодуль - Структура - транспортный модуль, через который нужно получить сообщения.
// 
// Возвращаемое значение:
//  Полученные сообщения.
//
Функция ПолучитьВходящиеСообщения(ТранспортныйМодуль) Экспорт
	
	МенеджерОбмена = ОбщегоНазначения.ОбщийМодуль(ТранспортныйМодуль.МенеджерОбменаНаСервере);
	Возврат МенеджерОбмена.ПолучитьВходящиеСообщения(ТранспортныйМодуль.ПараметрыПодключения);
	
КонецФункции

#КонецОбласти
