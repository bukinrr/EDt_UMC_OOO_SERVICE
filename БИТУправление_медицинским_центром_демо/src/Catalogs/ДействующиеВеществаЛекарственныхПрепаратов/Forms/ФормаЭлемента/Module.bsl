
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Расшифровки = Справочники.ДействующиеВеществаЛекарственныхПрепаратов.ПолучитьСоответствиеРасшифровокКодаГруппы();
	Для Каждого Строка Из Расшифровки Цикл
		РасшифровкиКодаГруппы.Добавить(Строка.Ключ, Строка.Значение);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьРасшифровкуКодаГруппы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ГруппаПриИзменении(Элемент)
	
	ОбновитьРасшифровкуКодаГруппы();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьРасшифровкуКодаГруппы()
	РасшифровкаКодаГруппыПоПаспорту = РасшифровкиКодаГруппы.НайтиПоЗначению(Объект.Группа);	
КонецПроцедуры 

#КонецОбласти