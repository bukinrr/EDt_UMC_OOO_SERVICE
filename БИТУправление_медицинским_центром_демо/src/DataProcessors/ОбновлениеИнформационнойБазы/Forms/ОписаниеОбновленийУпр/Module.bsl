#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ДокументОписаниеОбновлений = Элементы.ДокументОписаниеОбновлений;
	МакетОписаниеОбновлений    = Обработки.ОбновлениеИнформационнойБазы.ПолучитьМакет("ОписаниеОбновлений");

	ДокументОписаниеОбновлений.Очистить();
	ДокументОписаниеОбновлений.Вывести(МакетОписаниеОбновлений);
	
КонецПроцедуры

#КонецОбласти
