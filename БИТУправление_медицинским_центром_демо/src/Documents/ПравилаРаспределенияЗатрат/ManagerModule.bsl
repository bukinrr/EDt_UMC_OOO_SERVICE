#Область ПрограммныйИнтерфейс

// Если в базе есть только одно правило распределения затрат, то возвращает его, иначе пустую ссылку.
//
// Возвращаемое значение:
//	СправочникСсылка.ПравилаРаспределенияЗатрат.
//
Функция ПравилоРаспределенияЗатратНаСпециализацииПоУмолчанию() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 	"ВЫБРАТЬ
					|	ПравилаРаспределенияЗатрат.Ссылка КАК Правило
					|ИЗ
					|	Справочник.ПравилаРаспределенияЗатрат КАК ПравилаРаспределенияЗатрат
					|ГДЕ
					|	НЕ ПравилаРаспределенияЗатрат.ПометкаУдаления";
	тзПравила = Запрос.Выполнить().Выгрузить();
	Если тзПравила.Количество() = 1 Тогда
		Возврат тзПравила[0].Правило; 		
	КонецЕсли;
	
	Возврат Справочники.ПравилаРаспределенияЗатрат.ПустаяСсылка(); 		
	
КонецФункции 

// Процедура ЗаполнитьНовыйДокументПоУмолчанию.
//
// Параметры:
//  ДокументОбъект - ДокументСсылка.ПравилаРаспределенияЗатрат - заполняемый документ.
//
Процедура ЗаполнитьНовыйДокументПоУмолчанию(ДокументОбъект) Экспорт
	
	Если Ложь Тогда ДокументОбъект = Документы.ПравилаРаспределенияЗатрат.СоздатьДокумент() КонецЕсли;
	
	Если ДокументОбъект.Ссылка.Пустая()
		И ДокументОбъект.РаспределениеЗатратФилиаловНаСпециализации.Количество() = 0
		И ДокументОбъект.РаспределениеЗатратСпециализацийНаНоменклатуру.Количество() = 0
	Тогда
		НоваяСтрока = ДокументОбъект.РаспределениеЗатратФилиаловНаСпециализации.Добавить();
		НоваяСтрока.ПравилоРаспределения = ПравилоРаспределенияЗатратНаСпециализацииПоУмолчанию();
		
		НоваяСтрока = ДокументОбъект.РаспределениеЗатратСпециализацийНаНоменклатуру.Добавить();
		НоваяСтрока.СпособРаспределения = Перечисления.СпособРаспределенияЗатрат.ПоСуммеПродаж;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДокументОбъект.ОсновнаяСтатьяЗатратОтраженияЗарплаты) Тогда
		ДокументОбъект.ОсновнаяСтатьяЗатратОтраженияЗарплаты = УправлениеНастройками.ПолучитьПараметрУчетнойПолитики("ОсновнаяСтатьяЗатратЗарплаты");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти