///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

// Добавить новый файл к объекту
//
// Параметры:
//  Объект			 - СправочникСсылка	 - владелец файла
//  ПутьКФайлу		 - Строка	 - путь к файлу.
//  УчетнаяПолитика	 - Структура, неопределено	 - кеш учетной политики.
// 
// Возвращаемое значение:
//   - ссылка на файл.
//
Функция ДобавитьНовыйФайл(Объект, ПутьКФайлу, УчетнаяПолитика = Неопределено, СсылкаНаФайл = Неопределено) Экспорт
	
	Если УчетнаяПолитика = Неопределено Тогда 
		УчетнаяПолитика = УправлениеНастройками.ПолучитьУчетнуюПолитику();
	КонецЕсли;
	
	ФайлНаДиске = Новый Файл(ПутьКФайлу);
	ИмяФайлаЗаписиБезРасш = ФайлНаДиске.ИмяБезРасширения;
	
	СтруктураДанныхФайла = Новый Структура("Объект, ДвоичныеДанные, ИмяБезРасширения, Расширение, ИмяФайла");	
	СтруктураДанныхФайла.Объект					= Объект;
	СтруктураДанныхФайла.ДвоичныеДанные			= Новый ДвоичныеДанные(ПутьКФайлу);
	СтруктураДанныхФайла.ИмяБезРасширения		= ФайлНаДиске.ИмяБезРасширения;;
	СтруктураДанныхФайла.Расширение				= ФайлНаДиске.Расширение;	
	СтруктураДанныхФайла.ИмяФайла				= ФайлНаДиске.Имя;
	Если ЗначениеЗаполнено(СсылкаНаФайл) Тогда 
		СтруктураДанныхФайла.Вставить("СсылкаНаФайл", СсылкаНаФайл);
	КонецЕсли;
	
	Если УчетнаяПолитика.ХранитьФотоКлиентовКакФайлы Тогда //Храним файлами
		КаталогХраненияФайла = ПолучитьКаталогХраненияФайлов(УчетнаяПолитика.БазовыйКаталогФайлов, Объект);
		СсылкаНаФайл = РаботаСФайлами.ПоместитьФайлВКаталогНаСервере(СтруктураДанныхФайла, КаталогХраненияФайла);
	Иначе    
		// Храним в хранилище
		Если РаботаСФайламиКлиент.ПроверитьРазмерФайла(ПутьКФайлу) Тогда
			СсылкаНаФайл = РаботаСФайлами.ПоместитьФайлВХранилищеНаСервере(СтруктураДанныхФайла);
		КонецЕсли;
	КонецЕсли;

	Возврат СсылкаНаФайл;
	
КонецФункции

// Удаляет файл, соотвествующий переданной ссылке.
//
Функция УдалитьФайл(СсылкаНаФайл, УчетнаяПолитика = Неопределено) Экспорт 
	
	Если УчетнаяПолитика = Неопределено Тогда 
		УчетнаяПолитика = УправлениеНастройками.ПолучитьУчетнуюПолитику();
	КонецЕсли;
	
	СтруктураДанныхФайла = РаботаСФайлами.ПолучитьФайлНаСервере(СсылкаНаФайл);
	Если ЗначениеЗаполнено(СтруктураДанныхФайла) И СтруктураДанныхФайла.ВФайле Тогда
		КаталогХранения = ПолучитьКаталогХраненияФайлов(УчетнаяПолитика.БазовыйКаталогФайлов, СтруктураДанныхФайла.Объект);
		Если УдалитьФайлИзКаталогаНаКлиенте(СсылкаНаФайл, КаталогХранения) Тогда
			РаботаСФайлами.УдалитьВосстановитьФайлВХранилищеНаСервере(СсылкаНаФайл);
		Иначе
			РаботаСФайлами.УдалитьФайлИзКаталогаНаСервере(СсылкаНаФайл, КаталогХранения);
		КонецЕсли;
	Иначе
		РаботаСФайлами.УдалитьВосстановитьФайлВХранилищеНаСервере(СсылкаНаФайл);
	КонецЕсли;
	
КонецФункции

// Удалить указанный файл
//
Функция УдалитьВосстановитьФайл(СсылкаНаФайл, УчетнаяПолитика = Неопределено, ПометкаУдаления = Истина) Экспорт 
	
	Если УчетнаяПолитика = Неопределено Тогда 
		УчетнаяПолитика = УправлениеНастройками.ПолучитьУчетнуюПолитику();
	КонецЕсли;
	
	СтруктураДанныхФайла = РаботаСФайлами.ПолучитьФайлНаСервере(СсылкаНаФайл);
	Если ЗначениеЗаполнено(СтруктураДанныхФайла) И СтруктураДанныхФайла.ВФайле Тогда
		КаталогХранения = ПолучитьКаталогХраненияФайлов(УчетнаяПолитика.БазовыйКаталогФайлов, СтруктураДанныхФайла.Объект);
		Если УдалитьФайлИзКаталогаНаКлиенте(СсылкаНаФайл, КаталогХранения) Тогда
			РаботаСФайлами.УдалитьВосстановитьФайлВХранилищеНаСервере(СсылкаНаФайл);
		Иначе
			РаботаСФайлами.УдалитьФайлИзКаталогаНаСервере(СсылкаНаФайл, КаталогХранения);
		КонецЕсли;
	Иначе
		РаботаСФайлами.УдалитьВосстановитьФайлВХранилищеНаСервере(СсылкаНаФайл, ПометкаУдаления);
	КонецЕсли;
	
КонецФункции

// Удаляет файл из каталога хранения в файловой системе.
//
// Параметры:
//  СсылкаНаФайл	 - ссылка на файл в справочнике файлов. 
//  КаталогХранения	 - Строка	 - каталог файла
// 
// Возвращаемое значение:
//   - Булево.
//
Функция УдалитьФайлИзКаталогаНаКлиенте(СсылкаНаФайл, КаталогХранения = Неопределено)
	
	Если КаталогХранения = Неопределено Тогда
		БазовыйКаталог = УправлениеНастройками.ПолучитьПараметрУчетнойПолитики("БазовыйКаталогФайлов");
		КаталогХранения = РаботаСФайлами.ПолучитьКаталогХраненияФайлов(БазовыйКаталог, СсылкаНаФайл);
	КонецЕсли;
	
	Файл = Новый Файл(КаталогХранения + Строка(СсылкаНаФайл));
	Если Файл.Существует() Тогда 
		УдалитьФайлы(Файл.ПолноеИмя);
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Получить каталог хранения файлов
//
// Параметры:
//  БазовыйКаталог	 - Строка - базовый катлог файлов.
//  Объект			 - Объект-владелец. 
// 
// Возвращаемое значение:
//   Строка.
//
Функция ПолучитьКаталогХраненияФайлов(БазовыйКаталог, Объект) Экспорт
	
	КаталогХранения = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(БазовыйКаталог) + 
		Строка(Объект.УникальныйИдентификатор());
		
	Возврат ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(КаталогХранения);
		
КонецФункции

// Получает и открывает указанный файл
//
// Параметры:
//  СсылкаНаФайл	 - Ссылка на файл 
//  ВремКаталог		 - Строка, Неопределено	 - каталог развертки файла
//  КешированныйПуть - Строка, Неопределено	 - ранее полученный путь
//  НеОткрыватьФайл	 - Булево - не открывать файл после получения.
// 
// Возвращаемое значение:
//   Строка -имя файла.
//
Функция ОткрытьФайл(СсылкаНаФайл, ВремКаталог = Неопределено, КешированныйПуть = Неопределено, НеОткрыватьФайл = Ложь) Экспорт
	
	#Если ВебКлиент Или МобильныйКлиент Тогда
	СодержаниеОшибки = "В режиме Веб-клиента данная операция не доступна.";
	Возврат "";
	#Иначе
	// Сначала пытаемся открыть файл по кешированному пути
	Если КешированныйПуть <> Неопределено Тогда
		Файл = Новый Файл(КешированныйПуть);
		Если Файл.Существует() Тогда
			Если Не НеОткрыватьФайл Тогда 
				ЗапуститьПриложение(Файл.ПолноеИмя);
			КонецЕсли;
			Возврат Файл.ПолноеИмя;
		КонецЕсли;
	КонецЕсли;
	
	// Попытка получить файл с сервера
	СтруктураДанныхФайла = РаботаСФайлами.ПолучитьФайлНаСервере(СсылкаНаФайл);
	Если Не СтруктураДанныхФайла.ФайлНайден Тогда 
		Возврат Неопределено;
	КонецЕсли;
	
	Если ВремКаталог = Неопределено Тогда		
		ИмяВремФайла = ПолучитьИмяВременногоФайла(СтруктураДанныхФайла.Расширение);	
	Иначе
		ИмяВремФайла = ВремКаталог + СтруктураДанныхФайла.Имя;		
	КонецЕсли;
	
	Если СтруктураДанныхФайла.Свойство("ДвоичныеДанные") Тогда 
		Если ТипЗнч(СтруктураДанныхФайла.ДвоичныеДанные) = Тип("ДвоичныеДанные") Тогда
			СтруктураДанныхФайла.ДвоичныеДанные.Записать(ИмяВремФайла);
		Иначе
			Возврат Неопределено;
		КонецЕсли;
	Иначе
		// Пытаемся получить доступ к файлу на клиенте
		Если СтруктураДанныхФайла.Свойство("ПутьКФайлу") Тогда 
			Файл = Новый Файл(СтруктураДанныхФайла.ПутьКФайлу);
			Если Файл.Существует() Тогда 
				ИмяВремФайла = Файл.ПолноеИмя;
			Иначе // Не получилось, пробуем все равно через временный файл
				СтруктураДанныхФайла = РаботаСФайлами.ПолучитьФайлНаСервере(СсылкаНаФайл, , Истина);
				Если СтруктураДанныхФайла.Свойство("ДвоичныеДанные") Тогда 
					СтруктураДанныхФайла.ДвоичныеДанные.Записать(ИмяВремФайла);
				КонецЕсли;
			КонецЕсли;
		Иначе
			Возврат Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Если Не НеОткрыватьФайл Тогда
		ЗапуститьПриложение(ИмяВремФайла);
	КонецЕсли;
	
	Возврат ИмяВремФайла;
	#КонецЕсли
	
КонецФункции

// Получить список типов для типов файлов, которые можно просматривать в 1С.
// 
// Возвращаемое значение:
//   - Соответсвие.
//
Функция ПолучитьРасширенияДляПредпросмотраФайлов() Экспорт 
	
	Расширения = Новый Соответствие;
	
	// Изображения
	Расширения.Вставить(".jpeg", "Картинка");
	Расширения.Вставить(".jpg", "Картинка");
	Расширения.Вставить(".bmp", "Картинка");
	Расширения.Вставить(".png", "Картинка");
	Расширения.Вставить(".gif", "Картинка");
	Расширения.Вставить(".dib", "Картинка");
	Расширения.Вставить(".rle", "Картинка");
	Расширения.Вставить(".ico", "Картинка");
	
	// Текст
	Расширения.Вставить(".txt", "Текст");
	Расширения.Вставить(".xml", "Текст");
	
	Возврат Расширения;
	
КонецФункции

// Позволяет проверить, удовлетворяет ли размер файла критерию на предельно допустимое в обращении.
//
// Параметры:
//  ИмяФайла - Строка - Путь к файлу на стороне клиента 1С.
// 
// Возвращаемое значение:
//   - Булево.
//
Функция ПроверитьРазмерФайла(ИмяФайла) Экспорт
	
	Файл = Новый Файл(ИмяФайла);
	
	Если (УправлениеНастройками.ПолучитьПараметрУчетнойПолитики("МаксимальныйРазмерФайлаФото") = 0
			И Файл.Размер() <= 10*1048576)
		ИЛИ (Файл.Размер() <= УправлениеНастройками.ПолучитьПараметрУчетнойПолитики("МаксимальныйРазмерФайлаФото")*1048576)
	Тогда
		Файл = Неопределено;
		Возврат Истина;
	Иначе
		Предупреждение("Размер загружаемого файла превышает максимально допустимый, установленный в параметрах учета!");
	КонецЕсли; 
	
	Файл = Неопределено;
	
	Возврат Ложь;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Работа со сканером.

////////////////////////////////////////////////////////////////////////////////
// Работа со сканером.

// Открывает форму настройки сканирования из пользовательских настроек.
//
Процедура ОткрытьФормуНастройкиСканирования() Экспорт
	
	Если Не РаботаСФайламиСлужебныйКлиент.ДоступноСканирование() Тогда
		//+бит Ошибка компоненты x64
		//ТекстСообщения = НСтр("ru = 'Сканирование возможно в программах для операционных систем Microsoft Windows x86 и х64.'");
		ТекстСообщения = НСтр("ru = 'Сканирование возможно в программах для операционных систем Microsoft Windows x86.'");
		//-бит
		ПоказатьПредупреждение(, ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("ОткрытьФормуНастройкиСканированияЗавершение", ЭтотОбъект);
	
	РаботаСФайламиСлужебныйКлиент.ПроинициализироватьКомпоненту(Обработчик, Истина);
		
КонецПроцедуры

Процедура ОткрытьФормуНастройкиСканированияЗавершение(РезультатПроверкиИнициализации, ПараметрыВыполнения) Экспорт
	
	КомпонентаУстановлена = РезультатПроверкиИнициализации.Подключено;
	
	Если Не КомпонентаУстановлена Тогда
		Если ЗначениеЗаполнено(РезультатПроверкиИнициализации.ОписаниеОшибки) Тогда
			ПоказатьПредупреждение(, РезультатПроверкиИнициализации.ОписаниеОшибки);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	СистемнаяИнформация = Новый СистемнаяИнформация();
	ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КомпонентаУстановлена", КомпонентаУстановлена);
	ПараметрыФормы.Вставить("ИдентификаторКлиента",  ИдентификаторКлиента);
	
	ОткрытьФорму("Обработка.Сканирование.Форма.НастройкаСканирования", ПараметрыФормы);
	
КонецПроцедуры

// Конструктор параметров параметров конвертации графических документов в PDF.
// 
// Возвращаемое значение:
//  Структура:
//   * ТипРезультата - см. ТипРезультатаКонвертацииИмяФайла
//                   - см. ТипРезультатаКонвертацииДвоичныеДанные
//                   - см. ТипРезультатаКонвертацииПрисоединенныйФайл
//   * ФорматРезультата - Строка - формат результирующего файла "pdf" или "tif"
//   * ИмяФайлаРезультата - см. ТипРезультатаКонвертацииИмяФайла
//   * ИспользоватьImageMagick - Булево - признак использования утилиты ImageMagick
//
Функция ПараметрыКонвертацииГрафическогоДокумента() Экспорт
	
	ПараметрыКонвертации = Новый Структура;
	ПараметрыКонвертации.Вставить("ТипРезультата", ТипРезультатаКонвертацииИмяФайла());
	ПараметрыКонвертации.Вставить("ФорматРезультата", "pdf");
	ПараметрыКонвертации.Вставить("ИмяФайлаРезультата", "");
	
	НастройкиСканированияПользователя = ПолучитьНастройкиСканированияПользователя();
	
	ПараметрыКонвертации.Вставить("ИспользоватьImageMagick", 
		НастройкиСканированияПользователя.ИспользоватьImageMagickДляПреобразованияВPDF);
		
	Возврат ПараметрыКонвертации;
	
КонецФункции

// Возвращает тип результата конвертации в файл на клиенте.
// 
// Возвращаемое значение:
//  Строка
//
Функция ТипРезультатаКонвертацииИмяФайла() Экспорт
	
	Возврат РаботаСФайламиСлужебныйКлиент.ТипРезультатаКонвертацииИмяФайла();
	
КонецФункции

// Возвращает тип результата конвертации в двоичные данные.
// 
// Возвращаемое значение:
//  Строка
//
Функция ТипРезультатаКонвертацииДвоичныеДанные() Экспорт
	
	Возврат РаботаСФайламиСлужебныйКлиент.ТипРезультатаКонвертацииДвоичныеДанные();
	
КонецФункции

// Обозначает тип результата конвертации в присоединенный файл.
// 
// Возвращаемое значение:
//  Строка
//
Функция ТипРезультатаКонвертацииПрисоединенныйФайл() Экспорт
	
	Возврат РаботаСФайламиСлужебныйКлиент.ТипРезультатаКонвертацииПрисоединенныйФайл();
	
КонецФункции


// Объединить массив переданных документов в один, с возможностью конвертации.
// 
// Параметры:
//  ОповещениеВозврата - ОписаниеОповещения - процедура, которая будет выполнена после объединения файлов.
//  ОбъектыДляОбъединения - Массив из ДвоичныеДанные, ОпределяемыйТип.ПрисоединенныйФайл, Строка - 
//                          Объекты могут поступать в виде двоичных данных, ссылки на присоединенный файл, пути к файлам
//                          на клиенте.
//  ПараметрыКонвертацииГрафическогоДокумента - см. РаботаСФайламиКлиент.ПараметрыКонвертацииГрафическогоДокумента.
// 
Процедура ОбъединитьВМногостраничныйФайл(ОповещениеВозврата, ОбъектыДляОбъединения, ПараметрыКонвертацииГрафическогоДокумента) Экспорт
	
	Результат = РезультатОбъединенияВМногостраничныйДокумент();
	НастройкиСканированияПользователя = ПолучитьНастройкиСканированияПользователя();
	
	ИспользоватьImageMagick = ПараметрыКонвертацииГрафическогоДокумента.ИспользоватьImageMagick; 
	ПутьКПрограммеКонвертации = НастройкиСканированияПользователя.ПутьКПрограммеКонвертации;
	
		Контекст = Новый Структура;
	Контекст.Вставить("ОповещениеВозврата", ОповещениеВозврата);
	Контекст.Вставить("ОбъектыДляОбъединения", ОбъектыДляОбъединения);
	Контекст.Вставить("ПараметрыКонвертацииГрафическогоДокумента", ПараметрыКонвертацииГрафическогоДокумента);
	Контекст.Вставить("НастройкиСканированияПользователя", НастройкиСканированияПользователя);
	
	Если ОбъектыДляОбъединения.Количество() = 0 Тогда
		Результат.ОписаниеОшибки = НСтр("ru='Не указаны изображения для объединения.'");
		ВыполнитьОбработкуОповещения(ОповещениеВозврата, Результат);
		Возврат;
	ИначеЕсли ИспользоватьImageMagick И Не ЗначениеЗаполнено(ПутьКПрограммеКонвертации) Тогда
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Не указан путь к программе %1.
		|Объединение многостраничных документов выполняется штатными средствами.'"), "ImageMagick");
		
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(),
			"Предупреждение", ТекстОшибки,, Истина);
		Контекст.ПараметрыКонвертацииГрафическогоДокумента.ИспользоватьImageMagick = Ложь;
		ОбъединитьВМногостраничныйФайлПродолжение(Контекст);
		Возврат;
	КонецЕсли;
	
	#Если Не ВебКлиент И Не МобильныйКлиент Тогда
		
	Если ИспользоватьImageMagick Тогда
		ОповещениеРезультата = Новый ОписаниеОповещения("ПослеПроверкиНаличияПрограммыКонвертации", ЭтотОбъект, Контекст);
		НачатьПроверкуНаличияПрограммыКонвертации(ПутьКПрограммеКонвертации, ОповещениеРезультата);
		Возврат;
	КонецЕсли;
	
	ОбъединитьВМногостраничныйФайлПродолжение(Контекст);
	
	#КонецЕсли
КонецПроцедуры

// Конструктор параметров добавления со сканера.
// 
// Возвращаемое значение:
//  Структура:
//    * ОбработчикРезультата - Неопределено, ОписаниеОповещения - оповещение, которое будет вызвано после получения изображений.
//    * ВладелецФайла - Неопределено, ОпределяемыйТип.ВладелецФайлов - владелец файла, для получения изображений в
//                                                                     присоединенные файлы.
//    * ФормаВладелец - Неопределено, Форма - форма из которой вызывается добавление файла.
//    * НеОткрыватьКарточкуПослеСозданияИзФайла - Булево - для режима создания присоединенных файлов.
//    * ЭтоФайл - Булево
//    * ТипРезультата - см. ТипРезультатаКонвертацииИмяФайла 
//                    - см. ТипРезультатаКонвертацииДвоичныеДанные
//                    - см. ТипРезультатаКонвертацииПрисоединенныйФайл
//    * ТолькоОдинФайл - Булево - сканировать только одно изображение.
//
Функция ПараметрыДобавленияСоСканера() Экспорт
	ПараметрыДобавления = Новый Структура;
	ПараметрыДобавления.Вставить("ОбработчикРезультата", Неопределено);
	ПараметрыДобавления.Вставить("ВладелецФайла", Неопределено);
	ПараметрыДобавления.Вставить("ФормаВладелец", Неопределено);
	ПараметрыДобавления.Вставить("НеОткрыватьКарточкуПослеСозданияИзФайла", Истина);
	ПараметрыДобавления.Вставить("ЭтоФайл", Истина);
	ПараметрыДобавления.Вставить("ТипРезультата", ТипРезультатаКонвертацииПрисоединенныйФайл());
	ПараметрыДобавления.Вставить("ТолькоОдинФайл", Ложь);
	Возврат ПараметрыДобавления;
КонецФункции

// Добавить со сканера. Если работа со сканером не была предварительно настроена, 
// то будут вызвана форма настроек сканирования.
// 
// Параметры:
//  ПараметрыДобавления - см. ПараметрыДобавленияСоСканера
//  ПараметрыСканирования - см. ПараметрыСканирования
//
Процедура ДобавитьСоСканера(ПараметрыДобавления, ПараметрыСканирования = Неопределено) Экспорт
	
	РаботаСФайламиСлужебныйКлиент.ДобавитьСоСканера(ПараметрыДобавления, ПараметрыСканирования);
	
КонецПроцедуры

// Проверяет, ограничения клиента для работы со сканером.
// 
// Возвращаемое значение:
//   см. РаботаСФайламиСлужебныйКлиент.ДоступноСканирование
//
Функция ДоступноСканирование() Экспорт
	Возврат РаботаСФайламиСлужебныйКлиент.ДоступноСканирование();
КонецФункции

// Проверяет установлена ли компонента сканирования и есть ли хоть один подключенный сканер.
// 
// Параметры:
//  ОповещениеРезультата - ОписаниеОповещения - процедура куда будет передан результат проверки:
//   * Результат - Булево - признак доступности сканирования.
//   * ДополнительныеПараметры - Произвольный - значение, указанное при создании описания оповещения.
//
Процедура ДоступнаКомандаСканировать(ОповещениеРезультата) Экспорт
	ОписаниеОповещения = Новый ОписаниеОповещения("ДоступнаКомандаСканироватьЗавершение", ЭтотОбъект, ОповещениеРезультата);
	РаботаСФайламиСлужебныйКлиент.ПроинициализироватьКомпоненту(ОписаниеОповещения);
КонецПроцедуры

// Получает настройки сканирования пользователя.
// 
// Параметры:
//  ИдентификаторКлиента - УникальныйИдентификатор - идентификатор клиента
// 
// Возвращаемое значение:
//   см. РаботаСФайламиКлиентСервер.НастройкиСканированияПользователя
//
Функция ПолучитьНастройкиСканированияПользователя(ИдентификаторКлиента = Неопределено) Экспорт
	//+бит
	// Было:
	//Если ИдентификаторКлиента = Неопределено Тогда
	//	СистемнаяИнформация = Новый СистемнаяИнформация();
	//	ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
	//КонецЕсли;
	//
	//Возврат РаботаСФайламиСлужебныйВызовСервера.ПолучитьНастройкиСканированияПользователя(ИдентификаторКлиента);
	// Стало:
	Возврат РаботаСФайламиСлужебныйВызовСервера.ПолучитьНастройкиСканированияПользователя(ИдентификаторКлиента);
	//-бит
	
КонецФункции

// Сохраняет настройки сканирования пользователя.
// 
// Параметры:
//  НастройкиСканированияПользователя - см. РаботаСФайламиКлиентСервер.НастройкиСканированияПользователя
//  ИдентификаторКлиента - УникальныйИдентификатор - идентификатор клиента
//
Процедура СохранитьНастройкиСканированияПользователя(НастройкиСканированияПользователя, ИдентификаторКлиента = Неопределено) Экспорт
	
	Если ИдентификаторКлиента = Неопределено Тогда
		СистемнаяИнформация = Новый СистемнаяИнформация();
		ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
	КонецЕсли;
	
	РаботаСФайламиСлужебныйВызовСервера.СохранитьНастройкиСканированияПользователя(НастройкиСканированияПользователя, ИдентификаторКлиента);
	
КонецПроцедуры  

Функция ИзображенияДляОбъединения(ОбъектыДляОбъединения, ИспользоватьImageMagick = Ложь)
	
	ИзображенияДляОбъединения = Новый Массив;
	
	Если ИспользоватьImageMagick Тогда
		Для Каждого ОбъектДляОбъединения Из ОбъектыДляОбъединения Цикл
			ИмяФайла = Неопределено;
			#Если Не ВебКлиент И Не МобильныйКлиент Тогда
				// АПК:441-выкл файл является результатом метода
				ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
				// АПК:441-вкл
			#Иначе
				ИмяВременногоФайла = Неопределено;			
			#КонецЕсли
			
			Если ОбъектДляОбъединения = Неопределено Тогда
				Продолжить;
			ИначеЕсли ТипЗнч(ОбъектДляОбъединения) = Тип("ДвоичныеДанные") Тогда
				ИмяФайла = ИмяВременногоФайла;
				ОбъектДляОбъединения.Записать(ИмяФайла);
			ИначеЕсли ТипЗнч(ОбъектДляОбъединения) = Тип("Строка") Тогда
				Если ЭтоАдресВременногоХранилища(ОбъектДляОбъединения) Тогда
					СодержимоеАдреса = ПолучитьИзВременногоХранилища(ОбъектДляОбъединения);
					Если ТипЗнч(СодержимоеАдреса) = Тип("ДвоичныеДанные") Тогда
						ИмяФайла = ИмяВременногоФайла;
						СодержимоеАдреса.Записать(ИмяФайла);
					ИначеЕсли ТипЗнч(СодержимоеАдреса) = Тип("Картинка") Тогда
						ДанныеКартинки = СодержимоеАдреса.ПолучитьДвоичныеДанные();
						ИмяФайла = ИмяВременногоФайла;
						ДанныеКартинки.Записать(ИмяФайла);
					КонецЕсли;
				Иначе
					ИмяФайла = ОбъектДляОбъединения;
				КонецЕсли;
			ИначеЕсли РаботаСФайламиСлужебныйВызовСервера.ЭтоЭлементРаботаСФайлами(ОбъектДляОбъединения) Тогда
				ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайла(ОбъектДляОбъединения);
				СодержимоеАдреса = ПолучитьИзВременногоХранилища(ДанныеФайла.СсылкаНаДвоичныеДанныеФайла);
				ИмяФайла = ИмяВременногоФайла;
				СодержимоеАдреса.Записать(ИмяФайла);
			КонецЕсли;
			
			Если ИмяФайла <> Неопределено Тогда
				ИзображенияДляОбъединения.Добавить(ИмяФайла);
			КонецЕсли;
			
		КонецЦикла;
	Иначе
		Для Каждого ОбъектДляОбъединения Из ОбъектыДляОбъединения Цикл
			Изображение = Неопределено;
			Если ОбъектДляОбъединения = Неопределено Тогда
				Продолжить;
			ИначеЕсли ТипЗнч(ОбъектДляОбъединения) = Тип("ДвоичныеДанные") Тогда
				Изображение = Новый Картинка(ОбъектДляОбъединения);
			ИначеЕсли ТипЗнч(ОбъектДляОбъединения) = Тип("Строка") Тогда
				Если ЭтоАдресВременногоХранилища(ОбъектДляОбъединения) Тогда
					СодержимоеАдреса = ПолучитьИзВременногоХранилища(ОбъектДляОбъединения);
					Если ТипЗнч(СодержимоеАдреса) = Тип("ДвоичныеДанные") Тогда
						Изображение = Новый Картинка(СодержимоеАдреса);
					ИначеЕсли ТипЗнч(СодержимоеАдреса) = Тип("Картинка") Тогда
						Изображение = СодержимоеАдреса;
					КонецЕсли;
				Иначе
					Изображение = Новый Картинка(ОбъектДляОбъединения);
				КонецЕсли;
			ИначеЕсли РаботаСФайламиСлужебныйВызовСервера.ЭтоЭлементРаботаСФайлами(ОбъектДляОбъединения) Тогда
				ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайла(ОбъектДляОбъединения);
				СодержимоеАдреса = ПолучитьИзВременногоХранилища(ДанныеФайла.СсылкаНаДвоичныеДанныеФайла);
				Изображение = Новый Картинка(СодержимоеАдреса);
			КонецЕсли;
			
			Если Изображение <> Неопределено Тогда
				ИзображенияДляОбъединения.Добавить(Изображение);
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
	Возврат ИзображенияДляОбъединения;
КонецФункции

Функция РезультатОбъединенияВМногостраничныйДокумент()
	Результат = Новый Структура;
	Результат.Вставить("ИмяФайлаРезультата", "");
	Результат.Вставить("ДвоичныеДанные");
	Результат.Вставить("ОписаниеОшибки", "");
	Результат.Вставить("Успешно", Ложь);	
	Возврат Результат;
КонецФункции

Процедура ОбъединитьВМногостраничныйФайлПослеВыполненияКоманды(РезультатImageMagick, Контекст) Экспорт

	ФайлыИзображений = Контекст.ФайлыИзображений;
	ТипРезультата = Контекст.ТипРезультата;
	ИмяФайлаРезультата = Контекст.ИмяФайлаРезультата;
	ОповещениеВозврата = Контекст.ОповещениеВозврата;
	
	Результат = РезультатОбъединенияВМногостраничныйДокумент();

	Если РезультатImageMagick.КодВозврата <> 0 Тогда
		Результат.ОписаниеОшибки = РезультатImageMagick.ОписаниеОшибки;
		ВыполнитьОбработкуОповещения(ОповещениеВозврата, Результат);
		Возврат;
	КонецЕсли;
	
	Для Каждого ФайлИзображения Из ФайлыИзображений Цикл
		УдалитьФайлы(ФайлИзображения);
	КонецЦикла;
	
	Если ТипРезультата = ТипРезультатаКонвертацииИмяФайла() Тогда
		Результат.ИмяФайлаРезультата = ИмяФайлаРезультата;
	ИначеЕсли ТипРезультата = ТипРезультатаКонвертацииДвоичныеДанные() Тогда
		ДанныеPDF = Новый ДвоичныеДанные(ИмяФайлаРезультата);
		УдалитьФайлы(ИмяФайлаРезультата);
		Результат.ДвоичныеДанные =  ДанныеPDF;
	КонецЕсли;
	Результат.Успешно = Истина;
	
	ВыполнитьОбработкуОповещения(ОповещениеВозврата, Результат);
		
КонецПроцедуры

Процедура ДоступнаКомандаСканироватьЗавершение(РезультатПроверкиИнициализации, ОповещениеРезультата) Экспорт
	КомпонентаПроинициализирована = РезультатПроверкиИнициализации.Подключено;
	ВыполнитьОбработкуОповещения(ОповещениеРезультата, КомпонентаПроинициализирована);	
КонецПроцедуры

Процедура ПослеПроверкиНаличияПрограммыКонвертации(РезультатЗапуска, Контекст) Экспорт
	Если СтрНайти(РезультатЗапуска.ПотокВывода, "ImageMagick") = 0  Тогда
		НастройкиСканированияПользователя = Контекст.НастройкиСканированияПользователя;
		ПутьКПрограммеКонвертации = НастройкиСканированияПользователя.ПутьКПрограммеКонвертации;
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Ошибочно указан путь к программе %1.
		|Объединение многостраничных документов выполняется штатными средствами.
		|Указан путь: %2'"), "ImageMagick", ПутьКПрограммеКонвертации); 
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(),
			"Предупреждение", ТекстОшибки,, Истина);
		Контекст.ПараметрыКонвертацииГрафическогоДокумента.ИспользоватьImageMagick = Ложь;
	КонецЕсли;
	ОбъединитьВМногостраничныйФайлПродолжение(Контекст);
КонецПроцедуры
	
Процедура ОбъединитьВМногостраничныйФайлПродолжение(Контекст)
	ОповещениеВозврата = Контекст.ОповещениеВозврата;
	ОбъектыДляОбъединения = Контекст.ОбъектыДляОбъединения;
	ПараметрыКонвертацииГрафическогоДокумента = Контекст.ПараметрыКонвертацииГрафическогоДокумента;
	НастройкиСканированияПользователя = Контекст.НастройкиСканированияПользователя;
	
	ИспользоватьImageMagick = ПараметрыКонвертацииГрафическогоДокумента.ИспользоватьImageMagick; 
	ПутьКПрограммеКонвертации = НастройкиСканированияПользователя.ПутьКПрограммеКонвертации;
	
	Результат = РезультатОбъединенияВМногостраничныйДокумент();
	
	#Если Не ВебКлиент И Не МобильныйКлиент Тогда
	ИмяФайлаРезультата = ПараметрыКонвертацииГрафическогоДокумента.ИмяФайлаРезультата;
	
	Если Не ЗначениеЗаполнено(ИмяФайлаРезультата) Тогда
		// АПК:441-выкл файл не удаляется, если является результатом метода
		ИмяФайлаРезультата = ПолучитьИмяВременногоФайла(ПараметрыКонвертацииГрафическогоДокумента.ФорматРезультата);
		// АПК:441-вкл
	КонецЕсли;
	
	Если Не ИспользоватьImageMagick Тогда
		ИзображенияДляОбъединения = ИзображенияДляОбъединения(ОбъектыДляОбъединения);
		Если ПараметрыКонвертацииГрафическогоДокумента.ФорматРезультата = "pdf" Тогда
			ТабличныйДокумент = РаботаСФайламиСлужебныйВызовСервера.НовыйТабличныйДокументНаСервере(ИзображенияДляОбъединения.Количество());
			Поток = Новый ПотокВПамяти();
			ТабличныйДокумент.Записать(Поток, ТипФайлаТабличногоДокумента.PDF);
			
			ДокументPDF = Новый ДокументPDF();
			ДокументPDF.Прочитать(Поток);
			Для ИндексОбъекта = 0 По ИзображенияДляОбъединения.ВГраница() Цикл
				Описание = Новый ОписаниеОтображаемогоОбъектаPDF;
				Описание.Имя           = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Изображение № %1'"), ИндексОбъекта);
				Изображение = ИзображенияДляОбъединения[ИндексОбъекта];
				Ширина = Изображение.Ширина();
				Высота = Изображение.Высота();
				ОтношениеА4 = 210/297;
				
				Если ОтношениеА4*Высота > Ширина Тогда
					Описание.Высота        = 269; //297
					Описание.Ширина        = Описание.Высота * Ширина/Высота; //210
				Иначе
					Описание.Ширина        = 190; //210
					Описание.Высота        = Описание.Ширина * Высота/Ширина; //297 
				КонецЕсли;
				Описание.Лево          = 0;
				Описание.Верх          = 0;
				Описание.НомерСтраницы = ИндексОбъекта+1;
				Описание.Объект        = Изображение;
				ДокументPDF.ДобавитьОтображаемыйОбъект(Описание);
			КонецЦикла;
			ДокументPDF.Записать(Поток);
			ДанныеРезультата = Поток.ЗакрытьИПолучитьДвоичныеДанные();
		ИначеЕсли ПараметрыКонвертацииГрафическогоДокумента.ФорматРезультата = "tif" Тогда
			ИзображениеTif = РаботаСФайламиСлужебныйВызовСервера.ОбъединитьИзображенияВTifФайл(ИзображенияДляОбъединения);
			ДанныеРезультата = ИзображениеTif.ПолучитьДвоичныеДанные();
		КонецЕсли;
		
		Если ПараметрыКонвертацииГрафическогоДокумента.ТипРезультата = ТипРезультатаКонвертацииИмяФайла() Тогда
			ДанныеРезультата.Записать(ИмяФайлаРезультата);
			Результат.ИмяФайлаРезультата = ИмяФайлаРезультата;
			Результат.Успешно = Истина;
		ИначеЕсли ПараметрыКонвертацииГрафическогоДокумента.ТипРезультата = ТипРезультатаКонвертацииДвоичныеДанные() Тогда
			Результат.ДвоичныеДанные = ДанныеРезультата;
			Результат.Успешно = Истина;
		КонецЕсли;
		
		ВыполнитьОбработкуОповещения(ОповещениеВозврата, Результат);
	Иначе
		ФайлыИзображений = ИзображенияДляОбъединения(ОбъектыДляОбъединения, Истина);
		
		СтрокаФайловИзображений = """" + СтрСоединить(ФайлыИзображений, """" + " " + """") + """";
		КомандыСистемы = """" + ПутьКПрограммеКонвертации + """" +" "+ СтрокаФайловИзображений + " " +""""+ ИмяФайлаРезультата+"""";
		
		Контекст = Новый Структура;
		Контекст.Вставить("ФайлыИзображений", ФайлыИзображений);
		Контекст.Вставить("ТипРезультата", ПараметрыКонвертацииГрафическогоДокумента.ТипРезультата);
		Контекст.Вставить("ИмяФайлаРезультата", ИмяФайлаРезультата);
		Контекст.Вставить("ОповещениеВозврата", ОповещениеВозврата);
		
		ПараметрыЗапускаПрограммы = ФайловаяСистемаКлиент.ПараметрыЗапускаПрограммы();
		ПараметрыЗапускаПрограммы.ДождатьсяЗавершения = Истина;
		ПараметрыЗапускаПрограммы.Оповещение = Новый ОписаниеОповещения("ОбъединитьВМногостраничныйФайлПослеВыполненияКоманды", 
			ЭтотОбъект, Контекст);
		ФайловаяСистемаКлиент.ЗапуститьПрограмму(КомандыСистемы, ПараметрыЗапускаПрограммы);
				
	КонецЕсли;
	
	#КонецЕсли
КонецПроцедуры

Процедура НачатьПроверкуНаличияПрограммыКонвертации(ПутьКПрограммеКонвертации, ОповещениеРезультата) Экспорт
	
	//+бит Имитация успешной проверки наличия программы конвертации 
	// т.к. типовая проверка не работает
	//КомандыСистемы = """" + ПутьКПрограммеКонвертации + """ -version";
	//
	//ПараметрыЗапускаПрограммы = ФайловаяСистемаКлиент.ПараметрыЗапускаПрограммы();
	//ПараметрыЗапускаПрограммы.ДождатьсяЗавершения = Истина;
	//ПараметрыЗапускаПрограммы.ПолучитьПотокОшибок = Истина;
	//ПараметрыЗапускаПрограммы.ПолучитьПотокВывода = Истина;
	//
	//ПараметрыЗапускаПрограммы.Оповещение = ОповещениеРезультата;
	//ФайловаяСистемаКлиент.ЗапуститьПрограмму(КомандыСистемы, ПараметрыЗапускаПрограммы);
	РезультатЗапуска = Новый Структура;
	РезультатЗапуска.Вставить("ПотокВывода", "ImageMagick");
	ВыполнитьОбработкуОповещения(ОповещениеРезультата, РезультатЗапуска);
	//-бит
	
КонецПроцедуры


Функция СобытиеЖурналаРегистрации()
	
	Возврат НСтр("ru = 'Файлы'", ОбщегоНазначенияКлиент.КодОсновногоЯзыка());
	
КонецФункции


