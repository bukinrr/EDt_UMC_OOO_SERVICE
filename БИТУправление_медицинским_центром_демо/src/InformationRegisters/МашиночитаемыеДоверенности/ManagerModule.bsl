
// Возвращает уникальный идентификатор первой актуальной МЧД пользователя
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи	 - Пользвоатель
// 
// Возвращаемое значение:
//  Строка, Неопределено - строка УИД, если действующая МЧД найдена, иначе Неопределено 
//
Функция ПолучитьУИДМЧД(ОГРН, Пользователь = Неопределено) Экспорт
	
	Пользователь = ?(Пользователь = Неопределено, ПараметрыСеанса.ТекущийПользователь, Пользователь);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	Организации.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.Организации КАК Организации
	               |ГДЕ
	               |	Организации.ОГРН = &ОГРН
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Организации.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("ОГРН", Строка(Формат(ОГРН,"ЧГ=0")));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
		               |	МашиночитаемыеДоверенности.УИД КАК УИД
		               |ИЗ
		               |	РегистрСведений.МашиночитаемыеДоверенности КАК МашиночитаемыеДоверенности
		               |ГДЕ
		               |	МашиночитаемыеДоверенности.Пользователь = &Пользователь
		               |	И &Дата МЕЖДУ МашиночитаемыеДоверенности.ДатаНачала И МашиночитаемыеДоверенности.ДатаКонца
		               |	И МашиночитаемыеДоверенности.Организация = &Организация
		               |
		               |УПОРЯДОЧИТЬ ПО
		               |	МашиночитаемыеДоверенности.ДатаНачала";
		
		Запрос.УстановитьПараметр("Пользователь", Пользователь);
		Запрос.УстановитьПараметр("Дата", ТекущаяДата());
		Запрос.УстановитьПараметр("Организация", Выборка.Ссылка);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		УстановитьПривилегированныйРежим(Ложь);
		
		Если Выборка.Следующий() Тогда
			Возврат Выборка.УИД;
		Иначе
			Возврат Неопределено;
		КонецЕсли;	
	Иначе
		Возврат Неопределено;
	КонецЕсли;
		
КонецФункции