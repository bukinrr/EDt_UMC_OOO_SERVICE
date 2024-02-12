#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ФормаЗагрузитьСправочник.Видимость = ПравоДоступа("Изменение", Метаданные.Справочники.РеестрМедицинскихОрганизаций);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьСправочник(Команда)
	
	СтруктураПараметры = Новый Структура("НаименованиеСправочника, ДоступенВыборТестовогоКонтура, ВыбратьЕдинственный", "РеестрМедицинскихОрганизаций", Истина, Ложь);
	Оповещение = Новый ОписаниеОповещения("ЗагрузкаКлассификатораЗавершена",ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ЗагрузкаНСИЕГИСЗПоОтбору", СтруктураПараметры, Элементы.Список, ЭтаФорма,,,Оповещение);
	
КонецПроцедуры 

&НаКлиенте
Процедура ЗагрузитьОрганизацию(Команда)
	
	СтруктураПараметры = Новый Структура("НаименованиеСправочника, ДоступенВыборТестовогоКонтура, ВыбратьЕдинственный", "РеестрМедицинскихОрганизаций", Истина, Истина);
	Оповещение = Новый ОписаниеОповещения("ЗагрузкаКлассификатораЗавершена",ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ЗагрузкаНСИЕГИСЗПоОтбору", СтруктураПараметры, Элементы.Список, ЭтаФорма,,,Оповещение);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

&НаКлиенте
Процедура ЗагрузкаКлассификатораЗавершена(Результат, ДополнительныеПараметры) Экспорт
	Элементы.Список.Обновить();
КонецПроцедуры

#КонецОбласти