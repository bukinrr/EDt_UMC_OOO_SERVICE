///////////////////////////////////////////////////////////////////////////////
// Общий клент-серверный модуль телефонии БИТ
// Содержит функции, реализация которых зависит от конфигурации
///////////////////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------------------
// === БИТ.Красота и здоровье ===

// Возвращает строку, имя справочника контрагентов
Функция ПолучитьИмяСправочникаКонтрагентов() Экспорт
	Возврат "Клиенты";
КонецФункции

// Возвращает строку, имя справочника контактных лиц
Функция ПолучитьИмяСправочникаКонтактныхЛиц() Экспорт
	Возврат "Клиенты";
КонецФункции

// Проверяет возможность автозапуска при начале работы системы
Функция ЕстьВозможностьАвтозапуска() Экспорт 
	Возврат бит_ТелефонияСерверПереопределяемый.ЕстьВозможностьАвтозапуска();
КонецФункции

Функция ВремяСтрокойВСекунды(ВремяСтрокой, Разделитель = ":") Экспорт
	
	Секунды = 0;
	Попытка
		Секунды = Дата("00010101" + СтрЗаменить(ВремяСтрокой, Разделитель, "")) - Дата(1,1,1);
	Исключение
		частиДлит = ОбщегоНазначенияКлиентСервер.РазложитьСтрокуВМассивПодстрок(ВремяСтрокой, Разделитель);
		Секунды = Число(частиДлит[2]) + Число(частиДлит[1])*60 + Число(частиДлит[0])*3600;
	КонецПопытки;
	
	Возврат Секунды;
	
КонецФункции