
#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Установка текущей закладки
	ТабличныеЧасти = Объект.Ссылка.Метаданные().ТабличныеЧасти;
	Для Каждого ТабличнаяЧасть Из ТабличныеЧасти Цикл
		Если Объект[ТабличнаяЧасть.Имя].Количество() <> 0 Тогда
			Элементы.Страницы.ТекущаяСтраница = Элементы.Найти("Группа"+ТабличнаяЧасть.Имя);
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти