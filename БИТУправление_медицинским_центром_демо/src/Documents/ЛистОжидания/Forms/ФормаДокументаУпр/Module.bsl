&НаКлиенте
Перем мТекущаяДатаДокумента Экспорт; // Хранит текущую дату документа - для проверки перехода документа в другой период установки номера

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	мУчетнаяПолитика = УправлениеНастройками.ПолучитьУчетнуюПолитику();
	
	РаботаСФормамиСервер.ФормаДокументаПриОткрытииСервер(ЭтаФорма);	
	
	РаботаСФормамиСервер.НастройкаПодбораПриСоздании(ЭтаФорма, Истина, "Работы", "Услуга", "Набор");
	
	НастройкаПодбораПриСоздании();
	Если Объект.Ссылка.Пустая() Тогда
		Объект.Дата=ТекущаяДата();
	Иначе
		ВебИнтеграция.ПометитьКакПрочитанныйДокумент(Объект.Ссылка);
	КонецЕсли;

	ИсходнаяДата = НачалоДня(Объект.Дата);
	
	ПериодЗаписи.ДатаНачала = Объект.ДатаНачалаПлан;
	ПериодЗаписи.ДатаОкончания = Объект.ДатаОкончанияПлан;
	
	// Заполняем список стандратных периодов
	СтандартныеДаты = мУчетнаяПолитика.ДатыЗаписейЛистовОжидания.Получить();
	СтандартныеПериоды = мУчетнаяПолитика.ПериодыЗаписиЛистовОжидания.Получить();
	Для Каждого Элемент Из СтандартныеДаты Цикл
		Элементы.ДатаЗаписиВыбор.СписокВыбора.Добавить(Элемент.Значение, Элемент.Представление);
	КонецЦикла;	
	Для Каждого Элемент Из СтандартныеПериоды Цикл
		Элементы.ПериодЗаписиВыбор.СписокВыбора.Добавить(Элемент.Значение, Элемент.Представление);
	КонецЦикла;
	
	// Вычисляем текущий стандартный период, если возможно
	ВыбранныеПромежутки = CRMКлиентСервер.ПолучитьСтандартныеПромежуткиПоПериодуЗаписи(ПериодЗаписи, ИсходнаяДата);
	ДатаЗаписиВыбор = ВыбранныеПромежутки.Дата;
	ПериодЗаписиВыбор = ВыбранныеПромежутки.Период;
	
	Если Объект.ИзмененияПериода.Количество() > 0 Тогда 
		Если Не ПустаяСтрока(Объект.ИзмененияПериода[Объект.ИзмененияПериода.Количество() - 1].Комментарий) Тогда 
			КомментарийКПериоду = Объект.ИзмененияПериода[Объект.ИзмененияПериода.Количество() - 1].Комментарий;
			Элементы.КомментарийКПериоду.Видимость = Истина;
		КонецЕсли;
	КонецЕсли;
	
	ТекущийПользователь = ПараметрыСеанса.ТекущийПользователь;
	
	CRMСервер.ЗаполнитьПерепискуПоДокументу(СписокСообщений, Объект.Ссылка, ТекущийПользователь);
	
	УстановитьПривилегированныйРежим(Истина);
	НаборЗаписей = РегистрыСведений.НеотработанныеОбращения.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Документ.Установить(Объект.Ссылка);
	НаборЗаписей.Прочитать();
	Отработан = НаборЗаписей.Количество() = 0;
	УстановитьПривилегированныйРежим(Ложь);
	
	Элементы.Дата.Доступность				= РольДоступна("ПолныеПрава") Или РольДоступна("бит_ПользовательБИТфон");
	Элементы.Отработан.Доступность			= РольДоступна("ПолныеПрава") Или РольДоступна("бит_ПользовательБИТфон");
	Элементы.НазначитьОтработку.Доступность	= РольДоступна("ПолныеПрава") Или РольДоступна("бит_ПользовательБИТфон");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РаботаСФормамиКлиент.ОчиститьЛишниеКомандыПобор(ЭтаФорма);
	ПечатьДокументовКлиент.УстановитьЗаголовокПечатнойФормы(ЭтаФорма);
	
	Если Объект.Ссылка.Пустая()
		И Не ЗначениеЗаполнено(Объект.ДатаНачалаПлан)
	Тогда
		УстановитьДатыЗаписиПоУмолчанию();
		ПереключательПриИзменении(Неопределено);
	КонецЕсли;
	
	ОбновитьВыпадающийСписокСпециализаций();
	
	НастроитьТабличныеЧасти();
	Если ЗначениеЗаполнено(Объект.Клиент) Тогда
		ОбновитьТаблицуЛистовОжидания();
	КонецЕсли;
	НастроитьВидимостьДоступность();
	
	ОбновитьОтображениеДанных();
			
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(Объект.Сотрудник) И ЗначениеЗаполнено(Объект.ПричинаЗаписи) Тогда 
		ПересекающиесяЛисты = CRMСервер.ПолучитьПересекающиесяЛистыОжидания(Объект.Клиент, Объект.Сотрудник, Объект.ПричинаЗаписи, Объект.ДатаНачалаПлан, Объект.ДатаОкончанияПлан, Объект.Ссылка);
		Если ПересекающиесяЛисты.Количество() > 0 Тогда
			
			СтрокаСообщение = НСтр("ru='Есть пересекающиеся по периоду листы ожидания с данным сотрудником и причиной записи. Все равно записать?'");
			Для Каждого ЭлементСписка Из ПересекающиесяЛисты Цикл
				СтрокаСообщение = СтрокаСообщение + Символы.ПС + ЭлементСписка.Представление;
			КонецЦикла;
			
			Если Вопрос(СтрокаСообщение, РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда 
				Отказ = Истина;
				Возврат;
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Не Объект.Ссылка.Пустая() И 
		(Объект.Ссылка.ДатаНачалаПлан <> ПериодЗаписи.ДатаНачала Или
		Объект.Ссылка.ДатаОкончанияПлан <> НачалоДня(ПериодЗаписи.ДатаОкончания)) 
	Тогда
	
		Если Объект.Ссылка.ИзмененияПериода.Количество() = 0 Тогда // Добавляем строку исходного времени для истории
			НоваяСтрока = ТекущийОбъект.ИзмененияПериода.Добавить();
			НоваяСтрока.ДатаНачала = Объект.Ссылка.ДатаНачалаПлан;
			НоваяСтрока.ДатаОкончания = Объект.Ссылка.ДатаОкончанияПлан;
			НоваяСтрока.Комментарий = НСтр("ru='Исходный период записи'");
		КонецЕсли;
	
		НоваяСтрока = ТекущийОбъект.ИзмененияПериода.Добавить();
		НоваяСтрока.ДатаИзменения = ТекущаяДата();
		НоваяСтрока.ДатаНачала = ТекущийОбъект.ДатаНачалаПлан;
		НоваяСтрока.ДатаОкончания = ТекущийОбъект.ДатаОкончанияПлан;
		НоваяСтрока.Комментарий = КомментарийКПериоду;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	РаботаСФормамиСервер.ВывестиЗаголовокФормыДокумента(Объект, Истина, ЭтаФорма);
	Если ЗначениеЗаполнено(Объект.ДокументВыполнения) Тогда
		ЗаписатьЗаявкуДляВыбранныхЛистовИзТаблицы();	
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ПостановкаНаОчередьИзменение");
	
	НастроитьТабличныеЧасти();
	НастроитьВидимостьДоступность();
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗаявкаИзменение"
		И Не ЭтаФорма.Модифицированность
		И Не Объект.Ссылка.Пустая()
	Тогда
	
		ЭтаФорма.Прочитать();
		
	ИначеЕсли ИмяСобытия = "ЗаявкаПоДокументуЗапись"
		И Параметр.ДокументЗаписи = Объект.Ссылка 
		И Не Объект.Ссылка.Пустая()
	Тогда
		Если Объект.ДокументВыполнения <> Параметр.Заявка Тогда
			Объект.ДокументВыполнения = Параметр.Заявка;
			Объект.Выполнен = Истина;
			ЭтаФорма.Модифицированность = Истина;
			ЗаписатьЗаявкуДляВыбранныхЛистовИзТаблицы();
		КонецЕсли;
				
	ИначеЕсли ИмяСобытия = "НовоеСообщениеПоЛО" Тогда 
		
		Если Параметр.Документ = Объект.Ссылка Тогда 
			CRMКлиентСервер.ДобавитьСообщениеВДокумент(СписокСообщений, Параметр.Сообщение, Параметр.Период, Параметр.Пользователь, ТекущийПользователь);
		КонецЕсли;
				
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)
	РаботаСФормамиКлиент.КнопкаПодборПриНажатии(ЭтаФорма, "Работы");
