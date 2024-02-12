#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПолучитьОписи(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;	
	КонецЕсли;
	
	ЗаполнитьТаблицу();
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьПоступление(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;	
	КонецЕсли;
	
	Поступление = СоздатьДокументПоступлениеПоОписям(ОтправленныеОписи, Прейскурант, Контрагент, Комментарий, СтатьяЗатрат);
	
	ОткрытьЗначение(Поступление);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	СформироватьКомментарий();
КонецПроцедуры

&НаКлиенте
Процедура ЛабораторияПриИзменении(Элемент)
	СформироватьКомментарий();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТаблицу()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
	                      |	ОписьЗаказовЛабораторииСписокЗаказов.Ссылка КАК Ссылка,
	                      |	ОписьЗаказовЛабораторииСписокЗаказов.ЗаказВЛабораторию КАК ЗаказВЛабораторию
	                      |ПОМЕСТИТЬ Описи
	                      |ИЗ
	                      |	Документ.ОписьЗаказовЛаборатории.СписокЗаказов КАК ОписьЗаказовЛабораторииСписокЗаказов
	                      |ГДЕ
	                      |	НЕ ОписьЗаказовЛабораторииСписокЗаказов.ЗаказВЛабораторию.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияЗаказовЛаборатории.Отменен)
	                      |	И НЕ ОписьЗаказовЛабораторииСписокЗаказов.ЗаказВЛабораторию.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияЗаказовЛаборатории.Создан)
	                      |	И ОписьЗаказовЛабораторииСписокЗаказов.Ссылка.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	                      |	И ОписьЗаказовЛабораторииСписокЗаказов.Ссылка.Лаборатория = &Лаборатория
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	Описи.Ссылка КАК Ссылка,
	                      |	СУММА(ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Цена, 0)) КАК Сумма
	                      |ИЗ
	                      |	Описи КАК Описи
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказВоВнешнююЛабораторию.Исследования КАК ЗаказВоВнешнююЛабораториюИсследования
	                      |		ПО (ЗаказВоВнешнююЛабораториюИсследования.Ссылка = Описи.ЗаказВЛабораторию)
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&Период, Прейскурант = &Прейскурант) КАК ЦеныНоменклатурыСрезПоследних
	                      |		ПО (ЗаказВоВнешнююЛабораториюИсследования.Номенклатура = ЦеныНоменклатурыСрезПоследних.Номенклатура)
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	Описи.Ссылка");
	
	Запрос.УстановитьПараметр("Период", Период.ДатаОкончания);
	Запрос.УстановитьПараметр("ДатаНачала", Период.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", Период.ДатаОкончания);
	Запрос.УстановитьПараметр("Лаборатория", Лаборатория);
	Запрос.УстановитьПараметр("Прейскурант", Прейскурант);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Стр = ОтправленныеОписи.Добавить();	
		Стр.Опись = Выборка.Ссылка;
		Стр.Сумма = Выборка.Сумма;
	КонецЦикла;	
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьКомментарий()
	
	Если ЗначениеЗаполнено(Лаборатория) И ЗначениеЗаполнено(Период) Тогда
		Комментарий = "Описи за период от " + Формат(Период.ДатаНачала, "ДФ=dd.MM.yyyy") + " до " 
			+ Формат(Период.ДатаОкончания, "ДФ=dd.MM.yyyy") + " по лаборатории " + Лаборатория;		    	
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СоздатьДокументПоступлениеПоОписям(Знач Описи, Прейскурант, Контрагент, Комментарий, СтатьяЗатрат)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Поступление = Документы.ПоступлениеТоваровУслуг.СоздатьДокумент();
	
	Поступление.Комментарий 			= Комментарий;
	Поступление.Контрагент 				= Контрагент;
	Поступление.Филиал 					= УправлениеНастройками.ПолучитьФилиалПоУмолчаниюПользователя();
	Поступление.Дата 					= ТекущаяДатаСеанса();
	Поступление.ВариантПолучателяЗатрат = Перечисления.ВариантыПолучателяПоступившихЗатрат.НоменклатураЗатраты;
	
	СуммаДокумента = 0;
	
	Для Каждого СтрОписи Из Описи Цикл
		Для Каждого СтрЗаказы Из СтрОписи.Опись.СписокЗаказов Цикл
			Для Каждого	СтрИсследования Из СтрЗаказы.ЗаказВЛабораторию.Исследования Цикл	
				
				Рез = Поступление.Услуги.Найти(СтрИсследования.Номенклатура, "Номенклатура");
				
				Если Рез = Неопределено Тогда
									
					Стр = Поступление.Услуги.Добавить();
					Стр.Номенклатура= СтрИсследования.Номенклатура;
					Стр.Цена 		= Ценообразование.ПолучитьЦену(Прейскурант, Стр.Номенклатура).Цена;
					Стр.Количество	= 1;
					Стр.Сумма 		= Стр.Цена * Стр.Количество;
					Стр.СтатьяЗатрат= СтатьяЗатрат;
					
					СуммаДокумента 	= СуммаДокумента + Стр.Сумма;

				Иначе	
					
					Рез.Количество 	= Рез.Количество + 1;
					Рез.Сумма 		= Рез.Цена * Рез.Количество; 
					
					СуммаДокумента 	= СуммаДокумента + Рез.Цена;
					
				КонецЕсли;
				
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	Поступление.СуммаДокумента = СуммаДокумента;
	
	Поступление.Записать();
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Поступление.Ссылка;
	
КонецФункции

#КонецОбласти