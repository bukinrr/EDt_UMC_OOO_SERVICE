#Область ОбработчикиКомандФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ФормаПерезаполнитьКлассификатор.Доступность = ДопСерверныеФункцииПовтИсп.ЕстьПравоДоступа("Изменение", "Справочник.ТипыНарушенийРежима");
	
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьКлассификатор(Команда)
	ПерезаполнитьКлассификаторНаСервере();
	Элементы.Список.Обновить();
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПерезаполнитьКлассификаторНаСервере()
	
	Справочники.ТипыНарушенийРежима.ПерезаполнитьКлассификатор();
	
КонецПроцедуры

#КонецОбласти
