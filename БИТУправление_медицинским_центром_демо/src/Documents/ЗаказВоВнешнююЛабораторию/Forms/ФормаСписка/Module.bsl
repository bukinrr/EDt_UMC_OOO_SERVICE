#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	РаботаСФормамиСервер.ДокументСписокПриСозданииНаСервере(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПечатьДокументовКлиент.УстановитьЗаголовокПечатнойФормы(ЭтаФорма);
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура СоздатьОписьДляНеотправленных(Команда)
	
	Оповещение = Новый ОписаниеОповещения("СоздатьОписьДляНеотправленныхПродолжение", ЭтотОбъект);
	ОткрытьФорму("Справочник.Лаборатории.ФормаВыбора",, ЭтотОбъект,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьРезультатыАнализов(Команда)
	
	ТекстОшибки = ЛабораторияСервер.ПолучитьРезультатыАнализовИзВнешнихЛабораторий();
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
	КонецЕсли;
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗаказыДляЗабранныхАнализов(Команда)
	ЛабораторияСервер.СоздатьЗаказыВоВнешниеЛабораторииДляЗабранныхАнализов();
	Элементы.Список.Обновить();
КонецПроцедуры
#КонецОбласти 

#Область СлужебныеПроцедурыИФункции
&НаКлиенте
Процедура СоздатьОписьДляНеотправленныхПродолжение(Результат, Параметры) Экспорт

	Если Результат = Неопределено Тогда 
		Возврат;	
	КонецЕсли;

	СозданныеОписи = ЛабораторияСервер.СоздатьОписьДляНеотправленных(, Результат);
	Если СозданныеОписи.Количество() = 1 Тогда
		ОткрытьЗначение(СозданныеОписи[0]);
	ИначеЕсли СозданныеОписи.Количество() >= 2 Тогда
		ОткрытьФорму("Документ.ОписьЗаказовЛаборатории.ФормаСписка");
	КонецЕсли;
	
	Элементы.Список.Обновить();
	
КонецПроцедуры
#КонецОбласти


