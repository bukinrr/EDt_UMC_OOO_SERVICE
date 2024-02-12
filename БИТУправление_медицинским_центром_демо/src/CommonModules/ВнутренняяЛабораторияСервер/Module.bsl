#Область ПрограммныйИнтерфейс

// Вызывается при заполнении кеша НСИ всех подключенных лабораторий.
//
Процедура ЗаполнитьКэшНСИЛаборатории() Экспорт
	Возврат;
КонецПроцедуры

// Получение результатов анализов лаборатории из внешних источников.
//
// Параметры:
//  ТекстОшибки - Строка - текст ошибки получения.
//
Процедура ПолучитьРезультатыАнализов(ТекстОшибки) Экспорт
	Возврат;
КонецПроцедуры

// Отправяет опись заказов во внешнюю лабораторию.
//
// Параметры:
//  ОписьЗаказов - ДокументСсылка.ОписьЗаказовЛаборатории	 - опись заказов этой лаборатории.
// 
// Возвращаемое значение:
//  Булево, Массив.
//
Функция ОтправитьЗаказыПоОписиВоВнешнююЛабораторию(ОписьЗаказов) Экспорт
	Возврат Неопределено;
КонецФункции

// Параметры забора анализа, если правила забора используются лабораторией.
//
// Параметры:
//  Номенклатура - СправочникСсылка.Номенклатура - анализ.
//
// Возвращаемое значение:
//  Массив.
//
Функция ПолучитьПараметрыЗабора(Номенклатура) Экспорт
	Возврат Новый Массив;
КонецФункции

// Распределение биоматериалов по контейнерам.
//
// Параметры:
//  ДанныеЗабора - Структура
//
// Возвращаемое значение:
//  ДеревоЗначений.
//
Функция РаспределениеБиоматериаловПоКонтейнерам(ДанныеЗабора) Экспорт
	
	НастройкиУчетаЛабораторий = ЛабораторияСервер.НастройкиУчетаЛабораторий();
	ИспользуетсяРасширеннаяВнутренняяЛаборатория = НастройкиУчетаЛабораторий.ИспользуетсяРасширеннаяВнутренняяЛаборатория;
		
	ДеревоРезультатов = Новый ДеревоЗначений;
	ДеревоРезультатов.Колонки.Добавить("Лаборатория", Новый ОписаниеТипов("СправочникСсылка.Лаборатории"));
	ДеревоРезультатов.Колонки.Добавить("ЭтоКонтейнер", Новый ОписаниеТипов("Булево"));
	ДеревоРезультатов.Колонки.Добавить("НомерКонтейнера", Новый ОписаниеТипов("Число"));
	ДеревоРезультатов.Колонки.Добавить("КодПробы", Новый ОписаниеТипов("Строка"));
	ДеревоРезультатов.Колонки.Добавить("ИДПравила", Новый ОписаниеТипов("Число"));
	ДеревоРезультатов.Колонки.Добавить("КлючСтрокиИсследования", Новый ОписаниеТипов("Число"));
	ДеревоРезультатов.Колонки.Добавить("Биоматериал", Новый ОписаниеТипов("СправочникСсылка.ВнутренняяЛаборатория_Биоматериалы"));
	ДеревоРезультатов.Колонки.Добавить("БиоматериалПредставление", Новый ОписаниеТипов("Строка"));
	ДеревоРезультатов.Колонки.Добавить("Контейнер", Новый ОписаниеТипов("СправочникСсылка.ВнутренняяЛаборатория_ВидыКонтейнеров"));
	ДеревоРезультатов.Колонки.Добавить("КонтейнерПредставление", Новый ОписаниеТипов("Строка"));
	ДеревоРезультатов.Колонки.Добавить("ИдАнализа", Новый ОписаниеТипов("Строка"));
	ДеревоРезультатов.Колонки.Добавить("УсловияХранения", Новый ОписаниеТипов("Строка"));
	ДеревоРезультатов.Колонки.Добавить("УсловияТранспортировки", Новый ОписаниеТипов("Строка"));
	ДеревоРезультатов.Колонки.Добавить("ЦветКонтейнера", Новый ОписаниеТипов("Строка"));
	ДеревоРезультатов.Колонки.Добавить("ПредставлениеАнализа", Новый ОписаниеТипов("Строка"));
	
	Если Не ИспользуетсяРасширеннаяВнутренняяЛаборатория Тогда
		Возврат ДеревоРезультатов;
	КонецЕсли;
	
	// Временные колонки
	ДеревоРезультатов.Колонки.Добавить("ЗанятоВКонтейнере", Новый ОписаниеТипов("Число"));
	ДеревоРезультатов.Колонки.Добавить("ОбъемКонтейнера", Новый ОписаниеТипов("Число"));
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ВЫРАЗИТЬ(Исследования.Номенклатура КАК Справочник.Номенклатура) КАК Номенклатура,
	                      |	Исследования.КлючСтроки,
	                      |	Исследования.КодПробы КАК КодПробы,
	                      |	ВЫРАЗИТЬ(Исследования.Лаборатория КАК Справочник.Лаборатории) КАК Лаборатория
	                      |ПОМЕСТИТЬ Исследования
	                      |ИЗ
	                      |	&Исследования КАК Исследования
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ИсследованияЗабора.Номенклатура,
	                      |	ИсследованияЗабора.КлючСтроки КАК КлючСтрокиИсследования,
	                      |	ИсследованияЗабора.ПредставлениеАнализа,
	                      |	ВнутренняяЛаборатория_СопоставлениеНоменклатуры.Контейнер,
	                      |	ВнутренняяЛаборатория_СопоставлениеНоменклатуры.Биоматериал,
	                      |	ВнутренняяЛаборатория_СопоставлениеНоменклатуры.НеобходимыйОбъем КАК НеобходимыйОбъемБиоматериала,
	                      |	ВнутренняяЛаборатория_СопоставлениеНоменклатуры.Контейнер.Объем КАК ОбъемКонтейнера,
	                      |	ИсследованияЗабора.КодПробы,
	                      |	ИсследованияЗабора.Лаборатория,
	                      |	ВнутренняяЛаборатория_СопоставлениеНоменклатуры.Биоматериал.Наименование КАК БиоматериалПредставление,
	                      |	ВнутренняяЛаборатория_СопоставлениеНоменклатуры.Контейнер.Наименование КАК КонтейнерПредставление,
	                      |	ИсследованияЗабора.Артикул КАК Артикул
	                      |ИЗ
	                      |	(ВЫБРАТЬ
	                      |		Исследования.Номенклатура КАК Номенклатура,
	                      |		Исследования.КлючСтроки КАК КлючСтроки,
	                      |		ПРЕДСТАВЛЕНИЕ(Исследования.Номенклатура) КАК ПредставлениеАнализа,
	                      |		Исследования.Номенклатура.Артикул КАК Артикул,
	                      |		Исследования.КодПробы КАК КодПробы,
	                      |		Исследования.Лаборатория КАК Лаборатория
	                      |	ИЗ
	                      |		Исследования КАК Исследования
	                      |	ГДЕ
	                      |		Исследования.Лаборатория.ВнешняяЛаборатория = ЗНАЧЕНИЕ(Перечисление.ВнешниеЛаборатории.ПустаяСсылка)) КАК ИсследованияЗабора
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ВнутренняяЛаборатория_СопоставлениеНоменклатуры КАК ВнутренняяЛаборатория_СопоставлениеНоменклатуры
	                      |		ПО ИсследованияЗабора.Номенклатура = ВнутренняяЛаборатория_СопоставлениеНоменклатуры.Номенклатура");
	
	Запрос.УстановитьПараметр("Исследования", ДанныеЗабора.Исследования);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		СтрокаЛаборатории = ДеревоРезультатов.Строки.Найти(Выборка.Лаборатория, "Лаборатория");
		Если СтрокаЛаборатории = Неопределено Тогда
			СтрокаЛаборатории = ДеревоРезультатов.Строки.Добавить();
			СтрокаЛаборатории.Лаборатория = Выборка.Лаборатория;
		КонецЕсли;
		
		НеобходимыйОбъемБиоматериала = Макс(Выборка.НеобходимыйОбъемБиоматериала, 0.001);
		
		ПоляПробы = Новый Структура;
		ПоляПробы.Вставить("КлючСтрокиИсследования",	Выборка.КлючСтрокиИсследования);
		ПоляПробы.Вставить("БиоматериалПредставление",	Выборка.БиоматериалПредставление);
		ПоляПробы.Вставить("ИдАнализа",					Выборка.Артикул);
		ПоляПробы.Вставить("ПредставлениеАнализа",		Выборка.ПредставлениеАнализа);
		
		// Ищем такой же контейнер
		СтрокаКонтейнера = Неопределено;
		Для Каждого СтарыйКонтейнер Из СтрокаЛаборатории.Строки Цикл
			
			Если СтарыйКонтейнер.Контейнер = Выборка.Контейнер
				И СтарыйКонтейнер.Биоматериал = Выборка.Биоматериал
				// Здесь может быть добавлена несовмеситмость групп анализов внутри одного контейнера,
				// если будет реализована НСИ групп совместимости биоматериалов анализов.
				И СтарыйКонтейнер.ОбъемКонтейнера > СтарыйКонтейнер.ЗанятоВКонтейнере
			Тогда
			    ЗанятьВКонтейнере = Мин(НеобходимыйОбъемБиоматериала, СтарыйКонтейнер.ОбъемКонтейнера - СтарыйКонтейнер.ЗанятоВКонтейнере);
				
				// Добавляем пробу в контейнер.
				СтрокаБиоматериала = СтарыйКонтейнер.Строки.Добавить();
				СтрокаБиоматериала.НомерКонтейнера = СтарыйКонтейнер.НомерКонтейнера;
				ЗаполнитьЗначенияСвойств(СтрокаБиоматериала, ПоляПробы);
				
			    НеобходимыйОбъемБиоматериала = НеобходимыйОбъемБиоматериала - ЗанятьВКонтейнере;
				СтарыйКонтейнер.ЗанятоВКонтейнере = СтарыйКонтейнер.ЗанятоВКонтейнере + ЗанятьВКонтейнере;
			КонецЕсли;
		КонецЦикла;
		
		// Если всё распределили по старым контейнерам, новый не добавляем.
		Если НеобходимыйОбъемБиоматериала = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ОбъемКонтейнера = ?(Выборка.ОбъемКонтейнера <> 0, Выборка.ОбъемКонтейнера, 1000000);
		
		Пока НеобходимыйОбъемБиоматериала > 0 Цикл
			
			// Добавляем контейнер
			СтрокаКонтейнера = СтрокаЛаборатории.Строки.Добавить();
			СтрокаКонтейнера.ЭтоКонтейнер	= Истина;
			СтрокаКонтейнера.НомерКонтейнера= СтрокаЛаборатории.Строки.Количество();
			СтрокаКонтейнера.КодПробы		= Выборка.КодПробы;
			
			СтрокаКонтейнера.ОбъемКонтейнера		= ОбъемКонтейнера;
			СтрокаКонтейнера.ЗанятоВКонтейнере		= Мин(НеобходимыйОбъемБиоматериала, СтрокаКонтейнера.ОбъемКонтейнера);
			СтрокаКонтейнера.Контейнер				= Выборка.Контейнер;
			СтрокаКонтейнера.КонтейнерПредставление	= Выборка.КонтейнерПредставление;
			СтрокаКонтейнера.Биоматериал			= Выборка.Биоматериал;
			СтрокаКонтейнера.БиоматериалПредставление = Выборка.БиоматериалПредставление;
			
			НеобходимыйОбъемБиоматериала = НеобходимыйОбъемБиоматериала - СтрокаКонтейнера.ЗанятоВКонтейнере;
			
			// Добавляем пробу в контейнер.
			СтрокаБиоматериала = СтрокаКонтейнера.Строки.Добавить();
			СтрокаБиоматериала.НомерКонтейнера = СтрокаКонтейнера.НомерКонтейнера;
			ЗаполнитьЗначенияСвойств(СтрокаБиоматериала, ПоляПробы);
			
		КонецЦикла;
	КонецЦикла;
	
	ДеревоРезультатов.Колонки.Удалить("ЗанятоВКонтейнере");
	ДеревоРезультатов.Колонки.Удалить("ОбъемКонтейнера");
	
	Возврат ДеревоРезультатов;
		
КонецФункции

// Проверить заполнение забора анализа.
//
// Параметры:
//  ДокументОбъект - ДокументСсылка.ДействиеНадАнализами.
//  Лаборатория - СправочникСсылка.Лаборатории.
//  Отказ - Булево
//
Процедура ПроверитьЗаполнениеЗабораАнализа(ДокументОбъект, Лаборатория, Отказ) Экспорт
КонецПроцедуры

// Проверка корректности кодов проб.
//
// Параметры:
//  КодыПроб - Массив - массив строк с кодами проб.
//  ПроверятьПустые - Булево - проверять ли корректность пустых кодов проб.
//
// Возвращаемое значение:
//  Строка.
//
Функция ПроверитьКорректностьКодовПроб(КодыПроб, Знач ПроверятьПустые) Экспорт
	
	СообщениеОбОшибке = "";
	
	Если ПроверятьПустые = Неопределено Тогда
		ПроверятьПустые = Ложь;
	КонецЕсли;
	
	ПредставлениеЛаборатории = Строка(Перечисления.ВнешниеЛаборатории.Helix);
	
	Для Сч = 1 По КодыПроб.Количество() Цикл
		
		КодПробы = КодыПроб[Сч - 1];
		
		ТекстОшибки = "";
		Если Не КодПробыКорректен(КодПробы, ПроверятьПустые, ТекстОшибки) Тогда
			ОбщегоНазначенияКлиентСервер.КонкатенацияСтрок(СообщениеОбОшибке,
				ЛабораторияСервер.СформироватьТекстОшибкиКодаПробы(Сч, ТекстОшибки, ПредставлениеЛаборатории),
				Символы.ПС);
		КонецЕсли;
		
	КонецЦикла;
		
	Возврат СообщениеОбОшибке;
		
КонецФункции

// Возвращает Истина, если код пробы (штрихкод образца) корректен
//
// Параметры:
//  КодПробы		 - Строка	 - код пробы.
//  ПроверятьПустые	 - Булево	 - По умолчанию Ложь.
//  ТекстОшибки		 - Строка	 - По умолчанию "".
// 
// Возвращаемое значение:
//  Булево.
//
Функция КодПробыКорректен(КодПробы, ПроверятьПустые = Ложь, ТекстОшибки = "") Экспорт
	
	Результат = Истина;
	
	Если ПроверятьПустые
		И ПустаяСтрока(КодПробы)
	Тогда
		Результат = Ложь;
		ТекстОшибки = ЛабораторияСервер.ТекстОшибкиПустойКодПробы();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Проверка корректности кода пробы с описанием ошибки.
//
// Параметры:
//  КодПробы	 - Строка	 - код пробы.
//  ТекстОшибки	 - Строка	 - текст ошибки.
// 
// Возвращаемое значение:
//  Булево.
//
Функция КодПробыКорректенДляЗаказа(КодПробы, ТекстОшибки = "") Экспорт
	
	Возврат КодПробыКорректен(КодПробы, ТекстОшибки, Ложь);
	
КонецФункции

Функция ИспользуетсяПечатьЭтикеток() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает структуру данных для печати этикеток лаборатории Внутренней лаборатории.
//
// Параметры:
//  ДанныеКонтейнеров	 - ДанныеФормыКоллекция	 		- данные табличной части "Контейнеры" формы документа "Действия над анализами".
//  Лаборатория			 - СправочникСсылка.Лаборатории - лаборатория, для которой печатаются этикетки.
//  Клиент				 - СправочникСсылка.Клиенты	 	- клиент, данные которого выводятся на этикетки.
//  ОписаниеОшибки		 - Строка - текст ошибок, полученных при печати этикеток. 
// 
// Возвращаемое значение:
//   - Структура:
//   	* Заголовок 		- Строка
//   	* Защита 			- Булево
//   	* ИмяМакета 		- Строка
//   	* ОбъектПечати 		- Неопределено
//   	* ПечДокумент 		- ТабличныйДокумент
//   	* ПолныйПутьКМакету - Строка
//   	* СинонимМакета 	- Строка
//   	* ФормаИмя 			- Строка
//
Функция ПолучитьСтруктуруПечатиЭтикеток(Знач ДанныеКонтейнеров, Лаборатория, ДокументСсылка, Клиент, ОписаниеОшибки = "") Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВнешняяКомпонента = ГенерацияШтрихкодаСерверПовтИсп.ПодключитьКомпонентуГенерацииИзображенияШтрихкода("");
	
	Если ВнешняяКомпонента = Неопределено Тогда 
		ОбщегоНазначенияКлиентСервер.КонкатенацияСтрок(ОписаниеОшибки,
			НСтр("ru = 'Ошибка подключения внешней компоненты печати штрихкода!'"), Символы.ПС);
		Возврат Неопределено;
	КонецЕсли;	
	
	Таб = Новый ТабличныйДокумент;	
	
	// Выведем таблицу на экран.
	Таб.АвтоМасштаб = Истина;
	Таб.КлючПараметровПечати = "ЭтикеткаОбразца_ВнутренняяЛаборатория";
	Таб.ОтображатьГруппировки = Ложь;
	Таб.ОтображатьЗаголовки   = Ложь;
	Таб.ОтображатьСетку       = Ложь;
	Таб.ПолеСверху = 0;
	Таб.ПолеСнизу  = 0;
	Таб.ПолеСправа = 0;
	Таб.ПолеСлева  = 0;	
	
	МассивКодыПроб = Новый Массив;
	
	Эталон = Обработки.ПечатьЭтикетокИЦенников.ПолучитьМакет("Эталон");
	КоличествоМиллиметровВПикселе = Эталон.Рисунки.Квадрат100Пикселей.Высота / 100;
	
	ПараметрыОтбора = Новый Структура("Лаборатория", Лаборатория);
	КонтейнерыЛаборатории = ДанныеКонтейнеров.НайтиСтроки(ПараметрыОтбора);
	
	Для Каждого Контейнер Из КонтейнерыЛаборатории Цикл 				
		
		КодШтрихкода = Контейнер.КодПробы;
		
		Если ПустаяСтрока(КодШтрихкода) Тогда
			Продолжить;	
		КонецЕсли;
		
		Если МассивКодыПроб.Найти(КодШтрихкода) <> Неопределено Тогда 
			Продолжить;
		КонецЕсли;
		
		Область = ПолучитьОбластьПечатиЭтикеток(КодШтрихкода, Клиент, Контейнер.КонтейнерПредставление, Лаборатория);		
		ТипКода = Штрихкодирование.ПолучитьЗначениеТипаШтрихкодаДляЭУ(ПланыВидовХарактеристик.ТипыШтрихкодов.CODE128);
				
		Для Каждого Рисунок Из Область.Рисунки Цикл
			Если Лев(Рисунок.Имя, 8) = Штрихкодирование.ПолучитьИмяПараметраШтрихкод() Тогда
				
				Если ВнешняяКомпонента = Неопределено Тогда
					Продолжить;
				КонецЕсли;
				
				ПараметрыШтрихкода = Новый Структура;

				ПараметрыШтрихкода.Вставить("Ширина",          Окр(Рисунок.Ширина / КоличествоМиллиметровВПикселе));
				ПараметрыШтрихкода.Вставить("Высота",          Окр(Рисунок.Высота / КоличествоМиллиметровВПикселе));
				ПараметрыШтрихкода.Вставить("Штрихкод",        КодШтрихкода);
				ПараметрыШтрихкода.Вставить("ТипКода",         ?(ТипКода >= 0, ТипКода, 1));
				ПараметрыШтрихкода.Вставить("ОтображатьТекст", Истина);
				ПараметрыШтрихкода.Вставить("РазмерШрифта",    10);			
				Рисунок.Картинка = Штрихкодирование.ПолучитьКартинкуШтрихкода(ВнешняяКомпонента, ПараметрыШтрихкода);			
			КонецЕсли;
		КонецЦикла;		
		Таб.ВывестиГоризонтальныйРазделительСтраниц();
		Таб.Вывести(Область);
		
		МассивКодыПроб.Добавить(КодШтрихкода);
		
	КонецЦикла;
	
	Возврат УниверсальныеМеханизмыСервер.НапечататьДокумент(Таб, 1,, "Этикетки");
	
КонецФункции

Функция ПолучитьОбластьПечатиЭтикеток(КодШтрихкода, Клиент, Контейнер, Лаборатория)
	
	МакетТабДокумента = ПолучитьОбщийМакет("ВнутренниеЛаборатории_МакетЭтикетки");
	Область = МакетТабДокумента.ПолучитьОбласть("Этикетка");
	
	ФИОКлиента = ВРег(Клиент.Фамилия + " " + Клиент.Имя);
	
	Область.Параметры.Установить(0, Лаборатория);
	Область.Параметры.Установить(1, Контейнер);
	Область.Параметры.Установить(2, ФИОКлиента);
		
	// Форматируем документ согласно устройству печати.	
	РазмерЭтикетки = 50;
	ШиринаЭтикетки = Число(Лев(РазмерЭтикетки, 3));
	ВысотаЭтикетки = Число(Прав(РазмерЭтикетки,3));
	
	Если ШиринаЭтикетки = Неопределено Тогда ШиринаЭтикетки = 20 КонецЕсли;
	
	// Настройка размера.
	// 1. Высота.
	Если ВысотаЭтикетки <> 0 Тогда
		
		ОбщаяВысота = 0;
		КоэфВысоты  = 1.3;
		
		Для сч = 1 По Область.Высотатаблицы Цикл
			ТекОбласть = Область.Область(сч,, сч);
			ОбщаяВысота = ОбщаяВысота + ТекОбласть.ВысотаСтроки;
		КонецЦикла;
		
		Если ОбщаяВысота = 0 Тогда
			ОбщаяВысота = 1;
		КонецЕсли;
		
		Для сч = 1 По Область.Высотатаблицы Цикл
			ТекОбласть = Область.Область(сч,, сч);
			ТекОбласть.ВысотаСтроки = ТекОбласть.ВысотаСтроки/ОбщаяВысота * ВысотаЭтикетки * КоэфВысоты;	
		КонецЦикла;
		
	КонецЕсли;	
	
	// 2. Ширина.
	Если ШиринаЭтикетки <> 0 Тогда
		
		ОбщаяШирина = 0;
		Коэф		= 0.55;
		
		Для сч = 1 По Область.ШиринаТаблицы Цикл
			ТекОбласть = Область.Область(, сч,, сч);
			ОбщаяШирина = ОбщаяШирина + ?(ТекОбласть.ШиринаКолонки = 0, 1, ТекОбласть.ШиринаКолонки);
		КонецЦикла;
		
		Для сч = 1 По Область.ШиринаТаблицы Цикл
			ТекОбласть = Область.Область(, сч,, сч);
			ТекОбласть.ШиринаКолонки = ТекОбласть.ШиринаКолонки/ОбщаяШирина * ШиринаЭтикетки * Коэф;
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Область;
	
КонецФункции

Функция ИспользуютсяПулыНомеровЗаявокЛабораторий(Лаборатория) Экспорт
	
	Возврат ЛабораторияСервер.ЕстьДоступныеПулыНомеров(Лаборатория);
	
КонецФункции

Функция ЛимитПуловНомеровЗаявок() Экспорт
	Возврат 3;
КонецФункции

Процедура ПолучитьНовыеНомераЗаявок(МассивКодыПробПустые, МассивДиапазонов) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МассивИдентификаторы = Новый Массив;
	
	Лаборатория = Справочники.Лаборатории.ПустаяСсылка();
	
	Для Каждого СтрокаКодыПробПустые Из МассивКодыПробПустые Цикл
		МассивИдентификаторы.Добавить(СтрокаКодыПробПустые.БиоМатериал);
		Если Не ЗначениеЗаполнено(Лаборатория) Тогда
			Лаборатория = СтрокаКодыПробПустые.Лаборатория;
		КонецЕсли;
	КонецЦикла;			
	Если МассивКодыПробПустые.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	Итератор = 0;
	Для Каждого ЭлементДиапазон Из МассивДиапазонов Цикл
		
		Пока Итератор < МассивКодыПробПустые.Количество() Цикл 
			
			Если Не ЭлементДиапазон.Закрыт Тогда
				Если ЭлементДиапазон.ТекущийНомер < ЭлементДиапазон.НачалоДиапазона Тогда  
					НовыйТекущийНомер = ЭлементДиапазон.НачалоДиапазона;
				Иначе 
					НовыйТекущийНомер = ЭлементДиапазон.ТекущийНомер + 1;
				КонецЕсли;
				//Если НовыйТекущийНомер >= ЭлементДиапазон.ОкончаниеДиапазона Тогда
				//	ЭлементДиапазон.Закрыт = Истина;
					Если НовыйТекущийНомер > ЭлементДиапазон.ОкончаниеДиапазона Тогда 
						НовыйТекущийНомер = ЭлементДиапазон.НачалоДиапазона;	
					КонецЕсли;
				//КонецЕсли;		
				ЭлементДиапазон.ТекущийНомер = НовыйТекущийНомер;			
				МассивКодыПробПустые[Итератор].КодПробы = Формат(НовыйТекущийНомер, "ЧГ=0");
				МассивКодыПробПустые[Итератор].Учтен = Истина;
				Итератор = Итератор + 1;
			Иначе
				Прервать;	
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти