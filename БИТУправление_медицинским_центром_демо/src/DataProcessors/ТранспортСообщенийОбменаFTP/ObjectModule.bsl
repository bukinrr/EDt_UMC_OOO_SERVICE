///////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ ЭКСПОРТНЫЕ

Перем СтрокаСообщенияОбОшибке Экспорт; // Соощение об ошибке.
Перем СтрокаСообщенияОбОшибкеЖР Экспорт; // Соощение об ошибке.

///////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мСообщенияОшибок; // соответствие с предопределенными сообщениями ошибок обработки
Перем мИмяОбъекта;		// имя объекта метаданных
Перем мИмяСервера;		// Адрес FTP сервера - имя или ip адрес
Перем мКаталогНаСервере;// Каталог на сервере, для хранения/получения сообщений обмена

Перем мВременныйФайлСообщенияОбмена; // временный файл сообщения обмена для выгрузки/загрузки данных
Перем мВременныйКаталогСообщенийОбмена; // временный каталог для сообщений обмена

///////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Создает временный каталог в каталоге временных файлов пользователя операционной системы.
//
// Параметры:
//  Нет.
// 
//  Возвращаемое значение:
//  Булево - Истина – удалось выполнить функцию, Ложь – произошла ошибка.
// 
Функция ВыполнитьДействияПередОбработкойСообщения() Экспорт
	
	ИнициализацияСообщений();
	
	Возврат СоздатьВременныйКаталогСообщенийОбмена();
	
КонецФункции

// Выполняет отправку сообщения обмена на заданный ресурс из временного каталога сообщения обмена
//
// Параметры:
//  Нет.
// 
//  Возвращаемое значение:
//  Булево - Истина – удалось выполнить функцию, Ложь – произошла ошибка.
// 
Функция ОтправитьСообщение() Экспорт
	
	ИнициализацияСообщений();
	
	Попытка
		Результат = ОтправитьСообщениеОбмена();
	Исключение
		Результат = Ложь;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Получает сообщение обмена с заданного ресурса во временный каталог сообщения обмена
//
// Параметры:
//  Нет.
// 
//  Возвращаемое значение:
//  Булево - Истина – удалось выполнить функцию, Ложь – произошла ошибка.
// 
Функция ПолучитьСообщение() Экспорт
	
	ИнициализацияСообщений();
	
	Попытка
		Результат = ПолучитьСообщениеОбмена();
	Исключение
		Результат = Ложь;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Удаляет временный каталог сообщений обмена после выполнения выгрузки или загрузки данных
//
// Параметры:
//  Нет.
// 
//  Возвращаемое значение:
//  Булево - Истина.
//
Функция ВыполнитьДействияПослеОбработкиСообщения() Экспорт
	
	ИнициализацияСообщений();
	
	УдалитьВременныйКаталогСообщенийОбмена();
	
	Возврат Истина;
	
КонецФункции

// Выполняет проверку наличия сообщения обмена на заданном ресурсе
//
// Параметры:
//  Нет.
// 
//  Возвращаемое значение:
//  Булево - Истина - сообщение обмена присутствует на заданном ресурсе; Лож – нет.
//
Функция ФайлСообщенияОбменаСуществует() Экспорт
	
	ИнициализацияСообщений();
	
	Попытка
		FTPСоединение = ПолучитьFTPСоединение();
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ПолучитьСообщениеОбОшибке(102);
		ДополнитьСообщениеОбОшибке(ТекстОшибки);
		Возврат Ложь;
	КонецПопытки;
	
	Попытка
		МассивНайденныхФайлов = FTPСоединение.НайтиФайлы(мКаталогНаСервере, ШаблонИмениФайлаСообщения + ".*", Ложь);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ПолучитьСообщениеОбОшибке(104);
		ДополнитьСообщениеОбОшибке(ТекстОшибки);
		Возврат Ложь;
	КонецПопытки;
	
	Возврат МассивНайденныхФайлов.Количество() > 0;
	
КонецФункции

// Инициализация

// Выполняет инициализацию свойств обработки начальными значениями и константами
//
// Параметры:
//  Нет.
// 
Процедура Инициализация() Экспорт
	
	ИнициализацияСообщений();
	
	ИмяСервераИКаталогНаСервере = РазделитьFTPРесурсНаСерверИКаталог(СокрЛП(FTPСоединениеПуть));
	мИмяСервера			= ИмяСервераИКаталогНаСервере.ИмяСервера;
	мКаталогНаСервере	= ИмяСервераИКаталогНаСервере.ИмяКаталога;
	
КонецПроцедуры

// ПРОВЕРКА ПОДКЛЮЧЕНИЯ

// Выполняет проверку возможности установки подключения к заданному ресурсу
//
// Параметры:
//  Нет.
// 
//  Возвращаемое значение:
//  Булево – Истина – подключение может быть установлено; Ложь – нет.
//
Функция ПодключениеУстановлено() Экспорт
	
	// Возвращаемое значение функции
	Результат = Истина;
	
	ИнициализацияСообщений();
	
	Если	ПустаяСтрока(FTPСоединениеПуть)
		ИЛИ FTPСоединениеПорт = 0
		ИЛИ ПустаяСтрока(FTPСоединениеПользователь) Тогда
		
		ПолучитьСообщениеОбОшибке(101);
		Возврат Ложь;
		
	КонецЕсли;
	
	// Создаем файл во временном каталоге
	ИмяВременногоФайлаПроверкиПодключения = ПолучитьИмяВременногоФайла("tmp");
	ИмяФайлаНаСторонеПриемника = ОбменДаннымиСервер.ИмяФайлаПроверкиПодключения();
	
	ЗаписьТекста = Новый ЗаписьТекста(ИмяВременногоФайлаПроверкиПодключения);
	ЗаписьТекста.ЗаписатьСтроку(ИмяФайлаНаСторонеПриемника);
	ЗаписьТекста.Закрыть();
	
	// Копируем файл на внешний ресурс из временного каталога
	Результат = ВыполнитьКопированиеФайлаНаFTPСервер(ИмяВременногоФайлаПроверкиПодключения, ИмяФайлаНаСторонеПриемника);
	
	// Удаляем файл на внешнем ресурсе
	Если Результат Тогда
		
		Результат = ВыполнитьУдалениеФайлаНаFTPСервере(ИмяФайлаНаСторонеПриемника);
		
	КонецЕсли;
	
	// Удаляем файл из временного каталога
	Попытка
		УдалитьФайлы(ИмяВременногоФайлаПроверкиПодключения);
	Исключение
	КонецПопытки;
	
	Возврат Результат;
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// СВОЙСТВА ОБРАБОТКИ

// Функция-свойство: время изменения файла сообщения обмена
//
// Тип: Дата.
//
Функция ДатаФайлаСообщенияОбмена() Экспорт
	
	Результат = Неопределено;
	
	Если ТипЗнч(мВременныйФайлСообщенияОбмена) = Тип("Файл") Тогда
		
		Если мВременныйФайлСообщенияОбмена.Существует() Тогда
			
			Результат = мВременныйФайлСообщенияОбмена.ПолучитьВремяИзменения();
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Функция-свойство: полное имя файла сообщения обмена
//
// Тип: Строка.
//
Функция ИмяФайлаСообщенияОбмена() Экспорт
	
	Имя = "";
	
	Если ТипЗнч(мВременныйФайлСообщенияОбмена) = Тип("Файл") Тогда
		
		Имя = мВременныйФайлСообщенияОбмена.ПолноеИмя;
		
	КонецЕсли;
	
	Возврат Имя;
	
КонецФункции

// Функция-свойство: полное имя каталога сообщения обмена
//
// Тип: Строка.
//
Функция ИмяКаталогаСообщенияОбмена() Экспорт
	
	Имя = "";
	
	Если ТипЗнч(мВременныйКаталогСообщенийОбмена) = Тип("Файл") Тогда
		
		Имя = мВременныйКаталогСообщенийОбмена.ПолноеИмя;
		
	КонецЕсли;
	
	Возврат Имя;
	
КонецФункции

//

Функция СжиматьФайлИсходящегоСообщения()
	
	Возврат FTPСжиматьФайлИсходящегоСообщения;
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ

Функция СоздатьВременныйКаталогСообщенийОбмена()
	
	мВременныйКаталогСообщенийОбмена = Новый Файл(ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(КаталогВременныхФайлов(), ОбменДаннымиСервер.ИмяВременногоКаталогаСообщенийОбмена()));
	
	// Создаем временный каталог для сообщений обмена
	Попытка
		СоздатьКаталог(ИмяКаталогаСообщенияОбмена());
	Исключение
		ПолучитьСообщениеОбОшибке(4);
		ДополнитьСообщениеОбОшибке(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат Ложь;
	КонецПопытки;
	
	ИмяФайлаСообщения = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ИмяКаталогаСообщенияОбмена(), ШаблонИмениФайлаСообщения + ".xml");
	
	мВременныйФайлСообщенияОбмена = Новый Файл(ИмяФайлаСообщения);
	
	Возврат Истина;
	
КонецФункции

Функция УдалитьВременныйКаталогСообщенийОбмена()
	
	Попытка
		Если Не ПустаяСтрока(ИмяКаталогаСообщенияОбмена()) Тогда
			УдалитьФайлы(ИмяКаталогаСообщенияОбмена());
			мВременныйКаталогСообщенийОбмена = Неопределено;
		КонецЕсли;
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

Функция ОтправитьСообщениеОбмена()
	
	Результат = Истина;
	
	Расширение = ?(СжиматьФайлИсходящегоСообщения(), ".zip", ".xml");
	
	ИмяФайлаИсходящегоСообщения = ШаблонИмениФайлаСообщения + Расширение;
	
	Если СжиматьФайлИсходящегоСообщения() Тогда
		
		// Получаем имя для временного файла архива
		ИмяВременногоФайлаАрхива = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ИмяКаталогаСообщенияОбмена(), ШаблонИмениФайлаСообщения + ".zip");
		
		Попытка
			
			Архиватор = Новый ЗаписьZipФайла(ИмяВременногоФайлаАрхива, ПарольАрхиваСообщенияОбмена, "Файл сообщения обмена");
			Архиватор.Добавить(ИмяФайлаСообщенияОбмена());
			Архиватор.Записать();
			
		Исключение
			
			Результат = Ложь;
			ПолучитьСообщениеОбОшибке(3);
			ДополнитьСообщениеОбОшибке(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
		КонецПопытки;
		
		Архиватор = Неопределено;
		
		Если Результат Тогда
			
			// Выполняем проверку на максимально допустимый размер сообщения обмена.
			Если ОбменДаннымиСервер.РазмерСообщенияОбменаПревышаетДопустимый(ИмяВременногоФайлаАрхива, МаксимальныйДопустимыйРазмерСообщения()) Тогда
				ПолучитьСообщениеОбОшибке(108);
				Результат = Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
		Если Результат Тогда
			
			// Копируем файл архива на FTP сервер в каталог обмена информацией.
			Если Не ВыполнитьКопированиеФайлаНаFTPСервер(ИмяВременногоФайлаАрхива, ИмяФайлаИсходящегоСообщения) Тогда
				Результат = Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		Если Результат Тогда
			
			// Выполняем проверку на максимально допустимый размер сообщения обмена.
			Если ОбменДаннымиСервер.РазмерСообщенияОбменаПревышаетДопустимый(ИмяФайлаСообщенияОбмена(), МаксимальныйДопустимыйРазмерСообщения()) Тогда
				ПолучитьСообщениеОбОшибке(108);
				Результат = Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
		Если Результат Тогда
			
			// Копируем файл архива на FTP сервер в каталог обмена информацией.
			Если Не ВыполнитьКопированиеФайлаНаFTPСервер(ИмяФайлаСообщенияОбмена(), ИмяФайлаИсходящегоСообщения) Тогда
				Результат = Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьСообщениеОбмена()
	
	ТаблицаФайловСообщенийОбмена = Новый ТаблицаЗначений;
	ТаблицаФайловСообщенийОбмена.Колонки.Добавить("Файл");
	ТаблицаФайловСообщенийОбмена.Колонки.Добавить("ВремяИзменения");
	
	Попытка
		FTPСоединение = ПолучитьFTPСоединение();
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ПолучитьСообщениеОбОшибке(102);
		ДополнитьСообщениеОбОшибке(ТекстОшибки);
		Возврат Ложь;
	КонецПопытки;
	
	Попытка
		МассивНайденныхФайлов = FTPСоединение.НайтиФайлы(мКаталогНаСервере, ШаблонИмениФайлаСообщения + ".*", Ложь);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ПолучитьСообщениеОбОшибке(104);
		ДополнитьСообщениеОбОшибке(ТекстОшибки);
		Возврат Ложь;
	КонецПопытки;
	
	Для Каждого ТекущийФайл ИЗ МассивНайденныхФайлов Цикл
		
		// Проверяем нужное расширение
		Если ((ВРег(ТекущийФайл.Расширение) <> ".ZIP")
			И (ВРег(ТекущийФайл.Расширение) <> ".XML")) Тогда
			
			Продолжить;
			
		// Проверяем что это файл, а не каталог
		ИначеЕсли (ТекущийФайл.ЭтоФайл() = Ложь) Тогда
			
			Продолжить;
			
		// Проверяем ненулевой размер файла
		ИначеЕсли (ТекущийФайл.Размер() = 0) Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		// Файл является требуемым сообщением обмена; добавляем его в таблицу.
		СтрокаТаблицы = ТаблицаФайловСообщенийОбмена.Добавить();
		СтрокаТаблицы.Файл           = ТекущийФайл;
		СтрокаТаблицы.ВремяИзменения = ТекущийФайл.ПолучитьВремяИзменения();
		
	КонецЦикла;
	
	Если ТаблицаФайловСообщенийОбмена.Количество() = 0 Тогда
		
		ПолучитьСообщениеОбОшибке(1);
		
		СтрокаСообщения = НСтр("ru = 'Каталог обмена информацией на сервере: ""%1""'");
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, мКаталогНаСервере);
		ДополнитьСообщениеОбОшибке(СтрокаСообщения);
		
		СтрокаСообщения = НСтр("ru = 'Имя файла сообщения обмена: ""%1""'");
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, ШаблонИмениФайлаСообщения + ".[xml|zip]");
		ДополнитьСообщениеОбОшибке(СтрокаСообщения);
		
		Возврат Ложь;
		
	Иначе
		
		ТаблицаФайловСообщенийОбмена.Сортировать("ВремяИзменения Убыв");
		
		// Получаем из таблицы самый "свежий" файл сообщения обмена.
		ФайлВходящегоСообщения = ТаблицаФайловСообщенийОбмена[0].Файл;
		
		ФайлЗапакован = (ВРег(ФайлВходящегоСообщения.Расширение) = ".ZIP");
		
		Если ФайлЗапакован Тогда
			
			// Получаем имя для временного файла архива
			ИмяВременногоФайлаАрхива = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ИмяКаталогаСообщенияОбмена(), ШаблонИмениФайлаСообщения + ".zip");
			
			Попытка
				FTPСоединение.Получить(ФайлВходящегоСообщения.ПолноеИмя, ИмяВременногоФайлаАрхива);
			Исключение
				ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
				ПолучитьСообщениеОбОшибке(105);
				ДополнитьСообщениеОбОшибке(ТекстОшибки);
				Возврат Ложь;
			КонецПопытки;
			
			// Распаковываем временный файл архива
			УспешноРаспакованно = ОбменДаннымиСервер.РаспаковатьZipФайл(ИмяВременногоФайлаАрхива, ИмяКаталогаСообщенияОбмена(), ПарольАрхиваСообщенияОбмена);
			
			Если Не УспешноРаспакованно Тогда
				ПолучитьСообщениеОбОшибке(2);
				Возврат Ложь;
			КонецЕсли;
			
			// Проверка на существование файла сообщения
			Файл = Новый Файл(ИмяФайлаСообщенияОбмена());
			
			Если Не Файл.Существует() Тогда
				
				ПолучитьСообщениеОбОшибке(5);
				Возврат Ложь;
				
			КонецЕсли;
			
		Иначе
			Попытка
				FTPСоединение.Получить(ФайлВходящегоСообщения.ПолноеИмя, ИмяФайлаСообщенияОбмена());
			Исключение
				ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
				ПолучитьСообщениеОбОшибке(105);
				ДополнитьСообщениеОбОшибке(ТекстОшибки);
				Возврат Ложь;
			КонецПопытки;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Процедура ПолучитьСообщениеОбОшибке(НомерСообщения)
	
	УстановитьСтрокуСообщенияОбОшибке(мСообщенияОшибок[НомерСообщения]);
	
КонецПроцедуры

Процедура УстановитьСтрокуСообщенияОбОшибке(Знач Сообщение)
	
	Если Сообщение = Неопределено Тогда
		Сообщение = "Внутренняя ошибка";
	КонецЕсли;
	
	СтрокаСообщенияОбОшибке   = Сообщение;
	СтрокаСообщенияОбОшибкеЖР = мИмяОбъекта + ": " + Сообщение;
	
КонецПроцедуры

Процедура ДополнитьСообщениеОбОшибке(Сообщение)
	
	СтрокаСообщенияОбОшибкеЖР = СтрокаСообщенияОбОшибкеЖР + Символы.ПС + Сообщение;
	
КонецПроцедуры

// Переопределяемая функция, возвращает максимально допустимый размер
// сообщения, которое может быть отправлено.
// 
Функция МаксимальныйДопустимыйРазмерСообщения()
	
	Возврат FTPСоединениеМаксимальныйДопустимыйРазмерСообщения;
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ИНИЦИАЛИЗАЦИИ

Процедура ИнициализацияСообщений()
	
	СтрокаСообщенияОбОшибке   = "";
	СтрокаСообщенияОбОшибкеЖР = "";
	
КонецПроцедуры

Процедура ИнициализацияСообщенийОшибок()
	
	мСообщенияОшибок = Новый Соответствие;
	
	// Общие коды ошибок
	мСообщенияОшибок.Вставить(001, НСтр("ru = 'В каталоге обмена информацией не был обнаружен файл сообщения с данными.'"));
	мСообщенияОшибок.Вставить(002, НСтр("ru = 'Ошибка при распаковке сжатого файла сообщения.'"));
	мСообщенияОшибок.Вставить(003, НСтр("ru = 'Ошибка при сжатии файла сообщения обмена.'"));
	мСообщенияОшибок.Вставить(004, НСтр("ru = 'Ошибка при создании временного каталога.'"));
	мСообщенияОшибок.Вставить(005, НСтр("ru = 'Архив не содержит файл сообщения обмена.'"));
	
	// Коды ошибок, зависящие от вида транспорта
	мСообщенияОшибок.Вставить(101, НСтр("ru = 'Не заданы обязательные параметры FTP-соединения (путь на сервере, порт, пользователь).'"));
	мСообщенияОшибок.Вставить(102, НСтр("ru = 'Ошибка инициализации подключения к FTP-серверу.'"));
	мСообщенияОшибок.Вставить(103, НСтр("ru = 'Ошибка подключения к FTP-серверу, проверьте правильность задания пути и права доступа к ресурсу.'"));
	мСообщенияОшибок.Вставить(104, НСтр("ru = 'Ошибка при поиске файлов на FTP-сервере.'"));
	мСообщенияОшибок.Вставить(105, НСтр("ru = 'Ошибка при получении файла с FTP-сервера.'"));
	мСообщенияОшибок.Вставить(106, НСтр("ru = 'Ошибка удаления файла на FTP-сервере, проверьте права доступа к ресурсу.'"));
	мСообщенияОшибок.Вставить(107, НСтр("ru = 'Ошибка при создании каталога на FTP-сервере.'"));
	мСообщенияОшибок.Вставить(108, НСтр("ru = 'Превышен допустимый размер сообщения обмена.'"));
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ С FTP

Функция ПолучитьFTPСоединение()
	
	// !НастройкаПроксиСервера = ПолучениеФайловИзИнтернета.ПолучитьНастройкиПроксиНаСервере1СПредприятие();.
	НастройкаПроксиСервера = Неопределено;
	
	Если НастройкаПроксиСервера <> Неопределено Тогда
		ИспользоватьПрокси = НастройкаПроксиСервера.Получить("ИспользоватьПрокси");
		ИспользоватьСистемныеНастройки = НастройкаПроксиСервера.Получить("ИспользоватьСистемныеНастройки");
		Если ИспользоватьПрокси Тогда
			Если ИспользоватьСистемныеНастройки Тогда
			// Системные настройки прокси-сервера
				Прокси = Новый ИнтернетПрокси(Истина);
			Иначе
			// Ручные настройки прокси-сервера
				Прокси = Новый ИнтернетПрокси;
				Прокси.Установить("ftp", НастройкаПроксиСервера["Сервер"], НастройкаПроксиСервера["Порт"]);
				Прокси.Пользователь = НастройкаПроксиСервера["Пользователь"];
				Прокси.Пароль       = НастройкаПроксиСервера["Пароль"];
				Прокси.НеИспользоватьПроксиДляЛокальныхАдресов = НастройкаПроксиСервера["НеИспользоватьПроксиДляЛокальныхАдресов"];
			КонецЕсли;
		Иначе
			// Не использовать прокси-сервер	
			Прокси = Новый ИнтернетПрокси(Ложь);
		КонецЕсли;
	Иначе
		Прокси = Неопределено;
	КонецЕсли;
	
	FTPСоединение = Новый FTPСоединение(мИмяСервера,
										FTPСоединениеПорт,
										FTPСоединениеПользователь,
										FTPСоединениеПароль,
										Прокси,
										FTPСоединениеПассивноеСоединение);
	
	Возврат FTPСоединение;
	
КонецФункции

