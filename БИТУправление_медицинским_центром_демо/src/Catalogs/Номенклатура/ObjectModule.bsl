#Область ПрограммныйИнтерфейс

// Возвращает структуру обязательных / уникальных реквизитов элемента.
// Если ДляЭлемента = Истина, возвращаемая структура содержит реквизиты для проверки элемента.
// Если ДляГруппы = Истина, аналогично для группы.
//
// Параметры:
//	ДляЭлемента	- Булево - проверяется элемент справочника.
//	ДляГруппы	- Булево - проверяется группа справочника.
//
// Возвращаемое значение:
//	Произвольный - Возвращаемая структура содержит строковые идентификаторы реквизитов или вложенные структуры 
//					для табличных частей.
//					Для реквизита значение структуры содержит число 1-Обязательный, 3-Уникальный.
//
Функция ПолучитьОбязательныеРеквизиты(ДляЭлемента=Истина, ДляГруппы=Ложь) Экспорт
	ОбязательныеРеквизиты=Новый Структура();
	ОбязательныеРеквизиты.Вставить("Наименование",1);

    Если ДляЭлемента Тогда
		ОбязательныеРеквизиты.Вставить("ВидНоменклатуры",1);
		Если ВидНоменклатуры <> Перечисления.ВидыНоменклатуры.Набор Тогда
			ОбязательныеРеквизиты.Вставить("КатегорияВыработки",1);
		КонецЕсли;
		Если ВидНоменклатуры = Перечисления.ВидыНоменклатуры.Материал Тогда
			ОбязательныеРеквизиты.Вставить("БазоваяЕдиницаИзмерения",1);
		КонецЕсли;                                                             
	КонецЕсли;
	
	Если ДляГруппы Тогда
	КонецЕсли;

	Возврат ОбязательныеРеквизиты;
КонецФункции

// Проверяет корректность заполнения объекта.
// 
// Параетры:
//	Ошибки - Строка, В случае некорректного заполнения функция формирует строку описанием возникших ошибок "Ошибки".
//	ДопРеквизиты - Произвольный, может быть передана структура ДопРеквизиты с дополнительными реквизитами для проверки.
//	Заполнение	 - Булево, флаг необходимости проверки заполнения обязательных реквизитов.
//	Уникальность - Булево, флаг необходимости проверки уникальности элемента в разрезе реквизитов, отмеченных в структуре как 
//		контролируемые на уникальность.
//
// Параметры:
//  Ошибки - Строка - По умолчанию ""
//  ДопРеквизиты - Неопределено - По умолчанию Неопределено
//  Заполнение - Булево - По умолчанию Истина
//  Уникальность - Булево - По умолчанию Истина
//
// Возвращаемое значение:
//	Булево - Возвращает Истина если все заполнено корректно и Ложь иначе.
//
Функция ПроверитьКорректность(Ошибки="", ДопРеквизиты=Неопределено, Заполнение=Истина, Уникальность=Истина) Экспорт
	#Если Не ТолстыйКлиентОбычноеприложение Тогда
	Возврат ОбщегоНазначенияСервер.ПроверитьКорректностьЗаполненияСправочника(ЭтотОбъект, Ошибки, ДопРеквизиты, Заполнение, Уникальность);
	#КонецЕсли 
КонецФункции

// Функция ОбновитьСопутствующиеУнаследованные
//
// Возвращаемое значение:
//  Произвольный.
//
Функция ОбновитьСопутствующиеУнаследованные() Экспорт
	
	ЗапросРодители = Новый Запрос;
	ЗапросРодители.Текст = "ВЫБРАТЬ
	|	ТаблНоменклатура.Ссылка КАК Номенклатура
	|ИЗ
	|	Справочник.Номенклатура КАК ТаблНоменклатура
	|ГДЕ
	|	ТаблНоменклатура.Ссылка <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|	И ТаблНоменклатура.Код = &Код
	|ИТОГИ ПО
	|	Номенклатура ТОЛЬКО ИЕРАРХИЯ";
	
	ЗапросРодители.УстановитьПараметр("Код", Код);
	
	Родители = ЗапросРодители.Выполнить().Выгрузить();
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	НоменклатураСопутствующиеТовары.Номенклатура КАК Номенклатура,
	               |	НоменклатураСопутствующиеТовары.Ссылка КАК Владелец,
	               |	НоменклатураСопутствующиеТовары.Номенклатура.Код КАК Код,
	               |	НоменклатураСопутствующиеТовары.Номенклатура.Артикул КАК Артикул,
	               |	НоменклатураСопутствующиеТовары.Номенклатура.ВидНоменклатуры КАК ВидНоменклатуры
	               |ИЗ
	               |	Справочник.Номенклатура.СопутствующиеТовары КАК НоменклатураСопутствующиеТовары
	               |ГДЕ
	               |	НоменклатураСопутствующиеТовары.Ссылка В(&Табл1)
	               |	И НоменклатураСопутствующиеТовары.Номенклатура.Код <> &Код
	               |	И НоменклатураСопутствующиеТовары.Ссылка.Код <> &Код";
				   
	Запрос.УстановитьПараметр("Табл1",Родители); 
	Запрос.УстановитьПараметр("Код", Код);
	
	ТЗ  = Запрос.Выполнить().Выгрузить();
	
	Если ТЗ.Количество() > 0 Тогда
		
		мас = Новый Массив();
		
		Для Каждого СтрТЗ Из ТЗ Цикл
			стр = Новый Структура("Код", СтрТЗ.Код);
			стр.Вставить("Номенклатура", СтрТЗ.Номенклатура);
			стр.Вставить("Артикул", СтрТЗ.Артикул);
			стр.Вставить("ВидНоменклатуры", СтрТЗ.ВидНоменклатуры);
			стр.Вставить("Владелец", СтрТЗ.Владелец);
			мас.Добавить(стр);
		КонецЦикла;
		
		Возврат мас;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции	

#КонецОбласти

#Область ОбработчикиСобытий

// Стандартный обработчик заполнения при вводе нового на основании.
//
// Параметры:
//  Основание - Произвольный.
//
Процедура ОбработкаЗаполнения(Основание) Экспорт
	
	РодительскаяГруппа=ЭтотОбъект.Родитель;
	Если ЭтотОбъект.ЭтоГруппа=Ложь Тогда
		Пока РодительскаяГруппа<>Новый(ТипЗнч(РодительскаяГруппа)) Цикл
			Если РодительскаяГруппа.ВидНоменклатуры<>Новый(ТипЗнч(ВидНоменклатуры)) И ВидНоменклатуры=Новый(ТипЗнч(ВидНоменклатуры)) Тогда
				ВидНоменклатуры = РодительскаяГруппа.ВидНоменклатуры;
			КонецЕсли; 
			РодительскаяГруппа=РодительскаяГруппа.Родитель;
		КонецЦикла; 

		Если ВидНоменклатуры=Неопределено Тогда
			ВидНоменклатуры = Перечисления.ВидыНоменклатуры.Услуга;
		КонецЕсли;
	КонецЕсли; 
	
КонецПроцедуры

// Стандартный обработчик ПередЗаписью элемента справочника.
Процедура ПередЗаписью(Отказ)
	
	Если ВидНоменклатуры <> Перечисления.ВидыНоменклатуры.Материал И
		 ЗначениеЗаполнено(ЕдиницаХраненияОстатков) 
	Тогда
		ЕдиницаХраненияОстатков = Справочники.ЕдиницыИзмерения.ПустаяСсылка();
	КонецЕсли;
	
	Если ВидНоменклатуры = Перечисления.ВидыНоменклатуры.Набор И ВестиУчетПоХарактеристикам Тогда
		ВестиУчетПоХарактеристикам = Ложь;
    КонецЕсли;
	
	Если Не ОбменДанными.Загрузка Тогда
		Ошибки = "";
		Если Не ПометкаУдаления 
			И Не ПроверитьКорректность(Ошибки) 
			Тогда
			#Если ТолстыйКлиентОбычноеприложение Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьОбОшибке(Ошибки, Отказ);
			#Иначе
				ОбщегоНазначения.СообщитьОбОшибке(Ошибки, Отказ);
			#КонецЕсли 
		КонецЕсли;
	КонецЕсли;
	
	Если Не ОбменДанными.Загрузка
		И ЭтоНовый()
		И КодМедУслуги = 0
	Тогда
		КодМедУслуги = 1;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти