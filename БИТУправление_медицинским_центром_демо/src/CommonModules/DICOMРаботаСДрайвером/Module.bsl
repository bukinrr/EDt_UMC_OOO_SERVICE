#Область СлужебныйПрограммныйИнтерфейс

Функция ПолучитьНастройки(СписокНастроек = "", Пользователь = Неопределено) Экспорт
	Если Пользователь = Неопределено Тогда
		Пользователь = DICOMРаботаСДрайвером.ТекущийПользователь();
	КонецЕсли;
	Возврат РегистрыСведений.НастройкиDICOM.ПолучитьНастройкиDICOM(СписокНастроек, Пользователь);
КонецФункции

Функция ПолучитьЗначениеКонстантыИспользоватьDICOM() Экспорт
	Если РольДоступна("ДоступКDICOM") Тогда
		Возврат Константы.ИспользоватьDICOM.Получить();
	Иначе
		Возврат Ложь;
	КонецЕсли;
КонецФункции

Функция ПрямаяТранслитерация(Слово) Экспорт
	
	МакетXML = ПолучитьОбщийМакет("Транслитерация").ПолучитьТекст();
	МакетТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(МакетXML).Данные;
	МакетТаблица.Колонки.Добавить("ПорядокЛатКирЧисло", Новый ОписаниеТипов("Число"));
	МакетТаблица.Колонки.Добавить("ПорядокКирЛатЧисло", Новый ОписаниеТипов("Число"));
	
	Для Каждого СтрокаМакета Из МакетТаблица Цикл
		Если НЕ ЗначениеЗаполнено(СтрокаМакета.ПорядокКирЛат) Тогда
			СтрокаМакета.ПорядокКирЛат = "999";
		Конецесли;
		Если НЕ ЗначениеЗаполнено(СтрокаМакета.ПорядокЛатКир) Тогда
			СтрокаМакета.ПорядокЛатКир = "999";
		Конецесли;
		СтрокаМакета.ПорядокЛатКирЧисло = Число(СтрокаМакета.ПорядокЛатКир);
		СтрокаМакета.ПорядокКирЛатЧисло = Число(СтрокаМакета.ПорядокКирЛат);
	КонецЦикла;
	МакетТаблица.Сортировать("ПорядокКирЛатЧисло,Кириллица");
	КолСимволов = 0;
	НовоеСлово = "";
	Пока КолСимволов < СтрДлина(Слово) Цикл
		Символ = Сред(Слово,КолСимволов+1,1);
		Найдено = Ложь;
		Для Каждого СтрокаМакета Из МакетТаблица Цикл
			Если НРег(Символ) = Нрег(СтрокаМакета.Кириллица) Тогда
				// новый символ с переводом в нужный регистр
				НовыйСимвол = ?(Символ = НРег(СтрокаМакета.Кириллица), НРег(СтрокаМакета.Латиница),ВРег(СтрокаМакета.Латиница));
				Если ЗначениеЗаполнено(СтрокаМакета.СледующиеБуквы) И КолСимволов + 1 < СтрДлина(Слово) Тогда
					// Для буквы ц, например,важно какие следующие буквы и надо заглянуть вперед
					// вперед смотрим если буква не последняя
					СимволСлед = Сред(Слово,КолСимволов+2,1);
					МассивСледБукв = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаМакета.СледующиеБуквы);
					Для каждого ЭлСледБуква Из МассивСледБукв Цикл
						Если НРег(ЭлСледБуква) = НРег(СимволСлед) Тогда
							НовоеСлово = НовоеСлово + НовыйСимвол;
							Найдено = Истина;
							Прервать;
						КонецЕсли;
					КонецЦикла; 
				Иначе
					НовоеСлово = НовоеСлово + НовыйСимвол;
					Найдено = Истина;
				КонецЕсли;
			КонецЕсли;
			Если Найдено = Истина Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если Найдено = Ложь Тогда
			НовоеСлово = НовоеСлово + Символ;
		КонецЕсли;
		КолСимволов = КолСимволов + 1;
	КонецЦикла; 
	
	Возврат НовоеСлово;
	
КонецФункции

Функция ОбратнаяТранслитерация(Слово) Экспорт
	МакетXML = ПолучитьОбщийМакет("Транслитерация").ПолучитьТекст();
	МакетТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(МакетXML).Данные;
	МакетТаблица.Колонки.Добавить("ПорядокЛатКирЧисло", Новый ОписаниеТипов("Число"));
	МакетТаблица.Колонки.Добавить("ПорядокКирЛатЧисло", Новый ОписаниеТипов("Число"));
	
	Для Каждого СтрокаМакета Из МакетТаблица Цикл
		Если НЕ ЗначениеЗаполнено(СтрокаМакета.ПорядокКирЛат) Тогда
			СтрокаМакета.ПорядокКирЛат = "999";
		Конецесли;
		Если НЕ ЗначениеЗаполнено(СтрокаМакета.ПорядокЛатКир) Тогда
			СтрокаМакета.ПорядокЛатКир = "999";
		Конецесли;
		СтрокаМакета.ПорядокЛатКирЧисло = Число(СтрокаМакета.ПорядокЛатКир);
		СтрокаМакета.ПорядокКирЛатЧисло = Число(СтрокаМакета.ПорядокКирЛат);
	КонецЦикла;
	МакетТаблица.Сортировать("ПорядокЛатКирЧисло,Кириллица");
	КолСимволов = 0;
	НовоеСлово = Слово;
	Для Каждого СтрокаМакета Из МакетТаблица Цикл
		НовоеСлово = СтрЗаменить(НовоеСлово,НРег(СтрокаМакета.Латиница),НРег(СтрокаМакета.Кириллица));
		НовоеСлово = СтрЗаменить(НовоеСлово,ВРег(СтрокаМакета.Латиница),ВРег(СтрокаМакета.Кириллица));
	КонецЦикла;
	
	Возврат НовоеСлово;
	
КонецФункции


Функция ТекущийПользователь() Экспорт
	Пользователь = Неопределено;
	Попытка
		Пользователь = Пользователи.ТекущийПользователь();
	Исключение
		Пользователь = Справочники.Пользователи.ПустаяСсылка();
	КонецПопытки;
	Возврат Пользователь;
КонецФункции

Функция ПолучитьPACS() Экспорт
	Настройки  =  DICOMРаботаСДрайвером.ПолучитьНастройки("ЗапросыDICOM_ВызываемыйAETitle");
	
	Если Не ЗначениеЗаполнено(Настройки.ЗапросыDICOM_ВызываемыйAETitle) Тогда
		Попытка
			ЗапросыDICOM_ВызываемыйAETitle = Константы.ЗапросыDICOM_ВызываемыйAETitle.Получить();
		Исключение
			ЗапросыDICOM_ВызываемыйAETitle = Неопределено; 
		КонецПопытки;
		
		Возврат ЗапросыDICOM_ВызываемыйAETitle;
	КонецЕсли;
	
	Возврат Настройки.ЗапросыDICOM_ВызываемыйAETitle;
КонецФункции

Функция ПолучитьAETitleДляЗапросовDICOM() Экспорт
	Настройки  =  DICOMРаботаСДрайвером.ПолучитьНастройки("STORESCP_ИспользуемыйAETitle");
	Возврат Настройки.STORESCP_ИспользуемыйAETitle;
КонецФункции

Функция ПолучитьХранилищеDICOM() Экспорт
	Настройки  =  DICOMРаботаСДрайвером.ПолучитьНастройки("STORESCP_ИспользуемыйAETitle,STORESCP_ИспользоватьКлиент");
	
	Если Настройки.STORESCP_ИспользоватьКлиент = Истина Тогда
		Возврат Настройки.STORESCP_ИспользуемыйAETitle;
	Иначе
		Попытка
			Возврат Константы.STORESCP_ИспользуемыйAETitle.Получить();
		Исключение
			Возврат Неопределено;
		КонецПопытки;
	КонецЕсли;
	
КонецФункции

Функция ПолучитьПутьКНастройкамЛогов() Экспорт
	LogCatalog = Константы.DICOM_LogCatalog.Получить();
	Если НЕ ЗначениеЗаполнено(LogCatalog) Тогда
		Возврат "C:\\dicom\\";
	Иначе
		Возврат LogCatalog;
	КонецЕсли;
КонецФункции
//////////////////////////////////////////////////////////////////
// Workllist

Процедура ЗаписатьЭлементWorkList(Ресурсы, Отказ) Экспорт
	Интерфейс = DICOMРаботаСДрайверомКлиентСервер.ПолучитьИнтерфейсDICOM();
//	# Dicom-Data-Set
// # Used TransferSyntax: Little Endian Explicit
// (0008,0005) CS [ISO_IR 100] # 10, 1 SpecificCharacterSet
Шаблон = 
	"(0008,0050) [@AccessionNumber@]
	|(0010,0010) [@PatientName@]
	|(0010,0020) [@PatientId@]
	|(0010,0030) [@BirthDay@]
	|(0010,0040) [@Sex@]
	|(0010,2000) [@MedicalAlerts@]
	|(0010,2110) [@Allergies@]
	|(0020,000d) [@StudyInstanceUID@]
	|(0032,1032) [@RequestingPhysician@]
	|(0032,1060) [@RequestedProcedureDescription@]
	|(0040,0100) [@ScheduledProcedureStepSequence@]
	|(fffe,e000) -
	|(0008,0060) [@Modality@]
	|(0032,1070) [@RequestedContrastAgent@]
	|(0040,0001) [@ScheduledStationAETitle@]
	|(0040,0002) [@ScheduledProcedureStepStartDate@]
	|(0040,0003) [@ScheduledProcedureStepStartTime@]
	|(0040,0006) [@ScheduledPerformingPhysiciansName@]
	|(0040,0007) [@ScheduledProcedureStepDescription@]
	|(0040,0009) [@ScheduledProcedureStepID@]
	|(0040,0010) [@ScheduledStationName@]
	|(0040,0011) [@ScheduledProcedureStepLocation@]
	|(0040,0012) [@PreMedication@]
	|(0040,0400) [@CommentsOnScheduledProcedureStep@]
	|(fffe,e00d) -
	|(fffe,e0dd) -
	|(0040,1001) [@RequestedProcedureID@]
	|(0040,1003) [@RequestedProcedurePriority@]
	|";
	
	Если Интерфейс <> Неопределено Тогда
		
		Для Каждого Ресурс Из Ресурсы Цикл
			Шаблон = СтрЗаменить(Шаблон, "@" + (Ресурс.Ключ) + "@", Ресурс.Значение);
		КонецЦикла;
		
		КаталогDCM = ПолучитьКаталогФайловWorkList();
		
		Если КаталогDCM <> Неопределено Тогда
			ПутьКФайлуDCM = СформироватьПутьПоКаталогуИИмениФайла(
			КаталогDCM,
			Ресурсы.ИмяФайла
			);
			ПутьКФайлуШаблона = СтрЗаменить(ПутьКФайлуDCM, ".wl", ".input");
			ФайлШаблона = Новый ЗаписьТекста(ПутьКФайлуШаблона,,,Истина, Символы.ПС);
			ФайлШаблона.Записать(Шаблон);
			ФайлШаблона.Закрыть();
			УдалитьBOM(ПутьКФайлуШаблона);
			ФайлDICOM = Новый ЗаписьТекста(ПутьКФайлуDCM,,,Истина, Символы.ПС);
			ФайлDICOM.Записать("");
			ФайлDICOM.Закрыть();
			УдалитьBOM(ПутьКФайлуDCM);
		Иначе
			Отказ = Истина;
			Возврат;
		КонецЕсли;
				
		Результат = Интерфейс.Dump2dcm("-input", ПутьКФайлуШаблона, "-output", ПутьКФайлуDCM);
		Попытка
			УдалитьФайлы(ПутьКФайлуШаблона);  
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
		КонецПопытки;

	КонецЕсли;
КонецПроцедуры

Процедура УдалитьBOM(ПутьКФайлу) Экспорт
   // удаляем из него BOM
   тДанные = Новый ДвоичныеДанные(ПутьКФайлу);
 
   тСтрока = Base64Строка(тДанные);
   тСтрока=Прав(тСтрока, СтрДлина(тСтрока)-4);
   Base64Значение(тСтрока).Записать(ПутьКФайлу);
КонецПроцедуры

Функция СформироватьПутьПоКаталогуИИмениФайла(Каталог, Файл) Экспорт
	Симв = Прав(Каталог,1);
	Если Симв = "/" Или Симв = "\" Тогда
		ЕстьСлэш = Истина;
	Иначе
		ЕстьСлэш = Ложь;
	КонецЕсли;
	СистемнаяИнформация = Новый СистемнаяИнформация;
	Если СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Linux_x86_64
		Или СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Linux_x86
	Тогда
		Возврат Каталог + ?(ЕстьСлэш,"","/") + Файл;
	Иначе
		Возврат Каталог + ?(ЕстьСлэш,"","\") + Файл;
	КонецЕсли;
КонецФункции

Функция ПолучитьКаталогФайловWorkList() Экспорт
	БазовыйКаталог = Константы.MWLSCP_КаталогФайлов.Получить();
	Если Не ЗначениеЗаполнено(БазовыйКаталог) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не задана настройка DICOM, каталог файлов WorkList.");
		Возврат Неопределено;
	КонецЕсли;

	//AETitle = Константы.MWLSCP_ИспользуемыйAETitle.Получить();
	//Если Не ЗначениеЗаполнено(AETitle) Тогда
	//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не задана настройка DICOM, AE Title сервера WorkList.");
	//	Возврат Неопределено;
	//КонецЕсли;
	//
	//Возврат СформироватьПутьПоКаталогуИИмениФайла(
	//						БазовыйКаталог,
	//						AETitle
	//					);
	Возврат БазовыйКаталог;
КонецФункции

Процедура ПоставитьОтметкуИсполнения(Источник) Экспорт

	НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);

	ЗаблокироватьРегистр(
				Источник,
				"РегистрСведений.DicomWorkLists",
				"УникальныйИдентификаторИсследования"
			);
	
	Для Каждого строкаТЗ Из Источник Цикл
		НаборЗаписей = РегистрыСведений.DicomWorkLists.СоздатьНаборЗаписей();
		
		НаборЗаписей.Отбор.УникальныйИдентификаторИсследования.Установить(
											строкаТЗ.УникальныйИдентификаторИсследования
										);
		
		НаборЗаписей.Прочитать();
		НаборЗаписей[0].СозданФайл = Ложь;
		НаборЗаписей[0].Выполнена = Истина;
		НаборЗаписей[0].ДатаВыполнения = ТекущаяДатаСеанса();
		НаборЗаписей[0].СтатусИсследования = Перечисления.СтатусыИсследованийDICOM.COMPLETED;
		НаборЗаписей.Записать();
	
	КонецЦикла;

	
	
	ЗафиксироватьТранзакцию();

КонецПроцедуры

Процедура СнятьОтметкуИсполнения(Источник) Экспорт

	НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);

	ЗаблокироватьРегистр(
				Источник,
				"РегистрСведений.DicomWorkLists",
				"УникальныйИдентификаторИсследования"
			);
	
	Для Каждого строкаТЗ Из Источник Цикл
		НаборЗаписей = РегистрыСведений.DicomWorkLists.СоздатьНаборЗаписей();
		
		НаборЗаписей.Отбор.УникальныйИдентификаторИсследования.Установить(
											строкаТЗ.УникальныйИдентификаторИсследования
										);
		
		НаборЗаписей.Прочитать();
		НаборЗаписей[0].СозданФайл = Истина;
		НаборЗаписей[0].Выполнена = Ложь;
		НаборЗаписей[0].ДатаВыполнения = Неопределено;
		НаборЗаписей[0].СтатусИсследования = Неопределено;
		НаборЗаписей.Записать();
	
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();

КонецПроцедуры

Процедура ЗаблокироватьРегистр(ТаблицаЗначенийИзмерений, ИмяРегистра, ИменаИзмерений, ИменаПолейТаблицы = Неопределено) Экспорт

	Если Не ЗначениеЗаполнено(ИменаПолейТаблицы) Тогда
		ИменаПолейТаблицы = ИменаИзмерений;
	КонецЕсли;
	
	МассивИзмерений = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИменаИзмерений);
	МассивПолей = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИменаПолейТаблицы);

	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить(ИмяРегистра);
	ЭлементБлокировки.ИсточникДанных=ТаблицаЗначенийИзмерений;

	Номер = 0;
	Для Каждого ИмяИзмерения Из МассивИзмерений Цикл
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных(ИмяИзмерения,МассивПолей[Номер]);
		Номер = Номер + 1;
	КонецЦикла;

	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	
	Блокировка.Заблокировать();

КонецПроцедуры



//////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////
// MWLSCP

Процедура ЗапускMWLCSP() Экспорт
	
	ЗапуститьСлужбуMWLSCP();
	
КонецПроцедуры

Процедура ОстановкаMWLCSP() Экспорт
	
	ВнешняяКомпонента = DICOMРаботаСДрайверомКлиентСервер.ПолучитьИнтерфейсDICOM();
	Попытка
		
		Рез = ВнешняяКомпонента.StopServiceIn1C("-aec", "1C", "-aet", Строка(Константы.MWLSCP_ИспользуемыйAETitle.Получить().Наименование)
			,"-host", Формат(Константы.MWLSCP_ИспользуемыйAETitle.Получить().Host, "ЧГ=0")
			, "-port", Формат(Константы.MWLSCP_ИспользуемыйAETitle.Получить().Port, "ЧГ=0"));
		
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибка отстановки компоненты DICOM");
	КонецПопытки;
	
КонецПроцедуры

Функция ПолучитьСтатусMWLCSP() Экспорт
	
	ВнешняяКомпонента = DICOMРаботаСДрайверомКлиентСервер.ПолучитьИнтерфейсDICOM();
	Попытка
		СтрокаЗапуска = "tasklist /fi ""IMAGENAME eq MWLSCP.exe""";
		
		ObjShell = Новый COMОбъект("WScript.Shell") ;
		ObjScriptExec = ObjShell.Exec(СтрокаЗапуска);
		StrPingResults = НРег(ObjScriptExec.StdOut.ReadAll());
		
		Если Найти(StrPingResults, "mwl") > 0 Тогда
			Рез = Истина;
		Иначе
			Рез = Ложь;
		КонецЕсли;
		
		//Рез = ВнешняяКомпонента.CheckMwlScp();
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось определить статус MWL CSP");
		Рез = Неопределено;
	КонецПопытки;
	
	Возврат Рез;
	
КонецФункции

Функция ПолучитьЗначениеКонстантыMWLSCP_АвтоматическийЗапуск() Экспорт
	Возврат Константы.MWLSCP_АвтоматическийЗапуск.Получить();
КонецФункции

//////////////////////////////////////////////////////////////////
// Переустановка компоненты

Процедура ЗаписатьВРегистрИспользуемуюВерсиюКомпоненты() Экспорт

	СисИнфо = Новый СистемнаяИнформация;
	УИДКлиента = СисИнфо.ИдентификаторКлиента;
	ВерсияКомпоненты = DICOMРаботаСДрайверомКлиентСервер.ВерсияКомпонентыDICOM();
	
	НаборЗаписей = РегистрыСведений.ВерсииКомпонентыDICOM.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.УникальныйИдентификаторКлиента.Установить(УИДКлиента);
	Запись = НаборЗаписей.Добавить();
	Запись.УникальныйИдентификаторКлиента = УИДКлиента;
	Запись.Версия = ВерсияКомпоненты;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

Функция ПолучитьВерсиюУстановленнойКомпоненты() Экспорт
	
	СисИнфо = Новый СистемнаяИнформация;
	УИДКлиента = СисИнфо.ИдентификаторКлиента;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВерсииКомпонентыDICOM.Версия
	|ИЗ
	|	РегистрСведений.ВерсииКомпонентыDICOM КАК ВерсииКомпонентыDICOM
	|ГДЕ
	|	ВерсииКомпонентыDICOM.УникальныйИдентификаторКлиента = &УникальныйИдентификаторКлиента";
	
	Запрос.УстановитьПараметр("УникальныйИдентификаторКлиента",УИДКлиента);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Версия;
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

///////////////////////////////////////////////////////////////////////////
Функция ЗапуститьСлужбуMWLSCP() Экспорт
	// Проверяем статус службы, если нет, то запускаем
	Если ПолучитьСтатусMWLCSP() = Истина Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Служба MWLSCP уже запущена.");
		Возврат Ложь;
	КонецЕсли;

	
	Shell=Новый COMОбъект("WScript.Shell");		
	СтрокаЗапуска = "";
	КаталогЗапускаСлужб = Константы.DICOM_КаталогЗапускаСлужб.Получить();
	КаталогНаДиске = Новый Файл(КаталогЗапускаСлужб);
	Если КаталогНаДиске.Существует() Тогда
		ПутьКФайлуСлужбы = СформироватьПутьКФайлуВКаталоге(КаталогЗапускаСлужб, "MWLSCP.exe");
		Файл_MWLSCP = Новый Файл(ПутьКФайлуСлужбы);
		Если Файл_MWLSCP.Существует() Тогда
			// Все ок файлик на месте		
		Иначе
			СлужбаДД = ПолучитьОбщийМакет("MWLSCP");
			СлужбаДД.Записать(ПутьКФайлуСлужбы);
		КонецЕсли;
		СтрокаЗапуска = ПутьКФайлуСлужбы 
							+ " -s "
			 				+ " -dfp "
							+ Константы.MWLSCP_КаталогФайлов.Получить()
							+ " " 
							+ Формат(Константы.MWLSCP_ИспользуемыйAETitle.Получить().Port, "ЧГ=0");

	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Неправильно задан каталог запуска служб DICOM.");
		Возврат Ложь;
	КонецЕсли;
	
	Попытка
		Shell.Run(СтрокаЗапуска, 0, 0);	
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибка запуска службы MWLSCP");
		Возврат Ложь;
	КонецПопытки;
КонецФункции

Функция ЗапуститьСлужбуStoreSCP() Экспорт
		// Проверяем статус службы, если нет, то запускаем
		Если DICOMРаботаСДрайверомКлиентСервер.ПолучитьСтатусStorageSCP() = Истина Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Служба StoreSCP уже запущена.");
			Возврат Ложь;
		КонецЕсли;
		
		#Если НаСервере Тогда
			НастройкиDICOM = Новый Структура("STORESCP_ИспользуемыйAETitle,STORESCP_КаталогФайлов,STORESCP_ОчищатьКаталогЧерез");
			Попытка
				НастройкиDICOM.ХранилищеDICOM_ИспользуемыйAETitle = Константы.STORESCP_ИспользуемыйAETitle.Получить();
			Исключение
			КонецПопытки;
			
			Попытка
				НастройкиDICOM.ХранилищеDICOM_КаталогФайлов = Константы.STORESCP_КаталогФайлов.Получить();
			Исключение
			КонецПопытки;
			
			Попытка
				НастройкиDICOM.ХранилищеDICOM_ОчищатьКаталогЧерез = Константы.STORESCP_ОчищатьКаталогЧерез.Получить();
			Исключение
			КонецПопытки;
		#Иначе
			НастройкиDICOM = DICOMРаботаСДрайвером.ПолучитьНастройки();
		#КонецЕсли

		AE = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(
					НастройкиDICOM.ХранилищеDICOM_ИспользуемыйAETitle, "Port, Наименование"
				);
				Port = AE.Port;
				AETitle = AE.Наименование;
		ХранилищеDICOM_Префикс = "study";
			
		Shell=Новый COMОбъект("WScript.Shell");		
		СтрокаЗапуска = "";
		КаталогЗапускаСлужб = Константы.DICOM_КаталогЗапускаСлужб.Получить();
		КаталогНаДиске = Новый Файл(КаталогЗапускаСлужб);
		Если КаталогНаДиске.Существует() Тогда
			ПутьКФайлуСлужбы = СформироватьПутьКФайлуВКаталоге(КаталогЗапускаСлужб, "StoreSCP.exe");
			Файл_MWLSCP = Новый Файл(ПутьКФайлуСлужбы);
			Если Файл_MWLSCP.Существует() Тогда
				// Все ок файлик на месте		
			Иначе
				СлужбаДД = Новый ДвоичныеДанные(ПолучитьОбщийМакет("StoreSCP"));
				СлужбаДД.Записать(ПутьКФайлуСлужбы);
			КонецЕсли;
			СтрокаЗапуска = ПутьКФайлуСлужбы 
								+ " -su "
								+ ХранилищеDICOM_Префикс
								+ " -aet "
								+ AETitle
								+ " -od "
								+ НастройкиDICOM.ХранилищеDICOM_КаталогФайлов
								+ Формат(Port, "ЧГ=0");

		Иначе
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Неправильно задан каталог запуска служб DICOM.");
			Возврат Ложь;
		КонецЕсли;
		
		Попытка
			Shell.Run(СтрокаЗапуска, 0, 0);	
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибка запуска службы StoreSCP");
			Возврат Ложь;
		КонецПопытки;
	КонецФункции

Процедура ЗапроситьПередачуДанных(СтрокаПараметров) Экспорт
	Shell=Новый COMОбъект("WScript.Shell");		
	СтрокаЗапуска = "";
	КаталогЗапускаСлужб = Константы.DICOM_КаталогЗапускаСлужб.Получить();
	КаталогНаДиске = Новый Файл(КаталогЗапускаСлужб);
	Если КаталогНаДиске.Существует() Тогда
		ПутьКФайлуСлужбы = СформироватьПутьКФайлуВКаталоге(КаталогЗапускаСлужб, "mvscu.exe");
		Файл_mvscu = Новый Файл(ПутьКФайлуСлужбы);
		Если Файл_mvscu.Существует() Тогда
			// Все ок файлик на месте		
		Иначе
			СлужбаДД = ПолучитьОбщийМакет("mvscu");
			СлужбаДД.Записать(ПутьКФайлуСлужбы);
		КонецЕсли;
		СтрокаЗапуска = ПутьКФайлуСлужбы + " " + СтрокаПараметров;

	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Неправильно задан каталог запуска служб DICOM.");
	КонецЕсли;
	
	Попытка
		Shell.Run(СтрокаЗапуска, 0, 0);	
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибка запуска службы mvscu");
	КонецПопытки;
КонецПроцедуры

Функция ПолучитьКаталогЗапускаСлужб() Экспорт
	Возврат Константы.DICOM_КаталогЗапускаСлужб.Получить()	;
КонецФункции

Функция СформироватьПутьКФайлуВКаталоге(Каталог, ИмяФайла)Экспорт
	Разделитель = ПолучитьРазделительПути();
	ПоследнийСимвол = Сред(Каталог, СтрДлина(Каталог), 1);
	Если ПоследнийСимвол <> Разделитель Тогда
		Возврат Каталог + Разделитель + ИмяФайла;
	Иначе
		Возврат Каталог + ИмяФайла;
	КонецЕсли;
КонецФункции

Функция ПолучитьДДОбщегоМакета(ИмяМакета, АдресХранилища)Экспорт
	ДД = ПолучитьОбщийМакет(ИмяМакета);
	Адрес = ПоместитьВоВременноеХранилище(ДД, АдресХранилища);
	Возврат Адрес;
КонецФункции

#КонецОбласти