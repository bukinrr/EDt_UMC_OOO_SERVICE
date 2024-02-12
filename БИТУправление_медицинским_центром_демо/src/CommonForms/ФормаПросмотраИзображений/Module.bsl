#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Параметры.СвойстваФайла) И ЗначениеЗаполнено(Параметры.Ключ)  Тогда
		ЭтаФорма.СвойстваФайла = ЭтаФорма.Параметры.СвойстваФайла;
		ЭтаФорма.Заголовок = "Просмотр изображения: "+ЭтаФорма.СвойстваФайла.ИмяФайла;
		ЭтаФорма.НавСсылка = ЭтаФорма.Параметры.Ключ;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОригинальныйРазмер(Команда)
	ПрисвоениеРазмераКартинке("Реальный");
КонецПроцедуры

&НаКлиенте
Процедура Подогнать(Команда)
	ПрисвоениеРазмераКартинке("Авто");
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзображение(Команда)
	ПолучитьФайл(НавСсылка,ЭтаФорма.СвойстваФайла.ИмяФайла+"."+НРЕГ(ЭтаФорма.СвойстваФайла.Расширение), Истина);
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

 &НаСервере
Процедура ПрисвоениеРазмераКартинке(Размер)
	Если Размер="Авто" Тогда
		ЭтаФорма.Элементы.НавСсылка.РазмерКартинки=РазмерКартинки.АвтоРазмер;
	ИначеЕсли Размер="Реальный" Тогда
		ЭтаФорма.Элементы.НавСсылка.РазмерКартинки=РазмерКартинки.РеальныйРазмер;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти



