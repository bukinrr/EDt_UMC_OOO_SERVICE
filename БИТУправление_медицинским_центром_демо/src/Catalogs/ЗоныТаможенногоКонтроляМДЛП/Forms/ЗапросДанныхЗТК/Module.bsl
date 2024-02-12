
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ДоступныеНастройки = ТранспортМДЛП.ДоступныеТранспортныеМодули();
	Для Каждого Настройка Из ДоступныеНастройки Цикл
		Если Настройка.ИдентификаторСубъектаОбращения = Настройка.ПараметрыПодключения.ИдентификаторОрганизации Тогда
			ДоступныеПодключения.Добавить(Настройка.ПараметрыПодключения, Настройка.Представление);
		КонецЕсли;
	КонецЦикла;
	
	Если ДоступныеПодключения.Количество() = 0 Тогда
		ВызватьИсключение НСтр(
			"ru = 'Нет настроенных подключений через API.
			|
			|Проверьте, что заведена собственная организация.
			|'");
	КонецЕсли;
	
	Идентификатор = Параметры.Идентификатор;
	ИНН = Параметры.ИНН;
	КодТаможенногоОргана = Параметры.КодТаможенногоОргана;
	НомерСвидетельства = Параметры.НомерСвидетельства;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийКомандФормы

&НаКлиенте
Процедура ЗапроситьДанныеЗТК(Команда)
	
	Если Не ЗначениеЗаполнено(Идентификатор) И Не ЗначениеЗаполнено(ИНН) И Не ЗначениеЗаполнено(КодТаможенногоОргана) И Не ЗначениеЗаполнено(НомерСвидетельства) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Нужно указать одно из значений ""Рег. номер участника"", ""ИНН"", ""Код таможенного органа"" или ""Номер свидетельства""'"),, "Идентификатор");
		Возврат;
	КонецЕсли;
	
	Отбор = Новый Структура;
	
	Если ЗначениеЗаполнено(Идентификатор) Тогда
		Если Не КорректныйИдентификатор(Идентификатор) Тогда
			ТекстОшибки = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, "Корректность", НСтр("ru = 'Рег. номер участника'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,, "Идентификатор");
		Иначе
			Отбор.Вставить("Идентификатор", Идентификатор);
		КонецЕсли;
	ИначеЕсли ЗначениеЗаполнено(ИНН) Тогда
		ТекстОшибки = "";
		Если Не РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(ИНН, СтрДлина(СокрЛП(ИНН)) <> 12, ТекстОшибки) Тогда
			ТекстОшибки = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, "Корректность", НСтр("ru = 'ИНН'"),,, ТекстОшибки);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,, "ИНН");
		Иначе
			Отбор.Вставить("ИНН", СокрЛП(ИНН));
		КонецЕсли;
	ИначеЕсли ЗначениеЗаполнено(КодТаможенногоОргана) Тогда
		Отбор.Вставить("КодТаможенногоОргана", СокрЛП(КодТаможенногоОргана));
	ИначеЕсли ЗначениеЗаполнено(НомерСвидетельства) Тогда
		Отбор.Вставить("НомерСвидетельства", СокрЛП(НомерСвидетельства));
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Нужно указать одно из значений ""Рег. номер участника"", ""ИНН"", ""Код таможенного органа"" или ""Номер свидетельства""'"),, "Идентификатор");
	КонецЕсли;
	
	Если Отбор.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ДоступныеПодключения.Количество() > 1 Тогда
		Обработчик = Новый ОписаниеОповещения("ЗапроситьДанныеЗТК_ПослеВыбораПодключения", ЭтотОбъект, Новый Структура("Отбор", Отбор));
		ДоступныеПодключения.ПоказатьВыборЭлемента(Обработчик, НСтр("ru = 'Выберите подключение'"));
	Иначе
		ЗапроситьДанныеЗТКЧерезПодключение(ДоступныеПодключения[0].Значение, Отбор);
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьДанныеЗТК(Команда)
	
	Если НайденныеЗТК.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если НайденныеЗТК.НайтиСтроки(Новый Структура("Пометка", Истина)).Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не выбраны данные для сохранения.'"));
		Возврат;
	КонецЕсли;
	
	СохранитьДанныеЗТКНаСервере();
	
	ОповеститьОбИзменении(Тип("СправочникСсылка.ЗоныТаможенногоКонтроляМДЛП"));
	ОповеститьОбИзменении(Тип("СправочникСсылка.ТаможенныеОрганыМДЛП"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗапроситьДанныеЗТК_ПослеВыбораПодключения(ВыбранныеЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеЭлемент <> Неопределено Тогда
		ЗапроситьДанныеЗТКЧерезПодключение(ВыбранныеЭлемент.Значение, ДополнительныеПараметры.Отбор);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапроситьДанныеЗТКЧерезПодключение(ПараметрыПодключения, Отбор)
	
	Обработчик = Новый ОписаниеОповещения("ЗапроситьДанныеЗТК_ОбработатьПолученияДанных", ЭтотОбъект);
	ТранспортМДЛПАПИКлиент.ПолучитьИнформациюОЗТК(ПараметрыПодключения, Отбор, Обработчик);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапроситьДанныеЗТК_ОбработатьПолученияДанных(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.Статус = "Ошибка" Тогда
		ВызватьИсключение Результат.ОписаниеОшибки;
	КонецЕсли;
	
	Если Результат.СписокЗТК.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'По указанным данным информация отсутствует.'"));
	Иначе
		НайденныеЗТК.Очистить();
		Для Каждого ЗТК Из Результат.СписокЗТК Цикл
			ДанныеЗТК = НайденныеЗТК.Добавить();
			ЗаполнитьЗначенияСвойств(ДанныеЗТК, ЗТК);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КорректныйИдентификатор(Знач Идентификатор)
	
	Возврат ИнтеграцияМДЛП.ЗначениеСоответствуетТипуXDTO(Идентификатор, "system_subject_type");
	
КонецФункции

&НаСервере
Процедура СохранитьДанныеЗТКНаСервере()
	
	РегистрационныеНомераУчастников = Новый Массив;
	ОтмеченныеЗТК = НайденныеЗТК.НайтиСтроки(Новый Структура("Пометка", Истина));
	Для Каждого СтрокаЗТК Из ОтмеченныеЗТК Цикл
		РегистрационныеНомераУчастников.Добавить(СтрокаЗТК.РегистрационныйНомерУчастника);
	КонецЦикла;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТаможенныеОрганы.Ссылка        КАК Ссылка,
	|	ТаможенныеОрганы.Код           КАК КодТаможенногоОргана,
	|	ТаможенныеОрганы.Наименование  КАК НаименованиеТаможенногоОргана
	|ИЗ
	|	Справочник.ТаможенныеОрганыМДЛП КАК ТаможенныеОрганы
	|ГДЕ
	|	НЕ ТаможенныеОрганы.ПометкаУдаления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗТК.Ссылка                         КАК Ссылка,
	|	ЗТК.РегистрационныйНомерУчастника  КАК РегистрационныйНомерУчастника,
	|	ЗТК.ИНН                            КАК ИНН,
	|	ЗТК.Наименование                   КАК Наименование,
	|	ЗТК.НомерСвидетельства             КАК НомерСвидетельства,
	|	ЗТК.ТипСклада                      КАК ТипСклада,
	|	ЗТК.ТаможенныйОрган                КАК ТаможенныйОрган,
	|	ЗТК.НаличиеЛицензииНаФармацевтическуюДеятельность КАК НаличиеЛицензииНаФармацевтическуюДеятельность
	|ИЗ
	|	Справочник.ЗоныТаможенногоКонтроляМДЛП КАК ЗТК
	|ГДЕ
	|	ЗТК.РегистрационныйНомерУчастника В(&РегистрационныеНомераУчастников)
	|	И НЕ ЗТК.ПометкаУдаления
	|");
	
	Запрос.УстановитьПараметр("РегистрационныеНомераУчастников", РегистрационныеНомераУчастников);
	
	Результаты = Запрос.ВыполнитьПакет();
	ВыборкаТаможенныхОрганов = Результаты[Результаты.ВГраница() - 1].Выбрать();
	ВыборкаЗТК               = Результаты[Результаты.ВГраница()].Выбрать();
	
	ТаможенныеОрганы = Новый Соответствие;
	Пока ВыборкаТаможенныхОрганов.Следующий() Цикл
		Данные = Новый Структура("Ссылка, КодТаможенногоОргана, НаименованиеТаможенногоОргана");
		ЗаполнитьЗначенияСвойств(Данные, ВыборкаТаможенныхОрганов);
		ТаможенныеОрганы.Вставить(НРег(ВыборкаТаможенныхОрганов.КодТаможенногоОргана), Данные);
	КонецЦикла;
	
	ЗТК = Новый Соответствие;
	Пока ВыборкаЗТК.Следующий() Цикл
		Данные = Новый Структура("Ссылка, РегистрационныйНомерУчастника, ИНН, Наименование, НомерСвидетельства, ТипСклада, ТаможенныйОрган, НаличиеЛицензииНаФармацевтическуюДеятельность");
		ЗаполнитьЗначенияСвойств(Данные, ВыборкаЗТК);
		ЗТК.Вставить(НРег(ВыборкаЗТК.РегистрационныйНомерУчастника), Данные);
	КонецЦикла;
	
	Для Каждого СтрокаЗТК Из ОтмеченныеЗТК Цикл
		
		ДанныеТаможенногоОргана = ТаможенныеОрганы.Получить(СтрокаЗТК.КодТаможенногоОргана);
		Если ДанныеТаможенногоОргана = Неопределено Тогда
			
			ТаможенныйОрганОбъект = Справочники.ТаможенныеОрганыМДЛП.СоздатьЭлемент();
			ТаможенныйОрганОбъект.Код          = СтрокаЗТК.КодТаможенногоОргана;
			ТаможенныйОрганОбъект.Наименование = СтрокаЗТК.НаименованиеТаможенногоОргана;
			ТаможенныйОрганОбъект.Записать();
			
			Данные = Новый Структура("Ссылка, КодТаможенногоОргана, НаименованиеТаможенногоОргана");
			ЗаполнитьЗначенияСвойств(Данные, СтрокаЗТК);
			Данные.Ссылка = ТаможенныйОрганОбъект.Ссылка;
			ТаможенныеОрганы.Вставить(СтрокаЗТК.КодТаможенногоОргана, Данные);
			ДанныеТаможенногоОргана = ТаможенныеОрганы.Получить(СтрокаЗТК.КодТаможенногоОргана);
			
		Иначе
			
			НужноОбновить = Ложь;
			Для Каждого Реквизит Из ДанныеТаможенногоОргана Цикл
				Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаЗТК, Реквизит.Ключ)
				   И Реквизит.Значение <> СтрокаЗТК[Реквизит.Ключ] Тогда
					НужноОбновить = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если НужноОбновить Тогда
				ТаможенныйОрганОбъект = ДанныеТаможенногоОргана.Ссылка.ПолучитьОбъект();
				ТаможенныйОрганОбъект.Код          = СтрокаЗТК.КодТаможенногоОргана;
				ТаможенныйОрганОбъект.Наименование = СтрокаЗТК.НаименованиеТаможенногоОргана;
				ТаможенныйОрганОбъект.Записать();
			КонецЕсли;
			
		КонецЕсли;
		
		ДанныеЗТК = ЗТК.Получить(СтрокаЗТК.РегистрационныйНомерУчастника);
		Если ДанныеЗТК = Неопределено Тогда
			
			ЗТКОбъект = Справочники.ЗоныТаможенногоКонтроляМДЛП.СоздатьЭлемент();
			ЗаполнитьЗначенияСвойств(ЗТКОбъект, СтрокаЗТК);
			ЗТКОбъект.ТаможенныйОрган = ДанныеТаможенногоОргана.Ссылка;
			ЗТКОбъект.Записать();
			
			Данные = Новый Структура("Ссылка, РегистрационныйНомерУчастника, ИНН, Наименование, НомерСвидетельства, ТипСклада, ТаможенныйОрган, НаличиеЛицензииНаФармацевтическуюДеятельность");
			ЗаполнитьЗначенияСвойств(Данные, СтрокаЗТК);
			Данные.Ссылка = ЗТКОбъект.Ссылка;
			Данные.ТаможенныйОрган = ЗТКОбъект.ТаможенныйОрган;
			ЗТК.Вставить(СтрокаЗТК.РегистрационныйНомерУчастника, Данные);
			
		Иначе
			
			НужноОбновить = Ложь;
			Для Каждого Реквизит Из ДанныеЗТК Цикл
				Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаЗТК, Реквизит.Ключ)
				   И Реквизит.Значение <> СтрокаЗТК[Реквизит.Ключ] Тогда
					НужноОбновить = Истина;
					Прервать;
				ИначеЕсли Реквизит.Ключ = "ТаможенныйОрган" И Реквизит.Значение <> ДанныеТаможенногоОргана.Ссылка Тогда
					НужноОбновить = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если НужноОбновить Тогда
				ЗТКОбъект = ДанныеЗТК.Ссылка.ПолучитьОбъект();
				ЗаполнитьЗначенияСвойств(ЗТКОбъект, СтрокаЗТК);
				ЗТКОбъект.ТаможенныйОрган = ДанныеТаможенногоОргана.Ссылка;
				ЗТКОбъект.Записать();
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
