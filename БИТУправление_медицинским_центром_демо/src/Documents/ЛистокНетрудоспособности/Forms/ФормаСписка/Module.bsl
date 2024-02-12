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

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	ТекСтр = Элементы.Список.ТекущиеДанные;
	Если ТекСтр <> Неопределено И ТекСтр.Свойство("Ссылка") Тогда
		ПодчиненныйСписок.Параметры.УстановитьЗначениеПараметра("ЛН", ТекСтр.Ссылка);
	иначе 
		ПодчиненныйСписок.Параметры.УстановитьЗначениеПараметра("ЛН", ДокументПустаяСсылка);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗапроситьЭЛНИзФСС(Команда)
	ПараметрыФормы = Новый Структура("Действие, Документ","ОбновитьЭЛН",Неопределено);
	ОткрытьФорму("Документ.ЛистокНетрудоспособности.Форма.ОбменСФСС",ПараметрыФормы,Элементы.Список,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры 

&НаКлиенте
Процедура ОткрытьФормуПросмотраОбмена(Команда)
	ОткрытьФорму("Документ.ЛистокНетрудоспособности.Форма.КонтрольОбменаСФСС",,,,,,,РежимОткрытияОкнаФормы.Независимый);
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСписокПоследнихЭЛН(Команда)
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ПослеЗакрытияФормыВыбораВнешнегоЛН", ЭтаФорма);
	ОткрытьФорму("Документ.ЛистокНетрудоспособности.Форма.ВыборВнешнихЗакрытыхЛН",,ЭтаФорма,,,,ОповещениеОЗакрытии,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияФормыВыбораВнешнегоЛН(Результат, Параметры) Экспорт
	Если ЗначениеЗаполнено(Результат) Тогда
		ПараметрыФормы = Новый Структура("Действие, Номер, СНИЛС","ОбновитьЭЛН",Результат.Номер, Результат.СНИЛС);
		ОткрытьФорму("Документ.ЛистокНетрудоспособности.Форма.ОбменСФСС",ПараметрыФормы,Элементы.Список,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);		
	КонецЕсли; 
КонецПроцедуры 

&НаКлиенте
Процедура ОткрытьПулНомеров(Команда)
	ОткрытьФорму("РегистрСведений.ПулыНомеровЭЛН.Форма.ФормаСписка");
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСвязьСФСС(Команда)
	
	ОткрытьФорму("Документ.ЛистокНетрудоспособности.Форма.ПроверкаСоединенияСФСС",,ЭтотОбъект,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти