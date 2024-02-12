
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура КонтактныеЛицаВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	ЗакрыватьПриВыборе = Ложь;
	ОповеститьОВыборе(Значение);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	стрИмяСправочникаКонтактов = бит_ТелефонияСерверПереопределяемый.ПолучитьИмяСправочникаКонтактныхЛиц();
	стрИмяТаблицы = "Справочник." + стрИмяСправочникаКонтактов;
	//
	КонтактныеЛица.ПроизвольныйЗапрос = Истина;
	КонтактныеЛица.ДинамическоеСчитываниеДанных = Истина;
	КонтактныеЛица.ОсновнаяТаблица = стрИмяТаблицы;
	КонтактныеЛица.ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                              |	КонтактныеЛицаКонтрагентов.Наименование,
	                              |	КонтактныеЛицаКонтрагентов.Владелец
	                              |ИЗ
	                              |	" + стрИмяТаблицы + " КАК КонтактныеЛицаКонтрагентов";
	//
	НоваяКолонкаТаблицы = Элементы.Добавить("Наименование", Тип("ПолеФормы"), Элементы.КонтактныеЛица);    
	НоваяКолонкаТаблицы.ПутьКДанным = "КонтактныеЛица.Наименование";	// тут название реквизита формы - динамического списка, а не таблицы БД
	//
	КолонкаВладелец = Элементы.Добавить("Владелец", Тип("ПолеФормы"), Элементы.КонтактныеЛица);    
	КолонкаВладелец.ПутьКДанным = "КонтактныеЛица.Владелец";	// тут название реквизита формы - динамического списка, а не таблицы БД
КонецПроцедуры

#КонецОбласти
