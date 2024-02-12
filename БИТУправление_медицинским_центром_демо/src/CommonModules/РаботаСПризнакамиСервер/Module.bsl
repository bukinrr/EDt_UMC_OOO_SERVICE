#Область ПрограммныйИнтерфейс

// Пересчитывает значения признаков
// НомерПоследнейГруппыОбъектов - Тип:Число(1)
// ИзменившийсяПризнак - Тип: ДокументСсылка.ПризнакиДляОтслеживания.
Процедура АлгоритмОбработки(НомерПоследнейГруппыОбъектов = 2, ИзменившийсяПризнак = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);	
	
	Признаки = ПолучитьСписокПризнаковДляРасчета(ИзменившийсяПризнак);
	Если Признаки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	КоличествоОшибок = 0;
	
	// Настройки по датам для групп Заявок из Альфа 1 и Альфа 2
	ЛеваяГраницаАктуальностиЗаявок = ?(Справочники.КонфигурированиеЯчеекКалендаря.ОсновнаяНастройка.ЛеваяГраницаАктуальностиЗаявок = 0, 2, Справочники.КонфигурированиеЯчеекКалендаря.ОсновнаяНастройка.ЛеваяГраницаАктуальностиЗаявок);  
	ПраваяГраницаАктуальностиЗаявок = ?(Справочники.КонфигурированиеЯчеекКалендаря.ОсновнаяНастройка.ПраваяГраницаАктуальностиЗаявок = 0, 2, Справочники.КонфигурированиеЯчеекКалендаря.ОсновнаяНастройка.ПраваяГраницаАктуальностиЗаявок);  
	
	ОграничениеСлева	= НачалоДня(ТекущаяДатаСеанса() - ПраваяГраницаАктуальностиЗаявок * 86400);
	ОграничениеСправа	= НачалоДня(ТекущаяДатаСеанса() + ЛеваяГраницаАктуальностиЗаявок * 86400);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Заявка.Клиент КАК Клиент,
		|	Заявка.Ссылка КАК Заявка,
		|	1 КАК Приоритет,
		|	Заявка.ДатаНачала КАК ДатаНачала
		|ИЗ
		|	Документ.Заявка КАК Заявка
		|ГДЕ
		|	НЕ Заявка.ПометкаУдаления
		|	И Заявка.ДатаНачала >= &НачалоДня
		|	И Заявка.ДатаНачала <= &ОграничениеСправа
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Заявка.Клиент,
		|	Заявка.Ссылка,
		|	2,
		|	Заявка.ДатаНачала
		|ИЗ
		|	Документ.Заявка КАК Заявка
		|ГДЕ
		|	НЕ Заявка.ПометкаУдаления
		|	И Заявка.ДатаНачала < &НачалоДня
		|	И Заявка.ДатаНачала >= &ОграничениеСлева
		|
		|УПОРЯДОЧИТЬ ПО
		|	Приоритет,
		|	ДатаНачала";
	Запрос.УстановитьПараметр("НачалоДня", НачалоДня(ТекущаяДатаСеанса()));
	Запрос.УстановитьПараметр("ОграничениеСлева", ОграничениеСлева);
	Запрос.УстановитьПараметр("ОграничениеСправа", ОграничениеСправа);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	КешМакетовСКД = Новый Структура;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		// Условие частичной обработки объектов
		Если ВыборкаДетальныеЗаписи.Приоритет > НомерПоследнейГруппыОбъектов Тогда
			Прервать;
		КонецЕсли;
		ОбновитьПризнакиПоСсылке(Признаки, ВыборкаДетальныеЗаписи, КоличествоОшибок, КешМакетовСКД);
	КонецЦикла;
	
	Если КоличествоОшибок > 0 Тогда
		ЗаписьЖурналаРегистрации("Ошибка расчета ДПР", УровеньЖурналаРегистрации.Ошибка,,, "При расчете значений признаков дополнительных реквизитов календаря планирования было зарегистрировано " + КоличествоОшибок + " ошибок. Проверьте исполняемый код признаков.");
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
КонецПроцедуры

