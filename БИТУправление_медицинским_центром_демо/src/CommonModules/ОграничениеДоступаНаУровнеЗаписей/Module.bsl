#Область ПрограммныйИнтерфейс

// Установка параметров сеанса.
//
Процедура УстановкаПараметровСеанса() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПараметрыСеанса.ОграничениеДоступаНаУровнеЗаписейВключено = 
		УправлениеНастройками.ПолучитьПараметрУчетнойПолитики("ИспользоватьОграничениеДоступаНаУровнеЗаписей")
		И Не УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(,"НеРаспространятьОграниченияНаУровнеЗаписей"); 
	
	ПараметрыСеанса.ДопускаетсяЗаписьВЖурналЗаписиЧужогоФилиала
		= Не Булево(УправлениеНастройками.ПолучитьПараметрУчетнойПолитики("ЗапретитьАдминистраторуЗаписьКлиентаНеВСвойФилиал"));
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Филиалы.Ссылка
	|ИЗ
	|	Справочник.Филиалы КАК Филиалы"
	;
	ГруппаФилиалов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	ГруппаФилиалов.Добавить(Справочники.Филиалы.ПустаяСсылка());
	ПараметрыСеанса.ГруппаФилиаловПользователя = Новый ФиксированныйМассив(ГруппаФилиалов);
	
	ФилиалПользователя = УправлениеНастройками.ПолучитьФилиалПоУмолчаниюПользователя();
	ФилиалыПользователя = Новый Массив;
	ФилиалыПользователя.Добавить(ФилиалПользователя);
	ФилиалыПользователя.Добавить(Справочники.Филиалы.ПустаяСсылка());
	
	ПараметрыСеанса.ФилиалПользователя = Новый ФиксированныйМассив(?(ЗначениеЗаполнено(ФилиалПользователя), ФилиалыПользователя, ГруппаФилиалов));
	
	Если УправлениеНастройками.ПолучитьПараметрУчетнойПолитики("ОграничиватьЧтениеФилиаломПользователя") Тогда
		ПараметрыСеанса.ГруппаФилиаловПользователя = Новый ФиксированныйМассив(ФилиалыПользователя);
	Иначе
		ПараметрыСеанса.ГруппаФилиаловПользователя = Новый ФиксированныйМассив(ГруппаФилиалов);
	КонецЕсли;
	
КонецПроцедуры

// Не используется.
// Параметры:
//  Ссылка - ЛюбаяСсылка
//  Право - Строка
//
// Возвращаемое значение:
//  Булево.
//
Функция ЕстьПравоНаОбъект(Ссылка, Право) Экспорт
	
	Результат = Истина;
	Объект = Ссылка.ПолучитьОбъект();
	НачатьТранзакцию();
	Попытка
		Объект.ОбменДанными.Загрузка = Истина;
		Объект.Записать();
	Исключение
		Результат = Ложь;
	КонецПопытки;
	ОтменитьТранзакцию();
	
	Возврат Результат;
	
КонецФункции

// Функция ИспользоватьОграничениеДоступаНаУровнеЗаписей.
//
// Возвращаемое значение:
//  Неопределено.
//
Функция ИспользоватьОграничениеДоступаНаУровнеЗаписей() Экспорт
	Возврат ПараметрыСеанса.ОграничениеДоступаНаУровнеЗаписейВключено;
КонецФункции

// Функция ЗаписьВЖурналЗаписиФилиалаЗапрещенаПользователю.
//
// Параметры:
//  Филиал - Неопределено
//
// Возвращаемое значение:
//  Неопределено.
//
Функция ЗаписьВЖурналЗаписиФилиалаЗапрещенаПользователю(Филиал) Экспорт
	
	Результат = Ложь;
	
	Если ЗначениеЗаполнено(Филиал)
		И ИспользоватьОграничениеДоступаНаУровнеЗаписей()
	Тогда
		ФилиалПользователя = УправлениеНастройками.ПолучитьФилиалПоУмолчаниюПользователя();
		Если Филиал <> ФилиалПользователя
			И УправлениеНастройками.ПолучитьПараметрУчетнойПолитики("ЗапретитьАдминистраторуЗаписьКлиентаНеВСвойФилиал")
		Тогда
			// Проверяем, есть ли у пользователя еще роли, дающие право записи заявки кроме "администратор".
			НетПрава = Истина;
			
			РолиПользователя = ПользователиИнформационнойБазы.ТекущийПользователь().Роли;
			РольАдминистратор = Метаданные.Роли.Администратор;
			МетаданныеЗаявка = Метаданные.Документы.Заявка;
			Для Каждого Роль Из РолиПользователя Цикл
				Если Роль <> РольАдминистратор
					И ПравоДоступа("Добавление", МетаданныеЗаявка)
				Тогда
					НетПрава = Ложь;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			Результат = НетПрава;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;	
	
КонецФункции

// Функция ТребуетсяПредупреждениеНесоответствияКассыФилиала.
//
// Параметры:
//  Касса - Неопределено
//  Филиал - Неопределено
//
// Возвращаемое значение:
//  Неопределено.
//
Функция ТребуетсяПредупреждениеНесоответствияКассыФилиала(Касса, Филиал) Экспорт
	
	СообщениеПользователю = "";
	
	Если ЗначениеЗаполнено(Касса)
		И ЗначениеЗаполнено(Филиал)
		И Не ЕстьПравоНесовпаденияКассыИФилиалаДокументаДС()
	Тогда
		ФилиалКассы = Касса.Филиал;
		Если ЗначениеЗаполнено(ФилиалКассы)
			И ФилиалКассы <> Филиал
		Тогда
			СообщениеПользователю = ПолучитьТекстСообщенияНесовпаденияКассыИФилиалаДокументаДС();
		КонецЕсли;
	КонецЕсли;
		
	Возврат СообщениеПользователю;
		
КонецФункции

// Функция ТребуетсяПредупреждениеНесоответствияСкладаИФилиала.
//
// Параметры:
//  Склад - Неопределено
//  Филиал - Неопределено
//
// Возвращаемое значение:
//  Неопределено.
//
Функция ТребуетсяПредупреждениеНесоответствияСкладаИФилиала(Склад, Филиал) Экспорт
	
	СообщениеПользователю = "";
	
	Если ЗначениеЗаполнено(Склад)
		И ЗначениеЗаполнено(Филиал)
		И Не ЕстьПравоНесовпаденияСкладаИФилиалаСкладскогоДокумента()
	Тогда
		ФилиалСклада = Склад.Филиал;
		Если ЗначениеЗаполнено(ФилиалСклада)
			И ФилиалСклада <> Филиал
		Тогда
			СообщениеПользователю = ПолучитьТекстСообщенияНесовпаденияСкладаИФилиала();
		КонецЕсли;
	КонецЕсли;
		
	Возврат СообщениеПользователю;
		
КонецФункции


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЕстьПравоНесовпаденияКассыИФилиалаДокументаДС()
	
	Если ИспользоватьОграничениеДоступаНаУровнеЗаписей()
		И ЗначениеЗаполнено(УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(,"ОсновнойФилиал"))
	Тогда
		Возврат РольДоступна("ПолныеПрава");
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

Функция ПолучитьТекстСообщенияНесовпаденияКассыИФилиалаДокументаДС()
	
	Возврат НСтр("ru =	'Филиал кассы не совпадает с филиалом документа!
						|У пользователя нет права проведения документа по кассам других филиалов.
						|Допускается запись без проведения и пробития чека.'");
	
КонецФункции

Функция ПолучитьТекстСообщенияНесовпаденияСкладаИФилиала()
	
	Возврат НСтр("ru =	'Филиал склада не совпадает с филиалом документа!
						|У пользователя нет права проведения документа по складам других филиалов.
						|Допускается запись без проведения.'");
	
КонецФункции

Функция ЕстьПравоНесовпаденияСкладаИФилиалаСкладскогоДокумента()
	
	Если ИспользоватьОграничениеДоступаНаУровнеЗаписей()
		И ЗначениеЗаполнено(УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(,"ОсновнойФилиал"))
	Тогда
		Возврат РольДоступна("ПолныеПрава");
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

#КонецОбласти