
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Инструментальное исследование, для которого выбирается анатомическая область
	Если Параметры.Свойство("СвязанныеПараметрыШаблона") Тогда
		Для Каждого КлючИЗначение Из Параметры.СвязанныеПараметрыШаблона Цикл
			Если КлючИЗначение.Ключ.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ИнструментальныеИсследования") Тогда
				Исследование = КлючИЗначение.Значение;	
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Исследование) Тогда
		ЗаполнитьСписокВыбораЛокализации();	
	КонецЕсли;
	
	// Если классификатор исследований допускает только одну область, она и подставляется без выбора из списка вариантов.
	// Поле ввода при этом доступно для ручного указания деталей (например, "левое" или "правое").
	Если СписокЛокализаций.Количество() = 1 Тогда
		Результат = СписокЛокализаций[0].Значение;
		Элементы.ГруппаЛокализации.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда)
		
	ЭтотОбъект.Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	Результат = Элементы.СписокЛокализаций.ТекущиеДанные.Значение;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокЛокализацийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Результат = Элементы.СписокЛокализаций.ТекущиеДанные.Значение;	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

&НаСервере
Процедура ЗаполнитьСписокВыбораЛокализации()
	
	МассивЛокализаций = Справочники.ИнструментальныеИсследования.ПолучитьЛокализацииИсследования(Исследование);
	Для Каждого Локализация Из МассивЛокализаций Цикл
		СтрокаЛокализации = СписокЛокализаций.Добавить();
		СтрокаЛокализации.Значение = СокрЛП(Локализация);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
