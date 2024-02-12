
#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Элементы.АнализСканированияШтрихкодов.Видимость = ПравоДоступа("Использование", Метаданные.Обработки.АнализСканированияШтрихкодовМДЛП);
	
	НастроитьФормуПриИзменииЭлементовУправления();
	
	СобытияФормМДЛППереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СобытияФормМДЛПКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ИспользоватьРеестрВыбытияУпаковокМДЛППриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправлятьДанныеТолькоПриВыполненииОбменаМДЛППриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура РежимЗапускаМетодовАПИМДЛППриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ТипЗапросаМетодовАПИПоУмолчаниюМДЛППриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтролироватьКодыМаркировкиСредствамиАПИМДЛППриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыКонтроляСредствамиАПИМДЛПНастройкаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФормуНастройкиИсключенийКонтроляКМ(Элементы.КонтролироватьКодыМаркировкиСредствамиАПИМДЛП.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтролироватьКодыМаркировкиСредствамиРВПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыКонтроляСредствамиРВНастройкаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФормуНастройкиИсключенийКонтроляКМ(Элементы.КонтролироватьКодыМаркировкиСредствамиРВ.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтролироватьКодыМаркировкиСредствамиККТПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыКонтроляСредствамиККТНастройкаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФормуНастройкиИсключенийКонтроляКМ(Элементы.КонтролироватьКодыМаркировкиСредствамиККТ.Имя);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьНастройкиГраницЗагрузкиДокументов(Команда)
	
	ОткрытьФорму("ОбщаяФорма.ГраницаЗагрузкиДокументовМДЛП",, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройкиГраницЗагрузкиОстатковПотребительскихУпаковок(Команда)
	
	ОткрытьФорму("ОбщаяФорма.ГраницаЗагрузкиОстатковПотребительскихУпаковокМДЛП",, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СверкаОстатковМДЛП(Команда)
	
	ОткрытьФорму("Обработка.СверкаОстатковМДЛП.Форма.СверкаОстатков",, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСоставТранспортныхУпаковок(Команда)
	
	ОткрытьФорму("Обработка.ПолучитьСоставТранспортныхУпаковокМДЛП.Форма.ПолучитьСоставТранспортныхУпаковок",, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура АнализСканированияШтрихкодовМДЛП(Команда)
	
	ОткрытьФорму("Обработка.АнализСканированияШтрихкодовМДЛП.Форма.АнализСканированияШтрихкодов",, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура РеестрВыбытияМДЛП(Команда)
	
	ОткрытьФорму("Обработка.РеестрВыбытияМДЛП.Форма.РеестрВыбытия",, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура РеестрРешенийОВводеЛПВОборот(Команда)
	
	ОткрытьФорму("Обработка.РеестрРешенийОВводеЛПВГражданскийОборот.Форма.РеестрРешенийОВводеЛПВОборот",, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПротоколОбменаМДЛП(Команда)
	
	ОткрытьФорму("Отчет.ПротоколОбменаМДЛП.Форма",, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборочныйКонтрольКММДЛП(Команда)
	
	ОткрытьФорму("Обработка.ВыборочныйКонтрольКММДЛП.Форма.ВыборочныйКонтроль",, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормМДЛПКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	КонстантаИмя = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если ОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Если КонстантаИмя <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, КонстантаИмя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	КонстантаИмя = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	
	НастроитьФормуПриИзменииЭлементовУправления(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если СтрНачинаетсяС(НРег(РеквизитПутьКДанным), НРег("НаборКонстант.")) Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
	Иначе
		
		СохранитьНастройкиКонтроляКМ(РеквизитПутьКДанным, КонстантаИмя);
		
	КонецЕсли;
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Процедура НастроитьФормуПриИзменииЭлементовУправления(РеквизитПутьКДанным = "")
	
	Если ЗначениеЗаполнено(РеквизитПутьКДанным) Тогда
		ПрочитатьНастройкиКонтроляКМ(РеквизитПутьКДанным);
	Иначе
		Для Каждого КлючИЗначение Из СоответствияКлючейГруппНастроекКонтроляКМРеквизитамФормы() Цикл
			ПрочитатьНастройкиКонтроляКМ(КлючИЗначение.Ключ);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#Область НастройкиСканированияКодовМаркировки

&НаСервере
Процедура СохранитьНастройкиКонтроляКМ(РеквизитПутьКДанным, КонстантаИмя)
	
	КлючГруппыНастроекКонтроляКМ = КлючГруппыНастроекКонтроляКМ(РеквизитПутьКДанным);
	Если КлючГруппыНастроекКонтроляКМ = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Успех = КонтрольКодовМаркировкиМДЛП.УстановитьИспользованиеНастройкиКонтроляКМ(КлючГруппыНастроекКонтроляКМ, ЭтотОбъект[РеквизитПутьКДанным]);
	Если Не Успех Тогда
		ЭтотОбъект[РеквизитПутьКДанным] = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьНастройкиКонтроляКМ(РеквизитПутьКДанным)
	
	КлючГруппыНастроекКонтроляКМ = КлючГруппыНастроекКонтроляКМ(РеквизитПутьКДанным);
	Если КлючГруппыНастроекКонтроляКМ = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ГруппаНастроек = КонтрольКодовМаркировкиМДЛПКлиентСервер.ЗначениеГруппыНастроекКонтроляКМ(, КлючГруппыНастроекКонтроляКМ);
	ЭтотОбъект[РеквизитПутьКДанным] = ГруппаНастроек.Включено;
	
	ЭлементФормыНастройка = Элементы[КлючГруппыНастроекКонтроляКМ];
	ЭлементФормыНастройка.Доступность = ГруппаНастроек.Включено;
	
	ПредставлениеИсключений = КонтрольКодовМаркировкиМДЛП.ПредставлениеИсключенийГруппыНастроекКонтроляКМ(ГруппаНастроек);
	Если ЗначениеЗаполнено(ПредставлениеИсключений) Тогда
		Если СтрДлина(ПредставлениеИсключений) > 40 Тогда
			ЭлементФормыНастройка.Заголовок = Новый ФорматированнаяСтрока(НСтр("ru = 'Настроить исключения'"),,,, "Перейти");
		Иначе
			ЭлементФормыНастройка.Заголовок = Новый ФорматированнаяСтрока(ПредставлениеИсключений,,,, "Перейти");
		КонецЕсли;
	Иначе
		ЭлементФормыНастройка.Заголовок = Новый ФорматированнаяСтрока(НСтр("ru = '<Все операции>'"),,,, "Перейти");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция КлючГруппыНастроекКонтроляКМ(РеквизитПутьКДанным)
	
	Возврат СоответствияКлючейГруппНастроекКонтроляКМРеквизитамФормы().Получить(РеквизитПутьКДанным);
	
КонецФункции

&НаСервере
Функция СоответствияКлючейГруппНастроекКонтроляКМРеквизитамФормы()
	
	ГруппыНастроекКонтроляКМ = КонтрольКодовМаркировкиМДЛПКлиентСервер.ГруппыНастроекКонтроляКМ();
	
	Результат = Новый Соответствие;
	Результат.Вставить(Элементы.КонтролироватьКодыМаркировкиСредствамиАПИМДЛП.ПутьКДанным, ГруппыНастроекКонтроляКМ.ПараметрыКонтроляСредствамиАПИМДЛП);
	Результат.Вставить(Элементы.КонтролироватьКодыМаркировкиСредствамиРВ.ПутьКДанным, ГруппыНастроекКонтроляКМ.ПараметрыКонтроляСредствамиРВ);
	Результат.Вставить(Элементы.КонтролироватьКодыМаркировкиСредствамиККТ.ПутьКДанным, ГруппыНастроекКонтроляКМ.ПараметрыКонтроляСредствамиККТ);
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуНастройкиИсключенийКонтроляКМ(РеквизитПутьКДанным)
	
	КлючГруппыНастроекКонтроляКМ = КлючГруппыНастроекКонтроляКМ(РеквизитПутьКДанным);
	Если КлючГруппыНастроекКонтроляКМ = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("КлючГруппыНастроекКонтроляКМ", КлючГруппыНастроекКонтроляКМ);
	
	Оповещение = Новый ОписаниеОповещения("НастройкаИсключенийЗавершение", ЭтотОбъект, РеквизитПутьКДанным);
	
	ОткрытьФорму(
		"Обработка.ПанельМаркировкиМДЛП.Форма.НастройкиИсключенийКонтроляКодовМаркировки",
		ПараметрыФормы,
		ЭтотОбъект,,,,
		Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаИсключенийЗавершение(Результат, РеквизитПутьКДанным) Экспорт
	
	Если Результат <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	ПрочитатьНастройкиКонтроляКМ(РеквизитПутьКДанным);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
