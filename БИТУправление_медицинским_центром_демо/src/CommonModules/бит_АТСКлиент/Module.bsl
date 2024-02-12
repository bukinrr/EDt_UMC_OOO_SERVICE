///////////////////////////////////////////////////////////////////////////////
// Общий клиентский модуль работы с БИТ.АТС
///////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает форму монитора стационарного телефона.
Процедура ОткрытьМонитор() ЭКСПОРТ
	бит_ТелефонияКлиент.ОткрытьФормуВыполнитьДействие(ПолучитьИмяФормыМонитора(), "", "");
КонецПроцедуры

// Открывает форму монитора стационарного телефона и начинает исходящий вызов на заданный номер.
//
// Параметры:
//  Контакт - Строка - номер телефона, также принимается ссылка на контрагента или контактное лицо.
//
Процедура ОткрытьМониторНачатьРазговор(Контакт) ЭКСПОРТ
	бит_ТелефонияКлиентПереопределяемый.ВыбратьНомерКонтактаИОповестить(Контакт, ПолучитьИмяФормыМонитора(), "БитфонМонитор_НачатьЗвонок");
КонецПроцедуры

// Возвращает имя формы Монитора БИТ.АТС
// Возвращаемое значение:
//   Строка - полное имя формы Монитора.
Функция ПолучитьИмяФормыМонитора() ЭКСПОРТ
	Возврат "Обработка.бит_БитАТС.Форма.Монитор";
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПодключениеКомпонентыУправлениеАТС(ИмяОповещения, ПараметрОповещения=Неопределено) ЭКСПОРТ
	
#Если ВебКлиент Тогда
	бит_ТелефонияКлиент.ВывестиСообщение("Работа внешней компоненты управления БИТ.АТС в режиме веб-клиента не поддерживается");
	Возврат;
#КонецЕсли

	Попытка
		
		стрИмяФайлаВК = ? ( бит_ТелефонияКлиент.Клиент64бит(), "BITPBXControlNative64.dll", "BITPBXControlNative.dll");
		
		бит_ТелефонияКлиентПереопределяемый.ПодключениеВнешнейКомпоненты(
								"ОбщийМакет.бит_КомпонентаУправлениеАТС",
								стрИмяФайлаВК,
								"бит_АТССервер",
								"PBXControl",
								"БИТ.АТС",
								ИмяОповещения,
								ПараметрОповещения);
	Исключение
		
		бит_ТелефонияКлиент.ВывестиСообщение(ОписаниеОшибки());
		
	КонецПопытки;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
Процедура УстановитьПараметрыПроверкиЛицензии(обКонтроллерАТС, флагМонитор) ЭКСПОРТ
	
	Если (обКонтроллерАТС <> Неопределено) Тогда
		
		стрСерверЛицензийАдрес		= бит_АТССервер.ПолучитьАдресСервераЛицензий();
		серверЛицензийПорт			= бит_АТССервер.ПолучитьПортСервераЛицензий();
		серверЛицензийНеИспПрокси	= бит_АТССервер.ПолучитьФлагСервераЛицензийНеИспользоватьПрокси();
		
		обКонтроллерАТС.SetLicenseParameters(стрСерверЛицензийАдрес, серверЛицензийПорт, серверЛицензийНеИспПрокси, флагМонитор);
		
	КонецЕсли;
	
КонецПроцедуры

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
	флагПрямойНабор		= бит_АТССервер.ПолучитьФлагИспользоватьПрямойНабор();
	стрПрефиксВнешЛинии	= бит_АТССервер.ПолучитьПрефиксВыходаНаВнешнююЛинию();
	Возврат бит_ТелефонияКлиент.СформироватьНомерСПрефиксами(стрНомерИсх, флагПрямойНабор, стрПрефиксВнешЛинии);
КонецФункции

// Открывает форму настроек для текущего пользователя.
//
// Параметры:
//  СкрыватьПараметрыПанели  - Булево, флаг скрывания параметров, не используемых в Панели БИТ.АТС.
//
Процедура ОткрытьФормуНастроек(СкрыватьПараметрыПанели) ЭКСПОРТ
	ПараметрыФормыНастроек = бит_АТССервер.ПолучитьПараметрыОткрытияФормыНастроек();
	фрмНастройки = ПолучитьФорму("РегистрСведений.бит_БитАТСНастройки.Форма.ФормаЗаписи", ПараметрыФормыНастроек);
	фрмНастройки.Элементы.Пользователь.ТолькоПросмотр = Истина;
	фрмНастройки.Элементы.ВерсияКомпонентыПанелиУправления.ТолькоПросмотр = Истина;
	фрмНастройки.Элементы.РежимВнеОфиса.ТолькоПросмотр = Истина;
	фрмНастройки.Элементы.РазрешенныйАдрес.Видимость = Ложь;
	фрмНастройки.СкрыватьПараметрыПанели = СкрыватьПараметрыПанели;
	бит_ТелефонияКлиентПереопределяемый.ОткрытьФормуСБлокировкойВладельца(фрмНастройки, "БитфонМониторПанель_ОбновлениеНастроек");
КонецПроцедуры

// Функция получения наименования для номера.
//
// Параметры:
//  СоответствиеНомеровИменам  - Соответствие, ключ - номер телефона, значение - имя абонента.
//  стрНомер  - Строка - номер телефона для поиска в соответствии.
//  НайденВозвращ - Булево, возвращаемое значение, Истина если имя номера найдено в соответствии.
//
// Возвращаемое значение:
//   Строка - наименование абонента.
//
Функция ПолучитьИмяПоВнутреннемуНомеру(СоответствиеНомеровИменам, стрНомер, НайденВозвращ=Неопределено) ЭКСПОРТ
	Наименование = стрНомер;
	НайденВозвращ = Ложь;
	Если СоответствиеНомеровИменам <> Неопределено Тогда
		ИмяНомера = СоответствиеНомеровИменам.Получить(стрНомер);
		Если ИмяНомера <> Неопределено Тогда
			Наименование = ИмяНомера + " (" + стрНомер + ")";
			НайденВозвращ = Истина;
		КонецЕсли;
	КонецЕсли;
	Возврат Наименование;
КонецФункции

//-----------------------------------------------------------------------------
Функция СократитьНомер(НомерСПрефиксами, флагПрямойНабор, ВнешнийВызовВозвращ) ЭКСПОРТ
	СокращНомер = НомерСПрефиксами;
	индСИП = Найти(НомерСПрефиксами, "SIP/");
	Если индСИП = 0 Тогда
		//
		// ВРЕМЕННО! Очистка префикса транка для SoftSwitch
		СокращНомер = бит_ТелефонияКлиентСервер.ОчиститьНомерЦифрыЗвРеш(НомерСПрефиксами);
		ДлинаСоединен = СтрДлина(СокращНомер);
		индРешТранк = Найти(СокращНомер, "#0");
		Если (индРешТранк = 1) И (ДлинаСоединен = 14) Тогда
			СокращНомер = Сред(СокращНомер, 4);
			СокращНомер = "9" + СокращНомер;
		КонецЕсли;
		//
		Если НЕ флагПрямойНабор Тогда
			СокращНомер = бит_ТелефонияКлиентСервер.СократитьНомерДляПоиска(СокращНомер);
		КонецЕсли;
		//
		ДлинаСоединен = СтрДлина(СокращНомер);
		ДлинаВнешнегоНомера = бит_ТелефонияКлиентСервер.ПолучитьДлинуВнешнегоНомера();
		ВнешнийВызовВозвращ = (ДлинаСоединен >= ДлинаВнешнегоНомера);
	Иначе
		// соединение с неизвестным внутренним абонентом
		ВнешнийВызовВозвращ = Ложь;
	КонецЕсли;
	Возврат СокращНомер;
КонецФункции

//-----------------------------------------------------------------------------
Функция СократитьНомерНайтиКонтрагента(кэшКонтактов, СоответствиеВнутреннихНомеров, НомерСПрефиксами, КонтрагентСсылка, КонтактноеЛицоСсылка) ЭКСПОРТ
	ВнешнийВызов = Ложь;
	СокращНомер = СократитьНомер(НомерСПрефиксами, Ложь, ВнешнийВызов);
	НомерСПрефиксами = СокращНомер;
	Возврат НайтиКонтрагентаПоСокращНомеру(кэшКонтактов, СоответствиеВнутреннихНомеров, СокращНомер, ВнешнийВызов, КонтрагентСсылка, КонтактноеЛицоСсылка);
КонецФункции

//-----------------------------------------------------------------------------
// При получении контрагента в кэше устанавливается флаг "Обновлен".
Функция НайтиКонтрагентаПоСокращНомеру(кэшКонтактов, СоответствиеВнутреннихНомеров, СокращНомер, ВнешнийВызов, КонтрагентСсылка, КонтактноеЛицоСсылка, ЕстьДубли=Ложь) ЭКСПОРТ
	найден = Ложь;
	ЕстьДубли = Ложь;
	СтруктураКонтакт = кэшКонтактов.Получить(СокращНомер);
	Если СтруктураКонтакт = Неопределено Тогда
		// найти и добавить в кэш
		найден = бит_АТССервер.НайтиКонтрагентаПоНомеру(СокращНомер, ВнешнийВызов, КонтрагентСсылка, КонтактноеЛицоСсылка, ЕстьДубли);
		Если найден <> Истина Тогда
			Если ВнешнийВызов Тогда
				КонтрагентСсылка = СокращНомер;
			Иначе
				КонтрагентСсылка = ПолучитьИмяПоВнутреннемуНомеру(СоответствиеВнутреннихНомеров, СокращНомер, найден);
			КонецЕсли;
		КонецЕсли;
		НайденныйКонтакт = Новый Структура;
		НайденныйКонтакт.Вставить("КонтрагентСсылка", КонтрагентСсылка);
		НайденныйКонтакт.Вставить("КонтактноеЛицоСсылка", КонтактноеЛицоСсылка);
		НайденныйКонтакт.Вставить("Найден", найден);
		НайденныйКонтакт.Вставить("Обновлен", Истина);
		кэшКонтактов.Вставить(СокращНомер, НайденныйКонтакт);
	Иначе
		КонтрагентСсылка		= СтруктураКонтакт.КонтрагентСсылка;
		КонтактноеЛицоСсылка	= СтруктураКонтакт.КонтактноеЛицоСсылка;
		найден					= СтруктураКонтакт.Найден;
		СтруктураКонтакт.Обновлен	= Истина;
	КонецЕсли;
	Возврат найден;
КонецФункции

//-----------------------------------------------------------------------------
Процедура ОчиститьФлагОбновленВсегоКэшаКонтактов(кэшКонтактов) ЭКСПОРТ
	Если кэшКонтактов <> Неопределено Тогда
		Для Каждого СтруктураКонтакт Из кэшКонтактов Цикл
			СтруктураКонтакт.Значение.Обновлен = Ложь;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

//-----------------------------------------------------------------------------
Процедура УдалитьНеобновленныеКонтактыИзКэша(кэшКонтактов) ЭКСПОРТ
	Если кэшКонтактов <> Неопределено Тогда
		Для Каждого СтруктураКонтакт Из кэшКонтактов Цикл
			Если СтруктураКонтакт.Значение.Обновлен = Ложь Тогда
				кэшКонтактов.Удалить(СтруктураКонтакт.Ключ);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

//-----------------------------------------------------------------------------
// Возвращает таймаут звонка в миллисекундах.
Функция ПолучитьТаймаутЗвонка() ЭКСПОРТ
	таймаут = бит_АТССервер.ПолучитьТаймаутЗвонка();
	Если таймаут = 0 Тогда
		бит_ТелефонияКлиент.ВывестиСообщение("Не задан таймаут звонка в настройках, принимается 15 сек");
		таймаут = 15;
	КонецЕсли;
	таймаут = таймаут * 1000;	// перевод в миллисекунды
	Возврат таймаут;
КонецФункции

//-----------------------------------------------------------------------------
Процедура ОткрытьМониторВоспроизвестиЗаписьРазговора(стрПутьЗаписьРазговора) ЭКСПОРТ
	бит_ТелефонияКлиент.ОткрытьФормуВыполнитьДействие(ПолучитьИмяФормыМонитора(), "БитфонМонитор_ВоспроизвестиЗаписьРазговора", стрПутьЗаписьРазговора);
КонецПроцедуры

//-----------------------------------------------------------------------------
Процедура ОткрытьАналитикуБИТАТС(АТССсылка) ЭКСПОРТ
	бит_ТелефонияКлиент.ОткрытьФайлИлиСсылку(бит_АТССервер.ПолучитьАдресАналитикиАТС(АТССсылка));
КонецПроцедуры

//-----------------------------------------------------------------------------
// Коды картинок статусов:
// 0 - не найден,
// 1 - свободен,
// 2 - разговаривает,
// 3 - режим не беспокоить (DND),
// 4 - не зарегистрирован (на АТС),
// 5 - входящий звонок,
// 6 - удержание.
Функция ПолучитьИндексКартинкиСтатуса(СтатусНомера) ЭКСПОРТ
	ИндексКартинкиСтатуса = 0;
	Если СтатусНомера = 0 Тогда
		ИндексКартинкиСтатуса = 1;
	ИначеЕсли СтатусНомера = 1 ИЛИ СтатусНомера = 9 ИЛИ СтатусНомера = 17 Тогда
		ИндексКартинкиСтатуса = 2;
	ИначеЕсли СтатусНомера = 2 Тогда
		ИндексКартинкиСтатуса = 3;
	ИначеЕсли СтатусНомера = 4 Тогда
		ИндексКартинкиСтатуса = 4;
	ИначеЕсли СтатусНомера = 8 Тогда
		ИндексКартинкиСтатуса = 5;
	ИначеЕсли СтатусНомера = 16 Тогда
		ИндексКартинкиСтатуса = 6;
	КонецЕсли;
	Возврат ИндексКартинкиСтатуса;
КонецФункции

Функция ПолучитьОписаниеСтатуса(СтатусНомера) ЭКСПОРТ
	СтрокаСтатуса = "";
	Если СтатусНомера = -1 ИЛИ СтатусНомера = -2 Тогда
		СтрокаСтатуса = "не найден";
	ИначеЕсли СтатусНомера = 0 Тогда
		СтрокаСтатуса = "свободен";
	ИначеЕсли СтатусНомера = 1 Тогда
		СтрокаСтатуса = "разговаривает";
	ИначеЕсли СтатусНомера = 2 Тогда
		СтрокаСтатуса = "не беспокоить (DND)";
	ИначеЕсли СтатусНомера = 4 Тогда
		СтрокаСтатуса = "не зарегистрирован на АТС";
	ИначеЕсли СтатусНомера = 8 Тогда
		СтрокаСтатуса = "входящий звонок";
	ИначеЕсли СтатусНомера = 9 Тогда
		СтрокаСтатуса = "разговаривает + входящий звонок";
	ИначеЕсли СтатусНомера = 16 Тогда
		СтрокаСтатуса = "удержание";
	ИначеЕсли СтатусНомера = 17 Тогда
		СтрокаСтатуса = "разговаривает + удержание";
	КонецЕсли;
	Возврат СтрокаСтатуса;
КонецФункции

//-----------------------------------------------------------------------------
Процедура ПеревестиЗвонокВыборНомера(ФормаСсылка, стрИмяТаблицыОжидающих, ссылкаКонтроллерАТС, стрСвойНомер, стрИмяОповещения) ЭКСПОРТ
	ТекущаяСтрокаОжидающих = ФормаСсылка.Элементы[стрИмяТаблицыОжидающих].ТекущиеДанные;
	Если ТекущаяСтрокаОжидающих = Неопределено Тогда
		бит_ТелефонияКлиентПереопределяемый.ПоказПредупреждение("Не выбран звонок");
		Возврат;
	КонецЕсли;

	формаВводаНомера = бит_ТелефонияКлиент.ПолучитьФормуВводаНомера(ФормаСсылка, Истина, ссылкаКонтроллерАТС, Ложь, стрСвойНомер);
	бит_ТелефонияКлиентПереопределяемый.ОткрытьФормуСБлокировкойВладельца(формаВводаНомера, стрИмяОповещения);
КонецПроцедуры

Процедура ПеревестиОжидающийЗвонокНаНомер(ФормаСсылка, стрИмяТаблицыОжидающих, стрСвойНомер, номерПеревода, ссылкаКонтроллерАТС, флагВебСервис, ИдКлиентаВебСервиса) ЭКСПОРТ
	ТекущаяСтрокаОжидающих = ФормаСсылка.Элементы[стрИмяТаблицыОжидающих].ТекущиеДанные;
	Если ТекущаяСтрокаОжидающих = Неопределено Тогда
		бит_ТелефонияКлиентПереопределяемый.ПоказПредупреждение("Не выбран звонок");
		Возврат;
	КонецЕсли;
	номерПереводаПолн = бит_АТСКлиент.СформироватьНомерСПрефиксами(номерПеревода);
	Если НЕ ЗначениеЗаполнено(номерПереводаПолн) Тогда
		Возврат;
	КонецЕсли;
	КаналОжид = ТекущаяСтрокаОжидающих.Канал;
	Попытка
		Если флагВебСервис Тогда
			ссылкаАТС = бит_АТССервер.ПолучитьАТС();
			бит_АТССервер.ВебСервисБезусловныйПеревод(ссылкаАТС, ИдКлиентаВебСервиса, КаналОжид, стрСвойНомер, номерПереводаПолн);
		Иначе
			ссылкаКонтроллерАТС.Redirect2(КаналОжид, стрСвойНомер, номерПереводаПолн);
		КонецЕсли;
	Исключение
		бит_ТелефонияКлиент.ВывестиСообщение(ОписаниеОшибки(), ФормаСсылка);
	КонецПопытки;
КонецПроцедуры

Процедура ПеревестиОжидающийЗвонокНаСвойНомер(ФормаСсылка, стрИмяТаблицыОжидающих, стрСвойНомер, ссылкаКонтроллерАТС, флагВебСервис, ИдКлиентаВебСервиса) ЭКСПОРТ
	стрНомерСУчетомВнеОфиса = стрСвойНомер;
	РежимВнеОфиса = бит_АТССервер.ПолучитьФлагРежимВнеОфиса();
	Если РежимВнеОфиса Тогда
		стрНомерСУчетомВнеОфиса = ПолучитьНомерВнеОфисаПолный();
		Если НЕ ЗначениеЗаполнено(стрНомерСУчетомВнеОфиса) Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	ПеревестиОжидающийЗвонокНаНомер(ФормаСсылка, стрИмяТаблицыОжидающих, стрСвойНомер, стрНомерСУчетомВнеОфиса, ссылкаКонтроллерАТС, флагВебСервис, ИдКлиентаВебСервиса);
КонецПроцедуры

//-----------------------------------------------------------------------------
Функция ПолучитьНомерВнеОфисаПолный() ЭКСПОРТ
	стрНомерВнеОфиса = бит_АТССервер.ПолучитьНомерВнеОфиса();
	стрНомерВнеОфиса = бит_АТСКлиент.СформироватьНомерСПрефиксами(стрНомерВнеОфиса);
	Если НЕ ЗначениеЗаполнено(стрНомерВнеОфиса) Тогда
		бит_ТелефонияКлиентПереопределяемый.ПоказПредупреждение("Не задан номер для работы вне офиса", , "Ошибка");
	КонецЕсли;
	Возврат стрНомерВнеОфиса;
КонецФункции

Процедура ОбработкаОшибки(ссылкаАТС, стрИсточник, стрЗаголовок, стрОшибка, ФормаСсылка) ЭКСПОРТ
	
	стрОписаниеОшибкиПодр = "";
	
	Если ЗначениеЗаполнено(ссылкаАТС) Тогда
		стрОписаниеОшибкиПодр = "АТС '" + Строка(ссылкаАТС) + "'. ";
	КонецЕсли;
	
	стрОписаниеОшибкиПодр = стрОписаниеОшибкиПодр + стрОшибка;
	
	Если НЕ (
		((СтрНайти(стрОписаниеОшибкиПодр, "Ошибка получения статусов") > 0) И (СтрНайти(стрОписаниеОшибкиПодр, "Таймаут") > 0))
		Или ((СтрНайти(стрОписаниеОшибкиПодр, "Invalid/unknown command:") > 0) И (СтрНайти(стрОписаниеОшибкиПодр, "Use Action: ListCommands to show available commands.") > 0))
		)
	Тогда
			бит_ТелефонияКлиент.ВывестиСообщение(стрОписаниеОшибкиПодр, ФормаСсылка);
	КонецЕсли;
	
	бит_ТелефонияСервер.ЗаписатьОшибкуВЖурналРегистрации(стрИсточник, стрЗаголовок, стрОписаниеОшибкиПодр);
	
КонецПроцедуры

Процедура ПроверкаОшибокВебСервиса(ссылкаАТС, стрИсточник, соотвИнфо, ФормаСсылка) ЭКСПОРТ
	Если соотвИнфо = Неопределено Тогда
		Возврат;
	КонецЕсли;
	соотвОшибки = соотвИнфо.Получить("Errors");
	Если соотвОшибки <> Неопределено Тогда
		Для Каждого соотвОшибка Из соотвОшибки Цикл
			текстОшибки = соотвОшибка.Получить("text");
			Если ЗначениеЗаполнено(текстОшибки) Тогда
				ОбработкаОшибки(ссылкаАТС, стрИсточник, "ВебСервисУправлениеАТС_Ошибка", текстОшибки, ФормаСсылка);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

//-----------------------------------------------------------------------------
Функция ПутьСервисаЗаписейРазговоровНаАТС() ЭКСПОРТ
	Возврат "/services/getrecord.php?id=";
КонецФункции

Функция СформироватьСсылкуНаЗаписьРазговора(стрАдресАТС, стрХэшЗаписи) ЭКСПОРТ
	Возврат "http://" + стрАдресАТС + ПутьСервисаЗаписейРазговоровНаАТС() + стрХэшЗаписи;
КонецФункции

//-----------------------------------------------------------------------------
&НаКлиенте
Функция ДатаВВебФормате(дтДата) ЭКСПОРТ
	Возврат Формат(дтДата, "DF=""yyyy-MM-dd HH:mm:ss""");
КонецФункции

&НаКлиенте
Функция ДатаИзВебФормата(стрДата) ЭКСПОРТ
	стрДатаЗв = СтрЗаменить(стрДата, " ", "");
	стрДатаЗв = СтрЗаменить(стрДатаЗв, "-", "");
	стрДатаЗв = СтрЗаменить(стрДатаЗв, ":", "");
	дтДата = Неопределено;
	Попытка
		дтДата = Дата(стрДатаЗв);
	Исключение
		бит_ТелефонияКлиент.ВывестиСообщение("Ошибка преобразования строки '" + стрДата + "' в дату");
	КонецПопытки;
	Возврат дтДата;
КонецФункции

&НаКлиенте
Функция ПроверитьРезультатЗапросаАТС(соотвОтветЗапроса, стрПрефиксОшибки, ФормаСсылка) ЭКСПОРТ
	резтЗапроса = соотвОтветЗапроса.Получить("result");
	Если резтЗапроса <> Истина Тогда
		стрПодробностиОшибки = соотвОтветЗапроса.Получить("error");
		Если ЗначениеЗаполнено(стрПодробностиОшибки) Тогда
			стрОшибка = стрПрефиксОшибки + ": " + стрПодробностиОшибки;
		Иначе
			стрОшибка = стрПрефиксОшибки + " - неправильный формат данных";
		КонецЕсли;
		ОбработкаОшибки(Неопределено, "БИТ.АТС_API", "Ошибка вызова функции API БИТ.АТС", стрОшибка, ФормаСсылка);
		Возврат Ложь;
	КонецЕсли;
	Возврат Истина;
КонецФункции

&НаКлиенте
Функция ЗвонокИсторииУспешен(стрСтатусЗв) ЭКСПОРТ
	Возврат (стрСтатусЗв = "ANSWERED");
КонецФункции

&НаКлиенте
Функция ЗвонокИсторииНаправление(стрНаправлениеЗв) ЭКСПОРТ
	стрНаправлениеВозвр = стрНаправлениеЗв;
	Если стрНаправлениеЗв = "incoming" Тогда
		стрНаправлениеВозвр = "входящий";
	ИначеЕсли стрНаправлениеЗв = "outgoing" Тогда
		стрНаправлениеВозвр = "исходящий";
	ИначеЕсли стрНаправлениеЗв = "internal" Тогда
		стрНаправлениеВозвр = "внутренний";
	ИначеЕсли стрНаправлениеЗв = "transit" Тогда
		стрНаправлениеВозвр = "транзит";
	КонецЕсли;
	Возврат стрНаправлениеВозвр;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура НачатьЗвонокВебСервис(ИдКлиента, стрВызывающийНомер, стрНомерКонтекста, стрВызываемыйНомер, флагЗаголовокАвтоподнятия, ТаймаутЗвонка)
	ссылкаАТС = бит_АТССервер.ПолучитьАТС();
	бит_АТССервер.ВебСервисНачатьРазговор(ссылкаАТС, ИдКлиента, стрВызывающийНомер, стрНомерКонтекста, стрВызываемыйНомер, флагЗаголовокАвтоподнятия, ТаймаутЗвонка);
КонецПроцедуры

#КонецОбласти

//-----------------------------------------------------------------------------
Процедура НачатьЗвонок(Подключен, СвязанныйНомер, ВызываемыйНомер, ссылкаКонтроллерАТС, флагВебСервис, ИдКлиентаВебСервиса, ФормаСсылка, ДокументСобытие = Неопределено, СобытияПоНомерам = Неопределено) ЭКСПОРТ
	
	//+Переопределенное
	Если СобытияПоНомерам = Неопределено Тогда
		СобытияПоНомерам = Новый Структура();
	КонецЕсли;
	//-Переопределенное
	
	Если НЕ Подключен Тогда
		бит_ТелефонияКлиентПереопределяемый.ПоказПредупреждение("Нет подключения к АТС", , "Ошибка");
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СвязанныйНомер) Тогда
		бит_ТелефонияКлиентПереопределяемый.ПоказПредупреждение("Не задан номер связанного телефона", , "Ошибка");
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВызываемыйНомер) Тогда
		бит_ТелефонияКлиентПереопределяемый.ПоказПредупреждение("Не задан номер вызова", , "Ошибка");
		Возврат;
	КонецЕсли;
	
	ТаймаутЗвонка = бит_АТСКлиент.ПолучитьТаймаутЗвонка();
	
	РежимВнеОфиса = бит_АТССервер.ПолучитьФлагРежимВнеОфиса();
	
	ВызываемыйНомер = бит_АТСКлиент.СформироватьНомерСПрефиксами(ВызываемыйНомер);
	
	Попытка
		
		Если РежимВнеОфиса Тогда
			
			стрНомерВнеОфиса = ПолучитьНомерВнеОфисаПолный();
			
			Если НЕ ЗначениеЗаполнено(стрНомерВнеОфиса) Тогда
				Возврат;
			КонецЕсли;
			
			ПоказатьОповещениеПользователя("Режим вне офиса - исходящий вызов", , "Вызов номера '" + ВызываемыйНомер + "' с внешнего телефона...");
			
			Если флагВебСервис Тогда
				НачатьЗвонокВебСервис(ИдКлиентаВебСервиса, стрНомерВнеОфиса, СвязанныйНомер, ВызываемыйНомер, Ложь, ТаймаутЗвонка);
			Иначе
				ссылкаКонтроллерАТС.MakeCall2(стрНомерВнеОфиса, СвязанныйНомер, ВызываемыйНомер, ТаймаутЗвонка);
			КонецЕсли;
			
			//+Переопределенное
			Если ДокументСобытие <> Неопределено Тогда 
				СобытияПоНомерам.Вставить(СвязанныйНомер, ДокументСобытие);
			КонецЕсли;
			//-Переопределенное
			
		Иначе
			
			ЗаголовокАвтоподнятия = бит_АТССервер.ПолучитьФлагЗаголовокАвтоподнятия();
			
			ПоказатьОповещениеПользователя("Исходящий вызов", , "Вызов номера '" + ВызываемыйНомер + "' со связанного телефона...");
	
			Если флагВебСервис Тогда
				НачатьЗвонокВебСервис(ИдКлиентаВебСервиса, СвязанныйНомер, СвязанныйНомер, ВызываемыйНомер, ЗаголовокАвтоподнятия, ТаймаутЗвонка);
			Иначе
				ссылкаКонтроллерАТС.MakeCall(СвязанныйНомер, ВызываемыйНомер, ЗаголовокАвтоподнятия, ТаймаутЗвонка);
			КонецЕсли;
			
		КонецЕсли;
		
	Исключение
		бит_ТелефонияКлиент.ВывестиСообщение( ОписаниеОшибки(), ФормаСсылка );
	КонецПопытки;
	
КонецПроцедуры
