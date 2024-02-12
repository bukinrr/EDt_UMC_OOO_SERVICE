#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		ВыбранныйЦвет = УправлениеНастройками.ПолучитьПараметрУчетнойПолитики("ОсновнойЦветЗаявки");
	Иначе
		СправочникОбъект = ДанныеФормыВЗначение(Объект, Тип("СправочникОбъект.ВидыСостоянийЗаявок"));
		ВыбранныйЦвет = СправочникОбъект.Цвет.Получить();
	КонецЕсли;
	
	Элементы.Наименование.ТолькоПросмотр = Объект.Предопределенный;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.Цвет = Новый ХранилищеЗначения(ВыбранныйЦвет);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ВидСостояниеЗаявкиЗапись");
КонецПроцедуры

#КонецОбласти
