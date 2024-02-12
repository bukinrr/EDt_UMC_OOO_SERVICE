#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РаботаСФормамиСервер.ФормаДокументаПриОткрытииСервер(ЭтаФорма, Ложь);
	РаботаСФормамиСервер.НастройкаПодбораПриСоздании(ЭтаФорма, Ложь, "Работы", "Услуга");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПечатьДокументовКлиент.УстановитьЗаголовокПечатнойФормы(ЭтаФорма);
	мУчетнаяПолитика = УправлениеНастройками.ПолучитьУчетнуюПолитику();
	
	// Видимость характеристик
	мВестиУчетПоХарктеристикам =  мУчетнаяПолитика.ВестиУчетПоХарактеристикам;
	Элементы.РаботыХарактеристикаНоменклатуры.Видимость = мВестиУчетПоХарктеристикам;
	
	РаботаСФормамиКлиент.ОчиститьЛишниеКомандыПобор(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	РаботаСФормамиСервер.ВывестиЗаголовокФормыДокумента(ТекущийОбъект,,ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора) 
	
	Перем Действие;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		ВыбранноеЗначение.Свойство("Действие", Действие);
		
		Если Действие = "ПодборРаботы" Тогда
			
			Если ДопСерверныеФункции.ПолучитьРеквизит(ВыбранноеЗначение.Номенклатура, "ВидНоменклатуры") = ПредопределенноеЗначение("Перечисление.ВидыНоменклатуры.Услуга") Тогда
				СтрокаРаботы = Объект.Работы.Добавить();
				СтрокаРаботы.Номенклатура = ВыбранноеЗначение.Номенклатура;
				СтрокаРаботы.ХарактеристикаНоменклатуры = ВыбранноеЗначение.ХарактеристикаНоменклатуры;
				СтрокаРаботы.Количество = ВыбранноеЗначение.Количество;
				Элементы.Работы.ТекущаяСтрока = СтрокаРаботы.ПолучитьИдентификатор();
				
				РаботыНоменклатураПриИзменении(Неопределено);
			Иначе
				СоставНабора = ОбщегоНазначенияСервер.ПолучитьСоставНабора(ВыбранноеЗначение.Номенклатура);
				Для Инд = 0 По СоставНабора.Количество()-1 Цикл
					СтрокаРаботы = Объект.Работы.Добавить();
					СтрокаРаботы.Номенклатура = СоставНабора[Инд].Комплектующая;
					СтрокаРаботы.ХарактеристикаНоменклатуры = СоставНабора[Инд].ХарактеристикаКомплектующей;
					СтрокаРаботы.Количество = СоставНабора[Инд].Количество * ВыбранноеЗначение.Количество;
					Элементы.Работы.ТекущаяСтрока = СтрокаРаботы.ПолучитьИдентификатор();
					РаботыНоменклатураПриИзменении(Неопределено);
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодборНажатие(Команда)
	
	РаботаСФормамиКлиент.КнопкаПодборПриНажатии(ЭтаФорма, "Работы");
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КнопкаФилиалПриНажатии(Команда)
	РаботаСДиалогамиКлиент.ДиалогКнопкаФилиалПриНажатии(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВывестиДвиженияДокумента(Команда)
	РаботаСДиалогамиКлиент.ВывестиДвиженияДокумента(Объект.Ссылка, Команда);
КонецПроцедуры

&НаКлиенте
Процедура Перезаполнить(Команда)
	
	ТекстВопроса = НСтр("ru = 'Список работ будет перезаполнен.'") + " " + НСтр("ru = 'Продолжить?'");
	Если Объект.Работы.Количество() > 0 
		И Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет 
	Тогда
		Возврат;
	КонецЕсли;
	
	ПерезаполнитьНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура Подключаемый_ВыборПодбор(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Ложь Тогда ЗапрашиватьКоличество = Ложь; ЗапрашиватьЦену = Ложь; ЗапрашиватьХарактеристику = Ложь; ЗапрашиватьСерию = Ложь; КонецЕсли; 
	СтандартнаяОбработка = Ложь;
	
	Если Не ДопСерверныеФункции.ПолучитьРеквизит(ВыбранноеЗначение, "ЭтоГруппа") Тогда 
		
		Действие = "ПодборРаботы";
		
		Результат = РаботаСФормамиКлиент.ВыборПодборОбработка(ВыбранноеЗначение, ЗапрашиватьКоличество, ЗапрашиватьЦену, ЗапрашиватьХарактеристику, ЗапрашиватьСерию, Действие, ЭтаФорма);

		Если Результат <> Неопределено Тогда
			ОбработкаВыбора(Результат, Неопределено);
			Модифицированность = Истина;
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура РаботыНоменклатураПриИзменении(Элемент)
	
	ДанныеЗаполнения = ПолучитьДанныеЗаполненияСтрокиСоставаПриИзмененииНоменклатуры(Объект, Элементы.Работы.ТекущаяСтрока);	
	ЗаполнитьЗначенияСвойств(Элементы.Работы.ТекущиеДанные, ДанныеЗаполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура РаботыКоличествоПриИзменении(Элемент)
	
	РаботыКоличествоЦенаПриИзменении(Элементы.Работы.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура РаботыЦенаПриИзменении(Элемент)
	
	РаботыКоличествоЦенаПриИзменении(Элементы.Работы.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметРекламацииПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.ПредметРекламации) Тогда
		Если ТипЗнч(Объект.ПредметРекламации) = Тип("ДокументСсылка.ОказаниеУслуг") Тогда
			Объект.Исполнитель = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Объект.ПредметРекламации, "Сотрудник");
		КонецЕсли;
		Перезаполнить(Неопределено);
	КонецЕсли;		
	
КонецПроцедуры

&НаКлиенте
Процедура КлиентАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)

	РаботаСФормамиКлиент.ПолеВводаКлиентаАвтоПодбор(Текст, СтандартнаяОбработка, ДанныеВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура КлиентОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)

	РаботаСФормамиКлиент.ПолеВводаКлиентаАвтоПодбор(Текст, СтандартнаяОбработка, ДанныеВыбора);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура РаботыКоличествоЦенаПриИзменении(ТекущиеДанные)
	
	ТекущиеДанные.Сумма = ТекущиеДанные.Количество * ТекущиеДанные.Цена;
	ТекущиеДанные.СуммаБезСкидок = ТекущиеДанные.Сумма;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеЗаполненияСтрокиСоставаПриИзмененииНоменклатуры(Знач Объект, ТекущаяСтрока)
	
	СтрокаТабличнойЧасти = Объект.Работы.НайтиПоИдентификатору(ТекущаяСтрока);
	
	Результат = Новый Структура("Цена, Сумма");
	
	дкУстановитьЦенуСтрокиТабЧасти(ДанныеФормыВЗначение(Объект, Тип("ДокументОбъект.Рекламация")), "Работы", СтрокаТабличнойЧасти);
	
	ЗаполнитьЗначенияСвойств(Результат, СтрокаТабличнойЧасти);
	
	Результат.Вставить("СуммаБезСкидок", Результат.Сумма);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ПерезаполнитьНаСервере()
	
	ОбъектКопия = Объект;
	Документы.Рекламация.ПерезаполнитьРаботыПоПредметуРекламации(ОбъектКопия);
	
КонецПроцедуры

#КонецОбласти
