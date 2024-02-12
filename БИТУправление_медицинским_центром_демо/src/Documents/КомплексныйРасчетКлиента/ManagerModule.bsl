#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	Поля.Добавить("Вид");
	Поля.Добавить("Номер");
	Поля.Добавить("Дата");
	СтандартнаяОбработка = Ложь;	
	
КонецПроцедуры

// Процедура формирует представление документа вида <ТИП> № <Номер> от <Дата>
Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	Представление = СформироватьПредставление(Данные, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Формирует представление объекта
//
// Параметры:
//  Данные				 - Структура - Содержит значения полей, из которых формируется представление.
//  СтандартнаяОбработка - Булево	 - является ли стандартной обработкой .
// 
// Возвращаемое значение:
//  Структура - структура каждая строка которой соответствует одному из вариантов печати.
//
Функция СформироватьПредставление(Данные, СтандартнаяОбработка = Истина) Экспорт
	
	ТипРасчета = ПараметрыСеанса.ТипыВидовКомплексныхРасчетов.Получить(Данные.Вид);
	Если Не ЗначениеЗаполнено(ТипРасчета) Тогда
		Возврат "";
	КонецЕсли;
	
	Представление = Строка(ТипРасчета) + " № " + Данные.Номер+ " от " + Данные.Дата;
	СтандартнаяОбработка = Ложь;
	
	Возврат Представление;
	
КонецФункции

// Возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//  Струткура - структура каждая строка которой соответствует одному из вариантов печати.
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	СтруктураМакетов = Новый Структура;
	СтруктураМакетов.Вставить("ПечатьЗаказНаряда", "Печать заказ-наряда");
		
	Возврат СтруктураМакетов;

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

// Процедура формирует печатную форму документа
//  
//  Название макета печати передается в качестве параметра,
//  по переданному названию находим имя макета в соответствии.
//
// Параметры:
//  СсылкаНаОбъект	 - ДокументСсылка.КомплексныйРасчетКлиента - документ.
//  ИмяМакета		 - Строка	 - название макета.
// 
// Возвращаемое значение:
//  ТабличныйДокумент - табличный документ на печать.
//
Функция Печать(СсылкаНаОбъект, ИмяМакета) Экспорт
	
	Перем ТабДокумент;
	
	// Получить экземпляр документа на печать
	Если ИмяМакета = "ПечатьЗаказНаряда" Тогда
		ТабДокумент = ПечатьЗаказНаряда(СсылкаНаОбъект);
	КонецЕсли;
	
	Возврат ТабДокумент;
	
КонецФункции

// Заполняет состав расчет по виду.
//
// Параметры:
//  Объект			 - ДокументОбъект.КомплексныйРасчетКлиента - документ.
//  УдалитьСтарые	 - Булево - Удалить ли старые.
//
Процедура ЗаполнитьСоставПоВиду(Объект, УдалитьСтарые = Истина) Экспорт
	
	Если УдалитьСтарые Тогда
		Объект.Состав.Очистить();
	КонецЕсли;
	
	Для Каждого СтрокаСостава Из Объект.Вид.Состав Цикл
		СтрокаДокумента = Объект.Состав.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаДокумента, СтрокаСостава);
		Если ЗначениеЗаполнено(СтрокаДокумента.ЕдиницаИзмерения) Тогда
			СтрокаДокумента.Коэффициент = СтрокаДокумента.ЕдиницаИзмерения.Коэффициент;
		КонецЕсли;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(Объект.Прейскурант) Тогда
		ЗаполнитьЦеныСкидкиПоВиду(Объект);
	КонецЕсли;
	
	ЗаполнитьЭтапыРаботПоВиду(Объект);
	ЗаполнитьЭтапыРаботСОтметкамиВыполнения(Объект); 
	
КонецПроцедуры

// Заполняет цены и скидки по виду расчета.
//
// Параметры:
//  Объект	 - ДокументОбъект.КомплексныйРасчетКлиента - ссылка 
//
Процедура ЗаполнитьЦеныСкидкиПоВиду(Объект) Экспорт
	
	ТаблицаНоменклатуры = Объект.Состав.Выгрузить();
	
	Для Каждого СтрокаТаблицы Из ТаблицаНоменклатуры Цикл
		СтрокаТаблицы.Цена = 0;
	КонецЦикла;
	
	Ценообразование.ПолучитьЦеныНоменклатуры(ТаблицаНоменклатуры, Объект.Дата, Объект.Прейскурант);
	ПроцентСкидки = Объект.Вид.ПроцентСкидки;
	Для Каждого СтрокаТаблицы Из ТаблицаНоменклатуры Цикл
		СтрокаТаблицы.ПроцентСкидки = ПроцентСкидки;
		СтрокаТаблицы.ЦенаСоСкидкой = СтрокаТаблицы.Цена * (1 - СтрокаТаблицы.ПроцентСкидки/100);
		СтрокаТаблицы.Сумма = СтрокаТаблицы.Количество * СтрокаТаблицы.ЦенаСоСкидкой;
	КонецЦикла;

	Объект.Состав.Загрузить(ТаблицаНоменклатуры);
	
КонецПроцедуры

// Заполняет этапы работ по виду расчета.
//
// Параметры:
//  Объект	 - ДокументОбъект.КомплексныйРасчетКлиента - ссылка 
//
Процедура ЗаполнитьЭтапыРаботПоВиду(Объект) Экспорт 
	
	Объект.ЭтапыРабот.Очистить();
	Для Каждого СтрокаЭтап Из Объект.Вид.ЭтапыРабот Цикл
		НоваяСтрока = Объект.ЭтапыРабот.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЭтап);
		НоваяСтрока.ИдентификаторЭтапа = Строка(Новый УникальныйИдентификатор);
	КонецЦикла;
	
КонецПроцедуры

// Заполняет этапы работ с отметками выполнения
//
// Параметры:
//  Объект	 - ДокументОбъект.КомплексныйРасчетКлиента - ссылка 
//
Процедура ЗаполнитьЭтапыРаботСОтметкамиВыполнения(Объект) Экспорт
	
	ЭтапыСОтметками = УправлениеЗаказами.ПолучитьТаблицуЭтаповРаботСОтметкамиОВыполнении(Объект.Ссылка, Объект.ЭтапыРабот);
	Объект.ЭтапыРабот.Очистить();
	Для Каждого СтрокаЭтап Из ЭтапыСОтметками Цикл
		НоваяСтрока = Объект.ЭтапыРабот.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЭтап);
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(НоваяСтрока, "Выполнен") Тогда
			Если ЗначениеЗаполнено(НоваяСтрока.Выполнен) И НоваяСтрока.ДокументРегистратор = Объект.Ссылка Тогда
				НоваяСтрока.ДокументРегистратор = Неопределено;
				НоваяСтрока.ВыполненВЭтомДокументе = Истина;
			КонецЕсли;
			НоваяСтрока.ВнешнийИсполнитель = (ТипЗнч(НоваяСтрока.ИсполнительПлан) = Тип("СправочникСсылка.Контрагенты"));
												ТипИсполнителя = Новый ОписаниеТипов(?(НоваяСтрока.ВнешнийИсполнитель, 
												"СправочникСсылка.Контрагенты", "СправочникСсылка.Сотрудники"));
			НоваяСтрока.ИсполнительФакт = ТипИсполнителя.ПривестиЗначение(НоваяСтрока.ИсполнительФакт);
			Если Не ЗначениеЗаполнено(НоваяСтрока.ИсполнительПлан) Тогда 
				НоваяСтрока.ИсполнительПлан = ТипИсполнителя.ПривестиЗначение(НоваяСтрока.ИсполнительПлан);
			КонецЕсли;  
		КонецЕсли;  
	КонецЦикла;
	
КонецПроцедуры

// Проверяет образование отрицательных остатков по измененному расчету.
//
// Параметры:
//  Ссылка	 - ДокументСсылка.КомплексныйРасчетКлиента - документ.
//  Отказ	 - Булево - результат проверки.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - таблица нехватки.
//
Функция ПроверитьОбразованиеОтрицательныхОстатковПоИзмененномуРасчету(Ссылка, Отказ = Ложь) Экспорт
	
	ТаблицаНехватки = Документы.КомплексныйРасчетКлиента.ПустаяСсылка().Состав.ВыгрузитьКолонки();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КомплексныйРасчет", Ссылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НоменклатураКомплексныхРасчетовКлиентовОстатки.КлючСтроки,
	|	НоменклатураКомплексныхРасчетовКлиентовОстатки.КлючСтроки.Номенклатура КАК Номенклатура,
	|	НоменклатураКомплексныхРасчетовКлиентовОстатки.КлючСтроки.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	НоменклатураКомплексныхРасчетовКлиентовОстатки.КлючСтроки.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	НоменклатураКомплексныхРасчетовКлиентовОстатки.КлючСтроки.Цена КАК Цена,
	|	НоменклатураКомплексныхРасчетовКлиентовОстатки.КоличествоОстаток КАК Количество
	|ИЗ
	|	РегистрНакопления.НоменклатураКомплексныхРасчетовКлиентов.Остатки(, КомплексныйРасчет = &КомплексныйРасчет) КАК НоменклатураКомплексныхРасчетовКлиентовОстатки
	|ГДЕ
	|	НоменклатураКомплексныхРасчетовКлиентовОстатки.КоличествоОстаток < 0"
	;
	ТаблицаНехватки = Запрос.Выполнить().Выгрузить();
	Отказ = ТаблицаНехватки.Количество() <> 0;
	
	Возврат ТаблицаНехватки;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПечатьЗаказНаряда(СсылкаНаОбъект)
	
	Если Ложь Тогда СсылкаНаОбъект = Документы.КомплексныйРасчетКлиента.ПустаяСсылка(); КонецЕсли;
	
	ТабДок = Новый ТабличныйДокумент;
	
	Валюта = ОбщегоНазначения.ПолучитьКраткоеНаименованиеОсновнойВалюты();
	
	МакетНаряда = ПолучитьМакет("ЗаказНаряд");
	ОбластьШапка = МакетНаряда.ПолучитьОбласть("ОбластьШапка");
	
	СтруктураРеквизитов = ПроцедурыСпециализацииПоставки.ПолучитьРеквизитыОрганизации(СсылкаНаОбъект.Филиал);
	
	ОбластьШапка.Параметры.НазваниеОрганизации = СтруктураРеквизитов.НазваниеОрганизации;
	ОбластьШапка.Параметры.АдресОрганизации = СтруктураРеквизитов.Адрес;
	ОбластьШапка.Параметры.ТелефонОрганизации = СтруктураРеквизитов.Телефон;
	ОбластьШапка.Параметры.Номер = СсылкаНаОбъект.Номер;
	ОбластьШапка.Параметры.Дата = Формат(СсылкаНаОбъект.Дата, "ДЛФ=D");
	ОбластьШапка.Параметры.КлиентФИО = CRMСервер.ПолучитьФИООбъекта(СсылкаНаОбъект.Клиент);
	ОбластьШапка.Параметры.КлиентТелефон = КонтактнаяИнформацияСерверПереопределяемый.НайтиКонтактнуюИнформацию(
		СсылкаНаОбъект.Клиент, Перечисления.ТипыКонтактнойИнформации.Телефон);
	
	ТабДок.Вывести(ОбластьШапка);	
	
	ЖирнаяЛиния = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 3); 
	
	// Спецификации
	Если СсылкаНаОбъект.Спецификация.Количество() > 0 Тогда
		
		ОбластьСПШапка = МакетНаряда.ПолучитьОбласть("ОбластьСпецификацияШапка");
		ОбластьСПШапкаТаблицы = МакетНаряда.ПолучитьОбласть("ОбластьСпецификацияШапкаТаблицы");
		ТабДок.Вывести(ОбластьСПШапка);
		ТабДок.Вывести(ОбластьСПШапкаТаблицы);
		
		ОбластьСПСтрокаТаблицы = МакетНаряда.ПолучитьОбласть("ОбластьСпецификацияСтрокаТаблицы");
		
		Спецификация = СсылкаНаОбъект.Спецификация;
		КолСтрокСвецификацииПФ = Окр(СсылкаНаОбъект.Спецификация.Количество()/2,0,РежимОкругления.Окр15как20);
		Для Сч = 0 По КолСтрокСвецификацииПФ-1 Цикл
			ОбластьСПСтрокаТаблицы.Параметры["Параметр1"] = Спецификация[Сч].Параметр;
			ОбластьСПСтрокаТаблицы.Параметры["Значение1"] = Спецификация[Сч].Значение;
			
			ИндексСтрокиВторойКолонки = Сч + КолСтрокСвецификацииПФ;
			Если Спецификация.Количество() >= ИндексСтрокиВторойКолонки + 1 Тогда
				ОбластьСПСтрокаТаблицы.Параметры["Параметр2"] = Спецификация[ИндексСтрокиВторойКолонки].Параметр;
				ОбластьСПСтрокаТаблицы.Параметры["Значение2"] = Спецификация[ИндексСтрокиВторойКолонки].Значение;
			Иначе
				ОбластьСПСтрокаТаблицы.Параметры["Параметр2"] = "";
				ОбластьСПСтрокаТаблицы.Параметры["Значение2"] = "";
			КонецЕсли;
			
			ТабДок.Вывести(ОбластьСПСтрокаТаблицы);
		КонецЦикла;
		
	КонецЕсли;
	
	// Этапы работ
	Если СсылкаНаОбъект.ЭтапыРабот.Количество() > 0 Тогда
		
		ОбластьЭтапыШапка = МакетНаряда.ПолучитьОбласть("ОбластьЭтапыРаботШапка");
		ОбластьЭтапыШапкаТаблицы = МакетНаряда.ПолучитьОбласть("ОбластьЭтапыРаботШапкаТаблицы");
		ТабДок.Вывести(ОбластьЭтапыШапка);
		ТабДок.Вывести(ОбластьЭтапыШапкаТаблицы);
		
		Для Каждого СтрокаЭтап Из СсылкаНаОбъект.ЭтапыРабот Цикл
			
			ОбластьЭтапыСтрокаТаблицы = МакетНаряда.ПолучитьОбласть("ОбластьЭтапыРаботСтрокаТаблицы");
			ОбластьЭтапыСтрокаТаблицы.Параметры.ЭтапРаботы = СтрокаЭтап.Номенклатура;
			ОбластьЭтапыСтрокаТаблицы.Параметры.Исполнитель = СтрокаЭтап.ИсполнительПлан;
			ОбластьЭтапыСтрокаТаблицы.Параметры.Комментарий = СтрокаЭтап.Комментарий;
			ТабДок.Вывести(ОбластьЭтапыСтрокаТаблицы);
			
		КонецЦикла;
		
	КонецЕсли;
	
	// Область работ
	ОбластьРаботыШапка = МакетНаряда.ПолучитьОбласть("ОбластьРаботыШапка");
	ТабДок.Вывести(ОбластьРаботыШапка);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗаказНаИзготовлениеРаботы.Номенклатура,
	|	ЗаказНаИзготовлениеРаботы.Количество,
	|	ЗаказНаИзготовлениеРаботы.ЦенаСоСкидкой КАК Цена,
	|	ЗаказНаИзготовлениеРаботы.Сумма,
	|	ЗаказНаИзготовлениеРаботы.Примечание КАК Комментарий
	|ИЗ
	|	Документ.КомплексныйРасчетКлиента.Состав КАК ЗаказНаИзготовлениеРаботы
	|ГДЕ
	|	ЗаказНаИзготовлениеРаботы.Ссылка = &ЗаказНаИзготовление"; 
	Запрос.УстановитьПараметр("ЗаказНаИзготовление", СсылкаНаОбъект);
	Выборка = Запрос.Выполнить().Выбрать();
	СуммаИтого = 0;
	Пока Выборка.Следующий() Цикл
		СуммаИтого = СуммаИтого + Выборка.Сумма;
		ОбластьРаботыСтрока = МакетНаряда.ПолучитьОбласть("ОбластьРаботыСтрока");
		ОбластьРаботыСтрока.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(ОбластьРаботыСтрока);
	КонецЦикла;

	// Итого сумма и аванс
	ОбластьРаботыПодвал = МакетНаряда.ПолучитьОбласть("ОбластьИтогоСуммаАванс");
	
	ДанныеОплаты = КомплексныеРасчетыКлиентов.ПолучитьДанныеПоОплатеРасчета(СсылкаНаОбъект);
	ОбластьРаботыПодвал.Параметры.СуммаДокумента = ОбщегоНазначенияКлиентСервер.ФорматСумм(ДанныеОплаты.СуммаДокумента, Валюта);
	
	Если ЗначениеЗаполнено (СсылкаНаОбъект.ПроцентАванса) Тогда
		ОбластьРаботыПодвал.Параметры.Аванс = "Аванс: "
			+ ОбщегоНазначенияКлиентСервер.ФорматСумм(ДанныеОплаты.СуммаАвансаПолная, Валюта) 
			+ " (" + ДанныеОплаты.ПроцентАванса + "%)";
	КонецЕсли;
	ТабДок.Вывести(ОбластьРаботыПодвал);

	// Подвал
	Если ЗначениеЗаполнено(СсылкаНаОбъект.Комментарий) Тогда
		ОбластьПодвал = МакетНаряда.ПолучитьОбласть("ОбластьПодвалКомментарий");
		ОбластьПодвал.Параметры.КомментарийНаряда = СсылкаНаОбъект.Комментарий;
		ТабДок.Вывести(ОбластьПодвал);
	КонецЕсли;
	
	ОбластьПодвал = МакетНаряда.ПолучитьОбласть("ОбластьПодвал");
	ОбластьПодвал.Параметры.Дата = Формат(СсылкаНаОбъект.Дата, "ДЛФ=D");
	ОбластьПодвал.Параметры.КлиентИнициалы = CRMСервер.ПолучитьФИООбъекта(СсылкаНаОбъект.Клиент, Истина);
	
	ТабДок.Вывести(ОбластьПодвал);
	
	ТабДок.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_КомплексныйРасчетКлиента_ПечатьЗаказНаряда";
	
	Возврат ТабДок;
	
КонецФункции

#КонецОбласти