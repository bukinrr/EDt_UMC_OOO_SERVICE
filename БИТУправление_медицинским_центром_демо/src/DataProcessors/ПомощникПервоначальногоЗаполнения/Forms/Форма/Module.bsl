
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗагрузитьСписокВстроенныхШаблонов();
	ЗагрузитьСписокВстроенныхМедосмотровСправок();
	ЗагрузитьСписокВстроенныхВидовСегментации();
	ЗагрузитьСписокВстроенныхЯчеекЖурналаЗаписи();
	ЗагрузитьСписокВстроенныхСтандартовЛечения();
	
	ПравоСохраненияДанных = ПравоДоступа("СохранениеДанныхПользователя", Метаданные);
	
	Если Не ПравоСохраненияДанных Тогда
		Элементы.ПоказыватьПриОткрытииПрограммы.Видимость = Ложь;
	Иначе
		ПоказыватьПриОткрытииПрограммы = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ПомощникПервоначальногоЗаполнения", "Показывать", Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Устанавливаем текущую таблицу переходов.
	ТаблицаПереходовПоСценарию();
	
	// Позиционируемся на первом шаге помощника.
	УстановитьПорядковыйНомерПерехода(0);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗакрытьФормуБезусловно Тогда
		Отказ = Вопрос(НСтр("ru = 'Закрыть помощник заполнения?'"),
				РежимДиалогаВопрос.ОКОтмена,
				30,
				КодВозвратаДиалога.ОК) = КодВозвратаДиалога.Отмена
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если Не ЗавершениеРаботы И ПравоСохраненияДанных Тогда
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ПомощникПервоначальногоЗаполнения", "Показывать", ПоказыватьПриОткрытииПрограммы);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаДалее(Команда)
	
	ИзменитьПорядковыйНомерПерехода(+1);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНазад(Команда)
	
	ИзменитьПорядковыйНомерПерехода(-1);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаГотово(Команда)
	
	ЗакрытьФормуБезусловно = Истина;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Поставляемая часть

&НаКлиенте
Процедура ИзменитьПорядковыйНомерПерехода(Итератор)
	
	ОчиститьСообщения();
	
	УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + Итератор);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПорядковыйНомерПерехода(Знач Значение)
	
	ЭтоПереходДалее = (Значение > ПорядковыйНомерПерехода);
	
	ПорядковыйНомерПерехода = Значение;
	
	Если ПорядковыйНомерПерехода < 0 Тогда
		
		ПорядковыйНомерПерехода = 0;
		
	КонецЕсли;
	
	ПорядковыйНомерПереходаПриИзменении(ЭтоПереходДалее);
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядковыйНомерПереходаПриИзменении(Знач ЭтоПереходДалее)
	
	// Выполняем обработчики событий перехода.
	ВыполнитьОбработчикиСобытийПерехода(ЭтоПереходДалее);
	
	// Устанавливаем отображение страниц.
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	Элементы.ПанельОсновная.ТекущаяСтраница  = Элементы[СтрокаПереходаТекущая.ИмяОсновнойСтраницы];
	Элементы.ПанельНавигации.ТекущаяСтраница = Элементы[СтрокаПереходаТекущая.ИмяСтраницыНавигации];
	
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяСтраницыДекорации) Тогда
		
		Элементы.ПанельДекорации.ТекущаяСтраница = Элементы[СтрокаПереходаТекущая.ИмяСтраницыДекорации];
		
	КонецЕсли;
	
	// Устанавливаем текущую кнопку по умолчанию.
	КнопкаДалее = ПолучитьКнопкуФормыПоИмениКоманды(Элементы.ПанельНавигации.ТекущаяСтраница, "КомандаДалее");
	
	Если КнопкаДалее <> Неопределено Тогда
		
		КнопкаДалее.КнопкаПоУмолчанию = Истина;
		
	Иначе
		
		КнопкаГотово = ПолучитьКнопкуФормыПоИмениКоманды(Элементы.ПанельНавигации.ТекущаяСтраница, "КомандаГотово");
		
		Если КнопкаГотово <> Неопределено Тогда
			
			КнопкаГотово.КнопкаПоУмолчанию = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЭтоПереходДалее И СтрокаПереходаТекущая.ДлительнаяОперация Тогда
		
		ПодключитьОбработчикОжидания("ВыполнитьОбработчикДлительнойОперации", 0.1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработчикиСобытийПерехода(Знач ЭтоПереходДалее)
	
	// Обработчики событий переходов.
	Если ЭтоПереходДалее Тогда
		
		СтрокиПерехода = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода - 1));
		
		Если СтрокиПерехода.Количество() > 0 Тогда
			
			СтрокаПерехода = СтрокиПерехода[0];
			
			// Обработчик ПриПереходеДалее
			Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеДалее)
				И Не СтрокаПерехода.ДлительнаяОперация Тогда
				
				ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ)";
				ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеДалее);
				
				Отказ = Ложь;
				
				Результат = Вычислить(ИмяПроцедуры);
				
				Если Отказ Тогда
					
					УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
					
					Возврат;
					
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	Иначе
		СтрокиПерехода = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода + 1));
		
		Если СтрокиПерехода.Количество() > 0 Тогда
			
			СтрокаПерехода = СтрокиПерехода[0];
			
			// Обработчик ПриПереходеНазад
			Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеНазад)
				И Не СтрокаПерехода.ДлительнаяОперация Тогда
				
				ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ)";
				ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеНазад);
				
				Отказ = Ложь;
				
				Результат = Вычислить(ИмяПроцедуры);
				
				Если Отказ Тогда
					
					УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
					
					Возврат;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	Если СтрокаПереходаТекущая.ДлительнаяОперация И Не ЭтоПереходДалее Тогда
		
		УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
		Возврат;
	КонецЕсли;
	
	// Обработчик ПриОткрытии
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии) Тогда
		
		ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ, ПропуститьСтраницу, ЭтоПереходДалее)";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии);
		
		Отказ = Ложь;
		ПропуститьСтраницу = Ложь;
		
		Результат = Вычислить(ИмяПроцедуры);
		
		Если Отказ Тогда
			
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
			
			Возврат;
			
		ИначеЕсли ПропуститьСтраницу Тогда
			
			Если ЭтоПереходДалее Тогда
				
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
				
				Возврат;
				
			Иначе
				
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
				
				Возврат;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработчикДлительнойОперации()
	
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	// Обработчик ОбработкаДлительнойОперации
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаДлительнойОперации) Тогда
		
		ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ, ПерейтиДалее)";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаДлительнойОперации);
		
		Отказ = Ложь;
		ПерейтиДалее = Истина;
		
		Результат = Вычислить(ИмяПроцедуры);
		
		Если Отказ Тогда
			
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
			
			Возврат;
			
		ИначеЕсли ПерейтиДалее Тогда
			
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
			
			Возврат;
			
		КонецЕсли;
		
	Иначе
		
		УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

// Добавляет новую строку в конец текущей таблицы переходов.
//
// Параметры:
//
//  ПорядковыйНомерПерехода (обязательный) - Число. Порядковый номер перехода, который соответствует текущему шагу
//  перехода.
//  ИмяОсновнойСтраницы (обязательный) - Строка. Имя страницы панели "ПанельОсновная", которая соответствует текущему
//  номеру перехода.
//  ИмяСтраницыНавигации (обязательный) - Строка. Имя страницы панели "ПанельНавигации", которая соответствует текущему
//  номеру перехода.
//  ИмяСтраницыДекорации (необязательный) - Строка. Имя страницы панели "ПанельДекорации", которая соответствует
//  текущему номеру перехода.
//  ИмяОбработчикаПриОткрытии (необязательный) - Строка. Имя функции-обработчика события открытия текущей страницы
//  помощника.
//  ИмяОбработчикаПриПереходеДалее (необязательный) - Строка. Имя функции-обработчика события перехода на следующую
//  страницу помощника.
//  ИмяОбработчикаПриПереходеНазад (необязательный) - Строка. Имя функции-обработчика события перехода на предыдущую
//  страницу помощника.
//  ДлительнаяОперация (необязательный) - Булево. Признак отображения страницы длительной операции.
//  Истина - отображается страница длительной операции; Ложь - отображается обычная страница. Значение по умолчанию -
//           Ложь.
// 
&НаКлиенте
Процедура ТаблицаПереходовНоваяСтрока(ПорядковыйНомерПерехода,
									ИмяОсновнойСтраницы,
									ИмяСтраницыНавигации,
									ИмяСтраницыДекорации = "",
									ИмяОбработчикаПриОткрытии = "",
									ИмяОбработчикаПриПереходеДалее = "",
									ИмяОбработчикаПриПереходеНазад = "",
									ДлительнаяОперация = Ложь,
									ИмяОбработчикаДлительнойОперации = "")
	НоваяСтрока = ТаблицаПереходов.Добавить();
	
	НоваяСтрока.ПорядковыйНомерПерехода = ПорядковыйНомерПерехода;
	НоваяСтрока.ИмяОсновнойСтраницы     = ИмяОсновнойСтраницы;
	НоваяСтрока.ИмяСтраницыДекорации    = ИмяСтраницыДекорации;
	НоваяСтрока.ИмяСтраницыНавигации    = ИмяСтраницыНавигации;
	
	НоваяСтрока.ИмяОбработчикаПриПереходеДалее = ИмяОбработчикаПриПереходеДалее;
	НоваяСтрока.ИмяОбработчикаПриПереходеНазад = ИмяОбработчикаПриПереходеНазад;
	НоваяСтрока.ИмяОбработчикаПриОткрытии      = ИмяОбработчикаПриОткрытии;
	
	НоваяСтрока.ДлительнаяОперация = ДлительнаяОперация;
	НоваяСтрока.ИмяОбработчикаДлительнойОперации = ИмяОбработчикаДлительнойОперации;
	
	ПорядковыйНомерПерехода = ПорядковыйНомерПерехода + 1;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьКнопкуФормыПоИмениКоманды(ЭлементФормы, ИмяКоманды)
	
	Для Каждого Элемент Из ЭлементФормы.ПодчиненныеЭлементы Цикл
		
		Если ТипЗнч(Элемент) = Тип("ГруппаФормы") Тогда
			
			ЭлементФормыПоИмениКоманды = ПолучитьКнопкуФормыПоИмениКоманды(Элемент, ИмяКоманды);
			
			Если ЭлементФормыПоИмениКоманды <> Неопределено Тогда
				
				Возврат ЭлементФормыПоИмениКоманды;
				
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(Элемент) = Тип("КнопкаФормы")
			И Найти(Элемент.ИмяКоманды, ИмяКоманды) > 0 Тогда
			
			Возврат Элемент;
			
		Иначе
			
			Продолжить;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Переопределяемая часть - Инициализация переходов помощника.

// Процедура определяет таблицу переходов по сценарию №1.
// Для заполнения таблицы переходов используется процедура ТаблицаПереходовНоваяСтрока().
//
&НаКлиенте
Процедура ТаблицаПереходовПоСценарию()
	
	ТаблицаПереходов.Очистить();
	НомерПерехода = 0;
	
	ТаблицаПереходовНоваяСтрока(НомерПерехода, "СтраницаОдин",	"СтраницаНавигацииНачало",		"СтраницаДекорацииНачало");
	ТаблицаПереходовНоваяСтрока(НомерПерехода, "СтраницаДва",	"СтраницаНавигацииПродолжение",	"СтраницаДекорацииПродолжение");
	ТаблицаПереходовНоваяСтрока(НомерПерехода, "СтраницаТри",	"СтраницаНавигацииПродолжение",	"СтраницаДекорацииПродолжение");
	ТаблицаПереходовНоваяСтрока(НомерПерехода, "СтраницаЧетыре","СтраницаНавигацииПродолжение",	"СтраницаДекорацииПродолжение");
	ТаблицаПереходовНоваяСтрока(НомерПерехода, "СтраницаПять",	"СтраницаНавигацииПродолжение",	"СтраницаДекорацииПродолжение");
	
	Если ТаблицаМедосмотров.Количество() <> 0 Тогда
		ТаблицаПереходовНоваяСтрока(НомерПерехода, "СтраницаМедосмотрыСправок",	"СтраницаНавигацииПродолжение",	"СтраницаДекорацииПродолжение");
	КонецЕсли;
	
	Если СтандартыЛечения.Количество() <> 0 Тогда
		ТаблицаПереходовНоваяСтрока(НомерПерехода, "СтраницаСтандартыЛечения",	"СтраницаНавигацииПродолжение",	"СтраницаДекорацииПродолжение");
	КонецЕсли;
	
	ТаблицаПереходовНоваяСтрока(НомерПерехода, "СтраницаШесть",	"СтраницаНавигацииПродолжение",	"СтраницаДекорацииПродолжение");
	
	Если ВидыСегментации.Количество() <> 0 Тогда
		ТаблицаПереходовНоваяСтрока(НомерПерехода, "СтраницаВидыСегментации",	"СтраницаНавигацииПродолжение",	"СтраницаДекорацииПродолжение");
	КонецЕсли;
	
	ТаблицаПереходовНоваяСтрока(НомерПерехода, "СтраницаГотово","СтраницаНавигацииОкончание",	"СтраницаДекорацииОкончание");
	
КонецПроцедуры

#Область ШаблоныПриемов

&НаСервере
Процедура ЗагрузитьШаблоныСервер()
	
	ЗагружаемыеШаблоны = Новый ТаблицаЗначений;
	ЗагружаемыеШаблоны.Колонки.Добавить("Наименование", Новый ОписаниеТипов("Строка"));
	ЗагружаемыеШаблоны.Колонки.Добавить("ИмяМакета", Новый ОписаниеТипов("Строка"));
	
	МакетыШаблонов = Новый Массив;
	
	Для Каждого ГруппаДерева Из ТаблицаШаблонов.ПолучитьЭлементы() Цикл
		Для Каждого СтрокаДерева Из ГруппаДерева.ПолучитьЭлементы() Цикл
			Если СтрокаДерева.Использовать Тогда
				ЗаполнитьЗначенияСвойств(ЗагружаемыеШаблоны.Добавить(), СтрокаДерева);
				Если МакетыШаблонов.Найти(СтрокаДерева.ИмяМакета) = Неопределено Тогда
					МакетыШаблонов.Добавить(СтрокаДерева.ИмяМакета);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	ИмяФайла = ПолучитьИмяВременногоФайла("xml");
	МенеджерСправочникаШаблонов = Справочники.ШаблоныHTML;
	
	СсылкиНаЗагружаемыеШаблоны = Новый Массив; // Ссылки выбранных шаблонов из всех макетов.
	
	// Начинаем транзакцию, которую потом отменим.
	НачатьТранзакцию();
	
	Для Каждого ИмяМакета Из МакетыШаблонов Цикл
		
		Макет = МенеджерСправочникаШаблонов.ПолучитьМакет(ИмяМакета);
		
		Попытка
			
			Макет.Записать(ИмяФайла);
			
			// Наименования загружаемых шаблонов конкретно из этого макета.
			ЗагружаемыеШаблоныМакета = Новый Массив;
			СтрокиЗагружаемыеШаблоныМакета = ЗагружаемыеШаблоны.НайтиСтроки(Новый Структура("ИмяМакета", ИмяМакета));
			Для Каждого СтрокаЗагружаемыйШаблон Из СтрокиЗагружаемыеШаблоныМакета Цикл
				ЗагружаемыеШаблоныМакета.Добавить(СтрокаЗагружаемыйШаблон.Наименование);
			КонецЦикла;
			
			СсылкиНаЗагружаемыеШаблоныМакета = МенеджерСправочникаШаблонов.Импортировать(ИмяФайла, ЗагружаемыеШаблоныМакета);
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(СсылкиНаЗагружаемыеШаблоны, СсылкиНаЗагружаемыеШаблоныМакета, Истина);
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
		КонецПопытки;
		
	КонецЦикла;
	
	Если СсылкиНаЗагружаемыеШаблоны.Количество() <> 0 Тогда
		МенеджерСправочникаШаблонов.Экспортировать(СсылкиНаЗагружаемыеШаблоны, ИмяФайла);
		ЕстьЧтоИмпортировать = Истина;
	Иначе
		ЕстьЧтоИмпортировать = Ложь;
	КонецЕсли;
	
	// Отменяем ранее "загруженные" шаблоны.
	ОтменитьТранзакцию();
	
	Если ЕстьЧтоИмпортировать Тогда
		МенеджерСправочникаШаблонов.Импортировать(ИмяФайла);
	КонецЕсли;
	
	Попытка
		УдалитьФайлы(ИмяФайла);
	Исключение
	КонецПопытки;
	
	Справочники.РазделыМедицинскихКарт.ОбновитьШаблоныРазделовМедкарт();

КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСписокВстроенныхШаблонов()
	
	ТаблицаШаблонов.ПолучитьЭлементы().Очистить();
	
	ИмяФайла = ПолучитьИмяВременногоФайла("xml");
	ЧтениеXML = Новый ЧтениеXML;
	МенеджерСправочникаШаблонов = Справочники.ШаблоныHTML;
	
	СписокМакетов = Метаданные.Справочники.ШаблоныHTML.Макеты;
	Для Каждого МетаданныеМакета Из СписокМакетов Цикл
		Макет = МенеджерСправочникаШаблонов.ПолучитьМакет(МетаданныеМакета.Имя);
		Если ТипЗнч(Макет) = Тип("ДвоичныеДанные") Тогда
			
			Попытка
				Макет.Записать(ИмяФайла);
				
				СтрокаЭталонная = Справочники.ШаблоныHTML.ПолучитьЭталонныйXMLШаблона(ИмяФайла, Ложь);
				ЧтениеXML.УстановитьСтроку(СтрокаЭталонная);
				
				ГруппаДерева = ТаблицаШаблонов.ПолучитьЭлементы().Добавить();
				ГруппаДерева.Наименование = МетаданныеМакета.Синоним;
				
				Пока ЧтениеXML.Прочитать() Цикл
					Если ВозможностьЧтенияXML(ЧтениеXML) Тогда
						Данные = ПрочитатьXML(ЧтениеXML);
						Если ТипЗнч(Данные) = Тип("СправочникОбъект.ШаблоныHTML")
							И Не Данные.ЭтоГруппа
						Тогда
							ЭлементДерева = ГруппаДерева.ПолучитьЭлементы().Добавить();
							ЭлементДерева.Использовать = Ложь;
							ЭлементДерева.Наименование = Данные.Наименование;
							ЭлементДерева.ИмяМакета = МетаданныеМакета.Имя;
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;

			Исключение
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(МетаданныеМакета.Синоним + ": " + ОписаниеОшибки());
			КонецПопытки;
			ЧтениеXML.Закрыть();
		КонецЕсли;
	КонецЦикла;
	Попытка
		УдалитьФайлы(ИмяФайла);
	Исключение
	КонецПопытки;
	
	ШаблоныДеревоЗначений = РеквизитФормыВЗначение("ТаблицаШаблонов");
	Для Каждого ГруппаДерева Из ШаблоныДеревоЗначений.Строки Цикл
		ГруппаДерева.Строки.Сортировать("Наименование");
	КонецЦикла;
	ЗначениеВРеквизитФормы(ШаблоныДеревоЗначений, "ТаблицаШаблонов");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьШаблоны(Команда)
	
	Состояние("Загрузка шаблонов");
	ЗагрузитьШаблоныСервер();
	ПоказатьПредупреждение(,"Выбранные шаблоны успешно загружены!");
	ОчиститьСообщения();

КонецПроцедуры

&НаКлиенте
Процедура ШаблоныУстановитьВсеОтметки(Команда)
	ШаблоныУстановитьЗначениеВсехФлажков(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ШаблоныСнятьВсеОтметки(Команда)
	ШаблоныУстановитьЗначениеВсехФлажков(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ШаблоныУстановитьЗначениеВсехФлажков(Значение)
	
	Для Каждого Строка Из ТаблицаШаблонов.ПолучитьЭлементы() Цикл
		Строка.Использовать = Значение;
		Для Каждого Строка2Ур Из Строка.ПолучитьЭлементы() Цикл
			Строка2Ур.Использовать = Значение;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаШаблоновИспользоватьПриИзменении(Элемент)
	
	ТекущаяСтрока = ТаблицаШаблонов.НайтиПоИдентификатору(Элементы.ТаблицаШаблонов.ТекущаяСтрока);
	Использовать = ТекущаяСтрока.Использовать;
	
	ЭлементыГруппы = ТекущаяСтрока.ПолучитьЭлементы();
	Если ЭлементыГруппы.Количество() > 0 Тогда
		// Простановка пометки вниз по дереву.
		Для Каждого СтрокаДерева Из ЭлементыГруппы Цикл
			СтрокаДерева.Использовать = Использовать;
		КонецЦикла;
	ИначеЕсли Не Использовать Тогда
		СтрокаРодитель = ТекущаяСтрока.ПолучитьРодителя();
		Если СтрокаРодитель <> Неопределено 
			И СтрокаРодитель.Использовать
		Тогда
			// Снятие пометки у родителя
			СтрокаРодитель.Использовать = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Справки

&НаСервере
Процедура ЗагрузитьСписокВстроенныхМедосмотровСправок()
	
	Если Метаданные.РегистрыСведений.Найти("удалитьДействияНоменклатурыМедосмотров") <> Неопределено Тогда
		Для Каждого МетаданныеМакета Из Метаданные.РегистрыСведений.удалитьДействияНоменклатурыМедосмотров.Макеты Цикл
			ТаблицаМедосмотров.Добавить(МетаданныеМакета.Имя, МетаданныеМакета.Синоним);
		КонецЦикла;
	КонецЕсли;
	ТаблицаМедосмотров.СортироватьПоПредставлению();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьМедосмотры(Команда)
	
	ЗагрузитьМедосмотрыСервер();
	ПоказатьПредупреждение(,"Выбранные позиции успешно загружены!");
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьМедосмотрыСервер()
	
	Для Каждого СтрокаМедосмотры Из ТаблицаМедосмотров Цикл
		Если СтрокаМедосмотры.Пометка Тогда
			ДанныеМакета = РегистрыСведений.удалитьДействияНоменклатурыМедосмотров.ПолучитьМакет(СтрокаМедосмотры.Значение);
			ОбщегоНазначенияСервер.ВыполнитьЗагрузкуУниверсальнымОбменомXML(ДанныеМакета, Истина);
		КонецЕсли;
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИспользоватьМедосмотрыСправок = УправлениеНастройками.ПолучитьПараметрУчетнойПолитики("ИспользоватьМедосмотрыСправки");
	Если Не ИспользоватьМедосмотрыСправок Тогда
		УправлениеНастройками.УстановитьЗначениеПараметраУчетнойПолитики("ИспользоватьМедосмотрыСправки", Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ВидыСегментации

&НаСервере
Процедура ЗагрузитьСписокВстроенныхВидовСегментации()
	
	Если Метаданные.РегистрыСведений.Найти("СегментыКлиентов") <> Неопределено Тогда
		Для Каждого МетаданныеМакета Из Метаданные.РегистрыСведений.СегментыКлиентов.Макеты Цикл
			ВидыСегментации.Добавить(МетаданныеМакета.Имя, МетаданныеМакета.Синоним);
		КонецЦикла;
	КонецЕсли;
	ВидыСегментации.СортироватьПоПредставлению();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьВидыСегментации(Команда)
	
	ЗагрузитьВидыСегментацииСервер();
	ПоказатьПредупреждение(,"Выбранные позиции успешно загружены!");

КонецПроцедуры

&НаСервере
Процедура ЗагрузитьВидыСегментацииСервер()
	
	Для Каждого СтрокаВидыСегментации Из ВидыСегментации Цикл
		Если СтрокаВидыСегментации.Пометка Тогда
			ДанныеМакета = РегистрыСведений.СегментыКлиентов.ПолучитьМакет(СтрокаВидыСегментации.Значение);
			Справочники.ВидыСегментации.Импортировать(ДанныеМакета);
		КонецЕсли;
	КонецЦикла;
		
КонецПроцедуры

#КонецОбласти

#Область ЯчейкиЖурналаЗаписи

&НаСервере
Процедура ЗагрузитьСписокВстроенныхЯчеекЖурналаЗаписи()
	
	Для Каждого МетаданныеМакета Из Метаданные.Справочники.ЯчейкиКалендаря.Макеты Цикл
		Если Тип(МетаданныеМакета.ТипМакета) = Тип("ДвоичныеДанные") Тогда
			ЯчейкиЖурналаЗаписи.Добавить(МетаданныеМакета.Имя, МетаданныеМакета.Синоним);
		КонецЕсли;
	КонецЦикла;
	
	ЯчейкиЖурналаЗаписи.СортироватьПоПредставлению();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьЯчейкиЖурналаЗаписи(Команда)
	
	ЗагрузитьЯчейкиЖурналаЗаписиНаСервере();
	ПоказатьПредупреждение(,"Выбранные позиции успешно загружены!");
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьЯчейкиЖурналаЗаписиНаСервере()
	
	Для Каждого СтрокаЯчейкиЖурналаЗаписи Из ЯчейкиЖурналаЗаписи Цикл
		Если СтрокаЯчейкиЖурналаЗаписи.Пометка Тогда
			ДанныеМакета = Справочники.ЯчейкиКалендаря.ПолучитьМакет(СтрокаЯчейкиЖурналаЗаписи.Значение);
			Справочники.ЯчейкиКалендаря.Импортировать(ДанныеМакета);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СтандартыЛечения

&НаСервере
Процедура ЗагрузитьСписокВстроенныхСтандартовЛечения()
	
	ЕстьСтандартыЛеченияДляЗагрузки = Ложь;
	Для Каждого МетаданныеМакета Из Метаданные.Справочники.СтандартыЛечения.Макеты Цикл
		Если Тип(МетаданныеМакета.ТипМакета) = Тип("ДвоичныеДанные")
			И МетаданныеМакета.Имя <> "РегламентированныеСтандарты"
		Тогда
			СтандартыЛечения.Добавить(МетаданныеМакета.Имя, МетаданныеМакета.Синоним);
			ЕстьСтандартыЛеченияДляЗагрузки = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьСтандартыЛечения(Команда)
	
	ЗагрузитьСтандартыЛеченияНаСервере();
	ПоказатьПредупреждение(,"Выбранные позиции успешно загружены!");
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСтандартыЛеченияНаСервере()
	
	Для Каждого СтрокаСписка Из СтандартыЛечения Цикл
		Если СтрокаСписка.Пометка Тогда
			ДанныеМакета = Справочники.СтандартыЛечения.ПолучитьМакет(СтрокаСписка.Значение);
			ОбщегоНазначенияСервер.ВыполнитьЗагрузкуУниверсальнымОбменомXML(ДанныеМакета, Истина,, Справочники.СтандартыЛечения.ПустаяСсылка().Метаданные().Имя);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
