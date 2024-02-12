#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СортироватьСписок();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СортироватьСписок()
	
	Сортировка = Список.Порядок.Элементы;
	
	Если Сортировка.Количество() = 1 Тогда 
		Сортировка[0].Использование = Ложь;
	КонецЕсли;
	
	УсловиеСортировки = Сортировка.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	УсловиеСортировки.Поле = Новый ПолеКомпоновкиДанных("Тип");
	УсловиеСортировки.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
	
КонецПроцедуры

#КонецОбласти