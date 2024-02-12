
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Параметры.ОписанияРеквизитовДляВвода) Тогда
		Закрыть(Неопределено);
	КонецЕсли;
	
	АвтоЗаголовок = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "АвтоЗаголовок", Истина);
	Если Не АвтоЗаголовок Тогда
		Заголовок = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "Заголовок", "");
	КонецЕсли;
	
	СоздатьРеквизиты(Параметры.ОписанияРеквизитовДляВвода);
	
	ЗаполнитьРеквизитыЗначениямиПоУмолчанию(Параметры.ОписанияРеквизитовДляВвода);
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомендаОК(Команда)
	
	РезультатВвода = Новый Структура;
	Для Каждого ИмяРеквизита Из ИменаРеквизитовДляВвода Цикл
		РезультатВвода.Вставить(ИмяРеквизита, ЭтотОбъект[ИмяРеквизита]);
	КонецЦикла;
	
	Закрыть(Новый ФиксированнаяСтруктура(РезультатВвода));
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СоздатьРеквизиты(ОписанияРеквизитовДляВвода)
	
	ИменаРеквизитов = Новый Массив;
	
	ДобавляемыеРеквизиты = Новый Массив;
	ДобавляемыеЭлементы = Новый Массив;
	Для Каждого КлючИЗначение Из ОписанияРеквизитовДляВвода Цикл
		
		ОписаниеРеквизита = КлючИЗначение.Значение;
		
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы(КлючИЗначение.Ключ, ОписаниеРеквизита.ОписаниеТипа,, ОписаниеРеквизита.Наименование));
		
		ЭлементФормы = Элементы.Добавить(КлючИЗначение.Ключ, Тип("ПолеФормы"));
		ЭлементФормы.Вид = ВидПоляФормы.ПолеВвода;
		ЭлементФормы.КнопкаОчистки = Истина;
		
		СписокВыбора = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ОписаниеРеквизита, "СписокВыбора");
		Если ЗначениеЗаполнено(СписокВыбора) Тогда
			ЭлементФормы.РежимВыбораИзСписка = Истина;
			Для Каждого ЭлементСписка Из СписокВыбора Цикл
				ЭлементФормы.СписокВыбора.Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление, ЭлементСписка.Пометка, ЭлементСписка.Картинка);
			КонецЦикла;
		КонецЕсли;
		
		ДобавляемыеЭлементы.Добавить(ЭлементФормы);
		
		ИменаРеквизитов.Добавить(КлючИЗначение.Ключ);
		
	КонецЦикла;
	
	Если ДобавляемыеРеквизиты.Количество() > 0 Тогда
		ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	КонецЕсли;
	
	Если ДобавляемыеЭлементы.Количество() > 0 Тогда
		Для Каждого ЭлементФормы Из ДобавляемыеЭлементы Цикл
			ЭлементФормы.ПутьКДанным = ЭлементФормы.Имя;
		КонецЦикла;
	КонецЕсли;
	
	ИменаРеквизитовДляВвода = Новый ФиксированныйМассив(ИменаРеквизитов);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыЗначениямиПоУмолчанию(ОписанияРеквизитовДляВвода)
	
	Для Каждого КлючИЗначение Из ОписанияРеквизитовДляВвода Цикл
		
		ОписаниеРеквизита = КлючИЗначение.Значение;
		
		ЭтотОбъект[КлючИЗначение.Ключ] = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ОписаниеРеквизита, "ЗначениеПоУмолчанию");
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции
