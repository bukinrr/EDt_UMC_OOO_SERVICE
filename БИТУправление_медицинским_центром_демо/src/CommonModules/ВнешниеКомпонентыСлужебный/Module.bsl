///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Представление компоненты для журнала регистрации
//
Функция ПредставлениеКомпоненты(Идентификатор, Версия) Экспорт

	Если ЗначениеЗаполнено(Версия) Тогда
		ПредставлениеКомпоненты = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 (версии %2)'"), Идентификатор, Версия);
	Иначе
		ПредставлениеКомпоненты = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 (последней версии)'"), Идентификатор);
	КонецЕсли;

	Возврат ПредставлениеКомпоненты;

КонецФункции

// Проверят доступна ли загрузка внешних компонент с портала.
//
// Возвращаемое значение:
//  Булево - признак доступности.
//
Функция ДоступнаЗагрузкаСПортала() Экспорт

	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ПолучениеВнешнихКомпонент") Тогда
		МодульПолучениеВнешнихКомпонент = ОбщегоНазначения.ОбщийМодуль("ПолучениеВнешнихКомпонент");
		Возврат МодульПолучениеВнешнихКомпонент.ДоступнаЗагрузкаВнешнихКомпонент();
	КонецЕсли;

	Возврат Ложь;

КонецФункции

// Возвращает информацию о компоненте из файла внешней компоненты.
//
// Параметры:
//  ДвоичныеДанные - ДвоичныеДанные - двоичные данные файла компоненты.
//  ВыполнятьРазборИнфоФайла - Булево - требуется ли дополнительно анализировать
//          данные файла INFO.XML, если он есть.
//  ПараметрыПоискаДополнительнойИнформации - см. ВнешниеКомпонентыКлиент.ПараметрыЗагрузки.
//
// Возвращаемое значение:
//  Структура:
//      * Разобрано - Булево - Истина, если информация о компоненте успешно извлечена.
//      * Реквизиты - см. РеквизитыКомпоненты
//      * ДвоичныеДанные - ДвоичныеДанные - выгрузка файла компоненты.
//      * ДополнительнаяИнформация - Соответствие - информация, полученная по переданным параметрам поиска.
//      * ОписаниеОшибки - Строка - текст ошибки в случае, если Разобрано = Ложь.
//
Функция ИнформацияОКомпонентеИзФайла(ДвоичныеДанные, ВыполнятьРазборИнфоФайла = Истина,
	Знач ПараметрыПоискаДополнительнойИнформации = Неопределено) Экспорт

	Результат = Новый Структура;
	Результат.Вставить("Разобрано", Ложь);
	Результат.Вставить("Реквизиты", Новый Структура);
	Результат.Вставить("ДвоичныеДанные", Неопределено);
	Результат.Вставить("ДополнительнаяИнформация", Новый Соответствие);
	Результат.Вставить("ОписаниеОшибки", "");
	
	Реквизиты = РеквизитыКомпоненты();
	Если ПараметрыПоискаДополнительнойИнформации = Неопределено Тогда
		ПараметрыПоискаДополнительнойИнформации = Новый Соответствие;
	КонецЕсли;
	ДополнительнаяИнформация = Новый Соответствие;
	НайденМанифест = Ложь;

	Попытка
		Поток = ДвоичныеДанные.ОткрытьПотокДляЧтения();
		ЧтениеАрхива = Новый ЧтениеZipФайла(Поток);
	Исключение
		Результат.ОписаниеОшибки = НСтр("ru = 'В файле отсутствует информация о компоненте.'");
		Возврат Результат;
	КонецПопытки;

	ВременныйКаталог = ФайловаяСистема.СоздатьВременныйКаталог("ExtComp");
	Для Каждого ЭлементАрхива Из ЧтениеАрхива.Элементы Цикл

		Если ЭлементАрхива.Зашифрован Тогда

			// Очищаем временные файлы и освобождаем память.
			ФайловаяСистема.УдалитьВременныйКаталог(ВременныйКаталог);
			ЧтениеАрхива.Закрыть();
			Поток.Закрыть();

			Результат.ОписаниеОшибки = НСтр("ru = 'ZIP-архив не должен быть зашифрован.'");
			Возврат Результат;

		КонецЕсли;

		Попытка

			// Поиск и разбор манифеста.
			Если НРег(ЭлементАрхива.ИсходноеПолноеИмя) = "manifest.xml" Тогда

				Реквизиты.ДатаВерсии = ЭлементАрхива.ВремяИзменения;

				ЧтениеАрхива.Извлечь(ЭлементАрхива, ВременныйКаталог);
				ФайлManifestXML = ВременныйКаталог + ПолучитьРазделительПути() + ЭлементАрхива.ПолноеИмя;
				ЗаполнитьРеквизитыПоManifestXML(ФайлManifestXML, Реквизиты);

				НайденМанифест = Истина;

			КонецЕсли;

			Если НРег(ЭлементАрхива.ИсходноеПолноеИмя) = "info.xml" И ВыполнятьРазборИнфоФайла Тогда

				ЧтениеАрхива.Извлечь(ЭлементАрхива, ВременныйКаталог);
				ФайлInfoXML = ВременныйКаталог + ПолучитьРазделительПути() + ЭлементАрхива.ПолноеИмя;
				ЗаполнитьРеквизитыПоInfoXML(ФайлInfoXML, Реквизиты);

			КонецЕсли;

			Для Каждого ПараметрПоиска Из ПараметрыПоискаДополнительнойИнформации Цикл

				ИмяФайлаXML = ПараметрПоиска.Значение.ИмяФайлаXML;

				Если ЭлементАрхива.ИсходноеПолноеИмя = ИмяФайлаXML Тогда

					КлючДополнительнойИнформации = ПараметрПоиска.Ключ;
					ВыражениеXPath = ПараметрПоиска.Значение.ВыражениеXPath;

					ЧтениеАрхива.Извлечь(ЭлементАрхива, ВременныйКаталог);
					ФайлManifestXML = ВременныйКаталог + ПолучитьРазделительПути() + ЭлементАрхива.ПолноеИмя;

					ДокументDOM = ДокументDOM(ФайлManifestXML);
					ЗначениеXPath = ВычислитьВыражениеXPath(ВыражениеXPath, ДокументDOM);

					ДополнительнаяИнформация.Вставить(КлючДополнительнойИнформации, ЗначениеXPath);

				КонецЕсли;

			КонецЦикла;

		Исключение
			Результат.ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Ошибка при разборе файла %1
				|%2'"), ЭлементАрхива.ИсходноеПолноеИмя, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			Возврат Результат;
		КонецПопытки;
	КонецЦикла;

	// Очищаем временные файлы и освобождаем память.
	ФайловаяСистема.УдалитьВременныйКаталог(ВременныйКаталог);
	ЧтениеАрхива.Закрыть();
	Поток.Закрыть();

	// Контроль соответствия компоненты.
	Если Не НайденМанифест Тогда
		ТекстОшибки = НСтр("ru = 'В архиве компоненты отсутствует обязательный файл MANIFEST.XML.'");

		Результат.ОписаниеОшибки = ТекстОшибки;
		Возврат Результат;
	КонецЕсли;

	Результат.Разобрано = Истина;
	Результат.Реквизиты = Реквизиты;
	Результат.ДвоичныеДанные = ДвоичныеДанные;
	Результат.ДополнительнаяИнформация = ДополнительнаяИнформация;

	Возврат Результат;

КонецФункции

Процедура ПроверитьМестоположениеКомпоненты(Идентификатор, Местоположение) Экспорт

	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ВнешниеКомпонентыВМоделиСервиса") Тогда
		МодульВнешниеКомпонентыВМоделиСервисаСлужебный = ОбщегоНазначения.ОбщийМодуль("ВнешниеКомпонентыВМоделиСервисаСлужебный");
		Если МодульВнешниеКомпонентыВМоделиСервисаСлужебный.ЭтоКомпонентаИзХранилища(Местоположение) Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;

	// В модели сервиса небезопасно подключать внешние компоненты на сервере 1С:Предприятие 
	// из справочника "Внешние компоненты" (допустимо только из справочника "Общие внешние компоненты").
	Если Не (ОбщегоНазначения.РазделениеВключено()
			И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных()) Тогда
		Если Не СтрНачинаетсяС(Местоположение, "e1cib/data/Справочник.ВнешниеКомпоненты.ХранилищеКомпоненты") Тогда
			Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ВнешниеКомпонентыВМоделиСервиса") Тогда
				ТекстИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не удалось подключить компоненту ""%1"" по причине:
					|Доступ запрещен. Обратитесь к администратору сервиса, чтобы разместить внешнюю компоненту в справочник ""Общие внешние компоненты"".'"), Идентификатор);
			Иначе
				ТекстИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не удалось подключить компоненту ""%1"" по причине:
					|Доступ запрещен.'"), Идентификатор);
				КонецЕсли;
			ВызватьИсключение ТекстИсключения;
		КонецЕсли;
	КонецЕсли;

	Если СтрНачинаетсяС(Местоположение, "e1cib/data/Справочник.ВнешниеКомпоненты.ХранилищеКомпоненты") Тогда
		Возврат;
	КонецЕсли;

	ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не удалось подключить компоненту ""%1"" по причине:
		|Недопустимое местоположение компоненты ""%2"".'"), Идентификатор, Местоположение);

КонецПроцедуры

// Параметры загрузки.
// 
// Возвращаемое значение:
//  Структура:
//   * Идентификатор - Строка
//   * Наименование - Строка
//   * Версия - Строка
//   * ИмяФайла - Строка
//   * ОписаниеОшибки - Строка - информация о загрузке компоненты
//   * ОбновлятьСПортала1СИТС - Булево
//   * Данные - Строка - адрес двоичных данных во временном хранилище 
//          - ДвоичныеДанные
//
Функция ПараметрыЗагрузки() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Идентификатор", "");
	Результат.Вставить("Наименование", "");
	Результат.Вставить("Версия", "");
	Результат.Вставить("ИмяФайла", "");
	Результат.Вставить("ОписаниеОшибки", "");
	Результат.Вставить("ОбновлятьСПортала1СИТС", Истина);
	Результат.Вставить("Данные", "");
	
	Возврат Результат;
	
КонецФункции

// Добавить компоненту в справочник из двоичных данных.
// 
// Параметры:
//  Параметры - см. ПараметрыЗагрузки
//  ВыполнятьРазборИнфоФайла - Булево - требуется ли дополнительно анализировать
//          данные файла INFO.XML, если он есть
//
Процедура ЗагрузитьКомпонентуИзДвоичныхДанных(Параметры, ВыполнятьРазборИнфоФайла = Истина) Экспорт
	
	Если ТипЗнч(Параметры.Данные) = Тип("Строка") Тогда
		Если ПустаяСтрока(Параметры.Данные) Тогда
			ТекстИсключения = НСтр("ru = 'Добавление внешней компоненты: не заполнены данные.'");
			ВызватьИсключение ТекстИсключения;
		Иначе
			Если ЭтоАдресВременногоХранилища(Параметры.Данные) Тогда
				ДвоичныеДанные = ПолучитьИзВременногоХранилища(Параметры.Данные);
			Иначе
				ВызватьИсключение НСтр("ru = 'Добавление внешней компоненты: адрес данных не является адресом временного хранилища.'");
			КонецЕсли;
		КонецЕсли;
	Иначе
		ДвоичныеДанные = Параметры.Данные;
	КонецЕсли;
	
	Если ТипЗнч(ДвоичныеДанные) <> Тип("ДвоичныеДанные") Тогда
		ТекстИсключения =  НСтр("ru = 'Добавление внешней компоненты: данные файла не являются двоичными данными.'");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Информация = ИнформацияОКомпонентеИзФайла(ДвоичныеДанные, ВыполнятьРазборИнфоФайла);

	Если Не Информация.Разобрано Тогда
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Добавление внешней компоненты'", 
			ОбщегоНазначения.КодОсновногоЯзыка()), УровеньЖурналаРегистрации.Ошибка, , , Информация.ОписаниеОшибки);
		ВызватьИсключение Информация.ОписаниеОшибки;
	КонецЕсли;
	
	Идентификатор = ?(ЗначениеЗаполнено(Параметры.Идентификатор), Параметры.Идентификатор, Информация.Реквизиты.Идентификатор);
	
	Если Не ЗначениеЗаполнено(Идентификатор) Тогда
		ТекстИсключения = НСтр("ru = 'Добавление внешней компоненты: не заполнен идентификатор'");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;

	НачатьТранзакцию();
	Попытка

		Блокировка = Новый БлокировкаДанных;
		Блокировка.Добавить("Справочник.ВнешниеКомпоненты");
		Блокировка.Заблокировать();

		Компонента = Справочники.ВнешниеКомпоненты.НайтиПоИдентификатору(Идентификатор);

		Если ЗначениеЗаполнено(Компонента) Тогда
			Объект = Компонента.ПолучитьОбъект();
			Попытка
				РезультатСравненияВерсий = ОбщегоНазначенияКлиентСервер.СравнитьВерсии(Объект.Версия, Параметры.Версия);
			Исключение
				// Если не удалось сравнить версии, перезаписываем компоненту.
				РезультатСравненияВерсий = -1;
			КонецПопытки;
			Если РезультатСравненияВерсий >= 0 Тогда
				ОтменитьТранзакцию();
				Возврат;
			КонецЕсли;
		Иначе
			Объект = Справочники.ВнешниеКомпоненты.СоздатьЭлемент();
			// Создание экземпляра компоненты.
			Объект.Заполнить(Неопределено); // Конструктор по умолчанию.
		КонецЕсли;
		
		 // По данным манифеста.
		ЗаполнитьЗначенияСвойств(Объект, Информация.Реквизиты, , "Наименование, Версия, ИмяФайла");
		
		Объект.Идентификатор = Идентификатор;
		// Если в параметрах Наименование, Версия, ИмяФайла не заполнены, берем из информации.
		Объект.Наименование = ?(ЗначениеЗаполнено(Параметры.Наименование), Параметры.Наименование, Информация.Реквизиты.Наименование);
		Объект.Версия = ?(ЗначениеЗаполнено(Параметры.Версия), Параметры.Версия, Информация.Реквизиты.Версия);
		Объект.ИмяФайла = ?(ЗначениеЗаполнено(Параметры.ИмяФайла), Параметры.ИмяФайла, Информация.Реквизиты.ИмяФайла);
		Объект.ОписаниеОшибки = Параметры.ОписаниеОшибки;
		Объект.ОбновлятьСПортала1СИТС = Параметры.ОбновлятьСПортала1СИТС;
		Объект.ДополнительныеСвойства.Вставить("ДвоичныеДанныеКомпоненты", Информация.ДвоичныеДанные);
		
		Объект.Записать();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Добавление внешней компоненты'", ОбщегоНазначения.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры


#Область ОбработчикиСобытийПодсистемКонфигурации

// См. ГрупповоеИзменениеОбъектовПереопределяемый.ПриОпределенииОбъектовСРедактируемымиРеквизитами.
Процедура ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты) Экспорт

	Объекты.Вставить(Метаданные.Справочники.ВнешниеКомпоненты.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");

КонецПроцедуры

// См. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки.
Процедура ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы) Экспорт

	Типы.Добавить(Метаданные.Справочники.ВнешниеКомпоненты);

КонецПроцедуры

// См. СтандартныеПодсистемыСервер.ПриОтправкеДанныхГлавному.
Процедура ПриОтправкеДанныхГлавному(ЭлементДанных, ОтправкаЭлемента,
		Получатель) Экспорт

	Если ТипЗнч(ЭлементДанных) = Тип("СправочникОбъект.ВнешниеКомпоненты") Тогда
		ОтправкаЭлемента = ОтправкаЭлементаДанных.Игнорировать;
	КонецЕсли;

КонецПроцедуры

// См. СтандартныеПодсистемыСервер.ПриОтправкеДанныхПодчиненному.
Процедура ПриОтправкеДанныхПодчиненному(ЭлементДанных, ОтправкаЭлемента,
		СозданиеНачальногоОбраза, Получатель) Экспорт

	Если ТипЗнч(ЭлементДанных) = Тип("СправочникОбъект.ВнешниеКомпоненты") Тогда
		ОтправкаЭлемента = ОтправкаЭлементаДанных.Игнорировать;
	КонецЕсли;

КонецПроцедуры

// См. СтандартныеПодсистемыСервер.ПриПолученииДанныхОтГлавного.
Процедура ПриПолученииДанныхОтГлавного(ЭлементДанных, ПолучениеЭлемента,
		ОтправкаНазад, Отправитель) Экспорт

	Если ТипЗнч(ЭлементДанных) = Тип("СправочникОбъект.ВнешниеКомпоненты") Тогда
		ПолучениеЭлемента = ПолучениеЭлементаДанных.Игнорировать;
	КонецЕсли;

КонецПроцедуры

// См. СтандартныеПодсистемыСервер.ПриПолученииДанныхОтПодчиненного.
Процедура ПриПолученииДанныхОтПодчиненного(ЭлементДанных, ПолучениеЭлемента,
		ОтправкаНазад, Отправитель) Экспорт

	Если ТипЗнч(ЭлементДанных) = Тип("СправочникОбъект.ВнешниеКомпоненты") Тогда
		ПолучениеЭлемента = ПолучениеЭлементаДанных.Игнорировать;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

// См. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления.
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "3.1.6.48";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("cb3e8653-f1d2-4439-afdd-b1d27f6dcc2f");
	Обработчик.Процедура = "Справочники.ВнешниеКомпоненты.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Комментарий = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Заполнение реквизитов ""%1"", ""%2"", ""%3"", которые ранее ошибочно были не заполнены'"),
		"MacOS_x86_64_Safari", "MacOS_x86_64_Chrome", "MacOS_x86_64_Firefox");
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "Справочники.ВнешниеКомпоненты.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ЧитаемыеОбъекты      = "Справочник.ВнешниеКомпоненты";
	Обработчик.ИзменяемыеОбъекты    = "Справочник.ВнешниеКомпоненты";
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверяет возможность подключения на сервере 1С:Предприятия внешней компоненты из хранилища внешних компонент, 
// выполненной по технологии Native API или COM.
//
// Параметры:
//   Идентификатор - Строка - идентификатор объекта внешней компоненты.
//   Версия        - Строка - версия компоненты.
//   ПараметрыПодключения - см. ОбщегоНазначения.ПараметрыПодключения.
//
// Возвращаемое значение:
//   Строка - краткое описание ошибки. 
//
Функция ПроверитьПодключениеКомпоненты(Знач Идентификатор,
		Знач Версия = Неопределено,
		Знач ПараметрыПодключения = Неопределено) Экспорт
		
	//+БИТ НЕ ИСПОЛЬЗУЕТСЯ (НЕТ ВЫЗОВОВ)
	//
	//Если ПараметрыПодключения = Неопределено Тогда
	//	ПараметрыПодключения = ВнешниеКомпонентыСервер.ПараметрыПодключения();
	//КонецЕсли;

	//Если ПустаяСтрока(Идентификатор) Тогда
	//	КомпонентаСодержитЕдинственныйКлассОбъектов = (ПараметрыПодключения.ИдентификаторыСозданияОбъектов.Количество() = 0);
	//	Если КомпонентаСодержитЕдинственныйКлассОбъектов Тогда
	//		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	//			НСтр("ru = 'Недопустимо одновременно не указывать %1 и %2 при подключении внешней компоненты.'"),
	//			"Идентификатор", "ИдентификаторыСозданияОбъектов");
	//	КонецЕсли;
	//	Идентификатор = СтрСоединить(ПараметрыПодключения.ИдентификаторыСозданияОбъектов, ", ");
	//КонецЕсли;

	//Результат = Новый Структура;
	//Результат.Вставить("Местоположение", "");
	//Результат.Вставить("Идентификатор", Идентификатор);
	//Результат.Вставить("ОписаниеОшибки", "");
	//Результат.Вставить("Версия", "");

	//Информация = ВнешниеКомпонентыСлужебныйВызовСервера.ИнформацияОСохраненнойКомпоненте(Идентификатор, Версия);
	//Результат.Вставить("Версия", Версия);
	//Если Информация.Состояние = "ОтключенаАдминистратором" Тогда
	//	Результат.ОписаниеОшибки = НСтр("ru = 'Компонента отключена администратором.'");
	//	Возврат Результат;
	//ИначеЕсли Информация.Состояние = "НеНайдена" Тогда
	//	Результат.ОписаниеОшибки = НСтр("ru = 'Компонента отсутствует в списке разрешенных внешних компонент.'");
	//	Возврат Результат;
	//ИначеЕсли Не ОперационнаяСистемаПоддерживаетсяКомпонентой(Информация.Реквизиты) Тогда
	//	СистемнаяИнформация = Новый СистемнаяИнформация;
	//	Результат.ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не предусмотрена работа компоненты в операционной системе %1.'"), Строка(СистемнаяИнформация.ТипПлатформы));
	//	Возврат Результат;
	//КонецЕсли;
	//ПроверитьМестоположениеКомпоненты(Идентификатор, Информация.Местоположение);
	//Результат.Местоположение = Информация.Местоположение;
	//Возврат Результат;

КонецФункции

#Область ИнформацияОСохраненнойКомпоненте

Функция ОперационнаяСистемаПоддерживаетсяКомпонентой(РеквизитыКомпоненты)

	СистемнаяИнформация = Новый СистемнаяИнформация;

	Если СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Linux_x86 Тогда
		Возврат РеквизитыКомпоненты.Linux_x86;
	ИначеЕсли СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Linux_x86_64 Тогда
		Возврат РеквизитыКомпоненты.Linux_x86_64;
	ИначеЕсли СистемнаяИнформация.ТипПлатформы = ТипПлатформы.MacOS_x86_64 Тогда
		Возврат РеквизитыКомпоненты.MacOS_x86_64;
	ИначеЕсли СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86 Тогда
		Возврат РеквизитыКомпоненты.Windows_x86;
	ИначеЕсли СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда
		Возврат РеквизитыКомпоненты.Windows_x86_64;
	КонецЕсли;

	Возврат Ложь;

КонецФункции

Функция ДоступнаЗагрузкаИзФайла()

	Возврат Пользователи.ЭтоПолноправныйПользователь(, , Ложь);

КонецФункции

// Параметры:
//   Идентификатор - Строка               - идентификатор объекта внешней компоненты.
//   Версия        - Строка
//                 - Неопределено - версия компоненты.
//   ПутьКМакетуДляПоискаПоследнейВерсии 
//                 - Неопределено
//                 - Строка
//
// Возвращаемое значение:
//  Структура:
//    * ДоступнаЗагрузкаСПортала - Булево
//    * ДоступнаЗагрузкаИзФайла - Булево
//    * Состояние - Строка - "НеНайдена", "НайденаВХранилище", "НайденаВОбщемХранилище", "ОтключенаАдминистратором" 
//    * Местоположение - Строка
//    * Ссылка - ЛюбаяСсылка
//    * Реквизиты - см. РеквизитыКомпоненты
//    * ПоследняяВерсияКомпонентыИзМакета 
//    		- см. СтандартныеПодсистемыПовтИсп.ПоследняяВерсияКомпонентыИзМакета
//    		- Неопределено
//
Функция ИнформацияОСохраненнойКомпоненте(Идентификатор, Версия = Неопределено, ПутьКМакетуДляПоискаПоследнейВерсии = Неопределено) Экспорт

	Результат = Новый Структура;
	Результат.Вставить("Ссылка");
	Результат.Вставить("Реквизиты", РеквизитыКомпоненты());
	Результат.Вставить("Местоположение");
	Результат.Вставить("Состояние");
	Результат.Вставить("ДоступнаЗагрузкаИзФайла", ДоступнаЗагрузкаИзФайла());
	Результат.Вставить("ДоступнаЗагрузкаСПортала", ДоступнаЗагрузкаСПортала());
	Результат.Вставить("ПоследняяВерсияКомпонентыИзМакета");

	Если ОбщегоНазначения.РазделениеВключено()
		И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ВнешниеКомпонентыВМоделиСервиса") Тогда
	
		МодульВнешниеКомпонентыВМоделиСервисаСлужебный = ОбщегоНазначения.ОбщийМодуль("ВнешниеКомпонентыВМоделиСервисаСлужебный");
		МодульВнешниеКомпонентыВМоделиСервисаСлужебный.ЗаполнитьИнформациюОКомпоненте(Результат, Версия, Идентификатор);
	Иначе	
		СсылкаИзХранилища = Справочники.ВнешниеКомпоненты.НайтиПоИдентификатору(Идентификатор, Версия);
		Если СсылкаИзХранилища.Пустая() Тогда
			Результат.Состояние = "НеНайдена";
		Иначе
			Результат.Состояние = "НайденаВХранилище";
			Результат.Ссылка = СсылкаИзХранилища;
		КонецЕсли
	КонецЕсли;
	
	Если ПутьКМакетуДляПоискаПоследнейВерсии <> Неопределено Тогда
		Результат.ПоследняяВерсияКомпонентыИзМакета = СтандартныеПодсистемыПовтИсп.ПоследняяВерсияКомпонентыИзМакета(
			ПутьКМакетуДляПоискаПоследнейВерсии);
	КонецЕсли;

	Если Результат.Состояние = "НеНайдена" Тогда
		Возврат Результат;
	КонецЕсли;

	Реквизиты = РеквизитыКомпоненты();
	Если Результат.Состояние = "НайденаВХранилище" Тогда
		Реквизиты.Вставить("Использование");
	КонецЕсли;
	Если Результат.Состояние = "НайденаВОбщемХранилище" Тогда
		Реквизиты.Удалить("ИмяФайла");
	КонецЕсли;

	РеквизитыОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Результат.Ссылка, Реквизиты);

	ЗаполнитьЗначенияСвойств(Результат.Реквизиты, РеквизитыОбъекта);
	Результат.Местоположение = ПолучитьНавигационнуюСсылку(Результат.Ссылка, "ХранилищеКомпоненты");

	Если Результат.Состояние = "НайденаВХранилище" Тогда
		Если РеквизитыОбъекта.Использование <> Перечисления.ВариантыИспользованияВнешнихКомпонент.Используется Тогда
			Результат.Состояние = "ОтключенаАдминистратором";
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

// Возвращаемое значение:
//  Структура:
//    * Windows_x86 - Булево
//    * Windows_x86_64 - Булево
//    * Linux_x86 - Булево
//    * Linux_x86_64 - Булево
//    * Windows_x86_Firefox - Булево
//    * Linux_x86_Firefox - Булево
//    * Linux_x86_64_Firefox - Булево
//    * Windows_x86_MSIE - Булево
//    * Windows_x86_64_MSIE - Булево
//    * Windows_x86_Chrome - Булево
//    * Linux_x86_Chrome - Булево
//    * Linux_x86_64_Chrome - Булево
//    * MacOS_x86_64_Safari - Булево
//    * MacOS_x86_64_Chrome - Булево
//    * MacOS_x86_64_Firefox - Булево
//    * Идентификатор - Строка
//    * Наименование - Строка
//    * Версия - Строка
//    * ДатаВерсии - Дата
//    * ИмяФайла - Строка
//
Функция РеквизитыКомпоненты()

	Реквизиты = Новый Структура;
	Реквизиты.Вставить("Windows_x86");
	Реквизиты.Вставить("Windows_x86_64");
	Реквизиты.Вставить("Linux_x86");
	Реквизиты.Вставить("Linux_x86_64");
	Реквизиты.Вставить("Windows_x86_Firefox");
	Реквизиты.Вставить("Linux_x86_Firefox");
	Реквизиты.Вставить("Linux_x86_64_Firefox");
	Реквизиты.Вставить("Windows_x86_MSIE");
	Реквизиты.Вставить("Windows_x86_64_MSIE");
	Реквизиты.Вставить("Windows_x86_Chrome");
	Реквизиты.Вставить("Linux_x86_Chrome");
	Реквизиты.Вставить("Linux_x86_64_Chrome");
	Реквизиты.Вставить("MacOS_x86_64");
	Реквизиты.Вставить("MacOS_x86_64_Safari");
	Реквизиты.Вставить("MacOS_x86_64_Chrome");
	Реквизиты.Вставить("MacOS_x86_64_Firefox");
	Реквизиты.Вставить("Идентификатор");
	Реквизиты.Вставить("Наименование");
	Реквизиты.Вставить("Версия");
	Реквизиты.Вставить("ДатаВерсии");
	Реквизиты.Вставить("ИмяФайла");

	Возврат Реквизиты;

КонецФункции

#КонецОбласти

#Область ПолучениеИнформацииИзФайлаКомпоненты

Процедура ЗаполнитьРеквизитыПоManifestXML(ИмяФайлаManifestXML, Реквизиты)

	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(ИмяФайлаManifestXML);

	ЧтениеXML.ПерейтиКСодержимому();
	Если ЧтениеXML.Имя = "bundle" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
		Пока ЧтениеXML.Прочитать() Цикл
			Если ЧтениеXML.Имя = "component" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда

				ОперационнаяСистема = НРег(ЧтениеXML.ЗначениеАтрибута("os"));
				ТипКомпоненты = НРег(ЧтениеXML.ЗначениеАтрибута("type"));
				АрхитектураПлатформы = НРег(ЧтениеXML.ЗначениеАтрибута("arch"));
				ПрограммаПросмотра = НРег(ЧтениеXML.ЗначениеАтрибута("client"));

				Если ОперационнаяСистема = "windows" И АрхитектураПлатформы = "i386"
						И (ТипКомпоненты = "native" Или ТипКомпоненты = "com") Тогда

					Реквизиты.Windows_x86 = Истина;
					Продолжить;
				КонецЕсли;

				Если ОперационнаяСистема = "windows" И АрхитектураПлатформы = "x86_64"
						И (ТипКомпоненты = "native" Или ТипКомпоненты = "com") Тогда

					Реквизиты.Windows_x86_64 = Истина;
					Продолжить;
				КонецЕсли;

				Если ОперационнаяСистема = "linux" И АрхитектураПлатформы = "i386"
						И ТипКомпоненты = "native" Тогда

					Реквизиты.Linux_x86 = Истина;
					Продолжить;
				КонецЕсли;

				Если ОперационнаяСистема = "linux" И АрхитектураПлатформы = "x86_64"
						И ТипКомпоненты = "native" Тогда

					Реквизиты.Linux_x86_64 = Истина;
					Продолжить;
				КонецЕсли;

				Если ОперационнаяСистема = "windows" И АрхитектураПлатформы = "i386"
						И ТипКомпоненты = "plugin" И ПрограммаПросмотра = "firefox" Тогда

					Реквизиты.Windows_x86_Firefox = Истина;
					Продолжить;
				КонецЕсли;

				Если ОперационнаяСистема = "linux" И АрхитектураПлатформы = "i386"
						И ТипКомпоненты = "plugin" И ПрограммаПросмотра = "firefox" Тогда

					Реквизиты.Linux_x86_Firefox = Истина;
					Продолжить;
				КонецЕсли;

				Если ОперационнаяСистема = "linux" И АрхитектураПлатформы = "x86_64"
						И ТипКомпоненты = "plugin" И ПрограммаПросмотра = "firefox" Тогда

					Реквизиты.Linux_x86_64_Firefox = Истина;
					Продолжить;
				КонецЕсли;

				Если ОперационнаяСистема = "windows" И АрхитектураПлатформы = "i386"
						И ТипКомпоненты = "plugin" И ПрограммаПросмотра = "msie" Тогда

					Реквизиты.Windows_x86_MSIE = Истина;
					Продолжить;
				КонецЕсли;

				Если ОперационнаяСистема = "windows" И АрхитектураПлатформы = "x86_64"
						И ТипКомпоненты = "plugin" И ПрограммаПросмотра = "msie" Тогда

					Реквизиты.Windows_x86_64_MSIE = Истина;
					Продолжить;
				КонецЕсли;

				Если ОперационнаяСистема = "windows" И АрхитектураПлатформы = "i386"
						И ТипКомпоненты = "plugin" И ПрограммаПросмотра = "chrome" Тогда

					Реквизиты.Windows_x86_Chrome = Истина;
					Продолжить;
				КонецЕсли;

				Если ОперационнаяСистема = "linux" И АрхитектураПлатформы = "i386"
						И ТипКомпоненты = "plugin" И ПрограммаПросмотра = "chrome" Тогда

					Реквизиты.Linux_x86_Chrome = Истина;
					Продолжить;
				КонецЕсли;

				Если ОперационнаяСистема = "linux" И АрхитектураПлатформы = "x86_64"
						И ТипКомпоненты = "plugin" И ПрограммаПросмотра = "chrome" Тогда

					Реквизиты.Linux_x86_64_Chrome = Истина;
					Продолжить;
				КонецЕсли;

				Если ОперационнаяСистема = "macos" И (АрхитектураПлатформы = "x86_64"
						Или АрхитектураПлатформы = "universal") И ТипКомпоненты = "native" Тогда

					Реквизиты.MacOS_x86_64 = Истина;
					Продолжить;
				КонецЕсли;

				Если ОперационнаяСистема = "macos" И (АрхитектураПлатформы = "x86_64"
						Или АрхитектураПлатформы = "universal") И ТипКомпоненты = "plugin"
						И ПрограммаПросмотра = "safari" Тогда

					Реквизиты.MacOS_x86_64_Safari = Истина;
					Продолжить;
				КонецЕсли;
				
				Если ОперационнаяСистема = "macos" И (АрхитектураПлатформы = "x86_64"
						Или АрхитектураПлатформы = "universal") И ТипКомпоненты = "plugin"
						И ПрограммаПросмотра = "chrome" Тогда

					Реквизиты.MacOS_x86_64_Chrome = Истина;
					Продолжить;
				КонецЕсли;
				
				Если ОперационнаяСистема = "macos" И (АрхитектураПлатформы = "x86_64"
						Или АрхитектураПлатформы = "universal") И ТипКомпоненты = "plugin"
						И ПрограммаПросмотра = "firefox" Тогда

					Реквизиты.MacOS_x86_64_Firefox = Истина;
					Продолжить;
				КонецЕсли;

			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	ЧтениеXML.Закрыть();

КонецПроцедуры

Процедура ЗаполнитьРеквизитыПоInfoXML(ИмяФайлаInfoXML, Реквизиты)

	ФайлПрочитан = Ложь;

	// Пытаемся разобрать по формату БПО.
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(ИмяФайлаInfoXML);

	ЧтениеXML.ПерейтиКСодержимому();
	Если ЧтениеXML.Имя = "drivers" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
		Пока ЧтениеXML.Прочитать() Цикл
			Если ЧтениеXML.Имя = "component" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда

				Идентификатор = ЧтениеXML.ЗначениеАтрибута("progid");
				
				Реквизиты.Идентификатор = Сред(Идентификатор, СтрНайти(Идентификатор, ".") + 1);
				Реквизиты.Наименование = ЧтениеXML.ЗначениеАтрибута("name");
				Реквизиты.Версия = ЧтениеXML.ЗначениеАтрибута("version");

				ФайлПрочитан = Истина;

			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	ЧтениеXML.Закрыть();

	Если ФайлПрочитан Тогда
		Возврат;
	КонецЕсли;

	// Пытаемся разобрать по формату БЭД.
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(ИмяФайлаInfoXML);

	ИнформацияКомпоненты = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
	Реквизиты.Идентификатор = ИнформацияКомпоненты.progid;
	Реквизиты.Наименование = ИнформацияКомпоненты.name;
	Реквизиты.Версия = ИнформацияКомпоненты.version;

	ЧтениеXML.Закрыть();

КонецПроцедуры

Функция ВычислитьВыражениеXPath(Выражение, ДокументDOM)

	ЗначениеXPath = Неопределено;

	Разыменователь = ДокументDOM.СоздатьРазыменовательПИ();
	РезультатXPath = ДокументDOM.ВычислитьВыражениеXPath(Выражение, ДокументDOM, Разыменователь);

	УзелРезультата = РезультатXPath.ПолучитьСледующий();
	Если ТипЗнч(УзелРезультата) = Тип("АтрибутDOM") Тогда
		ЗначениеXPath = УзелРезультата.Значение;
	КонецЕсли;

	Возврат ЗначениеXPath
КонецФункции

Функция ДокументDOM(ПутьКФайлу)

	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(ПутьКФайлу);
	ПостроительDOM = Новый ПостроительDOM;
	ДокументDOM = ПостроительDOM.Прочитать(ЧтениеXML);
	ЧтениеXML.Закрыть();

	Возврат ДокументDOM;

КонецФункции

#КонецОбласти

#Область ЗагрузкаСПортала

Процедура ПроверитьДоступностьЗагрузкиСПортала()

	Если Не ДоступнаЗагрузкаСПортала() Тогда
		ВызватьИсключение НСтр("ru = 'Обновление внешних компонент с портала 1С:ИТС не доступно.'");
	КонецЕсли;

КонецПроцедуры

// Возвращаемое значение:
//  Структура:
//   * Идентификатор - Строка
//   * Версия - Строка
//
Функция ПараметрыКомпонентаСПортала() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Идентификатор", "");
	Результат.Вставить("Версия", "");
	Возврат Результат;
	
КонецФункции
	
// Параметры:
//  ПараметрыПроцедуры - см. ПараметрыКомпонентаСПортала.
//  АдресРезультата - Строка
//
Процедура НоваяКомпонентаСПортала(ПараметрыПроцедуры, АдресРезультата) Экспорт

	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ПолучениеВнешнихКомпонент") Тогда

		Идентификатор = ПараметрыПроцедуры.Идентификатор;
		Версия = ПараметрыПроцедуры.Версия;

		ПроверитьДоступностьЗагрузкиСПортала();

		МодульПолучениеВнешнихКомпонент = ОбщегоНазначения.ОбщийМодуль("ПолучениеВнешнихКомпонент");

		ОписаниеВнешнихКомпонент = МодульПолучениеВнешнихКомпонент.ОписаниеВнешнихКомпонент();
		ОписаниеВнешнейКомпоненты = ОписаниеВнешнихКомпонент.Добавить();
		ОписаниеВнешнейКомпоненты.Идентификатор = Идентификатор;
		ОписаниеВнешнейКомпоненты.Версия = Версия;

		Если Не ЗначениеЗаполнено(Версия) Тогда
			РезультатОперации = МодульПолучениеВнешнихКомпонент.АктуальныеВерсииВнешнихКомпонент(ОписаниеВнешнихКомпонент);
		Иначе
			РезультатОперации = МодульПолучениеВнешнихКомпонент.ВерсииВнешнихКомпонент(ОписаниеВнешнихКомпонент);
		КонецЕсли;

		Если ЗначениеЗаполнено(РезультатОперации.КодОшибки) Тогда
			ТекстИсключения = ?(Пользователи.ЭтоПолноправныйПользователь(), РезультатОперации.ИнформацияОбОшибке, РезультатОперации.СообщениеОбОшибке);
			ВызватьИсключение ТекстИсключения;
		КонецЕсли;

		Если РезультатОперации.ДанныеВнешнихКомпонент.Количество() = 0 Тогда
			ТекстИсключения = НСтр("ru = 'На портале 1С:ИТС внешняя компонента отсутствует.'");
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление внешних компонент'", ОбщегоНазначения.КодОсновногоЯзыка()), УровеньЖурналаРегистрации.Ошибка, , , ТекстИсключения);
			ВызватьИсключение ТекстИсключения;
		КонецЕсли;

		СтрокаРезультата = РезультатОперации.ДанныеВнешнихКомпонент[0];
		КодОшибки = СтрокаРезультата.КодОшибки;

		Если ЗначениеЗаполнено(КодОшибки) Тогда

			ИнформацияОбОшибке = "";
			Если КодОшибки = "ОтсутствуетКомпонента" Тогда
				ИнформацияОбОшибке = НСтр("ru = 'На портале 1С:ИТС нет требуемой внешней компоненты %1.'");
			ИначеЕсли КодОшибки = "ОтсутствуетВерсия" Тогда
				ИнформацияОбОшибке = НСтр("ru = 'На портале 1С:ИТС нет требуемой версии внешней компоненты %1.'");
			ИначеЕсли КодОшибки = "ФайлНеЗагружен" Или КодОшибки = "АктуальнаяВерсия" Тогда
				ИнформацияОбОшибке = НСтр("ru = 'При загрузке внешней компоненты %1 произошла непредвиденная ошибка (код %2).'");
			КонецЕсли;

			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ИнформацияОбОшибке, 
				ПредставлениеКомпоненты(Идентификатор, Версия), КодОшибки);
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление внешних компонент'", ОбщегоНазначения.КодОсновногоЯзыка()), 
				УровеньЖурналаРегистрации.Ошибка, , , ТекстОшибки);
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;

		ДвоичныеДанные = ПолучитьИзВременногоХранилища(СтрокаРезультата.АдресФайла);
		Информация = ИнформацияОКомпонентеИзФайла(ДвоичныеДанные, Ложь);

		Если Не Информация.Разобрано Тогда
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление внешних компонент'", ОбщегоНазначения.КодОсновногоЯзыка()), 
				УровеньЖурналаРегистрации.Ошибка, , , Информация.ОписаниеОшибки);
			ВызватьИсключение Информация.ОписаниеОшибки;
		КонецЕсли;

		УстановитьПривилегированныйРежим(Истина);

		НачатьТранзакцию();
		Попытка
			// Создание экземпляра компоненты.
			Объект = Справочники.ВнешниеКомпоненты.СоздатьЭлемент();
			Объект.Заполнить(Неопределено); // Конструктор по умолчанию.
			ЗаполнитьЗначенияСвойств(Объект, Информация.Реквизиты); // По данным манифеста.
			ЗаполнитьЗначенияСвойств(Объект, СтрокаРезультата); // По данным с сайта.
			Объект.ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Загружена с Портала 1С:ИТС. %1.'"), ТекущаяДатаСеанса());

			Объект.ДополнительныеСвойства.Вставить("ДвоичныеДанныеКомпоненты", Информация.ДвоичныеДанные);

			Если Не ЗначениеЗаполнено(Версия) Тогда // Если запрос конкретной версии - пропускаем.
				Объект.ОбновлятьСПортала1СИТС = Объект.ЭтоКомпонентаПоследнейВерсии();
			КонецЕсли;

			Объект.Записать();
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление внешних компонент'", ОбщегоНазначения.КодОсновногоЯзыка()), УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ВызватьИсключение;
		КонецПопытки;

	Иначе
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Действие недоступно, т.к. отсутствует подсистема ""%1"".'"),
			"ИнтернетПоддержкаПользователей.ПолучениеВнешнихКомпонент");
	КонецЕсли;

КонецПроцедуры

// Возвращаемое значение:
//   Структура:
//     * ОбновляемыеКомпоненты - Массив из СправочникСсылка.ВнешниеКомпоненты 
//  
Функция ПараметрыОбновленияКомпонентСПортала() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ОбновляемыеКомпоненты", Новый Массив);
	Возврат Результат;
	
КонецФункции

// Параметры:
//  ПараметрыПроцедуры - см. ПараметрыОбновленияКомпонентСПортала
//  АдресРезультата - Строка
//
Процедура ОбновитьКомпонентыСПортала(ПараметрыПроцедуры, АдресРезультата) Экспорт

	//+БИТ НЕ НАДО!
	//
	//Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ПолучениеВнешнихКомпонент") Тогда

	//	ПроверитьДоступностьЗагрузкиСПортала();

	//	МодульПолучениеВнешнихКомпонент = ОбщегоНазначения.ОбщийМодуль("ПолучениеВнешнихКомпонент");
	//	ОписаниеВнешнихКомпонент = МодульПолучениеВнешнихКомпонент.ОписаниеВнешнихКомпонент();

	//	ОбновляемыеКомпоненты = ПараметрыПроцедуры.ОбновляемыеКомпоненты;
	//	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(ОбновляемыеКомпоненты, "Идентификатор, Версия");
	//	Для Каждого ОбновляемаяКомпонента Из ОбновляемыеКомпоненты Цикл
	//		ОписаниеКомпоненты = ОписаниеВнешнихКомпонент.Добавить();
	//		ОписаниеКомпоненты.Идентификатор = Реквизиты[ОбновляемаяКомпонента].Идентификатор;
	//		ОписаниеКомпоненты.Версия = Реквизиты[ОбновляемаяКомпонента].Версия;
	//	КонецЦикла;

	//	РезультатОперации = МодульПолучениеВнешнихКомпонент.АктуальныеВерсииВнешнихКомпонент(ОписаниеВнешнихКомпонент);
	//	Если ЗначениеЗаполнено(РезультатОперации.КодОшибки) Тогда
	//		ТекстИсключения = ?(Пользователи.ЭтоПолноправныйПользователь(), РезультатОперации.ИнформацияОбОшибке, РезультатОперации.СообщениеОбОшибке);
	//		ВызватьИсключение ТекстИсключения;
	//	КонецЕсли;

	//	ВнешниеКомпонентыСервер.ОбновитьВнешниеКомпоненты(РезультатОперации.ДанныеВнешнихКомпонент, АдресРезультата);

	//Иначе
	//	ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	//		НСтр("ru = 'Действие недоступно, т.к. отсутствует подсистема ""%1"".'"),
	//		"ИнтернетПоддержкаПользователей.ПолучениеВнешнихКомпонент");
	//КонецЕсли;

КонецПроцедуры

#КонецОбласти


#КонецОбласти