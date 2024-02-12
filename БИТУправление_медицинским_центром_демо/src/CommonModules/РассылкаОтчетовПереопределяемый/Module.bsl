#Область ПрограммныйИнтерфейс

// Позволяет изменить форматы по умолчанию и установить картинки.
// Для изменения параметров формата смотрите вспомогательный метод РассылкаОтчетов.УстановитьПараметрыФормата.
// Другие примеры использования см. функцию РассылкаОтчетовПовтИсп.СписокФорматов.
//
// Параметры:
//   СписокФорматов - СписокЗначений - Список форматов.
//       * Значение      - ПеречислениеСсылка.ФорматыСохраненияОтчетов - Ссылка формата.
//       * Представление - Строка - Представление формата.
//       * Пометка       - Булево - Признак того, что формат используется по умолчанию.
//       * Картинка      - Картинка - Картинка формата.
//
// Пример:
//	РассылкаОтчетов.УстановитьПараметрыФормата(СписокФорматов, "HTML4", , Ложь);
//	РассылкаОтчетов.УстановитьПараметрыФормата(СписокФорматов, "XLS"  , , Истина);
//
Процедура ПереопределитьПараметрыФорматов(СписокФорматов) Экспорт
	
	
	
КонецПроцедуры

// Позволяет добавить описание кросс объектной связи типов для получателей рассылки.
// Для регистрации параметров типа см. РассылкаОтчетов.ДобавитьЭлементВТаблицуТиповПолучателей.
// Другие примеры использования см. функцию РассылкаОтчетовПовтИсп.ТаблицаТиповПолучателей.
// Важно:
//   Использовать данный механизм требуется только в том случае, если:
//   1. Требуется описать и представить несколько типов как один (как в справочнике Пользователи и Группы
//   пользователей).
//   2. Требуется изменить представление типа без изменения синонима метаданных.
//   3. Требуется указать вид контактной информации E-Mail по умолчанию.
//   4. Требуется определить группу контактной информации.
//
// Параметры:
//   ТаблицаТипов  - ТаблицаЗначений - Таблица описания типов.
//   ДоступныеТипы - Массив - Доступные типы.
//
// Пример:
//	Настройки = Новый Структура;
//	Настройки.Вставить("ОсновнойТип", Тип("СправочникСсылка.Контрагенты"));
//	Настройки.Вставить("ВидКИ", Справочники.ВидыКонтактнойИнформации.EmailКонтрагента);
//	РассылкаОтчетов.ДобавитьЭлементВТаблицуТиповПолучателей(ТаблицаТипов, ДоступныеТипы, Настройки);
//
Процедура ПереопределитьТаблицуТиповПолучателей(ТаблицаТипов, ДоступныеТипы) Экспорт
	ТаблицаТипов.ЗаполнитьЗначения(Справочники.ВидыКонтактнойИнформации.АдресЭлектроннойПочтыРабочий,"ОсновнойВидКИ");	
КонецПроцедуры

// Позволяет определить свой обработчик для сохранения табличного документа в формат.
// Важно:
//   Если используется нестандартная обработка (СтандартнаяОбработка меняется на Ложь),
//   тогда ПолноеИмяФайла должно содержать полное имя файла с расширением.
//
// Параметры:
//   СтандартнаяОбработка - Булево - Признак использования стандартных механизмов подсистемы для сохранения в формат.
//   ТабличныйДокумент    - ТабличныйДокумент - Сохраняемый табличный документ.
//   Формат               - ПеречислениеСсылка.ФорматыСохраненияОтчетов - Формат, в котором сохраняется табличный
//                                                                        документ.
//   ПолноеИмяФайла       - Строка - Полное имя файла.
//       Передается без расширения, если формат был добавлен в прикладной конфигурации.
//
// Пример:
//	Если Формат = Перечисления.ФорматыСохраненияОтчетов.HTML4 Тогда
//		СтандартнаяОбработка = Ложь;
//		ПолноеИмяФайла = ПолноеИмяФайла +".html";
//		ТабличныйДокумент.Записать(ПолноеИмяФайла, ТипФайлаТабличногоДокумента.HTML4);
//	КонецЕсли;
//
Процедура ПередСохранениемТабличногоДокументаВФормат(СтандартнаяОбработка, ТабличныйДокумент, Формат, ПолноеИмяФайла) Экспорт
	
	
	
КонецПроцедуры

// Позволяет определить свой обработчик формирования списка получателей.
//
// Параметры:
//   ПараметрыПолучателей - Структура - Параметры формирования получателей рассылки.
//   Запрос - Запрос - Запрос, который будет использован, если значение параметра СтандартнаяОбработка останется Истина.
//   СтандартнаяОбработка - Булево - Признак использования стандартных механизмов.
//   Результат - Соответствие - Получатели с их E-mail адресами.
//       * Ключ     - СправочникСсылка - Получатель.
//       * Значение - Строка - Набор E-mail адресов в строке с разделителями.
// 
Процедура ПередФормированиемСпискаПолучателейРассылки(ПараметрыПолучателей, Запрос, СтандартнаяОбработка, Результат) Экспорт
	
КонецПроцедуры

// Позволяет исключить отчеты, которые не готовы к интеграции с рассылкой.
//   Указанные отчеты используются в качестве исключающего фильтра при выборе отчетов.
//
// Параметры:
//   ИсключаемыеОтчеты - Массив из ОбъектМетаданных: Отчет - Отчеты, подключенные к хранилищу "ВариантыОтчетов",
//       но не поддерживающие интеграцию с рассылками.
//
Процедура ОпределитьИсключаемыеОтчеты(ИсключаемыеОтчеты) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти
