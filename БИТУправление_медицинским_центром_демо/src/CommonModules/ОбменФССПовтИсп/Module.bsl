#Область ПрограммныйИнтерфейс

// Получить WSОпределения из XSD-типов веб-сервиса ФСС.
//
// Параметры:
//  АдресWSDL	 - Строка - адрес сервиса ФСС.
// 
// Возвращаемое значение:
//  WSОпределения.
//
Функция ВнутренняяWSОпределения(Знач АдресWSDL) Экспорт
	
	Возврат WSСсылки.FSS.ПолучитьWSОпределения();
	
КонецФункции

#КонецОбласти
