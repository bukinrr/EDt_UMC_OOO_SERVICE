#Область ПрограммныйИнтерфейс

// Настройки UTM-меток для телефона организации.
//
// Параметры:
//  НомерТелефона	 - Строка - номер телефона 
// 
// Возвращаемое значение:
//  Структура - параметры UTM.
//
Функция ПолучитьПараметрыUTM(НомерТелефона) Экспорт
	Возврат РегистрыСведений.ПараметрыUTMПоТелефону.СрезПоследних(ТекущаяДата(), Новый Структура("НомерТелефона", НомерТелефона));
КонецФункции

#КонецОбласти