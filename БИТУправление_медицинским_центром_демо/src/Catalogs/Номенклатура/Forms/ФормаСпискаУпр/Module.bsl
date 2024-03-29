#Область ОписаниеПеременных
&НаКлиенте
Перем соотВидыНоменклатуры;
&НаКлиенте
Перем мУчетнаяПолитика;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.КнопкаПанельИнформации.Пометка = РаботаСФормамиСервер.ПолучитьНастройкуФормы("ФормаСпискаНоменклатуры", "ОтображатьПанельИнформации", Ложь);
	Элементы.ГруппаПанельИнформации.Видимость = Элементы.КнопкаПанельИнформации.Пометка;
	
	// Настройка видимости панели информации.
	мПоказыватьСопутствующиеТовары = УправлениеНастройками.ПолучитьУчетнуюПолитику().ПоказыватьСопутствующиеТовары;
	Элементы.ГруппаСопутствующиеТовары.Видимость = мПоказыватьСопутствующиеТовары;
	
	Элементы.ГруппаОстатки.Видимость = ПравоДоступа("Просмотр", Метаданные.РегистрыНакопления.ПартииТоваровНаСкладах);
	Если Не Элементы.ГруппаОстатки.Видимость И Не Элементы.ГруппаСопутствующиеТовары.Видимость Тогда
		Элементы.КнопкаПанельИнформации.Видимость = Ложь;
	КонецЕсли;
	
	ТабличноеПолеОстатки.Параметры.УстановитьЗначениеПараметра("ЕдиницаИзмерения", Неопределено);
	ТабличноеПолеОстатки.Параметры.УстановитьЗначениеПараметра("Номенклатура", Неопределено);	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	мУчетнаяПолитика = УправлениеНастройками.ПолучитьУчетнуюПолитику();
	соотВидыНоменклатуры = СоотвВидыНоменклатуры();
	
	Если Истина // ИспользоватьПодключаемоеОборудование Проверка на включенную ФО "Использовать ВО".
	   И МенеджерОборудованияКлиент.ОбновитьРабочееМестоКлиента() Тогда // Проверка на определенность рабочего места ВО.

		ОписаниеОшибки = "";
		
		ПоддерживаемыеТипыВО = Новый Массив();
		ПоддерживаемыеТипыВО.Добавить("СканерШтрихкода");
		
		ОповещенияПриПодключении = Новый ОписаниеОповещения("ПодключитьОборудованиеЗавершение", ЭтотОбъект);    
		МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПоТипу(ОповещенияПриПодключении, УникальныйИдентификатор, ПоддерживаемыеТипыВО);
	
	КонецЕсли;
	
	РаботаСДиалогамиКлиент.СкрытьПоказатьАрхивные(Элементы.ФормаСкрытьПоказатьАрхивные, Список, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;

	НастройкиФормы = Новый Структура;
	НастройкиФормы.Вставить("ОтображатьПанельИнформации", Элементы.КнопкаПанельИнформации.Пометка);
	
	РаботаСФормамиСервер.СохранитьНастройкиФормы(НастройкиФормы, "ФормаСпискаНоменклатуры"); 
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	// МеханизмВнешнегоОборудования
	ПоддерживаемыеТипыВО = Новый Массив();
	ПоддерживаемыеТипыВО.Добавить("СканерШтрихкода");
	ПоддерживаемыеТипыВО.Добавить("СчитывательМагнитныхКарт");
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПоТипу(Неопределено, УникальныйИдентификатор, ПоддерживаемыеТипыВО);
	// Конец МеханизмВнешнегоОборудования
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ScanData" Тогда
		Если ВводДоступен() Тогда
			ТипШК = Неопределено;
			РаботаСТорговымОборудованиемКлиент.ОбработатьСобытиеСШКФормы(ЭтаФорма, Параметр, ТипШК);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СопутствующиеТоварыНаименованиеПриИзменении(Элемент)
	стр = СопутствующиеТоварыНаименованиеПриИзмененииСервер(Элемент.Родитель.ТекущиеДанные.Номенклатура);
	
	Элемент.Родитель.ТекущиеДанные.Артикул = стр.Артикул;
	Элемент.Родитель.ТекущиеДанные.Код = стр.Код;
	Элемент.Родитель.ТекущиеДанные.ВидНоменклатуры = стр.ВидНоменклатуры;
	
КонецПроцедуры

&НаСервере
Функция СопутствующиеТоварыНаименованиеПриИзмененииСервер(Ссылка)
	Стр = Новый Структура;
	Стр.Вставить("Код", Ссылка.Код);
	Стр.Вставить("ВидНоменклатуры", Ссылка.ВидНоменклатуры);
	Стр.Вставить("Артикул", Ссылка.Артикул);
	Возврат Стр;
КонецФункции	


#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура КнопкаПанельИнформацииНажатие(Команда)
	
	Элементы.КнопкаПанельИнформации.Пометка = Не Элементы.КнопкаПанельИнформации.Пометка;
	Элементы.ГруппаПанельИнформации.Видимость = Элементы.КнопкаПанельИнформации.Пометка;	
	Если Элементы.ГруппаПанельИнформации.Видимость Тогда
		ОбновитьОстатки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоместитьВАрхив(Команда)

	РаботаСДиалогамиКлиент.ПоместитьВАрхив(Элементы.Список.ВыделенныеСтроки);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьПоказатьАрхивные(Команда)

	РаботаСДиалогамиКлиент.СкрытьПоказатьАрхивные(Элементы.ФормаСкрытьПоказатьАрхивные, Список);
	
КонецПроцедуры

&НаСервере
Функция СоотвВидыНоменклатуры()
	Соот = Новый Соответствие;
	Соот.Вставить("Услуга", Перечисления.ВидыНоменклатуры.Услуга);
	Соот.Вставить("Материал", Перечисления.ВидыНоменклатуры.Материал);
	Соот.Вставить("Набор", Перечисления.ВидыНоменклатуры.Набор);
	Возврат Соот;	
КонецФункции	

&НаКлиенте
Процедура СопутствующиеТоварыОбновить(Команда)
	ОбновитьСписокСопутствующих();
КонецПроцедуры

&НаКлиенте
Процедура СопутствующиеТоварыСохранить(Команда)
	СопутствующиеТоварыСохранитьНаСервере(Элементы.Список.ТекущиеДанные.Ссылка);
КонецПроцедуры

&НаСервере
Процедура СопутствующиеТоварыСохранитьНаСервере(Ссылка)
	
	Об = Ссылка.ПолучитьОбъект();
	Об.СопутствующиеТовары.Очистить();
	
	Для Каждого Стр Из СопутствующиеТовары Цикл
		НовСтр = Об.СопутствующиеТовары.Добавить();
		НовСтр.Номенклатура = Стр.Номенклатура;
	КонецЦикла;	
	
	Об.Записать();
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru ='Для товара ""%1"" изменения в списке сопутствующих товаров сохранены'"),
			Строка(Ссылка)));
	
КонецПроцедуры	

&НаКлиенте
Процедура ПечатьЭтикетокИЦенников(Команда)
	
	ОткрытьФорму("Обработка.ПечатьЭтикетокИЦенников.Форма", , ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ТекДанные = Элемент.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда
		
		Если соотВидыНоменклатуры = Неопределено Тогда
			соотВидыНоменклатуры = СоотвВидыНоменклатуры();
		КонецЕсли; 
		
		Если мУчетнаяПолитика = Неопределено Тогда
			мУчетнаяПолитика = УправлениеНастройками.ПолучитьУчетнуюПолитику();
		КонецЕсли; 
		
		ОбновитьСписокСопутствующих();
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекДанные, "Наименование") Тогда
			
			КомментарийИмяПродолжительность = ТекДанные.Наименование;
			
			Если Не ТекДанные.ЭтоГруппа Тогда
				
				Если ТекДанные.видНоменклатуры = соотВидыНоменклатуры.Получить("Услуга") Тогда 
					
					текстКомментарий = "" + 
						?(Не ЗначениеЗаполнено(ТекДанные.ПродолжительностьЧас),"", " " + ТекДанные.ПродолжительностьЧас + " час") +
						?(Не ЗначениеЗаполнено(ТекДанные.ПродолжительностьМин),"", " " + ТекДанные.ПродолжительностьМин + " мин");
					КомментарийИмяПродолжительность = КомментарийИмяПродолжительность + текстКомментарий;
					
				ИначеЕсли  ТекДанные.видНоменклатуры = соотВидыНоменклатуры.Получить("Материал") Тогда
					
					// Покажем информацию в нижней панели.
					Если Элементы.ГруппаОстатки.Видимость Тогда
						// Если панель видна, то обновим.
						ОбновитьОстатки();
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		Иначе
			КомментарийИмяПродолжительность = "";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаКлиенте
Процедура ОбновитьОстатки()
	
	ЕдиницаИзмерения = ?(Элементы.Список.ТекущиеДанные = Неопределено, Неопределено, Элементы.Список.ТекущиеДанные.ЕдиницаХраненияОстатков);
	ТабличноеПолеОстатки.Параметры.УстановитьЗначениеПараметра("ЕдиницаИзмерения", ЕдиницаИзмерения);	
	ТабличноеПолеОстатки.Параметры.УстановитьЗначениеПараметра("Номенклатура",Элементы.Список.ТекущаяСтрока);	
	
КонецПроцедуры

&НаКлиенте
// Функция СШКНоменклатура.
//
// Параметры:
//  ДанныеНоменклатуры - Неопределено
//  СШК - Неопределено
//
// Возвращаемое значение:
//  Неопределено.
//
Функция СШКНоменклатура(ДанныеНоменклатуры, СШК) Экспорт
	
	Номенклатура = ДанныеНоменклатуры.Номенклатура;
	
	Элементы.Список.ТекущаяСтрока = Номенклатура;
	
	Возврат Истина;
	
КонецФункции // СШКНоменклатура()

// Функция осуществляет обработку считывания штрих-кода клиенты.
//
// Параметры:
//  Клиент	 - СправочникСсылка.Клиенты	 - клиент, штрих-код которой был отсканирован.
//  СШК		 - Строка	 - Идентификатор сканера штрих-кода, с которым связано данное событие.
// 
// Возвращаемое значение:
//	Булево.
//
&НаКлиенте
Функция СШККлиент(Клиент, СШК) Экспорт
	
	ОткрытьЗначение(Клиент);	
	
	Возврат Истина;
	
КонецФункции

// Функция осуществляет обработку считывания штрих-кода сотрудник.
//
// Параметры:
//  Клиент   - СправочникСсылка.Сотрудники
//                 - сотрудник, штрих-код которой был отсканирован.
//
//  СШК            - Строка
//                 - Идентификатор сканера штрих-кода, с которым связано данное
//                   событие.
//
// Возвращаемое значение:
//  Булево       - Данная ситуация обработана.
//
&НаКлиенте
Функция СШКСотрудник(Сотрудник, СШК) Экспорт
	
	ОткрытьЗначение(Сотрудник);
	
	Возврат Истина;
	
КонецФункции

// Функция осуществляет обработку считывания штрихового кода, который не был
//  зарегистрирован.
//
// Параметры:
//  Штрихкод - Строка										 - Считанный код.
//  ТипКода	 - ПланыВидовХарактеристикСсылка.ТипыШтрихкодов	 - Тип штрихкода. Пустая ссылка в случае, если тип определить не
//  	представляется возможным.
//  СШК		 - Строка	- Идентификатор сканера штрих-кода, с которым связано данное
//  										событие.
// 
// Возвращаемое значение:
//  Булево.
//
&НаКлиенте
Функция СШКНеизвестныйКод(Штрихкод, ТипКода, СШК) Экспорт
	
	ПоказатьПредупреждение(,НСтр("ru = 'Номенклатуры с указанным штрихкодом не существует!'"));
	Возврат Истина;
	
КонецФункции

&НаКлиенте
// Процедура ПодключитьОборудованиеЗавершение.
//
// Параметры:
//  РезультатВыполнения - Структура - описание результата.
//  Параметры - Произвольный - не используется
//
Процедура ПодключитьОборудованиеЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Если Не РезультатВыполнения.Результат Тогда
		ТекстСообщения = НСтр( "ru = 'При подключении оборудования произошла ошибка:
				|""%ОписаниеОшибки%"".'" );
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%" , РезультатВыполнения.ОписаниеОшибки);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокСопутствующих()
	
	Если мУчетнаяПолитика.ПоказыватьСопутствующиеТовары Тогда
		
		Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда Возврат; КонецЕсли;
		
		Если Элементы.Список.ТекущиеДанные.ВидНоменклатуры <> соотВидыНоменклатуры.Получить("Набор") Тогда
			СопутствующиеНовые = ПолучитьСписокСопутствующихСервер(Элементы.Список.ТекущаяСтрока);
			СопутствующиеТовары.Очистить();
			Для Каждого ОписаниеТовара Из СопутствующиеНовые Цикл
				ЗаполнитьЗначенияСвойств(СопутствующиеТовары.Добавить(), ОписаниеТовара);
			КонецЦикла;
		Иначе
			Элементы.ГруппаСопутствующиеТовары.Доступность = Ложь;
		КонецЕсли;	
		
	Иначе
		Элементы.ГруппаСопутствующиеТовары.Доступность = Ложь;	
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСписокСопутствующихСервер(Номенклатура)
	
	Сопутствующие = Новый Массив;
	
	Если УправлениеНастройками.ПолучитьПараметрУчетнойПолитики("ПоказыватьСопутствующиеТовары") Тогда
	
		Запрос = Новый Запрос;
		Запрос.Текст =                         
		"ВЫБРАТЬ
		|	НоменклатураСопутствующиеТовары.Номенклатура КАК Наименование,
		|	НоменклатураСопутствующиеТовары.Номенклатура.Код,
		|	НоменклатураСопутствующиеТовары.Номенклатура.Артикул,
		|	НоменклатураСопутствующиеТовары.Номенклатура.ВидНоменклатуры
		|ИЗ
		|	Справочник.Номенклатура.СопутствующиеТовары КАК НоменклатураСопутствующиеТовары
		|ГДЕ
		|	НоменклатураСопутствующиеТовары.Ссылка = &Номенклатура
		|	И НоменклатураСопутствующиеТовары.Номенклатура.ПометкаУдаления = ЛОЖЬ";
		
		Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
		Выб = Запрос.Выполнить().Выбрать();
		Пока Выб.Следующий() Цикл
			
			ОписаниеТовара = Новый Структура;
			ОписаниеТовара.Вставить("Код",				 Выб.НоменклатураКод);
			ОписаниеТовара.Вставить("Артикул",			 Выб.НоменклатураАртикул);
			ОписаниеТовара.Вставить("ВидНоменклатуры",	 Выб.НоменклатураВидНоменклатуры);
			ОписаниеТовара.Вставить("Номенклатура",		 Выб.Наименование);
			
			Сопутствующие.Добавить(ОписаниеТовара);
			
		КонецЦикла;
	КонецЕсли;
	
	Возврат Сопутствующие;
	
КонецФункции

#КонецОбласти
