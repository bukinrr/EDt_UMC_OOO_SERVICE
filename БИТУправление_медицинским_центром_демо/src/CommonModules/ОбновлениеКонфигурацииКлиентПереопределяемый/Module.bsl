#Область ПрограммныйИнтерфейс

// Обработчик события перехода по страница помощника обновления.
//
// Параметры
//  ПредыдущаяСтраница  - Строка - имя страницы помощника.
//  СледующаяСтраница   - Строка - имя страницы помощника.
//  Отказ               - Булево - если записать значение Истина, то переход на 
//                                 страницу СледующаяСтраница не произойдет. 
//                                 По умолчанию, значение Ложь.
Процедура ПриПереходеНаСтраницуПомощника(ПредыдущаяСтраница, СледующаяСтраница, Отказ) Экспорт
	
КонецПроцедуры

// Обработчик вызывается перед завершением работы системы при обновлении конфигурации из помощника.
//
// Пример реализации:
// #Если Клиент Тогда
// 		  глЗапрашиватьПодтверждениеПриЗакрытии = Ложь;
// #КонецЕсли.
//
Процедура ПередЗавершениемРаботыСистемы() Экспорт
	
КонецПроцедуры

// Проверить, что информационную базу можно обновить.
// Например, если выясняется, что обновление конфигурации не пройдет или 
// будет идти с проблемами, то пользователю выдается предупреждение, и 
// предлагается самостоятельно устранить причины, после чего 
// повторить попытку обновления.
//
// Параметры:
// 	ВыдаватьСообщения – Булево – определяет, может ли функция выводить 
//                               сообщения/диалоги или от нее требуется вернуть только результат проверки.
// Возвращаемое значение:
// 	Булево – признак готовности ИБ к проведению обновления.
//
// Пример реализации:
// 
// 	Результат = ПроверитьКорректностьДанных();
// 	Если НЕ Результат И ВыдаватьСообщения Тогда
// 		Предупреждение("Конфигурация не может быть обновлена, так как ...");
// 	КонецЕсли; 
// 	Возврат Результат;.
Функция ГотовностьКОбновлениюКонфигурации(Знач ВыдаватьСообщения) Экспорт
	Возврат Истина;	// результат по умолчанию
КонецФункции

// Определить, поставляются ли для данной конфигурации обновления на ИТС.
//
// Возвращаемое значение:
//   Булево   - признак того, что обновления поставляются на диске ИТС.
//
Функция ИспользоватьОбновлениеСДискаИТС() Экспорт
	Возврат Ложь; // значение по умолчанию 
КонецФункции 

// Получить адрес веб-страницы с информацией о том, как получить доступ к 
// пользовательскому разделу на сайте поставщика конфигурации.
//
// Возвращаемое значение:
//   Строка   – адрес веб-страницы.
//
// Пример реализации:
// 	Возврат "http://users.v8.1c.ru/Rules.aspx"; // для типовых конфигураций.
//
Функция АдресСтраницыИнформацииОПолученииДоступаКПользовательскомуСайту() Экспорт
	
	// _Демо начало примера
	Возврат "http://users.v8.1c.ru/Rules.aspx";
	// _Демо конец примера
	
	Возврат "";
	
КонецФункции

#КонецОбласти