Функция ВыполнитьКопированиеФайлаНаFTPСервер(Знач ИмяФайлаИсточника, ИмяФайлаПриемника)
	
	Перем КаталогНаСервере;
	
	СерверИКаталогНаСервере = РазделитьFTPРесурсНаСерверИКаталог(СокрЛП(FTPСоединениеПуть));
	КаталогНаСервере = СерверИКаталогНаСервере.ИмяКаталога;
	
	Попытка
		FTPСоединение = ПолучитьFTPСоединение();
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ПолучитьСообщениеОбОшибке(102);
		ДополнитьСообщениеОбОшибке(ТекстОшибки);
		Возврат Ложь;
	КонецПопытки;
	
	Попытка
		FTPСоединение.Записать(ИмяФайлаИсточника, КаталогНаСервере + ИмяФайлаПриемника);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ПолучитьСообщениеОбОшибке(103);
		ДополнитьСообщениеОбОшибке(ТекстОшибки);
		Возврат Ложь;
	КонецПопытки;
	
	Попытка
		МассивФайлов = FTPСоединение.НайтиФайлы(КаталогНаСервере, ИмяФайлаПриемника, Ложь);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ПолучитьСообщениеОбОшибке(104);
		ДополнитьСообщениеОбОшибке(ТекстОшибки);
		Возврат Ложь;
	КонецПопытки;
	
	Возврат МассивФайлов.Количество() > 0;
	
КонецФункции

Функция ВыполнитьУдалениеФайлаНаFTPСервере(Знач ИмяФайла)
	
	Перем КаталогНаСервере;
	
	СерверИКаталогНаСервере = РазделитьFTPРесурсНаСерверИКаталог(СокрЛП(FTPСоединениеПуть));
	КаталогНаСервере = СерверИКаталогНаСервере.ИмяКаталога;
	
	Попытка
		FTPСоединение = ПолучитьFTPСоединение();
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ПолучитьСообщениеОбОшибке(102);
		ДополнитьСообщениеОбОшибке(ТекстОшибки);
		Возврат Ложь;
	КонецПопытки;
	
	Попытка
		FTPСоединение.Удалить(КаталогНаСервере + ИмяФайла);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ПолучитьСообщениеОбОшибке(106);
		ДополнитьСообщениеОбОшибке(ТекстОшибки);
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

Функция РазделитьFTPРесурсНаСерверИКаталог(знач ПолныйПуть) Экспорт 
	
	Результат = Новый Структура("ИмяСервера,ИмяКаталога", "", "");
	
	Если ВРег(Лев(ПолныйПуть, 6)) = "FTP://" Тогда
		ПолныйПуть = Прав(ПолныйПуть, СтрДлина(ПолныйПуть) - 6);
	КонецЕсли;
	
	Позиция = Найти(ПолныйПуть, "/");
	
	Если Позиция = 0 Тогда
		Результат.ИмяСервера = ПолныйПуть;
		Результат.ИмяКаталога = "/";
		Возврат Результат;
	КонецЕсли;
	
	Результат.ИмяСервера = Лев(ПолныйПуть, Позиция - 1);
	Результат.ИмяКаталога = Прав(ПолныйПуть, СтрДлина(ПолныйПуть) - Позиция);
	
	Если Прав(Результат.ИмяКаталога, 1) <> "/" Тогда
		Результат.ИмяКаталога = Результат.ИмяКаталога + "/";
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// +бит
Функция ПолучитьТекстыФайловКаталога(СведенияПоследнихВерсийФайлов = Неопределено, ЛимитОбработкиФайловЗаРаз = Неопределено, FTPСоединение = Неопределено, НужныеФайлы = Неопределено, ОбратныйПорядокОбработки = Ложь, Маска = "*.*") Экспорт
	
	Перем ТаблицаФайловСообщенийОбмена;
	
	Если Не ЗначениеЗаполнено(ЛимитОбработкиФайловЗаРаз) Тогда
		ЛимитОбработкиФайловЗаРаз = 20;
	КонецЕсли;
	
	ИнициализацияСообщений();
	
	Если FTPСоединение = Неопределено Тогда 
		Попытка
			FTPСоединение = ПолучитьFTPСоединение();
		Исключение
			ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ПолучитьСообщениеОбОшибке(102);
			ДополнитьСообщениеОбОшибке(ТекстОшибки);
			Возврат Неопределено;
		КонецПопытки;
	КонецЕсли;
	
	Попытка
		МассивНайденныхФайлов = FTPСоединение.НайтиФайлы(мКаталогНаСервере, Маска, Ложь);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ПолучитьСообщениеОбОшибке(104);
		ДополнитьСообщениеОбОшибке(ТекстОшибки);
		Возврат Неопределено;
	КонецПопытки;
		
	Если МассивНайденныхФайлов.Количество() = 0 Тогда

		ПолучитьСообщениеОбОшибке(1);
		
		СтрокаСообщения = НСтр("ru = 'Каталог обмена информацией на сервере: ""%1""'");
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, мКаталогНаСервере);
		ДополнитьСообщениеОбОшибке(СтрокаСообщения);
		
		СтрокаСообщения = НСтр("ru = 'Имя файла сообщения обмена: ""%1""'");
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, ШаблонИмениФайлаСообщения + ".[xml|zip]");
		ДополнитьСообщениеОбОшибке(СтрокаСообщения);
		
		Возврат Неопределено;
		
	Иначе
		ТаблицаФайловСообщенийОбмена = Новый ТаблицаЗначений;
		ТаблицаФайловСообщенийОбмена.Колонки.Добавить("ИмяФайла",		Новый ОписаниеТипов("Строка"));
		ТаблицаФайловСообщенийОбмена.Колонки.Добавить("ДанныеФайла",	Новый ОписаниеТипов("Строка"));
		ТаблицаФайловСообщенийОбмена.Колонки.Добавить("ВремяИзменения", Новый ОписаниеТипов("Дата"));
		ТаблицаФайловСообщенийОбмена.Колонки.Добавить("Размер",			Новый ОписаниеТипов("Число"));
		
		Если ОбратныйПорядокОбработки Тогда
			МассивОбратный = Новый Массив;
			Для Сч = 1 По МассивНайденныхФайлов.Количество() Цикл
				МассивОбратный.Добавить(МассивНайденныхФайлов[МассивНайденныхФайлов.Количество() - Сч]);
			КонецЦикла;
			МассивНайденныхФайлов = МассивОбратный;
		КонецЕсли;
		
		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		
		ОбработаноФайлов = 0;
		
		Для Каждого ТекущийФайл Из МассивНайденныхФайлов Цикл

			Если НужныеФайлы <> Неопределено
				И НужныеФайлы.Найти(НРег(ТекущийФайл.Имя)) = Неопределено
			Тогда
				Продолжить;
			КонецЕсли;
			
			Если ОбработаноФайлов >= ЛимитОбработкиФайловЗаРаз Тогда 
				Прервать;
			КонецЕсли;
				
			ПоследняяВерсия = Неопределено;
			Если СведенияПоследнихВерсийФайлов <> Неопределено Тогда 
				ПоследняяВерсия = СведенияПоследнихВерсийФайлов.Найти(ТекущийФайл.Имя,"ИмяФайла");
			КонецЕсли;
			
			ВремяИзмененияФайлаFTP = ТекущийФайл.ПолучитьВремяИзменения();
			Если Год(ВремяИзмененияФайлаFTP) < 2000 Тогда
				ВремяИзмененияФайлаFTP = Дата(2000 + Год(ВремяИзмененияФайлаFTP), Месяц(ВремяИзмененияФайлаFTP), День(ВремяИзмененияФайлаFTP), Час(ВремяИзмененияФайлаFTP), Минута(ВремяИзмененияФайлаFTP), Секунда(ВремяИзмененияФайлаFTP));
			КонецЕсли;
			
			Если ПоследняяВерсия = Неопределено
				Или ВремяИзмененияФайлаFTP <> ПоследняяВерсия.ВремяИзменения
				Или ТекущийФайл.Размер() <> ПоследняяВерсия.Размер
			Тогда
				Попытка
					FTPСоединение.Получить(ТекущийФайл.ПолноеИмя, ИмяФайлаСообщенияОбмена());
					ТекстовыйДокумент.Прочитать(ИмяФайлаСообщенияОбмена(), КодировкаТекста.UTF8);
					
					СтрокаТаблицы = ТаблицаФайловСообщенийОбмена.Добавить();
					СтрокаТаблицы.ИмяФайла		 = ТекущийФайл.Имя;
					СтрокаТаблицы.ДанныеФайла	 = ТекстовыйДокумент.ПолучитьТекст();
					СтрокаТаблицы.ВремяИзменения = ВремяИзмененияФайлаFTP;
					СтрокаТаблицы.Размер		 = ТекущийФайл.Размер();
				Исключение
					ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
					ПолучитьСообщениеОбОшибке(105);
					ДополнитьСообщениеОбОшибке(ТекстОшибки);
					Возврат Неопределено;
				КонецПопытки;
			Иначе
				СтрокаТаблицы = ТаблицаФайловСообщенийОбмена.Добавить();
				СтрокаТаблицы.ИмяФайла		 = ТекущийФайл.Имя;
				СтрокаТаблицы.ДанныеФайла	 = "";
			КонецЕсли;
		
		    ОбработаноФайлов = ОбработаноФайлов + 1;
		КонецЦикла;
		
		УдалитьФайлы(ИмяФайлаСообщенияОбмена());
		
	КонецЕсли;
	
	Возврат ТаблицаФайловСообщенийОбмена;
	
КонецФункции

Функция Helix_ВыполнитьПеремещениеФайлаНаFTPСервер(Знач ИмяФайлаИсточника,Обработан = Истина,FTPСоединение = Неопределено) Экспорт
	
	Перем КаталогНаСервере;
	
	ИнициализацияСообщенийОшибок();
	
	СерверИКаталогНаСервере = РазделитьFTPРесурсНаСерверИКаталог(СокрЛП(FTPСоединениеПуть));
	КаталогНаСервере = СерверИКаталогНаСервере.ИмяКаталога;
	
	Если FTPСоединение = Неопределено Тогда 
		Попытка
			FTPСоединение = ПолучитьFTPСоединение();
		Исключение
			ТекстОшибки = мСообщенияОшибок[102];
			Возврат ТекстОшибки;
		КонецПопытки;
	КонецЕсли;

	Попытка
		Если Обработан Тогда 
			КаталогПриемник = "Archive";
		Иначе 
			КаталогПриемник = "NotProcessed";
		КонецЕсли;
		НовыйКаталогФайла = КаталогНаСервере + КаталогПриемник + "/";
		НовыйПутьФайла = НовыйКаталогФайла + ИмяФайлаИсточника;
		
		// Проверяем наличие каталога. Если нет каталога - создаем.
		КаталогПриемникФайлаСуществует = Ложь;
		
		Попытка
			МассивНайденныхКаталогов = FTPСоединение.НайтиФайлы(КаталогНаСервере, КаталогПриемник);
			
			Для Каждого НайденныйКаталог Из МассивНайденныхКаталогов Цикл
				Если НайденныйКаталог.ЭтоКаталог() Тогда
					КаталогПриемникФайлаСуществует = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
		Исключение
			ТекстОшибки = мСообщенияОшибок[104];
			Возврат ТекстОшибки;
		КонецПопытки;
			
		Если Не КаталогПриемникФайлаСуществует Тогда
			Попытка
				FTPСоединение.СоздатьКаталог(НовыйКаталогФайла);
			Исключение
				ТекстОшибки = мСообщенияОшибок[107];
				Возврат ТекстОшибки;
			КонецПопытки;
		КонецЕсли;
		
		Попытка
			FTPСоединение.Переместить(КаталогНаСервере + ИмяФайлаИсточника, НовыйПутьФайла);
		Исключение
			// Если по новому пути уже есть файл с таким же именем как у файла-источника, добавляем к имени файла-источника текущую дату.
			ТекДатаСтрокой = Формат(ТекущаяДата(), "ДФ=dd.MM.yyyy_hhmmss"); 
			Файл = Новый Файл(ИмяФайлаИсточника);
			НовыйПутьФайла = НовыйКаталогФайла + Файл.ИмяБезРасширения + "_" + ТекДатаСтрокой + Файл.Расширение;
			FTPСоединение.Переместить(КаталогНаСервере + ИмяФайлаИсточника, НовыйПутьФайла);
		КонецПопытки;
			
	Исключение
		ТекстОшибки = мСообщенияОшибок[103];
		Возврат ТекстОшибки;
	КонецПопытки;
	
КонецФункции
// -бит

///////////////////////////////////////////////////////////////////////////////
// ИНИЦИАЛИЗАЦИЯ

ИнициализацияСообщений();
ИнициализацияСообщенийОшибок();

мВременныйКаталогСообщенийОбмена = Неопределено;
мВременныйФайлСообщенияОбмена    = Неопределено;

мИмяСервера			= Неопределено;
мКаталогНаСервере	= Неопределено;

мИмяОбъекта = НСтр("ru = 'Обработка: %1'");
мИмяОбъекта = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(мИмяОбъекта, Метаданные().Имя);