// Сохраняет значения признаков
// ЗначенияПризнаков - Тип: Булево
// КлючевойОбъект1 - Тип: ДокументСсылка.Заявка
// КлючевойОбъект2 - Тип: СправочникСсылка.Клиенты.
Процедура СохранитьЗначенияПризнакаКлючевогоОбъекта(ЗначенияПризнаков, КлючевойОбъект1, КлючевойОбъект2) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ЗначениеЗаполнено(КлючевойОбъект1) Тогда
		РПКО1 = РегистрыСведений.ПризнакиКлючевыхОбъектов.СоздатьНаборЗаписей();
		РПКО1.Отбор.КлючевойОбъект.Установить(КлючевойОбъект1);
		РПКО1.Прочитать();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КлючевойОбъект2) Тогда	
		РПКО2 = РегистрыСведений.ПризнакиКлючевыхОбъектов.СоздатьНаборЗаписей();
		РПКО2.Отбор.КлючевойОбъект.Установить(КлючевойОбъект2);
		РПКО2.Прочитать();
	КонецЕсли;
		
	Для Каждого СтрокаПризнака Из ЗначенияПризнаков Цикл
		Если СтрокаПризнака.Значение <> Неопределено Тогда
			ЗаписьРПКО = Неопределено;
			Если КлючевойОбъект1 = СтрокаПризнака.КлючевойОбъект Тогда
				Для Каждого ЗаписьНабора Из РПКО1 Цикл
					Если ЗаписьНабора.Признак = СтрокаПризнака.Признак Тогда
						ЗаписьРПКО = ЗаписьНабора;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				Если ЗаписьРПКО = Неопределено Тогда
					ЗаписьРПКО = РПКО1.Добавить();
				КонецЕсли;
			ИначеЕсли КлючевойОбъект2 = СтрокаПризнака.КлючевойОбъект Тогда
				Для Каждого ЗаписьНабора Из РПКО2 Цикл
					Если ЗаписьНабора.Признак = СтрокаПризнака.Признак Тогда
						ЗаписьРПКО = ЗаписьНабора;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				Если ЗаписьРПКО = Неопределено Тогда
					ЗаписьРПКО = РПКО2.Добавить();
				КонецЕсли;
			КонецЕсли;
			ЗаписьРПКО.КлючевойОбъект		= СтрокаПризнака.КлючевойОбъект;
			ЗаписьРПКО.Признак				= СтрокаПризнака.Признак;
			Если ТипЗнч(СтрокаПризнака.Значение) = Тип("Строка") Тогда
				ЗаписьРПКО.ЗначениеПризнака = СтрокаПризнака.Значение;
				ЗаписьРПКО.ЗначениеПризнакаХранилище = Неопределено;
			Иначе
				ЗаписьРПКО.ЗначениеПризнака = "";
				ЗаписьРПКО.ЗначениеПризнакаХранилище = Новый ХранилищеЗначения(СтрокаПризнака.Значение);
			КонецЕсли;
			ЗаписьРПКО.ДатаВремяИзменения	= ТекущаяДатаСеанса();
		КонецЕсли;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(КлючевойОбъект1) Тогда	
		РПКО1.Записать(Истина);
	КонецЕсли;
	Если ЗначениеЗаполнено(КлючевойОбъект2) Тогда
		РПКО2.Записать(Истина);
	КонецЕсли;
	
КонецПроцедуры

// Возвращает таблицу активных признаков вместе с исполняемым кодом и видом признака
// ИзменившийсяПризнак - Тип: СправочникСсылка.ПризнакиДляОтслеживания
// Возвращаемое значение - Тип: ТаблицаЗначений.
Функция ПолучитьСписокПризнаковДляРасчета(ИзменившийсяПризнак = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПризнакиДляОтслеживания.Ссылка,
	|	ПризнакиДляОтслеживания.УсловиеПрименения КАК ИсполняемыйКод,
	|	ПризнакиДляОтслеживания.ВидПризнака,
	|	ПризнакиДляОтслеживания.ФорматУсловия,
	|	ПризнакиДляОтслеживания.ЗначениеПоУмолчанию,
	|	ПризнакиДляОтслеживания.Отборы.(
	|		НомерСтроки,
	|		Отбор,
	|		Результат
	|	)
	|ИЗ
	|	Справочник.ЯчейкиКалендаря КАК ПризнакиДляОтслеживания
	|ГДЕ
	|	НЕ ПризнакиДляОтслеживания.ПометкаУдаления
	|	И НЕ ПризнакиДляОтслеживания.Предопределенный
	|	И (&ИспользоватьОтборПоСсылке
	|			ИЛИ ПризнакиДляОтслеживания.Ссылка = &ИзменившийсяПризнак)
	|	И НЕ РассчитыватьОнлайн
	|";
	Запрос.УстановитьПараметр("ИзменившийсяПризнак", ИзменившийсяПризнак);
	Запрос.УстановитьПараметр("ИспользоватьОтборПоСсылке", ИзменившийсяПризнак = Неопределено);
	
	Возврат  Запрос.Выполнить().Выгрузить();
	
КонецФункции

// Вычислить признак объекта для журнала записи по произвольному коду
//
// Параметры:
//  ИсполняемыйКод	 - Строка - Код на языке 1С.
//  КлючевойОбъект	 - СправочникСсылка.Клиенты, ДокументСсылка.Заявка - Контекст расчета.
// 
// Возвращаемое значение:
//   Строка, Цвет, Картинка.
//
Функция ВычислитьПризнакПоПроизвольномуКоду(ИсполняемыйКод, Знач КлючевойОбъект, Параметры = Неопределено)
	
	Результат = Неопределено;
	Объект = КлючевойОбъект;
	
	Попытка	
		Выполнить (ИсполняемыйКод);
	Исключение
		Ошибка = ИнформацияОбОшибке();
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Обновляет значения признаков по выбранному варианту алгоритма
// ВыбранныйВариант	- Тип: Число(1)
// Признак			- Тип: СправочникСсылка.ПризнакиДляОтслеживания.
Процедура ОбновлениеРПКОПослеЗаписиПризнака(ВыбранныйВариант = 0, Признак) Экспорт
	
	// Не обновлять таблицу рассчитанных признаков ключевых объектов
	Если ВыбранныйВариант = 0 Тогда
	// Обновить таблицу рассчитанных ключевых объектов синхронно	
	ИначеЕсли ВыбранныйВариант = 1 Тогда
		АлгоритмОбработки(2, Признак);
	// Обновить таблицу рассчитанных ключевых объектов асинхронно (фоновым заданием)
	ИначеЕсли ВыбранныйВариант = 2 Тогда
		ПараметрыФЗ = Новый Массив();
		ПараметрыФЗ.Добавить(2);
		ПараметрыФЗ.Добавить(Признак);
		ФоновыеЗадания.Выполнить("РаботаСПризнакамиСервер.АлгоритмОбработки", ПараметрыФЗ, Новый УникальныйИдентификатор, "ОбновлениеРКПО");
	// Обновить таблицу рассчитанных ключевых объектов только по свежим ключевым объектам синхронно	
	ИначеЕсли ВыбранныйВариант = 3 Тогда
		АлгоритмОбработки(1, Признак);
	// Обновить таблицу рассчитанных ключевых объектов только по свежим ключевым объектам асинхронно 	
	ИначеЕсли ВыбранныйВариант = 4 Тогда
		ПараметрыФЗ = Новый Массив();
		ПараметрыФЗ.Добавить(1);
		ПараметрыФЗ.Добавить(Признак);
		ФоновыеЗадания.Выполнить("РаботаСПризнакамиСервер.АлгоритмОбработки", ПараметрыФЗ, Новый УникальныйИдентификатор, "ОбновлениеРКПО");	
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьПризнакиПоИсточнику(Источник, Отказ = Ложь) Экспорт
	
	Если Не Отказ Тогда
		// Подготовим необходимые параметры для расчета признаков
		Признаки = ПолучитьСписокПризнаковДляРасчета();
		Если Признаки.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		КоличествоОшибок = 0;
		СтруктураОбъектов = Новый Структура("Заявка, Клиент");
		Если ТипЗнч(Источник) = Тип("ДокументОбъект.Заявка") Или ТипЗнч(Источник) = Тип("ДокументСсылка.Заявка") Тогда
			СтруктураОбъектов.Заявка = Источник.Ссылка;
			СтруктураОбъектов.Клиент = Источник.Клиент;
		ИначеЕсли ТипЗнч(Источник) = Тип("СправочникОбъект.Клиенты") Или ТипЗнч(Источник) = Тип("СправочникСсылка.Клиенты") Тогда
			СтруктураОбъектов.Клиент = Источник.Ссылка;
		КонецЕсли;
		
		Если (ТипЗнч(Источник) = Тип("СправочникОбъект.Клиенты") Или ТипЗнч(Источник) = Тип("ДокументОбъект.Заявка"))
			И Источник.ДополнительныеСвойства.Свойство("ЗаписьИзФормы") И Источник.ДополнительныеСвойства.ЗаписьИзФормы
		Тогда
			Возврат; // Избавимся от двойного расчета значений признаков в случае записи из формы объекта
		КонецЕсли;
		
		// Вычисление значений признаков по ссылке на Заявку/КлиентаЗаявки	
		ОбновитьПризнакиПоСсылке(Признаки, СтруктураОбъектов, КоличествоОшибок);
		Если КоличествоОшибок > 0 Тогда
			ЗаписьЖурналаРегистрации("Ошибка расчета ДПР", УровеньЖурналаРегистрации.Ошибка,,, "При расчете значений признаков дополнительных реквизитов календаря планирования было зарегистрировано " + КоличествоОшибок + " ошибок. Проверьте исполняемый код признаков.");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция РассчитатьПризнакПоОтборамСКД(Отборы, ЗначениеПоУмолчанию, КлючевойОбъект, ДанныеОнлайнРасчета = Неопределено, ДопСвойства = Неопределено, КешМакетовСКД = Неопределено) Экспорт
	
	Результат = Новый Массив;
	
	Попытка
		
		ТипКлючевогоОбъекта = ?(ТипЗнч(КлючевойОбъект)=Тип("Массив"), ?(КлючевойОбъект.Количество()>0, ТипЗнч(КлючевойОбъект[0]), Неопределено), ТипЗнч(КлючевойОбъект));
		
		Если ТипКлючевогоОбъекта = Тип("СправочникСсылка.Клиенты") Тогда
			
			ИмяПоляОбъекта = "Клиент";
			ЭтоКлиент = Истина;
			Если ДанныеОнлайнРасчета = Неопределено Тогда
				ИмяМакета = "МакетОтбораКлиенты";
			Иначе
				ИмяМакета = "МакетОтбораКлиентыОнлайнВычисление";
			КонецЕсли;
			
		ИначеЕсли ТипКлючевогоОбъекта = Тип("ДокументСсылка.Заявка") Тогда
			
			ИмяПоляОбъекта = "Заявка";
			ЭтоКлиент = Ложь;
			Если ДанныеОнлайнРасчета = Неопределено Тогда
				ИмяМакета = "МакетОтбораЗаявки";
			Иначе
				ИмяМакета = "МакетОтбораЗаявкиОнлайнВычисление";
			КонецЕсли;
		Иначе
			Возврат Результат;
		КонецЕсли;
		
		// Если происходит циклический вызов расчета, то схему СКД берем из кеша макетов справочника.
		Если ТипЗнч(КешМакетовСКД) = Тип("Структура")
			И КешМакетовСКД.Свойство(ИмяМакета)
		Тогда
			СхемаКомпоновкиДанных = КешМакетовСКД[ИмяМакета];
		Иначе
			СхемаКомпоновкиДанных = Справочники.ЯчейкиКалендаря.ПолучитьМакет(ИмяМакета);
			Если ИмяМакета = "МакетОтбораЗаявкиОнлайнВычисление" Тогда
				СхемаКомпоновкиДанных = ДобавитьПоляДопСвойств(СхемаКомпоновкиДанных, ДопСвойства);
			КонецЕсли;
			
			Если ТипЗнч(КешМакетовСКД) = Тип("Структура") Тогда
				КешМакетовСКД.Вставить(ИмяМакета, СхемаКомпоновкиДанных);
			КонецЕсли;
		КонецЕсли;
		
		СоответствиеЗначенийРезультатаОтбора = Новый Соответствие;
		
		КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных)));
		
		КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
		
		ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
		КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
		Настройки = КомпоновщикНастроек.Настройки;
		
		ЭлементПользовательскогоПоля = Настройки.ПользовательскиеПоля.Элементы.Добавить(Тип("ПользовательскоеПолеВыборКомпоновкиДанных"));
		ЭлементПользовательскогоПоля.Использование = Истина;
		ЭлементПользовательскогоПоля.Заголовок = "ПП";
		
		НовоеПолеВыбора = Настройки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		НовоеПолеВыбора.Использование = Истина;
		НовоеПолеВыбора.Поле = Новый ПолеКомпоновкиДанных(ЭлементПользовательскогоПоля.ПутьКДанным);
		
		Если ДанныеОнлайнРасчета = Неопределено Тогда
			ОтборЭлемента = Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяПоляОбъекта);
			ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			ОтборЭлемента.ПравоеЗначение = КлючевойОбъект;
		КонецЕсли;
		
		// Добавления вариантов значения.
		Для Каждого Правило Из Отборы Цикл
			СоответствиеЗначенийРезультатаОтбора.Вставить(Отборы.Индекс(Правило), Правило.Результат);
			
			ЭлементВарианта = ЭлементПользовательскогоПоля.Варианты.Элементы.Добавить();
			ЭлементВарианта.Использование = Истина;
			ЭлементыОтбораПравила = Правило.Отбор.Получить().Отбор.Элементы;
			СкопироватьОтборКомпоновкиДанных(ЭлементВарианта.Отбор, Правило.Отбор.Получить().Отбор);
			ЭлементВарианта.Значение = Отборы.Индекс(Правило);
			
		КонецЦикла;
		// Вариант со значением по умолчанию
		СоответствиеЗначенийРезультатаОтбора.Вставить(Отборы.Количество(), ЗначениеПоУмолчанию); // Отборы.Количество() - Уникальный индекс значения.
		ЭлементВарианта = ЭлементПользовательскогоПоля.Варианты.Элементы.Добавить();
		ЭлементВарианта.Использование = Истина;
		ЭлементВарианта.Значение = Отборы.Количество(); // Отборы.Количество() - Уникальный индекс значения.
		
		// Компоновка
		МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
		
		Если ДанныеОнлайнРасчета = Неопределено Тогда
			ВнешниеНаборыДанных = Неопределено;
		Иначе
			ВнешниеНаборыДанных = Новый Структура("Данные", ВнешнийНаборДанныхСКДПоВходящейСтруктуре(ДанныеОнлайнРасчета, СхемаКомпоновкиДанных.НаборыДанных.Данные));
		КонецЕсли;
		
		ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
		ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки);
		
		ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
		ТаблицаЗначений = Новый ТаблицаЗначений;
		ПроцессорВывода.УстановитьОбъект(ТаблицаЗначений);
		ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
		
		ТаблицаЗначений.Свернуть(ИмяПоляОбъекта + ",ПользовательскиеПоляПоле1");
		
		// Обработка результата расчета
		Если ТипЗнч(КлючевойОбъект) = Тип("Массив") Тогда
			
			Для Каждого Объект Из КлючевойОбъект Цикл
				СтрокиТЗ = ТаблицаЗначений.НайтиСтроки(Новый Структура(ИмяПоляОбъекта, Объект));
				Если СтрокиТЗ.Количество() > 0 Тогда
					ЗначениеРезультатаОтбора = СоответствиеЗначенийРезультатаОтбора.Получить(СтрокиТЗ[0].ПользовательскиеПоляПоле1);
					Если ЗначениеРезультатаОтбора = Неопределено Тогда
						РезультатРасчета = ЗначениеПоУмолчанию.Получить();
					Иначе
						РезультатРасчета = ЗначениеРезультатаОтбора.Получить();
					КонецЕсли;
				Иначе
					РезультатРасчета = ЗначениеПоУмолчанию.Получить();
				КонецЕсли;
				Результат.Добавить(Новый Структура("Объект, РезультатРасчета", Объект, РезультатРасчета));
			КонецЦикла;
		Иначе
			РезультатРасчета = ЗначениеПоУмолчанию.Получить();
			Для Каждого СтрокаРезультатов Из ТаблицаЗначений Цикл
				Если СтрокаРезультатов[ИмяПоляОбъекта] = КлючевойОбъект Тогда
					РезультатРасчета = СоответствиеЗначенийРезультатаОтбора.Получить(СтрокаРезультатов.ПользовательскиеПоляПоле1).Получить();
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Результат.Добавить(Новый Структура("Объект, РезультатРасчета", КлючевойОбъект, РезультатРасчета));
		КонецЕсли;
	Исключение
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

