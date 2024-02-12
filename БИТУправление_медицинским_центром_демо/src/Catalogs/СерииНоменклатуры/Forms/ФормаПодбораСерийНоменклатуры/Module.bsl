
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗапрашиватьКоличество = Ложь;
	ЗапрашиватьЦену = Ложь;
	
	Если Параметры.Свойство("Номенклатура") Тогда 
		Номенклатура = Параметры.Номенклатура;	
	КонецЕсли;	
	
	Если Параметры.Свойство("ХарактеристикаНоменклатуры") Тогда 
		ХарактеристикаНоменклатуры = Параметры.ХарактеристикаНоменклатуры;	
	КонецЕсли;	
	
	Если Параметры.Свойство("Склад") Тогда 
		Склад = Параметры.Склад;
	Иначе
		ТребуетсяАнализВладельцаФормыПриОткрытии = Истина;
	КонецЕсли;
	
	Если Параметры.Свойство("ЕдиницаИзмерения") Тогда 
		ЕдиницаИзмерения = ?(ЗначениеЗаполнено(Параметры.ЕдиницаИзмерения), Параметры.ЕдиницаИзмерения, Номенклатура.ЕдиницаХраненияОстатков);
	КонецЕсли;
	
	Если Параметры.Свойство("Количество") Тогда 
		Количество = Параметры.Количество;	
	КонецЕсли;
	
	Если Параметры.Свойство("ЭтоПодбор") Тогда 
		ЭтоПодбор = Параметры.ЭтоПодбор;	
	КонецЕсли;
	
	Если Параметры.Свойство("Действие") Тогда 
		Действие = Параметры.Действие;	
	КонецЕсли;
	
	Если Параметры.Свойство("ЗапрашиватьКоличество") Тогда 
		ЗапрашиватьКоличество = Параметры.ЗапрашиватьКоличество;	
	КонецЕсли;
	
	Если Параметры.Свойство("ЗапрашиватьЦену") Тогда 
		ЗапрашиватьЦену = Параметры.ЗапрашиватьЦену;	
	КонецЕсли;
	
	Если Параметры.Свойство("ТолькоВНаличии") Тогда 
		ТолькоВНаличии = Параметры.ТолькоВНаличии;
	Иначе
		ТолькоВНаличии = Истина;
		ТребуетсяАнализВладельцаФормыПриОткрытии = Истина;
	КонецЕсли;
		
	Элементы.Количество.Доступность = ЗапрашиватьКоличество;
	Элементы.ГруппаЦена.Видимость = ЗапрашиватьЦену;
	Элементы.ГруппаПодвал.Видимость = ЗапрашиватьКоличество Или ЗапрашиватьЦену;	
		
	Если ЗначениеЗаполнено(Номенклатура) Тогда
		Если Не ТребуетсяАнализВладельцаФормыПриОткрытии Тогда 
			ЗаполнитьСерииНоменклатурыСервер(Номенклатура, Склад);
		Иначе 
			ЗаполнятьНаКлиенте = Истина;
		КонецЕсли;
	Иначе
		Если Параметры.Свойство("Отбор") Тогда 
			Если ЗначениеЗаполнено(Параметры.Отбор.Владелец) Тогда 
				Номенклатура = Параметры.Отбор.Владелец;
			КонецЕсли;
		КонецЕсли;
		ЗаполнятьНаКлиенте = Истина;
	КонецЕсли;
	
	Параметры.Свойство("ТекущаяСтрока", СерияТекущая);
	
	Если Не ЗначениеЗаполнено(Номенклатура)
		Или Не Номенклатура.ВестиУчетПоСериям
	Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ЗначениеЗаполнено(Номенклатура) Тогда 
		ПоказатьПредупреждение(, НСтр("ru = 'Не указана номенклатура. Выбор серии не возможен!'"));
		Отказ = Истина;
	ИначеЕсли Не ЗначениеЗаполнено(ЕдиницаИзмерения) Тогда 
		Попытка
			ЕдиницаИзмерения = ЭтаФорма.ВладелецФормы.Родитель.ТекущиеДанные.ЕдиницаИзмерения;
		Исключение
			ПоказатьПредупреждение(, НСтр("ru = 'Не указана единица измерения. Выбор серии не возможен!'"));
			Отказ = Истина;
		КонецПопытки;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЭтоПодбор Тогда
		Попытка
			ХарактеристикаНоменклатуры = ЭтаФорма.ВладелецФормы.Родитель.ТекущиеДанные.ХарактеристикаНоменклатуры;
		Исключение
		КонецПопытки;
	КонецЕсли;

	// Определение склада и необходимости отбора по складу
	Если ТребуетсяАнализВладельцаФормыПриОткрытии Тогда
		ОпределитьПараметрыОстатковПоВладельцуФормы();
	КонецЕсли;
	
	Элементы.ГруппаТолькоВНаличии.Видимость = ЗначениеЗаполнено(Склад);
	
	Если ТолькоВНаличии И Не ЗначениеЗаполнено(Склад) Тогда
		ТолькоВНаличии = Ложь;
		ЗаполнятьНаКлиенте = Истина;
	КонецЕсли;
	
	Если ЗаполнятьНаКлиенте Тогда 
		ЗаполнитьСерииНоменклатурыСервер(Номенклатура, Склад);
	КонецЕсли;
		
	Если ЗапрашиватьЦену Тогда
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("ЕдиницаИзмерения",ЕдиницаИзмерения);
		СтруктураПараметров.Вставить("Количество"	   ,Количество);
		СтруктураПараметров.Вставить("Цена"			   ,Цена);
		СтруктураПараметров.Вставить("Номенклатура"	   ,Номенклатура);
		СтруктураПараметров.Вставить("ЗапрашиватьХарактеристику", Истина);
		СтруктураПараметров.Вставить("ХарактеристикаНоменклатуры", ХарактеристикаНоменклатуры);
		СтруктураПараметров.Вставить("Действие", Действие);
		
		РаботаСФормамиКлиент.мПолучитьЦенуВФормуКлиент(ЭтаФорма, СтруктураПараметров);		
	КонецЕсли;
	
	ОбновитьЗаголовокОстаток();
	
	Если ЗначениеЗаполнено(СерияТекущая) Тогда
		УстановитьТекущуюСтроку(СерияТекущая);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если Не ЭтоПодбор Тогда 	
		ОповеститьОВыборе(Элементы.Серии.ТекущиеДанные.СерияСсылка);
	Иначе
		СтруктураПараметров = Новый Структура("Структура");
		СтруктураПараметров.Вставить("Номенклатура", Номенклатура);
		СтруктураПараметров.Вставить("ХарактеристикаНоменклатуры", ХарактеристикаНоменклатуры);
		СтруктураПараметров.Вставить("СерияНоменклатуры", Элементы.Серии.ТекущиеДанные.СерияСсылка);
		СтруктураПараметров.Вставить("ЕдиницаИзмерения", ЕдиницаИзмерения);
		СтруктураПараметров.Вставить("Количество", Количество);
		СтруктураПараметров.Вставить("Цена", ?(ЗапрашиватьЦену, Цена, Неопределено));
		СтруктураПараметров.Вставить("Действие", Действие);
		Закрыть(СтруктураПараметров);	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Создать(Команда)
	
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", Новый Структура("Владелец", Номенклатура));
	ОткрытьФорму("Справочник.СерииНоменклатуры.ФормаОбъекта", ПараметрыФормы, ЭтаФорма,,,,
				Новый ОписаниеОповещения("ОбновитьСерииНоменклатуры", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура Изменить(Команда)
	
	ТекущиеДанные = Элементы.Серии.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("Ключ", ТекущиеДанные.СерияСсылка);
	ОткрытьФорму("Справочник.СерииНоменклатуры.ФормаОбъекта", ПараметрыФормы, ЭтаФорма,,,,
				Новый ОписаниеОповещения("ОбновитьСерииНоменклатуры", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ПоместитьВАрхив(Команда)
	
	ВыбранныеСтроки = Новый Массив;
	
	Для Каждого Строка Из Элементы.Серии.ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.Серии.ДанныеСтроки(Строка);
		ВыбранныеСтроки.Добавить(ДанныеСтроки.СерияСсылка);
	КонецЦикла;

	РаботаСДиалогамиКлиент.ПоместитьВАрхив(ВыбранныеСтроки);
	
	ЗаполнитьСерииНоменклатурыСервер(Номенклатура, Склад);
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьПоказатьАрхивные(Команда)

	ЭлементФормы = Элементы.СкрытьПоказатьАрхивные;
	
	ПоказыватьАрхивные = Не ЭлементФормы.Пометка;
	
	ЭлементФормы.Пометка = ПоказыватьАрхивные;
		
	ЗаполнитьСерииНоменклатурыСервер(Номенклатура, Склад);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ТолькоВНаличииПриИзменении(Элемент)
	
	ЗаполнитьСерииНоменклатурыСервер(Номенклатура, Склад);
	
КонецПроцедуры

&НаКлиенте
Процедура СерииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Не ЭтоПодбор Тогда 	
		ОповеститьОВыборе(Элемент.ТекущиеДанные.СерияСсылка);
	Иначе
		СтруктураПараметров = Новый Структура("Структура");
		СтруктураПараметров.Вставить("Номенклатура", Номенклатура);
		СтруктураПараметров.Вставить("ХарактеристикаНоменклатуры", ХарактеристикаНоменклатуры);
		СтруктураПараметров.Вставить("СерияНоменклатуры", Элемент.ТекущиеДанные.СерияСсылка);
		СтруктураПараметров.Вставить("ЕдиницаИзмерения", ЕдиницаИзмерения);
		СтруктураПараметров.Вставить("Количество", Количество);
		СтруктураПараметров.Вставить("Цена", ?(ЗапрашиватьЦену, Цена, Неопределено));
		СтруктураПараметров.Вставить("Действие", Действие);
		Закрыть(СтруктураПараметров);	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПриИзменении(Элемент)
	
	ОбновитьНадписьФормулаСумма();

КонецПроцедуры

&НаКлиенте
Процедура ЕдиницаИзмеренияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ЕдиницаИзмерения) Тогда 
		ЗаполнитьСерииНоменклатурыСервер(Номенклатура, Склад);
	КонецЕсли;
	ОбновитьНадписьФормулаСумма();
	ОбновитьЗаголовокОстаток();

КонецПроцедуры

&НаКлиенте
Процедура ЦенаПриИзменении(Элемент)
	
	ОбновитьНадписьФормулаСумма();
	
КонецПроцедуры

&НаКлиенте
Процедура ЕдиницаИзмеренияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	// Сначала пытаемся найти цену для новой единицы, если не найдется, то будет вычислена пропорционально коэффициентам.
	СтараяЦена = Цена;
	Если ЗначениеЗаполнено(ЕдиницаИзмерения) Тогда
		СтарыйКоэффициент = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЕдиницаИзмерения,"Коэффициент");
	Иначе
		СтарыйКоэффициент = 0;
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ЕдиницаИзмерения",ЕдиницаИзмерения);
	СтруктураПараметров.Вставить("Количество"	   ,Количество);
	СтруктураПараметров.Вставить("Цена"			   ,Цена);
	СтруктураПараметров.Вставить("Номенклатура"	   ,Номенклатура);
	СтруктураПараметров.Вставить("ЗапрашиватьХарактеристику", Истина);
	СтруктураПараметров.Вставить("ХарактеристикаНоменклатуры", ХарактеристикаНоменклатуры);
	
	РаботаСФормамиКлиент.мПолучитьЦенуВФормуКлиент(ЭтаФорма, СтруктураПараметров, ВыбранноеЗначение);
	Если Цена = 0 Тогда
		Цена = СтараяЦена;
		
		Если СтарыйКоэффициент <> 0 Тогда
			НовыйКоэффициент = ДопСерверныеФункции.ПолучитьРеквизит(ВыбранноеЗначение,"Коэффициент");
			Цена = Цена * НовыйКоэффициент / СтарыйКоэффициент;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОпределитьПараметрыОстатковПоВладельцуФормы()
	
	ТекущийВладелец = ЭтаФорма.ВладелецФормы;
	
	Попытка
		Пока ТипЗнч(ТекущийВладелец) <> Тип("ФормаКлиентскогоПриложения") Цикл
			ТекущийВладелец = ТекущийВладелец.Родитель;
		КонецЦикла;
		
		ОбъектВладельца = ТекущийВладелец.Объект;
		Если ОбъектВладельца.Свойство("Ссылка") Тогда

			Если ТипЗнч(ОбъектВладельца.Ссылка) = Тип("ДокументСсылка.ПеремещениеМатериалов") Тогда
				Склад = ОбъектВладельца.СкладОтправитель;
			ИначеЕсли ТипЗнч(ОбъектВладельца.Ссылка) = Тип("ДокументСсылка.ОказаниеУслуг")
					И ЗначениеЗаполнено(Действие)
			Тогда
				Если Действие = "ПодборМатериала" Тогда
					Склад = ОбъектВладельца.СкладМатериалов;
				Иначе
					Склад = ОбъектВладельца.Склад;
				КонецЕсли;
			ИначеЕсли Не ЗначениеЗаполнено(Склад) Тогда
				Если ОбъектВладельца.Свойство("Склад") Тогда
					Склад = ОбъектВладельца.Склад;
				ИначеЕсли ОбъектВладельца.Свойство("СкладМатериалов") Тогда
					Склад = ОбъектВладельца.СкладМатериалов;
				КонецЕсли;
			КонецЕсли;
			
			Если ТипЗнч(ОбъектВладельца.Ссылка) = Тип("ДокументСсылка.ОприходованиеТоваров")
				Или ТипЗнч(ОбъектВладельца.Ссылка) = Тип("ДокументСсылка.ИнвентаризацияТоваров")
				Или ТипЗнч(ОбъектВладельца.Ссылка) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг")
				Или ТипЗнч(ОбъектВладельца.Ссылка) = Тип("ДокументСсылка.АвансовыйОтчет")
			Тогда
				ТолькоВНаличии = Ложь;
			КонецЕсли;
			
		ИначеЕсли ОбъектВладельца.Свойство("Склад") Тогда
			Склад = ОбъектВладельца.Склад;
		Иначе
			Склад = ТекущийВладелец.Склад;
		КонецЕсли;
	Исключение
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСерииНоменклатуры(СерияНоменклатуры, ДополнитлеьныеПараметры) Экспорт
	
	ЗаполнитьСерииНоменклатурыСервер(Номенклатура, Склад);
	УстановитьТекущуюСтроку(СерияНоменклатуры);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьТекущуюСтроку(СерияНоменклатуры)
	
	СтрокиТаблицы = Серии.НайтиСтроки(Новый Структура("СерияСсылка", СерияНоменклатуры));
	Если СтрокиТаблицы.Количество() <> 0 Тогда
		
		Элементы.Серии.ТекущаяСтрока = СтрокиТаблицы[0].ПолучитьИдентификатор();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСерииНоменклатурыСервер(Номенклатура, Склад)
	
	Перем ВыборкаОстатки;
	
	Серии.Очистить();
	
	Выборка = Справочники.СерииНоменклатуры.Выбрать(, Номенклатура);
	СерииНоменклатуры = Новый Массив;
	СерииНоменклатурыМассивСсылок = Новый Массив;
	Пока Выборка.Следующий() Цикл
		Если Не Выборка.ПометкаУдаления
			И (ПоказыватьАрхивные Или Не Выборка.Архив)
		Тогда
			ДанныеСерии = Новый Структура("Ссылка, Наименование, Архив, СрокГодности", Выборка.Ссылка, Выборка.Наименование, Выборка.Архив, Выборка.ГоденДо);
			СерииНоменклатуры.Добавить(ДанныеСерии);
			СерииНоменклатурыМассивСсылок.Добавить(Выборка.Ссылка);
		КонецЕсли;
	КонецЦикла;
	ДанныеСерии = Новый Структура("Ссылка, Наименование, Архив, СрокГодности", Справочники.СерииНоменклатуры.ПустаяСсылка(), "<Пустое значение>", Ложь, Дата(1,1,1));
	СерииНоменклатуры.Добавить(ДанныеСерии);
	СерииНоменклатурыМассивСсылок.Добавить(ДанныеСерии.Ссылка);
	
	Если ЗначениеЗаполнено(Склад) Тогда
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("СерииНоменклатуры", СерииНоменклатурыМассивСсылок);
		Запрос.УстановитьПараметр("ХарактеристикаНоменклатуры", ХарактеристикаНоменклатуры);
		Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
		Запрос.УстановитьПараметр("Склад", Склад);
		Запрос.Текст = "ВЫБРАТЬ
		               |	ПартииТоваровНаСкладахОстатки.Склад КАК Склад,
		               |	ПартииТоваровНаСкладахОстатки.СерияНоменклатуры КАК СерияНоменклатуры,
		               |	ПартииТоваровНаСкладахОстатки.КоличествоОстаток КАК Остаток
		               |ИЗ
		               |	РегистрНакопления.ПартииТоваровНаСкладах.Остатки(
		               |			,
		               |			СерияНоменклатуры В (&СерииНоменклатуры)
		               |				И ХарактеристикаНоменклатуры = &ХарактеристикаНоменклатуры
		               |				И Номенклатура = &Номенклатура
		               |				И Склад = &Склад) КАК ПартииТоваровНаСкладахОстатки";
		ВыборкаОстатки = Запрос.Выполнить().Выбрать();
	КонецЕсли;
	
	Отбор = Новый Структура("СерияНоменклатуры");
	Для Каждого ДанныеСерии Из СерииНоменклатуры Цикл
		
		СерияНоменклатуры = ДанныеСерии.Ссылка;
		Отбор.СерияНоменклатуры = СерияНоменклатуры;
		
		БуферОстаток = 0;
		БуферСрокГодностиДата = ДанныеСерии.СрокГодности;
		БуферСрокГодностиИстек = ?(БуферСрокГодностиДата < НачалоДня(ТекущаяДата()), Истина, Ложь);
		
		Если ВыборкаОстатки <> Неопределено Тогда
			
			ВыборкаОстатки.Сбросить();
			Если ВыборкаОстатки.НайтиСледующий(Отбор) Тогда
				
				Единица = ?(ЗначениеЗаполнено(ЕдиницаИзмерения), ЕдиницаИзмерения, Номенклатура.ЕдиницаХраненияОстатков);
				Коэффициент = ?(Единица.Коэффициент = 0, 1, Единица.Коэффициент); 
				БуферОстаток = Окр(ВыборкаОстатки.Остаток * Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / Коэффициент, 3);
				
			КонецЕсли;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ДанныеСерии.Ссылка) И Не ЗначениеЗаполнено(БуферОстаток) Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не ТолькоВНаличии Или БуферОстаток > 0 Тогда
			НовыйНабор = Серии.Добавить();
			НовыйНабор.СерияПредставление = ДанныеСерии.Наименование; 
			НовыйНабор.Остаток = БуферОстаток;
			НовыйНабор.СерияСсылка = СерияНоменклатуры;
			НовыйНабор.СрокГодностиИстек = БуферСрокГодностиИстек;
			НовыйНабор.ДатаСрокаГодности = БуферСрокГодностиДата;
			НовыйНабор.Архив = ДанныеСерии.Архив;
		КонецЕсли;
	КонецЦикла;
	                
	Серии.Сортировать("СрокГодностиИстек, ДатаСрокаГодности, Остаток Убыв");
	
КонецПроцедуры
			
&НаКлиенте
Процедура ОбновитьНадписьФормулаСумма()
	
	НадписьФормулаСумма = Формат(Цена * Количество,"ЧДЦ=2; ЧН=");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗаголовокОстаток()
	
	Если ЗначениеЗаполнено(ЕдиницаИзмерения) Тогда 
		Элементы.СерииОстаток.Заголовок = "Остаток, " + Строка(ЕдиницаИзмерения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

