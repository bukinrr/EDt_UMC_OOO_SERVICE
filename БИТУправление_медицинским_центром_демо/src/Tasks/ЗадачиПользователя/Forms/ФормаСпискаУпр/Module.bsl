
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеЗадачи" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УдалениеСтарыхЗадач(Команда)	
	ОткрытьФорму("Задача.ЗадачиПользователя.Форма.ФормаПараметрыУдаленияСтарыхЗадач",,ЭтаФорма);	
КонецПроцедуры

&НаКлиенте
Процедура Отчет(Команда)
	ОткрытьФорму("Отчет.ЗадачиИНапоминания.Форма");
КонецПроцедуры

#КонецОбласти
