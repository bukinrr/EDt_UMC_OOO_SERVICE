////////////////////////////////////////////////////////////////////////////////
// Подсистема "Защита персональных данных".
// Модуль предназначен для размещения переопределяемых процедур подсистемы.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс
// Процедура обеспечивает сбор сведений о хранении данных, 
// относящихся к персональным
//
// Параметры:
// 		ТаблицаСведений - ТаблицаЗначений - таблица значений с полями:
// 			Объект 			- Строка - строка, содержащая полное имя объекта метаданных,
// 			ПоляРегистрации - Строка - строка, в которой перечислены имена полей регистрации, 
// 								отдельные поля регистрации отделяются запятой,
// 								альтернативные - символом "|",
// 			ПоляДоступа		- Строка - строка, в которой перечислены через запятую имена полей доступа.
// 			ОбластьДанных	- Строка - строка с идентификатором области данных, необязательно для заполнения.
//
Процедура ЗаполнитьСведенияОПерсональныхДанных(ТаблицаСведений) Экспорт
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект			= "Справочник.Клиенты";
	НовыеСведения.ПоляРегистрации	= "Ссылка";
	НовыеСведения.ПоляДоступа		= "Фамилия,Имя,Отчество,ДатаРождения,СНИЛС";
	НовыеСведения.ОбластьДанных		= "ФИО";
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект			= "РегистрСведений.ПаспортныеДанные";
	НовыеСведения.ПоляРегистрации	= "ФизЛицо";
	НовыеСведения.ПоляДоступа		= "ДокументВид,ДокументСерия,ДокументНомер,ДокументДатаВыдачи,ДокументКемВыдан,ДокументКодПодразделения,ДатаРегистрацииПоМестуЖительства";
	НовыеСведения.ОбластьДанных		= "Паспортные данные";
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект			= "РегистрСведений.КонтактнаяИнформация";
	НовыеСведения.ПоляРегистрации	= "Объект";
	НовыеСведения.ПоляДоступа		= "Тип,Вид,Представление";
	НовыеСведения.ОбластьДанных		= "Контактная информация";
		
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект			= "Справочник.СтраховыеПолисы";
	НовыеСведения.ПоляРегистрации	= "Ссылка";
	НовыеСведения.ПоляДоступа		= "Номер,Серия";
	НовыеСведения.ОбластьДанных		= "Полисы";
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект			= "Справочник.МедицинскиеКарты";
	НовыеСведения.ПоляРегистрации	= "Ссылка";
	НовыеСведения.ПоляДоступа		= "НомерКарты";
	НовыеСведения.ОбластьДанных		= "Медицинские карты";
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект			= "Документ.Прием";
	НовыеСведения.ПоляРегистрации	= "Ссылка";
	НовыеСведения.ПоляДоступа		= "Клиент,Врач,ШаблонОсмотра";
	НовыеСведения.ОбластьДанных		= "Медицинские данные";
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект			= "РегистрСведений.ЗначенияПараметровHTML";
	НовыеСведения.ПоляРегистрации	= "Документ";
	НовыеСведения.ПоляДоступа		= "Значение";
	НовыеСведения.ОбластьДанных		= "Медицинские данные";
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект			= "Документ.Рецепт";
	НовыеСведения.ПоляРегистрации	= "Ссылка";
	НовыеСведения.ПоляДоступа		= "Клиент,Врач";
	НовыеСведения.ОбластьДанных		= "Медицинские данные";
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект			= "Документ.ДействияНадАнализами";
	НовыеСведения.ПоляРегистрации	= "Ссылка";
	НовыеСведения.ПоляДоступа		= "Получатель";
	НовыеСведения.ОбластьДанных		= "Медицинские данные";
	
	// Сотрудники
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект			= "Справочник.Сотрудники";
	НовыеСведения.ПоляРегистрации	= "Ссылка";
	НовыеСведения.ПоляДоступа		= "Фамилия,Имя,Отчество,ДатаРождения";
	НовыеСведения.ОбластьДанных		= "Личные данные сотрудников";
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект			= "РегистрСведений.КонтактнаяИнформация";
	НовыеСведения.ПоляРегистрации	= "Объект";
	НовыеСведения.ПоляДоступа		= "Тип,Вид,Представление";
	НовыеСведения.ОбластьДанных		= "Контактная информация сотрудников";

КонецПроцедуры

// Процедура обеспечивает составление коллекции областей персональных данных.
//
// Параметры:
// 		ОбластиПерсональныхДанных - ТаблицаЗначений - таблица значений с полями:
// 			Имя - Строка - идентификатор области данных.
// 			Представление - Строка - пользовательское представление области данных.
// 			Родитель - Строка - идентификатор родительской области данных.
//
Процедура ЗаполнитьОбластиПерсональныхДанных(ОбластиПерсональныхДанных) Экспорт
	
	// Заполнение представлений для используемых областей.
	НоваяОбласть = ОбластиПерсональныхДанных.Добавить();
	НоваяОбласть.Имя = "Личные данные клиентов";
	НоваяОбласть.Представление = НСтр("ru = 'Личные данные клиентов'");
	
	НоваяОбласть = ОбластиПерсональныхДанных.Добавить();
	НоваяОбласть.Имя = "ФИО";
	НоваяОбласть.Представление = НСтр("ru = 'ФИО, дата рождения'");
	НоваяОбласть.Родитель = "Личные данные клиентов";
	
	НоваяОбласть = ОбластиПерсональныхДанных.Добавить();
	НоваяОбласть.Имя = "Паспортные данные";
	НоваяОбласть.Представление = НСтр("ru = 'Паспортные данные'");
	НоваяОбласть.Родитель = "Личные данные клиентов";
	
	НоваяОбласть = ОбластиПерсональныхДанных.Добавить();
	НоваяОбласть.Имя = "Контактная информация";
	НоваяОбласть.Представление = НСтр("ru = 'Контактная информация'");
	НоваяОбласть.Родитель = "Личные данные клиентов";
	
	НоваяОбласть = ОбластиПерсональныхДанных.Добавить();
	НоваяОбласть.Имя = "Полисы";
	НоваяОбласть.Представление = НСтр("ru = 'Полисы'");
	НоваяОбласть.Родитель = "Личные данные клиентов";
	
	НоваяОбласть = ОбластиПерсональныхДанных.Добавить();
	НоваяОбласть.Имя = "Медицинские карты";
	НоваяОбласть.Представление = НСтр("ru = 'Медицинские карты'");
	НоваяОбласть.Родитель = "Личные данные клиентов";
	
	НоваяОбласть = ОбластиПерсональныхДанных.Добавить();
	НоваяОбласть.Имя = "Медицинские данные";
	НоваяОбласть.Представление = НСтр("ru = 'Медицинские данные'");
	НоваяОбласть.Родитель = "Личные данные клиентов";
	
	// Сотрудники
	НоваяОбласть = ОбластиПерсональныхДанных.Добавить();
	НоваяОбласть.Имя = "Личные данные сотрудников";
	НоваяОбласть.Представление = НСтр("ru = 'Личные данные сотрудников'");

	НоваяОбласть = ОбластиПерсональныхДанных.Добавить();
	НоваяОбласть.Имя = "Контактная информация сотрудников";
	НоваяОбласть.Представление = НСтр("ru = 'Контактная информация сотрудников'");
	
КонецПроцедуры
#КонецОбласти