#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Метаданные.ОбщиеМодули.Найти("DICOMРаботаСДрайвером") = Неопределено
		Или Не DICOMРаботаСДрайвером.ПолучитьЗначениеКонстантыИспользоватьDICOM()
	Тогда
		РаботаСФормамиКлиентСервер.УстановитьВидимостьЭлементаФормы(Элементы, "AETitle", Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если Объект.ОсновнойСпособЗаполненияГрафика.Пустая() Тогда
		НаследоватьСпособЗаполненияГрафикаОтПодразделения = Истина;
		Элементы.ОсновнойСпособЗаполненияГрафика.Доступность = Ложь;
	Иначе
		НаследоватьСпособЗаполненияГрафикаОтПодразделения = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если НаследоватьСпособЗаполненияГрафикаОтПодразделения Тогда
		ТекущийОбъект.ОсновнойСпособЗаполненияГрафика = Справочники.СпособыЗаполненияГрафиковРабот.ПустаяСсылка();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура НаследоватьОтГруппыПриИзменении(Элемент)
	Элементы.ОсновнойСпособЗаполненияГрафика.Доступность = Не НаследоватьСпособЗаполненияГрафикаОтПодразделения;
КонецПроцедуры

#КонецОбласти