Функция ДобавитьПоляДопСвойств(СхемаКомпоновкиДанных, ДопСвойства) Экспорт
	
	Для каждого Свойство Из ДопСвойства Цикл	 
		Поле = СхемаКомпоновкиДанных.НаборыДанных.Данные.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
		
		Поле.Заголовок      = Свойство.Наименование;
		Поле.ПутьКДанным    = "Дополнительные свойства." + СтрЗаменить(Свойство.Ссылка.УникальныйИдентификатор(), "-","_");
		Поле.Поле           = "Свойство" + СтрЗаменить(Свойство.Ссылка.УникальныйИдентификатор(), "-","_");
		Поле.ТипЗначения    = Свойство.ТипЗначения;
		Поле.ОграничениеИспользованияРеквизитов.Группировка = Истина;
		Поле.ОграничениеИспользованияРеквизитов.Поле = Истина;
		Поле.ОграничениеИспользованияРеквизитов.Порядок = Истина;
		Поле.ОграничениеИспользованияРеквизитов.Условие = Истина;
	КонецЦикла;
	Возврат СхемаКомпоновкиДанных;
	
КонецФункции

Процедура СкопироватьОтборКомпоновкиДанных(Приемник, Источник, ОчищатьПриемник = Истина, УдалятьПредставлениеГруппы = Ложь, УдалятьНеиспользуемые = Истина) 
	
	Если ОчищатьПриемник Тогда 
		Приемник.Элементы.Очистить();
	КонецЕсли;
	
	Для Каждого ЭлементОтбораИсточник Из Источник.Элементы Цикл
		
		Если УдалятьНеиспользуемые И Не ЭлементОтбораИсточник.Использование Тогда
			Продолжить;
		КонецЕсли;
		
		ЭлементОтбора = Приемник.Элементы.Добавить(ТипЗнч(ЭлементОтбораИсточник));
		ЗаполнитьЗначенияСвойств(ЭлементОтбора, ЭлементОтбораИсточник);
		Если ТипЗнч(ЭлементОтбораИсточник) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			Если УдалятьПредставлениеГруппы Тогда
				ЭлементОтбора.Представление = "";
			КонецЕсли;
			СкопироватьОтборКомпоновкиДанных(ЭлементОтбора, ЭлементОтбораИсточник);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ВнешнийНаборДанныхСКДПоВходящейСтруктуре(ВходящаяСтруктура, СхемаНабораДанных)
	
	Если ТипЗнч(ВходящаяСтруктура) <> Тип("Массив") Тогда
		МассивВходящихСтруктур = Новый Массив;
		МассивВходящихСтруктур.Добавить(ВходящаяСтруктура);
	Иначе
		МассивВходящихСтруктур = ВходящаяСтруктура;
	КонецЕсли;
	
	НаборДанных = Новый ТаблицаЗначений;
	Для Каждого Поле Из СхемаНабораДанных.Поля Цикл
		Если ТипЗнч(Поле) = Тип("ПолеНабораДанныхСхемыКомпоновкиДанных") Тогда
			НаборДанных.Колонки.Добавить(Поле.Поле, Поле.ТипЗначения);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ЭлементВходящейСтруктуры Из МассивВходящихСтруктур Цикл
		ЗаполнитьЗначенияСвойств(НаборДанных.Добавить(), ЭлементВходящейСтруктуры);
	КонецЦикла;
	
	Возврат НаборДанных;
	
КонецФункции

Процедура ОбновитьПризнакиПоСсылке(Признаки, СтруктураОбъектов, КоличествоОшибок = 0, КешМакетовСКД = Неопределено)
	
	ЗначенияПризнаков = Новый Массив();
	 
	Для Каждого ПризнакСтрока Из Признаки Цикл
		СтрокаПризнака = Новый Структура("Признак, КлючевойОбъект, Значение");
		СтрокаПризнака.Признак = ПризнакСтрока.Ссылка;
		
		Если ПризнакСтрока.ВидПризнака = 0 И ЗначениеЗаполнено(СтруктураОбъектов.Клиент) Тогда
			СтрокаПризнака.КлючевойОбъект = СтруктураОбъектов.Клиент;	
		ИначеЕсли ПризнакСтрока.ВидПризнака = 1 И ЗначениеЗаполнено(СтруктураОбъектов.Заявка) Тогда
			СтрокаПризнака.КлючевойОбъект = СтруктураОбъектов.Заявка;
		Иначе
			Продолжить;
		КонецЕсли;
		
		Если ПризнакСтрока.ФорматУсловия = 0 Тогда
			СтрокаПризнака.Значение = ВычислитьПризнакПоПроизвольномуКоду(ПризнакСтрока.ИсполняемыйКод, СтрокаПризнака.КлючевойОбъект);
		ИначеЕсли ПризнакСтрока.ФорматУсловия = 1 Тогда
			Значения = РассчитатьПризнакПоОтборамСКД(ПризнакСтрока.Отборы, ПризнакСтрока.ЗначениеПоУмолчанию, СтрокаПризнака.КлючевойОбъект,,,КешМакетовСКД);
			СтрокаПризнака.Значение = ?(Значения.Количество() = 0, Неопределено, Значения[0].РезультатРасчета);
		КонецЕсли;
		
		ЗначенияПризнаков.Добавить(СтрокаПризнака);
		Если СтрокаПризнака.Значение = Неопределено Тогда
			КоличествоОшибок = КоличествоОшибок + 1;
		КонецЕсли;
	КонецЦикла;
	
	// Сохранение значений признаков
	СохранитьЗначенияПризнакаКлючевогоОбъекта(ЗначенияПризнаков, СтруктураОбъектов.Заявка, СтруктураОбъектов.Клиент);	
	
КонецПроцедуры

Процедура ЗаполнитьСтруктуруВыводаСхемыКомпоновкиРекурсивно(ГруппаПриемник, ГруппаИсточник)
	
	Для Каждого ГруппаСтруктурыИсточник Из ГруппаИсточник.Структура Цикл
		
		ГруппаСтруктурыПриемник = ГруппаПриемник.Структура.Добавить(ТипЗнч(ГруппаСтруктурыИсточник));
		ЗаполнитьЗначенияСвойств(ГруппаСтруктурыПриемник, ГруппаСтруктурыИсточник);
		
		Для Каждого ВыборСтруктурыИсточник Из ГруппаСтруктурыИсточник.Выбор.Элементы Цикл
			ВыборСтруктурыПриемник = ГруппаСтруктурыПриемник.Выбор.Элементы.Добавить(ТипЗнч(ВыборСтруктурыИсточник));
			ЗаполнитьЗначенияСвойств(ВыборСтруктурыПриемник, ВыборСтруктурыИсточник);
		КонецЦикла;
		
		Для Каждого ГруппировкаСтруктурыИсточник Из ГруппаСтруктурыИсточник.ПоляГруппировки.Элементы Цикл
			ГруппировкаСтруктурыПриемник = ГруппаСтруктурыПриемник.ПоляГруппировки.Элементы.Добавить(ТипЗнч(ГруппировкаСтруктурыИсточник));
			ЗаполнитьЗначенияСвойств(ГруппировкаСтруктурыПриемник, ГруппировкаСтруктурыИсточник);
		КонецЦикла;
		
		ЗаполнитьСтруктуруВыводаСхемыКомпоновкиРекурсивно(ГруппаСтруктурыПриемник, ГруппаСтруктурыИсточник);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти