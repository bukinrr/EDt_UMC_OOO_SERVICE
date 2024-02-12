
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если НЕ ЗначениеЗаполнено(Объект.Пользователь) Тогда
		Объект.Пользователь = бит_ТелефонияСервер.ПолучитьТекущегоПользователя();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Стр = бит_ТелефонияКлиентСервер.ОчиститьНомерТолькоЦифры(Объект.Номер);
	Объект.Номер = Стр;
	Если Модифицированность ИЛИ Объект.Ссылка = ПредопределенноеЗначение("Справочник.бит_БитфонИзбранное.ПустаяСсылка") Тогда
		ОбъектИзменен = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Если ОбъектИзменен И ЗначениеЗаполнено(ИмяСобытияОповещенияПриИзменении) Тогда
		парамОповещ = Новый Структура;
		парамОповещ.Вставить("Наименование", Объект.Наименование);
		парамОповещ.Вставить("Номер", Объект.Номер);
		Оповестить(ИмяСобытияОповещенияПриИзменении, парамОповещ);
		ОбъектИзменен = Ложь;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
