
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтаФорма.мВестиУчетПоХарактеристикам = УправлениеНастройками.ПолучитьПараметрУчетнойПолитики("ВестиУчетПоХарактеристикам");
	ЭтаФорма.Элементы.Характеристика.Видимость = ЭтаФорма.мВестиУчетПоХарактеристикам;
	ЭтаФорма.Элементы.ФормаУдалить.Доступность = ПравоДоступа("Удаление",Метаданные.Справочники.СтруктураПрайслистов);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Элементы.Характеристика.Видимость = ЭтаФорма.мВестиУчетПоХарактеристикам;
КонецПроцедуры

&НаКлиенте
Процедура ДействияФормыЗаполнитьПоСправочнику(Кнопка)
	
	Если ПрайсПуст() ИЛИ Вопрос(НСтр("ru = 'Текущий прайс-лист не пустой! Новые элементы будут добавлены без удаления существующих. Все равно заполнить?'"),РежимДиалогаВопрос.ОКОтмена)=КодВозвратаДиалога.ОК Тогда
		
		
		ДействияФормыЗаполнитьПоСправочникуСервер();
		Элементы.СправочникСписок.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПрайсПуст()
	Выб = Справочники.СтруктураПрайслистов.Выбрать();
	Возврат НЕ Выб.Следующий();
КонецФункции	

&НаСервере
Процедура ДействияФормыЗаполнитьПоСправочникуСервер()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Ссылка,
	|	Номенклатура.ЭтоГруппа КАК ЭтоГруппа,
	|	Номенклатура.НаименованиеПолное КАК Текст,
	|	ВЫБОР
	|		КОГДА Номенклатура.ВидНоменклатуры <> ЗНАЧЕНИЕ(перечисление.видыноменклатуры.материал)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтоУслуга,
	|	Номенклатура.ЕдиницаХраненияОстатков,
	|	Номенклатура.ЕдиницаТоваров,
	|	Номенклатура.ВестиУчетПоХарактеристикам
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	НЕ Номенклатура.ПометкаУдаления
	|	И НЕ Номенклатура.ЭтоГруппа
	|	И НЕ Номенклатура.Архив
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЭтоГруппа
	|ИТОГИ ПО
	|	Ссылка ТОЛЬКО ИЕРАРХИЯ";
	
	ДеревоНоменклатуры = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	ТекРодитель = Справочники.СтруктураПрайслистов.ПустаяСсылка();
	
	РазобратьУровеньДерева(ДеревоНоменклатуры.Строки, ТекРодитель);
	
	
КонецПроцедуры	

&НаКлиенте
Процедура ДействияФормыДобавитьИзСправочника(Кнопка)
	
	Перем ТекРодитель;
	
	ПараметрыФормы = Новый Структура("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.ГруппыИЭлементы);
	ВыбранноеЗначение = ОткрытьФормуМодально("Справочник.Номенклатура.ФормаВыбора", ПараметрыФормы);
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		
		ТекущиеДанные = Элементы.СправочникСписок.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда
			Если ТекущиеДанные.ЭтоГруппа Тогда
				ТекРодитель = ТекущиеДанные.Ссылка;
			Иначе
				ТекРодитель = ТекущиеДанные.Родитель;
			КонецЕсли;
		КонецЕсли;

		ДействияФормыДобавитьИзСправочникаСервер(ТекРодитель, ВыбранноеЗначение); 
		Элементы.СправочникСписок.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДействияФормыДобавитьИзСправочникаСервер(ТекРодитель, ВыбранноеЗначение)
	
	Если ТекРодитель = Неопределено Тогда
		ТекРодитель = Справочники.СтруктураПрайслистов.ПустаяСсылка();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Группа",ВыбранноеЗначение);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Ссылка,
	|	Номенклатура.ЭтоГруппа КАК ЭтоГруппа,
	|	Номенклатура.НаименованиеПолное КАК Текст,
	|	ВЫБОР
	|		КОГДА Номенклатура.ВидНоменклатуры <> ЗНАЧЕНИЕ(перечисление.ВидыНоменклатуры.Материал)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтоУслуга,
	|	Номенклатура.ЕдиницаХраненияОстатков,
	|	Номенклатура.ЕдиницаТоваров,
	|	Номенклатура.ВестиУчетПоХарактеристикам
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Ссылка В ИЕРАРХИИ(&Группа)";
	
	Если ВыбранноеЗначение.ЭтоГруппа Тогда
		Запрос.Текст = Запрос.Текст + "
		|	И Номенклатура.Ссылка <> &Группа
		|	И НЕ Номенклатура.ПометкаУдаления
		|	И НЕ Номенклатура.Архив";
	КонецЕсли;
	
	Запрос.Текст = Запрос.Текст + "
	|ИТОГИ ПО
	|	Ссылка ТОЛЬКО ИЕРАРХИЯ";
	
	ДеревоНоменклатуры = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	Строки = ДеревоНоменклатуры.Строки;
	Пока Строки[0].Ссылка <> ВыбранноеЗначение Цикл
		Строки = Строки[0].Строки;
	КонецЦикла;
	
	РазобратьУровеньДерева(Строки, ТекРодитель);

КонецПроцедуры

&НаСервере
Процедура РазобратьУровеньДерева(Строки,ТекРодитель)
	
	Для Каждого Строка Из Строки Цикл
		Если не ЗначениеЗаполнено(Строка.Ссылка) Тогда
			
			РазобратьУровеньДерева(Строка.Строки,ТекРодитель);
			
		ИначеЕсли Строка.ЭтоГруппа Тогда
			
			Группа = Справочники.СтруктураПрайслистов.СоздатьГруппу();
			Группа.Родитель = ТекРодитель;
			Группа.Наименование = Строка.Ссылка.Наименование;
			Группа.НаименованиеПолное = Группа.Наименование;
			Группа.УстановитьНовыйКод();
			Группа.Записать();
			РазобратьУровеньДерева(Строка.Строки,Группа.Ссылка)
			
		Иначе
			
			Если Строка.ЭтоУслуга Тогда
				Характеристики = Неопределено;
				Если мВестиУчетПоХарактеристикам и 
					Строка.ВестиУчетПоХарактеристикам и 
					ЕстьХарактеристикиВНоменклатуре(Строка.Ссылка, Характеристики)	
				Тогда
					Для Каждого Характеристика Из Характеристики Цикл
						ДобавитьЭлементЛиста(ТекРодитель, Строка,Характеристика,Характеристика.Наименование);
					КонецЦикла;
				Иначе
					ДобавитьЭлементЛиста(ТекРодитель, Строка);
				КонецЕсли;
			Иначе
				ДобавитьЭлементЛиста(ТекРодитель, Строка);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьЭлементЛиста(Родитель, Строка, Характеристика = Неопределено, НаименованиеХарактеристики = "")
	
	Элемент = Справочники.СтруктураПрайслистов.СоздатьЭлемент();
	Элемент.Родитель = Родитель;
	Элемент.НаименованиеПолное = Строка.Текст + ?(ПустаяСтрока(НаименованиеХарактеристики),""," "+НаименованиеХарактеристики);
	Элемент.Наименование = Элемент.НаименованиеПолное;
	Элемент.Номенклатура = Строка.Ссылка;
	Элемент.Характеристика = Характеристика;
	Если ЗначениеЗаполнено(Строка.ЕдиницаТоваров) Тогда
		Элемент.ЕдиницаИзмерения = Строка.ЕдиницаТоваров;
	Иначе
		Элемент.ЕдиницаИзмерения = Строка.ЕдиницаХраненияОстатков;
	КонецЕсли;
	Элемент.УстановитьНовыйКод();
	Элемент.Записать();
	
КонецПроцедуры

Функция ЕстьХарактеристикиВНоменклатуре(Номенклатура, Характеристики)
	
	Результат = Ложь;
	Выб = Справочники.ХарактеристикиНоменклатуры.Выбрать(,Номенклатура);
	Пока Выб.Следующий() Цикл
		
		Если Характеристики = Неопределено Тогда
			Характеристики = Новый Массив;
		КонецЕсли;
		
		Характеристики.Добавить(Выб.Ссылка);
		
		Результат = Истина;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ПереместитьВверх(Команда)
	
	ПереместитьКлиент(1);
	
КонецПроцедуры

&НаКлиенте
Процедура  ПереместитьКлиент(Направление)
	
	Если Элементы.СправочникСписок.ТекущиеДанные <> Неопределено Тогда
		
		ТекКод = Элементы.СправочникСписок.ТекущиеДанные.Код;
		ТекРодитель = Элементы.СправочникСписок.ТекущиеДанные.Родитель;
		ТекСсылка = Элементы.СправочникСписок.ТекущиеДанные.Ссылка;
		ПереместитьСервер(ТекКод, ТекСсылка, ТекРодитель, Направление);
		Элементы.СправочникСписок.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры	

// Направление: 1 - вверх, 2 - вниз
&НаСервере
Процедура ПереместитьСервер(Код, Ссылка, Родитель, Направление = 1)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВсеСоседи.Ссылка,
	|	ВсеСоседи.Код КАК Код
	|ИЗ
	|	(ВЫБРАТЬ
	|		СтруктураПрайслистов.Ссылка КАК Ссылка,
	|		СтруктураПрайслистов.Код КАК Код
	|	ИЗ
	|		Справочник.СтруктураПрайслистов КАК СтруктураПрайслистов
	|	ГДЕ
	|		СтруктураПрайслистов.Родитель = &Родитель
	|		) КАК ВсеСоседи
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			МАКСИМУМ(СтруктураПрайслистов.Код) КАК Код
	|		ИЗ
	|			Справочник.СтруктураПрайслистов КАК СтруктураПрайслистов
	|		ГДЕ
	|			СтруктураПрайслистов.Родитель = &Родитель
	|			И СтруктураПрайслистов.Код < &Код
	|) КАК Максимум
	|		ПО ВсеСоседи.Код = Максимум.Код
	|
	|УПОРЯДОЧИТЬ ПО
	|	Код";
	
	Запрос.УстановитьПараметр("Код", Код);
	Запрос.УстановитьПараметр("Родитель", Родитель);
	
	Если Направление = 2 Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "<", ">");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "МАКСИМУМ", "МИНИМУМ");
	КонецЕсли;
	
	Результат = Запрос.Выполнить().Выгрузить();			
	
	Если Результат.Количество() > 0 Тогда
		
		НовыйТекКод = Результат[0].Ссылка.Код;
		Об1 = Результат[0].Ссылка.ПолучитьОбъект();
		Об1.Код = Код;
		
		Об2 = Ссылка.ПолучитьОбъект();
		Об2.Код = НовыйТекКод;
		Попытка
			Об2.Записать();
			Об1.Записать();
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
		КонецПопытки;
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиенте
Процедура СправочникСписокПриАктивизацииСтроки(Элемент)
	
	Если Элементы.СправочникСписок.ТекущиеДанные <> Неопределено Тогда
		Элементы.Характеристика.ТолькоПросмотр = Элементы.СправочникСписок.ТекущиеДанные.ЭтоГруппа;
		Элементы.ЕдиницаИзмерения.ТолькоПросмотр = Элементы.СправочникСписок.ТекущиеДанные.ЭтоГруппа;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВниз(Команда)
	ПереместитьКлиент(2);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДерево(Команда)
	Элементы.СправочникСписок.Обновить();
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УдалитьНаСервере()
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	СтруктураПрайслистов.Ссылка КАК Ссылка,
	                      |	СтруктураПрайслистов.ЭтоГруппа КАК ЭтоГруппа,
	                      |	СтруктураПрайслистов.ПометкаУдаления,
	                      |	ЕСТЬNULL(СтруктураПрайслистов.Родитель.ПометкаУдаления, ЛОЖЬ) КАК РодительПометкаУдаления
	                      |ИЗ
	                      |	Справочник.СтруктураПрайслистов КАК СтруктураПрайслистов
	                      |ГДЕ
	                      |	СтруктураПрайслистов.ПометкаУдаления
	                      |ИТОГИ ПО
	                      |	Ссылка ИЕРАРХИЯ");
	Выборка = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	УдалитьДанные(Выборка);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция УдалитьДанные(УзелДерева)
	
	Для Каждого СтрокаДерева Из УзелДерева.Строки Цикл
		
		УдалитьДанные(СтрокаДерева);
		
		ВыборкаПоСтроке = Справочники.СтруктураПрайслистов.ВыбратьИерархически(СтрокаДерева.Ссылка);
		Если Не ВыборкаПоСтроке.Следующий() Тогда 
			Попытка
				обВыб = СтрокаДерева.Ссылка.ПолучитьОбъект();
				обВыб.Удалить();
			Исключение
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;
	
КонецФункции

&НаКлиенте
Процедура Удалить(Команда)
	
	Ответ = Вопрос(НСтр("ru = 'Все записи, помеченные на удаление, будут удалены. Продолжить?'"), РежимДиалогаВопрос.ДаНет,0,,"Удаление помеченных объектов");
	Если Ответ = КодВозвратаДиалога.Да Тогда 
		УдалитьНаСервере();
		Элементы.СправочникСписок.Обновить();
	Иначе 
		Возврат
	КонецЕсли;

КонецПроцедуры

