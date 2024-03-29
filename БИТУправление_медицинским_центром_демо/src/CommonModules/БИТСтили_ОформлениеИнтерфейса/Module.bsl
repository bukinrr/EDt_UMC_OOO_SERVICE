#Область ПрограммныйИнтерфейс

// Действия при запуске системы
// 
// Возвращаемое значение:
//  Булево - треубется ли перезапуск сеанса.
//
Функция ПриЗапускеСистемы() Экспорт
	
	ТребуетсяПерезапуск = Ложь;
	ПервыйЗапуск = (ОбщегоНазначенияСервер.ПолучитьЗначениеКонстанты("НомерВерсииКонфигурации") = "");	
	
	УстановитьПривилегированныйРежим(Истина);
		
	Пользователь = Пользователи.ТекущийПользователь();
	НастройкиПользователя = ПолучитьНастройкиПользователя();
	ДефолтДляПользователя = ПолучитьДефолтДляПользователя(Пользователь);
	Если ДефолтДляПользователя <> Неопределено Тогда 
		ТребуетсяПерезапуск = НастройкиИнтерфейсаРазличны(НастройкиПользователя, ДефолтДляПользователя);
	КонецЕсли;
	Если ТребуетсяПерезапуск Тогда
		ПрименитьНастройкиКПользователю(, ДефолтДляПользователя, НастройкиПользователя);
	КонецЕсли;
	
	Если ПервыйЗапуск 
		И Не ЕстьУстановленныерасширенияСтилей()	
	Тогда
		УстановитьСтильИнтерфейсаПоУмолчанию();
		ТребуетсяПерезапуск = Истина;
	КонецЕсли;
	
	Возврат ТребуетсяПерезапуск;
	
КонецФункции

// Настройки пользователя
//
// Параметры:
//  ИмяПользователяИБ	 - Строка - Имя пользователя базы.
// 
// Возвращаемое значение:
//  Структура.
//
Функция ПолучитьНастройкиПользователя(ИмяПользователяИБ = Неопределено) Экспорт
	
	Соответствие = СоответствиеЗначенияНастройкиНазванию();
	
	Настройки = Новый Структура;
	Настройка = ХранилищеСистемныхНастроек.Загрузить("Общее/НастройкиИнтерфейсаКлиентскогоПриложения",,, );
	Если Не Настройка = Неопределено Тогда
		МассивРазделов = ПанелиИнтерфейса();
		
		Состав = Настройка.ПолучитьСостав();
		Настройки.Вставить("СоставПанелей", Состав);
		
		Для Каждого Элем из МассивРазделов Цикл
			Если ЕстьЭлементВКоллекцииНастроекИнтерфейса(Элем, Состав.Верх) Тогда
				Настройки.Вставить(Элем, "Верх");		
			ИначеЕсли ЕстьЭлементВКоллекцииНастроекИнтерфейса(Элем, Состав.Лево) Тогда 
				Настройки.Вставить(Элем, "Лево");	
			ИначеЕсли ЕстьЭлементВКоллекцииНастроекИнтерфейса(Элем, Состав.Право) Тогда
				Настройки.Вставить(Элем, "Право");	
			ИначеЕсли ЕстьЭлементВКоллекцииНастроекИнтерфейса(Элем, Состав.Низ) Тогда
				Настройки.Вставить(Элем, "Низ");	
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Настройка = ХранилищеСистемныхНастроек.Загрузить("Общее/ПанельРазделов/НастройкиКомандногоИнтерфейса",,, );
	Если Не Настройка = Неопределено Тогда
		Настройки.Вставить("ОтображениеПанелиРазделов", Соответствие.Получить(Настройка.ОтображениеПанелиРазделов));
	КонецЕсли;
	
	Настройка = ХранилищеСистемныхНастроек.Загрузить("Общее/НастройкиКлиентскогоПриложения",,, );
	Если Не Настройка = Неопределено Тогда
		Настройки.Вставить("ВариантИнтерфейсаКлиентскогоПриложения", Соответствие.Получить(Настройка.ВариантИнтерфейсаКлиентскогоПриложения));
		Настройки.Вставить("ВариантМасштабаФормКлиентскогоПриложения", Соответствие.Получить(Настройка.ВариантМасштабаФормКлиентскогоПриложения));
	КонецЕсли;
	
	Возврат Настройки;
	
КонецФункции

// Применяет настройки оформления к пользователю
//
// Параметры:
//  Пользователь	 - СправочникСсылка.Пользователи - пользователь
//  Настройки		 - Структура - структура настроек
//  ТекущиеНастройки - Структура - текущие настройки.
//
Процедура ПрименитьНастройкиКПользователю(Пользователь = Неопределено, Настройки, ТекущиеНастройки = Неопределено) Экспорт
	
	ИмяПользователя = ?(Пользователь <> Неопределено, Пользователь.Код, ИмяПользователя());
	
	Если ТекущиеНастройки = Неопределено Тогда
		ТекущиеНастройки = ПолучитьДефолтДляПользователя(Пользователь);
	КонецЕсли;
	
	Соответствие = СоответствиеНазванияНастройкиЗначению();
	
	// ОтображениеПанелиРазделов
	Настройка = Новый НастройкиКлиентскогоПриложения;
	
	Если Не Настройки.Свойство("ВариантИнтерфейсаКлиентскогоПриложения") Тогда
		Настройки.Вставить("ВариантИнтерфейсаКлиентскогоПриложения", "Такси");
		Настройки.Вставить("ВариантМасштабаФормКлиентскогоПриложения", "Компактный");
	КонецЕсли;
	УстановитьЗначениеНастройки(Настройка, "ВариантИнтерфейсаКлиентскогоПриложения",	 Соответствие, Настройки, ТекущиеНастройки);
	УстановитьЗначениеНастройки(Настройка, "ВариантМасштабаФормКлиентскогоПриложения",	 Соответствие, Настройки, ТекущиеНастройки);
	
	ХранилищеСистемныхНастроек.Сохранить("Общее/НастройкиКлиентскогоПриложения",,Настройка,,ИмяПользователя);
	
	// ОтображениеПанелиРазделов
	Настройка = Новый НастройкиКомандногоИнтерфейса;
	УстановитьЗначениеНастройки(Настройка, "ОтображениеПанелиРазделов",	 Соответствие, Настройки, ТекущиеНастройки);
	ХранилищеСистемныхНастроек.Сохранить("Общее/ПанельРазделов/НастройкиКомандногоИнтерфейса",,Настройка,,ИмяПользователя);
	
	// Расположение панелей
	НастройкаПанелей = Новый НастройкиИнтерфейсаКлиентскогоПриложения;
	Если ЕстьНастройкаРасположенияПанелей(Настройки) Тогда
		
		МассивРазделов = ПанелиИнтерфейса();
		
		Состав = НастройкаПанелей.ПолучитьСостав();
		Состав.Верх.Очистить();
		Состав.Лево.Очистить();
	    Состав.Право.Очистить();
		Состав.Низ.Очистить();
		
		ГруппаВерх = Новый ГруппаНастройкиСоставаИнтерфейсаКлиентскогоПриложения;
		ГруппаЛево = Новый ГруппаНастройкиСоставаИнтерфейсаКлиентскогоПриложения;
		ГруппаПраво = Новый ГруппаНастройкиСоставаИнтерфейсаКлиентскогоПриложения;
		ГруппаНиз = Новый ГруппаНастройкиСоставаИнтерфейсаКлиентскогоПриложения;
		Значение = "";
		
		Для Каждого Элем Из МассивРазделов Цикл
			Если Настройки.Свойство(Элем, Значение) Тогда
				
				Панель = Новый ЭлементНастройкиСоставаИнтерфейсаКлиентскогоПриложения(Элем);
				Если Значение = "Верх" Тогда
					ГруппаВерх.Добавить(Панель);
				ИначеЕсли Значение = "Лево" Тогда
					ГруппаЛево.Добавить(Панель);
				ИначеЕсли Значение = "Право" Тогда
					ГруппаПраво.Добавить(Панель);
				ИначеЕсли Значение = "Низ" Тогда
					ГруппаНиз.Добавить(Панель);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		Состав.Верх.Добавить(ГруппаВерх);
		Состав.Лево.Добавить(ГруппаЛево);
		Состав.Право.Добавить(ГруппаПраво);
		Состав.Низ.Добавить(ГруппаНиз);
	Иначе 
		// Оставляем текущие настройки пользователя
		Состав = ТекущиеНастройки.СоставПанелей;
	КонецЕсли;
	
	НастройкаПанелей.УстановитьСостав(Состав);
	ХранилищеСистемныхНастроек.Сохранить("Общее/НастройкиИнтерфейсаКлиентскогоПриложения",,НастройкаПанелей,,ИмяПользователя);
	
КонецПроцедуры

// Имена настроек интерфейса
// 
// Возвращаемое значение:
//  Массив - строки имен настроек.
//
Функция ИменаНастроекИнтерфейса() Экспорт
	
	СписокНастроек = ПанелиИнтерфейса();
	СписокНастроек.Добавить("ВариантИнтерфейсаКлиентскогоПриложения");
	СписокНастроек.Добавить("ВариантМасштабаФормКлиентскогоПриложения");
	СписокНастроек.Добавить("ОтображениеПанелиРазделов");
	
	Возврат СписокНастроек;
	
КонецФункции

// Панели интерфейса такси.
// 
// Возвращаемое значение:
//  Массив - имена панелей интерфейса.
//
Функция ПанелиИнтерфейса() Экспорт
	
	Панели = Новый Массив;
	
	Панели.Добавить("ПанельРазделов");
	Панели.Добавить("ПанельФункцийТекущегоРаздела");
	Панели.Добавить("ПанельИзбранного");
	Панели.Добавить("ПанельИстории");
	Панели.Добавить("ПанельОткрытых");
	
	Возврат Панели;
	
КонецФункции

// Возвращает префикс имени расширения для стиля
//
// Параметры:
//  Стиль	 - Булево	 - Истина возвращает префикс стиля, ложь - картинок
// 
// Возвращаемое значение:
//  Строка - Префикс имени расширения стиля 
//
Функция ПрефиксРасширенияСтиля(Стиль = Истина) Экспорт
	
	Если Стиль Тогда
		Возврат "СтильИнтерфейса_";	
	Иначе
		Возврат "АльтерИкон_";	
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьДефолтДляПользователя(Пользователь)
	
	Отбор = Новый Структура("Профиль");
	
	Если ЗначениеЗаполнено(Пользователь.Профиль) Тогда
		Отбор.Профиль = Пользователь.Профиль;
		Настройки = РегистрыСведений.БИТСтили_НастройкиИнтерфейсаПрофилей.Получить(Отбор).Настройка.Получить();
		Если Настройки <> Неопределено Тогда
			Возврат Настройки;
		КонецЕсли;
	КонецЕсли;
	
	Отбор.Профиль = Справочники.ПрофилиПользователей.ПустаяСсылка();
	Настройки = РегистрыСведений.БИТСтили_НастройкиИнтерфейсаПрофилей.Получить(Отбор).Настройка.Получить();
	
	Возврат Настройки;
	
КонецФункции

Функция НастройкиИнтерфейсаРазличны(НастройкиПользователя, ДефолтныеНастройки)
	
	СписокНастроек = ИменаНастроекИнтерфейса();
	
	Для Каждого ИмяНастройки Из СписокНастроек Цикл
		
		Если ДефолтныеНастройки.Свойство(ИмяНастройки) // Настройка предписана.
			И (Не НастройкиПользователя.Свойство(ИмяНастройки)
				Или ДефолтныеНастройки[ИмяНастройки] <> НастройкиПользователя[ИмяНастройки])
		Тогда
			Возврат Истина;		
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Функция УстановитьЗначениеНастройки(Настройка, ИмяНастройки, СоответствиеНазванийНастроекЗначениям, НовыеЗначения, ТекущиеЗначения)
	
	Если НовыеЗначения.Свойство(ИмяНастройки) Тогда
		Настройка[ИмяНастройки] = СоответствиеНазванийНастроекЗначениям.Получить(НовыеЗначения[ИмяНастройки]);
		
	ИначеЕсли ТекущиеЗначения.Свойство(ИмяНастройки) Тогда
		Настройка[ИмяНастройки] = СоответствиеНазванийНастроекЗначениям.Получить(ТекущиеЗначения[ИмяНастройки]);
	КонецЕсли;
	
КонецФункции

Функция ЕстьЭлементВКоллекцииНастроекИнтерфейса(Искомое, Коллекция)
	
	Результат = Ложь;
	
	Для Каждого Элемент Из Коллекция Цикл
		Если ТипЗнч(Элемент) = Тип("ГруппаНастройкиСоставаИнтерфейсаКлиентскогоПриложения") Тогда
			Результат = ЕстьЭлементВКоллекцииНастроекИнтерфейса(Искомое, Элемент);
		ИначеЕсли Элемент.Имя = Искомое Тогда
			Результат = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция СоответствиеНазванияНастройкиЗначению()
	
	Соответствие = Новый Соответствие;
	Соответствие.Вставить("Такси", ВариантИнтерфейсаКлиентскогоПриложения.Такси);
	Соответствие.Вставить("Версия8_2", ВариантИнтерфейсаКлиентскогоПриложения.Версия8_2);
	Соответствие.Вставить("Авто", ВариантМасштабаФормКлиентскогоПриложения.Авто);
	Соответствие.Вставить("Обычный", ВариантМасштабаФормКлиентскогоПриложения.Обычный);
	Соответствие.Вставить("Компактный", ВариантМасштабаФормКлиентскогоПриложения.Компактный);
	Соответствие.Вставить("Картинка", ОтображениеПанелиРазделов.Картинка);
	Соответствие.Вставить("Текст", ОтображениеПанелиРазделов.Текст);
	Соответствие.Вставить("КартинкаСверхуИТекст", ОтображениеПанелиРазделов.КартинкаСверхуИТекст);
	Соответствие.Вставить("КартинкаСлеваИТекст", ОтображениеПанелиРазделов.КартинкаСлеваИТекст);
	Соответствие.Вставить("КартинкаИТекст", ОтображениеПанелиРазделов.КартинкаИТекст);
	
	Возврат Соответствие;
	
КонецФункции

Функция СоответствиеЗначенияНастройкиНазванию()
	
	Соответствие = Новый Соответствие;
	
	СоответствиеНазвания = СоответствиеНазванияНастройкиЗначению();
	
	Для Каждого НазваниеЗначение Из СоответствиеНазвания Цикл
		Соответствие.Вставить(НазваниеЗначение.Значение, НазваниеЗначение.Ключ);
	КонецЦикла;
	
	Возврат Соответствие;
	
КонецФункции

// Определяет, есть ли в настройке интерфейса настройка расположения панелей.
//
// Параметры:
//  НастройкиИнтерфейса	 - Структура - настройки интерфейса.
// 
// Возвращаемое значение:
//  Булево - есть ли настройка.
//
Функция ЕстьНастройкаРасположенияПанелей(НастройкиИнтерфейса) Экспорт
	
	Для Каждого Панель Из ПанелиИнтерфейса() Цикл
		Если НастройкиИнтерфейса.Свойство(Панель) Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Процедура УстановитьСтильИнтерфейсаПоУмолчанию()
	
	Макеты = ПолучитьСтильИнтерфейсаПоУмолчанию();
	
	Для Каждого Макет Из Макеты Цикл
		ДвоичныеДанныеАрхива = Обработки.БИТСтили_УправлениеИнтерфейсомПользователей.ПолучитьМакет(Макет);
		
		ИмяФайлаАрхива = ПолучитьИмяВременногоФайла("zip");
		ДвоичныеДанныеАрхива.Записать(ИмяФайлаАрхива);
		ЧтениеZip = Новый ЧтениеZipФайла(ИмяФайлаАрхива);
		
		КаталогАрхива = ПолучитьИмяВременногоФайла();
		ЧтениеZip.ИзвлечьВсе(КаталогАрхива, РежимВосстановленияПутейФайловZIP.НеВосстанавливать);
		
		СистемнаяИнформация = Новый СистемнаяИнформация;
		ОбщегоНазначенияКлиентСервер.ДобавитьСлешЕслиНужно(КаталогАрхива, СистемнаяИнформация.ТипПлатформы);
		
		Для Каждого ЭлементZip Из ЧтениеZip.Элементы Цикл
			
			ИмяФайлаЭлемента = КаталогАрхива +  ЭлементZip.Имя;
			
			Если ЭлементZip.Расширение = "cfe" Тогда
				// Расширение конфигурации
				Расширение = Новый ДвоичныеДанные(ИмяФайлаЭлемента);
				
			ИначеЕсли НРег(ЭлементZip.Имя) = "default.json" Тогда
				// Настройки по умолчанию панелей для расширения
				Настройки = ПолучитьНастройкиПанелей(ИмяФайлаЭлемента); 	
			КонецЕсли;
			
		КонецЦикла;
		
		ЧтениеZip.Закрыть();
		
		УстановитьРасширение(Расширение, Настройки);
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьНастройкиПанелей(ИмяФайлаНастроек)
	
	Чтение = Новый ЧтениеJSON;
	Чтение.ОткрытьФайл(ИмяФайлаНастроек);
	Настройки = Новый Структура;
	Пока Чтение.Прочитать() Цикл
		Тип = Чтение.ТипТекущегоЗначения;
		Если Тип = ТипЗначенияJSON.ИмяСвойства Тогда
			ИмяСвойства = Чтение.ТекущееЗначение;
		ИначеЕсли Тип = ТипЗначенияJSON.Строка Тогда
			Настройки.Вставить(ИмяСвойства, Чтение.ТекущееЗначение);
		КонецЕсли;
	КонецЦикла;
	
	// Если не указан вариант интерфейса по умолчанию - ставим такси компактный
	Если Не Настройки.Свойство("ВариантИнтерфейсаКлиентскогоПриложения") Тогда
		Настройки.Вставить("ВариантИнтерфейсаКлиентскогоПриложения", "Такси");
		Настройки.Вставить("ВариантМасштабаФормКлиентскогоПриложения", "Компактный");
	КонецЕсли;
	
КонецФункции

Процедура УстановитьРасширение(ДвоичныеДанные, НастройкиПанелей)
	
	// Сохранение расширения
	НовоеРасширение = РасширенияКонфигурации.Создать();
	НовоеРасширение.БезопасныйРежим = Ложь;
	НовоеРасширение.ЗащитаОтОпасныхДействий.ПредупреждатьОбОпасныхДействиях = Ложь;
	НовоеРасширение.Записать(ДвоичныеДанные);
	
	// Сохранение дефолтных настроек панелей.
	
	// Объединение с текущими общими настройками
	ЗаписьТекущие = РегистрыСведений.БИТСтили_НастройкиИнтерфейсаПрофилей.СоздатьМенеджерЗаписи();
	ЗаписьТекущие.Профиль = Неопределено;
	ЗаписьТекущие.Прочитать();
	Если ЗаписьТекущие.Выбран() Тогда
		НастройкиТекущие = ЗаписьТекущие.Настройка.Получить();
		
		Если НастройкиТекущие <> Неопределено Тогда
			Для Каждого КлючЗначение Из НастройкиТекущие Цикл
				Если Не НастройкиПанелей.Свойство(КлючЗначение.Ключ) Тогда
					НастройкиПанелей.Вставить(КлючЗначение.Ключ, КлючЗначение.Значение);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Запись = РегистрыСведений.БИТСтили_НастройкиИнтерфейсаПрофилей.СоздатьМенеджерЗаписи();
	Запись.Профиль = Неопределено;
	Запись.Настройка = Новый ХранилищеЗначения(НастройкиПанелей);
	Запись.Записать();
	
КонецПроцедуры

Функция ЕстьУстановленныерасширенияСтилей()
	
	ЕстьУстановленныеРасширенияСтилей = Ложь;
	
	Расширения = РасширенияКонфигурации.Получить();
	Для Каждого Расширение Из Расширения Цикл
		Если Лев(Расширение.Имя, 16) = ПрефиксРасширенияСтиля() 
			Или Лев(Расширение.Имя, 11) = ПрефиксРасширенияСтиля(Ложь)
		Тогда
			ЕстьУстановленныеРасширенияСтилей = Истина;			
		КонецЕсли;
	КонецЦикла;
	
	Возврат ЕстьУстановленныеРасширенияСтилей;
	
КонецФункции

Функция ПолучитьСтильИнтерфейсаПоУмолчанию()
	
	МассивМакетов = Новый Массив;
	МассивМакетов.Добавить("СтильИнтерфейса_СтерильныйПромежуточный");
	МассивМакетов.Добавить("АльтерИкон_ЧБ");
	
	Возврат МассивМакетов;
	
КонецФункции

#КонецОбласти
