
#Область РазделОписанияПеременныхФормы

&НаКлиенте
Перем соотвКешИзображенийШаблонов;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Параметры.Клиент) Тогда 
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ШаблонАнамнезаЖизни = УправлениеНастройками.ПолучитьПараметрУчетнойПолитики("ШаблонАнамнезаЖизни");
	Если Не ЗначениеЗаполнено(ШаблонАнамнезаЖизни) Или ШаблонАнамнезаЖизни.ВидШаблона <> Перечисления.ВидыШаблонов.HTMLШаблон Тогда 
		Отказ = Истина;
		Возврат
	КонецЕсли;
	
	Клиент = Параметры.Клиент;
	
	РаботаСФормамиКлиентСервер.УстановитьПолеЭлементаФормы(Элементы, "ОткрытьЛекарственнуюНепереносимость", "Заголовок", МедицинскаяДеятельность.ЗаголовокКнопкиОткрытьЛекарственнуюНепереносимость(Клиент));
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МассивШаблонов = Новый Массив;
	МассивШаблонов.Добавить(ШаблонАнамнезаЖизни);
	РаботаСШаблонамиHTMLКлиентСервер.ИнициализироватьНастройкиИзображенийПриема(соотвКешИзображенийШаблонов, МассивШаблонов, УникальныйИдентификатор);
	
	ИнициализироватьШаблонАнамнеза();
	ПреобразоватьОсмотрВВерсиюДляРедактирования();
	
	Объект = ПолучитьСтруктуруОбъекта(Клиент);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЛекарственнаяНепереносимостьИзменение" Тогда
		Если Параметр = Клиент Тогда
			РаботаСФормамиКлиентСервер.УстановитьПолеЭлементаФормы(Элементы, "ОткрытьЛекарственнуюНепереносимость", "Заголовок", МедицинскаяДеятельность.ЗаголовокКнопкиОткрытьЛекарственнуюНепереносимость(Клиент));
			ПреобразоватьОсмотрВВерсиюДляРедактирования();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗаписатьЗакрыть(Команда)
	
	ПеренестиЗначенияТекстовыхПолейОсмотраВТаблицуПараметров();
	
	РаботаСШаблонамиHTML.ВыгрузитьТаблицуПараметров(Клиент, ТаблицаПараметров, , , Истина);
	
	МодульРаботыСШаблонами = РаботаСШаблонамиHTMLКлиентСервер;
	#Если ВебКлиент Или МобильныйКлиент Тогда
		МодульРаботыСШаблонами = РаботаСШаблонамиHTML;
	#КонецЕсли
	
	ТекстШаблона = ОбщегоНазначения.ПолучитьЗначениеРеквизита(ШаблонАнамнезаЖизни, "ТекстHTML");
	ДанныеШаблона = Новый Структура("Шаблон, ИдентификаторСтрокиШаблона, ТекстШаблона", ШаблонАнамнезаЖизни, 0, ТекстШаблона);
	ДанныеСформированногоШаблона = МодульРаботыСШаблонами.СформироватьВерсиюДляПечатиШаблонаОсмотра(Объект, ДанныеШаблона, 
		ТаблицаПараметров);
	СохранитьПредставлениеАнамнеза(Клиент, ДанныеСформированногоШаблона.ТекстШаблонаПолный);
	
	ЭтаФорма.Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаполнитьПоУмолчанию(Команда)
	
	ПеренестиЗначенияТекстовыхПолейОсмотраВТаблицуПараметров();
	
	ЗначенияПоУмолчанию = РаботаСШаблонамиHTML.ПолучитьЗначенияПараметровПоУмолчанию(ТаблицаПараметров, КешЗависимыхПараметров, Объект);
	РаботаСШаблонамиHTMLКлиентСервер.ОбновитьЗначенияТаблицыПараметров(ТаблицаПараметров, ЗначенияПоУмолчанию);
	
	ПреобразоватьОсмотрВВерсиюДляРедактирования();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОчистить(Команда)
	
	ИнициализироватьШаблонАнамнеза();
	ПреобразоватьОсмотрВВерсиюДляРедактирования();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПолеHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
		
	ЭлементHTML = РаботаСШаблонамиHTMLКлиентСервер.НайтиЭлементСЗаполненнымIDВышеПоИерархии(ДанныеСобытия.Element);
	Если ЭлементHTML = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Чтобы не срабатывал переход по ссылке
	Если ВРег(ДанныеСобытия.Element.TagName) = "A" Или ВРег(ЭлементHTML.TagName) = "A" Тогда 
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
	ТегЭлемента = ВРег(ЭлементHTML.TagName);
		
	мсСтрокаПараметра = ТаблицаПараметров.НайтиСтроки(Новый Структура("СтрокаУидПараметра", ЭлементHTML.id));
	Если мсСтрокаПараметра.Количество() > 0 Тогда
		
		СтрокаПараметра = мсСтрокаПараметра[0];
		РаботаСШаблонамиHTMLКлиент.ВыбратьЗначениеПараметраHTMLИнтерактивно(ЭтаФорма, Элемент.Имя, ЭлементHTML, СтрокаПараметра, КешЗначенийВыбора);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИнициализироватьШаблонАнамнеза()
	
	ЗагрузитьТаблицуПараметров();			
	КешЗначенийВыбора = Новый ФиксированноеСоответствие(РаботаСШаблонамиHTML.ПолучитьКешЗначенийВыбора(ШаблонАнамнезаЖизни));
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьСтруктуруОбъекта(Клиент)
	
	СтруктураОбъекта = Новый Структура("Клиент, Ссылка, Врач, Дата, ШаблоныПриема", 
		Клиент, 
		ПредопределенноеЗначение("Документ.Прием.ПустаяСсылка"), 
		ПредопределенноеЗначение("Справочник.Сотрудники.ПустаяСсылка"), 
		ТекущаяДата(), 
		Новый Массив);
		
	Возврат СтруктураОбъекта;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьТаблицуПараметров()
	
	ТаблицаПараметров.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ШаблоныHTMLСоответствияПараметрам.Ссылка КАК Шаблон,
	|	ШаблоныHTMLСоответствияПараметрам.Параметр
	|ПОМЕСТИТЬ ПараметрыШаблона
	|ИЗ
	|	Справочник.ШаблоныHTML.СоответствияПараметрам КАК ШаблоныHTMLСоответствияПараметрам
	|ГДЕ
	|	ШаблоныHTMLСоответствияПараметрам.Ссылка = &Шаблон
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПараметрыШаблона.Шаблон,
	|	ПараметрыШаблона.Параметр,
	|	АнамнезыЖизниСрезПоследних.Значение,
	|	НЕ АнамнезыЖизниСрезПоследних.Значение ЕСТЬ NULL КАК ЕстьЗначение
	|ИЗ
	|	ПараметрыШаблона КАК ПараметрыШаблона
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АнамнезыЖизни.СрезПоследних(, Клиент = &Клиент) КАК АнамнезыЖизниСрезПоследних
	|		ПО ПараметрыШаблона.Параметр = АнамнезыЖизниСрезПоследних.Параметр
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПараметрыШаблона.Параметр КАК ЗависимыйПараметр,
	|	ВычисляемыеЗначенияПараметровСписокПеременных.Параметр КАК Параметр
	|ИЗ
	|	ПараметрыШаблона КАК ПараметрыШаблона
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВычисляемыеЗначенияПараметров.СписокПеременных КАК ВычисляемыеЗначенияПараметровСписокПеременных
	|		ПО (ПараметрыШаблона.Параметр.ИспользуетсяВычисляемоеЗначение)
	|			И ПараметрыШаблона.Параметр.ЗначениеПоУмолчанию = ВычисляемыеЗначенияПараметровСписокПеременных.Ссылка";
	Запрос.УстановитьПараметр("Клиент", Клиент);
	Запрос.УстановитьПараметр("Шаблон", ШаблонАнамнезаЖизни);
	
	Результат = Запрос.ВыполнитьПакет();
	Выборка = Результат[1].Выбрать();	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = ТаблицаПараметров.Добавить();
		НоваяСтрока.Параметр      = Выборка.Параметр;
		НоваяСтрока.СтрокаУидПараметра = Строка(НоваяСтрока.Параметр.УникальныйИдентификатор());
		НоваяСтрока.ИдентификаторСтрокиШаблона = 0;
		НоваяСтрока.НеРедактируетсяПользователем = НоваяСтрока.Параметр.НеРедактируетсяПользователем;
		НоваяСтрока.ТипЗначения = НоваяСтрока.Параметр.ТипЗначения;
		НоваяСтрока.ФорматнаяСтрока = НоваяСтрока.Параметр.ФорматнаяСтрока; 
		
		Если Выборка.ЕстьЗначение Тогда 
			Если ТипЗнч(Выборка.Значение) = Тип("СправочникСсылка.СтрокиЭМКНеограниченнойДлины") Тогда
				НоваяСтрока.Значение = Выборка.Значение.Значение;
			Иначе
				НоваяСтрока.Значение = Выборка.Значение;
			КонецЕсли;
		Иначе
			НоваяСтрока.Значение = НоваяСтрока.Параметр.ТипЗначения.ПривестиЗначение(Неопределено);
		КонецЕсли;
		НоваяСтрока.Представление = РаботаСШаблонамиHTMLКлиентСервер.ПолучитьПредставлениеПараметра(НоваяСтрока);
		                                               
	КонецЦикла;
	
	КешЗависимыхПараметров.Загрузить(Результат[2].Выгрузить());

КонецПроцедуры

&НаКлиенте
Процедура ПеренестиЗначенияТекстовыхПолейОсмотраВТаблицуПараметров()
	
	ПолеДокумента = Элементы.ПолеHTML;
	Если ПолеДокумента.Документ = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РаботаСШаблонамиHTMLКлиент.ПеренестиЗначениеАктивногоТекстовогоПоляОсмотраВТаблицуПараметров(ЭтаФорма, Элементы.ПолеHTML);	
		
КонецПроцедуры

&НаКлиенте
Процедура ПреобразоватьОсмотрВВерсиюДляРедактирования()
	
	МодульРаботыСШаблонами = РаботаСШаблонамиHTMLКлиентСервер;
	#Если ВебКлиент Или МобильныйКлиент Тогда
		МодульРаботыСШаблонами = РаботаСШаблонамиHTML;
	#КонецЕсли
	
	ТекстШаблона = ОбщегоНазначения.ПолучитьЗначениеРеквизита(ШаблонАнамнезаЖизни, "ТекстHTML");
	ДанныеШаблона = Новый Структура("Шаблон, ИдентификаторСтрокиШаблона, ТекстШаблона", ШаблонАнамнезаЖизни, 0, ТекстШаблона);
	ДанныеСформированногоШаблона = МодульРаботыСШаблонами.СформироватьВерсиюДляРедактированияШаблонаОсмотра(УникальныйИдентификатор, ДанныеШаблона, ТаблицаПараметров, КешЗначенийВыбора, соотвКешИзображенийШаблонов,);
	
	Объект = ПолучитьСтруктуруОбъекта(Клиент);
	
	ДокументHTML = РаботаСDOMКлиентСервер.СоздатьДокументDOM(ДанныеСформированногоШаблона.ТекстШаблонаПолный);
	
	РаботаСШаблонамиHTMLКлиентСервер.НормализоватьВычисляемыеБлокиHTML(ДокументHTML);
	СписокВычисляемыхБлоков = РаботаСHTMLКлиентСервер.ПолучитьЭлементыПоИмени(ДокументHTML, "tt", Истина);	
	Для Каждого ЭлементБлока Из СписокВычисляемыхБлоков Цикл
		ИдентификаторБлока = РаботаСHTMLКлиентСервер.ПолучитьИдентификаторЭлемента(ЭлементБлока);
		Если Не ЗначениеЗаполнено(ИдентификаторБлока) Тогда 
			Продолжить;
		КонецЕсли;
		Значение = РаботаСШаблонамиHTML.ВычислитьЗначениеБлокаHTML(ИдентификаторБлока, Объект);
		РаботаСHTMLКлиентСервер.ЗаменитьЭлементНаПроизвольныйHTML(ЭлементБлока, Значение);
	КонецЦикла;
	
	ПолеHTML = РаботаСDOMКлиентСервер.ПолучитьТекстHTMLДокументаDOM(ДокументHTML);

	Если ДанныеСформированногоШаблона.ОбновленныеЗначенияПараметров.Количество() > 0 Тогда 
		РаботаСШаблонамиHTMLКлиентСервер.ОбновитьЗначенияТаблицыПараметров(
			ТаблицаПараметров, ДанныеСформированногоШаблона.ОбновленныеЗначенияПараметров, 0);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьПредставлениеАнамнеза(Клиент, ПредставлениеАнамнеза)
	
	КлиентОбъект = Клиент.ПолучитьОбъект();
	КлиентОбъект.ПредставлениеАнамнеза = ПредставлениеАнамнеза;
	КлиентОбъект.Записать();
	
КонецПроцедуры

#КонецОбласти
