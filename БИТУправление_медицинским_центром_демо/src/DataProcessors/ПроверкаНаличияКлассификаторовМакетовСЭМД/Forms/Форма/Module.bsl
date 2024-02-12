#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПроверитьНаСервере()
	СправочникиКонфигурации.Очистить();
	СправочникиМакетов.Очистить();
	ЗаполнитьПоСправочникамКОнфигурации();
	СписокФайлов = НайтиФайлы(ПутьКМакетам,"*.xml");
	Для каждого ФайлМакета Из СписокФайлов Цикл
		Попытка
			Макет = Новый ТекстовыйДокумент;
		    Макет.Прочитать(ФайлМакета.ПолноеИмя,КодировкаТекста.UTF8);
			РаспарситьМакет(Макет.ПолучитьТекст());	
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьОбОшибке("Ошибка! Не обработан: " + ФайлМакета.Имя);
		КонецПопытки; 	
	КонецЦикла; 
	ПроверитьНаличие();
	СправочникиКонфигурации.Сортировать("OID");
	СправочникиМакетов.Сортировать("OID");
КонецПроцедуры

&НаСервере
Процедура ПроверитьНаличие()
	Для каждого СтрокаОИД Из СправочникиМакетов Цикл
		СтрокаОИД.ЕстьСправочник = (СправочникиКонфигурации.НайтиСтроки(Новый Структура("OID",СтрокаОИД.OID)).Количество() > 0);
	КонецЦикла; 	
КонецПроцедуры
 
&НаСервере
Процедура ЗаполнитьПоСправочникамКОнфигурации()
	Для каждого ЭлементСостава Из Метаданные.ОбщиеРеквизиты.УИДЕГИСЗ.Состав Цикл
		Справочник = ЭлементСостава.Метаданные;
		Менеджер = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(Справочник.ПолноеИмя());
		Если Строка(Справочник) = "Классификаторы Министерства Здравоохранения" Тогда
			Для каждого ВидКлассификатора Из Перечисления.ВидыКлассификаторовМинЗдрава Цикл
				Попытка
					ОидСправочника = Менеджер.ПолучитьOIDСправочника(ВидКлассификатора);
					Если СправочникиКонфигурации.НайтиСтроки(Новый Структура("OID",ОидСправочника)).Количество() = 0 Тогда
						НоваяСтрока = СправочникиКонфигурации.Добавить();	
						НоваяСтрока.OID = ОидСправочника;	
					КонецЕсли; 	
				Исключение
				КонецПопытки; 
				
				Попытка
					СписокАльтернативныхOID = Менеджер.ПолучитьАльтернативныеOID(ВидКлассификатора);
					Для каждого АльтернативныйOID Из СписокАльтернативныхOID Цикл
						Если СправочникиКонфигурации.НайтиСтроки(Новый Структура("OID",АльтернативныйOID)).Количество() = 0 Тогда
							НоваяСтрока = СправочникиКонфигурации.Добавить();	
							НоваяСтрока.OID = АльтернативныйOID;	
						КонецЕсли;
					КонецЦикла;
				Исключение
				КонецПопытки;		
			КонецЦикла; 	
		Иначе
			Попытка
				ОидСправочника = Менеджер.ПолучитьOIDСправочника();
				Если СправочникиКонфигурации.НайтиСтроки(Новый Структура("OID",ОидСправочника)).Количество() = 0 Тогда
					НоваяСтрока = СправочникиКонфигурации.Добавить();	
					НоваяСтрока.OID = ОидСправочника;	
				КонецЕсли;
			Исключение
			КонецПопытки; 
			
			Попытка
				СписокАльтернативныхOID = Менеджер.ПолучитьАльтернативныеOID();
				Для каждого АльтернативныйOID Из СписокАльтернативныхOID Цикл
					Если СправочникиКонфигурации.НайтиСтроки(Новый Структура("OID",АльтернативныйOID)).Количество() = 0 Тогда
						НоваяСтрока = СправочникиКонфигурации.Добавить();	
						НоваяСтрока.OID = АльтернативныйOID;	
					КонецЕсли;	
				КонецЦикла;
			Исключение
			КонецПопытки;
		КонецЕсли;
		 	
	КонецЦикла; 
	
	Элементы.ДекорацияКоличествоВКонфигурации.Заголовок = "Количество" + Строка(СправочникиКонфигурации.Количество());
КонецПроцедуры
 
&НаСервере
Функция РаспарситьМакет(МакетXML) Экспорт
	
	МакетXML = СтрЗаменить(МакетXML,"xsi:type","xsitype");
	
	Парсер = Новый ЧтениеXML;
    Парсер.УстановитьСтроку(МакетXML);
    Построитель = Новый ПостроительDOM;
    Документ = Построитель.Прочитать(Парсер);
	
	ОбойтиУзел(Документ.ЭлементДокумента);
	
	Элементы.ДекорацияКоличествоВМакетах.Заголовок = "Количество" + Строка(СправочникиМакетов.Количество());
			
КонецФункции

&НаСервере
Процедура ОбойтиУзел(Узел)
	ДочерниеУзлы = Узел.ДочерниеУзлы;
	Для каждого ДочернийУзел Из ДочерниеУзлы Цикл
		ОбойтиУзел(ДочернийУзел);		
	КонецЦикла;
	Если Узел.Атрибуты <> Неопределено Тогда
		Для каждого Артибут Из Узел.Атрибуты Цикл
			Если Артибут.Имя = "codeSystem" Тогда
				Если СправочникиМакетов.НайтиСтроки(Новый Структура("OID",Артибут.Значение)).Количество() = 0 Тогда
					НоваяСтрока = СправочникиМакетов.Добавить();
					НоваяСтрока.OID = Артибут.Значение;
					
					АтрибутИмя = Узел.Атрибуты.ПолучитьИменованныйЭлемент("codeSystemName");
					Если АтрибутИмя <> Неопределено Тогда
						НоваяСтрока.Имя = АтрибутИмя.Значение;
					КонецЕсли;
				КонецЕсли; 		
			КонецЕсли; 	
		КонецЦикла;  	
	КонецЕсли; 
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Проверить(Команда)
	ПроверитьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПапкуМакетов(Команда)
	Режим = РежимДиалогаВыбораФайла.ВыборКаталога; 
	ДиалогОткрытия = Новый ДиалогВыбораФайла(Режим);       
    ДиалогОткрытия.Каталог = "";       
    ДиалогОткрытия.МножественныйВыбор = Ложь;     
    ДиалогОткрытия.Заголовок = "Выберите каталог"; 
            
    Если ДиалогОткрытия.Выбрать() Тогда 
    	ПутьКМакетам = ДиалогОткрытия.Каталог; 
    КонецЕсли; 
КонецПроцедуры

#КонецОбласти
