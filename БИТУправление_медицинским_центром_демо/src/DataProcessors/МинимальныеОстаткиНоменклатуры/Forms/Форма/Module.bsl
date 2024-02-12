
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	НачалоПериода = НачалоГода(ТекущаяДата());
	ОкончаниеПериода = КонецДня(ТекущаяДата());
	ВремяДоставки = 7;
	ВыводитьВсе = Истина;
	макет = ПолучитьДанныеИзМакета("Макет");
	АдресСхемы = ПоместитьВоВременноеХранилище(макет, УникальныйИдентификатор);	
	
	Настройки.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы));
	Настройки.ЗагрузитьНастройки(макет.НастройкиПоУмолчанию);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПериодКоВсем(Команда)
	Для Каждого СтрокаТЧ Из ТЧОстатки Цикл
		СтрокаТЧ.НачалоПериода = НачалоПериода;
		СтрокаТЧ.ОкончаниеПериода = ОкончаниеПериода;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ВремяКоВсем(Команда)
	Для Каждого СтрокаТЧ Из ТЧОстатки Цикл
		СтрокаТЧ.ВремяДоставки = ВремяДоставки;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СкладКоВсем(Команда)
	Для Каждого СтрокаТЧ Из ТЧОстатки Цикл
		СтрокаТЧ.Склад = Склад;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура РасчитатьМинОстатки(Команда)
	ВычислитьМинимальныеОстатки();	
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	ЗаписатьМинОстатки();
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНоменклатуру(Команда)
	ПрименитьОтборПоНоменклатуре();
	ПериодКоВсем(Неопределено);
	СкладКоВсем(Неопределено);
	ВремяКоВсем(Неопределено);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ВыводитьРасходуемуюПриИзменении(Элемент)
	ВыводитьВсе = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьСМинимальнымиПриИзменении(Элемент)
	ВыводитьВсе = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьВсеПриИзменении(Элемент)
	ВыводитьРасходуемую = Ложь;
	ВыводитьСМинимальными = Ложь;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Округление в меньшую сторону.
&НаСервере
Функция ОкрМен (Число)
	Возврат Окр(Число-0.5,0,1);
КонецФункции

&НаСервере
Функция ПолучитьДанныеИзМакета(ИмяМакета)
	Обработка = РеквизитФормыВЗначение("Объект");
	Возврат Обработка.ПолучитьМакет(ИмяМакета);	
КонецФункции

&НаСервере
Процедура ВычислитьМинимальныеОстатки()
	
	мУчетнаяПолитика = УправлениеНастройками.ПолучитьУчетнуюПолитику();
	Для Каждого СтрокаТЧ Из ТЧОстатки Цикл
		Если мУчетнаяПолитика.ВестиУчетПоХарактеристикам И СтрокаТЧ.Номенклатура.ВестиУчетПоХарактеристикам И НЕ СтрокаТЧ.Номенклатура.ВестиУчетПоСериям Тогда  
			СверятьХарактеристики = Истина;
			Если НЕ ЗначениеЗаполнено(СтрокаТЧ.ХарактеристикаНоменклатуры) И мУчетнаяПолитика.ЗапретНезаполненияХарактеристик Тогда 
				Запрос = Новый Запрос;
				Запрос.Текст = 
				"ВЫБРАТЬ
				|	ХарактеристикиНоменклатуры.Ссылка КАК Количество
				|ИЗ
				|	Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
				|ГДЕ
				|	ХарактеристикиНоменклатуры.Владелец = &Владелец";
				
				Запрос.УстановитьПараметр("Владелец", СтрокаТЧ.Номенклатура);
				
				РезультатЗапроса = Запрос.Выполнить();
				
				Если НЕ РезультатЗапроса.Пустой() Тогда
					Продолжить; 
				КонецЕсли;
				
			КонецЕсли;
		Иначе
			СверятьХарактеристики = Ложь;	
		КонецЕсли;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПартииТоваровНаСкладахОстаткиИОбороты.Номенклатура КАК Номенклатура,
		|	СУММА(ЕСТЬNULL(ПартииТоваровНаСкладахОстаткиИОбороты.КоличествоРасход, 0)) КАК Расход,
		|	МАКСИМУМ(ЕСТЬNULL(ПартииТоваровНаСкладахОстаткиИОбороты.КоличествоРасход, 0)) КАК Максимум
		|ИЗ
		|	РегистрНакопления.ПартииТоваровНаСкладах.ОстаткиИОбороты(
		|			&НачалоПериода,
		|			&ОкончаниеПериода,
		|			День,
		|			,
		|			Номенклатура = &Номенклатура
		|				И Склад = &Склад) КАК ПартииТоваровНаСкладахОстаткиИОбороты
		|ГДЕ
		|	ВЫБОР
		|			КОГДА &СверятьХарактеристики
		|				ТОГДА ПартииТоваровНаСкладахОстаткиИОбороты.ХарактеристикаНоменклатуры = &ХарактеристикаНоменклатуры
		|			ИНАЧЕ ИСТИНА
		|		КОНЕЦ
		|
		|СГРУППИРОВАТЬ ПО
		|	ПартииТоваровНаСкладахОстаткиИОбороты.Номенклатура";
		Запрос.УстановитьПараметр("СверятьХарактеристики", СверятьХарактеристики);
		Запрос.УстановитьПараметр("Номенклатура",СтрокаТЧ.Номенклатура);
		Запрос.УстановитьПараметр("ХарактеристикаНоменклатуры",СтрокаТЧ.ХарактеристикаНоменклатуры);
		Запрос.УстановитьПараметр("НачалоПериода",НачалоДня(СтрокаТЧ.НачалоПериода));
		Запрос.УстановитьПараметр("ОкончаниеПериода",КонецДня(СтрокаТЧ.ОкончаниеПериода));
		Запрос.УстановитьПараметр("Склад",СтрокаТЧ.Склад);
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			СтрокаТЧ.РасходЗаПериод = Выборка.Расход;
			СтрокаТЧ.МаксимальныйРасход = Выборка.Максимум;
			ДнейВПериоде = (СтрокаТЧ.ОкончаниеПериода - СтрокаТЧ.НачалоПериода)/(24*60*60) + 1;
			Если ДнейВПериоде < 7 Тогда
				ЕстьСуббота = Ложь;
				ЕстьВоскресенье = Ложь;
				сч = СтрокаТЧ.НачалоПериода; 
				Пока сч <= СтрокаТЧ.ОкончаниеПериода Цикл
					Если ДеньНедели(сч) = 6 Тогда
						ЕстьСуббота = Истина;
					ИначеЕсли ДеньНедели(сч) = 7 Тогда
						ЕстьВоскресенье = Истина;
					КонецЕсли;
					сч = сч + 24*60*60;
				КонецЦикла;
				Если ЕстьСуббота И Не Суббота Тогда
					ДнейВПериоде = ДнейВПериоде - 1;
				КонецЕсли;
				Если ЕстьВоскресенье И Не Воскресенье Тогда
					ДнейВПериоде = ДнейВПериоде - 1;
				КонецЕсли;
				Если ДнейВПериоде = 0 Тогда
					ОбщегоНазначения.СообщитьПользователю("Рассчет мин. остатков для """ + СтрокаТЧ.Номенклатура +  """ не произведен. В периоде нулевое количество дней, т.к. в настройках отключен учет выходных.");
					Продолжить;
				КонецЕсли;
			Иначе
				ДнейВПериоде = ОкрМен(ДнейВПериоде - ?(Суббота,0,ДнейВПериоде/7) - ?(Воскресенье,0,ДнейВПериоде/7));
			КонецЕсли;
			СтрокаТЧ.РасходВДень = Выборка.Расход/ДнейВПериоде;
			СтрокаТЧ.МинимальныйОстаток = (СтрокаТЧ.МаксимальныйРасход - СтрокаТЧ.РасходВДень)*СтрокаТЧ.ВремяДоставки;
			СтрокаТЧ.ТочкаПредупреждения = СтрокаТЧ.РасходВДень*СтрокаТЧ.ВремяДоставки+СтрокаТЧ.МинимальныйОстаток;
		Иначе
			СтрокаТЧ.РасходЗаПериод = 0;
			СтрокаТЧ.РасходВДень = 0;
			СтрокаТЧ.ТочкаПредупреждения = 0;
			СтрокаТЧ.МинимальныйОстаток = 0;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Нет данных для расчета мин. остатков позиции номенклатуры """+
							  СтрокаТЧ.Номенклатура+"""";
			Сообщение.Сообщить();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьМинОстатки()
	Для Каждого СтрокаТЧ Из ТЧОстатки Цикл
		МЗ = РегистрыСведений.МинимальныеОстаткиНоменклатуры.СоздатьМенеджерЗаписи();
		МЗ.Номенклатура = СтрокаТЧ.Номенклатура;
		МЗ.ХарактеристикаНоменклатуры = СтрокаТЧ.ХарактеристикаНоменклатуры;
		МЗ.Склад = СтрокаТЧ.Склад;
		МЗ.Прочитать();
		Если МЗ.Выбран() Тогда
			МЗ.Удалить();
		КонецЕсли;
		МЗ.Номенклатура = СтрокаТЧ.Номенклатура;
		МЗ.ХарактеристикаНоменклатуры = СтрокаТЧ.ХарактеристикаНоменклатуры;
		МЗ.Склад = СтрокаТЧ.Склад;
		МЗ.ТочкаПредупреждения = СтрокаТЧ.ТочкаПредупреждения;
		МЗ.Количество = СтрокаТЧ.МинимальныйОстаток;
		МЗ.ВремяДоставки = СтрокаТЧ.ВремяДоставки;
		МЗ.Записать();
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПрименитьОтборПоНоменклатуре()
	мУчетнаяПолитика = УправлениеНастройками.ПолучитьУчетнуюПолитику();
	
	СхемаКомпоновкиДанных = ПолучитьДанныеИзМакета("Макет");
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
    КомпоновщикНастроек.ЗагрузитьНастройки(Настройки.ПолучитьНастройки());

	ПараметрыКомп = КомпоновщикНастроек.Настройки.ПараметрыДанных; 
    ПараметрыКомп.УстановитьЗначениеПараметра("НачалоПериода", НачалоДня(НачалоПериода));
   	ПараметрыКомп.УстановитьЗначениеПараметра("ОкончаниеПериода", КонецДня(ОкончаниеПериода));
	ПараметрыКомп.УстановитьЗначениеПараметра("ВыводитьРасходуемые", ВыводитьРасходуемую);
	ПараметрыКомп.УстановитьЗначениеПараметра("ВыводитьСМинимальными", ВыводитьСМинимальными);
	ПараметрыКомп.УстановитьЗначениеПараметра("ВыводитьВсе", ВыводитьВсе);
	ПараметрыКомп.УстановитьЗначениеПараметра("УПУчетПоХарактеристикам", мУчетнаяПолитика.ВестиУчетПоХарактеристикам);
	ПараметрыКомп.УстановитьЗначениеПараметра("ЗапретРасходаБезХарактеристики", мУчетнаяПолитика.ЗапретНезаполненияХарактеристик);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, КомпоновщикНастроек.ПолучитьНастройки(),,, Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки);	

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ТабРезультат = Новый ТаблицаЗначений;
	ТабРезультат = ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных, Истина);
	ТЧОстатки.Загрузить(ТабРезультат);	
КонецПроцедуры

#КонецОбласти
