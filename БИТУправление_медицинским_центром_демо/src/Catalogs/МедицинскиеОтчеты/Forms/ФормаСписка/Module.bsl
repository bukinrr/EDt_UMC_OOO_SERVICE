#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	РежимВыбора = Параметры.РежимВыбора;
		
	УстановитьВидимостьСпискаГруппСправочника();
	
	#Область РасширенныйФункционал
	МедицинскаяОтчетность.СправочникМедицинскиеОтчеты_ПриСозданииНаСервере(ЭтотОбъект);
	#КонецОбласти
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	
	Элементы.Список.ТекущаяСтрока = НовыйОбъект;
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьНовый(Команда)
	
	СоздатьНовыйОтчет();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЖурнал(Команда)
	
	ПараметрыФормы = Новый Структура;
	
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		ПараметрыФормы .Вставить("Отбор", Новый Структура("ИсточникОтчета", Элементы.Список.ТекущиеДанные.ИсточникОтчета));
	КонецЕсли;
	
	ОткрытьФорму("Документ.МедицинскийОтчет.ФормаСписка", ПараметрыФормы);
		
КонецПроцедуры

&НаКлиенте
Процедура Добавить(Команда)
	ОткрытьФорму("Справочник.МедицинскиеОтчеты.ФормаОбъекта",, ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВидимостьСпискаГруппСправочника()
	
	ЕстьГруппы = Ложь;
	
	Выборка = Справочники.МедицинскиеОтчеты.Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Выборка.ЭтоГруппа Тогда
			ЕстьГруппы = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Элементы.Дерево.Видимость = ЕстьГруппы;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьОтчет(НаименованиеОтчета = Неопределено)
	Перем Расширение;
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	МедицинскиеОтчеты.ЭтоГруппа КАК ЭтоГруппа,
		|	МедицинскиеОтчеты.ИсточникОтчета КАК ИсточникОтчета,
		|	МедицинскиеОтчеты.Наименование КАК Наименование
		|ИЗ
		|	Справочник.МедицинскиеОтчеты КАК МедицинскиеОтчеты
		|ГДЕ
		|	МедицинскиеОтчеты.Ссылка = &ТекущаяСтрока
		|");
	
	Запрос.УстановитьПараметр("ТекущаяСтрока", Элементы.Список.ТекущаяСтрока);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Выборка.Следующий();
	
	Если Выборка.ЭтоГруппа Тогда
		Возврат "ЭтоГруппа";
	КонецЕсли;
	
	ФайлВнешнегоОтчета = Выборка.ИсточникОтчета;
	
	НаименованиеИзСправочника = Выборка.Наименование;
	МетаОтчет = Метаданные.Отчеты.Найти(ФайлВнешнегоОтчета);
	Если МетаОтчет <> Неопределено И МетаОтчет.ОсновнаяФорма <> Неопределено Тогда
			
		НаименованиеОтчета = МетаОтчет.ОсновнаяФорма.Синоним;
			
	Иначе
			
		НаименованиеОтчета = НаименованиеИзСправочника;
			
	КонецЕсли;
	
	ПравоДоступаКОтчету = МедицинскаяОтчетностьВызовСервера.ПравоДоступаКМедицинскомуОтчету(ФайлВнешнегоОтчета);
	Если ПравоДоступаКОтчету = Ложь Тогда
				
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru='Недостаточно прав.'");
		Сообщение.Сообщить();
		
		Возврат Неопределено;
		
	ИначеЕсли ПравоДоступаКОтчету = Неопределено Тогда
				
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru='Отчет не найден.'");
		Сообщение.Сообщить();
		
		Возврат Неопределено;
		
	КонецЕсли;
		
	Если Метаданные.Документы.Найти(ФайлВнешнегоОтчета) <> Неопределено Тогда // это внутренний отчет-документ
			
		ВнутреннийОтчет = Документы[ФайлВнешнегоОтчета];
		Возврат "Документ." + Сред(ВнутреннийОтчет, СтрНайти(ВнутреннийОтчет, ".") + 1) + ".Форма.ФормаДокумента";
			
	КонецЕсли;
	
	// Возвращает типы ВнешнийОтчетОбъект.<Имя> и ОтчетМенеджер.<Имя>
	ТекОтчет = МедицинскаяОтчетность.МедОтчеты(ФайлВнешнегоОтчета);
	Если ТекОтчет = Неопределено Тогда
				
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru='Не удалось получить отчет.'");
		Сообщение.Сообщить();
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	// ВнешнийОтчетОбъект или ОтчетМенеджер
	Возврат ?(СтрНайти(ТекОтчет, "ОтчетМенеджер") > 0, "Отчет.", "ВнешнийОтчет.") + Сред(ТекОтчет, СтрНайти(ТекОтчет, ".") + 1) + ".Форма.ОсновнаяФорма";

КонецФункции

&НаКлиенте
Функция СоздатьНовыйОтчет()
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru='Выберите отчет.'");
		Сообщение.Сообщить();
		
		Возврат Ложь;
		
	КонецЕсли;
	
	НаименованиеОтчета = "";
	ТекФорма = ПолучитьОтчет(НаименованиеОтчета);
	
	Если ТекФорма = Неопределено
		ИЛИ ТекФорма = "ЭтоГруппа" Тогда
		Возврат ТекФорма;
	КонецЕсли;
	
	// Сначала попробуем найти его среди открытых стартовых форм.
	// Необходимо при работе под Веб-клиентом для предотвращения
	// открытия нескольких стартовых форм одного отчета
	НайденоОкно = Ложь;
	МедицинскаяОтчетностьКлиент.ВебКлиентНайтиАктивизироватьОкно(ТекФорма, ЭтаФорма, НайденоОкно);
	Если НайденоОкно <> Неопределено Тогда
		Если НайденоОкно Тогда
			
			Возврат Ложь;
			
		КонецЕсли;
	КонецЕсли;
	
	ТекФорма = ПолучитьФорму(ТекФорма, , ЭтаФорма, ТекФорма);
	
	Если ТекФорма = Неопределено Тогда
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru='Не удалось открыть отчет.'");
		Сообщение.Сообщить();
		
		Возврат Ложь;
		
	КонецЕсли;
	
	ТекФорма.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	ТекФорма.Открыть();
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ПоказатьПодробнуюИнформацию(Команда)
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		
		ПоказатьПредупреждение(,НСтр("ru='Выберите отчет.'"));
		
		Возврат;
		
	КонецЕсли;
	
	Если Элементы.Список.ТекущиеДанные.ЭтоГруппа Тогда
				
		ПоказатьПредупреждение(,НСтр("ru='Функция недоступна для группы отчетов.'"));
		
		Возврат;
		
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("НачальноеЗначениеВыбора", Элементы.Список.ТекущаяСтрока);
	
	ФормаПодробнееОФормах = МедицинскаяОтчетностьКлиент.ПолучитьОбщуюФормуПоИмени("ПодробнееОбОтчете", ПараметрыФормы, ЭтаФорма);
	ФормаПодробнееОФормах.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	ФормаПодробнееОФормах.Открыть();

КонецПроцедуры

&НаКлиенте
Процедура СписокОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	
	Элементы.Список.ТекущаяСтрока = НовыйОбъект;
		
КонецПроцедуры

#КонецОбласти