#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ПереноситьИерархиюГруппИсходногоСправочника = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьНоменклатуруНаОсновеМУ(Команда) 
	Попытка
		Если КатегорияВыработки.Пустая() Тогда
			ПоказатьПредупреждение(,НСтр("ru = 'Не заполнена специализация для простановки в добавляемую номенклатуру!'"),30,НСтр("ru = 'Внимание!'"));
		Иначе
			Состояние(НСтр("ru='Идёт выполнение операции.'"));
			СоздатьНоменклатуруНаОсновеМассива(Параметры.ИсходныеДанные, КатегорияВыработки, Родитель);
			ПоказатьПредупреждение(,НСтр("ru = 'Операция завершена!'"),30);
			Закрыть();
		КонецЕсли;
	Исключение
	КонецПопытки;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СоздатьНоменклатуруНаОсновеМассива(Знач ИсходныеДанные,Знач КатегорияВыработки,Знач Родитель)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НоменклатураМУ.Родитель КАК Родитель,
	|	НоменклатураМУ.ЭтоГруппа КАК ЭтоГруппа,
	|	НоменклатураМУ.Код КАК Код,
	|	НоменклатураМУ.Наименование КАК Наименование,
	|	Номенклатура.Ссылка КАК НоменклатураУМЦ,
	|	НоменклатураМУ.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.НоменклатураМедицинскихУслуг КАК НоменклатураМУ
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Номенклатура
	|		ПО (Номенклатура.НоменклатураМедицинскихУслуг = НоменклатураМУ.Ссылка И НЕ Номенклатура.ЭтоГруппа И НЕ НоменклатураМУ.ЭтоГруппа)
	|		
	|"; 
	
	Если ИсходныеДанные <> Неопределено Тогда
		Запрос.Текст = Запрос.Текст + " ГДЕ НоменклатураМУ.Ссылка В ИЕРАРХИИ(&ИсходныеДанные)";	
		Запрос.УстановитьПараметр("ИсходныеДанные", ИсходныеДанные);
	КонецЕсли;
	
	Запрос.Текст = Запрос.Текст + " УПОРЯДОЧИТЬ ПО НоменклатураМУ.ЭтоГруппа,НоменклатураМУ.Ссылка 
									| ИТОГИ ПО НоменклатураМУ.Ссылка ИЕРАРХИЯ АВТОУПОРЯДОЧИВАНИЕ";
	
	Результат = Запрос.Выполнить();
	
	КешГрупп = Новый Соответствие;
	ДобавитьСписокВыбранныхЭлементов(Результат, Родитель, КешГрупп);

КонецПроцедуры

&НаСервере
Процедура ДобавитьСписокВыбранныхЭлементов(Результат, Группа, КешГрупп)
	Выборка = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией,"Ссылка");
	
	Пока Выборка.Следующий() Цикл
		Если Не Выборка.ЭтоГруппа Или ПереноситьИерархиюГруппИсходногоСправочника Тогда
			Попытка
				Если Выборка.этогруппа Тогда
					ГруппаНоменклатуры = КешГрупп.Получить(Выборка.Код);
					Если ГруппаНоменклатуры = Неопределено Тогда
						ГруппаНоменклатуры = Справочники.Номенклатура.НайтиПоРеквизиту("Артикул", Выборка.Код);
						Если ЗначениеЗаполнено(ГруппаНоменклатуры) И ГруппаНоменклатуры.ЭтоГруппа Тогда
							КешГрупп.Вставить(Выборка.Код, ГруппаНоменклатуры);
						КонецЕсли; 
					КонецЕсли; 
				КонецЕсли; 
				
				ВыборкаНоменклатура = Выборка.Выбрать();
				ВыборкаНоменклатура.Следующий();
				
				Если Выборка.ЭтоГруппа И ЗначениеЗаполнено(ГруппаНоменклатуры) Тогда
					Объект = ГруппаНоменклатуры.ПолучитьОбъект();
				ИначеЕсли Не Выборка.ЭтоГруппа И ЗначениеЗаполнено(ВыборкаНоменклатура.НоменклатураУМЦ) Тогда
					Объект = ВыборкаНоменклатура.НоменклатураУМЦ.ПолучитьОбъект();
				ИначеЕсли Выборка.ЭтоГруппа Тогда 
					Объект = Справочники.Номенклатура.СоздатьГруппу();	
				Иначе
					Объект = Справочники.Номенклатура.СоздатьЭлемент();
					Объект.ВидНоменклатуры 		= Перечисления.ВидыНоменклатуры.Услуга;
					Объект.КатегорияВыработки 	= КатегорияВыработки;
					Объект.НаименованиеПолное 	= Выборка.Наименование;
				КонецЕсли; 	
				Объект.Артикул = Выборка.Код;
				Объект.Наименование = Выборка.Наименование;
				Объект.Родитель = Группа;
				
				Если Не Выборка.ЭтоГруппа Тогда
					Объект.НоменклатураМедицинскихУслуг = Выборка.Ссылка;	
				КонецЕсли; 
				
				Объект.Записать();
			
			Исключение 		
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
				Прервать;
			КонецПопытки;
			
			ДобавитьСписокВыбранныхЭлементов(Выборка, Объект.Ссылка, КешГрупп);
		Иначе
			ДобавитьСписокВыбранныхЭлементов(Выборка, Группа, КешГрупп);
		КонецЕсли; 						
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти
