#Область СлужебныеПроцедурыИФункции

// Формирование QR-кода для оплаты в платежной системе.
//
// Параметры:
//  ПараметрыПроцедуры - Структура - параметры выполнения длительной операции;
//  АдресРезультата - Строка - адрес результата операции во временном хранилище.
//
Процедура ИдентификаторОплатыВПлатежнойСистеме(ПараметрыПроцедуры, АдресРезультата) Экспорт
	
	ПередВыполнениемОперацииВПлатежнойСистеме(
		ПараметрыПроцедуры.ДокументОплаты);
	
	РезультатОперации = ИнтеграцияСПлатежнымиСистемами.ИдентификаторОплаты(
		ПараметрыПроцедуры.ДокументОплаты,
		ПараметрыПроцедуры.ТорговаяТочка);
	
	ПоместитьВоВременноеХранилище(
		РезультатОперации,
		АдресРезультата);
	
КонецПроцедуры

// Определяет статус оплаты в платежной системе.
//
// Параметры:
//  ПараметрыПроцедуры - Структура - параметры выполнения длительной операции;
//  АдресРезультата - Строка - адрес результата операции во временном хранилище.
//
Процедура СтатусОплатыВПлатежнойСистеме(ПараметрыПроцедуры, АдресРезультата) Экспорт
	
	ПередВыполнениемОперацииВПлатежнойСистеме(
		ПараметрыПроцедуры.ДокументОплаты);
	
	РезультатОперации = ИнтеграцияСПлатежнымиСистемами.СтатусОплаты(
		ПараметрыПроцедуры.ДокументОплаты,
		ПараметрыПроцедуры.ТорговаяТочка);
	
	ПоместитьВоВременноеХранилище(РезультатОперации, АдресРезультата);
	
КонецПроцедуры

// Отменяет заказ на оплату, если оплата не была ранее подтверждена мерчантом.
//
// Параметры:
//  ДокументОплаты - ОпределяемыйТип.ДокументОперацииБИП - документ, который отражает
//                    продажу в информационной базе;
//  ТорговаяТочка - СправочникСсылка.НастройкиИнтеграцииСПлатежнымиСистемами -
//                  настройка выполнения операции платежной системы.
//
// Возвращаемое значение:
//  Структура - см. ИнтеграцияСПлатежнымиСистемами.ОтменитьЗаказНаОплату.
//
Функция ОтменитьЗаказНаОплату(ДокументОплаты, ТорговаяТочка) Экспорт
	
	ПередВыполнениемОперацииВПлатежнойСистеме(
		ДокументОплаты);
	
	Возврат ИнтеграцияСПлатежнымиСистемами.ОтменитьЗаказНаОплату(
		ДокументОплаты,
		ТорговаяТочка);
	
КонецФункции

// Производит возврат продажи платежной системе на основании чека продажи или идентификатора оплаты.
//
// Параметры:
//  ПараметрыПроцедуры - Структура - параметры выполнения длительной операции;
//  АдресРезультата - Строка - адрес результата операции во временном хранилище.
//
Процедура ВозвратОплаты(ПараметрыПроцедуры, АдресРезультата) Экспорт
	
	ПередВыполнениемОперацииВПлатежнойСистеме(
		ПараметрыПроцедуры.ДокументВозврата);
	
	РезультатОперации = ИнтеграцияСПлатежнымиСистемами.ВозвратОплаты(
		ПараметрыПроцедуры.ДокументВозврата,
		?(ЗначениеЗаполнено(ПараметрыПроцедуры.ДокументОплаты),
			ПараметрыПроцедуры.ДокументОплаты,
			ПараметрыПроцедуры.ИдентификаторОплаты),
		ПараметрыПроцедуры.ТорговаяТочка,
		ПараметрыПроцедуры.ПлатежнаяСистема);
	
	ПоместитьВоВременноеХранилище(РезультатОперации, АдресРезультата);
	
КонецПроцедуры

// Производит получение статуса возврата по документу.
//
// Параметры:
//  ПараметрыПроцедуры - Структура - параметры выполнения длительной операции;
//  АдресРезультата - Строка - адрес результата операции во временном хранилище.
//
Процедура СтатусВозвратОплаты(ПараметрыПроцедуры, АдресРезультата) Экспорт
	
	ПередВыполнениемОперацииВПлатежнойСистеме(
		ПараметрыПроцедуры.ДокументВозврата);
	
	РезультатОперации = ИнтеграцияСПлатежнымиСистемами.СтатусВозврата(
		ПараметрыПроцедуры.ДокументВозврата,
		ПараметрыПроцедуры.ТорговаяТочка);
	
	ПоместитьВоВременноеХранилище(РезультатОперации, АдресРезультата);
	
КонецПроцедуры

// Подтверждает возврат в платежной системе.
//
// Параметры:
//  ДокументОплаты - ОпределяемыйТип.ДокументОперацииБИП - документ, который отражает
//                   оплату в информационной базе;
//  ТорговаяТочка - СправочникСсылка.НастройкиИнтеграцииСПлатежнымиСистемами -
//                  настройка выполнения операции платежной системы.
//
// Возвращаемое значение:
//  Структура - см. ИнтеграцияСПлатежнымиСистемами.ПодтвердитьВозврат.
//
Функция ПодтвердитьВозврат(ДокументВозврата, ТорговаяТочка) Экспорт
	
	ПередВыполнениемОперацииВПлатежнойСистеме(
		ДокументВозврата);
	
	Возврат ИнтеграцияСПлатежнымиСистемами.ПодтвердитьВозврат(
		ДокументВозврата,
		ТорговаяТочка);
	
КонецФункции

// Загружает статусы оплаты СБП.
//
// Параметры:
//  ПараметрыПроцедуры - Структура - параметры выполнения длительной операции;
//  АдресРезультата - Строка - адрес результата операции во временном хранилище.
//
Процедура ПолучитьСтатусыОперацияC2B(ПараметрыПроцедуры, АдресРезультата) Экспорт
	
	ОбработанныеОперации = ИнтеграцияСПлатежнымиСистемами.СтатусыОперацийC2B();
	
	ПоместитьВоВременноеХранилище(ОбработанныеОперации, АдресРезультата);
	
КонецПроцедуры

// Проверяет документ операции, в случае ошибки вызывает исключение.
//
// Параметры:
//  ДокументОплаты - ОпределяемыйТип.ДокументОперацииБИП - документ, который отражает
//                   оплату в информационной базе;
//
Процедура ПередВыполнениемОперацииВПлатежнойСистеме(ДокументОперации)
	
	Если ЗначениеЗаполнено(ДокументОперации) Тогда
		Если ТипЗнч(ДокументОперации) = Тип("ДокументСсылка.ОказаниеУслуг") 
			Или ТипЗнч(ДокументОперации) = Тип("ДокументСсылка.ОплатаПлатежнойКартой")
			Или ТипЗнч(ДокументОперации) = Тип("ДокументСсылка.ВозвратПоПлатежнойКарте")
		Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;		
	
	ВызватьИсключение НСтр("ru = 'Оплата в платежной системе для документа не поддерживается.'");
	
	
КонецПроцедуры

// См. УправлениеПечатьюПереопределяемый.ПриОпределенииОбъектовСКомандамиПечати
Процедура ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов) Экспорт
	
	//СписокОбъектов.Добавить(Документы._ДемоЧекККМ);
	//СписокОбъектов.Добавить(Документы._ДемоСчетНаОплатуПокупателю);
	
КонецПроцедуры

Функция ПолучитьТорговуюТочкуПоЭквайринговомуТерминалу(ЭквайринговыйТерминал) Экспорт
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЭквайринговыеТерминалы.ТорговаяТочкаСБП КАК ТорговаяТочка
		|ИЗ
		|	Справочник.ЭквайринговыеТерминалы КАК ЭквайринговыеТерминалы
		|ГДЕ
		|	ЭквайринговыеТерминалы.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ЭквайринговыйТерминал);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат ВыборкаДетальныеЗаписи.ТорговаяТочка;
	КонецЦикла;
	
	Возврат Неопределено;	
	
КонецФункции

Функция ПроверитьСуществующийИдентификаторПоДокументуОплаты(ДокументОплаты) Экспорт
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИдентификаторыОперацийСБП.Идентификатор КАК Идентификатор,
		|	ДанныеОперацийСБП.ДатаОперации КАК ДатаОперации,
		|	ДанныеОперацийСБП.СуммаОперации КАК СуммаОперации,
		|	ДанныеОперацийСБП.ТорговаяТочка КАК ТорговаяТочка,
		|	ИдентификаторыОперацийСБП.СтатусОперации КАК СтатусОперации
		|ИЗ
		|	РегистрСведений.ИдентификаторыОперацийСБП КАК ИдентификаторыОперацийСБП
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеОперацийСБП КАК ДанныеОперацийСБП
		|		ПО ИдентификаторыОперацийСБП.Идентификатор = ДанныеОперацийСБП.Идентификатор
		|ГДЕ
		|	ИдентификаторыОперацийСБП.ДокументОперации = &ДокументОперации";
	
	Запрос.УстановитьПараметр("ДокументОперации", ДокументОплаты);
	
	Выборка =  Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		СтруктураВозврата = Новый Структура;
		СтруктураВозврата.Вставить("Идентификатор", Выборка.Идентификатор);
		СтруктураВозврата.Вставить("СуммаОперации", Выборка.СуммаОперации);
		СтруктураВозврата.Вставить("ТорговаяТочка", Выборка.ТорговаяТочка);
		СтруктураВозврата.Вставить("СтатусОперации", Выборка.СтатусОперации);
		СтруктураВозврата.Вставить("ДатаОперации", Выборка.ДатаОперации);
		Возврат СтруктураВозврата;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
	
	
КонецФункции

Функция ПолучитьДанныеСуммыПоБезналу(ДокументСсылка) Экспорт
	
	Если ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ОказаниеУслуг") Тогда
		Отбор = Новый Структура("ВидОплаты",Перечисления.ВидыОплаты.Безналичные);
		мОплатыБезналом = ДокументСсылка.Оплата.НайтиСтроки(Отбор);		
		Если мОплатыБезналом.Количество() = 1 Тогда	
			ВозвращаемыеДанные = Новый Структура;
			ВозвращаемыеДанные.Вставить("СуммаОплаты", мОплатыБезналом[0].Сумма);
			ВозвращаемыеДанные.Вставить("ДатаОплаты", ДокументСсылка.Дата);
			ВозвращаемыеДанные.Вставить("ЭквайринговыйТерминал", мОплатыБезналом[0].ЭквайринговыйТерминал);
			Возврат ВозвращаемыеДанные;			
		Иначе
			ВызватьИсключение "Количество строк оплаты безналичным более 1 или отсутствует!";	
		КонецЕсли; 
	ИначеЕсли ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ОплатаПлатежнойКартой") Тогда
		ВозвращаемыеДанные = Новый Структура;
		ВозвращаемыеДанные.Вставить("СуммаОплаты", ДокументСсылка.СуммаДокумента);
		ВозвращаемыеДанные.Вставить("ДатаОплаты", ДокументСсылка.Дата);
		ВозвращаемыеДанные.Вставить("ЭквайринговыйТерминал", ДокументСсылка.ЭквайринговыйТерминал);
		Возврат ВозвращаемыеДанные;
	КонецЕсли;
	
	Возврат Неопределено;

КонецФункции

Функция ПолучитьНастройкиТорговойТочки(ТорговаяТочка) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СоответствиеНастроекСБП.СрокЖизниQRКода КАК СрокЖизниQRКода,
		|	СоответствиеНастроекСБП.НазначениеПлатежа КАК НазначениеПлатежа
		|ИЗ
		|	РегистрСведений.СоответствиеНастроекСБП КАК СоответствиеНастроекСБП
		|ГДЕ
		|	СоответствиеНастроекСБП.ТорговаяТочка = &ТорговаяТочка";
	
	Запрос.УстановитьПараметр("ТорговаяТочка", ТорговаяТочка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("СрокЖизниQRКода", Неопределено);
	СтруктураВозврата.Вставить("НазначениеПлатежа", Неопределено);
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(СтруктураВозврата, ВыборкаДетальныеЗаписи);		
	КонецЕсли;
	
	Возврат СтруктураВозврата;
	
КонецФункции 

Функция ПолучитьИдентификаторОперации(ДокументОперации) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИдентификаторыОперацийСБП.Идентификатор КАК Идентификатор
		|ИЗ
		|	РегистрСведений.ИдентификаторыОперацийСБП КАК ИдентификаторыОперацийСБП
		|ГДЕ
		|	ИдентификаторыОперацийСБП.ДокументОперации = &ДокументОперации";
	
	Запрос.УстановитьПараметр("ДокументОперации", ДокументОперации); 

	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Идентификатор;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Функция СоздатьДокументВозвратаПоПлатежнойКарте(ДокументОснование, СуммаДокумента) Экспорт
	
	НовыйВозврат = Документы.ВозвратПоПлатежнойКарте.СоздатьДокумент();	
	НовыйВозврат.ДокументОснование = ДокументОснование;
	НовыйВозврат.АдресEmailЧек = ДокументОснование.АдресEmailЧек;
	НовыйВозврат.Дата = ТекущаяДата();
	НовыйВозврат.Клиент = ДокументОснование.Клиент;
	НовыйВозврат.СуммаДокумента = СуммаДокумента;
	ДанныеДокумента = ПолучитьДанныеСуммыПоБезналу(ДокументОснование);
	НовыйВозврат.ЭквайринговыйТерминал = ДанныеДокумента.ЭквайринговыйТерминал;
	НовыйВозврат.Ответственный = ПараметрыСеанса.ТекущийПользователь;
	НовыйВозврат.Записать(РежимЗаписиДокумента.Запись);
	Возврат НовыйВозврат.Ссылка;
	
КонецФункции

Функция СоздатьДокументОплатаПлатежнойКартой(ДокументОснование, СуммаДокумента) Экспорт

	НовоеПоступление = Документы.ОплатаПлатежнойКартой.СоздатьДокумент();
	НовоеПоступление.ДокументОснование = ДокументОснование;
	НовоеПоступление.АдресEmailЧек = ДокументОснование.АдресEmailЧек;
	НовоеПоступление.Дата = ТекущаяДата();
	НовоеПоступление.Клиент = ДокументОснование.Клиент;
	НовоеПоступление.СуммаДокумента = СуммаДокумента;
	ДанныеДокумента = ПолучитьДанныеСуммыПоБезналу(ДокументОснование);	
	НовоеПоступление.ЭквайринговыйТерминал = ДанныеДокумента.ЭквайринговыйТерминал;
	НовоеПоступление.Ответственный = ПараметрыСеанса.ТекущийПользователь;
	НовоеПоступление.Записать(РежимЗаписиДокумента.Запись);
	Возврат НовоеПоступление.Ссылка;
	
КонецФункции

Функция ЭтоЭквайринговыйТерминалСБП(ЭквайринговыйТерминал) Экспорт

	Если ЗначениеЗаполнено(ЭквайринговыйТерминал.ТорговаяТочкаСБП) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти


