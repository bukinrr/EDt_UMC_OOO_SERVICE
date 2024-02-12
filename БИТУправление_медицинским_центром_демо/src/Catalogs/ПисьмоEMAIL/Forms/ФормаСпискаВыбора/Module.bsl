#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметр = Параметры.Параметр;
	
	Элементы.СписокВыбораЗначение.ОграничениеТипа = Параметр.ТипЗначения;
	
	Элементы.СписокВыбора.ПодчиненныеЭлементы.СписокВыбораЗначение.ВыбиратьТип = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
&НаКлиенте
Процедура СписокВыбораЗначениеПриИзменении(Элемент)
	
	Элементы.СписокВыбора.ТекущиеДанные.Представление = Строка(Элементы.СписокВыбора.ТекущиеДанные.Значение);
	
КонецПроцедуры                                                                                              

&НаКлиенте
Процедура СписокВыбораПоУмолчаниюПриИзменении(Элемент)
	
	Для Каждого Строка Из СписокВыбора Цикл        
		
		Если Строка.Значение <> Элементы.СписокВыбора.ТекущиеДанные.Значение Тогда
			
			Строка.ПоУмолчанию = Ложь;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура КомандаСохранить(Команда)
	
	Если СписокВыбора.Количество() > 0 Тогда
		
		Массив = Новый Массив;
		
		Для Каждого Строка Из СписокВыбора Цикл
			
			Структура = Новый Структура("Значение, Представление, ПоУмолчанию", Строка.Значение, Строка.Представление, Строка.ПоУмолчанию);
			
			Массив.Добавить(Структура);
			
		КонецЦикла;
		
		ЭтаФорма.Закрыть(Массив);
		
	Иначе
		
		ЭтаФорма.Закрыть(Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти