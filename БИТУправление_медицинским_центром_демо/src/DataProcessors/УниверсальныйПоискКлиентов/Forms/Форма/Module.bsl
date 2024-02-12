
&НаКлиенте
Перем ПутьКОбработке;

#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
			
	СохраненныеНастройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ОтборКлиентов", "НастройкиОтбора");
	ЗагрузитьСохраненныеНастройкиНаСервере(Истина);
		
	Элементы.ГруппаСоздание.Видимость = Не Параметры.ЗагрузкаВДокумент;
	Элементы.ФормаЗагрузитьКлиентов.Видимость = Параметры.ЗагрузкаВДокумент;		
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПутьКОбработке = Лев(ИмяФормы, СтрНайти(ИмяФормы, ".", НаправлениеПоиска.СКонца, , 2) - 1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если НЕ ЗавершениеРаботы Тогда	
		Если НастройкиМодифицированы Тогда
			
			ТекстВопроса = НСтр("ru = 'Настройки были модифицированы. Сохранить изменения?'");
			КнопкиВопроса = Новый СписокЗначений;
			Если ЗначениеЗаполнено(СохраненныеНастройки) Тогда 
				КнопкиВопроса.Добавить("ОбновитьСуществующую", НСтр("ru='Обновить существующую'"));
			КонецЕсли;
			КнопкиВопроса.Добавить("СоздатьНовую", НСтр("ru='Создать новую настройку'"));
			КнопкиВопроса.Добавить("Нет", НСтр("ru='Нет'"));
			КнопкиВопроса.Добавить("Отмена", НСтр("ru='Отмена'"));
			Ответ = Вопрос(ТекстВопроса, КнопкиВопроса, 30, НСтр("ru='Нет'"));
			
			Если Ответ = "СоздатьНовую" Тогда 
				ИмяНастройки = "";
				Если ВвестиСтроку(ИмяНастройки, НСтр("ru='Введите наименование новой настройки'")) Тогда 
					СохранитьНастройкиНаСервере(ИмяНастройки);
				КонецЕсли;
			ИначеЕсли Ответ = "ОбновитьСуществующую" Тогда 
				СохранитьНастройкиНаСервере(СохраненныеНастройки);
			ИначеЕсли Ответ = "Отмена" Тогда
				Отказ = Истина;
				Возврат;
			Иначе
				Возврат;
			КонецЕсли;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СохраненныеНастройки) Тогда 
			ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ОтборКлиентов", "НастройкиОтбора", СохраненныеНастройки); 
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаВидаПриИзменении(Элемент)
	
	ИнициализироватьСхемыКомпоновки(Ложь);
	НастройкиМодифицированы = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПриИзменении(Элемент)
	
	СтрокиСхемы = СхемыКомпоновкиДанных.НайтиСтроки(Новый Структура("ИмяЭлементаНастроек", Элемент.Имя));
	Если СтрокиСхемы.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	СтрокаСхемы = СтрокиСхемы[0];
	ПересчитатьВысотуТаблицыПользовательскихНастроек(СтрокаСхемы.ПолучитьИдентификатор());
	НастройкиМодифицированы = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	Перем ВыполненноеДействие, ПараметрВыполненногоДействия;

    СтандартнаяОбработка = Ложь;
    ОбработкаРасшифровки = Новый ОбработкаРасшифровкиКомпоновкиДанных(РезультатРасшифровка,
    Новый ИсточникДоступныхНастроекКомпоновкиДанных(РезультатСхема));

    ДоступныеДействия = Новый Массив;
    ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение);

    ОбработкаРасшифровки.ВыбратьДействие(Расшифровка, ВыполненноеДействие, ПараметрВыполненногоДействия, ДоступныеДействия);

	Если ЗначениеЗаполнено(ПараметрВыполненногоДействия) Тогда 
    	ОткрытьЗначение(ПараметрВыполненногоДействия);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Команды

&НаКлиенте
Процедура ИзменитьВариант(Команда)
	
	СтруктураНастроек = ПолучитьОбъединенныеНастройкиКомпоновки(Ложь, Истина, Ложь);
	
	НастройкиКомпоновки = ПолучитьФорму(ПутьКОбработке + ".Форма.ФормаВарианта", СтруктураНастроек).ОткрытьМодально();
	Если НастройкиКомпоновки <> Неопределено Тогда
		ОсновнаяСхемаКомпоновкиКомпоновщик.ЗагрузитьНастройки(НастройкиКомпоновки);
		НастройкиМодифицированы = Истина;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОтчет(Команда)
	
	ВыполнитьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКлиентов(Команда)
	
	мсКлиенты = ЗагрузитьКлиентовНаСервере();
	ОповеститьОВыборе(мсКлиенты);
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьОтбор(Команда)
	
	СтрокиСхемы = СхемыКомпоновкиДанных.НайтиСтроки(Новый Структура("ИмяКомандыОтбора", Команда.Имя));
	Если СтрокиСхемы.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	СтрокаСхемы = СтрокиСхемы[0];
	
	НастройкиКомпоновки = ОбщегоНазначенияРасширенный.ПолучитьНастройкиКомпоновщика(ЭтаФорма[СтрокаСхемы.ИмяНастроек]);
	ПараметрыФормы = Новый Структура("АдресСхемы, НастройкиКомпоновки", СтрокаСхемы.АдресСхемы, НастройкиКомпоновки);
	НастройкиКомпоновки = ПолучитьФорму(ПутьКОбработке + ".Форма.ФормаРедактированияОтбора", ПараметрыФормы).ОткрытьМодально();
	Если НастройкиКомпоновки <> Неопределено Тогда
		
		ЭтаФорма[СтрокаСхемы.ИмяНастроек].ЗагрузитьНастройки(НастройкиКомпоновки);
		ПересчитатьВысотуТаблицыПользовательскихНастроек(СтрокаСхемы.ПолучитьИдентификатор());
		НастройкиМодифицированы = Истина;

	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура СкрытьОтборы(Команда)
	
	Элементы.ФормаСкрытьОтборы.Пометка = Не Элементы.ФормаСкрытьОтборы.Пометка;
	ГруппаНастроек = ?(НастройкаРасположенияОтборов = 
		ПредопределенноеЗначение("Перечисление.ВидыНастроекРасположенияОтборовФормыПодбораКлиентов.НаНесколькихСтраницах"), 
		Элементы.ГруппаНастройкиСтраницы, Элементы.ГруппаНастройкиОднаСтраница);
	ГруппаНастроек.Видимость = Не Элементы.ФормаСкрытьОтборы.Пометка; 	
	
КонецПроцедуры

#КонецОбласти

#Область ИнициализацияРаботаСКД

&НаСервере
Процедура ИнициализироватьСхемыКомпоновки(ЗагружатьНастройкиПоУмолчанию = Истина)
	
	Для Каждого СтрокаСхемы Из СхемыКомпоновкиДанных Цикл
		УдалитьРеквизитыСхемыКомпоновки(СтрокаСхемы.ПолучитьИдентификатор(), ЗагружатьНастройкиПоУмолчанию);
	КонецЦикла;
	СхемыКомпоновкиДанных.Очистить();
	Результат.Очистить();
	РезультатРасшифровка = "";
	РезультатСхема = "";
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	
	Для Каждого МетаданныеМакета Из ОбработкаОбъект.Метаданные().Макеты Цикл
		
		Если Лев(МетаданныеМакета.Имя, 1) = "_" Тогда 
			Продолжить;
		КонецЕсли;
		
		МакетСКД = ОбработкаОбъект.ПолучитьМакет(МетаданныеМакета.Имя);
		ДобавитьСхемуКомпоновки(МакетСКД, МетаданныеМакета.Имя, МетаданныеМакета.Синоним, ЗагружатьНастройкиПоУмолчанию);
		
	КонецЦикла;
	
	// Собираем объединенную схему
	ОсновнаяСхемаКомпоновки = ОбработкаОбъект.ПолучитьМакет("КлиентыСКД");
	Для Сч = 1 По СхемыКомпоновкиДанных.Количество() - 1 Цикл
		
		СтрокаСхемы = СхемыКомпоновкиДанных[Сч];
		ДополнитьНаборДанныхСхемыКомпоновки(ОсновнаяСхемаКомпоновки, СтрокаСхемы.ПолучитьИдентификатор());
		ПересчитатьВысотуТаблицыПользовательскихНастроек(СтрокаСхемы.ПолучитьИдентификатор());
		
	КонецЦикла;
	
	ОсновнаяСхемаКомпоновкиАдрес = ПоместитьВоВременноеХранилище(ОсновнаяСхемаКомпоновки, УникальныйИдентификатор);
	СтруктураНастроек = ПолучитьОбъединенныеНастройкиКомпоновки();
	ОсновнаяСхемаКомпоновкиКомпоновщик.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(ОсновнаяСхемаКомпоновкиАдрес));
	ОсновнаяСхемаКомпоновкиКомпоновщик.ЗагрузитьНастройки(СтруктураНастроек.НастройкиКомпоновки);
		
КонецПроцедуры

&НаСервере
Процедура ДобавитьСхемуКомпоновки(СхемаКомпоновки, ИмяСхемы, ЗаголовокСхемы = Неопределено, ЗагружатьНастройкиПоУмолчанию = Истина)
		
	Если ЗаголовокСхемы = Неопределено Тогда 
		ЗаголовокСхемы = ИмяСхемы;
	КонецЕсли;
	
	НоваяСтрока = СхемыКомпоновкиДанных.Добавить();
	НоваяСтрока.ИмяСхемы = ИмяСхемы;
	НоваяСтрока.Заголовок = ЗаголовокСхемы;
	НоваяСтрока.ИмяСтраницы = "Страница_" + ИмяСхемы;
	НоваяСтрока.ИмяНастроек = "Настройки_" + ИмяСхемы;
	НоваяСтрока.ИмяЭлементаНастроек = "Настройки_" + ИмяСхемы;
	НоваяСтрока.ИмяЭлементаОтбора = "Отбор_" + ИмяСхемы;
	НоваяСтрока.ИмяКомандыОтбора = "РедактироватьОтбор_" + ИмяСхемы;
	НоваяСтрока.АдресСхемы = ПоместитьВоВременноеХранилище(СхемаКомпоновки, УникальныйИдентификатор);
	НоваяСтрока.Основная = (СхемыКомпоновкиДанных.Количество() = 1);
	НоваяСтрока.Используется = Истина;
	
	// Создание реквизитов и элементов
	СоздатьРеквизитыСхемыКомпоновки(НоваяСтрока.ПолучитьИдентификатор());
	
	// Загрузка настроек
	ИнициализироватьРеквизитыСхемыКомпоновки(НоваяСтрока.ПолучитьИдентификатор(), ЗагружатьНастройкиПоУмолчанию);
	
КонецПроцедуры

&НаСервере
Процедура СоздатьРеквизитыСхемыКомпоновки(ИдентификаторСтрокиСхемы)
	
	ВидыНастроек = Перечисления.ВидыНастроекРасположенияОтборовФормыПодбораКлиентов;
	ГруппаНастроек = ?(НастройкаРасположенияОтборов = ВидыНастроек.НаНесколькихСтраницах, Элементы.ГруппаНастройкиСтраницы, Элементы.ГруппаНастройкиОднаСтраница);
	ГруппаРезультата = ?(НастройкаРасположенияОтборов = ВидыНастроек.НаНесколькихСтраницах, Элементы.ГруппаРезультатНесколькоСтраниц, Элементы.ГруппаРезультатОднаСтраница);
	ВидГруппыНастройки = ?(НастройкаРасположенияОтборов = ВидыНастроек.НаНесколькихСтраницах, ВидГруппыФормы.Страница, ВидГруппыФормы.ОбычнаяГруппа);
	ПоведениеГруппыНастройки = ?(НастройкаРасположенияОтборов = ВидыНастроек.НаНесколькихСтраницах, Неопределено, ПоведениеОбычнойГруппы.Свертываемая);
	
	СтрокаСхемы = СхемыКомпоновкиДанных.НайтиПоИдентификатору(ИдентификаторСтрокиСхемы);
	Если СтрокаСхемы = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Реквизит = РаботаСДинамическиИзменяемымиФормами.ПолучитьРеквизитФормы(ЭтаФорма, СтрокаСхемы.ИмяНастроек);
	Если Реквизит = Неопределено Тогда 
		мсРеквизиты = Новый Массив;
		Реквизит = Новый РеквизитФормы(СтрокаСхемы.ИмяНастроек, Новый ОписаниеТипов("КомпоновщикНастроекКомпоновкиДанных"));
		мсРеквизиты.Добавить(Реквизит);
		ИзменитьРеквизиты(мсРеквизиты);
	КонецЕсли;
		
	ЭлементСтраница = Элементы.Добавить(СтрокаСхемы.ИмяСтраницы, Тип("ГруппаФормы"), ГруппаНастроек);
	ЭлементСтраница.Вид = ВидГруппыНастройки;
	Если ПоведениеГруппыНастройки <> Неопределено Тогда  
		ЭлементСтраница.Поведение = ПоведениеГруппыНастройки;
	КонецЕсли;
	ЭлементСтраница.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
	ЭлементСтраница.Заголовок = СтрокаСхемы.Заголовок;
	
	ЭлементНастройки = ОбщегоНазначенияРасширенный.СоздатьЭлементыПользовательскихНастроекНаФорме(Элементы, ЭлементСтраница, СтрокаСхемы.ИмяНастроек, СтрокаСхемы.ИмяЭлементаНастроек);
	ЭлементНастройки.УстановитьДействие("ПриИзменении", "ОтборПриИзменении");
	
	// Команда открытия отбора
	КомандаОтбор = ЭтаФорма.Команды.Добавить(СтрокаСхемы.ИмяКомандыОтбора);
	КомандаОтбор.Заголовок = НСтр("ru='Редактировать подробно'");
	КомандаОтбор.Действие = "РедактироватьОтбор";
	ЭлементКоманда = Элементы.Добавить(СтрокаСхемы.ИмяКомандыОтбора, Тип("КнопкаФормы"), ЭлементНастройки.КоманднаяПанель);
	ЭлементКоманда.Вид = ВидКнопкиФормы.КнопкаКоманднойПанели;
	ЭлементКоманда.ИмяКоманды = СтрокаСхемы.ИмяКомандыОтбора;
	
	ГруппаНастроек.Видимость = Не Элементы.ФормаСкрытьОтборы.Пометка;
		
	// Перемещаем результат
	Элементы.Переместить(Элементы.ГруппаРезультат, ГруппаРезультата);
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьРеквизитыСхемыКомпоновки(ИдентификаторСтрокиСхемы, ЗагружатьНастройкиПоУмолчанию)
	
	СтрокаСхемы = СхемыКомпоновкиДанных.НайтиПоИдентификатору(ИдентификаторСтрокиСхемы);
	Если СтрокаСхемы = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	КомпоновщикНастроек = ЭтаФорма[СтрокаСхемы.ИмяНастроек];
	СтраницаНастроек = Элементы[СтрокаСхемы.ИмяСтраницы];
	КомандаОтбора = Элементы[СтрокаСхемы.ИмяКомандыОтбора];
	
	// Загружаем настройки
	Если ЗагружатьНастройкиПоУмолчанию Тогда 
		СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(СтрокаСхемы.АдресСхемы);
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СтрокаСхемы.АдресСхемы));
		КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	КонецЕсли;
		
	// Если в схеме нет поля "Клиент", она не используется
	Если Не СтрокаСхемы.Основная И
		КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.НайтиПоле(Новый ПолеКомпоновкиДанных("Клиент")) = Неопределено
	Тогда
		СтрокаСхемы.Используется = Ложь;
	КонецЕсли;
	
	Если ЗагружатьНастройкиПоУмолчанию Тогда 
		СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(СтрокаСхемы.АдресСхемы);
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СтрокаСхемы.АдресСхемы));
		КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	КонецЕсли;
	
	СтраницаНастроек.Видимость = СтрокаСхемы.Используется;
	КомандаОтбора.Видимость = СтрокаСхемы.Используется;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьРеквизитыСхемыКомпоновки(ИдентификаторСтрокиСхемы, УдалятьРеквизитыКомпоновщика = Ложь)
	
	СтрокаСхемы = СхемыКомпоновкиДанных.НайтиПоИдентификатору(ИдентификаторСтрокиСхемы);
	Если СтрокаСхемы = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если УдалятьРеквизитыКомпоновщика Тогда 
		мсРеквизиты = Новый Массив;
		мсРеквизиты.Добавить(СтрокаСхемы.ИмяНастроек);
		ИзменитьРеквизиты(, мсРеквизиты);
	КонецЕсли;
	
	Элементы.Удалить(Элементы[СтрокаСхемы.ИмяСтраницы]);
	КомандаОтбор = Команды.Найти(СтрокаСхемы.ИмяКомандыОтбора);
	Если КомандаОтбор <> Неопределено Тогда 
		Команды.Удалить(КомандаОтбор);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДополнитьНаборДанныхСхемыКомпоновки(СхемаПриемник, ИдентификаторСтрокиСхемы)
		
	СтрокаСхемы = СхемыКомпоновкиДанных.НайтиПоИдентификатору(ИдентификаторСтрокиСхемы);
	Если СтрокаСхемы = Неопределено Или Не СтрокаСхемы.Используется Тогда 
		Возврат;
	КонецЕсли;
	
	СхемаИсточник = ПолучитьИзВременногоХранилища(СтрокаСхемы.АдресСхемы);
	
	Если СхемаИсточник.НаборыДанных.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	Если Ложь Тогда 
		СхемаПриемник = Новый СхемаКомпоновкиДанных;
		СхемаИсточник = Новый СхемаКомпоновкиДанных;
	КонецЕсли;
	
	// Наборы данных
	ИмяОсновногоНабораИсточника = "Клиенты"; // Если такого набора в источнике нет - будет использован первый
	ОсновнойНаборИсточник = СхемаИсточник.НаборыДанных[0];
	Для Каждого НаборИсточник Из СхемаИсточник.НаборыДанных Цикл 
		
		Если НаборИсточник.Имя = ИмяОсновногоНабораИсточника Тогда
			ОсновнойНаборИсточник = НаборИсточник;
		КонецЕсли;
		
		НаборПриемник = СхемаПриемник.НаборыДанных.Добавить(ТипЗнч(НаборИсточник));
		ЗаполнитьЗначенияСвойств(НаборПриемник, НаборИсточник);
		
		// Поля набора
		Для Каждого ПолеИсточник Из НаборИсточник.Поля Цикл
			
			ПолеПриемник = НаборПриемник.Поля.Добавить(ТипЗнч(ПолеИсточник));
			ЗаполнитьЗначенияСвойств(ПолеПриемник, ПолеИсточник);
			
		КонецЦикла;
		
	КонецЦикла;
	
	ОсновнойНаборПриемник = СхемаПриемник.НаборыДанных[0];
	
	// Добавляем связь с основным набором
	СвязьПриемник = СхемаПриемник.СвязиНаборовДанных.Добавить();
	СвязьПриемник.НаборДанныхИсточник = ОсновнойНаборПриемник.Имя;
	СвязьПриемник.НаборДанныхПриемник = ОсновнойНаборИсточник.Имя;
	СвязьПриемник.ВыражениеИсточник = "Клиент";
	СвязьПриемник.ВыражениеПриемник = "Клиент";
	СвязьПриемник.Обязательная = Ложь;
	
	// Добавляем существующие связи
	Для Каждого СвязьИсточник Из СхемаИсточник.СвязиНаборовДанных Цикл
		
		СвязьПриемник = СхемаПриемник.СвязиНаборовДанных.Добавить();
		ЗаполнитьЗначенияСвойств(СвязьПриемник, СвязьИсточник);
		
	КонецЦикла;
		
	// Параметры данных
	Для Каждого ПараметрИсточник Из СхемаИсточник.Параметры Цикл
		
		Если СхемаПриемник.Параметры.Найти(ПараметрИсточник.Имя) <> Неопределено Тогда 
			Продолжить;
		КонецЕсли;
		
		ПараметрПриемник = СхемаПриемник.Параметры.Добавить();
		ЗаполнитьЗначенияСвойств(ПараметрПриемник, ПараметрИсточник);
		
	КонецЦикла;
	
	// Вычисляемые поля
	Для Каждого ПолеИсточник Из СхемаИсточник.ВычисляемыеПоля Цикл
		
		Если СхемаПриемник.ВычисляемыеПоля.Найти(ПолеИсточник.ПутьКДанным) <> Неопределено Тогда 
			Продолжить;
		КонецЕсли;
		
		ПолеПриемник = СхемаПриемник.ВычисляемыеПоля.Добавить();
		ЗаполнитьЗначенияСвойств(ПолеПриемник, ПолеИсточник);
		
	КонецЦикла;
	
	// Ресурсы
	Для Каждого РесурсИсточник Из СхемаИсточник.ПоляИтога Цикл
		
		РесурсПриемник = СхемаПриемник.ПоляИтога.Добавить();
		ЗаполнитьЗначенияСвойств(РесурсПриемник, РесурсИсточник);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыСхемыКомпоновки(НастройкиПриемник, ИдентификаторСтрокиСхемы)
	
	СтрокаСхемы = СхемыКомпоновкиДанных.НайтиПоИдентификатору(ИдентификаторСтрокиСхемы);
	Если СтрокаСхемы = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	КомпоновщикИсточник = ЭтаФорма[СтрокаСхемы.ИмяНастроек];
	НастройкиИсточник = КомпоновщикИсточник.ПолучитьНастройки();
	
	Если Ложь Тогда 
		КомпоновщикПриемник = Новый КомпоновщикНастроекКомпоновкиДанных;
		НастройкиПриемник = КомпоновщикПриемник.ПолучитьНастройки();
		КомпоновщикИсточник = Новый КомпоновщикНастроекКомпоновкиДанных;
		НастройкиИсточник = КомпоновщикИсточник.ПолучитьНастройки();
	КонецЕсли;
	
	// Копируем отбор
	СкопироватьОтборКомпоновкиДанных(НастройкиПриемник.Отбор, НастройкиИсточник.Отбор, Ложь);
	
	// Устанавливаем параметры
	Для Каждого УстановленныйПараметр Из НастройкиИсточник.ПараметрыДанных.Элементы Цикл
		Если УстановленныйПараметр.Использование Тогда 
			НастройкиПриемник.ПараметрыДанных.УстановитьЗначениеПараметра(УстановленныйПараметр.Параметр, УстановленныйПараметр.Значение);
		КонецЕсли;	
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СкопироватьОтборКомпоновкиДанных(Приемник, Источник, ОчищатьПриемник = Истина, УдалятьПредставлениеГруппы = Ложь, УдалятьНеиспользуемые = Истина) 
	
	Если ОчищатьПриемник Тогда 
		Приемник.Элементы.Очистить();
	КонецЕсли;
	
	Для Каждого ЭлементОтбораИсточник Из Источник.Элементы Цикл
		
		Если УдалятьНеиспользуемые И (Не ЭлементОтбораИсточник.Использование) Тогда
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

&НаСервере
Процедура ЗаполнитьСтруктуруВыводаСхемыКомпоновки(НастройкиПриемник, ИдентификаторСтрокиСхемы)
	
	СтрокаСхемы = СхемыКомпоновкиДанных.НайтиПоИдентификатору(ИдентификаторСтрокиСхемы);
	Если СтрокаСхемы = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	КомпоновщикИсточник = ЭтаФорма[СтрокаСхемы.ИмяНастроек];
	НастройкиИсточник = КомпоновщикИсточник.ПолучитьНастройки();
	
	Если Ложь Тогда 
		КомпоновщикПриемник = Новый КомпоновщикНастроекКомпоновкиДанных;
		НастройкиПриемник = КомпоновщикПриемник.ПолучитьНастройки();
		КомпоновщикИсточник = Новый КомпоновщикНастроекКомпоновкиДанных;
		НастройкиИсточник = КомпоновщикИсточник.ПолучитьНастройки();
	КонецЕсли;
	
	// Выбранные поля
	Для Каждого ВыбранноеПолеИсточник Из НастройкиИсточник.Выбор.Элементы Цикл
		
		ПолеУжеСуществует = Ложь;
		Для Каждого ВыбранноеПолеПриемник Из НастройкиПриемник.Выбор.Элементы Цикл 
			Если ВыбранноеПолеПриемник.Поле = ВыбранноеПолеИсточник.Поле Тогда 
				ПолеУжеСуществует = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ПолеУжеСуществует Тогда 
			Прервать;
		КонецЕсли;
		
		ВыбранноеПолеПриемник = НастройкиПриемник.Выбор.Элементы.Добавить(ТипЗнч(ВыбранноеПолеИсточник));
		ЗаполнитьЗначенияСвойств(ВыбранноеПолеПриемник, ВыбранноеПолеИсточник);
		
	КонецЦикла;
	
	// Поле, куда будут помещены настройки
	Если НастройкиПриемник.Структура.Количество() = 0 Тогда
		ГруппаНастроекПриемник = НастройкиПриемник;
	Иначе
		ГруппаНастроекПриемник = НастройкиПриемник.Структура[0];
	КонецЕсли;
	
	ЗаполнитьСтруктуруВыводаСхемыКомпоновкиРекурсивно(ГруппаНастроекПриемник, НастройкиИсточник)
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтруктуруВыводаСхемыКомпоновкиРекурсивно(ГруппаПриемник, ГруппаИсточник)
	
	Если Ложь Тогда 
		КомпоновщикПриемник = Новый КомпоновщикНастроекКомпоновкиДанных;
		НастройкиПриемник = КомпоновщикПриемник.ПолучитьНастройки();
		КомпоновщикИсточник = Новый КомпоновщикНастроекКомпоновкиДанных;
		НастройкиИсточник = КомпоновщикИсточник.ПолучитьНастройки();
		ГруппаПриемник = НастройкиПриемник;
		ГруппаИсточник = НастройкиИсточник;
	КонецЕсли;
	
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

&НаКлиенте
Процедура СкопироватьОтборВПользовательскиеНастройкиРекурсивно(ЭлементыПользовательскихНастроек, ЭлементыОтбора)

	Для Каждого ЭлементОтбора Из ЭлементыОтбора Цикл
		
		Если Не ЗначениеЗаполнено(ЭлементОтбора.ИдентификаторПользовательскойНастройки) Тогда 
			Продолжить;
		КонецЕсли;
		
		ЭлементНастроек = ЭлементыПользовательскихНастроек.Найти(ЭлементОтбора.ИдентификаторПользовательскойНастройки);
		Если ЭлементНастроек = Неопределено Тогда 
			Продолжить;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ЭлементНастроек, ЭлементОтбора);
		Если ТипЗнч(ЭлементыОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда 
			СкопироватьОтборВПользовательскиеНастройкиРекурсивно(ЭлементОтбора.Элементы, ЭлементыПользовательскихНастроек);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПересчитатьВысотуТаблицыПользовательскихНастроек(ИдентификаторСтрокиСхемы)
	
	СтрокаСхемы = СхемыКомпоновкиДанных.НайтиПоИдентификатору(ИдентификаторСтрокиСхемы);
	Если СтрокаСхемы = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	КомпоновщикНастроек = ЭтаФорма[СтрокаСхемы.ИмяНастроек];
		
	Элементы[СтрокаСхемы.ИмяЭлементаНастроек].ВысотаВСтрокахТаблицы = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Количество();
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьНаСервере()
	
	Результат.Очистить();
	
	Если СхемыКомпоновкиДанных.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	ОсновнаяСхема = ПолучитьИзВременногоХранилища(ОсновнаяСхемаКомпоновкиАдрес);	
	НастройкиОснСхемы = ОсновнаяСхемаКомпоновкиКомпоновщик.ПолучитьНастройки();
	
	// Объединяем настройки компоновок
	СтруктураНастроек = ПолучитьОбъединенныеНастройкиКомпоновки(Ложь, Истина, Ложь);
	НастройкиОснСхемы = СтруктураНастроек.НастройкиКомпоновки;
	
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;

	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(ОсновнаяСхема, НастройкиОснСхемы, ДанныеРасшифровки);
	 
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина); 
	 
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(Результат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	РезультатСхема = ПоместитьВоВременноеХранилище(ОсновнаяСхема, УникальныйИдентификатор);
	РезультатРасшифровка = ПоместитьВоВременноеХранилище(ДанныеРасшифровки, УникальныйИдентификатор);
	
	Если НастройкаРасположенияОтборов <> Перечисления.ВидыНастроекРасположенияОтборовФормыПодбораКлиентов.НаНесколькихСтраницах Тогда 
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаРезультатОднаСтраница;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьОбъединенныеНастройкиКомпоновки(ПереинициализироватьКомпоновщик = Истина, ЗаполнятьПараметры = Истина, ЗаполнятьСтруктуруВывода = Истина)
	
	ОсновнаяСхема = ПолучитьИзВременногоХранилища(ОсновнаяСхемаКомпоновкиАдрес);
	
	Если ПереинициализироватьКомпоновщик Тогда 
		КомпоновщикНастроекОснСхемы = Новый КомпоновщикНастроекКомпоновкиДанных;
		КомпоновщикНастроекОснСхемы.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(ОсновнаяСхема)); 
		КомпоновщикНастроекОснСхемы.ЗагрузитьНастройки(ОсновнаяСхема.НастройкиПоУмолчанию);
		НастройкиОснСхемы = КомпоновщикНастроекОснСхемы.ПолучитьНастройки();
	Иначе
		НастройкиОснСхемы = ОсновнаяСхемаКомпоновкиКомпоновщик.ПолучитьНастройки();
	КонецЕсли;
	
	// Очищаем отбор
	НастройкиОснСхемы.Отбор.Элементы.Очистить();
	
	// Заполнение параметров из пользовательских настроек
	Если ЗаполнятьПараметры Тогда 
		Для Сч = 0 По СхемыКомпоновкиДанных.Количество() - 1 Цикл
			
			СтрокаСхемы = СхемыКомпоновкиДанных[Сч];
			Если Не СтрокаСхемы.Используется Тогда 
				Продолжить;
			КонецЕсли;
			ЗаполнитьПараметрыСхемыКомпоновки(НастройкиОснСхемы, СтрокаСхемы.ПолучитьИдентификатор());
			
		КонецЦикла;
	КонецЕсли;
	
	// Заполнение структуры вывода
	Если ЗаполнятьСтруктуруВывода Тогда 
		Для Сч = 1 По СхемыКомпоновкиДанных.Количество() - 1 Цикл
			
			СтрокаСхемы = СхемыКомпоновкиДанных[Сч];
			Если Не СтрокаСхемы.Используется Тогда 
				Продолжить;
			КонецЕсли;
			ЗаполнитьСтруктуруВыводаСхемыКомпоновки(НастройкиОснСхемы, СтрокаСхемы.ПолучитьИдентификатор());
			
		КонецЦикла;
	КонецЕсли;
	
	Возврат Новый Структура("АдресСхемы, НастройкиКомпоновки", ОсновнаяСхемаКомпоновкиАдрес, НастройкиОснСхемы);
	
КонецФункции

&НаСервере
Функция ЗагрузитьКлиентовНаСервере()
	
	Если СхемыКомпоновкиДанных.Количество() = 0 Тогда 
		Возврат Новый Массив;
	КонецЕсли;
	
	ОсновнаяСхема = ПолучитьИзВременногоХранилища(ОсновнаяСхемаКомпоновкиАдрес);	
	НастройкиОснСхемы = ОсновнаяСхемаКомпоновкиКомпоновщик.ПолучитьНастройки();
	
	// Объединяем настройки компоновок
	СтруктураНастроек = ПолучитьОбъединенныеНастройкиКомпоновки(Ложь, Истина, Ложь);
	НастройкиОснСхемы = СтруктураНастроек.НастройкиКомпоновки;
	
	Если Ложь Тогда 
		НастройкиОснСхемы = ОсновнаяСхемаКомпоновкиКомпоновщик.ПолучитьНастройки();
	КонецЕсли;
	
	// Очищаем структуру вывода и добавляем одну группировку - клиент
	НастройкиОснСхемы.Структура.Очистить();
	НастройкиОснСхемы.Выбор.Элементы.Очистить();
	
	ГруппировкаКлиент = НастройкиОснСхемы.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	ПолеГруппировки = ГруппировкаКлиент.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных("Клиент");
	ПолеГруппировки.Использование = Истина;
	АвтоПоле = ГруппировкаКлиент.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
    АвтоПоле.Использование = Истина;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(ОсновнаяСхема, НастройкиОснСхемы,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	 
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, , , Истина); 
	 
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ТаблицаКлиентов = ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	Возврат ТаблицаКлиентов.ВыгрузитьКолонку("Клиент");
	
КонецФункции
	
#КонецОбласти

#Область СохранениеНастроек

&НаКлиенте
Процедура СохранитьНастройки(Команда)
	
	Если ЗначениеЗаполнено(СохраненныеНастройки) Тогда
		СохранитьНастройкиНаСервере(СохраненныеНастройки);
		НастройкиМодифицированы = Ложь;
	Иначе
		ИмяНастройки = "";
		Если ВвестиСтроку(ИмяНастройки, НСтр("ru='Введите наименование новой настройки'")) Тогда 
			СохранитьНастройкиНаСервере(ИмяНастройки);
			НастройкиМодифицированы = Ложь;
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиНаСервере(ИмяНастройки)
	
	СтруктураОбъединенныхНастроек = ПолучитьОбъединенныеНастройкиКомпоновки(Ложь, Истина, Ложь);
	
	ТаблицаНастроек = СхемыКомпоновкиДанных.Выгрузить();
	ТаблицаНастроек.Колонки.Добавить("НастройкиКомпоновки");
	Для Каждого СтрокаНастроек Из ТаблицаНастроек Цикл 
		СтрокаНастроек.НастройкиКомпоновки = ЭтаФорма[СтрокаНастроек.ИмяНастроек].ПолучитьНастройки();	
	КонецЦикла;
	
	СохраненныеНастройки = Справочники.НастройкиПоискаКлиентов.ЗаписатьНастройкиПоиска(
		ИмяНастройки, ТаблицаНастроек, СтруктураОбъединенныхНастроек.НастройкиКомпоновки, НастройкаРасположенияОтборов);
	
КонецПроцедуры

&НаКлиенте
Процедура СохраненныеНастройкиПриИзменении(Элемент)
	
	НастройкиМодифицированы = Ложь;
	Если ЗначениеЗаполнено(СохраненныеНастройки) Тогда 
		ЗагрузитьСохраненныеНастройкиНаСервере(Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСохраненныеНастройкиНаСервере(ПереинициализироватьСхемыКомпоновки = Ложь)
	
	НастройкаРасположенияОтборов = СохраненныеНастройки.НастройкаРасположенияОтборов;
	Если Не ЗначениеЗаполнено(НастройкаРасположенияОтборов) Тогда 
		НастройкаРасположенияОтборов = Перечисления.ВидыНастроекРасположенияОтборовФормыПодбораКлиентов.НаНесколькихСтраницах;
	КонецЕсли;
	
	Если ПереинициализироватьСхемыКомпоновки Тогда 
		ИнициализироватьСхемыКомпоновки();
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СохраненныеНастройки) Тогда 
		Возврат;
	КонецЕсли;
	
	// Настройки основной схемы
	НастройкиОсновнойСхемы = СохраненныеНастройки.КомпоновщикНастроекОсновнойСхемы.Получить();
	Если НастройкиОсновнойСхемы <> Неопределено Тогда 
		ОсновнаяСхемаКомпоновкиКомпоновщик.ЗагрузитьНастройки(НастройкиОсновнойСхемы);
	КонецЕсли;
		
	Для Каждого СтрокаНастроек Из СохраненныеНастройки.НастройкиОтдельныхСхемКомпоновки Цикл
		
		СтрокаСхемы = СхемыКомпоновкиДанных.НайтиСтроки(Новый Структура("ИмяСхемы", СтрокаНастроек.ИмяСхемы));
		Если СтрокаСхемы.Количество() = 0 Тогда 
			Продолжить;
		КонецЕсли;
		СтрокаСхемы = СтрокаСхемы[0];
		
		КомпоновщикНастроек = ЭтаФорма[СтрокаСхемы.ИмяНастроек];
		КомпоновщикНастроек.ЗагрузитьНастройки(СтрокаНастроек.НастройкиКомпоновки.Получить());
		КомпоновщикНастроек.Восстановить();
		
		Если СтрокаСхемы.Основная И Параметры.СписокКлиентов.Количество() > 0 Тогда 
			РаботаСФормамиСервер.УстановитьОтборСписка("Клиент", Параметры.СписокКлиентов, КомпоновщикНастроек.Настройки);
		КонецЕсли;
		
		ПересчитатьВысотуТаблицыПользовательскихНастроек(СтрокаСхемы.ПолучитьИдентификатор());
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьНастройкиПоУмолчанию(Команда)
	
	НастройкиМодифицированы = Ложь;
	ИнициализироватьСхемыКомпоновки();
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСобытия(Команда)
	
	мсКлиенты = ЗагрузитьКлиентовНаСервере();
	Если мсКлиенты.Количество() = 0 Тогда 
		ПоказатьПредупреждение(, НСтр("ru='Нет отобранных клиентов!'"), 30);
		Возврат;
	КонецЕсли;
	
	сзКлиенты = Новый СписокЗначений;
	сзКлиенты.ЗагрузитьЗначения(мсКлиенты);
	ПараметрыФормы = Новый Структура("СписокКлиентов", сзКлиенты);
	ОткрытьФорму(ПутьКОбработке + ".Форма.СозданиеСобытий", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗадачи(Команда)
	
	мсКлиенты = ЗагрузитьКлиентовНаСервере();
	Если мсКлиенты.Количество() = 0 Тогда 
		ПоказатьПредупреждение(, НСтр("ru='Нет отобранных клиентов!'"), 30);
		Возврат;
	КонецЕсли;
	
	сзКлиенты = Новый СписокЗначений;
	сзКлиенты.ЗагрузитьЗначения(мсКлиенты);
	ПараметрыФормы = Новый Структура("СписокКлиентов", сзКлиенты);
	ОткрытьФорму(ПутьКОбработке + ".Форма.ФормаСозданияЗадач", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьРассылкуSMS(Команда)
	
	ЗапомненнаяНастройка = Параметры.РассылкаSMS;
	Параметры.РассылкаSMS = Истина;
	мсКлиенты = ЗагрузитьКлиентовНаСервере();
	Параметры.РассылкаSMS = ЗапомненнаяНастройка;
	Если мсКлиенты.Количество() = 0 Тогда 
		Предупреждение("Нет отобранных клиентов!", 30);
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("СписокПолучателей", мсКлиенты);
	ОткрытьФорму("Документ.Рассылка.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьРассылкуEMAIL(Команда)
	
	ЗапомненнаяНастройка = Параметры.РассылкаEmail;
	Параметры.РассылкаEmail = Истина;
	мсКлиенты = ЗагрузитьКлиентовНаСервере();
	Параметры.РассылкаEmail = ЗапомненнаяНастройка;
	Если мсКлиенты.Количество() = 0 Тогда 
		Предупреждение("Нет отобранных клиентов!", 30);
		Возврат;
	КонецЕсли;
	
	сзКлиенты = Новый СписокЗначений;
	сзКлиенты.ЗагрузитьЗначения(мсКлиенты);
	ПараметрыФормы = Новый Структура("СписокПолучателей", мсКлиенты);
	ОткрытьФорму("Документ.РассылкаПисемEmail.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЛистыОжидания(Команда)
	
	мсКлиенты = ЗагрузитьКлиентовНаСервере();
	Если мсКлиенты.Количество() = 0 Тогда 
		Предупреждение("Нет отобранных клиентов!", 30);
		Возврат;
	КонецЕсли;
	
	сзКлиенты = Новый СписокЗначений;
	сзКлиенты.ЗагрузитьЗначения(мсКлиенты);
	ПараметрыФормы = Новый Структура("СписокКлиентов", сзКлиенты);
	ОткрытьФорму(ПутьКОбработке + ".Форма.ФормаСозданияЛистовОжидания", ПараметрыФормы);

КонецПроцедуры

&НаКлиенте
Процедура СоздатьСписокОбзвона(Команда)
	
	мсКлиенты = ЗагрузитьКлиентовНаСервере();
	Если мсКлиенты.Количество() = 0 Тогда 
		Предупреждение("Нет отобранных клиентов!", 30);
		Возврат;
	КонецЕсли;
	
	сзКлиенты = Новый СписокЗначений;
	сзКлиенты.ЗагрузитьЗначения(мсКлиенты);
	ПараметрыФормы = Новый Структура("СписокКлиентов", сзКлиенты);
	ОткрытьФорму("Документ.бит_СписокОбзвона.Форма.ФормаДокумента", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти
