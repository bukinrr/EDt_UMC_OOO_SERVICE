#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ДанныеКР = ПолучитьДанныеКомплексногоРасчетаДляРекламации(ПараметрКоманды);
	
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ДанныеКР);
	ОткрытьФорму("Документ.Рекламация.ФормаОбъекта", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеКомплексногоРасчетаДляРекламации(КРСсылка)
	
	Результат = Новый Структура("ПредметРекламации, Клиент, Работы");
	
	Результат.ПредметРекламации = КРСсылка;
	Результат.Клиент = КРСсылка.Клиент;
		
	Работы = Новый Массив;
	Для Каждого СтрокаТЧ Из КРСсылка.Состав Цикл
		Если Не РаботаСФормамиСервер.ЭтоУслуга(СтрокаТЧ.Номенклатура) Тогда 
			Продолжить;
		КонецЕсли;
		ДанныеРаботы = Новый Структура;
		ДанныеРаботы.Вставить("Номенклатура", СтрокаТЧ.Номенклатура);
		ДанныеРаботы.Вставить("ХарактеристикаНоменклатуры", СтрокаТЧ.ХарактеристикаНоменклатуры);
		ДанныеРаботы.Вставить("Количество", СтрокаТЧ.Количество);
		ДанныеРаботы.Вставить("Цена", СтрокаТЧ.Цена);
		ДанныеРаботы.Вставить("Сумма", СтрокаТЧ.Сумма);
		Работы.Добавить(ДанныеРаботы);
	КонецЦикла;
	
	Результат.Работы = Работы;
	
	Возврат Результат;
	
КонецФункции
#КонецОбласти


