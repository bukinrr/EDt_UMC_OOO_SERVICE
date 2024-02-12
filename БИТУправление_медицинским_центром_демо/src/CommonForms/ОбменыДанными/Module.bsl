////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;                                               
	
	СписокПлановОбмена = ОбменДаннымиПовтИсп.СписокПлановОбменаБСП();
	Если СписокПлановОбмена.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Возможность настройки синхронизации данных не предусмотрена.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
		Возврат;
	КонецЕсли;
	
	ЕстьПравоНаПросмотрЖурналаРегистрации = Истина;	
	РольДоступнаДобавлениеИзменениеОбменовДанными = Истина;
	Если РольДоступнаДобавлениеИзменениеОбменовДанными Тогда
		ДобавитьКомандыСозданияНовогоОбмена();
	Иначе
		Элементы.НастроитьСинхронизациюДанныхНеНастроена.Видимость = Ложь;
		Элементы.ГруппаНастройкаСинхронизации.Видимость = Ложь;
		Элементы.ИнформационнаяНадпись.ТекущаяСтраница = Элементы.НетПравНаСинхронизацию;
		Элементы.ГруппаСценарииСинхронизации.Видимость = Ложь;
		Элементы.ГруппаНастройкиСинхронизации.Видимость = Ложь;
	КонецЕсли;
	
	ОбновитьСписокСостоянияУзлов();
	
	Если КоличествоСинхронизаций = 1 Тогда
		
		Если ЕстьПравоНаПросмотрЖурналаРегистрации Тогда
			
			Элементы.ДатаУспешнойЗагрузки.Видимость = Истина;
			Элементы.ДатаУспешнойВыгрузки.Видимость = Истина;
			Элементы.НадписьДатаПолучения.Видимость = Ложь;
			Элементы.НадписьДатаОтправки.Видимость = Ложь;
			
		Иначе
			
			Элементы.ДатаУспешнойЗагрузки.Видимость = Ложь;
			Элементы.ДатаУспешнойВыгрузки.Видимость = Ложь;
			Элементы.НадписьДатаПолучения.Видимость = Истина;
			Элементы.НадписьДатаОтправки.Видимость = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не РольДоступнаДобавлениеИзменениеОбменовДанными Или ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		
		Элементы.ПрефиксСинхронизацияНеНастроена.Видимость = Ложь;
		Элементы.ПрефиксОднаСинхронизация.Видимость = Ложь;
		Элементы.ПрефиксИБ.Видимость = Ложь;
		
	Иначе
		
		ПрефиксИБ = ОбменДаннымиСервер.ПрефиксИнформационнойБазы();
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("ОбновитьДанныеМонитора", 60);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если    ИмяСобытия = "ВыполненОбменДанными"
		ИЛИ ИмяСобытия = "Запись_СценарииОбменовДанными"
		ИЛИ ИмяСобытия = "Запись_УзелПланаОбмена"
		ИЛИ ИмяСобытия = "ЗакрытаФормаПомощникаСопоставленияОбъектов"
		ИЛИ ИмяСобытия = "ЗакрытаФормаПомощникаСозданияОбменаДанными"
		ИЛИ ИмяСобытия = "ЗакрытаФормаРезультатовОбменаДанными" Тогда
		
		// Обновляем данные монитора
		ОбновитьДанныеМонитора();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ
#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура НастроитьСинхронизациюДанных(Элемент)
	
	ВыбраннаяСинхронизация = ВыбратьИзМеню(НастраиваемыеСинхронизации, Элемент);
	
	Если ВыбраннаяСинхронизация <> Неопределено Тогда
		
		ОбменДаннымиКлиент.ОткрытьПомощникНастройкиОбменаДанными(ВыбраннаяСинхронизация.Значение);
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ СписокСостоянияУзлов.

&НаКлиенте
Процедура СписокСостоянияУзловВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Ответ = Вопрос(НСтр("ru = 'Выполнить синхронизацию данных?'"), РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да);
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		АвтоматическаяСинхронизация = (Элементы.СписокСостоянияУзлов.ТекущиеДанные.ВариантОбменаДанными = "Синхронизация");
		
		Получатель = Элементы.СписокСостоянияУзлов.ТекущиеДанные.УзелИнформационнойБазы;
		
		ОбменДаннымиКлиент.ВыполнитьОбменДаннымиОбработкаКоманды(Получатель, ЭтаФорма,, АвтоматическаяСинхронизация);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСостоянияУзловПриАктивизацииСтроки(Элемент)
	
	ЗаданыТекущиеДанные = Элементы.СписокСостоянияУзлов.ТекущиеДанные <> Неопределено;
	
	Элементы.Настройка.Доступность = ЗаданыТекущиеДанные;
	Элементы.СписокСостоянияУзловИзменитьУзелИнформационнойБазы.Доступность = ЗаданыТекущиеДанные;
	
	Элементы.ГруппаКнопокВыполненияОбменаДанными.Доступность = ЗаданыТекущиеДанные;
	Элементы.КонтекстноеМенюСписокСостоянияДиагностика.Доступность = ЗаданыТекущиеДанные;
	Элементы.ГруппаКнопокНастройкиРасписания.Доступность = ЗаданыТекущиеДанные;
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьОбменДанными(Команда)
	
	Если КоличествоСинхронизаций = 1 Тогда
		
		УзелОбмена = СписокСостоянияУзлов[0].УзелИнформационнойБазы;
		АвтоматическаяСинхронизация = (СписокСостоянияУзлов[0].ВариантОбменаДанными = "Синхронизация");
		
	Иначе
		
		ТекущиеДанные = Элементы.СписокСостоянияУзлов.ТекущиеДанные;
		
		Если ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		УзелОбмена = ТекущиеДанные.УзелИнформационнойБазы;
		АвтоматическаяСинхронизация = (ТекущиеДанные.ВариантОбменаДанными = "Синхронизация");
		
	КонецЕсли;
	
	ОбменДаннымиКлиент.ВыполнитьОбменДаннымиОбработкаКоманды(УзелОбмена, ЭтаФорма,, АвтоматическаяСинхронизация);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбменДаннымиИнтерактивно(Команда)
	
	Если КоличествоСинхронизаций = 1 Тогда
		
		УзелОбмена = СписокСостоянияУзлов[0].УзелИнформационнойБазы;
		
	Иначе
		
		ТекущиеДанные = Элементы.СписокСостоянияУзлов.ТекущиеДанные;
		
		Если ТекущиеДанные = Неопределено Тогда
			
			Возврат;
			
		КонецЕсли;
		
		УзелОбмена = ТекущиеДанные.УзелИнформационнойБазы;
		
	КонецЕсли;
	
	ТекущиеДанные = Элементы.СписокСостоянияУзлов.ТекущиеДанные;
	ОбменДаннымиКлиент.ОткрытьПомощникСопоставленияОбъектовОбработкаКоманды(УзелОбмена, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьСценарииОбменаДанными(Команда)
	
	ТекущиеДанные = Элементы.СписокСостоянияУзлов.ТекущиеДанные;
	
	ОбменДаннымиКлиент.ОбработкаКомандыНастроитьРасписаниеВыполненияОбмена(ТекущиеДанные.УзелИнформационнойБазы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьМонитор(Команда)
	
	ОбновитьДанныеМонитора();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьУзелИнформационнойБазы(Команда)
	
	Если КоличествоСинхронизаций = 1 Тогда
		
		УзелОбмена = СписокСостоянияУзлов[0].УзелИнформационнойБазы;
		
	Иначе
		
		ТекущиеДанные = Элементы.СписокСостоянияУзлов.ТекущиеДанные;
		УзелОбмена = ТекущиеДанные.УзелИнформационнойБазы;
		
	КонецЕсли;
	
	ОткрытьЗначение(УзелОбмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиВЖурналРегистрацииСобытийЗагрузкиДанных(Команда)
	
	Если КоличествоСинхронизаций = 1 Тогда
		
		УзелОбмена = СписокСостоянияУзлов[0].УзелИнформационнойБазы;
		
	Иначе
		
		ТекущиеДанные = Элементы.СписокСостоянияУзлов.ТекущиеДанные;
		УзелОбмена = ТекущиеДанные.УзелИнформационнойБазы;
		
	КонецЕсли;
	
	ОбменДаннымиКлиент.ПерейтиВЖурналРегистрацииСобытийДанныхМодально(УзелОбмена, ЭтаФорма, "ЗагрузкаДанных");
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиВЖурналРегистрацииСобытийВыгрузкиДанных(Команда)
	
	Если КоличествоСинхронизаций = 1 Тогда
		
		УзелОбмена = СписокСостоянияУзлов[0].УзелИнформационнойБазы;
		
	Иначе
		
		ТекущиеДанные = Элементы.СписокСостоянияУзлов.ТекущиеДанные;
		УзелОбмена = ТекущиеДанные.УзелИнформационнойБазы;
		
	КонецЕсли;
	
	ОбменДаннымиКлиент.ПерейтиВЖурналРегистрацииСобытийДанныхМодально(УзелОбмена, ЭтаФорма, "ВыгрузкаДанных");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПомощникНастройкиОбменаДанными(Команда)
	
	ОбменДаннымиКлиент.ОткрытьПомощникНастройкиОбменаДанными(Команда.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОбновление(Команда)
	ОбменДаннымиКлиент.бспВыполнитьОбновлениеИнформационнойБазы();
КонецПроцедуры

&НаКлиенте
Процедура НастроитьСинхронизациюДанныхОдна(Команда)
	
	НастроитьСинхронизациюДанных(Элементы.НастроитьСинхронизациюДанныхОдна);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьСинхронизациюДанныхНеНастроена(Команда)
	
	НастроитьСинхронизациюДанных(Элементы.НастроитьСинхронизациюДанныхНеНастроена);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьСценарииОбменаДаннымиОдна(Команда)
	
	УзелОбмена = СписокСостоянияУзлов[0].УзелИнформационнойБазы;
	
	СценарийСинхронизации = СценарийСинхронизацииПоУзлу(УзелОбмена);
	ПараметрыФормы = Новый Структура;
	
	Если СценарийСинхронизации = Неопределено Тогда
		
		ПараметрыФормы.Вставить("УзелИнформационнойБазы", УзелОбмена);
		
	Иначе
		
		ПараметрыФормы.Вставить("Ключ", СценарийСинхронизации);
		
	КонецЕсли;
	
	ОткрытьФорму("Справочник.СценарииОбменовДанными.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьУспешные(Команда)
	
	СкрыватьУспешные = Не СкрыватьУспешные;
	
	Элементы.СписокСостоянияУзловСкрыватьУспешные.Пометка = СкрыватьУспешные;
	
	ОбновитьСписокСостоянияУзлов(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ИнформацияПоОбмену(Команда)
	
	Если КоличествоСинхронизаций = 1 Тогда
		
		УзелОбмена = СписокСостоянияУзлов[0].УзелИнформационнойБазы;
		
	Иначе
		
		ТекущиеДанные = Элементы.СписокСостоянияУзлов.ТекущиеДанные;
		УзелОбмена = ТекущиеДанные.УзелИнформационнойБазы;
		
	КонецЕсли;
	
	СсылкаНаПодробноеОписание = ПодробнаяИнформацияНаСервере(УзелОбмена);
	
	ОбменДаннымиКлиент.ОткрытьПодробноеОписаниеСинхронизации(СсылкаНаПодробноеОписание);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРезультатыОднаСинхронизация(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("УзлыОбмена", МассивИспользуемыхУзлов(СписокСостоянияУзлов));
	ОткрытьФорму("РегистрСведений.РезультатыОбменаДанными.Форма.Форма", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура СоставОтправляемыхДанных(Команда)
	
	Если КоличествоСинхронизаций = 1 Тогда
		
		УзелОбмена = СписокСостоянияУзлов[0].УзелИнформационнойБазы;
		
	Иначе
		
		ТекущиеДанные = Элементы.СписокСостоянияУзлов.ТекущиеДанные;
		
		Если ТекущиеДанные = Неопределено Тогда
			
			Возврат;
			
		КонецЕсли;
		
		УзелОбмена = ТекущиеДанные.УзелИнформационнойБазы;
		
	КонецЕсли;
	
	ОбменДаннымиКлиент.ОткрытьСоставОтправляемыхДанных(УзелОбмена);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьНастройкуСинхронизации(Команда)
	
	Если КоличествоСинхронизаций = 1 Тогда
		
		УзелОбмена = СписокСостоянияУзлов[0].УзелИнформационнойБазы;
		
	Иначе
		
		ТекущиеДанные = Элементы.СписокСостоянияУзлов.ТекущиеДанные;
		
		Если ТекущиеДанные = Неопределено Тогда
			
			Возврат;
			
		КонецЕсли;
		
		УзелОбмена = ТекущиеДанные.УзелИнформационнойБазы;
		
	КонецЕсли;
	
	ОбменДаннымиКлиент.УдалитьНастройкуСинхронизации(УзелОбмена);
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьДанныеМонитора()
	
	ИндексСтрокиСписокСостоянияУзлов = ПолучитьТекущийИндексСтроки("СписокСостоянияУзлов");
	
	// Выполняем обновление таблиц монитора на сервере
	ОбновитьСписокСостоянияУзлов();
	
	// Выполняем позиционирование курсора
	ВыполнитьПозиционированиеКурсора("СписокСостоянияУзлов", ИндексСтрокиСписокСостоянияУзлов);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокСостоянияУзлов(ТолькоОбновлениеСписка = Ложь)
	
	// Обновляем данные в списке состояния узлов
	СписокСостоянияУзлов.Загрузить(ОбменДаннымиСервер.ТаблицаМонитораОбменаДанными(ОбменДаннымиПовтИсп.ПланыОбменаБСП(), "Код", СкрыватьУспешные));
	
	Если Не ТолькоОбновлениеСписка Тогда
		
		ПроверитьСостояниеОбменаСГлавнымУзлом();
		
		Если КоличествоСинхронизаций <> СписокСостоянияУзлов.Количество() Тогда
			
			ОбновитьКоличествоСинхронизаций();
			
		ИначеЕсли КоличествоСинхронизаций = 1 Тогда
			
			УстановитьЭлементыОднойСинхронизации();
			
		КонецЕсли;
		
		ОбновитьКомандыРезультатовСинхронизации();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьКоличествоСинхронизаций()
	
	КоличествоСинхронизаций = СписокСостоянияУзлов.Количество();
	ПанельСинхронизации = Элементы.СинхронизацияДанных;
	ЕстьПравоОбновления = ПравоДоступа("ОбновлениеКонфигурацииБазыДанных", Метаданные);
	
	Если КоличествоСинхронизаций = 0 Тогда
		
		ПанельСинхронизации.ТекущаяСтраница = ПанельСинхронизации.ПодчиненныеЭлементы.СинхронизацияНеНастроена;
		Заголовок = НСтр("ru = 'Синхронизация данных'");
		
	ИначеЕсли КоличествоСинхронизаций = 1 Тогда
		
		Элементы.ПравоОбновленияСтраницы.ТекущаяСтраница = ?(ЕстьПравоОбновления, 
			Элементы.ПравоОбновленияСтраницы.ПодчиненныеЭлементы.ИнформацияОбменДаннымиПриостановленЕстьПравоОбновления1,
			Элементы.ПравоОбновленияСтраницы.ПодчиненныеЭлементы.ИнформацияОбменДаннымиПриостановленНетПраваОбновления1);
			
		УстановитьЭлементыОднойСинхронизации();
		
		ПанельСинхронизации.ТекущаяСтраница = ПанельСинхронизации.ПодчиненныеЭлементы.ОднаСинхронизация;
		
	Иначе
		
		ПанельСинхронизации.ТекущаяСтраница = ПанельСинхронизации.ПодчиненныеЭлементы.НесколькоСинхронизаций;
		
		Элементы.СписокСостоянияУзловИзменитьУзелИнформационнойБазы.Видимость = РольДоступнаДобавлениеИзменениеОбменовДанными;
		Элементы.НастроитьРасписаниеВыполненияОбмена.Видимость = РольДоступнаДобавлениеИзменениеОбменовДанными;
		Элементы.НастроитьРасписаниеВыполненияОбмена1.Видимость = РольДоступнаДобавлениеИзменениеОбменовДанными;
		
		Элементы.ИнформацияОбменДаннымиПриостановленЕстьПравоОбновления.Видимость = ЕстьПравоОбновления;
		Элементы.ИнформацияОбменДаннымиПриостановленНетПраваОбновления.Видимость = Не ЕстьПравоОбновления;
		
		НадписьОбменДаннымиПриостановлен = ?(ЕстьПравоОбновления,
		Элементы.НадписьОбменДаннымиПриостановленЕстьПравоОбновления,
		Элементы.НадписьОбменДаннымиПриостановленНетПраваОбновления);
		
		НадписьОбменДаннымиПриостановлен.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НадписьОбменДаннымиПриостановлен.Заголовок, ОбменДаннымиСервер.ГлавныйУзел());
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьКомандыРезультатовСинхронизации()
	
	Если КоличествоСинхронизаций <> 0 Тогда
		
		СтруктураЗаголовка = ОбменДаннымиСервер.СтруктураЗаголовкаГиперссылкиМонитораПроблем(МассивИспользуемыхУзлов(СписокСостоянияУзлов));
		
		Если КоличествоСинхронизаций = 1 Тогда
			
			ЗаполнитьЗначенияСвойств(Элементы.ОткрытьРезультатыОднаСинхронизация, СтруктураЗаголовка);
			
		ИначеЕсли КоличествоСинхронизаций > 1 Тогда
			
			ЗаполнитьЗначенияСвойств(Элементы.ОткрытьРезультатыСинхронизацииДанных, СтруктураЗаголовка);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция МассивИспользуемыхУзлов(СписокСостоянияУзлов)
	
	УзлыОбмена = Новый Массив;
	
	Для Каждого СтрокаУзла Из СписокСостоянияУзлов Цикл
		УзлыОбмена.Добавить(СтрокаУзла.УзелИнформационнойБазы);
	КонецЦикла;
	
	Возврат УзлыОбмена;
	
КонецФункции

&НаСервере
Процедура УстановитьЭлементыОднойСинхронизации()
	
	НастроеннаяСинхронизация = СписокСостоянияУзлов[0];
	
	Если НастроеннаяСинхронизация.УзелИнформационнойБазы = Неопределено Тогда
		
		ВызватьИсключение НСтр("ru = 'Работа монитора синхронизации данных в неразделенном сеансе не поддерживается'");
		
	КонецЕсли;
	
	ЗаголовокФормы = НСтр("ru = 'Синхронизация данных с ""%Программа%""'");
		ЗаголовокФормы = СтрЗаменить(ЗаголовокФормы, "%Программа%", НастроеннаяСинхронизация.УзелИнформационнойБазы.Наименование);
		Заголовок = ЗаголовокФормы;
		
	Если ЕстьПравоНаПросмотрЖурналаРегистрации Тогда
			
		Элементы.ДатаУспешнойЗагрузки.Заголовок = НастроеннаяСинхронизация.ПредставлениеДатыПоследнейУспешнойЗагрузки;
		Элементы.ДатаУспешнойВыгрузки.Заголовок = НастроеннаяСинхронизация.ПредставлениеДатыПоследнейУспешнойВыгрузки;
		
	Иначе
		
		Элементы.НадписьДатаПолучения.Заголовок = НастроеннаяСинхронизация.ПредставлениеДатыПоследнейУспешнойЗагрузки;
		Элементы.НадписьДатаОтправки.Заголовок = НастроеннаяСинхронизация.ПредставлениеДатыПоследнейУспешнойВыгрузки;
		
	КонецЕсли;
	
	ПустаяДата = Дата(1, 1, 1);
	
	Если НастроеннаяСинхронизация.ДатаПоследнейУспешнойВыгрузки <> НастроеннаяСинхронизация.ДатаПоследнейВыгрузки
		Или НастроеннаяСинхронизация.ДатаПоследнейВыгрузки <> ПустаяДата
		Или НастроеннаяСинхронизация.РезультатПоследнейВыгрузкиДанных <> 0 Тогда
		
		ПодсказкаВыгрузки = НСтр("ru = 'Данные отправлены: %ДатаОтправки%
										|Последняя попытка: %ДатаПопытки%'");
		ПодсказкаВыгрузки = СтрЗаменить(ПодсказкаВыгрузки, "%ДатаОтправки%", НастроеннаяСинхронизация.ПредставлениеДатыПоследнейУспешнойВыгрузки);
		ПодсказкаВыгрузки = СтрЗаменить(ПодсказкаВыгрузки, "%ДатаПопытки%", НастроеннаяСинхронизация.ПредставлениеДатыПоследнейВыгрузки);
		
	Иначе
		
		ПодсказкаВыгрузки = "";
		
	КонецЕсли;
	
	Если НастроеннаяСинхронизация.ДатаПоследнейУспешнойЗагрузки <> НастроеннаяСинхронизация.ДатаПоследнейЗагрузки
		Или НастроеннаяСинхронизация.ДатаПоследнейЗагрузки <> ПустаяДата
		Или НастроеннаяСинхронизация.РезультатПоследнейЗагрузкиДанных <> 0 Тогда
		
		ПодсказкаЗагрузки = НСтр("ru = 'Данные получены: %ДатаПолучения%
										|Последняя попытка: %ДатаПопытки%'");
		ПодсказкаЗагрузки = СтрЗаменить(ПодсказкаЗагрузки, "%ДатаПолучения%", НастроеннаяСинхронизация.ПредставлениеДатыПоследнейУспешнойЗагрузки);
		ПодсказкаЗагрузки = СтрЗаменить(ПодсказкаЗагрузки, "%ДатаПопытки%", НастроеннаяСинхронизация.ПредставлениеДатыПоследнейЗагрузки);
		
	Иначе
		
		ПодсказкаЗагрузки = "";
		
	КонецЕсли;
	
	Если НастроеннаяСинхронизация.РезультатПоследнейЗагрузкиДанных =2 Тогда
		НастроеннаяСинхронизация.РезультатПоследнейЗагрузкиДанных = ?(ОбменДаннымиСервер.ОбменДаннымиВыполненСПредупреждениями(НастроеннаяСинхронизация.УзелИнформационнойБазы), 2, 0);
	КонецЕсли;
	
	КартинкаСтатуса(Элементы.ДекорацияСтатусЗагрузки, НастроеннаяСинхронизация.РезультатПоследнейЗагрузкиДанных, ПодсказкаЗагрузки);
	КартинкаСтатуса(Элементы.ДекорацияСтатусВыгрузки, НастроеннаяСинхронизация.РезультатПоследнейВыгрузкиДанных, ПодсказкаВыгрузки);
	
	Элементы.ДекорацияСтатусПустой.Видимость = Истина;
	Если НастроеннаяСинхронизация.РезультатПоследнейЗагрузкиДанных <> 0
		Или (НастроеннаяСинхронизация.РезультатПоследнейЗагрузкиДанных = 0
		И НастроеннаяСинхронизация.РезультатПоследнейВыгрузкиДанных = 0) Тогда
		
		Элементы.ДекорацияСтатусПустой.Видимость = Ложь;
		
	КонецЕсли;
	
	Элементы.ДекорацияУспешнаяЗагрузка.Подсказка = Элементы.ДекорацияСтатусЗагрузки.Подсказка;
	Элементы.ДекорацияУспешнаяВыгрузка.Подсказка = Элементы.ДекорацияСтатусВыгрузки.Подсказка;
	
	Если ОбменДаннымиПовтИсп.ЭтоУзелРаспределеннойИнформационнойБазы(НастроеннаяСинхронизация.УзелИнформационнойБазы) Тогда
		
		Элементы.ВыполнитьОбменДаннымиИнтерактивно2.Видимость = Ложь;
		
	КонецЕсли;
	
	ОписаниеПравилСинхронизацииДанных = ОбменДаннымиСервер.ОписаниеПравилСинхронизацииДанных(НастроеннаяСинхронизация.УзелИнформационнойБазы);
	Элементы.ОписаниеПравилСинхронизацииДанных.Высота = СтрЧислоСтрок(ОписаниеПравилСинхронизацииДанных);
	
	РасписаниеУзлаИнформационнойБазы = РасписаниеУзлаИнформационнойБазы(НастроеннаяСинхронизация.УзелИнформационнойБазы);
	
	Если РасписаниеУзлаИнформационнойБазы <> Неопределено Тогда
		
		РасписаниеСинхронизацииДанных = РасписаниеУзлаИнформационнойБазы;
		
	Иначе
		
		РасписаниеСинхронизацииДанных = НСтр("ru = 'Расписание синхронизации не настроено'");;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьКомандыСозданияНовогоОбмена()
	
	СписокПлановОбмена = ОбменДаннымиПовтИсп.СписокПлановОбменаБСП();
	
	Для Каждого Элемент ИЗ СписокПлановОбмена Цикл
		
		ИмяПланаОбмена = Элемент.Значение;
		
		МенеджерПланаОбмена = ПланыОбмена[ИмяПланаОбмена];
		
		Если МенеджерПланаОбмена.ИспользоватьПомощникСозданияОбменаДанными() 
			И ОбменДаннымиПовтИсп.ДоступноИспользованиеПланаОбмена(ИмяПланаОбмена) Тогда
			
			ЗаголовокКоманды = МенеджерПланаОбмена.ЗаголовокКомандыДляСозданияНовогоОбменаДанными();
			
			Команды.Добавить(ИмяПланаОбмена);
			Команды[ИмяПланаОбмена].Заголовок = ЗаголовокКоманды + "...";
			Команды[ИмяПланаОбмена].Действие  = "ОткрытьПомощникНастройкиОбменаДанными";
			
			Если Метаданные.ПланыОбмена[ИмяПланаОбмена].РаспределеннаяИнформационнаяБаза Тогда
				
				Элементы.Добавить(ИмяПланаОбмена, Тип("КнопкаФормы"), Элементы.ПодменюРиб);
				Элементы[ИмяПланаОбмена].ИмяКоманды = ИмяПланаОбмена;
				
				НастраиваемыеСинхронизации.Добавить(ИмяПланаОбмена, Команды[ИмяПланаОбмена].Заголовок);
				
			Иначе
				
				Элементы.Добавить(ИмяПланаОбмена, Тип("КнопкаФормы"), Элементы.ПодменюПрочее);
				Элементы[ИмяПланаОбмена].ИмяКоманды = ИмяПланаОбмена;
				
				НастраиваемыеСинхронизации.Добавить(ИмяПланаОбмена, Команды[ИмяПланаОбмена].Заголовок);
				
				Если МенеджерПланаОбмена.КорреспондентВМоделиСервиса() Тогда
					
					ИмяКоманды = "[ИмяПланаОбмена]КорреспондентВМоделиСервиса";
					ИмяКоманды = СтрЗаменить(ИмяКоманды, "[ИмяПланаОбмена]", ИмяПланаОбмена);
					
					Команды.Добавить(ИмяКоманды);
					Команды[ИмяКоманды].Заголовок = ЗаголовокКоманды + НСтр("ru = ' (в сервисе)...'");
					Команды[ИмяКоманды].Действие  = "ОткрытьПомощникНастройкиОбменаДанными";
					
					Элементы.Добавить(ИмяКоманды, Тип("КнопкаФормы"), Элементы.ПодменюПрочее);
					Элементы[ИмяКоманды].ИмяКоманды = ИмяКоманды;
					
					НастраиваемыеСинхронизации.Добавить(ИмяКоманды, Команды[ИмяКоманды].Заголовок);
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьТекущийИндексСтроки(ИмяТаблицы)
	
	// Возвращаемое значение функции
	ИндексСтроки = Неопределено;
	
	// При обновлении монитора выполняем позиционирование курсора.
	ТекущиеДанные = Элементы[ИмяТаблицы].ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		ИндексСтроки = ЭтаФорма[ИмяТаблицы].Индекс(ТекущиеДанные);
		
	КонецЕсли;
	
	Возврат ИндексСтроки;
КонецФункции

&НаКлиенте
Процедура ВыполнитьПозиционированиеКурсора(ИмяТаблицы, ИндексСтроки)
	
	Если ИндексСтроки <> Неопределено Тогда
		
		// Выполняем проверки позиционирования курсора после получения новых данных.
		Если ЭтаФорма[ИмяТаблицы].Количество() <> 0 Тогда
			
			Если ИндексСтроки > ЭтаФорма[ИмяТаблицы].Количество() - 1 Тогда
				
				ИндексСтроки = ЭтаФорма[ИмяТаблицы].Количество() - 1;
				
			КонецЕсли;
			
			// Позиционируем курсор
			Элементы[ИмяТаблицы].ТекущаяСтрока = ЭтаФорма[ИмяТаблицы][ИндексСтроки].ПолучитьИдентификатор();
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Если спозиционировать строку не удалось, то устанавливаем текущей первую строку.
	Если Элементы[ИмяТаблицы].ТекущаяСтрока = Неопределено
		И ЭтаФорма[ИмяТаблицы].Количество() <> 0 Тогда
		
		Элементы[ИмяТаблицы].ТекущаяСтрока = ЭтаФорма[ИмяТаблицы][0].ПолучитьИдентификатор();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьСостояниеОбменаСГлавнымУзлом()
	
	ТребуетсяОбновление = ОбменДаннымиВызовСервера.ТребуетсяУстановкаОбновления();
	
	Элементы.ИнформационнаяПанельТребуетсяОбновление1.Видимость = ТребуетсяОбновление;
	Элементы.ИнформационнаяПанельТребуетсяОбновление.Видимость = ТребуетсяОбновление;
	
	Элементы.ВыполнитьОбменДанными2.Видимость = Не ТребуетсяОбновление;
	
КонецПроцедуры

&НаСервере
Функция СценарийСинхронизацииПоУзлу (УзелИнформационнойБазы)
	
	НастроенныйСценарий = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	|	СценарииОбменовДанными.Ссылка
	|ИЗ
	|	Справочник.СценарииОбменовДанными КАК СценарииОбменовДанными
	|ГДЕ
	|	СценарииОбменовДанными.НастройкиОбмена.УзелИнформационнойБазы = &УзелИнформационнойБазы
	|	И СценарииОбменовДанными.ПометкаУдаления = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("УзелИнформационнойБазы", УзелИнформационнойБазы);
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		НастроенныйСценарий = Выборка.Ссылка;
		
	КонецЕсли;
	
	Возврат НастроенныйСценарий;
	
КонецФункции

&НаСервере
Функция РасписаниеУзлаИнформационнойБазы(УзелИнформационнойБазы)
	
	РасписаниеРегламентногоЗадания = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	|	СценарииОбменовДанными.РегламентноеЗаданиеGUID
	|ИЗ
	|	Справочник.СценарииОбменовДанными КАК СценарииОбменовДанными
	|ГДЕ
	|	СценарииОбменовДанными.ИспользоватьРегламентноеЗадание = ИСТИНА
	|	И СценарииОбменовДанными.НастройкиОбмена.УзелИнформационнойБазы = &УзелИнформационнойБазы
	|	И СценарииОбменовДанными.ПометкаУдаления = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("УзелИнформационнойБазы", УзелИнформационнойБазы);
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		
		Выборка.Следующий();
		
		РегламентноеЗаданиеОбъект = ОбменДаннымиВызовСервера.НайтиРегламентноеЗаданиеПоПараметру(Выборка.РегламентноеЗаданиеGUID);
		Если РегламентноеЗаданиеОбъект <> Неопределено Тогда
			РасписаниеРегламентногоЗадания = РегламентноеЗаданиеОбъект.Расписание;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат РасписаниеРегламентногоЗадания;
	
КонецФункции

&НаСервере
Процедура КартинкаСтатуса(ЭлементУправления, ВидСобытия, Подсказка)

	Если ВидСобытия = 1 Тогда
		ЭлементУправления.Картинка = БиблиотекаКартинок.СостояниеОбменаДаннымиОшибка;
		ЭлементУправления.Видимость = Истина;
	ИначеЕсли ВидСобытия = 2 Тогда
		ЭлементУправления.Картинка = БиблиотекаКартинок.Предупреждение32;
		ЭлементУправления.Видимость = Истина;
	Иначе
		ЭлементУправления.Видимость = Ложь;
	КонецЕсли;
	
	ЭлементУправления.Подсказка = Подсказка;
	
КонецПроцедуры

&НаСервере
Функция ПодробнаяИнформацияНаСервере(УзелОбмена)
	
	МенеджерПланаОбмена = ПланыОбмена[УзелОбмена.Метаданные().Имя];
	СсылкаНаПодробноеОписание = МенеджерПланаОбмена.ПодробнаяИнформацияПоОбмену();
	
	Возврат СсылкаНаПодробноеОписание;
	
КонецФункции

&НаКлиенте
Процедура НастройкиТранспорта(Команда)
	
	Если КоличествоСинхронизаций = 1 Тогда
		
		УзелОбмена = СписокСостоянияУзлов[0].УзелИнформационнойБазы;
		
	Иначе
		
		ТекущиеДанные = Элементы.СписокСостоянияУзлов.ТекущиеДанные;
		УзелОбмена = ТекущиеДанные.УзелИнформационнойБазы;
		
	КонецЕсли;
	
	Отбор              = Новый Структура("Узел", УзелОбмена);
	ЗначенияЗаполнения = Новый Структура("Узел", УзелОбмена);
	
	ОбменДаннымиКлиент.ОткрытьФормуЗаписиРегистраСведенийПоОтбору(Отбор, ЗначенияЗаполнения, "НастройкиТранспортаОбмена", ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти
