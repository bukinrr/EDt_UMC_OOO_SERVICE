#Область ПрограммныйИнтерфейс

// При необходимости дополняет массив строковых представлений типов предметов взаимодействий.
// Используется, если в конфигурации определен хотя бы один предмет взаимодействий. Например, заказы, вакансии и т.п.
//
// Параметры:
//  ТипыПредметов  - Массив - массив, в который добавляются строковые представления типов предметов взаимодействий.
//
Процедура ПриОпределенииВозможныхПредметов(ТипыПредметов) Экспорт
	
	
	
КонецПроцедуры

// Дополняет описания возможных типов контактов.
// Используется, если в конфигурации определен хотя бы один тип контактов взаимодействий,
// помимо справочника Пользователи. Например, партнеры, контактные лица и т.п.
//
// Параметры:
//  ТипыКонтактов - Массив - массив структур, в котором описываются возможные типы контактов.
//    Каждая структура содержит описание одного типа контактов и содержит следующие поля:
//       *Тип                                - Тип    - тип ссылки контакта.
//       *ВозможностьИнтерактивногоСоздания  - Булево - признак возможности интерактивного создания контакта из
//                                                      документов - взаимодействий.
//       *Имя                                 - Строка - имя типа контакта , как оно определено в метаданных.
//       *Представление                       - Строка - представление типа контакта для отображения пользователю.
//       *Иерархический                       - Булево - признак того, является ли справочник иерархическим.
//       *ЕстьВладелец                        - Булево - признак того, что у контакта есть владелец.
//       *ИмяВладельца                        - Строка - имя владельца контакта, как оно определено в метаданных.
//       *ИскатьПоДомену                      - Булево - признак того, что по данному типу контакта будет осуществляться
//                                                       поиск по домену.
//       *Связь                               - Строка - описывает возможную связь данного контакта с другим контактом, в
//                                                       случае когда текущий контакт является реквизитом другого контакта.
//                                                       Описывается следующей строкой "ИмяТаблицы.ИмяРеквизита".
//       *ИмяРеквизитаПредставлениеКонтакта   - Строка - имя реквизита контакта, из которого будет получено
//                                                       представление контакта.
//
Процедура ПриОпределенииВозможныхКонтактов(ТипыКонтактов) Экспорт

	

КонецПроцедуры

#КонецОбласти