КонецПроцедуры

&НаКлиенте
Процедура ПоискКлиентов(Команда)
	ОткрытьФорму("ОбщаяФорма.ФормаПоискаКлиентаУпр",,ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура КлиентАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	РаботаСФормамиКлиент.ПолеВводаКлиентаАвтоПодбор(Текст, СтандартнаяОбработка, ДанныеВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура КлиентОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСФормамиКлиент.ПолеВводаКлиентаАвтоПодбор(Текст, СтандартнаяОбработка, ДанныеВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	МассивРаботников = ПолучитьМассивРаботников();
	Элементы.Сотрудник.СписокВыбора.ЗагрузитьЗначения(МассивРаботников);
КонецПроцедуры

&НаСервере
Функция ПолучитьМассивРаботников()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ГрафикиСотрудников.Сотрудник КАК Ссылка
	               |ИЗ
	               |	РегистрСведений.ГрафикиРаботы КАК ГрафикиСотрудников
	               |ГДЕ
	               |	ГрафикиСотрудников.Дата = &ДатаНач
	               |	И ГрафикиСотрудников.Сотрудник <> ЗНАЧЕНИЕ(Справочник.Сотрудники.ПустаяСсылка)
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ГрафикиСотрудников.Сотрудник";
	
	Запрос.УстановитьПараметр("ДатаНач", НачалоДня(Объект.ДатаНачала));
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выгрузить().ВыгрузитьКолонку("Ссылка");
	Возврат Выборка;
КонецФункции

&НаКлиенте
Процедура РаботыРаботаПриИзменении(Элемент)
	ОбработкаВыбора(Элемент.Родитель.ТекущиеДанные.Номенклатура, Неопределено, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора, РучноеРедактирование = Ложь)
	
	Результат = "";
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Клиенты") Тогда
		Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
			Объект.Клиент = ВыбранноеЗначение;
		КонецЕсли;
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		Результат = ОбработкаВводаНоменклатуры(ВыбранноеЗначение.Номенклатура, ВыбранноеЗначение.Количество);
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Номенклатура") Тогда
		ТекущиеДанные = Элементы.Работы.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда
			СтрокаТабличнойЧасти = ТекущиеДанные.НомерСтроки-1;
			ПозицияВводаСтроки = СтрокаТабличнойЧасти;
			Если РаботаСФормамиСервер.ЭтоНабор(Элементы.Работы.ТекущиеДанные.Номенклатура) Тогда
				Объект.Работы.Удалить(ПозицияВводаСтроки);
			КонецЕсли;
		Иначе
			ПозицияВводаСтроки = Объект.Работы.Количество()-1;
		КонецЕсли;
		Результат = ОбработкаВводаНоменклатуры(ВыбранноеЗначение,,,ПозицияВводаСтроки,, РучноеРедактирование);
	КонецЕсли;
	
	Если Не ПустаяСтрока(Результат) Тогда 
		Предупреждение(Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОбработкаВводаНоменклатуры(Номенклатура, Количество = 1, Цена = Неопределено, ПозицияВводаСтроки = Неопределено, пСотрудник = Неопределено, РучноеРедактирование = Ложь) 
	
	Если Номенклатура.ЭтоГруппа Тогда
		Возврат "";
	КонецЕсли;
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");	
	Если Номенклатура.Пустая() Или Номенклатура.ВидНоменклатуры = Перечисления.ВидыНоменклатуры.Услуга Тогда
		ОбработкаВнесенияРаботы(Номенклатура, Количество, Цена, ПозицияВводаСтроки, пСотрудник,ДокументОбъект, РучноеРедактирование);
	ИначеЕсли Номенклатура.ВидНоменклатуры = Перечисления.ВидыНоменклатуры.Набор Тогда
		СоставНабора = ОбщегоНазначенияСервер.ПолучитьСоставНабора(Номенклатура);
		Для Каждого СтрокаСостава Из СоставНабора Цикл
			ОбработкаВнесенияРаботы(СтрокаСостава.Комплектующая, СтрокаСостава.Количество*Количество, , ПозицияВводаСтроки, пСотрудник,ДокументОбъект);
			Если ПозицияВводаСтроки <> Неопределено Тогда
				ПозицияВводаСтроки = ПозицияВводаСтроки + 1;
			КонецЕсли;
		КонецЦикла;
	Иначе
		ЗначениеВРеквизитФормы(ДокументОбъект,"Объект");
		Возврат Строка(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Номенклатура %1 не является работой. Допускается только подбор работ.'"),Строка(Номенклатура)));
	КонецЕсли; 
	ЗначениеВРеквизитФормы(ДокументОбъект,"Объект");
	
	Возврат "";
	
КонецФункции

&НаСервере
Процедура ОбработкаВнесенияРаботы (Номенклатура, Количество, Цена = Неопределено, ПозицияВводаСтроки, пСотрудник,ДокументОбъект, РучноеРедактирование = Ложь)
	
	Если Цена = Неопределено Тогда 
		Цена = 0;
	КонецЕсли;
	
	Если Количество = 0 Тогда
		Количество = 1;
	КонецЕсли;
	
	Если ПозицияВводаСтроки <> Неопределено
		И ПозицияВводаСтроки < (ДокументОбъект.Работы.Количество() - 1)
	Тогда
		СтрокаРаботы = ДокументОбъект.Работы[ПозицияВводаСтроки];
	Иначе
		СтруктураПоиска = Новый Структура("Номенклатура", Номенклатура);
		Если ЗначениеЗаполнено(пСотрудник) Тогда
			СтруктураПоиска.Вставить("Сотрудник", пСотрудник);
		КонецЕсли;
		
		СуществующиеСтрокиРабот = ДокументОбъект.Работы.НайтиСтроки(СтруктураПоиска);
		Если СуществующиеСтрокиРабот.Количество() > 0 Тогда
			СтрокаРаботы = СуществующиеСтрокиРабот[СуществующиеСтрокиРабот.Количество() - 1];
		Иначе
			СтрокаРаботы = ДокументОбъект.Работы.Добавить();
		КонецЕсли;
		
	КонецЕсли;
	ИнкрементацияНоменклатуры = Не РучноеРедактирование И (СтрокаРаботы.Номенклатура = Номенклатура);
	СтрокаРаботы.Номенклатура = Номенклатура;
	
	Если	ЗначениеЗаполнено(пСотрудник) И
		Не  ЗначениеЗаполнено(СтрокаРаботы.Сотрудник)
	Тогда
		СтрокаРаботы.Сотрудник = пСотрудник;
	КонецЕсли;
	
	// Установка продолжительности по норме
	Если ЗначениеЗаполнено(СтрокаРаботы.Номенклатура) Тогда
		СтрокаРаботы.Продолжительность	= Дата(1,1,1)
										+ (СтрокаРаботы.Номенклатура.ПродолжительностьЧас*60*60
										+  СтрокаРаботы.Номенклатура.ПродолжительностьМин*60)
										* Количество
										+ ?(ИнкрементацияНоменклатуры, ОбщегоНазначения.ВремяВСекунды(СтрокаРаботы.Продолжительность), 0);
	КонецЕсли;
	
	ЭтаФорма.Элементы.Работы.ТекущаяСтрока = СтрокаРаботы.НомерСтроки-1;
	
	
КонецПроцедуры

&НаКлиенте
Процедура РаботыДатаНачалаПриИзменении(Элемент)
	ЧасыВд=Час(Элементы.Работы.ТекущиеДанные.ДатаНачала)*3600;
	МинутыВд=Минута(Элементы.Работы.ТекущиеДанные.ДатаНачала)*60;
	СекундыВд=Секунда(Элементы.Работы.ТекущиеДанные.ДатаНачала);
	
	Элементы.Работы.ТекущиеДанные.ДатаОкончания=Элементы.Работы.ТекущиеДанные.Продолжительность+(ЧасыВд+МинутыВд+СекундыВд);

КонецПроцедуры

&НаСервере
Процедура НастройкаПодбораПриСоздании()
	//РаботаСФормамиСервер.ПодборСервер(ЭтаФорма);
	Элементы.РаботыПодбор.Пометка = Ложь;
	Элементы.ГруппаПодбор.Видимость=Ложь;	
КонецПроцедуры	

&НаКлиенте
Процедура Подключаемый_ВыборПодбор(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОбработкаВводаНоменклатуры(ВыбранноеЗначение, 1);
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПрейскурантПодборПриИзменении(Элемент)
	РаботаСФормамиКлиент.УстановитьПараметрПрейскурантПодбора(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ЖелаемоеВремяНачалоПриИзменении(Элемент)
	ИтогоСекунд=0;
	Если объект.Работы.Количество()=0 Тогда
		возврат;
	КонецЕсли;
	
	Для каждого ст Из Объект.Работы Цикл
	ЧасыВд=Час(ст.Продолжительность)*3600;
	МинутыВд=Минута(ст.Продолжительность)*60;
	СекундыВд=Секунда(ст.Продолжительность);
	ИтогоСекунд=(ЧасыВд+МинутыВд+СекундыВд);	
	КонецЦикла;
	
	Элементы.ЖелаемоеВремя.ТекущиеДанные.Окончание=Элементы.ЖелаемоеВремя.ТекущиеДанные.Начало+ИтогоСекунд;

КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗаявкуПоОчереди(Команда)
	
	Если РаботаСДиалогамиКлиент.ПроверитьМодифицированностьВФорме(ЭтаФорма) Тогда
		
		СообщениеОбОшибке = "";
		ПараметрыЗаписи = УправлениеЗаявками.ПолучитьПараметрыЗаписиПоЛистуОжидания(Объект.Ссылка, СообщениеОбОшибке);
		Если ЗначениеЗаполнено(СообщениеОбОшибке) Тогда
			ПоказатьПредупреждение(,СообщениеОбОшибке);
			Возврат;
		КонецЕсли;
		
		СписокЛистовОжидания = Новый Массив;
		Для Каждого СтрокаЛО Из ТаблицаЛистовОжидания Цикл
			Если СтрокаЛО.Выбран Тогда
				СписокЛистовОжидания.Добавить(СтрокаЛО.Ссылка);
			КонецЕсли
		КонецЦикла;
		
		Если СписокЛистовОжидания.Количество() > 0 Тогда
			ПараметрыЗаписи.Вставить("СопутствующиеЛистыОжидания", СписокЛистовОжидания);
		КонецЕсли;
		
		КалендарьПланированияКлиент.ОткрытьАктивизироватьКалендарьПланирования();
		Оповестить("НамерениеЗаписиПоДокументу", ПараметрыЗаписи, ПараметрыЗаписи.ДокументЗаписи);
	КонецЕсли;

КонецПроцедуры

#Область ОбработчикиДинамическиСоздаваемыхКоманд

&НаКлиенте
Процедура Подключаемый_КнопкаФилиалПриНажатии(Команда)
	РаботаСДиалогамиКлиент.ДиалогКнопкаФилиалПриНажатии(ЭтаФорма);
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура НастроитьТабличныеЧасти()
	
	РаботаСФормамиКлиент.УстановитьОтборСписка("Клиент",		 Объект.Клиент, ЗаявкиВПериоде);  
	РаботаСФормамиКлиент.УстановитьОтборСписка("ДатаНачала",	 ПериодЗаписи.ДатаНачала,	 ЗаявкиВПериоде, ВидСравненияКомпоновкиДанных.БольшеИлиРавно); 
	РаботаСФормамиКлиент.УстановитьОтборСписка("ДатаОкончания",	 ПериодЗаписи.ДатаОкончания, ЗаявкиВПериоде, ВидСравненияКомпоновкиДанных.МеньшеИлиРавно);
	
	РаботаСФормамиКлиент.УстановитьОтборСписка("Основание", Объект.Ссылка, СобытияПоЛистуОжидания); 
	Элементы.ЗаявкиВПериоде.Обновить(); 
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьТаблицуЛистовОжидания()
	
	ТаблицаЛистовОжидания.Очистить();
	
	АктуальнаяТаблица = ПолучитьТаблицуЛистовОжидания(Объект.Клиент, ПериодЗаписи, Объект.Ссылка);
	Для Каждого СтрокаЛистОжидания Из АктуальнаяТаблица Цикл
		ЗаполнитьЗначенияСвойств(ТаблицаЛистовОжидания.Добавить(), СтрокаЛистОжидания);
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьТаблицуЛистовОжидания(Клиент, ПериодЗаписи, ТекущийДокументСсылка)
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЛО.Ссылка КАК Ссылка,
	               |	ЛО.Специализация КАК Специализация,
	               |	ЛО.Сотрудник КАК Сотрудник,
	               |	ЛО.ДатаНачалаПлан КАК ДатаНачалаПлан,
	               |	ЛО.ДатаОкончанияПлан КАК ДатаОкончанияПлан,
	               |	ЛО.ПричинаЗаписи КАК ПричинаЗаписи,
	               |	ВЫБОР
	               |		КОГДА ЛО.ДатаНачалаПлан <= &ДатаНачала
	               |					И ЛО.ДатаОкончанияПлан >= &ДатаОкончания
	               |				ИЛИ ЛО.ДатаНачалаПлан >= &ДатаНачала
	               |					И ЛО.ДатаНачалаПлан <= &ДатаОкончания
	               |			ТОГДА ИСТИНА
	               |		ИНАЧЕ ЛОЖЬ
	               |	КОНЕЦ КАК ЕстьПересечение,
	               |	ЛО.Выполнен КАК Выполнен
	               |ИЗ
	               |	Документ.ЛистОжидания КАК ЛО
	               |ГДЕ
	               |	ЛО.Клиент.Ссылка = &Клиент
	               |	И ЛО.Выполнен = ЛОЖЬ
	               |	И НЕ ЛО.ПометкаУдаления
	               |	И (ЛО.ДатаОкончанияПлан >= &ТекущаяДата
	               |			ИЛИ ЛО.ДатаОкончанияПлан = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0))
	               |	И ЛО.Ссылка <> &Ссылка";
	
	Запрос.УстановитьПараметр("ТекущаяДата",НачалоДня(ТекущаяДата()));
	Запрос.УстановитьПараметр("Клиент",Клиент);
	Запрос.УстановитьПараметр("ДатаНачала",ПериодЗаписи.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания",ПериодЗаписи.ДатаОкончания);
	Запрос.УстановитьПараметр("Ссылка",ТекущийДокументСсылка);
	
	Возврат ОбщегоНазначения.ТаблицаЗначенийВМассив(Запрос.Выполнить().Выгрузить());
	
КонецФункции

&НаКлиенте
Процедура НастроитьВидимостьДоступность()
	
	Элементы.Основание.ТолькоПросмотр = (Не Объект.Ссылка.Пустая() И ЗначениеЗаполнено(Объект.Основание));
	Элементы.Отработан.Видимость = Не Отработан;
	Элементы.НазначитьОтработку.Видимость = Отработан И ЗначениеЗаполнено(Объект.ИсточникИнформации);
	Элементы.Обращение.Заголовок = ?(ЗначениеЗаполнено(Объект.ИсточникИнформации), "Обращение (" + Строка(Объект.ИсточникИнформации) + ")", "Обращение");
	
КонецПроцедуры

&НаКлиенте
Процедура КлиентПриИзменении(Элемент)
	
	Объект.Основание = Неопределено;
	НастроитьТабличныеЧасти();
	Если ЗначениеЗаполнено(Объект.Клиент) Тогда
		ОбновитьТаблицуЛистовОжидания();
	КонецЕсли;
	НастроитьВидимостьДоступность();
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодЗаписиПриИзменении(Элемент, ВычислятьПромежутки = Истина)
	
	НастроитьТабличныеЧасти();
	Если ЗначениеЗаполнено(Объект.Клиент) Тогда
		ОбновитьТаблицуЛистовОжидания();
	КонецЕсли;
	
	Объект.ДатаНачалаПлан = ПериодЗаписи.ДатаНачала;
	Объект.ДатаОкончанияПлан = ПериодЗаписи.ДатаОкончания;
	
	Если ВычислятьПромежутки Тогда 
		ВыбранныеПромежутки = CRMКлиентСервер.ПолучитьСтандартныеПромежуткиПоПериодуЗаписи(ПериодЗаписи, ИсходнаяДата);
		ДатаЗаписиВыбор = ВыбранныеПромежутки.Дата;
		ПериодЗаписиВыбор = ВыбранныеПромежутки.Период;
	КонецЕсли;
	
	Если Элементы.КомментарийКПериоду.ТолькоПросмотр И Не Объект.Ссылка.Пустая() Тогда 
		Элементы.КомментарийКПериоду.ТолькоПросмотр = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументВыполненияПриИзменении(Элемент)
	
	Объект.Выполнен = ЗначениеЗаполнено(Объект.ДокументВыполнения); 
	НастроитьТабличныеЧасти();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСообщение(Команда)
	
	ТекущееСообщение = СокрЛП(ТекущееСообщение);
	Если ПустаяСтрока(ТекущееСообщение) Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не РаботаСДиалогамиКлиент.ЗаписатьНовыйОбъектВФорме(ЭтаФорма) Тогда 
		Возврат;
	КонецЕсли;
	
	ТекДата = ТекущаяДата();
	СтруктураОповещения = CRMСервер.ДобавитьСообщениеПоЛистуОжидания(Объект.Ссылка, ТекущееСообщение);
	
	Оповестить("НовоеСообщениеПоЛО", СтруктураОповещения, Объект.Ссылка);
	
	ТекущееСообщение = "";
	
	ЭтаФорма.ТекущийЭлемент = Элементы.ТекущееСообщение;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаявкиВПериодеПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	СоздатьЗаявкуПоОчереди(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключательПриИзменении(Элемент)
	
	Если ДатаЗаписиВыбор = "" Тогда 
		ДатаЗаписиВыбор = Элементы.ДатаЗаписиВыбор.СписокВыбора[0];
	КонецЕсли;
	Если ПериодЗаписиВыбор = "" Тогда 
		ПериодЗаписиВыбор = Элементы.ПериодЗаписиВыбор.СписокВыбора[0];
	КонецЕсли;
	
	ПериодЗаписи = CRMКлиентСервер.СформироватьДатуПериодЗаписи(ДатаЗаписиВыбор, ПериодЗаписиВыбор, ИсходнаяДата); 
	ПериодЗаписиПриИзменении(Неопределено, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДатыЗаписиПоУмолчанию()
	
	// Получаем дату записи по причине записи
	ДатаПериодЗаписи = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(Объект.ПричинаЗаписи, "ДатаЗаписиПоУмолчанию, ПериодЗаписиПоУмолчанию");
	Если ЗначениеЗаполнено(Объект.ПричинаЗаписи) Тогда
		ЭлементВыбора = Элементы.ДатаЗаписиВыбор.СписокВыбора.НайтиПоЗначению(ДатаПериодЗаписи.ДатаЗаписиПоУмолчанию);
		Если ЭлементВыбора <> Неопределено Тогда 
			ДатаЗаписиВыбор = ЭлементВыбора.Значение;
		КонецЕсли;
		ЭлементВыбора = Элементы.ПериодЗаписиВыбор.СписокВыбора.НайтиПоЗначению(ДатаПериодЗаписи.ПериодЗаписиПоУмолчанию);
		Если ЭлементВыбора <> Неопределено Тогда 
			ПериодЗаписиВыбор = ЭлементВыбора.Значение;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПричинаЗаписиПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.ПричинаЗаписи) Тогда
		УстановитьДатыЗаписиПоУмолчанию();
		ПереключательПриИзменении(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВыпадающийСписокСпециализаций()
	
	МассивСпециализаций = ПроцедурыСпециализацииПоставки.ПолучитьМассивСпециализацийСотрудника(Объект.Сотрудник);
	Если МассивСпециализаций.Количество() > 0 Тогда
		Элементы.Специализация.СписокВыбора.ЗагрузитьЗначения(МассивСпециализаций);
		Элементы.Специализация.ОтображениеКнопкиВыбора = ОтображениеКнопкиВыбора.ОтображатьВВыпадающемСпискеИВПолеВвода;
		Элементы.Специализация.КнопкаВыпадающегоСписка = Истина;
	Иначе
		Элементы.Специализация.СписокВыбора.Очистить();
		Элементы.Специализация.ОтображениеКнопкиВыбора = ОтображениеКнопкиВыбора.ОтображатьВПолеВвода;
		Элементы.Специализация.КнопкаВыпадающегоСписка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	
	ОбновитьВыпадающийСписокСпециализаций();
	Если Элементы.Специализация.СписокВыбора.Количество() > 0 Тогда 
		ЭлементВыбора = Элементы.Специализация.СписокВыбора.НайтиПоЗначению(Объект.Специализация); 
		Если ЭлементВыбора <> Неопределено Тогда 
			Объект.Специализация = ЭлементВыбора.Значение;
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЛистовОжиданияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ПоказатьЗначение(,Элемент.ТекущиеДанные.Ссылка);	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьЗаявкуДляВыбранныхЛистовИзТаблицы()
	
	Для каждого СтрокаЛиста Из ТаблицаЛистовОжидания Цикл
		Если СтрокаЛиста.Выбран Тогда
			Если Не ЗначениеЗаполнено(СтрокаЛиста.Ссылка.ДокументВыполнения) Тогда
				ОбъектЛистаОжидания = СтрокаЛиста.Ссылка.ПолучитьОбъект();
				ОбъектЛистаОжидания.ДокументВыполнения = Объект.ДокументВыполнения.Ссылка;
				ОбъектЛистаОжидания.Выполнен = Истина;
				ОбъектЛистаОжидания.Записать();		
			КонецЕсли
		КонецЕсли; 	
	КонецЦикла; 	
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьРазговор(Команда)
	
	Если Не РаботаСДиалогамиКлиент.ЗаписатьНовыйОбъектВФорме(ЭтаФорма) Тогда 
		Возврат;
	КонецЕсли;
	
	ТекстСообщения = НСтр("ru='Нет данных для совершения звонка. Не заполнен клиент или не указан контактный телефон!'");
	Если Не ЗначениеЗаполнено(Объект.Клиент) Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	НомерТелефона = КонтактнаяИнформацияСерверПереопределяемый.НайтиКонтактнуюИнформацию(Объект.Клиент,,,,Ложь);;
	Если Не ЗначениеЗаполнено(НомерТелефона) Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Если Команда.Имя = "НачатьРазговор" Тогда
		бит_ТелефонияКлиентПереопределяемый.Позвонить(НомерТелефона, , Объект.Ссылка);
	Иначе
		бит_ТелефонияКлиентПереопределяемый.ПозвонитьМонитор(НомерТелефона, , Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отработан(Команда)
	УдалитьИзНеобработанных(Объект.Ссылка);
	Элементы.Отработан.Доступность = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура НазначитьОтработку(Команда)
	ДобавитьВНеобработанные(Объект.Ссылка);
	Элементы.НазначитьОтработку.Доступность = Ложь;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УдалитьИзНеобработанных(Документ)
	
	НаборЗаписей = РегистрыСведений.НеотработанныеОбращения.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Документ.Установить(Документ);
	НаборЗаписей.Записать();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ДобавитьВНеобработанные(Документ)
	
	Запись = РегистрыСведений.НеотработанныеОбращения.СоздатьМенеджерЗаписи();
	Запись.Документ = Документ;
	Запись.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура UTM_SOURCEПриИзменении(Элемент)
	НастроитьВидимостьДоступность();
КонецПроцедуры
