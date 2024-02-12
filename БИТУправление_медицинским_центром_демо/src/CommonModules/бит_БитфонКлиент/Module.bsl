///////////////////////////////////////////////////////////////////////////////
// Общий клиентский модуль БИТ.Phone софтфон
// Содержит функции, не зависящие от конфигурации.
///////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Воспроизводит запись разговора.
// Если путь к записи - интернет-ссылка, ссылка открывается в браузере по умолчанию.
// Если путь к записи - путь к файлу:
//   - Запись воспроизводится системным проигрывателем по умолчанию, если не используется стационарный телефон.
//   - Если включен режим использования стационарного телефона, запись воспроизводится на стационарном телефоне.
//
// Параметры:
//  стрПутьКЗаписи - Строка - полное имя файла или ссылка на запись разговора.
//
Процедура ВоспроизвестиЗаписьРазговора(стрПутьКЗаписи) ЭКСПОРТ
	
	Если НЕ ЗначениеЗаполнено(стрПутьКЗаписи) Тогда
		бит_ТелефонияКлиент.ВывестиСообщение("Запись не найдена");
		Возврат;
	КонецЕсли;
	
	стрСервисЗаписейНаАТС = бит_АТСКлиент.ПутьСервисаЗаписейРазговоровНаАТС();
	
	Если Найти(стрПутьКЗаписи, стрСервисЗаписейНаАТС) = 0 Тогда
		бит_ТелефонияКлиентПереопределяемый.ЗапускПрограммы(стрПутьКЗаписи);
	Иначе
		бит_ТелефонияКлиент.ОткрытьФайлИлиСсылку(стрПутьКЗаписи);
	КонецЕсли;
	
КонецПроцедуры

// Открывает основную форму.
//
Процедура ОткрытьБитфон() ЭКСПОРТ
	бит_ТелефонияКлиент.ОткрытьФормуВыполнитьДействие(ПолучитьИмяФормыБитфона(), "", "");
КонецПроцедуры

// Открывает основную форму и начинает исходящий вызов на заданный номер.
//
// Параметры:
//  Контакт - Строка - номер телефона, также принимается ссылка на контрагента или контактное лицо.
//
Процедура ОткрытьБитфонНачатьРазговор(Контакт) ЭКСПОРТ
	бит_ТелефонияКлиентПереопределяемый.ВыбратьНомерКонтактаИОповестить(Контакт, ПолучитьИмяФормыБитфона(), "БитФон_НачатьРазговор");
КонецПроцедуры

// Возвращает имя формы БИТ.Phone софтфона
// Возвращаемое значение:
//   Строка - имя формы.
Функция ПолучитьИмяФормыБитфона() ЭКСПОРТ
	Возврат "Обработка.бит_Битфон.Форма";
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Формирует полный номер телефона с префиксами выхода в город и на междугороднюю линию.
// Из номера удаляются лишние символы.
// Если номер уже с префиксами, то сначала префиксы удаляются.
//
// Параметры:
//  стрНомерИсх - Строка - номер телефона.
//
// Возвращаемое значение:
//   Строка - сформированный полный номер с префиксами, очищенный от лишних символов.
//
Функция СформироватьНомерСПрефиксами(стрНомерИсх) ЭКСПОРТ
	флагПрямойНабор		= бит_БитфонСервер.ПолучитьФлагИспользоватьПрямойНабор();
	стрПрефиксВнешЛинии	= бит_БитфонСервер.ПолучитьПрефиксВыходаНаВнешнююЛинию();
	Возврат бит_ТелефонияКлиент.СформироватьНомерСПрефиксами(стрНомерИсх, флагПрямойНабор, стрПрефиксВнешЛинии);
КонецФункции

// Возвращает имя файла для записи разговора.
// Имя файла формируется на основе текущей даты.
// Если такой файл уже существует, он удаляется.
//
// Возвращаемое значение:
//   Строка - полное имя файла (с путем).
//
Функция ПолучитьИмяФайлаДляЗаписи() ЭКСПОРТ
	стрИмяФайла = "";
	стрКаталогЗаписей = бит_БитфонСервер.ПолучитьДиректориюЗаписанныхФайлов();
	Если ЗначениеЗаполнено(стрКаталогЗаписей) Тогда
		форматФайлаЗаписи = бит_БитфонСервер.ПолучитьФорматЗаписи();
		Если форматФайлаЗаписи = ПредопределенноеЗначение("Перечисление.бит_ФорматЗаписи.gsm") Тогда
			стрРасширениеФайлаЗаписи = "wav";
		Иначе
			стрРасширениеФайлаЗаписи = Строка(форматФайлаЗаписи);
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(стрРасширениеФайлаЗаписи) Тогда
			стрРасширениеФайлаЗаписи = "wav";
		КонецЕсли;
		стрИмяФайла = стрКаталогЗаписей + "\" + бит_ТелефонияКлиент.ПолучитьИмяФайлаЗаписиСДатой(ТекущаяДата()) + "." + стрРасширениеФайлаЗаписи;
	Иначе
		бит_ТелефонияКлиент.ВывестиСообщение("Не найдено значение директории для записанных файлов в настройках");
	КонецЕсли;
	Возврат стрИмяФайла;
КонецФункции

// Открывает форму настроек для текущего пользователя.
//
// Параметры:
//  Софтфон - ссылка на объект софтфона.
//
Процедура ОткрытьФормуНастроек(Софтфон) ЭКСПОРТ
	СтарыеНастройки = Новый Структура();
	СтарыеНастройки.Вставить("СобственныйНомер",		бит_БитфонСервер.ПолучитьСвойНомер());
	СтарыеНастройки.Вставить("ГлубинаИсторииЗвонков",	бит_БитфонСервер.ПолучитьГлубинуИсторииЗвонков());
	СтарыеНастройки.Вставить("УровеньЛоггирования",		бит_БитфонСервер.ПолучитьУровеньЛоггирования());
	СтарыеНастройки.Вставить("ПолучениеСтатусов",		бит_БитфонСервер.ПолучитьФлагПолучениеСтатусовАбонентов());
	СтарыеНастройки.Вставить("РежимНесколькихВход",		бит_БитфонСервер.ПолучитьФлагПриниматьНесколькоВходящих());
	СтарыеНастройки.Вставить("РазворачПриВхЗвонке",		бит_БитфонСервер.ПолучитьФлагРазворачиватьОкноПриВходящемЗвонке());
	СтарыеНастройки.Вставить("УстройствоЗвукаВхЗвонка",	бит_БитфонСервер.ПолучитьУстройствоВыводаЗвукаВходящегоЗвонка());
	СтарыеНастройки.Вставить("ТипВходящегоЗвонка",		бит_БитфонСервер.ПолучитьТипВходящегоЗвонка());
	СтарыеНастройки.Вставить("ФайлВходящегоЗвонка",		бит_БитфонСервер.ПолучитьФайлВходящегоЗвонка());
	СтарыеНастройки.Вставить("ПолучениеЗаписейСБИТАТС",	бит_БитфонСервер.ПолучитьФлагПолучатьЗаписиРазговоровСБИТАТС());
	//
	ПараметрыФормыНастроек = бит_БитфонСервер.ПолучитьПараметрыОткрытияФормыНастроек();
	//
	стрСписокУстройствВыводаЗвука = "";	// Список устройств вывода звука на компьютере,
										// разделители списка - точка с запятой,
										// элемент списка имеет вид Устройство:Драйвер.
	Если Софтфон <> Неопределено Тогда
		Попытка
			стрСписокУстройствВыводаЗвука = Софтфон.GetPlaybackDevicesList();
		Исключение
			бит_ТелефонияКлиентПереопределяемый.ПоказПредупреждение("Ошибка получения списка устройств воспроизведения звука");
		КонецПопытки;
	КонецЕсли;
	ПараметрыФормыНастроек.Вставить("СписокУстройствВывода", стрСписокУстройствВыводаЗвука);
	//
	фрмНастройки = ПолучитьФорму("РегистрСведений.бит_БитфонНастройки.Форма.ФормаЗаписиБезПользователя", ПараметрыФормыНастроек);
	фрмНастройки.Элементы.РазрешенныйАдрес.Видимость = Ложь;
	бит_ТелефонияКлиентПереопределяемый.ОткрытьФормуСБлокировкойВладельца(фрмНастройки, "БитФон_ОбновлениеНастроек", СтарыеНастройки);
КонецПроцедуры

// Отправляет по электронной почте письмо в техподдержку.
// В приложении к письму добавляется архив с лог-файлами.
//
Процедура ОтправитьЗапросВТехподдержкуСАрхивомЛога() ЭКСПОРТ
	фрмОтправкаЗапроса = ПолучитьФорму("Обработка.бит_Битфон.Форма.ОтправкаЗапросаВТехподдержку");
	бит_ТелефонияКлиентПереопределяемый.ОткрытьФормуСБлокировкойВладельца(фрмОтправкаЗапроса);
КонецПроцедуры

//
// Работа с ВК софтфона
//

// Подключает внешнюю компоненту софтфона.
// При необходимости компонента устанавливается.
//
Процедура ПодключитьСофтфон(ИмяОповещения, ПараметрОповещения=Неопределено) ЭКСПОРТ
#Если ВебКлиент Тогда
	бит_ТелефонияКлиент.ВывестиСообщение("Работа софтфона в режиме веб-клиента не поддерживается");
	Возврат;
#КонецЕсли
	Попытка
		стрИмяФайлаВК = ? ( бит_ТелефонияКлиент.Клиент64бит(), "NativeSoftPhone64.dll", "NativeSoftPhone.dll");
		бит_ТелефонияКлиентПереопределяемый.ПодключениеВнешнейКомпоненты(
								"ОбщийМакет.бит_Софтфон",
								стрИмяФайлаВК,
								"бит_БитфонСервер",
								"SoftPhoneNative",
								"БИТ.Phone",
								ИмяОповещения,
								ПараметрОповещения);
	Исключение
		бит_ТелефонияКлиент.ВывестиСообщение(ОписаниеОшибки());
	КонецПопытки;
КонецПроцедуры

// Проверка возможности подключения к внешнему ресурсу.
//
// Параметры:
//  стрИмяСобытия - Строка, имя события для оповещения продолжения подключения.
//
// Возвращаемое значение:
//   Булево - флаг успешности проверки.
//
Функция ПроверкаРазрешенногоАдреса(Софтфон, стрИмяСобытия) ЭКСПОРТ
	стрРазрешенныйАдрес = бит_БитфонСервер.ПолучитьРазрешенныйАдрес();
	стрАдресПодключения = бит_БитфонСервер.ПолучитьПараметрыСоединения().АдресСервера;
	Если стрРазрешенныйАдрес = стрАдресПодключения Тогда
		Возврат ИнициализироватьСофтфонРегистрацияНаАТС(Софтфон);
	Иначе
		стрЗапросНовогоПодключения = "Разрешить подключение к АТС по адресу '" + стрАдресПодключения + "'?";
		бит_ТелефонияКлиентПереопределяемый.ПоказВопрос(стрЗапросНовогоПодключения,
			РежимДиалогаВопрос.ДаНет, , , , стрИмяСобытия, стрАдресПодключения);
		Возврат Ложь;
	КонецЕсли;
КонецФункции

// Начальная инициализация объекта софтфона и регистрация на АТС.
//
// Параметры:
//  Софтфон - ссылка на объект софтфона.
//
// Возвращаемое значение:
//   Булево - флаг успешности инициализации.
//
Функция ИнициализироватьСофтфонРегистрацияНаАТС(Софтфон) ЭКСПОРТ
	
	Если Софтфон = Неопределено Тогда
		бит_ТелефонияКлиент.ВывестиСообщение("БИТ.Phone - Ошибка! Не создан объект Софтфона.");
		Возврат Ложь;
	КонецЕсли;
	
	ПараметрыСоединения = бит_БитфонСервер.ПолучитьПараметрыСоединения();
	
	стрСерверЛицензийАдрес		= бит_БитфонСервер.ПолучитьАдресСервераЛицензий();
	серверЛицензийПорт			= бит_БитфонСервер.ПолучитьПортСервераЛицензий();
	серверЛицензийНеИспПрокси	= бит_БитфонСервер.ПолучитьФлагСервераЛицензийНеИспользоватьПрокси();
	уровеньЛоггирования			= бит_БитфонСервер.ПолучитьУровеньЛоггирования();
	
	Попытка
		ИнициализацияУспешна = Софтфон.Init(уровеньЛоггирования, ПараметрыСоединения.Логин, ПараметрыСоединения.RTPПорт,
										ПараметрыСоединения.ДетекторАктивностиМикрофона,
										стрСерверЛицензийАдрес, серверЛицензийПорт, серверЛицензийНеИспПрокси);
		Если НЕ ИнициализацияУспешна Тогда
			бит_ТелефонияКлиент.ВывестиСообщение("БИТ.Phone - Ошибка! Не удалось инициализировать Софтфон.");
			Возврат Ложь;
		КонецЕсли;
	Исключение
		бит_ТелефонияКлиент.ВывестиСообщение("БИТ.Phone - Ошибка! Не удалось инициализировать Софтфон. Исключение: " + ОписаниеОшибки());
		Возврат Ложь;
	КонецПопытки;
	
	Попытка
		списокКодеков = бит_БитфонСервер.ПолучитьСписокКодеков();
		Если НЕ ЗначениеЗаполнено(списокКодеков) Тогда
			списокКодеков = Софтфон.GetCodecs();
			
			// UISCOM
			Если бит_БитфонСервер.ПолучитьПрофильНастроек() = ПредопределенноеЗначение("Перечисление.бит_ПрофилиНастроекБИТPhone.UISCOM") Тогда
				списокКодеков = УстановкаПриоритетаКодекаPCMA(списокКодеков, 131);
			КонецЕсли;
			
			бит_БитфонСервер.УстановитьСписокКодеков(списокКодеков);
		КонецЕсли;
		
		массКодеков = РазобратьСписокКодеков(списокКодеков);
		Для Каждого кодекПриор Из массКодеков Цикл
			Софтфон.SetCodecPriority(кодекПриор.Кодек, кодекПриор.Приоритет);
		КонецЦикла;
	Исключение
		бит_ТелефонияКлиент.ВывестиСообщение("БИТ.Phone - Ошибка! Не удалось установить список кодеков. Исключение: " + ОписаниеОшибки());
		Возврат Ложь;
	КонецПопытки;
	
	многоканальныйРежим = бит_БитфонСервер.ПолучитьФлагПриниматьНесколькоВходящих();
	Попытка
		Софтфон.SetMultichannelMode(многоканальныйРежим);
	Исключение
		бит_ТелефонияКлиент.ВывестиСообщение("БИТ.Phone - Ошибка! Не удалось установить режим многоканальности. Исключение: " + ОписаниеОшибки());
		Возврат Ложь;
	КонецПопытки;
	
	разворачиватьПриВходящемЗвонке = бит_БитфонСервер.ПолучитьФлагРазворачиватьОкноПриВходящемЗвонке();
	Попытка
		Софтфон.SetActivateOnIncomingCall(разворачиватьПриВходящемЗвонке);
	Исключение
		бит_ТелефонияКлиент.ВывестиСообщение("БИТ.Phone - Ошибка! Не удалось установить флаг разворачивания окна при входящем звонке. Исключение: " + ОписаниеОшибки());
		Возврат Ложь;
	КонецПопытки;
	
	устройствоВыводаЗвукаВходящегоЗвонка = бит_БитфонСервер.ПолучитьУстройствоВыводаЗвукаВходящегоЗвонка();
	Если ЗначениеЗаполнено(устройствоВыводаЗвукаВходящегоЗвонка) Тогда
		Попытка
			Софтфон.SetRingPlaybackDevice(устройствоВыводаЗвукаВходящегоЗвонка);
		Исключение
			бит_ТелефонияКлиент.ВывестиСообщение("БИТ.Phone - Ошибка! Не удалось задать устройство вывода звука " +
				устройствоВыводаЗвукаВходящегоЗвонка + " для входящего звонка. Исключение: " + ОписаниеОшибки());
			Возврат Ложь;
		КонецПопытки;
	КонецЕсли;
	
	типВходящегоЗвонка = бит_БитфонСервер.ПолучитьТипВходящегоЗвонка();
	Если типВходящегоЗвонка <> 0 Тогда
		стрФайлВходящегоЗвонка = бит_БитфонСервер.ПолучитьФайлВходящегоЗвонка();
		Попытка
			Софтфон.SetRingType(типВходящегоЗвонка, стрФайлВходящегоЗвонка);
		Исключение
			бит_ТелефонияКлиент.ВывестиСообщение("БИТ.Phone - Ошибка! Не удалось задать тип входящего звонка. Исключение: " + ОписаниеОшибки());
			Возврат Ложь;
		КонецПопытки;
	КонецЕсли;
	
	Если ПустаяСтрока(ПараметрыСоединения.Логин) Тогда
		бит_ТелефонияКлиент.ВывестиСообщение("БИТ.Phone - Ошибка! Получить параметры соединения не удалось");
		Возврат Ложь;
	КонецЕсли;
	
	СвойНомер = бит_БитфонСервер.ПолучитьСвойНомер();
	Если ПустаяСтрока(СвойНомер) Тогда
		бит_ТелефонияКлиент.ВывестиСообщение("БИТ.Phone - Ошибка! Не задан свой номер в настройках");
		Возврат Ложь;
	КонецЕсли;
	
	Попытка
		СофтФон.Register(ПараметрыСоединения.Логин, ПараметрыСоединения.АдресСервера, ПараметрыСоединения.АдресПрокси,
			ПараметрыСоединения.CallerID, ПараметрыСоединения.IDАвторизации, ПараметрыСоединения.Пароль,
			Строка(ПараметрыСоединения.Протокол), ПараметрыСоединения.ИнтервалПеререгистрации, ПараметрыСоединения.АвтоопределениеNAT);
	Исключение
		бит_ТелефонияКлиент.ВывестиСообщение("БИТ.Phone - Ошибка! Не удалось зарегистрироваться на АТС. " + ОписаниеОшибки());
		Возврат Ложь;
	КонецПопытки;

	Возврат Истина;
КонецФункции

// Обработчик изменения профиля настроек.
//
// Параметры:
//  Запись - ссылка запись регистра сведений настроек.
//  флагВыводитьСообщения - Булево, Истина для вывода сообщений при изменении настроек.
//
Процедура ОбработчикИзмененияПрофиляНастроек(Запись, флагВыводитьСообщения) ЭКСПОРТ
	
	стрАдресСервераПоУмолчаниюМанго = "mangosip.ru";
	стрАдресСервераПоУмолчаниюUISCOM = "voip.uiscom.ru:9060";
	стрАдресСервераПоУмолчаниюСкорозвон = "31.186.102.42";
	
	соотвСписокСерверов = Новый Соответствие();
	соотвСписокСерверов.Вставить(стрАдресСервераПоУмолчаниюМанго, "");
	соотвСписокСерверов.Вставить(стрАдресСервераПоУмолчаниюUISCOM, "");
	соотвСписокСерверов.Вставить(стрАдресСервераПоУмолчаниюСкорозвон, "");
	
	ключСервер = соотвСписокСерверов.Получить(Запись.АдресСервера);
	
	//
	Если Запись.ПрофильНастроек = ПредопределенноеЗначение("Перечисление.бит_ПрофилиНастроекБИТPhone.Манго") Тогда
		Если (НЕ ЗначениеЗаполнено(Запись.АдресСервера))
			ИЛИ (ключСервер <> Неопределено)
		Тогда
			Запись.АдресСервера = стрАдресСервераПоУмолчаниюМанго;
		КонецЕсли;
	КонецЕсли;
	
	//
	Если Запись.ПрофильНастроек = ПредопределенноеЗначение("Перечисление.бит_ПрофилиНастроекБИТPhone.UISCOM") Тогда
		Если (НЕ ЗначениеЗаполнено(Запись.АдресСервера))
			ИЛИ (ключСервер <> Неопределено)
		Тогда
			Запись.АдресСервера = стрАдресСервераПоУмолчаниюUISCOM;
		КонецЕсли;
		
		Запись.RTPПорт = 10000;
		Запись.СписокКодеков = УстановкаПриоритетаКодекаPCMA(Запись.СписокКодеков, 131);
	Иначе
		Запись.RTPПорт						= бит_БитфонСервер.ПолучитьRTPПортПоУмолчанию();
		Запись.СписокКодеков				= УстановкаПриоритетаКодекаPCMA(Запись.СписокКодеков, 128);
	КонецЕсли;
	
	//
	Если Запись.ПрофильНастроек = ПредопределенноеЗначение("Перечисление.бит_ПрофилиНастроекБИТPhone.Скорозвон") Тогда
		Если (НЕ ЗначениеЗаполнено(Запись.АдресСервера))
			ИЛИ (ключСервер <> Неопределено)
		Тогда
			Запись.АдресСервера = стрАдресСервераПоУмолчаниюСкорозвон;
		КонецЕсли;
		
		Запись.АвтоопределениеNAT	= Ложь;
		Запись.АдресПрокси = "31.186.102.42:5020";
	Иначе
		Запись.АвтоопределениеNAT	= бит_БитфонСервер.ПолучитьФлагАвтоопределениеNATПоУмолчанию();
		Запись.АдресПрокси = "";
	КонецЕсли;
	
	// общие параметры для нескольких профилей
	Запись.ПрефиксВыходаНаВнешнююЛинию = ПолучитьПрефиксВыходаНаВнешнююЛиниюПрофиля(Запись.ПрофильНастроек);
	
	// настройки для БИТ.АТС и произвольные
	Если (Запись.ПрофильНастроек = ПредопределенноеЗначение("Перечисление.бит_ПрофилиНастроекБИТPhone.БИТ_АТС"))
		ИЛИ (Запись.ПрофильНастроек = ПредопределенноеЗначение("Перечисление.бит_ПрофилиНастроекБИТPhone.Произвольные"))
	Тогда
		Если ключСервер <> Неопределено Тогда
			Запись.АдресСервера = "";
		КонецЕсли;
	Иначе
		Если Запись.ТипПереводаЗвонка = ПредопределенноеЗначение("Перечисление.бит_ТипПереводаЗвонка.Условный") Тогда
			Если флагВыводитьСообщения Тогда
				бит_ТелефонияКлиент.ВывестиСообщение("Условный тип перевода доступен только при использовании БИТ.АТС, изменен на безусловный");
			КонецЕсли;
			Запись.ТипПереводаЗвонка = ПредопределенноеЗначение("Перечисление.бит_ТипПереводаЗвонка.Безусловный");
		КонецЕсли;
		//
		Если Запись.ИспользоватьКомандуНеБеспокоитьНаАТС Тогда
			Если флагВыводитьСообщения Тогда
				бит_ТелефонияКлиент.ВывестиСообщение("Команда 'Не беспокоить' на АТС доступна только при использовании БИТ.АТС, отключена");
			КонецЕсли;
			Запись.ИспользоватьКомандуНеБеспокоитьНаАТС = Ложь;
		КонецЕсли;
		//
		Если Запись.ПолучатьЗаписиРазговоровСБИТАТС Тогда
			Если флагВыводитьСообщения Тогда
				бит_ТелефонияКлиент.ВывестиСообщение("Получение записей разговоров возможно только с БИТ.АТС, отключено");
			КонецЕсли;
			Запись.ПолучатьЗаписиРазговоровСБИТАТС = Ложь;
		КонецЕсли;
		//
		Если Запись.ПроверкаСтатусаНомераПередПереводом Тогда
			Если флагВыводитьСообщения Тогда
				бит_ТелефонияКлиент.ВывестиСообщение("Проверка статуса номера перед переводом возможна только с БИТ.АТС, отключена");
			КонецЕсли;
			Запись.ПроверкаСтатусаНомераПередПереводом = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Разбор строки со списком кодеков.
//
// Параметры:
//  стрСписокКодеков - Строка, список кодеков в формате 'кодек1=приоритет1;кодек1=приоритет2;...'.
//
// Возвращаемое значение:
//  массив структур с полями
//    Кодек - Строка,
//    Приоритет - Число.
//
Функция РазобратьСписокКодеков(стрСписокКодеков) ЭКСПОРТ
	массКодеки = Новый Массив;
	
	списокСПриоритетом = бит_ТелефонияКлиентСервер.СтрРазбить(стрСписокКодеков, ";");
	Для Каждого кодекПриорЭл Из списокСПриоритетом Цикл
		стрКодекПриор = кодекПриорЭл.Значение;
		индекс = Найти(стрКодекПриор, "=");
		Если индекс > 0 Тогда
			стрКодек = Лев(стрКодекПриор, индекс-1);
			стрПриор = Сред(стрКодекПриор, индекс+1);
			приор = Число(стрПриор);
			структКодекПриор = Новый Структура();
			структКодекПриор.Вставить("Кодек", стрКодек);
			структКодекПриор.Вставить("Приоритет", приор);
			массКодеки.Добавить(структКодекПриор);
		КонецЕсли;
	КонецЦикла;
	
	Возврат массКодеки;
КонецФункции

//-----------------------------------------------------------------------------
// Коды картинок статусов:
// 0 - не найден
// 1 - свободен
// 2 - разговаривает
// 3 - не доступен
// 4 - ожидание
Функция ПолучитьИндексКартинкиСтатуса(СтатусНомера, ОписаниеСтатуса) ЭКСПОРТ
	ИндексКартинкиСтатуса = 0;
	Если СтатусНомера = 0 Тогда
		ИндексКартинкиСтатуса = 0;
	ИначеЕсли СтатусНомера = 2 Тогда
		ИндексКартинкиСтатуса = 3;
	ИначеЕсли СтатусНомера = 1 Тогда
		Если ОписаниеСтатуса = "On hold" Тогда
			ИндексКартинкиСтатуса = 4;
		ИначеЕсли ОписаниеСтатуса = "On the phone" Тогда
			ИндексКартинкиСтатуса = 2;
		ИначеЕсли ОписаниеСтатуса = "Ready" Тогда
			ИндексКартинкиСтатуса = 1;
		КонецЕсли;
	КонецЕсли;
	Возврат ИндексКартинкиСтатуса;
КонецФункции

Функция ПолучитьОписаниеСтатусаПоИндексуКартинки(ИндексКартинкиСтатуса) ЭКСПОРТ
	СтрокаСтатуса = "";
	Если ИндексКартинкиСтатуса = 0 Тогда
		СтрокаСтатуса = "не найден";
	ИначеЕсли ИндексКартинкиСтатуса = 1 Тогда
		СтрокаСтатуса = "свободен";
	ИначеЕсли ИндексКартинкиСтатуса = 2 Тогда
		СтрокаСтатуса = "разговаривает";
	ИначеЕсли ИндексКартинкиСтатуса = 3 Тогда
		СтрокаСтатуса = "не доступен";
	ИначеЕсли ИндексКартинкиСтатуса = 4 Тогда
		СтрокаСтатуса = "ожидание";
	КонецЕсли;
	Возврат СтрокаСтатуса;
КонецФункции

//
// Работа с ВК управления АТС
//

Функция ПолучитьЗаписьРазговораБИТАТС(обКонтроллерАТС, стрСвойНомер, стрНомерАбонента) ЭКСПОРТ
	
	Если обКонтроллерАТС = Неопределено Тогда
		бит_ТелефонияКлиент.ВывестиСообщение("Не создан объект управления БИТ.АТС");
		Возврат "";
	КонецЕсли;
	
	стрЗаписьРазговораБИТАТС = "";
	
	Попытка
		
		СИПЛогинСофтфон = бит_БитфонСервер.ПолучитьПараметрыСоединения().Логин;
		
		ТекущаяАТС = бит_БитфонСервер.ПолучитьАТС();
		
		Если НЕ ЗначениеЗаполнено(ТекущаяАТС) Тогда
			бит_ТелефонияКлиент.ВывестиСообщение("Не задана БИТ.АТС для получения записей разговоров в настройках");
			Возврат "";
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(стрСвойНомер) Тогда
			бит_ТелефонияКлиент.ВывестиСообщение("Не задан свой номер телефона для получения записей разговоров");
			Возврат "";
		КонецЕсли;
		
		Хост = бит_АТССервер.ПолучитьПараметрыПодключенияАТС(ТекущаяАТС);
		
		ХэшЗаписи = обКонтроллерАТС.GetExtensionRecordHash(Хост.Адрес, Хост.Пользователь, Хост.Пароль, стрСвойНомер, СИПЛогинСофтфон);
		Если ЗначениеЗаполнено(ХэшЗаписи) Тогда
			стрЗаписьРазговораБИТАТС = бит_АТСКлиент.СформироватьСсылкуНаЗаписьРазговора(Хост.Адрес, ХэшЗаписи);
		КонецЕсли;
		
	Исключение
		
		бит_ТелефонияКлиент.ВывестиСообщение("Ошибка получения записи разговора с БИТ.АТС '" + Строка(ТекущаяАТС) + "'");
		бит_ТелефонияКлиент.ВывестиСообщение(ОписаниеОшибки());
	
	КонецПопытки;
	
	//
	
	Попытка
		Если обКонтроллерАТС.IsConnected Тогда
			обКонтроллерАТС.Disconnect();
		КонецЕсли;
	Исключение
		бит_ТелефонияКлиент.ВывестиСообщение("Ошибка отключения от БИТ.АТС '" + Строка(ТекущаяАТС) + "'");
		бит_ТелефонияКлиент.ВывестиСообщение(ОписаниеОшибки());
	КонецПопытки;
	
	Возврат стрЗаписьРазговораБИТАТС;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция УстановкаПриоритетаКодекаPCMA(стрСписокКодеков, приоритет)
	массКодеков = РазобратьСписокКодеков(стрСписокКодеков);
	Для Каждого кодекПриор Из массКодеков Цикл
		Если Найти(кодекПриор.Кодек, "PCMA") > 0 Тогда
			кодекПриор.Приоритет = приоритет;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	стрСписокКодеков = "";
	Для Каждого кодекПриор Из массКодеков Цикл
		стрКодек = кодекПриор.Кодек;
		стрПриор = Строка(кодекПриор.Приоритет);
		стрСписокКодеков = стрСписокКодеков + стрКодек + "=" + стрПриор + ";";
	КонецЦикла;
	Возврат стрСписокКодеков;
КонецФункции

Функция ПолучитьПрефиксВыходаНаВнешнююЛиниюПрофиля(профильНастроек)
	стрПрефикс = "";
	Если профильНастроек = ПредопределенноеЗначение("Перечисление.бит_ПрофилиНастроекБИТPhone.UISCOM") ИЛИ
		профильНастроек = ПредопределенноеЗначение("Перечисление.бит_ПрофилиНастроекБИТPhone.Скорозвон")
	Тогда
		стрПрефикс = "";
	Иначе
		стрПрефикс = бит_ТелефонияСервер.ПолучитьПрефиксВыходаНаВнешнююЛиниюПоУмолчанию();	
	КонецЕсли;
	Возврат стрПрефикс;
КонецФункции

#КонецОбласти
