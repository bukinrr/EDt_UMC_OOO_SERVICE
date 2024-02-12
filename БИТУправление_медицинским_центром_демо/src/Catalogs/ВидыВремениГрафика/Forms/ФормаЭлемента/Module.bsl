#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	об = РеквизитФормыВЗначение("Объект");
	ВыбранныйЦвет = об.Цвет.Получить();
	
	Элементы.ВыбранныйЦвет.Доступность = Объект.Ссылка <> Справочники.ВидыВремениГрафика.РабочееВремя;
	Элементы.РабочееВремяТабеля.Доступность = Не Объект.РабочееВремя;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.Цвет = Новый ХранилищеЗначения(ВыбранныйЦвет);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура РабочееВремяПриИзменении(Элемент)
	
	Если Объект.РабочееВремя Тогда
		Объект.РабочееВремяТабеля = Истина;
	КонецЕсли;
	
	Элементы.РабочееВремяТабеля.Доступность = Не Объект.РабочееВремя;
	
КонецПроцедуры

#КонецОбласти