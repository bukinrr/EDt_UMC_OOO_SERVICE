#Область РазделОписанияПеременных

&НаКлиенте
Перем мТекущаяДатаДокумента Экспорт; // Хранит текущую дату документа - для проверки перехода документа в другой период
                                     // установки номера.

&НаКлиенте
Перем мИзмененыНастройкиПодбора;

#КонецОбласти           

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РаботаСФормамиСервер.ФормаДокументаПриОткрытииСервер(ЭтаФорма);

	Элементы.ТоварыАртикул.Видимость = УправлениеНастройками.ПолучитьПараметрУчетнойПолитики("ПоказыватьАртикул" , ТекущаяДата());
	
	ЭтаФорма.КоманднаяПанель.ПодчиненныеЭлементы.ФормаОбщаяКомандаПечатьПоУмолчанию.Заголовок = 
	ХранилищеПользовательскихНастроекОтчетов.Загрузить("ИнвентаризацияТоваров", "ПечатнаяФорма");

	Элементы.ТоварыХарактеристикаНоменклатуры.Видимость = УправлениеНастройками.ПолучитьПараметрУчетнойПолитики("ВестиУчетПоХарактеристикам");
	
	РаботаСФормамиСервер.НастройкаПодбораПриСоздании(ЭтаФорма, Ложь, "Товары", "Материал");

	РаботаСФормамиСервер.УстановитьВидимостьКнопокЗагрузитьИзТСД(Элементы.ТоварыГруппаЗагрузитьИзТСД);
	
	ЗагрузитьНастройкиОтбораНоменклатуры();
	
КонецПроцедуры
  
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	мТекущаяДатаДокумента = Объект.Дата;
	
	Если Параметры.Ключ.Пустая() Тогда
		ВхДокДата = ТекущаяДата();
		Модифицированность = ЛОЖЬ;
	КонецЕсли;
	
	Если Истина // ИспользоватьПодключаемоеОборудование  Проверка на включенную ФО "Использовать ВО".
	   И МенеджерОборудованияКлиент.ОбновитьРабочееМестоКлиента() Тогда // Проверка на определенность рабочего места ВО.
		ОписаниеОшибки = "";
		
		ПоддерживаемыеТипыВО = Новый Массив();
		ПоддерживаемыеТипыВО.Добавить("СканерШтрихкода");
		ПоддерживаемыеТипыВО.Добавить("СчитывательМагнитныхКарт");
		ПоддерживаемыеТипыВО.Добавить("ТерминалСбораДанных");
		
		ОповещенияПриПодключении = Новый ОписаниеОповещения("ПодключитьОборудованиеЗавершение", ЭтотОбъект);    
		МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПоТипу(ОповещенияПриПодключении, УникальныйИдентификатор, ПоддерживаемыеТипыВО);

	КонецЕсли;
	
	РаботаСФормамиКлиент.ОчиститьЛишниеКомандыПобор(ЭтаФорма);
	ПечатьДокументовКлиент.УстановитьЗаголовокПечатнойФормы(ЭтаФорма);
	
	ОбновитьВсеОтклонения();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	// МеханизмВнешнегоОборудования
	ПоддерживаемыеТипыВО = Новый Массив();
	ПоддерживаемыеТипыВО.Добавить("СканерШтрихкода");
	ПоддерживаемыеТипыВО.Добавить("СчитывательМагнитныхКарт");
	ПоддерживаемыеТипыВО.Добавить("ТерминалСбораДанных");
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПоТипу(Неопределено, УникальныйИдентификатор, ПоддерживаемыеТипыВО);
	// Конец МеханизмВнешнегоОборудования
	Если НЕ ЗавершениеРаботы Тогда	
		СохранитьНастройкиПодбора();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ЗначениеВыбора, Источник)
	Перем Действие;
	
	Если ТипЗнч(ЗначениеВыбора) = Тип("Структура") Тогда
		ЗначениеВыбора.Свойство("Действие", Действие);

		Если Действие = "ПодборМатериала" Тогда
			
			ДанныеНоменклатуры = РаботаСТорговымОборудованиемКлиент.ДанныеНоменклатуры();
			ЗаполнитьЗначенияСвойств(ДанныеНоменклатуры, ЗначениеВыбора);
			СШКНоменклатура(ДанныеНоменклатуры, Неопределено);
			
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ScanData" Тогда
		Если ВводДоступен() Тогда
			ТипШК = Неопределено;
			РаботаСТорговымОборудованиемКлиент.ОбработатьСобытиеСШКФормы(ЭтаФорма, Параметр, ТипШК);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	РаботаСФормамиСервер.ВывестиЗаголовокФормыДокумента(ТекущийОбъект,,ЭтаФорма);
	
	РаботаСДокументамиСервер.ПроверитьПринадлежностьСкладаФилиалу(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Для НомерЭлемента = 0 По Объект.Товары.Количество() - 1 Цикл
		ОбновитьОтклонение(НомерЭлемента);
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

// Изменение даты документа
&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ВызватьОбщийМодульПроверитьНомерДокумента(мТекущаяДатаДокумента);
	мТекущаяДатаДокумента = Объект.Дата;

КонецПроцедуры

&НаСервере
Процедура ВызватьОбщийМодульПроверитьНомерДокумента(ДатаДок)
	
	РаботаСДиалогамиСервер.ПроверитьНомерДокумента(ЭтаФорма, ДатаДок);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПослеУдаления(Элемент)
	РасчитатьСуммуДокумента();
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	Если Не ОтменаРедактирования Тогда
		РасчитатьСуммуДокумента();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент, НомерСтроки = Неопределено)
	ТоварыРеквизитПриИзменении("Товары.Номенклатура", НомерСтроки);	
	ОбновитьОтклонение(НомерСтроки);	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаНоменклатурыПриИзменении(Элемент)
	ТоварыРеквизитПриИзменении("Товары.ХарактеристикаНоменклатуры");
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЕдиницаИзмеренияПриИзменении(Элемент)
	ТоварыРеквизитПриИзменении("Товары.ЕдиницаИзмерения");
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент, НомерСтроки = Неопределено)
	ТоварыРеквизитПриИзменении("Товары.Количество", НомерСтроки);
	ОбновитьОтклонение();
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоУчетПриИзменении(Элемент)
	ОбновитьОтклонение();
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЦенаПриИзменении(Элемент)
	ТоварыРеквизитПриИзменении("Товары.Цена");
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСуммаПриИзменении(Элемент)
	ТоварыРеквизитПриИзменении("Товары.Сумма");
КонецПроцедуры
      
&НаКлиенте
Процедура ТоварыРеквизитПриИзменении(ИмяРеквизита, НомерСтроки = Неопределено)
	ОбработкаРеквизитаУпр(ИмяРеквизита,?(НомерСтроки = Неопределено, Элементы.Товары.ТекущиеДанные, Объект.Товары[НомерСтроки]),ЭтаФорма);
КонецПроцедуры

// Обработка изменения реквизитов документа.
//
// Параметры:
//  Имя			– Строка			– Имя реквизита документа с полным путем (например Тавары.Номенклатура).
//  ЭтаФорма	– Форма				– Ссылка на форму документа. 
// 									  Если значение неопределено, производится программная обработка реквизитов.
//  ТекСтрока	– СтрокаТабличнойЧасти - Ссылка на строку табличной части документа, реквизит которой обрабатывается.
// 										 Имеет смысл только для табличных частей документов.
//  ДопПараметры– Стркутура			– Структура, содержащая дополнительные параметры обработки реквизита.
// Возвращаемое значение:
//   Булево   - Результат выполнения обработки.
&НаКлиенте
Процедура ОбработкаРеквизитаУпр(Имя,ТекСтрока=Неопределено,ЭтаФорма=Неопределено,ДопПараметры=Неопределено)
	// ОБРАБОТКА РЕКВИЗИТОВ ДОКУМЕНТА
	Если Имя="Склад" Тогда
			
	// ОБРАБОТКА РЕКВИЗИТОВ ТАБЛИЧНОЙ ЧАСТИ "ТОВАРЫ"
	ИначеЕсли Имя="Товары.Номенклатура" Тогда
		
		Если Не ЗначениеЗаполнено(ТекСтрока.ЕдиницаИзмерения)
			Или ДопСерверныеФункции.ПолучитьРеквизит(ТекСтрока.ЕдиницаИзмерения, "Владелец") <> ТекСтрока.Номенклатура
		Тогда
			ТекСтрока.ЕдиницаИзмерения = ДопСерверныеФункции.ПолучитьРеквизит(ТекСтрока.Номенклатура, "ЕдиницаХраненияОстатков");
			ТекСтрока.Коэффициент = ДопСерверныеФункции.ПолучитьРеквизит(ТекСтрока.ЕдиницаИзмерения, "Коэффициент");
		КонецЕсли;
			
	ИначеЕсли Имя="Товары.ЕдиницаИзмерения" Тогда
		
		СтарыйКоэффициент = ?(ЗначениеЗаполнено(ТекСтрока.Коэффициент),ТекСтрока.Коэффициент,1);
		ТекСтрока.Коэффициент = ДопСерверныеФункции.ПолучитьРеквизит(ТекСтрока.ЕдиницаИзмерения, "Коэффициент");
		
		Если ТекСтрока.Коэффициент <> 0 Тогда
			ТекСтрока.КоличествоУчет = ТекСтрока.КоличествоУчет * СтарыйКоэффициент/ТекСтрока.Коэффициент;
			ТекСтрока.Количество=?(ЗначениеЗаполнено(ТекСтрока.Сумма), ТекСтрока.Количество, ТекСтрока.Количество * СтарыйКоэффициент/ТекСтрока.Коэффициент); 
		КонецЕсли;

		Если Не ЗначениеЗаполнено(ТекСтрока.Цена) Тогда
			ТекСтрока.Цена        = ТекСтрока.Цена       * ТекСтрока.Коэффициент/СтарыйКоэффициент;
			ОбработкаРеквизитаУпр("Товары.Цена", ТекСтрока, ЭтаФорма);
		Иначе
			ОбработкаРеквизитаУпр("Товары.Цена", ТекСтрока, ЭтаФорма);
		КонецЕсли;
		                                                                    
	ИначеЕсли Имя="Товары.Количество" Тогда
		РаботаСДокументамиКлиент.дкОбработкаРеквизитаКлиент(Объект,Имя,ТекСтрока,ЭтаФорма,ДопПараметры);
		
	ИначеЕсли Имя="Товары.Цена" Тогда
		РаботаСДокументамиКлиент.дкОбработкаРеквизитаКлиент(Объект,Имя,ТекСтрока,ЭтаФорма,ДопПараметры);
		
	ИначеЕсли Имя="Товары.Сумма" Тогда
		РаботаСДокументамиКлиент.дкОбработкаРеквизитаКлиент(Объект,Имя,ТекСтрока,ЭтаФорма,ДопПараметры);
		
	ИначеЕсли Имя = "Товары.ХарактеристикаНоменклатуры"	Тогда
		// Ничего.
	Иначе 
		РаботаСДокументамиКлиент.дкОбработкаРеквизитаКлиент(Объект,Имя,ТекСтрока,ЭтаФорма,ДопПараметры);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Рассчитывает сумму документа и обновляет надписи её отображения.
&НаКлиенте
Процедура РасчитатьСуммуДокумента()
	РасчитатьСуммуДокументаСервер()
КонецПроцедуры

&НаСервере
Процедура РасчитатьСуммуДокументаСервер()
	РаботаСДокументамиСервер.РасчитатьСуммуДокумента(Объект);	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОтклонение(НомерСтроки = Неопределено)
	
	Если НомерСтроки <> Неопределено Тогда
		ТекущиеДанные = Объект.Товары[НомерСтроки];
	Иначе
		ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	КонецЕсли;
	ТекущиеДанные.Отклонение = ТекущиеДанные.Количество - ТекущиеДанные.КоличествоУчет;
	
КонецПроцедуры	 

&НаКлиенте
Процедура ОбновитьВсеОтклонения()
	Для Каждого Стр Из Объект.Товары Цикл
		Стр.Отклонение = Стр.Количество - Стр.КоличествоУчет;
	КонецЦикла;	
КонецПроцедуры	

#КонецОбласти

#Область ПодключаемоеОборудование

// Функция осуществляет обработку считывания штрихкода номенклатуры.
//
// Параметры:
//  ДанныеНоменклатуры	 - Старуктура	 - сведения о считанной позиции.
//  СШК					 - Строка		 - Идентификатор сканера штрих-кода, с которым связано данное событие.
// 
// Возвращаемое значение:
//  Булево - Событие обработано.
//
&НаКлиенте
Функция СШКНоменклатура(ДанныеНоменклатуры, СШК) Экспорт
	Номенклатура				= ДанныеНоменклатуры.Номенклатура;
	Количество					= ДанныеНоменклатуры.Количество;
	ХарактеристикаНоменклатуры	= ДанныеНоменклатуры.ХарактеристикаНоменклатуры;
	Единица						= ДанныеНоменклатуры.ЕдиницаИзмерения;
	Цена						= ДанныеНоменклатуры.Цена;
	СерияНоменклатуры           = ДанныеНоменклатуры.СерияНоменклатуры;
	
	РеквизитыНоменклатуры = РаботаСДокументамиСервер.ДанныеНоменклатурыДляОбработкиЧтенияШК(Номенклатура, Ложь);
	Если РеквизитыНоменклатуры.ЭтоМатериал Тогда
		
		ТабличнаяЧасть = Объект.Товары;
		мсСтрокиТовары = РаботаСДокументамиКлиент.ЧтениеШтрихкода_НайтиСтрокиДокументаПоДаннымШтрихкода(ТабличнаяЧасть, ДанныеНоменклатуры, РеквизитыНоменклатуры);
				                                                       
		Если мсСтрокиТовары.Количество() = 0 Тогда

			// Добавление новой строки
			СтрокаТовары = РаботаСДокументамиКлиент.ЧтениеШтрихкода_ДобавитьСтрокуТовараПоДаннымШтрихкода(ТабличнаяЧасть, ДанныеНоменклатуры, РеквизитыНоменклатуры);
			
			СтрокаТовары.Цена = ?(Цена = Неопределено, 0 , Цена);
			СтрокаТовары.Сумма = СтрокаТовары.Цена*Количество;
			
			ТоварыНоменклатураПриИзменении(Неопределено, СтрокаТовары.НомерСтроки-1);
			НоваяСтрока = Истина;
		Иначе
			// Увеличивается количество в существующей строке.
			СтрокаТовары = мсСтрокиТовары[0];
			СтрокаТовары.Количество = СтрокаТовары.Количество + Количество;      
						
			Если СтрокаТовары.Свойство("Цена") Тогда
				Если Цена <> Неопределено  И Цена > 0 Тогда
					СтрокаТовары.Цена = Цена;      
				КонецЕсли;	
			КонецЕсли;
			
			Если СтрокаТовары.Свойство("Сумма") Тогда
				СтрокаТовары.Сумма = СтрокаТовары.Цена*Количество;      
			КонецЕсли;

			
			ТоварыКоличествоПриИзменении(Неопределено, СтрокаТовары.НомерСтроки-1);

			НоваяСтрока = Ложь;
		КонецЕсли;
		
		ТоварыПриОкончанииРедактирования(Элементы.Товары, НоваяСтрока, Ложь);
		Элементы.Товары.ТекущаяСтрока = СтрокаТовары.ПолучитьИдентификатор();

	Иначе
		РаботаСДокументамиКлиент.ЧтениеШтрихкода_ПредупреждениеОжидаетсяМатериал(Номенклатура);
	КонецЕсли; 
	Возврат Истина;

КонецФункции // СШКНоменклатура()

&НаКлиенте
// Процедура ПодключитьОборудованиеЗавершение.
//
// Параметры:
//  РезультатВыполнения - Неопределено
//  Параметры - Неопределено
//
Процедура ПодключитьОборудованиеЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Если Не РезультатВыполнения.Результат Тогда
		ТекстСообщения = НСтр( "ru = 'При подключении оборудования произошла ошибка:
				|""%ОписаниеОшибки%"".'" );
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%" , РезультатВыполнения.ОписаниеОшибки);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПодборНоменклатуры // Процедуры подбора номенклатуры.

&НаКлиенте
Процедура Подбор(Команда)
	РаботаСФормамиКлиент.КнопкаПодборПриНажатии(ЭтаФорма, "Товары");
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыборПодбор(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Ложь Тогда ЗапрашиватьКоличество = Ложь; ЗапрашиватьЦену = Ложь; ЗапрашиватьХарактеристику = Ложь; ЗапрашиватьСерию = Ложь; КонецЕсли; 
	СтандартнаяОбработка = Ложь;
	
	Если Не ДопСерверныеФункции.ПолучитьРеквизит(ВыбранноеЗначение, "ЭтоГруппа") Тогда
		Действие = "ПодборМатериала";
	    Результат = РаботаСФормамиКлиент.ВыборПодборОбработка(ВыбранноеЗначение, ЗапрашиватьКоличество, ЗапрашиватьЦену, ЗапрашиватьХарактеристику, ЗапрашиватьСерию, Действие, ЭтаФорма, 0); 
		Если Результат <> Неопределено Тогда
			ОбработкаВыбора(Результат, Неопределено);
			Модифицированность = Истина;
		КонецЕсли;
	КонецЕсли;	

КонецПроцедуры	

&НаКлиенте
Процедура Подключаемый_ПолеПодбораПриИзменении(Элемент)
	мИзмененыНастройкиПодбора = Истина;
	СохранитьНастройкиПодбора();
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройкиПодбора()
	
	Если ЗначениеЗаполнено(мИзмененыНастройкиПодбора) Тогда 
		РаботаСФормамиСервер.СохранитьНастройкиПодбора(ЭтаФорма.ЗапрашиватьКоличество, ЭтаФорма.ЗапрашиватьЦену, ЭтаФорма.ЗапрашиватьХарактеристику, ЭтаФорма.ЗапрашиватьСерию, ТипЗнч(Объект.Ссылка));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиДинамическиСоздаваемыхКоманд

&НаКлиенте
Процедура Подключаемый_КнопкаФилиалПриНажатии(Команда)
	РаботаСДиалогамиКлиент.ДиалогКнопкаФилиалПриНажатии(ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область КомандыЗаполненияДокумента

&НаКлиенте
Процедура КоманднаяПанельТоварыЗаполнитьПоОстаткамНаСкладе(Кнопка)
	
	Если Не ЗначениеЗаполнено(Объект.Склад) Тогда
		ПоказатьПредупреждение(,НСтр("ru='Не указан склад инвентаризации!'"));
		Возврат;
	КонецЕсли;
		
	Если Объект.Товары.Количество() > 0 Тогда	
		ОповещениеОЗавершении = Новый ОписаниеОповещения("ТоварыЗаполнитьПоОстаткамНаСкладеПродолжение", ЭтотОбъект, Новый Структура);
		ТекстВопроса = НСтр("ru='Перед заполнением табличная часть будет очищена. Заполнить?'");
		ПоказатьВопрос(ОповещениеОЗавершении, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да, Строка(Объект.Ссылка));
	Иначе
		ТоварыЗаполнитьПоОстаткамНаСкладеЗавершение();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Процедура ТоварыЗаполнитьПоОстаткамНаСкладеПродолжение.
//
// Параметры:
//  Результат - Неопределено
//  ДополнительныеПараметры - Неопределено
//
Процедура ТоварыЗаполнитьПоОстаткамНаСкладеПродолжение(Результат, ДополнительныеПараметры) Экспорт
		
	Если Результат = КодВозвратаДиалога.Да Тогда
		Объект.Товары.Очистить();
		Модифицированность = Истина;
		ТоварыЗаполнитьПоОстаткамНаСкладеЗавершение();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТоварыЗаполнитьПоОстаткамНаСкладеЗавершение()
		
	ЗаполнитьТоварыПоОстаткамНаСкладеСервер();
	ОбновитьВсеОтклонения();

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТоварыПоОстаткамНаСкладеСервер()
	
	Документы.ИнвентаризацияТоваров.ЗаполнитьТоварыПоОстаткамНаСкладе(Объект, ПолучитьНастройкиОтбора());
	
КонецПроцедуры 	

&НаКлиенте
Процедура КоманднаяПанельТоварыДополнитьПоОстаткамНаСкладе(Кнопка)
	
	Если Не ЗначениеЗаполнено(Объект.Склад) Тогда
		ПоказатьПредупреждение(,НСтр("ru='Не указан склад инвентаризации!'"));
		Возврат;
	КонецЕсли;
	
	ДополнитьТоварыПоОстаткамНаСкладеСервер();
	ОбновитьВсеОтклонения();
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ДополнитьТоварыПоОстаткамНаСкладеСервер()
	
	Документы.ИнвентаризацияТоваров.ДополнитьТоварыПоОстаткамНаСкладе(Объект, ПолучитьНастройкиОтбора());

КонецПроцедуры 	

&НаСервере
Процедура ПерезаполнитьУчетныеКоличестваСервер()
	
	Документы.ИнвентаризацияТоваров.ПерезаполнитьУчетныеКоличества(Объект);

КонецПроцедуры 	

&НаКлиенте
Процедура КоманднаяПанельТоварыСвернутьТаблицуТоваров(Кнопка)
	
	Если Не ЗначениеЗаполнено(Объект.Склад) Тогда
		ПоказатьПредупреждение(,НСтр("ru='Не указан склад инвентаризации!'"));
		Возврат;
	КонецЕсли;

	Если Объект.Товары.Количество() > 0 Тогда
		ОповещениеОЗавершении = Новый ОписаниеОповещения("ТоварыСвернутьТаблицуТоваровЗавершение", ЭтотОбъект, Новый Структура);
		ТекстВопроса = НСтр("ru='После свёртки будут перезаполнены учетные количества и суммы. Продолжить?'");
		ПоказатьВопрос(ОповещениеОЗавершении, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да, Строка(Объект.Ссылка)); 
	Иначе
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Процедура ТоварыСвернутьТаблицуТоваровЗавершение.
//
// Параметры:
//  Результат - Неопределено
//  ДополнительныеПараметры - Неопределено
//
Процедура ТоварыСвернутьТаблицуТоваровЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		СвернутьтаблицуТоваровСервер();
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СвернутьтаблицуТоваровСервер()
	
	Документы.ИнвентаризацияТоваров.СвернутьтаблицуТоваров(Объект);

КонецПроцедуры	

&НаКлиенте
Процедура ПерезаполнитьУчетныеКоличестваИСуммы(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Склад) Тогда
		ПоказатьПредупреждение(,НСтр("ru='Не указан склад инвентаризации!'"));
		Возврат;
	КонецЕсли;	
	ПерезаполнитьУчетныеКоличестваСервер();
	ОбновитьВсеОтклонения();
	Модифицированность = Истина;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьКоличествоУчетными(Команда)
	
	Для Каждого СтрокаТовары Из Объект.Товары Цикл
		
		СтрокаТовары.Количество = Макс(СтрокаТовары.КоличествоУчет, 0);
		
	КонецЦикла;
	ОбновитьВсеОтклонения();
	
КонецПроцедуры

#КонецОбласти

#Область ТерминалыСбораДанных // ТЕРМИНАЛЫ СБОРА ДАННЫХ

&НаКлиенте
Процедура ЗагрузитьДанныеИзТСД(Команда)
	
	Кнопки = Новый СписокЗначений();
	Кнопки.Добавить("Добавить", "Добавить");
	Кнопки.Добавить("Перезаполнить", "Перезаполнить");
	
	Если Команда.Имя = "ЗагрузитьДанныеИзТСДПерезаполнить" Тогда
		РежимЗагрузки = "Перезаполнить";
	Иначе
		РежимЗагрузки = "Добавить";
	КонецЕсли;
	
	ОповещенияПриПодключении = Новый ОписаниеОповещения("ЗагрузитьДанныеИзТСДЗавершение", ЭтотОбъект, Новый Структура("РежимЗагрузки", РежимЗагрузки));    
	МенеджерОборудованияКлиент.НачатьЗагрузкуДанныеИзТСД(ОповещенияПриПодключении, УникальныйИдентификатор, Ложь)	
		
КонецПроцедуры

&НаКлиенте
// Процедура ЗагрузитьДанныеИзТСДЗавершение.
//
// Параметры:
//  РезультатВыполнения - Неопределено
//  Параметры - Неопределено
//
Процедура ЗагрузитьДанныеИзТСДЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Если РезультатВыполнения.Результат Тогда
		мсШтрихкоды = РезультатВыполнения.ТаблицаТоваров;

		ДопПараметры = Новый Структура;
		ДопПараметры.Вставить("ДобавлятьБезВладельца", Истина);
		ДопПараметры.Вставить("СпособЗаполнения", Параметры.РежимЗагрузки);
		РаботаСТорговымОборудованиемКлиент.ОбработатьШтрихкоды(ЭтаФорма, Объект, мсШтрихкоды, "Товары", ДопПараметры);
		ОбновитьОтклонение();
	Иначе
		ТекстСообщения = НСтр( "ru = 'При подключении оборудования произошла ошибка:
		|""%ОписаниеОшибки%"".'" );
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%" , РезультатВыполнения.ОписаниеОшибки);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ЗагрузитьНастройкиОтбораНоменклатуры()
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	
	СхемаКомпоновкиДанных = Документы.ИнвентаризацияТоваров.ПолучитьМакет("МакетСКДОтборНоменклатуры");

	ВремХранилищеСКД = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, ЭтаФорма.УникальныйИдентификатор);
	
	КомпановщикНастроекКД.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(ВремХранилищеСКД));
	КомпановщикНастроекКД.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	КомпановщикНастроекКД.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	
	НастройкиОтбора = ДокументОбъект.ХранилищеОтбор.Получить();
	
	Если ЗначениеЗаполнено(НастройкиОтбора) Тогда
		КомпановщикНастроекКД.ЗагрузитьНастройки(НастройкиОтбора);
	КонецЕсли;
		
КонецПроцедуры 

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ТекущийОбъект.ХранилищеОтбор = Новый ХранилищеЗначения(ПолучитьНастройкиОтбора());	
КонецПроцедуры

&НаСервере
Функция ПолучитьНастройкиОтбора()
	
	Настройки = Неопределено;
	
	Для Каждого Элемент Из КомпановщикНастроекКД.Настройки.Отбор.Элементы Цикл
		Если Элемент.Использование Тогда
			Настройки = КомпановщикНастроекКД.ПолучитьНастройки();
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Настройки;
	
КонецФункции
