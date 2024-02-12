///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО Индустрия автоматизации  (Первый БИТ)
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область РазделОписанияПеременных

&НаКлиенте
Перем БылоПервоеЧтениеНастроекПрофилей;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ПравоДоступа("Администрирование", Метаданные)
		Или Не ПравоДоступа("АдминистрированиеРасширенийКонфигурации", Метаданные)
	Тогда
		Сообщить(НСтр("ru='Необходимы права администрирования для открытия формы'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ПрефиксРасширенияСтиля = БИТСтили_ОформлениеИнтерфейса.ПрефиксРасширенияСтиля();
	ПрефиксРасширенияКартинок = БИТСтили_ОформлениеИнтерфейса.ПрефиксРасширенияСтиля(Ложь);
	
	СохранитьНастройкиОформленияКакНастройкиПоУмолчанию = Истина;
	
	Если Не ПользователиВНастройкахИнтрефейса() Тогда
		СписокВыбора = Элементы.ОбластьПримененияНастройкиИнтерфейса.СписокВыбора;
		СписокВыбора.Удалить(СписокВыбора.НайтиПоЗначению("Пользователь"));
	КонецЕсли;
	
	ПрочитатьМакетыРасширений();
	
	ОбластьПрименения = "";
	
	ОбновитьСохраненныеНастройкиПрофилей();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Перезапустить(Команда = Неопределено)
	
	ТекстВопроса = НСтр("ru='Перезапустить приложение?'");
	Оповещение = Новый ОписаниеОповещения("Перезапустить_ПослеПодтверждения", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена, 60, КодВозвратаДиалога.ОК);
	
КонецПроцедуры

&НаКлиенте
Процедура Перезапустить_ПослеПодтверждения(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.ОК Тогда
		ЗавершитьРаботуСистемы(Истина, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СледующееИзображение(Команда)
	
	НавигацияИллюстрацияСтиля(1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредыдущееИзображение(Команда)
	
	НавигацияИллюстрацияСтиля(-1);
	
КонецПроцедуры

&НаКлиенте
Процедура НавигацияИллюстрацияСтиля(Шаг)
	
	Если Элементы.СпискиРасширений.ТекущаяСтраница = Элементы.СтраницаРасширенияОформления Тогда
		ТекущийСписок = Элементы.Расширения;
	ИначеЕсли Элементы.СпискиРасширений.ТекущаяСтраница = Элементы.СтраницаРасширенияКартинок Тогда
		ТекущийСписок = Элементы.РасширенияКартинок;
	Иначе
		Возврат;
	КонецЕсли;
	
	Расширение = ТекущийСписок.ТекущиеДанные;
	
	Если Расширение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КоличествоИллюстраций = Расширение.Иллюстрации.Количество();
	
	ИндексКартинки = ИндексКартинки + Шаг;
	Если ИндексКартинки >= 0 Тогда
		ИндексКартинки = ИндексКартинки % КоличествоИллюстраций;
	Иначе
		ИндексКартинки = КоличествоИллюстраций - 1;
	КонецЕсли;
	
	Картинка = ПоместитьВоВременноеХранилище(Расширение.Иллюстрации[ИндексКартинки].Картинка, УникальныйИдентификатор);

КонецПроцедуры

&НаКлиенте
Процедура ПрименитьОформление(Команда)
	
	Если Команда.Имя = "ПрименитьОформление" Тогда
		Префикс = ПрефиксРасширенияСтиля;
		Расширение = Элементы.Расширения.ТекущиеДанные;
	ИначеЕсли Команда.Имя = "ПрименитьКартинкиРазделов" Тогда
		Префикс = ПрефиксРасширенияКартинок;
		Расширение = Элементы.РасширенияКартинок.ТекущиеДанные;
	Иначе
		Возврат;
	КонецЕсли;
	
	Если Расширение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	БылоПервоеЧтениеНастроекПрофилей = Ложь;
	
	ТекущиеРасширенияСтиля = ТекущиеРасширенияСтиляВБазе(Префикс);
	
	Если ТекущиеРасширенияСтиля.Количество() <> 0 Тогда
		
		// Спросить, готовы ли удалить нынешние
		ПараметрыОповещения = Новый Структура;
		ПараметрыОповещения.Вставить("ТекущиеРасширенияСтиля", ТекущиеРасширенияСтиля);
		ПараметрыОповещения.Вставить("АдресФайлРасширения", Расширение.ФайлРасширения);
		ПараметрыОповещения.Вставить("НастройкиПанелей", Расширение.Настройки);
		ПараметрыОповещения.Вставить("Префикс", Префикс);
		
		Оповещение = Новый ОписаниеОповещения("УдалитьРасширенияСтиля_ПослеПодтверждения", ЭтотОбъект, ПараметрыОповещения);
		ПоказатьВопрос(Оповещение, ТекстВопросаУдалениеРасширений(Префикс),РежимДиалогаВопрос.ОКОтмена);
		
	Иначе
		УстановитьРасширениеСтиля(Расширение.ФайлРасширения, Расширение.Настройки, Префикс);	
		Перезапустить();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура УдалитьРасширенияСтиля_ПослеПодтверждения(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Ок Тогда
		
		УдалитьРасширенияНаСервере(ДополнительныеПараметры.ТекущиеРасширенияСтиля);		
		
		Если ДополнительныеПараметры.Свойство("АдресФайлРасширения") Тогда
			Если ДополнительныеПараметры.Свойство("Префикс") Тогда 
				УстановитьРасширениеСтиля(ДополнительныеПараметры.АдресФайлРасширения, ДополнительныеПараметры.НастройкиПанелей, ДополнительныеПараметры.Префикс);
			Иначе
				УстановитьРасширениеСтиля(ДополнительныеПараметры.АдресФайлРасширения, ДополнительныеПараметры.НастройкиПанелей);	
			КонецЕсли;
		КонецЕсли;
		
		Перезапустить();
	КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРасширениеСтиля(АдресФайлРасширения, НастройкиПанелей, Префикс = Неопределено)
	
	// Установка нового расширения стиля
	НастройкиПанелейУстановка = ?(СохранитьНастройкиОформленияКакНастройкиПоУмолчанию, НастройкиПанелей, Неопределено);
	УстановитьРасширениеНаСервере(АдресФайлРасширения, НастройкиПанелейУстановка, Префикс);
	
	Если НастройкиПанелейУстановка <> Неопределено Тогда
		ОбновитьСохраненныеНастройкиПрофилей();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьВсеРасширенияСтиляБазы(Команда)
	
	Если Команда.Имя = "УдалитьВсеРасширенияСтиляОформленияБазы" Тогда
		Префикс = ПрефиксРасширенияСтиля;
	ИначеЕсли Команда.Имя = "УдалитьРасширенияАльтернативныхКартинокРазделов" Тогда
		Префикс = ПрефиксРасширенияКартинок;
	Иначе
		Возврат;
	КонецЕсли;
	
	ТекущиеРасширенияСтиля = ТекущиеРасширенияСтиляВБазе(Префикс);
	
	Если ТекущиеРасширенияСтиля.Количество() <> 0 Тогда
		
		// Спросить, готовы ли удалить нынешние
		ПараметрыОповещения = Новый Структура;
		ПараметрыОповещения.Вставить("ТекущиеРасширенияСтиля", ТекущиеРасширенияСтиля);
		
		Оповещение = Новый ОписаниеОповещения("УдалитьРасширенияСтиля_ПослеПодтверждения", ЭтотОбъект, ПараметрыОповещения);
		ПоказатьВопрос(Оповещение, ТекстВопросаУдалениеРасширений(Префикс),РежимДиалогаВопрос.ОКОтмена);
	Иначе
		ПоказатьПредупреждение(, ТекстПредупрежденияНетРасширений(Префикс));
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЗначенияПоОбъекту(Команда)
	
	ПрочитатьНастройкиОбъекта();
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьНастройкиОбъекта(ОбъектНастроек = Неопределено)
	
	Если ОбъектНастроек = Неопределено Тогда
		ОбъектНастроек = ПолучательНастроек;
	КонецЕсли;
	
	Если ОбъектНастроек = Неопределено
		Или ТипЗнч(ОбъектНастроек) = Тип("СправочникСсылка.ПрофилиПользователей")
	Тогда
		Настройки = НастройкиИнтерфейсаПрофиля(ОбъектНастроек);
		Если Настройки = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ОбъектНастроек) = Тип("СправочникСсылка.Пользователи") Тогда
		Настройки = Новый Структура;
		Настройки = БИТСтили_ОформлениеИнтерфейса.ПолучитьНастройкиПользователя(ОбъектНастроек.Код); // Имя пользователя ИБ.
	КонецЕсли;
	
	ОтобразитьНастройкиНаФорме(Настройки);	
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НастройкиИнтерфейсаПрофиля(Профиль)
	
	Отбор = Новый Структура;
	Отбор.Вставить("Профиль", Профиль);
	Возврат РегистрыСведений.БИТСтили_НастройкиИнтерфейсаПрофилей.Получить(Отбор).Настройка.Получить();
	
КонецФункции

&НаКлиенте
Процедура ОтобразитьНастройкиНаФорме(Настройки)
	
	Для Каждого Поле Из БИТСтили_ОформлениеИнтерфейса.ИменаНастроекИнтерфейса() Цикл
		
		Если Настройки.Свойство(Поле) Тогда
			ЭтотОбъект[Поле] = Настройки[Поле]
		Иначе
			ЭтотОбъект[Поле] = Неопределено;
		КонецЕсли;
		
	КонецЦикла;
	
	ВариантИнтерфейсаНаФорму();
	
	РасположениеПанелейЗадано = БИТСтили_ОформлениеИнтерфейса.ЕстьНастройкаРасположенияПанелей(Настройки);
	РасположениеПанелейЗаданоПриИзменении(Неопределено);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьНастройкиИнтерфейсаДляПолучателя(Настройки, ПолучательНастроек)
	
	Если ПолучательНастроек = Неопределено
		Или ТипЗнч(ПолучательНастроек) = Тип("СправочникСсылка.ПрофилиПользователей")
	Тогда
		Запись = РегистрыСведений.БИТСтили_НастройкиИнтерфейсаПрофилей.СоздатьМенеджерЗаписи();
		Запись.Профиль = ПолучательНастроек;
		Запись.Настройка = Новый ХранилищеЗначения(Настройки);
		Запись.Записать();
		
	ИначеЕсли ТипЗнч(ПолучательНастроек) = Тип("СправочникСсылка.Пользователи") Тогда
		БИТСтили_ОформлениеИнтерфейса.ПрименитьНастройкиКПользователю(ПолучательНастроек, Настройки);		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрименитьДляОбъекта(Команда)
	
	ВариантИнтерфейсаИзФормы();
	
	Настройки = СтруктураНастроекИнтерфейса();
	СохранитьНастройкиИнтерфейсаДляПолучателя(Настройки, ПолучательНастроек);
	ОбновитьСохраненныеНастройкиПрофилей();
	
	Состояние(НСтр("ru='Настройки сохранены.'"));

КонецПроцедуры

&НаКлиенте
Процедура ОчиститьНастройкиНаФорме(Команда)
	
	Для Каждого Поле Из БИТСтили_ОформлениеИнтерфейса.ИменаНастроекИнтерфейса() Цикл
		ЭтотОбъект[Поле] = Неопределено;
	КонецЦикла;
	
	РасположениеПанелейЗадано = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОбластьПримененияПриИзменении(Элемент)

	Если ОбластьПрименения = "" Тогда
		ПолучательНастроек = Неопределено;
		Элементы.Объект.Доступность = Ложь;
		Элементы.Объект.ПодсказкаВвода = НСтр("ru='По умолчанию для остальных пользователей'");
	Иначе
		Элементы.Объект.ПодсказкаВвода = "";
		Элементы.Объект.Доступность = Истина;
		Если ОбластьПрименения = "Профиль" Тогда
			ОписаниеТипов = Новый ОписаниеТипов("СправочникСсылка.ПрофилиПользователей");
		Иначе
			ОписаниеТипов = Новый ОписаниеТипов("СправочникСсылка.Пользователи");
		КонецЕсли;
		ПолучательНастроек = ОписаниеТипов.ПривестиЗначение(ПолучательНастроек); 			
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СпискиРасширенийПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если Элемент.ТекущаяСтраница = Элементы.СтраницаРасширенияОформления Тогда
		ТекущийСписок = Элементы.Расширения;
		Элементы.СтраницыОписания.ТекущаяСтраница = Элементы.ГруппаОписаниеОформления;
	ИначеЕсли Элемент.ТекущаяСтраница = Элементы.СтраницаРасширенияКартинок Тогда
		ТекущийСписок = Элементы.РасширенияКартинок;
		Элементы.СтраницыОписания.ТекущаяСтраница = Элементы.ГруппаОписаниеКартинок;
	Иначе
		Возврат;
	КонецЕсли;
	
	РасширенияПриАктивизацииСтроки(ТекущийСписок)
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеКартинкиНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Элементы.СпискиРасширений.ТекущаяСтраница = Элементы.СтраницаРасширенияОформления Тогда
		Расширение = Элементы.Расширения.ТекущиеДанные;
	Иначе
		Расширение = Элементы.РасширенияКартинок.ТекущиеДанные;
	КонецЕсли;
		
	Если Расширение <> Неопределено Тогда
		Попытка
			ОткрытьЗначение(Расширение.Иллюстрации[ИндексКартинки].Картинка);
		Исключение КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

#Область НастройкиПрофилей

&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если ТекущаяСтраница = Элементы.НастройкаИнтерфейса Тогда
		ПодключитьОбработчикОжидания("СтраницыПриСменеСтраницы_ОтключитьАвтоЧтениеПрофиля", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницыПриСменеСтраницы_ОтключитьАвтоЧтениеПрофиля()
	
	БылоПервоеЧтениеНастроекПрофилей = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиПрофилейПриАктивизацииСтроки(Элемент)
	
	Если БылоПервоеЧтениеНастроекПрофилей <> Истина
		И Элемент.ТекущиеДанные <> Неопределено
	Тогда
		ПрочитатьНастройкиОбъекта(Элемент.ТекущиеДанные.Профиль);
		БылоПервоеЧтениеНастроекПрофилей = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РасположениеПанелейЗаданоПриИзменении(Элемент)
	
	Элементы.РасположениеПанелейЗначения.Доступность = РасположениеПанелейЗадано;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийТаблицФормы

&НаКлиенте
Процедура РасширенияПриАктивизацииСтроки(Элемент)
	
	Расширение = Элемент.ТекущиеДанные;
	
	Если Расширение <> Неопределено Тогда
		ИндексКартинки = 0;
		
		Если Расширение.Иллюстрации.Количество() <> 0 Тогда
			Картинка = ПоместитьВоВременноеХранилище(Расширение.Иллюстрации[0].Картинка);
		Иначе
			Картинка = "";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СуществующиеНастройкиПередУдалением(Элемент, Отказ)
	
	УдалитьНастройкиПрофиля(Элементы.НастройкиПрофилей.ТекущиеДанные.Профиль);
	ОбновитьСохраненныеНастройкиПрофилей();
	
КонецПроцедуры

&НаКлиенте
Процедура СуществующиеНастройкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПрочитатьНастройкиОбъекта(Элементы.НастройкиПрофилей.ТекущиеДанные.Профиль);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ДесериализацияРасширенийСтиля

// При создании формы.
&НаСервере
Процедура ПрочитатьМакетыРасширений()
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	
	Для Каждого Макет Из ОбработкаОбъект.Метаданные().Макеты Цикл
		
		Если СтрНачинаетсяС(Макет.Имя, ПрефиксРасширенияСтиля) Тогда
			ТаблицаРасширений = РасширенияСтиля;
		ИначеЕсли СтрНачинаетсяС(Макет.Имя, ПрефиксРасширенияКартинок) Тогда
			ТаблицаРасширений = РасширенияКартинок;
		Иначе
			Продолжить;
		КонецЕсли;
		
		Расширение = ТаблицаРасширений.Добавить();
		Расширение.Синоним = Макет.Синоним;
		Расширение.Название = Макет.Имя;
		
		ДвоичныеДанныеАрхива = ОбработкаОбъект.ПолучитьМакет(Макет.Имя);
		ИмяФайлаАрхива = ПолучитьИмяВременногоФайла("zip");
		ДвоичныеДанныеАрхива.Записать(ИмяФайлаАрхива);
		ЧтениеZip = Новый ЧтениеZipФайла(ИмяФайлаАрхива);
		
		КаталогАрхива = ПолучитьИмяВременногоФайла();
		ЧтениеZip.ИзвлечьВсе(КаталогАрхива, РежимВосстановленияПутейФайловZIP.НеВосстанавливать);
		
		СистемнаяИнформация = Новый СистемнаяИнформация;
		ОбщегоНазначенияКлиентСервер.ДобавитьСлешЕслиНужно(КаталогАрхива, СистемнаяИнформация.ТипПлатформы);
		
		Для Каждого ЭлементZip Из ЧтениеZip.Элементы Цикл
			
			ИмяФайлаЭлемента = КаталогАрхива +  ЭлементZip.Имя;
			
			Если ЭтоФайлИзображения(ЭлементZip.Расширение) Тогда
				// Иллюстрации
				Попытка
					КартинкаИллюстрация = Новый Картинка(ИмяФайлаЭлемента);
				Исключение
					Продолжить;
				КонецПопытки;
				Расширение.Иллюстрации.Добавить(ЭлементZip.Имя,,, КартинкаИллюстрация);
			
			ИначеЕсли ЭлементZip.Расширение = "cfe" Тогда
				// Расширение конфигурации
				Расширение.ФайлРасширения = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ИмяФайлаЭлемента), УникальныйИдентификатор);
			
			ИначеЕсли НРег(ЭлементZip.Имя) = "default.json" Тогда
				// Настройки по умолчанию панелей для расширения
				Расширение.Настройки = РазобратьJSON_НастроекРасширенияСтиля(ИмяФайлаЭлемента);
				Расширение.НастройкиПанелейСтиля = ТекстОписанияИзНастроекРасширенияСтиля(Расширение.Настройки);
				
			ИначеЕсли НРег(ЭлементZip.ИмяБезРасширения) = "readme" Тогда
				// Описание
				ТестовыйДокумент = Новый ТекстовыйДокумент;
				ТестовыйДокумент.Прочитать(ИмяФайлаЭлемента);
				Расширение.Описание = ТестовыйДокумент.ПолучитьТекст();
			КонецЕсли;
			
		КонецЦикла;
		
		ЧтениеZip.Закрыть();
	КонецЦикла;
	
	// Удаление временных файлов.
	Файл = Новый Файл(ИмяФайлаАрхива);
	Если Файл.Существует() Тогда
		УдалитьФайлы(ИмяФайлаАрхива);
	КонецЕсли;
	
	Файл = Новый Файл(ИмяФайлаЭлемента);
	Если Файл.Существует() Тогда
		УдалитьФайлы(ИмяФайлаЭлемента);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ЭтоФайлИзображения(РасширениеФайла)
	
	РасширенияИзображений = Новый Массив;
	РасширенияИзображений.Добавить("bmp");
	РасширенияИзображений.Добавить("jpg");
	РасширенияИзображений.Добавить("png");
	РасширенияИзображений.Добавить("dib");
	РасширенияИзображений.Добавить("tif");
	РасширенияИзображений.Добавить("gif");
	РасширенияИзображений.Добавить("ico");
	РасширенияИзображений.Добавить("wmf");
	РасширенияИзображений.Добавить("emf");
	РасширенияИзображений.Добавить("jpeg");
	
	Возврат РасширенияИзображений.Найти(РасширениеФайла) <> Неопределено;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ТекстОписанияИзНастроекРасширенияСтиля(Настройки)
	
	Описание = "";
	
	Если Настройки.Свойство("ОтображениеПанелиРазделов") Тогда
		Попытка
			Описание = Описание + "Отображение панели разделов: " + ОтображениеПанелиРазделов[Настройки.ОтображениеПанелиРазделов];
		Исключение КонецПопытки;
	КонецЕсли;
	
	// Расположение панелей
	МассивСторон = Новый Массив;
	МассивПанелей = Новый Массив;
	МассивСторон.Добавить("Верх");
	МассивСторон.Добавить("Лево");
	МассивСторон.Добавить("Право");
	МассивСторон.Добавить("Низ");
	Для Каждого Сторона Из МассивСторон Цикл
		
		МассивПанелей.Очистить();
		Для Каждого Настройка Из Настройки Цикл
			Если Настройка.Значение = Сторона Тогда	
				МассивПанелей.Добавить(Настройка.Ключ);
			КонецЕсли;
		КонецЦикла;
		
		Если МассивПанелей.Количество() > 0 Тогда
			Описание = Описание + Символы.ПС;
			Описание = Описание + НСтр("ru='В группе ""'") + Сторона + """: "; 
			Для Сч = 0 По МассивПанелей.Количество() - 1 Цикл
				
				Если Сч <> 0 Тогда
					Описание = Описание + ", ";	
				КонецЕсли;
				Описание = Описание + МассивПанелей[Сч];
				
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Если Настройки.Свойство("ВариантИнтерфейсаКлиентскогоПриложения") Тогда
		Попытка
			Описание = Описание
					 + ?(ЗначениеЗаполнено(Описание), Символы.ПС,"")
					 + НСтр("ru='Вариант интерфейса'") + ": " + ВариантИнтерфейсаКлиентскогоПриложения[Настройки.ВариантИнтерфейсаКлиентскогоПриложения] + Символы.ПС;
		Исключение КонецПопытки;
	КонецЕсли;
	
	Если Настройки.Свойство("ВариантМасштабаФормКлиентскогоПриложения") Тогда
		Попытка
			Описание = Описание
					 + ?(ЗначениеЗаполнено(Описание), Символы.ПС,"")
					 + НСтр("ru='Масштабирование интерфейса'") + ": " + ВариантМасштабаФормКлиентскогоПриложения[Настройки.ВариантМасштабаФормКлиентскогоПриложения]
					 + ", " + НСтр("ru='вариант масштаба форм'") + Символы.ПС;
		Исключение КонецПопытки;
	КонецЕсли;
	
	Возврат СокрЛП(Описание);
	
КонецФункции

&НаСервереБезКонтекста
Функция РазобратьJSON_НастроекРасширенияСтиля(ИмяФайлаНастроек)
	
	Чтение = Новый ЧтениеJSON;
	Чтение.ОткрытьФайл(ИмяФайлаНастроек);
	Настройки = Новый Структура;
	Пока Чтение.Прочитать() Цикл
		Тип = Чтение.ТипТекущегоЗначения;
		Если Тип = ТипЗначенияJSON.ИмяСвойства Тогда
			ИмяСвойства = Чтение.ТекущееЗначение;
		ИначеЕсли Тип = ТипЗначенияJSON.Строка Тогда
			Настройки.Вставить(ИмяСвойства, Чтение.ТекущееЗначение);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Настройки;
	
КонецФункции

#КонецОбласти

#Область ОперацииСРасширениямиБазы

&НаСервереБезКонтекста
Функция ТекущиеРасширенияСтиляВБазе(Префикс)
	
	ИменаРасширений = Новый Массив;
	
	Для Каждого Расширение Из РасширенияКонфигурации.Получить() Цикл
		Если СтрНачинаетсяС(Расширение.Имя, Префикс)
			И Расширение.Активно
		Тогда
			ИменаРасширений.Добавить(Расширение.УникальныйИдентификатор);	
		КонецЕсли;
	КонецЦикла;
	
	Возврат ИменаРасширений; 	
	
КонецФункции

&НаКлиенте
Функция ТекстВопросаУдалениеРасширений(Префикс)
	
	Шаблон = НСтр("ru='В базе есть активные расширения %1. Они будут удалены.'") + " " + НСтр("ru='Продолжить?'");
	
	Если Префикс = ПрефиксРасширенияСтиля Тогда
		Параметр = НСтр("ru='стиля'");
	Иначе
		Параметр = НСтр("ru='картинок разделов'");
	КонецЕсли;
	
	Возврат СтрШаблон(Шаблон, Параметр);
	
КонецФункции

&НаКлиенте
Функция ТекстПредупрежденияНетРасширений(Префикс)
	
	Шаблон = НСтр("ru='В базе не найдено активных расширений %1.'");
	
	Если Префикс = ПрефиксРасширенияСтиля Тогда
		Параметр = НСтр("ru='стиля оформления'");
	Иначе
		Параметр = НСтр("ru='картинок разделов'");
	КонецЕсли;
	
	Возврат СтрШаблон(Шаблон, Параметр);
	
КонецФункции

&НаСервереБезКонтекста
Процедура УстановитьРасширениеНаСервере(АдресФайлаРасширения, НастройкиПанелей = Неопределено, Префикс = "")
	
	// Сохранение расширения
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресФайлаРасширения);
	НовоеРасширение = РасширенияКонфигурации.Создать();
	НовоеРасширение.БезопасныйРежим = Ложь;
	НовоеРасширение.Записать(ДвоичныеДанные);
	
	ПрефиксРасширенияСтиля = БИТСтили_ОформлениеИнтерфейса.ПрефиксРасширенияСтиля();
	ПрефиксРасширенияКартинок = БИТСтили_ОформлениеИнтерфейса.ПрефиксРасширенияСтиля(Ложь); 
	
	// Сохранение дефолтных настроек панелей.
	Если НастройкиПанелей <> Неопределено 
		И (Префикс = ПрефиксРасширенияКартинок
		Или (Префикс = ПрефиксРасширенияСтиля
		И ТекущиеРасширенияСтиляВБазе(ПрефиксРасширенияКартинок).Количество() = 0))
	Тогда
		
		// Объединение с текущими общими настройками
		ЗаписьТекущие = РегистрыСведений.БИТСтили_НастройкиИнтерфейсаПрофилей.СоздатьМенеджерЗаписи();
		ЗаписьТекущие.Профиль = Неопределено;
		ЗаписьТекущие.Прочитать();
		Если ЗаписьТекущие.Выбран() Тогда
			НастройкиТекущие = ЗаписьТекущие.Настройка.Получить();
			
			Для Каждого КлючЗначение Из НастройкиТекущие Цикл
				Если Не НастройкиПанелей.Свойство(КлючЗначение.Ключ) Тогда
					НастройкиПанелей.Вставить(КлючЗначение.Ключ, КлючЗначение.Значение);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		Запись = РегистрыСведений.БИТСтили_НастройкиИнтерфейсаПрофилей.СоздатьМенеджерЗаписи();
		Запись.Профиль = Неопределено;
		Запись.Настройка = Новый ХранилищеЗначения(НастройкиПанелей);
		Запись.Записать();
	КонецЕсли;
	
КонецПроцедуры	

&НаСервереБезКонтекста
Процедура УдалитьРасширенияНаСервере(ТекущиеРасширенияСтиля)
	
	Расширения = РасширенияКонфигурации.Получить();
	Для Каждого Расширение Из Расширения Цикл
		
		Если ТекущиеРасширенияСтиля.Найти(Расширение.УникальныйИдентификатор) <> Неопределено Тогда
			Расширение.Удалить();
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область НастройкиПрофилей

&НаСервереБезКонтекста
Функция ПользователиВНастройкахИнтрефейса()
	Возврат Ложь;
КонецФункции

&НаСервере
Процедура ОбновитьСохраненныеНастройкиПрофилей()

	НастройкиПрофилей.Очистить();
	Выборка = РегистрыСведений.БИТСтили_НастройкиИнтерфейсаПрофилей.Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаПрофиль = НастройкиПрофилей.Добавить();
		СтрокаПрофиль.Профиль = Выборка.Профиль;
	КонецЦикла;	

КонецПроцедуры

&НаКлиенте
Функция СтруктураНастроекИнтерфейса()
	
	Настройки = Новый Структура;
	
	ПанелиИнтерфейса = БИТСтили_ОформлениеИнтерфейса.ПанелиИнтерфейса();
	
	Для Каждого Поле Из БИТСтили_ОформлениеИнтерфейса.ИменаНастроекИнтерфейса() Цикл
		
		Если ЗначениеЗаполнено(ЭтотОбъект[Поле]) // Настройка задана.
			И (ПанелиИнтерфейса.Найти(Поле) = Неопределено Или РасположениеПанелейЗадано) // Это не настройка панелей при выключенном флаге.
		Тогда
			Настройки.Вставить(Поле, ЭтотОбъект[Поле]);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Настройки;	
	
КонецФункции

&НаКлиенте
Процедура ВариантИнтерфейсаИзФормы()
	
	Если ВариантИнтерфейса = "ТаксиК" Тогда
		ВариантИнтерфейсаКлиентскогоПриложения	 = "Такси";
		ВариантМасштабаФормКлиентскогоПриложения = "Компактный";
	ИначеЕсли ВариантИнтерфейса = "ТаксиО" Тогда
		ВариантИнтерфейсаКлиентскогоПриложения	 = "Такси";
		ВариантМасштабаФормКлиентскогоПриложения = "Обычный";
	ИначеЕсли ВариантИнтерфейса = "8.2" Тогда
		ВариантИнтерфейсаКлиентскогоПриложения	 = "Версия8_2";
		ВариантМасштабаФормКлиентскогоПриложения = "";
	Иначе
		ВариантИнтерфейсаКлиентскогоПриложения	 = "";
		ВариантМасштабаФормКлиентскогоПриложения = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантИнтерфейсаНаФорму()
	
	Если ВариантМасштабаФормКлиентскогоПриложения = "Компактный" Тогда
		ВариантИнтерфейса = "ТаксиК";
	ИначеЕсли ВариантМасштабаФормКлиентскогоПриложения = "Обычный" Тогда
		ВариантИнтерфейса = "ТаксиО";
	ИначеЕсли ВариантИнтерфейсаКлиентскогоПриложения = "Версия8_2" Тогда
		ВариантИнтерфейса = "8.2";
	ИначеЕсли ВариантИнтерфейсаКлиентскогоПриложения = "Такси" Тогда
		ВариантИнтерфейса = "ТаксиК";
	Иначе
		ВариантИнтерфейса = "";
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УдалитьНастройкиПрофиля(ПрофильНаУдаление)
	
	Запись = РегистрыСведений.БИТСтили_НастройкиИнтерфейсаПрофилей.СоздатьМенеджерЗаписи();
	Запись.Профиль = ПрофильНаУдаление;
	Запись.Удалить();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
