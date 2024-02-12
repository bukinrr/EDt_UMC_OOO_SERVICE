////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа с файлами".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Позволяет переопределить справочники хранения файлов по типам владельцев.
// 
// Параметры:
//  ТипВладелецФайла  - Тип - тип ссылки объекта, к которому добавляется файл.
//
//  ИменаСправочников - Соответствие - содержит в ключах имена справочников.
//                      При вызове содержит стандартное имя одного справочника,
//                      помеченного, как основной (если существует).
//                      Основной справочник используется для интерактивного
//                      взаимодействия с пользователем. Чтобы указать основной
//                      справочник, нужно установить Истина в значение соответствия.
//                      Если установить Истина более одного раза, тогда будет ошибка.
//
Процедура ПриОпределенииСправочниковХраненияФайлов(ТипВладелецФайла, ИменаСправочников) Экспорт
	
КонецПроцедуры

#КонецОбласти

