#Область РазделОписанияПеременных

&НаКлиенте
Перем мТекущаяДатаДокумента Экспорт; // Хранит текущую дату документа - для проверки перехода документа в другой период установки номера.

&НаКлиенте
Перем РаспределитьНоменклатуруПоРазнымСНО Экспорт; // Флаг, отвечающий за перезапись документа с отбором номенклатуры только под одной СНО.

#КонецОбласти

#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДополнительныеСвойства = РаботаСФормамиСервер.ФормаДокументаПриОткрытииСервер(ЭтотОбъект);
	
	НастройкаПечатиЧеков = МенеджерОборудованияВызовСервераПереопределяемый.ПолучитьНастройкуПечатиЧековФилиала(Объект.Филиал, Истина);	
	Если Объект.Ссылка.Пустая() Тогда
		ЗаполнитьДепозитнуюОперациюККМ();
	КонецЕсли;
	
	ДоступныПолныеПрава = Пользователи.ЭтоПолноправныйПользователь();
	
	Если Объект.Ссылка.Пустая() Тогда
		Если Не ЗначениеЗаполнено(Объект.ЭквайринговыйТерминал) Тогда
			Объект.ЭквайринговыйТерминал = РаботаСТорговымОборудованием.ПолучитьЭквайринговыйТерминал(, Объект.Филиал);
		КонецЕсли;		
	КонецЕсли;

	ПоместитьРеквизитыККТИзХЗвРеквизитыФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не РаботаСДокументамиКлиент.ФормаДокументаПриОткрытии(ЭтотОбъект, ДополнительныеСвойства) Тогда
		ЭтотОбъект.Закрыть();
		Возврат;
	КонецЕсли;
	
	мТекущаяДатаДокумента = Объект.Дата;
	ОбновитьДоступностьЭлементов();
	
	Элементы.НадписьВалюта.Заголовок = глКраткоеНаименованиеОсновнойВалюты;
	
	ПечатьДокументовКлиент.УстановитьЗаголовокПечатнойФормы(ЭтаФорма);
	
	РаботаСДокументамиКлиент.ОбновитьВидимостьДоступностьСпособаРасчетаККМ(ЭтаФорма, Неопределено, Объект.СпособРасчетаЧекаККМ, НастройкаПечатиЧеков);
	РаботаСДокументамиКлиент.ОбновитьВидимостьКредитныхДанныхККМ(ЭтаФорма, Неопределено, Объект.КредитныеДанные, Объект.СпособРасчетаЧекаККМ);
	
	РаботаСДокументамиКлиент.РассчитатьЗаполнитьПризнакиЕНВДКредитнойЧасти(Объект, НастройкаПечатиЧеков);
	РаботаСДокументамиКлиент.ПлатежныйДокументПриОткрытииПроверкаНоменклатурыДоплатыНаНесколькоСНО(ЭтаФорма);
	
	КоррекцияПриИзменении("");
	
	Если Истина // ИспользоватьПодключаемоеОборудование Проверка на включенную ФО "Использовать ВО"
	   И МенеджерОборудованияКлиент.ОбновитьРабочееМестоКлиента() Тогда // Проверка на определенность рабочего места ВО.
		ОписаниеОшибки = "";
		
		ПоддерживаемыеТипыВО = Новый Массив();
		ПоддерживаемыеТипыВО.Добавить("ДисплейПокупателя");
		
		ОповещенияПриПодключении = Новый ОписаниеОповещения("ПодключитьОборудованиеЗавершение", ЭтотОбъект);    
		МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПоТипу(ОповещенияПриПодключении, УникальныйИдентификатор, ПоддерживаемыеТипыВО);

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	РаботаСДокументамиКлиент.ПлатежныйДокументПередЗаписьюНаФорме(ЭтотОбъект, Отказ, Объект, ПараметрыЗаписи, НастройкаПечатиЧеков)

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаписатьРеквизитыККТИзРеквизитовФормыВХЗ(ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	РаботаСФормамиСервер.ВывестиЗаголовокФормыДокумента(Объект.Ссылка, Ложь, ЭтаФорма);	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	РаботаСДокументамиКлиент.ПлатежныйДокументПослеЗаписиОбработкаНоменклатурыДоплатыНаНесколькоСНО(ЭтаФорма);
	
	РаботаСДокументамиКлиент.РассчитатьЗаполнитьПризнакиЕНВДКредитнойЧасти(Объект, НастройкаПечатиЧеков);

	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект, "Сделка")
		И ЗначениеЗаполнено(Объект["Сделка"])
	Тогда
		Оповестить("ИзменениеДанныхОплатыКомплексногоРасчета", Новый Структура("Сделка", Объект["Сделка"]), Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ДокументОплатыЗаполнитьРасчетыПоДолгуПоКомплексномуРасчету"
		И Параметр = ЭтаФорма
	Тогда
		ДокументОплатыЗаполнитьРасчетыПоДолгуПоКомплексномуРасчетуСервер(РаботаСДокументамиКлиент.СделкаДокумента(Объект));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	ОборудованиеДисплеиПокупателяКлиент.НачатьОчисткуДисплеяПокупателя(,УникальныйИдентификатор);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиДинамическиСоздаваемыхКоманд

&НаКлиенте
Процедура Подключаемый_КнопкаФилиалПриНажатии(Команда)
	
	ОповещениеОВыборе = Новый ОписаниеОповещения("Подключаемый_КнопкаФилиалПриНажатииЗавершение", ЭтотОбъект);
	РаботаСДиалогамиКлиент.ДиалогКнопкаФилиалПриНажатии(ЭтаФорма, , ОповещениеОВыборе);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КнопкаФилиалПриНажатииЗавершение(Результат, ДополнительныеЗначения) Экспорт
	
	НастройкаПечатиЧеков = МенеджерОборудованияВызовСервераПереопределяемый.ПолучитьНастройкуПечатиЧековФилиала(Объект.Филиал, Истина);
	ЗаполнитьДепозитнуюОперациюККМ();
	РаботаСДокументамиКлиент.ОбновитьВидимостьДоступностьСпособаРасчетаККМ(ЭтаФорма, Неопределено, Объект.СпособРасчетаЧекаККМ, НастройкаПечатиЧеков);
	РаботаСДокументамиКлиент.ОбновитьВидимостьКредитныхДанныхККМ(ЭтаФорма, Неопределено, Объект.КредитныеДанные, Объект.СпособРасчетаЧекаККМ);
	РаботаСДокументамиКлиент.ПлатежныйДокументОбновитьЭквайрингПриСменеФилиала(Объект, Результат.ИсходныйФилиал); 
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВывестиДвиженияДокумента(Команда)
	РаботаСДиалогамиКлиент.ВывестиДвиженияДокумента(Объект.Ссылка, Команда);
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура КредитныеДанныеПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока И Не Копирование Тогда
		Элемент.ТекущиеДанные.Количество = 1;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	РаботаСФормамиКлиент.ДокументПриИзмененииДаты(ЭтаФорма, мТекущаяДатаДокумента);

КонецПроцедуры

&НаКлиенте
Процедура КлиентПриИзменении(Элемент)
	РаботаСДокументамиСервер.ЗаполнитьУчастникаИИННДенежнойОперации(Объект.Клиент, Объект.ПринятоОт, Объект.ПринятоОтИНН, Объект.ПринятоОтАдрес);
КонецПроцедуры

&НаКлиенте
Процедура КлиентАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)

	РаботаСФормамиКлиент.ПолеВводаКлиентаАвтоПодбор(Текст, СтандартнаяОбработка, ДанныеВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура КлиентОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)

	РаботаСФормамиКлиент.ПолеВводаКлиентаАвтоПодбор(Текст, СтандартнаяОбработка, ДанныеВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭквайринговыйТерминалНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	РабочееМесто = МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента();		
	Если ЗначениеЗаполнено(РабочееМесто) Тогда
		ПараметрыВыбораЗначения = Новый Структура("РабочееМесто", РабочееМесто);
		ПараметрыВыбораЗначения.Вставить("Филиал", Объект.Филиал);
		Результат = ОткрытьФормуМодально("Справочник.ЭквайринговыеТерминалы.ФормаВыбора", ПараметрыВыбораЗначения);
		Если Результат <> Неопределено Тогда
			Объект.ЭквайринговыйТерминал = Результат;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДоступностьЭлементов()
	Если ЗначениеЗаполнено(Объект.НомерЧекаЭТ) Тогда
		Элементы.ЭквайринговыйТерминал.Доступность = Ложь;	
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Чек(Команда)
	
	РаботаСДокументамиКлиент.ЧекДенежногоДокумента(ЭтаФорма);
	
КонецПроцедуры

#Область СлужебныеПроцедурыПечатиЧеков

&НаКлиенте
Процедура КомандаSMS(Команда)
	ТипКИ = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Телефон");
	Объект.ТелефонЧек = КонтактнаяИнформацияКлиент.ВыбратьСоздатьКИКлиента(Объект.Клиент, ТипКИ, Объект.Филиал);
КонецПроцедуры

&НаКлиенте
Процедура КомандаEmail(Команда)
	ТипКИ = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты");
	Объект.АдресEmailЧек = КонтактнаяИнформацияКлиент.ВыбратьСоздатьКИКлиента(Объект.Клиент, ТипКИ, Объект.Филиал);
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура СпособРасчетаЧекаККМПриИзменении(Элемент)
	Если Объект.СпособРасчетаЧекаККМ = ПредопределенноеЗначение("Перечисление.СпособыРасчетаЧекаККМ.Аванс") Тогда
		Объект.КредитныеДанные.Очистить();
	КонецЕсли;
	
	РаботаСДокументамиКлиент.ОбновитьВидимостьКредитныхДанныхККМ(ЭтаФорма, Неопределено, Объект.КредитныеДанные, Объект.СпособРасчетаЧекаККМ);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоКомплексномуРасчету(Команда)
	ДокументОплатыЗаполнитьРасчетыПоДолгуПоКомплексномуРасчетуСервер(РаботаСДокументамиКлиент.СделкаДокумента(Объект));
	РаботаСДокументамиКлиент.РассчитатьЗаполнитьПризнакиЕНВДКредитнойЧасти(Объект, НастройкаПечатиЧеков);
КонецПроцедуры

&НаКлиенте
Процедура РаспределитьОплатуКредитныхДанныхККМ(Команда)
	РаботаСДокументамиКлиентСервер.РаспределитьОплатуКредитныхДанныхККМ(Объект.КредитныеДанные, Объект.СуммаДокумента);
КонецПроцедуры

&НаКлиенте
Процедура КредитныеДанныеСуммаПриИзменении(Элемент)
	ТД = Элементы.КредитныеДанные.ТекущиеДанные;
	Если ТД <> Неопределено Тогда
		РаботаСДокументамиКлиент.ЗаполнитьСуммуПриПокупкеСтрокиТабЧасти(ТД);
	КонецЕсли;
	ПерезаполнитьСуммуДокумента();
КонецПроцедуры

&НаКлиенте
Процедура КредитныеДанныеНоменклатураПриИзменении(Элемент)
	
	ТекущиеКредитныеДанные = Элементы.КредитныеДанные.ТекущиеДанные;
	Если ТекущиеКредитныеДанные <> Неопределено И ЗначениеЗаполнено(ТекущиеКредитныеДанные.Номенклатура) Тогда
		// Заполним Наименование
		ТекущиеКредитныеДанные.Наименование = ОбщегоНазначения.ПолучитьЗначениеРеквизита(ТекущиеКредитныеДанные.Номенклатура, "НаименованиеПолное");
		СтавкаНДСНоменклатуры = УчетНДСВызовСервера.СтавкаНДС(ТекущиеКредитныеДанные.Номенклатура, ОбщегоНазначения.ТекущаяДатаПользователя());
		
		// Заполним Ставку НДС
		Если ЗначениеЗаполнено(СтавкаНДСНоменклатуры) Тогда
			ТекущиеКредитныеДанные.СтавкаНДС = СтавкаНДСНоменклатуры;
		Иначе
			Если ЗначениеЗаполнено(НастройкаПечатиЧеков) И ЗначениеЗаполнено(НастройкаПечатиЧеков.СтавкаНДСДляОсновнойСистемыНалогообложения) Тогда
				СтавкаНДСПоУмолчанию = НастройкаПечатиЧеков.СтавкаНДСДляОсновнойСистемыНалогообложения;
			Иначе
				СтавкаНДСПоУмолчанию = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС0");
			КонецЕсли;
			
			ТекущиеКредитныеДанные.СтавкаНДС = СтавкаНДСПоУмолчанию;
		КонецЕсли;
	КонецЕсли;
	
	РаботаСДокументамиКлиент.РассчитатьЗаполнитьПризнакиЕНВДКредитнойЧасти(Объект, НастройкаПечатиЧеков);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоОказаниюУслуг(Команда)
	ЗаполнитьПоОказаниюУслугСервер();	
	РаботаСДокументамиКлиент.РассчитатьЗаполнитьПризнакиЕНВДКредитнойЧасти(Объект, НастройкаПечатиЧеков);
КонецПроцедуры

&НаСервере
Процедура ДокументОплатыЗаполнитьРасчетыПоДолгуПоКомплексномуРасчетуСервер(Сделка)
	Объект.СуммаДокумента = Макс(0, РаботаСКлиентамиПереопределяемый.ПолучитьВзаиморасчетыСКлиентом(Объект.Клиент, ТекущаяДата(), Сделка));
	РаботаСДокументамиСервер.ДокументОплатыЗаполнитьРасчетыПоДолгуПоКомплексномуРасчетуСервер(Сделка, НастройкаПечатиЧеков, Объект.КредитныеДанные, Объект.СуммаДокумента);
КонецПроцедуры

&НаСервере
Функция ЗаполнитьДепозитнуюОперациюККМ()
	РаботаСДокументамиСервер.ЗаполнитьДепозитнуюОперациюККМ(Объект, НастройкаПечатиЧеков);
КонецФункции

&НаСервере
Процедура ЗаполнитьПоОказаниюУслугСервер()
	РаботаСДокументамиСервер.ДокументОплатыЗаполнитьРасчетыПоДолгуПоОказаниюУслуг(Объект.ДокументОснование, НастройкаПечатиЧеков, Объект.КредитныеДанные, Объект.СуммаДокумента, Объект.СпособРасчетаЧекаККМ);
КонецПроцедуры

&НаКлиенте
Процедура СделкаПриИзменении(Элемент)
	РаботаСДокументамиКлиент.ПредложитьПерезаполнитьКредитныеДанныеПоСделкеДокумента(Объект, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура КредитныеДанныеПриИзменении(Элемент)
	ТекущиеКредитныеДанные = Элементы.КредитныеДанные.ТекущиеДанные;
	Если ТекущиеКредитныеДанные <> Неопределено И НЕ ЗначениеЗаполнено(ТекущиеКредитныеДанные.Номенклатура) Тогда
		// Заполним Ставку НДС
		Если ЗначениеЗаполнено(НастройкаПечатиЧеков) И ЗначениеЗаполнено(НастройкаПечатиЧеков.СтавкаНДСДляОсновнойСистемыНалогообложения) Тогда
			СтавкаНДСПоУмолчанию = НастройкаПечатиЧеков.СтавкаНДСДляОсновнойСистемыНалогообложения;
		Иначе
			СтавкаНДСПоУмолчанию = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС0");
		КонецЕсли;
		ТекущиеКредитныеДанные.СтавкаНДС = СтавкаНДСПоУмолчанию;		
	КонецЕсли;
	РаботаСДокументамиКлиент.РассчитатьЗаполнитьПризнакиЕНВДКредитнойЧасти(Объект, НастройкаПечатиЧеков);
КонецПроцедуры

&НаКлиенте
Процедура КредитныеДанныеПриАктивизацииЯчейки(Элемент)
	Если Элемент.ТекущийЭлемент.Имя	= "КредитныеДанныеНДС" И НЕ ДоступныПолныеПрава Тогда
		Элемент.ТекущийЭлемент.Доступность = Ложь;	
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДанныеПолучателя(Команда)
	РаботаСДокументамиСервер.ЗаполнитьУчастникаИИННДенежнойОперации(Объект.Клиент, Объект.ПринятоОт, Объект.ПринятоОтИНН, Объект.ПринятоОтАдрес, Истина);
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура КоррекцияПриИзменении(Элемент)
	РаботаСДокументамиКлиент.ОбновитьВидимостьЭлементовКоррекции(ЭтаФорма, Объект.Коррекция);
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьРедактированиеРеквизитаККТ(НазваниеРеквизитаККТ)
	
	РаботаСДокументамиКлиент.ВыполнитьРедактированиеРеквизитаККТ(ЭтотОбъект, НазваниеРеквизитаККТ, Объект.Клиент);
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьОперационныйРеквизитНажатие(Элемент)
	
	ВыполнитьРедактированиеРеквизитаККТ("ОперационныйРеквизит");
	
КонецПроцедуры

&наСервере
Процедура ПоместитьРеквизитыККТИзХЗвРеквизитыФормы()
	
	ОУОбъект = РеквизитФормыВЗначение("Объект");
	//ПерсональныеДанныеПокупателя	= ОУОбъект.ПерсональныеДанныеПокупателя.Получить();
	ОперационныйРеквизит			= ОУОбъект.ОперационныйРеквизит.Получить();
	
КонецПроцедуры

&наСервере
Процедура ЗаписатьРеквизитыККТИзРеквизитовФормыВХЗ(ОУОбъект)
	
	//ОУОбъект.ПерсональныеДанныеПокупателя	= Новый ХранилищеЗначения(ПерсональныеДанныеПокупателя);
	ОУОбъект.ОперационныйРеквизит			= Новый ХранилищеЗначения(ОперационныйРеквизит);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияФормыРедактированияРеквизитаККТ(Результат, ПараметрыРеквизитаККТ) Экспорт
	
	Если Результат <> Неопределено Тогда
		Если Результат.Свойство("ДетальнаяИнформация") Тогда
			РаботаСДокументамиКлиент.СохранитьЗначениеРеквизитаККТВОбъекте(ЭтаФорма, Результат.ДетальнаяИнформация, ПараметрыРеквизитаККТ.НазваниеРеквизитаККТ);
			Если ПараметрыРеквизитаККТ.НазваниеРеквизитаККТ = "ПерсональныеДанныеПокупателя" Тогда
				Объект.ПринятоОт = Результат.Клиент;
				Объект.ПринятоОтИНН = Результат.ДетальнаяИнформация.ИНН;
				Объект.ПринятоОтАдрес = Результат.Адрес;
			КонецЕсли;
		ИначеЕсли Результат.Свойство("Удалить") Тогда
			РаботаСДокументамиКлиент.ОчиститьЗначениеРеквизитаККТВОбъекте(ЭтаФорма, ПараметрыРеквизитаККТ.НазваниеРеквизитаККТ);	
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПодключитьОборудованиеЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Если Не РезультатВыполнения.Результат Тогда
		ТекстСообщения = НСтр( "ru = 'При подключении оборудования произошла ошибка:
				|""%ОписаниеОшибки%"".'" );
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%" , РезультатВыполнения.ОписаниеОшибки);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьПерсональныеДанныеПокупателяНажатие(Элемент)
	
	ВыполнитьРедактированиеРеквизитаККТ("ПерсональныеДанныеПокупателя");
	
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьСуммуДокумента()
	
	Объект.СуммаДокумента = 0;
	Для Каждого СтрокаНоменклатуры Из Объект.КредитныеДанные Цикл
		Объект.СуммаДокумента = Объект.СуммаДокумента + СтрокаНоменклатуры.Сумма;		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСертификат(Команда)
	
	Если ЗначениеЗаполнено(Объект.Клиент) Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("НаУслуги", Истина);
		ПараметрыФормы.Вставить("НаОплату", Ложь);
		ПараметрыФормы.Вставить("СертификатыТолькоВладельца", Истина);
		ПараметрыФормы.Вставить("ВладелецСертификата", Объект.Клиент);
		ПараметрыФормы.Вставить("ПроданныеСертификаты", Истина);
		ПараметрыФормы.Вставить("Дата", Объект.Дата);
		
		Оповещение = Новый ОписаниеОповещения("ДобавитьСертификат_Завершение", ЭтотОбъект);
		ОткрытьФорму("Справочник.Сертификаты.Форма.ФормаСпискаРасширеннаяУпр",ПараметрыФормы,ЭтотОбъект,,,,Оповещение,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	Иначе
		ПоказатьПредупреждение(,НСтр("ru='Нельзя выбрать сертификат, т.к. не указан клиент!'"), 10);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСертификат_Завершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("СправочникСсылка.Сертификаты") Тогда
		
		СтруктураДанныхСертификата = ПолучитьСтруктуДанныхСтрокиСертификата(Результат);
		ЗаполнитьЗначенияСвойств(Объект.КредитныеДанные.Добавить(), СтруктураДанныхСертификата);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСтруктуДанныхСтрокиСертификата(Сертификат)
		
	Возврат Новый Структура("Номенклатура, Наименование", Сертификат.ВидСертификата.Номенклатура, Сертификат.ВидСертификата.Наименование);
	
КонецФункции
