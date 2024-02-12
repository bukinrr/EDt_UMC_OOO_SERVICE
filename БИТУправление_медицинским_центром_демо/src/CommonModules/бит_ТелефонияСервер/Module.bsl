////////////////////////////////////////////////////////////////////////////////
// Общий модуль телефонии БИТ
// Содержит общие функции, вызываемые на сервере.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Функция ПолучитьВерсиюПодсистемы() ЭКСПОРТ
	Возврат "1.7.33.442";
КонецФункции

Функция ЗаписатьОшибкуВЖурналРегистрации(стрИсточник, стрОшибка, стрОписание) ЭКСПОРТ
	ЗаписьЖурналаРегистрации(стрИсточник, УровеньЖурналаРегистрации.Ошибка, , стрОшибка, стрОписание);
КонецФункции

Функция ПолучитьТекущегоПользователя() ЭКСПОРТ
	//ПользовательБД = ИмяПользователя();
	//Пользователь = Справочники.Пользователи.НайтиПоКоду(ПользовательБД);
	Пользователь = ПараметрыСеанса.ТекущийПользователь;
	Возврат Пользователь;
КонецФункции

Процедура УстановитьНастройкуТекущегоПользователя(стрИмяРегистраСведений, стрИмяМодуля, стрНастройка, значениеНастройки) ЭКСПОРТ
	ПользовательЗап = ПолучитьТекущегоПользователя();
	зап = РегистрыСведений[стрИмяРегистраСведений].СоздатьМенеджерЗаписи();
	зап.Пользователь = ПользовательЗап;
	зап.Прочитать();
	обновитьЗапись = Ложь;
	Если НЕ зап.Выбран() Тогда
		ЗаполнитьНастройкиПоУмолчаниюОбщ(стрИмяМодуля, зап);
		обновитьЗапись = Истина;
	КонецЕсли;
	Если зап[стрНастройка] <> значениеНастройки Тогда
		зап[стрНастройка] = значениеНастройки;
		обновитьЗапись = Истина;
	КонецЕсли;
	Если обновитьЗапись Тогда
		зап.Записать();
	КонецЕсли;
КонецПроцедуры

Функция ПолучитьПараметрыОткрытияФормыНастроек(стрИмяРегистраСведений, стрИмяМодуля) ЭКСПОРТ
	ПользовательЗап =  ПолучитьТекущегоПользователя();
	менеджЗапись = РегистрыСведений[стрИмяРегистраСведений].СоздатьМенеджерЗаписи();
	менеджЗапись.Пользователь = ПользовательЗап;
	менеджЗапись.Прочитать();
	Если НЕ менеджЗапись.Выбран() Тогда
		ЗаполнитьНастройкиПоУмолчаниюОбщ(стрИмяМодуля, менеджЗапись);
		менеджЗапись.Записать();
	КонецЕсли;
	Отбор = Новый Структура("Пользователь", ПользовательЗап);
	ключзап = РегистрыСведений[стрИмяРегистраСведений].СоздатьКлючЗаписи(Отбор);
	ПараметрыОткрытияНастроек = Новый Структура("Ключ", ключзап);
	Возврат ПараметрыОткрытияНастроек;
КонецФункции

// Возвращает массив из 3 чисел или Неопределено
Функция ПолучитьРежимСовместимостиКонфигурации() ЭКСПОРТ
	РежСовмест = Метаданные.РежимСовместимости;
	Если РежСовмест = Метаданные.СвойстваОбъектов.РежимСовместимости.НеИспользовать Тогда
		Возврат Неопределено;
	КонецЕсли;
	стрРежимСовмест = Строка(РежСовмест);
	стрРежимСовмест = СтрЗаменить(стрРежимСовмест, "Версия", "");
	списЗначРеж = бит_ТелефонияКлиентСервер.СтрРазбить(стрРежимСовмест, "_");
	массРеж = Новый Массив(3);
	Для й=0 По 2 Цикл
		массРеж[й] = Число(списЗначРеж[й].Значение);
	КонецЦикла;
	Возврат массРеж;
КонецФункции

Функция ПолучитьПрефиксВыходаНаВнешнююЛиниюПоУмолчанию() ЭКСПОРТ
	// префикс может переопределяться при внедрениях
	Возврат "";
КонецФункции

Функция ПолучитьНаименованиеНабранногоНомера(стрНабранныйНомер) ЭКСПОРТ
	стрНомерПоиска = бит_ТелефонияКлиентСервер.СократитьНомерДляПоиска(
							бит_ТелефонияКлиентСервер.ОчиститьНомерТолькоЦифры(стрНабранныйНомер)
							);
	стрНаименование = стрНомерПоиска;
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	бит_НабранныеНомера.Наименование
	               |ИЗ
	               |	РегистрСведений.бит_НабранныеНомера КАК бит_НабранныеНомера
	               |ГДЕ
	               |	бит_НабранныеНомера.Номер = &Номер";
	Запрос.УстановитьПараметр("Номер", стрНомерПоиска);
	резт = Запрос.Выполнить();
	Если НЕ резт.Пустой() Тогда
		табл = резт.Выгрузить();
		наим = СокрЛП(табл[0].Наименование);
		Если ЗначениеЗаполнено(наим) Тогда
			стрНаименование = наим;
		КонецЕсли;
	КонецЕсли;
	Возврат стрНаименование;
КонецФункции

Функция СкачатьПоHTTPS(АдресHTTP, таймаут, флагЗагрузкаТекста, ТелоОтвета, стрОшибка) ЭКСПОРТ
	Возврат бит_ТелефонияКлиентСервер.СкачатьПоHTTPS(АдресHTTP, таймаут, флагЗагрузкаТекста, ТелоОтвета, стрОшибка);
КонецФункции

// поиск в избранном
Функция НайтиКонтрагентаПоНомеруВИзбранном(Знач КороткийНомер, флагВнешнийВызов, КонтрагентСсылка) ЭКСПОРТ
	Если НЕ ЗначениеЗаполнено(КороткийНомер) Тогда
		КонтрагентСсылка = "";
		Возврат Ложь;
	КонецЕсли;
	
	запросИзбр = Новый Запрос;
	Если флагВнешнийВызов Тогда
		// внешний вызов
		длинаВнешнегоНомера = бит_ТелефонияКлиентСервер.ПолучитьДлинуВнешнегоНомера();
		внешНомер = Прав(КороткийНомер, длинаВнешнегоНомера);
		запросИзбр.Текст = "ВЫБРАТЬ
		|	бит_БитфонИзбранное.Наименование
		|ИЗ
		|	Справочник.бит_БитфонИзбранное КАК бит_БитфонИзбранное
		|ГДЕ
		|	(бит_БитфонИзбранное.Пользователь = &Пользователь
		|			ИЛИ бит_БитфонИзбранное.Пользователь = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка))
		|	И бит_БитфонИзбранное.Номер ПОДОБНО &Номер";
		запросИзбр.УстановитьПараметр("Номер", "%" + внешНомер);
	Иначе
		запросИзбр.Текст = "ВЫБРАТЬ
		|	бит_БитфонИзбранное.Наименование
		|ИЗ
		|	Справочник.бит_БитфонИзбранное КАК бит_БитфонИзбранное
		|ГДЕ
		|	(бит_БитфонИзбранное.Пользователь = &Пользователь
		|			ИЛИ бит_БитфонИзбранное.Пользователь = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка))
		|	И бит_БитфонИзбранное.Номер = &Номер";
		запросИзбр.УстановитьПараметр("Номер", КороткийНомер);
	КонецЕсли;
	
	запросИзбр.УстановитьПараметр("Пользователь", ПолучитьТекущегоПользователя());
	
	Результат = запросИзбр.Выполнить();
	
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		КонтрагентСсылка = ВыборкаДетальныеЗаписи.Наименование + " (избранное)";
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
КонецФункции

Процедура ДобавитьВИсториюЗвонков(СвойНомер,
							флагТипЗвонкаВходящий,
							Номер,
							Абонент,
							КонтактноеЛицо,
							Успешность,
							Длительность,
							НабранныйНомер,
							стрПутьКЗаписи) ЭКСПОРТ
	//
	датаНачРазговора = ТекущаяДата() - Длительность;
	//
	ДобавитьВИсториюЗвонковСДатой(датаНачРазговора,
		СвойНомер,
		флагТипЗвонкаВходящий,
		Номер,
		Абонент,
		КонтактноеЛицо,
		Успешность,
		Длительность,
		НабранныйНомер,
		стрПутьКЗаписи);
КонецПроцедуры

Функция ИсторияЗвонковПолучитьКлюч(структОтбор) ЭКСПОРТ
	структОтбор.Пользователь = ПолучитьТекущегоПользователя();
	ключ = РегистрыСведений.бит_ИсторияЗвонков.СоздатьКлючЗаписи(структОтбор);
	Возврат ключ;
КонецФункции

Функция УдалитьИсториюЗвонковКонтрагента(контрагентСсылка) ЭКСПОРТ
	Отбор = Новый Структура("Абонент", контрагентСсылка);
	выборка = РегистрыСведений.бит_ИсторияЗвонков.Выбрать(Отбор);
	записейУдалено = 0;
	Пока выборка.Следующий() Цикл
		менеджер = выборка.ПолучитьМенеджерЗаписи();
		менеджер.Удалить();
		записейУдалено = записейУдалено + 1;
	КонецЦикла;
	Возврат записейУдалено;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Работа с Избранным

Процедура ИзбранноеУдалить(ИзбранноеСсылка) ЭКСПОРТ
	избрОбъект = ИзбранноеСсылка.ПолучитьОбъект();
	избрОбъект.ПометкаУдаления = Не избрОбъект.ПометкаУдаления;
	избрОбъект.Записать();
КонецПроцедуры

Процедура ИзбранноеОбновить(форма) ЭКСПОРТ
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	бит_БитфонИзбранное.Ссылка,
	               |	бит_БитфонИзбранное.Наименование,
	               |	бит_БитфонИзбранное.Номер,
	               |	бит_БитфонИзбранное.ОтслеживатьСтатус,
	               |	бит_БитфонИзбранное.ПометкаУдаления,
	               |	0 КАК ИндексКартинкиСтатуса
	               |ИЗ
	               |	Справочник.бит_БитфонИзбранное КАК бит_БитфонИзбранное
	               |ГДЕ
	               |	(бит_БитфонИзбранное.Пользователь = &Пользователь
	               |			ИЛИ бит_БитфонИзбранное.Пользователь = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка))
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	бит_БитфонИзбранное.Наименование";
	
	Пользователь = бит_ТелефонияСервер.ПолучитьТекущегоПользователя();
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	таблИзбр = Запрос.Выполнить().Выгрузить();
	форма.ЗначениеВРеквизитФормы(таблИзбр, "Избранное");
КонецПроцедуры

Функция ИзбранноеНайтиНомер(стрИзбранноеНаименование) ЭКСПОРТ
	стрИзбранноеНомер = "";
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	бит_БитфонИзбранное.Номер
	               |ИЗ
	               |	Справочник.бит_БитфонИзбранное КАК бит_БитфонИзбранное
	               |ГДЕ
	               |	бит_БитфонИзбранное.ПометкаУдаления = ЛОЖЬ
	               |	И бит_БитфонИзбранное.Наименование = &Наименование";
	Запрос.УстановитьПараметр("Наименование", стрИзбранноеНаименование);
	таблИзбр = Запрос.Выполнить().Выгрузить();
	Если таблИзбр.Количество() > 0 Тогда
		стрИзбранноеНомер = таблИзбр[0].Номер;
	КонецЕсли;
	Возврат стрИзбранноеНомер;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьНастройкиПоУмолчаниюОбщ(стрИмяМодуля, настройки)
	Если стрИмяМодуля = "бит_БитфонСервер" Тогда
		бит_БитфонСервер.ЗаполнитьНастройкиПоУмолчаниюТекущегоПользователя(настройки);
	ИначеЕсли стрИмяМодуля = "бит_АТССервер" Тогда
		бит_АТССервер.ЗаполнитьНастройкиПоУмолчаниюТекущегоПользователя(настройки);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

//-----------------------------------------------------------------------------
// Поиск контрагента и контактного лица по номеру телефона.
//
// Параметры:
//  НомерДляПоиска - Строка - номер телефона.
//  КонтрагентСсылка - ссылка на элемент справочника контрагентов (возвращаемый параметр).
//  КонтактноеЛицоСсылка - ссылка на элемент справочника контактных лиц (возвращаемый параметр).
//  флагНеИскатьКонтрагента - Булево - флаг, отключающий поиск в базе данных,
//                            параметры контрагент и контактное лицо заполняются пустыми ссылками.
//  флагПоискДублей - Булево - флаг, включающий поиск нескольких контрагентов.
//  флагЕстьДублиВозвращ - возвращаемое значение, тип Булево, признак того что найдены дубли контрагентов.
//
// Возвращаемое значение:
//   Булево - признак успешности поиска контрагента по номеру.
//
Функция НайтиКонтрагентаИКонтактноеЛицоПоНомеру(НомерДляПоиска, КонтрагентСсылка, КонтактноеЛицоСсылка, флагНеИскатьКонтрагента,
												флагПоискДублей, флагЕстьДублиВозвращ) ЭКСПОРТ
	КороткийНомер = бит_ТелефонияКлиентСервер.СократитьНомерДляПоиска(НомерДляПоиска);
	стрИмяСправочникаКонтрагентов = бит_ТелефонияСерверПереопределяемый.ПолучитьИмяСправочникаКонтрагентов();
	стрИмяСправочникаКонтактныхЛиц = бит_ТелефонияСерверПереопределяемый.ПолучитьИмяСправочникаКонтактныхЛиц();
	КонтрагентСсылка = Справочники[стрИмяСправочникаКонтрагентов].ПустаяСсылка();
	КонтактноеЛицоСсылка = Справочники[стрИмяСправочникаКонтактныхЛиц].ПустаяСсылка();
	флагЕстьДублиВозвращ = Ложь;
	Если НЕ ЗначениеЗаполнено(КороткийНомер) ИЛИ флагНеИскатьКонтрагента Тогда
		Возврат Ложь;
	КонецЕсли;
	найден = Ложь;
	
	//+Переопределенное
	//таблКонтраг = бит_ТелефонияСерверПереопределяемый.НайтиКонтрагентовПоНомеруВКонтактах(КороткийНомер, НЕ флагПоискДублей);
	таблКонтраг = бит_ТелефонияСерверПереопределяемый.НайтиКлиентовПоНомеруТелефона(КороткийНомер, флагПоискДублей);
	Если таблКонтраг.Количество() > 0 Тогда
		КонтрагентСсылка = таблКонтраг[0].Контрагент;
		КонтактноеЛицоСсылка = таблКонтраг[0].КонтактноеЛицо;
		найден = Истина;
		Если флагПоискДублей И таблКонтраг.Количество() > 1 Тогда
			Для Каждого строкаКонтраг Из таблКонтраг Цикл
				Если строкаКонтраг.Контрагент <> КонтрагентСсылка Тогда
					флагЕстьДублиВозвращ = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	Возврат найден;
	//-Переопределенное
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Работа с историей звонков

Процедура ДобавитьВИсториюЗвонковСДатой(датаНачРазговора,
							СвойНомер,
							флагТипЗвонкаВходящий,
							Номер,
							Абонент,
							КонтактноеЛицо,
							Успешность,
							Длительность,
							НабранныйНомер,
							стрПутьКЗаписи) ЭКСПОРТ
	//
	запись = РегистрыСведений.бит_ИсторияЗвонков.СоздатьМенеджерЗаписи();
	запись.Пользователь			= ПолучитьТекущегоПользователя();
	запись.СвойНомер			= СвойНомер;
	запись.Дата					= датаНачРазговора;
	запись.Абонент				= Абонент;
	запись.КонтактноеЛицо		= КонтактноеЛицо;
	запись.Номер				= Номер;
	запись.ТипЗвонка = ? ( флагТипЗвонкаВходящий, Перечисления.бит_ТипЗвонка.Входящий, Перечисления.бит_ТипЗвонка.Исходящий);
	запись.Успешность			= Успешность;
	запись.ДлительностьЗвонка	= Длительность;
	запись.НабранныйНомер		= НабранныйНомер;
	запись.ЗаписьРазговора		= стрПутьКЗаписи;
	
	//+БИТ.УМЦ
	Попытка
		ПараметрыСоединения = бит_БитфонСервер.ПолучитьПараметрыСоединения();
		Запись.Логин = ПараметрыСоединения.Логин;
	Исключение КонецПопытки;
	//-БИТ.УМЦ
	
	запись.Записать();
КонецПроцедуры
