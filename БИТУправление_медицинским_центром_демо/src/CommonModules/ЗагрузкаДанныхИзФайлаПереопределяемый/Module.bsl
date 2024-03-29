///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет список справочников, доступных для загрузки с помощью подсистемы "Загрузка данных из файла".
//
// Параметры:
//  ЗагружаемыеСправочники - ТаблицаЗначений - список справочников, в которые возможна загрузка данных.
//      * ПолноеИмя          - Строка - полное имя справочника (как в метаданных).
//      * Представление      - Строка - представление справочника в списке выбора.
//      * ПрикладнаяЗагрузка - Булево - если Истина, значит справочник использует собственный алгоритм загрузки и
//                                      в модуле менеджера справочника определены функции.
//
Процедура ПриОпределенииСправочниковДляЗагрузкиДанных(ЗагружаемыеСправочники) Экспорт
	
	// Заполняем заново доступные для загрузки справочники фиксированным списком.
	ЗагружаемыеСправочники.Очистить();
	
	ИменаСправочников = Новый Массив;
	ИменаСправочников.Добавить("Сотрудники");
	ИменаСправочников.Добавить("Пользователи");
	ИменаСправочников.Добавить("Склады");
	ИменаСправочников.Добавить("КатегорииВыработки");
	ИменаСправочников.Добавить("Должности");
	ИменаСправочников.Добавить("ВидыПолисов");
	ИменаСправочников.Добавить("СтраховыеПолисы");
	ИменаСправочников.Добавить("ВидыСкидок");
	ИменаСправочников.Добавить("КартыСкидок");
	ИменаСправочников.Добавить("ВидыСертификатов");
	ИменаСправочников.Добавить("СоставныеФразы");
	
	Для Каждого ИмяСправочника Из ИменаСправочников Цикл
		ОбъектМетаданныхДляВывода = Метаданные.Справочники.Найти(ИмяСправочника);
		Строка = ЗагружаемыеСправочники.Добавить();
		Строка.Представление = ОбъектМетаданныхДляВывода.Представление();
		Строка.ПолноеИмя = ОбъектМетаданныхДляВывода.ПолноеИмя();
	КонецЦикла;
	
	// Выделение справочников с прикладной загрузкой.
	// Номенклатура
	Сведения = ЗагружаемыеСправочники.Добавить();
	Сведения.ПолноеИмя = Метаданные.Справочники.Номенклатура.ПолноеИмя();;
	Сведения.Представление = Метаданные.Справочники.Номенклатура.Представление();
	Сведения.ПрикладнаяЗагрузка = Истина;
	
    // Клиенты
	Сведения = ЗагружаемыеСправочники.Добавить();
	Сведения.ПолноеИмя = Метаданные.Справочники.Клиенты.ПолноеИмя();
	Сведения.Представление = Метаданные.Справочники.Клиенты.Представление();
	Сведения.ПрикладнаяЗагрузка = Истина;
	
	// Сертификаты
	Сведения = ЗагружаемыеСправочники.Добавить();
	Сведения.ПолноеИмя = Метаданные.Справочники.Сертификаты.ПолноеИмя();
	Сведения.Представление = Метаданные.Справочники.Сертификаты.Представление();
	Сведения.ПрикладнаяЗагрузка = Истина;
	
КонецПроцедуры

#КонецОбласти